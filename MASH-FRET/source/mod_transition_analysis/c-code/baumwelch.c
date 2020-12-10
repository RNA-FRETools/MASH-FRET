/*
 * =============================================================
 * baumwelch.c 
 * Perform Baum-Welch optimization of HMM parameters on input 
 * state sequences. NOTE: MATLAB uses 1-based indexing, C uses 
 * 0-based indexing.
 *
 * Takes (1) a J-by-J-dimensional array of doubles (T0) as starting 
 * transition probabilities, (2) a V-by-J-dimensional array of 
 * doubles (B0) as fixed event probabilities filled with 0 or 1, 
 * (3) a 1-by-N cell array (seq) containing the N observation 
 * sequences of various lengths, filled with state value indexes 
 * (corresponding to row indexes in B0), and (4) a [1-by-J] row 
 * vector of doubles as starting initial state probabilities.
 * Returns (1) convergence boolean (1: converged, 0: failed) (2) 
 * the optimized transition porbability matrix (T), (3) the optimized 
 * initial probabilities (ip), and (4) the log-likelihood of the HMM 
 * given the observations.
 * baumwelch.c works much (MUCH!) faster than its MATLAB version 
 * baumwelch_matlab.m.
 *  
 * Corresponding MATLAB executing command:
 * [ok,T,ip,logL] = baumwelch(T0,B0,seq,ip0);
 *
 * MEX-compilation command:
 * mex  -R2018a -O baumwelch.c vectop.c fwdbwd.c
 *
 * This is a MEX-file for MATLAB.  
 * Written by Mélodie C.A.S Hadzic, 24.11.2020
 * =============================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "mex.h"
#include "fwdbwd.h"
#include "vectop.h"
#include "baumwelch.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	// check input and output arguments
	if (!validArg(nlhs, plhs, nrhs, prhs)){
		return;
	}
	
	// get input dimensions
	int J = (int) mxGetM(prhs[0]);
	int V = (int) mxGetM(prhs[1]);
	const mwSize *seqDim = mxGetDimensions(prhs[2]);
	int N = (int) seqDim[1];
	
	// get input values
	const double *T0 = (const double *) mxGetDoubles(prhs[0]);
	const double *B = (const double *) mxGetDoubles(prhs[1]);
	const double *ip0 = (const double *) mxGetDoubles(prhs[3]);
	
	// prepare output
	plhs[0] = mxCreateDoubleScalar(0);
	plhs[1] = mxCreateDoubleMatrix(J,J,mxREAL);
	plhs[2] = mxCreateDoubleMatrix(1,J,mxREAL);
	plhs[3] = mxCreateDoubleScalar(0);
	double *cvg = mxGetDoubles(plhs[0]);
	double *T = mxGetDoubles(plhs[1]);
	double *ip = mxGetDoubles(plhs[2]);
	double *logL = mxGetDoubles(plhs[3]);
	
	// get trajectory lentghs
	double L[N];
	long Lsum = 0; 
	mwIndex n = 0;
	for (n=0; n<seqDim[1]; n++){
		L[(int) n] = (double) mxGetNumberOfElements(mxGetCell(prhs[2],n));
		Lsum = Lsum + (long) L[(int) n];
	}

	// store sequences in a linear vector (for speed)
	double seq[Lsum], *tmp;
	long i = 0, j = 0, k = 0;
	for (n=0; n<seqDim[1]; n++){
		tmp = (double *) mxGetDoubles(mxGetCell(prhs[2],n));
		k = 0;
		for (j=i; j<(i+((long) L[n])); j++){
			seq[j] = tmp[k];
			k++;
		}
		i = j;
	}
	
	// print data characteristics
	mexPrintf("Optimize HMM (%i states, %i values) for %i trajectories (lengths:",J,V,N);
	for (i=0; i<N; i++){
		mexPrintf(" %i",((long) L[i]));
	}
	mexPrintf(")\n");
	
	// transpose T matrix (for speed) and initialize prob.
	double Tt[J*J];
	transposeMat(Tt,T0,J,J);
	setVect(ip,ip0,J);
	
	// optimize prob.
	*cvg = (double) optBW(Tt,ip,logL,B,(const double*) seq,J,N,V,(const double*) L);
	
	// back-transpose T matrix for return
	transposeMat(T,(const double*) Tt,J,J);
	
	return;
}


bool optBW(double* T, double* ip, double* logL, const double* B, const double* seq, int J, int N, int V, const double* L){
	
	// intialization
	int i = 0, j = 0, k = 0, n = 0, nb = 0;
	long o = 0, p_i = 0, p_j = 0, l = 0; // large indexes
	long Lmax = (long) maxVal(L,N);
	double Nij[J*J], Ni[J], N0[J], xi[J*J], gamma[J], fwd[J*Lmax], bwd[J*Lmax], coeff[Lmax], T_prev[J*J], ip_prev[J];
	double sum_gam = 0, sum_xi = 0, logL_prev = -pow(10,9), dmax = 0, m = 0;
	bool cvg = 0;
	
	// builds index matrix
	int** id_B = (int **) malloc(V * sizeof(int *));
	for (i=0; i<V; i++){
		id_B[i] = (int *) malloc(J * sizeof(int));
	}
	buildIdMat(id_B,V,J);	
	
	// E-M cycles
	while (!cvg && m<MAXITER){
		
		logL_prev = *logL;
		setVect(T_prev,(const double*) T,J*J);
		setVect(ip_prev,(const double*) ip,J);

		// resets counts
		k = 0; // initializes transition matrix running index
		for (i=0; i<J; i++){
			N0[i] = 0;
			Ni[i] = 0;
			for (j=0; j<J; j++){
				Nij[k] = 0;
				
				k++; // increment transition matrix running index
			}
		}
		*logL = 0;
		
		o = 0; // initializes sequence running index
		for (n=0; n<N; n++){
			
			// updates forward & backward probabilities
			fwdprob(fwd,coeff,J,(long) L[n],V,(const double*) seq,o,(const double*) T,B,(const double*) ip,(const int**) id_B);
			bwdprob(bwd,(const double*) coeff,J,(long) L[n],V,(const double*) seq,o,(const double*) T,B,(const int**) id_B);
			
			p_i = 0; // initializes 1st probability running index
			p_j = J; // initializes 2nd probability running index
			for (l=0; l<((long) L[n]); l++){
				
				// reset temporary variables
				sum_gam = 0;
				sum_xi = 0;
				
				// calculate temporary variables
				k = 0; // initializes transition matrix running index
				for (i=0; i<J; i++){
					gamma[i] = fwd[p_i] * bwd[p_i];
					sum_gam = sum_gam + gamma[i];
					for (j=0; j<J; j++){
						if (l<((long) L[n]-1)){
							xi[k] = fwd[p_i] * T[k] * bwd[p_j] * B[id_B[(int) (seq[o+1]-1)][j]];
							sum_xi = sum_xi + xi[k];
						}
						
						k++; // increment transition matrix running index
						p_j++; // increment 1st probability running index
					}
					p_j = p_j-J; // reset 2nd probability running index
					p_i++; // increment 1st probability running index
				}
				p_j = p_j + J; // increment 2nd probability running index
				
				// normalize and count transitions
				k = 0; // initializes transition matrix running index
				for (i=0; i<J; i++){
					gamma[i] = gamma[i] / sum_gam;
					
					if (l==0){ N0[i] = N0[i] + gamma[i]; }
					
					if (l<((long) L[n]-1)){ Ni[i] = Ni[i] + gamma[i]; }
					
					for (j=0; j<J; j++){
						if (l<((long) L[n]-1)){
							xi[k] = xi[k] / sum_xi;
							Nij[k] = Nij[k] + xi[k];
						}
						k++; // increment transition matrix running index
					}
				}
				
				// updates log-likelihood
				*logL = *logL + log(coeff[l]);

				o++; // increment sequence running index
			}
		}
		
		// updates model parameters
		k = 0; // initializes transition matrix running index
		for (i=0; i<J; i++){
			ip[i] = N0[i] / ((double) N);
			for (j=0; j<J; j++){
				T[k] = Nij[k] / Ni[i];
				k++; // increment transition matrix running index
			}
		}
		
		// calculates maximum parameter deviation
		dmax = getMaxDiff((const double*) T,(const double*) T_prev,(const double*) ip,(const double*) ip_prev,J);
		
		// displays results
		nb = dispProb(m,*logL-logL_prev,dmax,(const double*) T,(const double*) ip,J,nb);
		
		// checks for convergence
		if (dmax<DMIN){ cvg = 1; }
		
		// increases iteration count
		m = m+1;
	}
	
	if (!cvg){
		mexPrintf("The model failed to converged: maximum number of iterations has been reached.\n");
	}
	
	// free memory
	for (i=0; i<V; i++){
		free(id_B[i]);
	}
	free(id_B);
	
	return cvg;
}


double getMaxDiff(const double* T, const double* T_prev, const double* ip,const double*  ip_prev, int J){
	
	double dmax = 0;
	int i = 0;
	for (i=0; i<J*J; i++){
		if(fabs(T[i]-T_prev[i])>dmax){
			dmax = fabs(T[i]-T_prev[i]);
		}
	}
	for (i=0; i<J; i++){
		if(fabs(ip[i]-ip_prev[i])>dmax){
			dmax = fabs(ip[i]-ip_prev[i]);
		}
	}
	return dmax;
}


int dispProb(double m, double dL, double dmax, const double* T, const double* ip, int J, int nb){
	char str[nb+1];
	int i = 0, j = 0, k = 0;
	
	// erase previous message
	if (nb>0){
		for (i=0; i<nb; i++){
			str[i] = '\b';
		}
		str[nb] = '\0';
		mexPrintf(str);
	}
	
	// write iteration
	nb = mexPrintf("iteration %.0f: d=%.3e (dmin=%.0e) dL=%.3e\n",m,dmax,DMIN,dL);
	
	// write probabilities
	nb = nb + mexPrintf("Initial probabilities:\n");
	for (i=0; i<J; i++){
		nb = nb + mexPrintf("\t%.4f",ip[i]);
	}
	nb = nb + mexPrintf("\n");
	
	nb = nb + mexPrintf("Transition probabilities:\n");
	k = 0;
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			nb = nb + mexPrintf("\t%.4f",T[k]);
			k++;
		}
		nb = nb + mexPrintf("\n");
	}
	mexEvalString("drawnow;");
	
	return nb;
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
	if (nlhs>4) {
		mexErrMsgTxt("Too many output arguments.");
		return 0;
	}

	/* Check for proper data type in input arguments. */
	for (i==0; i<nrhs; i++){
		if (i==2 && !(mxIsCell(prhs[2]))){
			sprintf(str,"Input argument %i must be a {1-by-N} cell row vector.",i+1);
			mexErrMsgTxt(str);
			return 0;
		}
		else if (i!=2 && !(mxIsDouble(prhs[i]))){
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
	
	J2 = (int) mxGetN(prhs[1]);
	if (J2!=J1){
		mexErrMsgTxt("The numbers of columns in input (1) and (2) must be equal.");
		return 0;
	}
	
	J2 = (int) mxGetNumberOfElements(prhs[3]);
	if (J2!=J1){
		mexErrMsgTxt("The numbers of elements in input (4) must be equal to the number of rows in input (1).");
		return 0;
	}
	
	return 1;
}

