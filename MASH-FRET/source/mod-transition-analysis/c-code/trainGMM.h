#ifndef TRAINGMM_H
#define TRAINGMM_H

// DEFAULTS
#define MAXITER 100000 // maximum number of EM iterations

bool getStartGMM(const double* dat, int nTrs, double cnstr, double shape, int V, 
		double* mu, double* w, double* cov);
bool optGMM(const double* dat, int nTrs, double cnstr, double shape, double lklhd, int V, 
		double* mu, double* w, double* cov, double* prob, double* logL);
bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

#endif