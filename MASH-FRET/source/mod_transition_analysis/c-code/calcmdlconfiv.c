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
#include <math.h>
#include "mex.h"
#include "fwdbwd.h"
#include "vectop.h"
#include "calcmdlconfiv.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	
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
	const double *B = (const double *) mxGetDoubles(prhs[2]);
	const double *ip = (const double *) mxGetDoubles(prhs[3]);
	
	// prepare output
	plhs[0] = mxCreateDoubleMatrix(J,J,mxREAL);
	plhs[1] = mxCreateDoubleMatrix(J,J,mxREAL);
	double *posiv = mxGetDoubles(plhs[0]);
	double *negiv = mxGetDoubles(plhs[1]);
	
	// get trajectory lentghs
	double L[N];
	long Lsum = 0; 
	mwIndex n = 0;
	for (n=0; n<seqDim[1]; n++){
		L[(int) n] = (double) mxGetNumberOfElements(mxGetCell(prhs[1],n));
		Lsum = Lsum + (long) L[(int) n];
	}

	// store sequences in a linear vector (for speed)
	double seq[Lsum], *tmp;
	long i = 0, j = 0, k = 0;
	for (n=0; n<seqDim[1]; n++){
		tmp = (double *) mxGetDoubles(mxGetCell(prhs[1],n));
		k = 0;
		for (j=i; j<(i+((long) L[n])); j++){
			seq[j] = tmp[k];
			k++;
		}
		i = j;
	}
	
	// print data characteristics
	mexPrintf("Calculate rate coefficient confidence intervals (%i states, %i values) for %i trajectories (lengths:",J,V,N);
	for (i=0; i<N; i++){
		mexPrintf(" %.0f",L[i]);
	}
	mexPrintf(")\n");
	
	// transpose transition matrix (for speed)
	double T0t[J*J], posivt[J*J], negivt[J*J];
	transposeMat(T0t,T0,J,J);
	
	//initializes arrays
	initVect_double(posivt,J*J,0);
	initVect_double(negivt,J*J,0);
	
	// calculate intervals
	calcRateIv(posivt,negivt,T0t,ip,B,(const double*) seq,J,N,V,L);
	
	// transpose error matrices to be returned
	transposeMat(posiv,posivt,J,J);
	transposeMat(negiv,negivt,J,J);
	
	return;
}


void calcRateIv(double* posiv, double* negiv, 
		const double* T0, const double* ip, const double* B, const double* seq, int J, int N, int V, double* L){
	
	int i = 0, k = 0, k2 = 0;
	int k0[J];
	long o = 0, j = 0, l = 0;
	double tp_up = 0, tp_low = 0, logL0 = 0, Lmax = maxVal(L,N);
	double T[J*J], tpMax[J*J];
	double fwd[J*((long) Lmax)], coeff[(long) Lmax];
	
	// initializes max. prob.
	initVect_double(tpMax,J*J,0);
	
	// build index matrix
	int** id_B = (int **) malloc(V * sizeof(int *));
	for (i=0; i<V; i++){
		id_B[i] = (int *) malloc(J * sizeof(int));
	}
	buildIdMat(id_B,V,J);
	
	// set transition matrix
	setVect(T,T0,J*J);
	
	// calculate initial likelihood
	o = 0; //ini. seq. running index
	logL0= 0;
	for (i=0; i<N; i++){
		fwdprob(fwd,coeff,J,(long) L[i],V,seq,o,T0,B,ip,(const int**) id_B);
		
		// update total log-likelihood
		for (j=0; j<((long) L[i]); j++){
			logL0 = logL0 + log(coeff[j]);
		}
		
		o = o + (long) L[i]; // incr. seq. running index
	}
	
	// calculate diagonal indexes
	k = 0; // ini. trans. mat. running index
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			if (i==j){ k0[i] = k; }
			k++; // incr. trans. mat. running index
		}
	}
	
	// determine maximum transition probabilities (max. 1 transition per frame)
	k = 0; // ini. trans. mat. running index
	k2 = 0; // ini. 2nd trans. mat. running index
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			for (l=0; l<J; l++){
				if (l!=i && l!=j){
					tpMax[k] = tpMax[k] + T[k2];
				}
				k2++; // incr. 2nd trans. mat. running index
			}
			tpMax[k] = 1-tpMax[k];
			
			k++; // incr. trans. mat. running index
			k2 = k2-J; // reset 2nd trans. mat. running index
		}
		k2 = k2+J; // incr. 2nd trans. mat. running index
	}
	
	// calculate confidence intervals
	k = 0; // ini. trans. mat. running index
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			if (i!=j){
			
				mexPrintf(">> interval for transition %i->%i...\n",i,j);
				mexEvalString("drawnow;");

				if (T0[k]>0){
					// increases rate coefficient
					tp_up = getRateBound(T,k,k0[i],tpMax[k],STEP,logL0,fwd,coeff,ip,B,seq,J,N,V,L,(const int**) id_B);
					posiv[k] = tp_up-T0[k];
					setVect(T,T0,J*J); // reset prob. to original
			
					// decreases rate coefficient
					tp_low = getRateBound(T,k,k0[i],tpMax[k],0-STEP,logL0,fwd,coeff,ip,B,seq,J,N,V,L,(const int**) id_B);
					negiv[k] = T0[k]-tp_low;
					setVect(T,T0,J*J); // reset prob. to original
				}
			}
			
			k++; // incr. trans. mat. running index
		}
	}
	
	// free memory
	for (i=0; i<V; i++){
		free(id_B[i]);
	}
	free(id_B);
}


double getRateBound(double* T, int id_ij, int id_ii, double tpMax, double step, double logL0, double* fwd, double* coeff, 
		const double* ip, const double* B, const double* seq, int J, int N, int V, double* L, const int** id_B){
	
	int n = 0;
	long i = 0, o = 0;
	double a = 0, b = 0;
	double tp = 0, logL = 0, LR1 = 0, LR2 = 0, tp1 = 0;

	// determine absolute step
	step = step*T[id_ij];
	if (step>=0 && step<MINPROBSTEP){ step = MINPROBSTEP; }
	else if (step<0 && step>(0-MINPROBSTEP)){ step = 0-MINPROBSTEP; }

	// varies prob and evaluate likelihood ratio
	while (T[id_ij]>TPMIN && T[id_ij]<tpMax){
		
		LR1 = LR2;
		if (T[id_ij]<=TPMIN){ tp1 = TPMIN; }
		else if (T[id_ij]>=tpMax){ tp1 = tpMax; }
		else{ tp1 = T[id_ij]; }
		
		T[id_ij] = T[id_ij]+step;
		if (T[id_ij]<TPMIN){ T[id_ij] = TPMIN; }
		if (T[id_ij]>tpMax){ T[id_ij] = tpMax; }
		T[id_ii] = tpMax-T[id_ij];

		// calculate likelihood ratio
		o = 0; // ini. seq. running index
		logL = 0;
		for (n=0; n<N; n++){
			fwdprob(fwd,coeff,J,(long) L[n],V,seq,o,(const double*) T,B,ip,id_B);
			
			// update total log-likeihhod
			for (i=0; i<L[n]; i++){
				logL = logL + log(coeff[i]);
			}
			
			o = o+L[n];// incr. seq. running index
		}
		
		// calculate log of likelihood ratio
		LR2 = 2*(logL0-logL);
		
		if (LR2>LRMAX){ break; }
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
	tp = (LRMAX-b)/a;

	return tp;
}


bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	int i = 0;
	char str[1000];
	
	// Check for proper number of input and output arguments.
	if (nrhs!=4) {
		mexErrMsgTxt("Four input arguments are required.");
		return 0;
	} 
	if (nlhs>2) {
		mexErrMsgTxt("Too many output arguments.");
		return 0;
	}

	// Check for proper data type in input arguments. 
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
	
	// Check for dimensions 
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

