#ifndef BAUMWELCH_H
#define BAUMWELCH_H

// DEFAULTS
#define DMIN 0.00000001 // convergence criterion on parameters (from SMACKS)
#define MAXITER 50000 // maximum number of EM iterations


double getMaxDiff(const double* T, const double* T_prev, const double* ip, const double* ip_prev, int J);
int dispProb(double m, double dL, double dmax, const double* T, const double* ip, int J, int nb, const int** id_T);
bool optBW(double* T, double* ip, double *logL, const double* B, const double** seq, int J, int N, int V, double* L);
bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

#endif