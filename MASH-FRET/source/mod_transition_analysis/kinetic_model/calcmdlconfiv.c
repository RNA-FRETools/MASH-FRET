/* 
 * Dwell times must be in number of frames (or time bins)
 *
 * [posiv,negiv] = calcRateConfIv(T0,seq,B,ip)
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
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
	double *T0 = (double *) mxGetDoubles(prhs[0]);
	double *seq[N];
	double *B = (double *) mxGetDoubles(prhs[2]);
	double *ip = (double *) mxGetDoubles(prhs[3]);
	
	// prepare output
	plhs[0] = mxCreateDoubleMatrix(J,J,mxREAL);
	plhs[1] = mxCreateDoubleMatrix(J,J,mxREAL);
	double *posiv = mxGetDoubles(plhs[0]);
	double *nefiv = mxGetDoubles(plhs[1]);
	
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
	calcRateIv(posiv,negiv,(const double*) T0,(const double*) ip,(const double*) B,(const double**) seq,J,N,V,L);
	
	return;
}


void calcRateIv(double* posiv, double negiv, 
		const double* T0, const double* ip, const double* B, const double** seq, int J, int N, int V, double* L){
	
	int i = 0, j = 0, id = 0;
	double tp0 = 0, tp_up = 0, tp_low = 0;
	double T[J*J];
	double* coeff[N], fwd[N][J];
	
	// pre-allocate memory for large vectors
	for (i=0; i<N; i++){
		coeff[i] = (double *) malloc(L[i] * sizeof(double));
		for (j=0; j<J; j++){
			fwd[i][j] = (double *) malloc(L[i] * sizeof(double));
		}
	}
	
	setVect(T,T0,J*J);
	
	// calculate initial likelihood ratio
	logL0 = calcLR();
	
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			if (i==j){ continue; }
			
			id = linid(i,j,0,J,J);
			tp0 = T0[id];
			
			// increases rate coefficient
			tp_up = getRateBound(T,i,j,id,STEP,logL0,fwd,coeff,ip,B,seq,J,N,V,L);
			posiv[id] = tp_up-tp0;
			T[id] = tp0; // reset prob. to original
	
			// decreases rate coefficient
			tp_low = getRateBound(T,i,j,id,-STEP,logL0,fwd,coeff,ip,B,seq,J,N,V,L);
			negiv[id] = tp0-tp_low;
			T[id] = tp0; // reset prob. to original
		}
	}
	
	// free memory
	for (i=0; i<N; i++){
		for (j=0; j<J; j++){
			free(fwd[n][j]);
		free(coeff[n]);
		}
	}
}


double getRateBound(double* T, int j1, int j2, int id, double step, double logL0, double*** fwd, double** coeff, 
		const double* ip, const double* B, const double** seq, int J, int N, int V, double* L){
	
	int n = 0, a = 0, b = 0;
	double tp= 0, tpMax = 0, logL = 0, LR1 = 0, LR2 = 0, tp1 = 0;
	
	// determine maximum transition probabilities (max. 1 transition per frame)
	for (i=0; i<J; i++){
		if (i!=j1 && i!=j2){
			tpMax = tpMax + T[linid(j1,i,0,J,J)];
			n = n+1;
		}
	}
	tpMax = 1-tpMax;
	
	// determine absolute step
	step = step*T[id];
	if (step<MINPROBSTEP){
		step = MINPROBSTEP;
	}
	
	// varies prob and evaluate likelihood ratio
	while (T[id]>0 && T[id]<tpMax){
		
		LR1 = LR2;
		tp1 = T[id];
		
		T[id] = T[id]+step;
		if (T[id]<0){ T[id] = 0; }
		if (T[id]>tpMax){ T[id] = tpMax; }
		
		// calculate lieklihood ratio
		for (n=0; n<N; n++){
			fwdprob(fwd[n],coeff[n],J,L[n],V,seq[n],T,B,ip);
		}
		
		logL = calcLogL(coeff,N,L);
		LR2 = 2*(logL0-logL);
		
		if (LR2>LRMAX){
			break;
		}
	}
	
	// find exact point where logL curve crosses theshold
	if (tp1==T[id]){
		return T[id];
	}
	if (step>0){
		a = (LR2-LR1)/(T[id]-tp1);
	}
	else{
		a = (LR1-LR2)/(tp1-T[id]);
	}
	b = LR2-a*T[id];
	tp = (LRMAX-b)/a;

	return tp;
}


bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	/* Declare variables */
	int i = 0;
	
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
			mexErrMsgTxt("Input argument %i must be a {1-by-N} cell row vector.",i+1);
			return 0;
		}
		else if (i!=1 && !(mxIsDouble(prhs[i]))){
			mexErrMsgTxt("Input argument %i must be of type double.",i+1);
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

