/* 
 * Dwell times must be in number of frames (or time bins)
 *
 * [a,T,logL] = trainDPH(a0,T0,cnts)
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "mex.h"
#include "fwdbwd.h"
#include "vectop.h"
#include "trainPH.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	// check input and output arguments
	if (!validArg(nlhs, plhs, nrhs, prhs)){
		return;
	}
	
	// get input dimensions
	int J = (int) mxGetN(prhs[1]);
	int nDt = (int) mxGetN(prhs[3]);
	
	// get input values
	double *a0 = (double *) mxGetDoubles(prhs[0]); // starting initial state prob.
	double *T0 = (double *) mxGetDoubles(prhs[1]); // starting transition matrix
	double *cnts = (double *) mxGetDoubles(prhs[2]); // dwell times and counts
	
	// prepare output
	plhs[0] = mxCreateDoubleMatrix(1,J,mxREAL); // PH initial state prob.
	plhs[1] = mxCreateDoubleMatrix(J,J,mxREAL); // PH transition matrix
	plhs[2] = mxCreateDoubleScalar(0); // Likelihood of PH given the dwell times
	double *T = mxGetDoubles(plhs[0]);
	double *a = mxGetDoubles(plhs[1]);
	double *logL = mxGetDoubles(plhs[2]);
	
	
	// train PH
	setVect(T,T0,J*J);
	setVect(a,a0,J);
	optPH(T,a,logL,(const double*) cnts,J,nDt);
	
	return;
}


void optPH(double* T, double* a, double* logL, (const double*) cnts, int J, int nDt){
	
	
	return;
}


bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	/*[a,T,logL,actstr] = trainPH(PH_type,a0,T0,P)*/
	
	/* Declare variables */
	int i = 0;
	
	/* Check for proper number of input and output arguments. */    
	if (nrhs!=3) {
		mexErrMsgTxt("Three input arguments are required.");
		return 0;
	} 
	if (nlhs>3) {
		mexErrMsgTxt("Too many output arguments.");
		return 0;
	}

	/* Check for proper data type in input arguments. */
	for (i==0; i<nrhs; i++){
		if (!(mxIsDouble(prhs[i]))){
			mexErrMsgTxt("Input argument %i must be of type double.",i+1);
			return 0;
		}
	}
	
	/* Check for dimensions */
	
	int J = (int) mxGetNumberOfElements(prhs[0]);
	int J1 = (int) mxGetM(prhs[1]);
	if (J1!=J){
		mexErrMsgTxt("The numbers of elements in input (1) and of rows in input (2) must be equal.");
		return 0;
	}
	int J2 = (int) mxGetN(prhs[1]);
	if (J2!=J1){
		mexErrMsgTxt("The numbers of columns and rows in input (2) must be equal.");
		return 0;
	}
	
	int nRows = (int) mxGetM(prhs[2]);
	int nDt = (int) mxGetN(prhs[2]);
	if (nRows!=2){
		mexErrMsgTxt("Input(3) must have 2 rows.");
		return 0;
	}
	if (nDt<3){
		mexErrMsgTxt("Input(3) must have at least 3 columns.");
		return 0;
	}

	return 1;
}