/* 
 * Train a discrete phase-type distribution on dwell time data
 * Dwell times must be in number of frames (or time bins)
 * Dwell time counts must be strictly positive
 *
 * Corresponding MATLAB executing command:
 * [a,T,logL] = trainPH(a0,T0,t0,cnts);
 *
 * MEX-compilation command:
 * mex  -R2018a -O trainPH.c vectop.c
 *
 * This is a MEX-file for MATLAB.  
 * Written by Mélodie C.A.S Hadzic, 24.11.2020
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "mex.h"
#include "vectop.h"
#include "trainPH.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, 
        const mxArray *prhs[])
{
	// check input and output arguments
	if (!validArg(nlhs, plhs, nrhs, prhs)){
		return;
	}
	
	// get input dimensions
	int J = (int) mxGetN(prhs[1]);
	int nDt = (int) mxGetN(prhs[3]);
    int nb_int = 0;
	
	// get input values
	const double *a0 = (const double *) mxGetDoubles(prhs[0]); // starting initial state prob.
	const double *T0 = (const double *) mxGetDoubles(prhs[1]); // starting transition matrix
	const double *t0 = (const double *) mxGetDoubles(prhs[2]); // starting exit prob
	const double *cnts = (const double *) mxGetDoubles(prhs[3]); // dwell times and counts
	
	// prepare output
	plhs[0] = mxCreateDoubleMatrix(1,J,mxREAL); // PH initial state prob.
	plhs[1] = mxCreateDoubleMatrix(J,J,mxREAL); // PH transition matrix
	plhs[2] = mxCreateDoubleScalar(0); // Likelihood of PH given the dwell times
    plhs[3] = mxCreateDoubleScalar(0); // Number of printed characters
	double *a = mxGetDoubles(plhs[0]);
	double *T = mxGetDoubles(plhs[1]);
	double *logL = mxGetDoubles(plhs[2]);
    double *nb = mxGetDoubles(plhs[3]);
    double t[J];

	// train PH
	setVect(T,T0,J*J);
	setVect(a,a0,J);
	setVect(t,t0,J);
	bool cvg = optDPH(T,t,a,logL,cnts,J,nDt,&nb_int);
    *nb = (double) nb_int;
	
	// return empty arrays if EM did not converge
	if (!cvg){
		const mwSize dims[] = {0,0};
		mxSetDimensions(plhs[0],dims,2);
		mxSetDimensions(plhs[1],dims,2);
		*logL = 0;
	}
	
	return;
}


bool optDPH(double* T, double* t, double* a, double* logL, const 
        double* cnts, int J, int nDt, int* nb){
	
	int i = 0, j = 0;
	bool cvg = 0;
	double m = 0, dmax = 0, logL_prev = 0, totCnt = 0;
	double T_prev[J*J], a_prev[J], B[J], Ni[J], Nij[J*J];

	// build vectorized matrix indexes outside the while loop for speed
	int** id_T = (int **)malloc(J * sizeof(int *));
	for (i=0; i<J; i++){
		id_T[i] = (int *)malloc(J * sizeof(int));
	}
	int** id_P = (int **)malloc(2 * sizeof(int *));
	for (i=0; i<2; i++){
		id_P[i] = (int *)malloc(nDt * sizeof(int));
	}
	int** id_mat = (int **)malloc(2*J * sizeof(int *));
	for (i=0; i<2*J; i++){
		id_mat[i] = (int *)malloc(2*J * sizeof(int));
	}
	int** id_Jv = (int **)malloc(J * sizeof(int *));
	for (i=0; i<J; i++){
		id_Jv[i] = (int *)malloc(sizeof(int));
	}
	int** id_Jh = (int **)malloc(sizeof(int *));
	id_Jh[0] = (int *)malloc(J * sizeof(int));
	
	buildIdMat(id_T,J,J);
	buildIdMat(id_P,2,nDt);
	buildIdMat(id_mat,2*J,2*J);
	buildIdMat(id_Jv,J,1);
	buildIdMat(id_Jh,1,J);
    
//     // calculate initial likelihood (discrete PH)
//     *logL = 0;
	
	// calculate initial likelihood (continuous PH)
	*logL = calcDPHlogL( (const double*) T, (const double*) a, 
            (const double*) t, cnts,J,nDt, (const int**) id_T, 
            (const int**) id_P, (const int**) id_Jv);
    if (!mxIsFinite(*logL)){ cvg = true; }
    
    // show initial fit
	*nb = dispDPHres(m,*logL-logL_prev,dmax, (const double*) T, 
            (const double*) a,J, (const int**) id_T,0);

    // E-M iterations
	while(!cvg && m<MAXITER){
		
		m = m+1;
		
        // store previous inferrence
		setVect(T_prev,(const double*) T,J*J);
		setVect(a_prev,(const double*) a,J);
		logL_prev = *logL;
		
		// E-step
		EstepDPH(B,Nij,Ni,cnts,(const double*) a,(const double*) T,
                (const double*) t,nDt,J,(const int**) id_T,
                (const int**) id_P,(const int**) id_Jh,(const int**) id_Jv,
                (const int**) id_mat, &totCnt);
        
//         //calculates likelihood (discrete PH)
//         *logL = calcDPHlogL_2((const double*) T, (const double*) a, 
//                 (const double*) t, (const double*) B, (const double*) Nij, 
//                 (const double*) Ni,J, (const int**) id_T);
//         if (!mxIsFinite(*logL)){ break; }
        		
		// M-step
		MstepDPH(a,T,t,(const double*) B,(const double*) Nij,
                (const double*) Ni,totCnt,J,(const int**) id_T);
		
		// calculates likelihood (continuous PH)
		*logL = calcDPHlogL((const double*) T,(const double*) a,
                (const double*) t,cnts,J,nDt,(const int**) id_T,
                (const int**) id_P,(const int**) id_Jv);
        if (!mxIsFinite(*logL)){ break; }

		// check for convergence
		dmax = calcMaxDev((const double*) T,(const double*) T_prev,
                (const double*) a,(const double*) a_prev,J);
		if (m>1 && ((*logL-logL_prev)<DLMIN || dmax<DMIN)){ cvg = 1; }
		
        // show progress
		*nb = dispDPHres(m,*logL-logL_prev,dmax,(const double*) T,
                (const double*) a,J,(const int**) id_T,*nb);
	}
	
    // manage failure
	if (!cvg){
        if (m>=MAXITER){
            *nb = eraseAndWrite(
                    "maximum number of iterations has been reached\n",*nb);
        }
        else { 
            *nb = eraseAndWrite("infinite log-likelihood\n",*nb); 
        }
	}
    else if (m==0){
        *nb = eraseAndWrite("ill-defined starting guess\n",*nb); 
    }
	
	// free memory outside the while loop for speed
	for (i=0; i<J; i++){ free(id_T[i]); }
	free(id_T);
	for (i=0; i<2; i++){ free(id_P[i]); }
	free(id_P);
	for (i=0; i<2*J; i++){ free(id_mat[i]); }
	free(id_mat);
	for (i=0; i<J; i++){ free(id_Jv[i]); }
	free(id_Jv);
	free(id_Jh[0]);
	free(id_Jh);
	
	return cvg;
}


void EstepDPH(double* B, double* Nij, double* Ni, const double* P, 
        const double* a, const double* T, const double* t, int nDt, int J, 
		const int** id_T, const int** id_P, const int** id_Jh, 
        const int** id_Jv, const int** id_mat, double* totCount){
	
	int i = 0, j = 0, n = 0;
	double ta[J*J], Tt[J], Tpow_n[J*J], K_n[J*J], mat[4*J*J], 
            matpow_n[4*J*J], dt, cnt, denom_n, sum_j;
	
	// initialize expectations
	for (i=0; i<J; i++){
		B[i] = 0;
		Ni[i] = 0;
		for (j=0; j<J; j++){
			Nij[id_T[i][j]] = 0;
		}
	}
	
	// vector product {t}*{a}
	matprod(ta,t,a,J,1,J,id_T,id_Jv,id_Jh);
    
    // builds matrix {T ta; 0 T}
	for (i=0; i<2*J; i++){
		for (j=0; j<2*J; j++){
			if (i<J && j<J){ mat[id_mat[i][j]] = T[id_T[i][j]]; }
			else if (i>=J && j>=J){ 
                mat[id_mat[i][j]] = T[id_T[i-J][j-J]]; 
            }
			else if (i>=J && j<J){ mat[id_mat[i][j]] = 0; }
			else if (i<J && j>=J){ mat[id_mat[i][j]] = ta[id_T[i][j-J]]; }
		}
	}
	
	// expectation calculations
    *totCount = 0;
	for (n=0; n<nDt; n++){
		
		dt = P[id_P[0][n]];
		cnt = P[id_P[1][n]];
		denom_n = 0;
		
		// matrix {T ta; 0 T}^(x-1)
		matpow(matpow_n,(const double*) mat,2*J,dt-1,id_mat);
        
        // isolates matrices {T^(x-1)} and {K(x)}
		for (i=0; i<J; i++){
			for (j=0; j<J; j++){
				Tpow_n[id_T[i][j]] = matpow_n[id_mat[i][j]];
				K_n[id_T[i][j]] = matpow_n[id_mat[i][j+J]];
			}
		}
        
        // matrix product {T^(x-1)}*{t}
		matprod(Tt,Tpow_n,t,J,J,1,id_Jv,id_T,id_Jv);

		// denominator {a}*{T^(x-1)}*{t}
		for (i=0; i<J; i++){
			denom_n = denom_n + a[i] * Tt[i];
		}
		if (denom_n<=0 || denom_n!=denom_n){ continue; }
        
        // add dwell time count to total count
        *totCount = *totCount + cnt;
		
		// expectations
		for (i=0; i<J; i++){
			sum_j = 0;
			for (j=0; j<J; j++){
				sum_j = sum_j + a[j] * Tpow_n[id_T[j][i]];
			}
			Ni[i] = Ni[i] + cnt * t[i] * sum_j / denom_n;

			B[i] = B[i] + cnt * a[i] * Tt[i] / denom_n;
			
			if (dt>1){
				for (j=0; j<J; j++){
					Nij[id_T[i][j]] = Nij[id_T[i][j]] + 
                            cnt * T[id_T[i][j]] * K_n[id_T[j][i]] / denom_n;
				}
			}
		}
	}

	return;
}


void MstepDPH(double* a, double* T, double* t, const double* B, 
        const double* Nij, const double* Ni, double totCnt, int J, 
		const int** id_T){
	
	int i = 0, j = 0;
	double sum_i = 0;
    
    // initialize maximizations
	for (i=0; i<J; i++){
		a[i] = 0;
		t[i] = 0;
		for (j=0; j<J; j++){
			T[id_T[i][j]] = 0;
		}
	}

	for (i=0; i<J; i++){
		// initial state probabilities
		a[i] = B[i] / totCnt; 
		
		// transition matrix
		sum_i = 0;
		for (j=0; j<J; j++){
			sum_i = sum_i + Nij[id_T[i][j]];
		}
        if ((Ni[i]+sum_i)>0){
            for (j=0; j<J; j++){
                T[id_T[i][j]] = Nij[id_T[i][j]] / (Ni[i] + sum_i);
            }
            t[i] = Ni[i] / (Ni[i] + sum_i);
        }
	}
	
	return;
}


double calcMaxDev(const double* T, const double* T_prev, const double* a, 
        const double*  a_prev, int J){
	
	double dmax = 0;
	int i = 0;
	for (i=0; i<J*J; i++){
		if(fabs(T[i]-T_prev[i])>dmax){
			dmax = fabs(T[i]-T_prev[i]);
		}
	}
	for (i=0; i<J; i++){
		if(fabs(a[i]-a_prev[i])>dmax){
			dmax = fabs(a[i]-a_prev[i]);
		}
	}
	return dmax;
}


 double calcDPHlogL(const double* T, const double* a, const double* t, 
         const double* P, int J, int nDt, const int** id_T, 
         const int** id_P, const int** id_v){
	
	int i = 0, j = 0;
	double logL = 0, Li = 0;
	double Tpow[J*J], Tt[J];

	for (i=0; i<nDt; i++){
        
        // matrix {T^(x-1)} = {T}^(x-1)
		matpow(Tpow,T,J,(P[id_P[0][i]]-1),id_T);
        
        // vector {Tt} = {T^(x-1)}*{t}
		matprod(Tt,Tpow,t,J,J,1,id_v,id_T,id_v);
        
        // vector product {a}*{Tt}
		Li = 0;
		for (j=0; j<J; j++){
			Li = Li + a[j]*Tt[j];
		}
        
        // likelihood
        if (Li>0){
            logL = logL + P[id_P[1][i]] * log(Li);
        }
	}
	
	return logL;
}


double calcDPHlogL_2(const double* T, const double* a, const double* t, 
        const double* B, const double* Nij, const double* Ni, int J, 
        const int** id_T){
	
	int i = 0, j = 0;
	double logL = 0;

	for (i=0; i<J; i++){
        if (a[i]>0){
            logL = logL + B[i] * log(a[i]); 
        }
        if (t[i]>0){
            logL = logL + Ni[i] * log(t[i]);
        }
		for (j=0; j<J; j++){
            if (T[id_T[i][j]]>0){
                logL = logL + Nij[id_T[i][j]] * log(T[id_T[i][j]]);
            }
		}
	}
	
	return logL;
}

int eraseAndWrite(char* str, int nb){
	char strb[nb+1];
	int i = 0;
	
	// erase previous message
	if (nb>0){
		for (i=0; i<nb; i++){
			strb[i] = '\b';
		}
		strb[nb] = '\0';
		mexPrintf(strb);
	}
	
	// write iteration
	nb = mexPrintf(str);
    
    return nb;
}


int dispDPHres(double m,double dL, double dmax, const double* T, 
        const double* a, int J, const int** id_T, int nb){
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
	nb = mexPrintf("iteration %.0f: dL=%.3e (dLmin=%.0e) d=%.3e\n",m,dL,
            DLMIN,dmax);
	
// 	// write probabilities
// 	nb = nb + mexPrintf("Initial probabilities:\n");
// 	for (i=0; i<J; i++){
// 		nb = nb + mexPrintf("\t%.6f",a[i]);
// 	}
// 	nb = nb + mexPrintf("\n");
// 	
// 	nb = nb + mexPrintf("Transition probabilities:\n");
// 	for (i=0; i<J; i++){
// 		for (j=0; j<J; j++){
// 			nb = nb + mexPrintf("\t%.6f",T[id_T[i][j]]);
// 		}
// 		nb = nb + mexPrintf("\n");
// 	}
	mexEvalString("drawnow;");
	
	return nb;
}


bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	int i = 0;
	char str[100];
	
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
		if (!(mxIsDouble(prhs[i]))){
			sprintf(str,"Input argument %i must be of type double.",i+1);
			mexErrMsgTxt(str);
			return 0;
		}
	}
	
	/* Check for dimensions */
	
	int J = (int) mxGetNumberOfElements(prhs[0]);
	if (J<=0){
		mexErrMsgTxt("Input (1) must contain at least one element.");
		return 0;
	}int K = (int) mxGetNumberOfElements(prhs[2]);
	if (K!=J){
		mexErrMsgTxt("Input (1) and (3) must contain the same number of elements.");
		return 0;
	}
	int J1 = (int) mxGetM(prhs[1]);
	if (J1!=J){
		mexErrMsgTxt("The numbers of elements in inputs (1) and (3) must be equal to the number of rows in input (2).");
		return 0;
	}
	int J2 = (int) mxGetN(prhs[1]);
	if (J2!=J1){
		mexErrMsgTxt("The numbers of columns and rows in input (2) must be equal.");
		return 0;
	}
	
	int nRows = (int) mxGetM(prhs[3]);
	int nDt = (int) mxGetN(prhs[3]);
	if (nRows!=2){
		mexErrMsgTxt("Input(4) must have 2 rows.");
		return 0;
	}
	if (nDt<1){
		mexErrMsgTxt("Input(4) must have at least 1 column.");
		return 0;
	}

	return 1;
}