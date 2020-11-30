/* 
 * Takes 3D-data (count,x,y), minimum and maximum model complexities 
 * (number of Gaussians), model description (shape and configuration 
 * of Gaussians) and likelihood calculation type (complete or 
 * incomplete data) in input.
 * Train Gaussian mixture models on data for input complexities.
 * Returns GMM parameters, data probabilities and log-likelihoods 
 * for each complexities
 *
 * Corresponding MATLAB executing command:
 * [mdlprm,prob,logL] = trainGMM(dat,Vmin,Vmax,cnstr,shape,lklhd)
 *
 * MEX-compilation command:
 * mex  -R2018a -O trainGMM.c vectop.c
 *
 * This is a MEX-file for MATLAB.  
 * Written by Mélodie C.A.S Hadzic, 29.11.2020
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include "mex.h"
#include "vectop.h"
#include "trainGMM.h"

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	int i = 0, j = 0, k = 0; //loop index
	
	// check input and output arguments
	if (!validArg(nlhs, plhs, nrhs, prhs)){
		return;
	}
	
	// get input dimensions
	int nTrs = (int) mxGetN(prhs[0]);
	
	// get input values
	const double *dat = (const double *) mxGetDoubles(prhs[0]); // transitions (FRET before,FRET after,count)
	const double *Vmin = (const double *) mxGetDoubles(prhs[1]); // maximum complexity
	const double *Vmax = (const double *) mxGetDoubles(prhs[2]); // minimum complexity
	const double *cnstr = (const double *) mxGetDoubles(prhs[3]); // constraint on cluster config
	const double *shape = (const double *) mxGetDoubles(prhs[4]); // cluster shape
	const double *lklhd = (const double *) mxGetDoubles(prhs[5]); // likelihood calculation
	
	// get model complexities
	int nV = (int) (*Vmax-*Vmin);
	int V[nV];
	for (i=0; i<nV; i++){
		V[i] = *Vmin+i;
	}
	
	// build matrix indexes
	int **id_dat = (int **)malloc(3 * sizeof(int*));
	for (i=0; i<3; i++){
		id_dat[i] = (int *)malloc(nTrs * sizeof(int));
	}
	int ***id_cov = (int ***)malloc(2 * sizeof(int **));
	for (i=0; i<2; i++){
		id_cov[i] = (int **)malloc(2 * sizeof(int *));
	}
	int **id_w = NULL, **id_prob = NULL;
	
	// prepare output
	int nfields = 3;
	const mwSize sz[] = {1,nV}, cov_sz[] = {2,2,V[i]};
	const char *fieldnames[] = {"mu","weight","cov"};
	
	plhs[0] = mxCreateStructArray((mwSize) 2,sz,nfields,fieldnames); // model parameters
	plhs[1] = mxCreateCellArray((mwSize) 2,sz); // data probabilities
	plhs[2] = mxCreateDoubleMatrix((mwSize) 1,(mwSize) nV, mxREAL); // log-likelihoods
	
	double *logL = mxGetDoubles(plhs[2]);
	double **mu = (double **) malloc(nV * sizeof(double *));
	double **w = (double **) malloc(nV * sizeof(double *));
	double **cov = (double **) malloc(nV * sizeof(double *));
	double **prob = (double **) malloc(nV * sizeof(double *));
	mxArray *dummy = NULL;
	

	// loop throught model complexities
	for (i=0; i<nV; i++){
		
		// prepare structure outpout
		dummy = mxGetField((const mxArray *) plhs[0],(mwIndex) i,"mu");
		dummy = mxCreateDoubleMatrix((mwSize) V[i],(mwSize) 1,mxREAL);
		mu[i] = mxGetDoubles(dummy);
		
		dummy = mxGetField((const mxArray *) plhs[0],(mwIndex) i,"weight");
		dummy = mxCreateDoubleMatrix((mwSize) V[i],(mwSize) V[i],mxREAL);
		w[i] = mxGetDoubles(dummy);

		dummy = mxGetField((const mxArray *) plhs[0],(mwIndex) i,"cov");
		dummy = mxCreateNumericArray((mwSize) 3, cov_sz, mxDOUBLE_CLASS, mxREAL);
		cov[i] = mxGetDoubles(dummy);
		
		// prepare cell array output
		dummy = mxGetCell((const mxArray *) plhs[1],(mwIndex) i);
		dummy = mxCreateDoubleMatrix((mwSize) V[i],(mwSize) nTrs,mxREAL);
		prob[i] = mxGetDoubles(dummy);
		
		// set matrix indexes
		for (j=0; j<2; j++){
			for (k=0; k<2; k++){
				id_cov[j][k] = (int *)malloc(V[i] * sizeof(int));
			}
		}
		id_w = (int **)malloc(V[i] * sizeof(int *));
		id_prob = (int **)malloc(V[i] * sizeof(int *));
		for (j=0; j<V[i]; j++){
			id_w[j] = (int *)malloc(V[i] * sizeof(int));
			id_prob[j] = (int *)malloc(nTrs * sizeof(int));
		}
		
		// get starting guess with kmeans
		getStartGMM(dat,nTrs,*cnstr,*shape,V[i],mu[i],w[i],cov[i]);

		// train GMM
		optGMM(dat,nTrs,*cnstr,*shape,*lklhd,V[i],mu[i],w[i],cov[i],prob[i],&(logL[i]));
		
		//free memory
		for (j=0; j<2; j++){
			for (k=0; k<2; k++){
				free(id_cov[j][k]);
			}
		}
		for (j=0; j<V[i]; j++){
			free(id_w[j]);
			free(id_prob[j]);
		}
		free(id_w);
		free(id_prob);
		
	}

	//free memory
	for (i=0; i<3; i++){
		free(id_dat[i]);
	}
	free(id_dat);
	for (i=0; i<2; i++){
		free(id_cov[i]);
	}
	free(id_cov);
	free(mu);
	free(w);
	free(cov);
	free(prob);

	mexPrintf("done!\n");
	
	return;
}


bool getStartGMM(const double* dat, int nTrs, double cnstr, double shape, int V, 
		double* mu, double* w, double* cov){

	return 1;
}

bool optGMM(const double* dat, int nTrs, double cnstr, double shape, double lklhd, int V, 
		double* mu, double* w, double* cov, double* prob, double* logL){

	return 1;
}


bool validArg(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){
	
	/*[mdlprm,prob,logL] = trainGMM(dat,Vmin,Vmax,cnstr,shape,lklhd)*/
	
	int i = 0;
	char str[100];
	
	/* Check for proper number of input and output arguments. */    
	if (nrhs!=6) {
		mexErrMsgTxt("Six input arguments are required.");
		return 0;
	} 
	if (nlhs>3) {
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
	
	int D = (int) mxGetM(prhs[0]);
	if (D!=3){
		mexErrMsgTxt("Input (1) must have 3 rows.");
		return 0;
	}
	D = (int) mxGetN(prhs[0]);
	if (D<3){
		mexErrMsgTxt("Input (1) must have at least 3 columns.");
		return 0;
	}
	D = (int) mxGetNumberOfElements(prhs[1]);
	if (D!=1){
		mexErrMsgTxt("Input (2) must be scalar.");
		return 0;
	}
	D = (int) mxGetNumberOfElements(prhs[2]);
	if (D!=1){
		mexErrMsgTxt("Input (3) must be scalar.");
		return 0;
	}
	D = (int) mxGetNumberOfElements(prhs[3]);
	if (D!=1){
		mexErrMsgTxt("Input (4) must be scalar.");
		return 0;
	}
	D = (int) mxGetNumberOfElements(prhs[4]);
	if (D!=1){
		mexErrMsgTxt("Input (5) must be scalar.");
		return 0;
	}
	D = (int) mxGetNumberOfElements(prhs[5]);
	if (D!=1){
		mexErrMsgTxt("Input (6) must be scalar.");
		return 0;
	}

	return 1;
}