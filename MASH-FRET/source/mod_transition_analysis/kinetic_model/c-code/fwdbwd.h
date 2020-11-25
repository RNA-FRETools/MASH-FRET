#ifndef FWDBWD_H
#define FWDBWD_H

void fwdprob(double** fwd, double* coeff, int J, int L, int V, const double* seq, const double* T, const double* B, const double* ip);
void bwdprob(double** bwd, const double* coeff, int J, int L, int V, const double* seq, const double* T, const double* B);
double calcLogL(double** coeff, int N, double* L);

#endif