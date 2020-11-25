#ifndef TRAINPH_H
#define TRAINPH_H

// DEFAULTS
#define DMIN 0.00000001 // convergence criterion on parameters (from SMACKS)
#define MAXITER 100000 // maximum number of EM iterations


void optPH(double* T, double* a, double* logL, (const double*) cnts, int J, int nDt);
bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);


#endif