#include <mex.h>
#include <matrix.h>
#include <cmath>
#include <limits>

/**
 * [P, x] = countGraphEdges(y);
 */

void mexFunction(int nlhs, mxArray *plhs[], 
                 int nrhs, const mxArray *prhs[]) {

  // input: y 
  float* y = (float*) mxGetPr(prhs[0]);
  size_t ln = mxGetNumberOfElements(prhs[0]);

  plhs[0] = mxCreateDoubleMatrix(1, ln, mxREAL);
  double* P = (double*) mxGetPr(plhs[0]);

for (size_t a = 1; a <= ln; ++a) {
    for (size_t b = a+2; b <= ln; ++b) {
         int fl=1;
         for (size_t c = a+1; c <= b-1; ++c) {
            if (y[c-1] >= y[b-1] + (y[a-1] - y[b-1])*(float)(b-c)/((float)(b-a))) {
                fl=0;
                break;
            }
         }
         if (fl) //add one to the graph edges of length b-a
             P[b-a-1] = P[b-a-1] + 1;
    }
}

size_t x;
for (x=2; x <= ln; ++x) { //choose an interval in P with no zeros
  if (P[x-1] == 0)
    break;
}

  // output: [P, x]
  plhs[1] = mxCreateDoubleScalar( (double) x);
}
