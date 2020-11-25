#ifndef BAUMWELCH_H
#define BAUMWELCH_H

// DEFAULTS
#define STEP 0.1 // relative variation of rate coefficients at each step (10%)
#define LRMAX 1.96^2 // maximum likelihood ratio for 95% confidence (2.576^2 for 99%)
#define MINPROBSTEP 0.001 // minimum probability step

void calcRateIv(double* posiv, double negiv, const double* T0, const double* ip, const double* B, const double** seq, int J, int N, int V, double* L)
double getRateBound(double* T, int j1, int j2, int id, double step, double LR0, double*** fwd, double** coeff, const double* ip, const double* B, const double** seq, int J, int N, int V, double* L)
bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

#endif