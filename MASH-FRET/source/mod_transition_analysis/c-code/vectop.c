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
#include <math.h>
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
			mexPrintf("%.2e ",mat[id[r][c]]);
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


void dispVect_int(const int* v, int sz){
	int i = 0;
	for (i=0; i<sz; i++){
		mexPrintf(" %i",v[i]);
	}
	mexPrintf("\n");
}


void dispVect_double(const double* v, int sz){
	int i = 0;
	for (i=0; i<sz; i++){
		mexPrintf(" %.2e",v[i]);
	}
	mexPrintf("\n");
}


int linid(int r, int c, int l, int R, int C){
	int id = 0;
	id = l*R*C + c*R + r;
	return id;
}


int findint(const int* vect, int val, int sz){
	int i = 0, id = 0;
	for (i=0; i<sz; i++){
		if (vect[i]==val){
			id = i;
			return id;
		}
	}
	return -1;
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
	
	int i = 0, j = 0, k = 0, op = 0, nop = 0;
	int nop0 = (int) ceil(sqrt((double) powexp)); // number of matrix multiplications
	int expnt[nop0];
	double tmp[J*J];
	
	// initialize: identity matrix (dest^0)
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			if (i==j){ dest[id[i][j]] = 1; }
			else{ dest[id[i][j]] = 0; }
		}
	}
	if (powexp==0){ return; }
	
	// determines decomposition of the powexp in powers of two
	j = 0;
	while (j<powexp){
		i = 1; 
		while (i<(powexp-j)){ i = i*2; }
		if (i>(powexp-j)){ i = i/2; }
		j = j + i;
		expnt[op] = i; // store intermediate exponents
		op = op+1;
	}
	nop = op;
	/*mexPrintf("nop=%.0f, exponents=",nop);
	dispVect_int((const int*) expnt,nop);*/
	
	double *intmed[nop];
	for (i=0; i<nop; i++){
		intmed[i] = (double *) malloc(J * J * sizeof(double));
	}
	
	// bring to the power of powexp
	for (op=0; op<nop; op++){
		if (op==0){
			for (j=1; j<=expnt[op]; j*=2){
				
				//mexPrintf("op=0, matrix^%i=\n",j);
				
				// bring matrix to the square
				if (j==1){
					setVect(tmp,src,J*J);
					setVect(dest,src,J*J);;
				}
				else{
					setVect(tmp,(const double*) dest,J*J);
					matprod(dest,(const double*) tmp,(const double*) tmp,J,J,J,id,id,id);
				}
				
				/*mexPrintf("op=0, tmp=\n");
				disp2DVectMatrix((const double*) tmp,J,J,id);
				mexPrintf("op=0, dest=\n");
				disp2DVectMatrix((const double*) dest,J,J,id);*/
				
				// store intermediate matrices: prevents re-calculation in next operations (op>0)
				k = findint((const int*) expnt,j,nop);
				if (k>=0){ 
					// mexPrintf("op=0, save it!\n");
					setVect(intmed[k],(const double*) dest,J*J);
					/*mexPrintf("op=0, saved(k=%i)=\n",k);
					disp2DVectMatrix((const double*) intmed[k],J,J,id);*/
				}
			}
		}
		else{
			setVect(tmp,(const double*) dest,J*J);
			matprod(dest,(const double*) tmp,(const double*) intmed[op],J,J,J,id,id,id);
			
			/*mexPrintf("op=%i, temp=\n",op);
			disp2DVectMatrix((const double*) tmp,J,J,id);
			mexPrintf("op=%i, intmed=\n",op);
			disp2DVectMatrix((const double*) intmed[op],J,J,id);
			mexPrintf("op=%i, dest=\n",op);
			disp2DVectMatrix((const double*) dest,J,J,id);*/
		}
	}
	/*
	mexPrintf("dest = ");
	disp2DVectMatrix((const double*) dest,J,J,id);*/
	
	// free memory
	for (i=0; i<nop; i++){
		free(intmed[i]);
	}
	
	return;
}


void matprod(double* dest, const double* src1, const double* src2, int R1, int C1, int C2, const int** id, const int** id1, const int** id2){
	
	int i = 0, j = 0, k = 0;

	for (i=0; i<R1; i++){
		for (j=0; j<C2; j++){
			dest[id[i][j]] = 0; // initialize
			for (k=0; k<C1; k++){
				dest[id[i][j]] = dest[id[i][j]] + src1[id1[i][k]] * src2[id2[k][j]];
			}
		}
	}
	return;
}

