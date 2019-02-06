#include <mex.h>
#include <matrix.h>
#include <cmath>
#include <limits>

/**
 * [mn, mx] = computeDists(l2, d, vec, dists);
 */

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[]) {

  // [P, x] = countGraphEdges(y)
  double* y = (double*) mxGetPr(prhs[0]);
  size_t ln = mxGetNumberOfElements(prhs[0]);

  plhs[0]= mxCreateDoubleMatrix(1, ln, mxREAL);
  double* P = (double*) mxGetPr(plhs[0]);

  for (size_t a = 1; a <= ln; ++a) {
    size_t am1 = a - 1;
    for (size_t b = a + 2; b <= ln; ++b) {
      size_t bm1 = b - 1;
      bool flg = true;
      for (size_t c = a + 1; c <= b - 1; ++c) {
        size_t cm1 = c - 1;
        if ( y[cm1] >= y[bm1] + (y[am1] - y[bm1])*(b - c)/(b - a) ) {
          flg = false;
          break;
        }
      }
      if (flg) {
        P[b - a]++;
      }
    }
  }

  size_t x;
  // choose an interval in P with no zeros
  for (x = 2; x <= ln; ++x) {
    if (P[x - 1] == 0) {
      break;
    }
  }

  plhs[1] = mxCreateDoubleScalar(x);
}
