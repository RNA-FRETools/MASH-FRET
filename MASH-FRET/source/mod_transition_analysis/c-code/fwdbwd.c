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
 
 
void fwdprob(double* fwd, double* coeff, int J, int L, int V, const double* seq, long l1,
				const double* T, const double* B, const double* ip, const int** id_B){
					
	int l = 0, i = 0, j = 0, k = 0, fi = 0, fj = 0;
	double sum_j = 0;
	
	// initialization
	for (i=0; i<J; i++){
		fwd[fi] = ip[i] * B[id_B[(int) seq[l1]-1][i]];
		coeff[0] = coeff[0] + fwd[fi];
		fi++; // increment 1st probability running index
	}
	
	// normalization
	fi = fi-J; // reset 1st probability running index
	for (i=0; i<J; i++){
		fwd[fi] = fwd[fi] / coeff[0];
		fi++; // increment 1st probability running index
	}
	
	// forward calculations
	for (l=1; l<L; l++){
		
		// initializes
		coeff[l] = 0;
		
		k = 0; // initialize transition matrix running index
		// calculate prob.
		for (i=0; i<J; i++){

			sum_j = 0;
			for (j=0; j<J; j++){
				sum_j = sum_j + fwd[fj] * T[k];
				
				k++; // increment transition matrix running index
				fj++; // increment 2nd probability running index
			}
			fwd[fi] = B[id_B[(int) seq[l1+l]-1][i]] * sum_j;
			coeff[l] = coeff[l] + fwd[fi];
			
			fj = fj-J; // reset 2nd probability running index
			fi++; // increment 1st probability running index
		}
		
		fj = fj + J; // increment 2nd probability running index
		
		// normalize
		fi = fi-J; // reset 1st probability running index
		for (i=0; i<J; i++){
			fwd[fi] = fwd[fi] / coeff[l];
			
			fi++; // increment 1st probability running index
		}
		
	}
}


void bwdprob(double* bwd, const double* coeff, int J, int L, int V, const double* seq, long l1,
				const double* T, const double* B, const int** id_B){
					
	int l = 0, i = 0, j = 0, k = 0, fi = J*(L-1), fj = J*(L-1);
	
	// initialization
	for (i=(J-1); i>=0; i--){
		bwd[fi] = 1;
		
		fi--; // decrement 1st probability running index
	}

	// forward calculations
	for (l=(L-2); l>=0; l--){
		k = 0;
		for (i=(J-1); i>=0; i--){
			bwd[fi] = 0;
			for (j=0; j<J; j++){
				k++;
				bwd[fi] = bwd[fi] + 
					(bwd[fj] * T[k] * B[id_B[(int) seq[l1+l+1]-1][j]]) / coeff[l+1];
					
				fj = fj--; // decrement 2nd probability running index
			}
			
			fj = fj+J; // reset 2nd probability running index
			fi--; // decrement 1st probability running index
		}
		fj = fj-J; // decrement 2nd probability running index
	}
}


double calcLogL(const double** coeff, int N, double* L){
	
	double logL = 1;
	int n = 0, l = 0;
	
	for (n=0; n<N; n++){
		for (l=0; l<L[n]; l++){
			logL = logL + log(coeff[n][l]);
		}
	}
	
	return logL;
}
