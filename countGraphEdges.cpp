#include <mex.h>
#include <matrix.h>
#include <cmath>
#include <algorithm>

/**
 * [P, x] = countGraphEdges(y);
 */

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[]) {

  // input: y (array of floats)
  float* y = (float*) mxGetPr(prhs[0]);
  size_t ln = mxGetNumberOfElements(prhs[0]);

  plhs[0] = mxCreateDoubleMatrix(1, ln, mxREAL);
  double* P = (double*) mxGetPr(plhs[0]);

  for (size_t a = 1; a <= ln; ++a) {
    size_t am1 = a - 1;
    for (size_t b = a + 2; b <= ln; ++b) {
      float bma = (float)(b) - (float)(a);
      size_t bm1 = b - 1;
      bool fl = true;
      for (size_t c = a + 1; c <= b - 1; ++c) {
        size_t cm1 = c - 1;
        float bmc = (float)(b) - (float)(c);
        if (y[cm1] >= y[bm1] + (y[am1] - y[bm1]) * bmc / bma) {
            fl = false;
            break;
        }
      }
      if (fl) //add one to the graph edges of length b-a
        P[b-a-1]++;
    }
  }

  // choose an interval in P with no zeros
  auto it = std::find(&P[1], &P[ln], 0.0);
  size_t x = std::distance(&P[0], it) + 1;

  /*
  mexPrintf("---x = %ld\n", x);


  //size_t x;
  for (x=2; x <= ln; ++x) { //
    if (P[x-1] == 0)
      break;
  }
  mexPrintf("+++x = %ld\n", x);
  */

  // output: [P, x]
  plhs[1] = mxCreateDoubleScalar((double) x);
}
