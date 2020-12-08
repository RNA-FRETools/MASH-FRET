#ifndef FWDBWD_H
#define FWDBWD_H

void fwdprob(double* fwd, double* coeff, int J, int L, int V, 
		const double* seq, long l1, const double* T, const double* B, const double* ip, const int** id_B);
void bwdprob(double* bwd, const double* coeff, int J, int L, int V, 
		const double* seq, long l1, const double* T, const double* B, const int** id_B);
double calcLogL(const double** coeff, int N, double* L);

#endif