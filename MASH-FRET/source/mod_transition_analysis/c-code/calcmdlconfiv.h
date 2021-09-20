#ifndef BAUMWELCH_H
#define BAUMWELCH_H

// DEFAULTS
#define STEP 0.1 // relative variation of rate coefficients at each step (10%)
#define TPMIN 1E-8 // minimum transition probability
#define LRMAX 3.8416 // maximum likelihood ratio for 95% confidence (6.6358 for 99%)
#define MINPROBSTEP 0.001 // minimum probability step

void calcRateIv(double* posiv, double* negiv, const double* T0, const double* ip, const double* B, 
		const double* seq, int J, int N, int V, double* L);
double getRateBound(double* T, int id_ij, int id_ii, double tpMax, double step, double logL0, double* fwd, double* coeff, 
		const double* ip, const double* B, const double* seq, int J, int N, int V, double* L, const int** id_B);
bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);

#endif