#include <mex.h>
#include <matrix.h>
#include <cmath>
#include <limits>

/**
 * [mn, mx] = computeDists(l2, d, vec, dists);
 */

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[]) {

  // input [mn, mx, scales, dists]
  int mn = (int) *mxGetPr(prhs[0]);
  int mx = (int) *mxGetPr(prhs[1]);
  int scales = (int) *mxGetPr(prhs[2]);
  double* dists = (double*) mxGetPr(prhs[3]);

  const mwSize *dims = mxGetDimensions(prhs[3]);
  size_t l2 = (size_t) dims[0];

  // output
  plhs[0]= mxCreateDoubleMatrix(2, scales, mxREAL);
  double* ratio = (double*) mxGetPr(plhs[0]);

  int n = 1;
  double epsilon = std::pow(2.0, -n);
  double mx2 = epsilon * mx;
  while (mx2 > 2*mn && n < scales) {
    size_t count = 0;
    for (size_t i = 0; i < l2; ++i) {
        for (size_t j = 0; j < l2; ++j) {
            if (dists[j + i*l2] < mx2) {
                count++;
            }
        }
    }
    if (count > 0) {
        ratio[0 + (n - 1)*2] = epsilon;
        ratio[1 + (n - 1)*2] = count;
        n++;
    }
    epsilon = std::pow(1.5, -n);
    mx2 = epsilon * mx;
  }
}

