#ifndef TRAINPH_H
#define TRAINPH_H

// DEFAULTS
#define DMIN 0.00000001 // convergence criterion on parameters (from SMACKS)
#define DLMIN 0.000001 // covergence criterion on log-likelihood ratio
#define MAXITER 100000 // maximum number of EM iterations


bool optDPH(double* T, double* a, double* logL, const double* cnts, int J, int nDt);
void EstepDPH(double* B, double* Nij, double* Ni, const double* P, const double* a, const double* T, const double* t, int nDt, int J, 
		const int** id_T, const int** id_P, const int** id_Jh, const int** id_Jv, const int** id_mat);
void MstepDPH(double* a, double* T, double* t, const double* B, const double* Nij, const double* Ni, double totCnt, int J, const int** id_T);
double calcMaxDev(const double* T, const double* T_prev, const double* a,const double*  a_prev, int J);
double calcDPHlogL(const double* T, const double* a, const double* t, const double* P, int J, int nDt, const int** id_T, const int** id_P, const int** id_v);
double calcDPHlogL_2(const double* T, const double* a, const double* t, const double* B, const double* Nij, const double* Ni, 
		int J, const int** id_T);
int eraseAndWrite(char* str, int nb);
int dispDPHres(double m,double dL, double dmax, const double* T, const double* a, int J, const int** id_T, int nb);
bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]);


#endif