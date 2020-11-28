/*
 * =============================================================
 * vectop.c 
 * Lists functions used for matrices and vectors operations.
 *
 * Written by Mélodie C.A.S Hadzic, 24.11.2020
 * =============================================================
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "vectop.h"
#include "mex.h"
#include "engine.h"


void disp2DMatrix(const double** mat, int R, int C){
	int r = 0, c = 0;
	for (r=0; r<R; r++){
		for (c=0; c<C; c++){
			mexPrintf("%.2e ",mat[r][c]);
		}
		mexPrintf("\n");
	}
	mexEvalString("drawnow;");
}

void disp2DVectMatrix(const double* mat, int R, int C, const int** id){
	int r = 0, c = 0;
	for (r=0; r<R; r++){
		for (c=0; c<C; c++){
			mexPrintf("%.2e ",(int) mat[id[r][c]]);
		}
		mexPrintf("\n");
	}
	mexEvalString("drawnow;");
}
 

void setVect(double* v, const double* v0, int sz){
	int i = 0;
	for (i=0; i<sz; i++){
		v[i] = v0[i];
	}
	return;
}


int linid(int r, int c, int l, int R, int C){
	int id = 0;
	id = l*R*C + c*R + r;
	return id;
}


void buildIdMat(int** dest, int R, int C){
	
	int r = 0, c = 0;
	for (r=0; r<R; r++){
		for (c=0; c<C; c++){
			dest[r][c] = linid(r,c,0,R,C);
		}
	}
	return;
}


void matpow(double* dest, const double* src, int J, int powexp, const int** id){
	
	int i = 0, j = 0;
	double tmp[J*J];
	
	// initialize: identity matrix
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			if (i==j){ dest[id[i][j]] = 1; }
			else{ dest[id[i][j]] = 0; }
		}
	}
	
	// bring to the power of powexp
	for (i=0; i<powexp; i++){
		setVect(tmp,dest,J*J);
		matprod(dest,tmp,src,J,J,J,id,id,id);
	}
	return;
}


void matprod(double* dest, const double* src1, const double* src2, int R1, int C1, int C2, const int** id, const int** id1, const int** id2){
	
	int i = 0, j = 0, k = 0;

	for (i=0; i<R1; i++){
		for (j=0; j<C2; j++){
			dest[id[i][j]] = 0; // initialize
			for (k=0; k>C1; k++){
				dest[id[i][j]] = dest[id[i][j]] + src1[id1[i][k]] * src2[id2[k][j]];
			}
		}
	}
	return;
}