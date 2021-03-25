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
#include "mex.h"
 
 
void fwdprob(double* fwd, double* coeff, int J, long L, int V, const double* seq, long l1,
				const double* T, const double* B, const double* ip, const int** id_B){
					
	long l = 0, fi = 0, fj = 0;
	int i = 0, j = 0;
	double sum_j = 0;
	
	// initialization
	coeff[0] = 0;
	for (i=0; i<J; i++){
		fwd[fi] = ip[i] * B[id_B[(int) (seq[l1]-1)][i]];
		coeff[0] = coeff[0] + fwd[fi];
		fi++; // increment 1st probability running index
	}
	
	// normalization
	fi = 0; // ini. 1st probability running index
	for (i=0; i<J; i++){
		fwd[fi] = fwd[fi] / coeff[0];
		fi++; // increment 1st probability running index
	}
	
	// forward calculations
	for (l=1; l<L; l++){
		// initializes
		coeff[l] = 0;
		
		// calculate prob.
		for (i=0; i<J; i++){

			sum_j = 0;
			for (j=0; j<J; j++){
				sum_j = sum_j + fwd[fj] * T[linid(i,j,0,J,J)]; // T_ji
				
				fj++; // increment 2nd probability running index
			}
			
			fwd[fi] = B[id_B[(int) (seq[l1+l]-1)][i]] * sum_j;
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


void bwdprob(double* bwd, const double* coeff, int J, long L, int V, const double* seq, long l1,
				const double* T, const double* B, const int** id_B){
					
	long l = 0, fi = J*(L-1), fj = J*(L-1);
	int i = 0, j = 0, k = 0;
	double sum_j = 0;
	
	// initialization
	for (i=0; i<J; i++){
		bwd[fi] = 1;
		
		fi++; // decrement 1st probability running index
	}
	fi = fi-2*J;
	
	// backward calculations
	for (l=(L-2); l>=0; l--){
		k = 0;
		for (i=0; i<J; i++){
			sum_j = 0;
			for (j=0; j<J; j++){
				sum_j = sum_j + bwd[fj] * T[k] * B[id_B[(int) (seq[l1+l+1]-1)][j]];

				k++; // increment trans. prob. running index
				fj++; // decrement 2nd probability running index
			}
			bwd[fi] = sum_j / coeff[l+1];
			
			fj = fj-J; // reset 2nd probability running index
			fi++; // decrement 1st probability running index
		}
		
		fi = fi-2*J;
		fj = fj-J; // decrement 2nd probability running index
	}
}

