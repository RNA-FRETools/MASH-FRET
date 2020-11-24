#ifndef BAUMWELCH_H
#define BAUMWELCH_H

// DEFAULTS
#define DLMIN 0.000001 // convergence criterion on logL
#define DMIN 0.00000001 // convergence criterion on parameters (SMACKS)
#define MAXITER 100000 // maximum number of EM iterations


double getMaxDiff(const double* T, const double* T_prev, const double* ip, const double* ip_prev, int J);
int dispProb(double m, double dL, double dmax, double* T, double* ip, int J, int nb);
void setVect(double* v, double* v0, int sz);
double calcLogL(double** coeff, int N, double* L);
void fwdprob(double** fwd, double* coeff, int J, int L, int V, const double* seq, const double* T, const double* B, const double* ip);
void bwdprob(double** bwd, const double* coeff, int J, int L, int V, const double* seq, const double* T, const double* B);
void optBW(double* T, double* ip, double *logL, const double* B, const double** seq, int J, int N, int V, double* L);
int linid(int r, int c, int l, int R, int C);
bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

#endif