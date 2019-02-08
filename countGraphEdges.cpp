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
    float ya = y[am1];
    for (size_t b = a + 2; b <= ln; ++b) {
      size_t bm1 = b - 1;
      float yb = y[bm1];
      float bma = (float)(b) - (float)(a);
      float coeff = (ya - yb) / bma;
      double fl = 1;
      for (size_t c = a + 1; c <= b - 1; ++c) {
        size_t cm1 = c - 1;
        float bmc = (float)(b) - (float)(c);
        if (y[cm1] >= y[bm1] + coeff * bmc) {
            fl = 0;
            break;
        }
      }
      //add one to the graph edges of length b-a
      P[bm1-a] += fl;
    }
  }

  // choose an interval in P with no zeros
  auto it = std::find(&P[1], &P[ln], 0.0);
  size_t x = std::distance(&P[0], it) + 1;

  // output: [P, x]
  plhs[1] = mxCreateDoubleScalar((double) x);
}
