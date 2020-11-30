#ifndef VECTOP_H
#define VECTOP_H

void disp2DMatrix(const double** mat, int R, int C);
void disp2DVectMatrix(const double* mat, int R, int C, const int** id);
void setVect(double* v, const double* v0, int sz);
int linid(int r, int c, int l, int R, int C);
void buildIdMat(int** dest, int R, int C);
void matpow(double* dest, const double* src, int J, int powexp, const int** id);
void matprod(double* dest, const double* src1, const double* src2, int R1, int C1, int C2, const int** id, const int** id1, const int** id2);

#endif