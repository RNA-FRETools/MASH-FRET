/*
 * =============================================================
 * fwdbwd.c 
 * Lists functions used for forward/backward probabilities and 
 * likelihood calculations with the forward-backward algorithm, 
 * given an input sequence of observations and HMM parameters.
 *
 * Written by Mélodie C.A.S Hadzic, 24.11.2020
 * =============================================================
 */
 
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "vectop.h"
#include "fwdbwd.h"
 
 
void fwdprob(double** fwd, double* coeff, int J, int L, int V, const double* seq, 
				const double* T, const double* B, const double* ip){
					
	int l = 0, i = 0, j = 0;
	double sum_j = 0;
	
	// initialize
	coeff[0] = 0;
	for (i=0; i<J; i++){
		fwd[i][0] = ip[i] * B[linid((int) (seq[l]-1),i,0,V,J)];
		coeff[0] = coeff[0] + fwd[i][0];
	}
	// normalize
	for (i=0; i<J; i++){
		fwd[i][0] = fwd[i][0] / coeff[0];
	}
	
	// forward calculations
	for (l=1; l<L; l++){
		coeff[l] = 0;
		for (i=0; i<J; i++){
			sum_j = 0;
			for (j=0; j<J; j++){
				sum_j = sum_j + fwd[j][l-1] * T[linid(j,i,0,J,J)];
			}
			fwd[i][l] = B[linid((int) (seq[l]-1),i,0,V,J)] * sum_j;
			coeff[l] = coeff[l] + fwd[i][l];
		}
		// normalize
		for (i=0; i<J; i++){
			fwd[i][l] = fwd[i][l] / coeff[l];
		}
		
	}
}


void bwdprob(double** bwd, const double* coeff, int J, int L, int V, const double* seq, 
				const double* T, const double* B){
					
	int l = 0, i = 0, j = 0;
	
	// initialize
	for (i=0; i<J; i++){
		bwd[i][L-1] = 1;
	}
	
	// forward calculations
	for (l=(L-2); l>=0; l--){
		for (i=0; i<J; i++){
			bwd[i][l] = 0;
			for (j=0; j<J; j++){
				bwd[i][l] = bwd[i][l] + 
					(bwd[j][l+1] * T[linid(i,j,0,J,J)] * B[linid((int) (seq[l+1]-1),j,0,V,J)]) / coeff[l+1];
			}
		}
	}
}


double calcLogL(double** coeff, int N, double* L){
	
	double logL = 1;
	int n = 0, l = 0;
	
	for (n=0; n<N; n++){
		for (l=0; l<L[n]; l++){
			logL = logL + log(coeff[n][l]);
		}
	}
	
	return logL;
}
