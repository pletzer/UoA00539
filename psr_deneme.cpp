#include <mex.h>
#include <matrix.h>

void mexFunction(int nlhs, mxArray *plhs[], 
	             int nrhs, const mxArray *prhs[]) {

	double* x = (double*) mxGetPr(prhs[0]);
	int m = (int) *mxGetPr(prhs[1]);
	int tao = (int) *mxGetPr(prhs[2]);
	int M = (int) *mxGetPr(prhs[3]);

	// creates and initializes to zero
	plhs[0] = mxCreateDoubleMatrix(M, m, mxREAL);
	double* res = mxGetPr(plhs[0]);
	for (int i = 0; i < m; ++i) {
		for (int j = 0; j < M; ++j) {
        	res[j + M*i] = x[j + i*tao];
		}
	}
}

/*
function Y = psr_deneme(x,m,tao,npoint)
%Phase space reconstruction
%x : time series 
%m : embedding dimension
%tao : time delay
%npoint : total number of reconstructed vectors
%Y : M x m matrix
% author:"Merve Kizilkaya"

M = npoint

Y=zeros(M,m); 

for i=1:m
    Y(:,i)=x((1:M)+(i-1)*tao)';
end
*/