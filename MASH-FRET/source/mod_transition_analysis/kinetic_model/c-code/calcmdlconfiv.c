/*
 * =============================================================
 * calcmdlconfiv.c 
 * Calculate lower and upper bound of 95% confidence intervals around 
 * each transition probabilities of the input HMM model given the input 
 * observation sequences. The method is from Schmid and Hugel, 
 * J Chem Phys. 2018 doi:10.1063/1.5006604. NOTE: MATLAB uses 1-
 * based indexing, C uses 0-based indexing.
 *
 * Takes (1) a J-by-J-dimensional array of doubles (T0) as HMM 
 * transition probabilities, (2) a 1-by-N cell array (seq) containing 
 * the N observation sequences of various lengths, filled with state 
 * value indexes (corresponding to row indexes in B0), (3) a V-by-J-
 * dimensional array of doubles (B0) as HMM event probabilities 
 * filled with 0 or 1, and (4) a [1-by-J] row vector of doubles as 
 * HMM initial state probabilities.
 * Returns (1) convergence boolean (1: converged, 0: failed) (2) 
 * the optimized transition porbability matrix (T), (3) the optimized 
 * initial probabilities (ip), and (4) the log-likelihood of the HMM 
 * given the observations.
 * calcmdlconfiv.c works much (MUCH!) faster than its MATLAB equivalent 
 * calcRateConfIv.m.
 *  
 * Corresponding MATLAB executing command:
 * [posiv,negiv] = calcmdlconfiv(T0,seq,B,ip);
 *
 * MEX-compilation comand:
 * mex  -R2018a -O calcmdlconfiv.c vectop.c fwdbwd.c
 *
 * This is a MEX-file for MATLAB.  
 * Written by Mélodie C.A.S Hadzic, 25.11.2020
 * =============================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mex.h"
#include "fwdbwd.h"
#include "vectop.h"
#include "calcmdlconfiv.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	int i = 0; // loop index
	
	// check input and output arguments
	if (!validArg(nlhs, plhs, nrhs, prhs)){
		return;
	}
	
	// get input dimensions
	int J = (int) mxGetM(prhs[0]);
	const mwSize *seqDim = mxGetDimensions(prhs[1]);
	int N = (int) seqDim[1];
	int V = (int) mxGetM(prhs[2]);
	
	// get input values
	const double *T0 = (const double *) mxGetDoubles(prhs[0]);
	double *seq[N];
	const double *B = (const double *) mxGetDoubles(prhs[2]);
	const double *ip = (const double *) mxGetDoubles(prhs[3]);
	
	// prepare output
	plhs[0] = mxCreateDoubleMatrix(J,J,mxREAL);
	plhs[1] = mxCreateDoubleMatrix(J,J,mxREAL);
	double *posiv = mxGetDoubles(plhs[0]);
	double *negiv = mxGetDoubles(plhs[1]);
	
	// get trajectory lentghs
	double L[N]; 
	mwIndex n = 0;
	for (n=0; n<seqDim[1]; n++){
		seq[(int) n] = (double *) mxGetDoubles(mxGetCell(prhs[1],n));
		L[(int) n] = (double) mxGetNumberOfElements(mxGetCell(prhs[1],n));
	}
	
	// print data characteristics
	mexPrintf("Calculate rate coefficient confidence intervals (%i states, %i values) for %i trajectories (lengths:",J,V,N);
	for (i=0; i<N; i++){
		mexPrintf(" %.0f",L[i]);
	}
	mexPrintf(")\n");
		
	// calculate intervals
	calcRateIv(posiv,negiv,T0,ip,B,(const double**) seq,J,N,V,L);
	
	return;
}


void calcRateIv(double* posiv, double* negiv, 
		const double* T0, const double* ip, const double* B, const double** seq, int J, int N, int V, double* L){
	
	int i = 0, j = 0, id_ij = 0;
	double tp0 = 0, tp0_ii = 0, tp_up = 0, tp_low = 0, logL0 = 0;
	double T[J*J];
	double*** fwd = (double ***) malloc(N * sizeof(double **));
	double** coeff = (double **) malloc(N * sizeof(double *));
	
	// pre-allocate memory for large vectors
	for (i=0; i<N; i++){
		coeff[i] = (double *) malloc(L[i] * sizeof(double));
		fwd[i] = (double **) malloc(J * sizeof(double *));
		for (j=0; j<J; j++){
			fwd[i][j] = (double *) malloc(L[i] * sizeof(double));
		}
	}
	
	// build index matrix
	int** id_T = (int **) malloc(J * sizeof(int *));
	int** id_B = (int **) malloc(V * sizeof(int *));
	for (i=0; i<J; i++){
		id_T[i] = (int *) malloc(J * sizeof(int));
	}
	for (i=0; i<V; i++){
		id_B[i] = (int *) malloc(J * sizeof(int));
	}
	buildIdMat(id_T,J,J);
	buildIdMat(id_B,V,J);
	
	// set transition matrix
	setVect(T,T0,J*J);
	
	// calculate initial likelihood
	for (i=0; i<N; i++){
		fwdprob(fwd[i],coeff[i],J,L[i],V,seq[i],T0,B,ip,(const int**) id_T,(const int**) id_B);
	}
	logL0 = calcLogL((const double**) coeff,N,L);
	
	// calculate confidence intervals
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			if (i==j){ continue; }
			
			mexPrintf(">> interval for transition %i->%i...\n",i,j);
			mexEvalString("drawnow;");
			
			id_ij = id_T[i][j];
			if (T0[id_ij]==0){ continue; }
			
			tp0 = T0[id_ij];
			
			// increases rate coefficient
			tp_up = getRateBound(T,i,j,STEP,logL0,fwd,coeff,ip,B,seq,J,N,V,L,(const int**) id_T,(const int**) id_B);
			posiv[id_ij] = tp_up-tp0;
			setVect(T,T0,J*J); // reset prob. to original
	
			// decreases rate coefficient
			tp_low = getRateBound(T,i,j,0-STEP,logL0,fwd,coeff,ip,B,seq,J,N,V,L,(const int**) id_T,(const int**) id_B);
			negiv[id_ij] = tp0-tp_low;
			setVect(T,T0,J*J); // reset prob. to original
		}
	}
	
	// free memory
	for (i=0; i<N; i++){
		for (j=0; j<J; j++){
			free(fwd[i][j]);
		}
		free(fwd[i]);
		free(coeff[i]);
	}
	free(fwd);
	free(coeff);
	for (i=0; i<J; i++){
		free(id_T[i]);
	}
	for (i=0; i<V; i++){
		free(id_B[i]);
	}
	free(id_T);
	free(id_B);
}


double getRateBound(double* T, int j1, int j2, double step, double logL0, double*** fwd, double** coeff, 
		const double* ip, const double* B, const double** seq, int J, int N, int V, double* L, const int** id_T, const int** id_B){
	
	int i = 0, n = 0, id_ij = id_T[j1][j2], id_ii = id_T[j1][j1];
	double a = 0, b = 0;
	double tp = 0, tpMax = 0, logL = 0, LR1 = 0, LR2 = 0, tp1 = 0;
	
	// determine maximum transition probabilities (max. 1 transition per frame)
	for (i=0; i<J; i++){
		if (i!=j1 && i!=j2){
			tpMax = tpMax + T[id_T[j1][i]];
		}
	}
	tpMax = 1-tpMax;
	
	// determine absolute step
	step = step*T[id_ij];
	if (step>0 && step<MINPROBSTEP){ step = MINPROBSTEP; }
	if (step<0 && step>(0-MINPROBSTEP)){ step = 0-MINPROBSTEP; }
	
	// varies prob and evaluate likelihood ratio
	while (T[id_ij]>0 && T[id_ij]<tpMax){
		
		LR1 = LR2;
		tp1 = T[id_ij];
		
		T[id_ij] = T[id_ij]+step;
		if (T[id_ij]<0){ T[id_ij] = 0; }
		if (T[id_ij]>tpMax){ T[id_ij] = tpMax; }
		T[id_ii] = tpMax-T[id_ij];
		
		// calculate lieklihood ratio
		for (n=0; n<N; n++){
			fwdprob(fwd[n],coeff[n],J,L[n],V,seq[n],(const double*) T,B,ip,id_T,id_B);
		}
		logL = calcLogL((const double**) coeff,N,L);
		LR2 = 2*(logL0-logL);

		if (LR2>LRMAX){
			break;
		}
	}
	
	// find exact point where logL curve crosses theshold
	if (tp1==T[id_ij]){
		return T[id_ij];
	}
	if (step>0){
		a = (LR2-LR1)/(T[id_ij]-tp1);
	}
	else{
		a = (LR1-LR2)/(tp1-T[id_ij]);
	}
	b = LR2-a*T[id_ij];
	tp = (((double) LRMAX)-b)/a;

	return tp;
}


bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	/* Declare variables */
	int i = 0;
	char str[1000];
	
	/* Check for proper number of input and output arguments. */    
	if (nrhs!=4) {
		mexErrMsgTxt("Four input arguments are required.");
		return 0;
	} 
	if (nlhs>2) {
		mexErrMsgTxt("Too many output arguments.");
		return 0;
	}

	/* Check for proper data type in input arguments. */
	for (i==0; i<nrhs; i++){
		if (i==1 && !(mxIsCell(prhs[1]))){
			sprintf(str,"Input argument %i must be a {1-by-N} cell row vector.",i+1);
			mexErrMsgTxt(str);
			return 0;
		}
		else if (i!=1 && !(mxIsDouble(prhs[i]))){
			sprintf(str,"Input argument %i must be of type double.",i+1);
			mexErrMsgTxt(str);
			return 0;
		}
	}
	
	/* Check for dimensions */
	int J1 = (int) mxGetM(prhs[0]);
	int J2 = (int) mxGetN(prhs[0]);
	if (J2!=J1){
		mexErrMsgTxt("The numbers of rows and columns of input(1) must be equal.");
		return 0;
	}
	
	J2 = (int) mxGetN(prhs[2]);
	if (J2!=J1){
		mexErrMsgTxt("The numbers of columns in input (1) and (3) must be equal.");
		return 0;
	}
	
	J2 = (int) mxGetNumberOfElements(prhs[3]);
	if (J2!=J1){
		mexErrMsgTxt("The numbers of elements in input (4) must be equal to the number of rows in input (1).");
		return 0;
	}
	
	return 1;
}

