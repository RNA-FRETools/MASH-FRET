//Mex-Interface for SPE import

#include "mex.h"
#include "ITASL_Extra.h"
#include "type_def.h"

/*
 * left-hand-side-output (plhs) none
 * right-hand-side-input (prhs) string fileName
*/ 

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{ 
    mwSize buflen;
    char* fileName;
    
    /* check proper input and output */
    if(nrhs != 1) 
        mexErrMsgTxt("One input required.");
        
    /* input must be a string */
    if ( mxIsChar(prhs[0]) != 1)
      mexErrMsgTxt("Input must be a string.");
    
    /* input must be a row vector */
    if (mxGetM(prhs[0])!=1)
      mexErrMsgTxt("Input must be a row vector.");
    
    /* get the length of the input string */

    buflen = (mxGetM(prhs[0]) * mxGetN(prhs[0])) + 1;
    
    fileName = mxArrayToString(prhs[0]);
    
    if(fileName == NULL)
        mexErrMsgTxt("Could not convert input to string.");     
    
    ConvertToAVI(fileName, buflen);    

    
    mxFree(fileName);    

}