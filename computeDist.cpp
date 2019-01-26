#include <mex.h>
#include <matrix.h>
#include <cmath>

void computeDist(int l2, int d, const double* vec, double* dists, int* mnPtr, int* mxPtr) {

  for (int i=1; i <=l2; ++i) {
    for (int j=1; j <=l2; ++j) {
      double sm = 0.;
      for (int k = 1; k <=d; ++k) {
        double dv = vec[k + i*d] - vec[k + j*d];
        sm += dv*dv;
      }
      sm = std::sqrt(sm);
      if (sm > *mxPtr) {
        *mxPtr = sm;
      }
      if (i==1 && j==2) {
        *mnPtr = sm;
      }
      else {
        if ((sm < *mnPtr) && (sm > 0)) {
          *mnPtr = sm;
        }
      }
      if (i==j) {
        dists[i + j*l2] = 1e10;
      }
      else {
        dists[i + j*l2] = sm;
      }
    }
  }
}

/**
 * [dists, mn, mx] = computeDist(l2, d, vec);
 */

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[]) {

  // input
  int l2 = (int) *mxGetPr(prhs[0]);
  int d = (int) *mxGetPr(prhs[1]);
  double* vec = (double*) mxGetPr(prhs[2]);
  mexPrintf("*** in computeDist l2 = %ld d = %ld \n", l2, d);

  // output
  mxArray* dists = mxCreateDoubleMatrix(l2, l2, mxREAL);
  mxArray* mn = mxCreateDoubleScalar(0);
  mxArray* mx = mxCreateDoubleScalar(0);

  // compute
  int* mnPtr = (int*) mxGetPr(mn);
  int* mxPtr = (int*) mxGetPr(mx);
  double* distsPtr = (double*) mxGetPr(dists);
  computeDist(l2, d, vec, distsPtr, mnPtr, mxPtr);

  // associate
  plhs[0] = dists;
  plhs[1] = mn;
  plhs[2] = mx;
}
