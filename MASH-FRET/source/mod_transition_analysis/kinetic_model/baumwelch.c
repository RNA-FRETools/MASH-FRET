/* [T,ip,logL] = baumwelch(T0,B0,seq,ip0) */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "mex.h"
#include "matrix.h"
#include "baumwelch.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	char str[100]; // log string
	int i = 0; // loop index
	double nb = 0; // number of characters printed
	
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
	double *T0 = (double *) mxGetDoubles(prhs[0]);
	double *B = (double *) mxGetDoubles(prhs[1]);
	double *seq[N];
	double *ip0 = (double *) mxGetDoubles(prhs[3]);
	
	// prepare output
	plhs[0] = mxCreateDoubleMatrix(J,J,mxREAL);
	plhs[1] = mxCreateDoubleMatrix(1,J,mxREAL);
	plhs[2] = mxCreateDoubleScalar(0);
	double *T = mxGetDoubles(plhs[0]);
	double *ip = mxGetDoubles(plhs[1]);
	double *logL = mxGetDoubles(plhs[2]);
	
	// get trajectory lentghs
	double L[N]; 
	mwIndex n = 0;
	for (n=0; n<seqDim[1]; n++){
		seq[(int) n] = (double *) mxGetDoubles(mxGetCell(prhs[2],n));
		L[(int) n] = (double) mxGetNumberOfElements(mxGetCell(prhs[2],n));
	}
	
	// print data characteristics
	mexPrintf("Optimize HMM (%i states, %i values) for %i trajectories (lengths:",J,V,N);
	for (i=0; i<N; i++){
		mexPrintf(" %.0f",L[i]);
	}
	mexPrintf(")\n");
		
	// optimize prob.
	setVect(T,T0,J*J);
	setVect(ip,ip0,J);
	optBW(T,ip,logL,(const double*) B,(const double**) seq,J,N,V,L);
	
	return;
}


void optBW(double* T, double* ip, double* logL, const double* B, const double** seq, int J, int N, int V, double* L){
	
	// intialization
	int n = 0, i = 0, j = 0, l = 0, nb = 0;
	double Nij[J][J], Ni[J], N0[J];
	double sum_gam = 0, sum_xi = 0;
	double xi[J][J], gamma[J], *fwd[N][J], *bwd[N][J], *coeff[N], T_prev[J*J], ip_prev[J];
	bool cvg = 0;
	double logL_prev = -pow(10,9), dmax = 0, m = 0;

	// calculate forward and backward prob.
	for (n=0; n<N; n++){
		coeff[n] = (double *)malloc(L[n] * sizeof(double));
		for (i=0; i<J; i++){
			fwd[n][i] = (double *)malloc(L[n] * sizeof(double));
			bwd[n][i] = (double *)malloc(L[n] * sizeof(double));
		}

		fwdprob(fwd[n], coeff[n], J, L[n], V, seq[n], (const double*) T, B, (const double*) ip);
		bwdprob(bwd[n], (const double*) coeff[n], J, L[n], V, seq[n], (const double*) T, B);
	}
	
	// calculate initial likelihood
	*logL = calcLogL(coeff,N,L);
	nb = dispProb(m,*logL-logL_prev,0,T,ip,J,0);
	
	// E-M cycles
	while (!cvg && m<MAXITER){
		
		m = m+1;
		
		logL_prev = *logL;
		setVect(T_prev,T,J*J);
		setVect(ip_prev,ip,J);
		
		// reset counts
		for (i=0; i<J; i++){
			N0[i] = 0;
			Ni[i] = 0;
			for (j=0; j<J; j++){
				Nij[i][j] = 0;
			}
		}
		for (n=0; n<N; n++){
			for (l=0; l<L[n]; l++){
				// calculate temporary variables
				sum_gam = 0;
				sum_xi = 0;
				for (i=0; i<J; i++){
					gamma[i] = fwd[n][i][l] * bwd[n][i][l];
					sum_gam = sum_gam + gamma[i];
					
					if (l==(L[n]-1)){ continue; }
					for (j=0; j<J; j++){
						xi[i][j] = fwd[n][i][l] * T[linid(i,j,0,J,J)] * bwd[n][j][l+1] * B[linid((int) (seq[n][l+1]-1),j,0,V,J)];
						sum_xi = sum_xi + xi[i][j];
					}
				}
				
				// normalize and count transitions
				for (i=0; i<J; i++){
					gamma[i] = gamma[i] / sum_gam;
					if (l==0){
						N0[i] = N0[i] + gamma[i];
					}
					
					if (l==(L[n]-1)){ continue; }
					Ni[i] = Ni[i] + gamma[i];
					for (j=0; j<J; j++){
						xi[i][j] = xi[i][j] / sum_xi;
						Nij[i][j] = Nij[i][j] + xi[i][j];
					}
				}
				
			}
		}
		// update model parameters
		for (i=0; i<J; i++){
			ip[i] = N0[i] / ((double) N);
			for (j=0; j<J; j++){
				T[linid(i,j,0,J,J)] = Nij[i][j] / Ni[i];
			}
		}

		// update forward & backward probabilities
		for (n=0; n<N; n++){
			fwdprob(fwd[n], coeff[n], J, L[n], V, seq[n], (const double*) T, B, (const double*) ip);
			bwdprob(bwd[n], (const double*) coeff[n], J, L[n], V, seq[n], (const double*) T, B);
		}
		
		// update likelihood
		*logL = calcLogL(coeff,N,L);
		dmax = getMaxDiff(T,T_prev,ip,ip_prev,J);
		
		// check for convergence
		/*if (!((*logL-logL_prev)>0 && ((*logL-logL_prev)>DLMIN || dmax>DMIN))){
			if ((*logL-logL_prev)<0){
				*logL = logL_prev;
				setVect(T,T_prev,J*J);
				setVect(ip,ip_prev,J);
			}
			cvg = 1;
		}*/
		if (dmax<DMIN){
			cvg = 1;
		}
		
		nb = dispProb(m,*logL-logL_prev,dmax,T,ip,J,nb);
	}
	
	// free memory
	for (n=0; n<N; n++){
		for (i=0; i<J; i++){
			free(fwd[n][i]);
			free(bwd[n][i]);
		}
		free(coeff[n]);
	}
	
	return;
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


int dispProb(double m, double dL, double dmax, double* T, double* ip, int J, int nb){
	char str[nb+1];
	int i = 0, j = 0;
	
	// erase previous message
	if (nb>0){
		for (i=0; i<nb; i++){
			str[i] = '\b';
		}
		str[nb] = '\0';
		mexPrintf(str);
	}
	
	// write iteration
	nb = mexPrintf("iteration %.0f: dL=%.3e (dL_min=%.0e) d=%.3e\n",m,dL,DLMIN,dmax);
	
	// write probabilities
	nb = nb + mexPrintf("Initial probabilities:\n");
	for (i=0; i<J; i++){
		nb = nb + mexPrintf("\t%.4f",ip[i]);
	}
	nb = nb + mexPrintf("\n");
	
	nb = nb + mexPrintf("Transition probabilities:\n");
	for (i=0; i<J; i++){
		for (j=0; j<J; j++){
			nb = nb + mexPrintf("\t%.4f",T[linid(i,j,0,J,J)]);
		}
		nb = nb + mexPrintf("\n");
	}
	mexEvalString("drawnow;");
	
	return nb;
}


void setVect(double* v, double* v0, int sz){
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


bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	/* Declare variables */
	int i = 0;
	char str[100];
	
	/* Check for proper number of input and output arguments. */    
	if (nrhs!=4) {
		mexErrMsgTxt("Four input arguments are required.");
		return 0;
	} 
	if (nlhs>3) {
		mexErrMsgTxt("Too many output arguments.");
		return 0;
	}

	/* Check for proper data type in input arguments. */
	for (i==0; i<nrhs; i++){
		if (i==2 && !(mxIsCell(prhs[2]))){
			sprintf(str,"Input argument %i must be a {1-by-N} cell row vector.",i+1);
			if (str==NULL){
				mexErrMsgTxt("Error string is empty.");
			}
			mexErrMsgTxt(str);
			return 0;
		}
		else if (i!=2 && !(mxIsDouble(prhs[i]))){
			sprintf(str,"Input argument %i must be of type double.",i+1);
			if (str==NULL){
				mexErrMsgTxt("Error string is empty.");
			}
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

