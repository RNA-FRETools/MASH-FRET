//Mex-Interface for SPE import

#include "mex.h"
#include "ITASL_Extra.h"
#include "type_def.h"

#define NUMBER_OF_STRUCTS (sizeof(fI)/sizeof(struct fileInfo))
#define NUMBER_OF_FIELDS (sizeof(field_names)/sizeof(*field_names))

/*
 * left-hand-side-output (plhs) [height,width,frames] size matrix, structure with {	int width; int height; int frames; int dataSize; string format; float exposure; string fileType; bool bReadable;}
 * right-hand-side-input (prhs) string fileName
*/

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{ 
    mwSize buflen;
    const char *field_names[] = {"height", "width", "frames", "dataSize", "format", "exposure", "fileType", "bReadable" };
	const char *format_names[] = {"float", "int32", "int16", "uint16", "uint8"};
    struct fileInfo fI[] = {{0,0,0,0,0,0.0,"SPE0",false}};
    char* fileName;
	axpUInt8* pUINT8Data;
	axpUInt16* pUINT16Data;
	axpSInt16* pINT16Data;
	axpSInt32* pINT32Data;
	axpReal64* pDOUBLEData;

    mwIndex i;
	mwSize dims[2] = {1, NUMBER_OF_STRUCTS};
    
    /* check proper input and output */
    if(nrhs != 1) 
        mexErrMsgTxt("One input required.");
    else if(nlhs > 2)
      mexErrMsgTxt("Too many output arguments.");
        
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
    
  
    
    
    if(loadSPEFile(fileName, buflen, &fI[0])) {
        mwSize ndim = 3;
        mwSize dims[] = {fI[0].height, fI[0].width, fI[0].frames};
        if(fI[0].format == 4) {//unsigned byte            
            plhs[0] = mxCreateNumericArray(ndim, dims, mxUINT8_CLASS, mxREAL);
			pUINT8Data = mxGetPr(plhs[0]);
            getDataUInt8(pUINT8Data, &fI[0]);
        } else if(fI[0].format == 3) {//unsigned short            
            plhs[0] = mxCreateNumericArray(ndim, dims, mxUINT16_CLASS, mxREAL);
			pUINT16Data = mxGetPr(plhs[0]);
            getDataUInt16(pUINT16Data, &fI[0]);
        } else if(fI[0].format == 2) {//short            
            plhs[0] = mxCreateNumericArray(ndim, dims, mxINT16_CLASS, mxREAL);
			pINT16Data = mxGetPr(plhs[0]);
            getDataInt16(pINT16Data, &fI[0]);
        } else if(fI[0].format == 1) {//int            
            plhs[0] = mxCreateNumericArray(ndim, dims, mxUINT32_CLASS, mxREAL);
			pINT32Data = mxGetPr(plhs[0]);
            getDataInt32(pINT32Data, &fI[0]);
        } else {               
            plhs[0] = mxCreateNumericArray(ndim, dims, mxDOUBLE_CLASS, mxREAL);
            pDOUBLEData = mxGetPr(plhs[0]);
            getDataReal64(pDOUBLEData, &fI[0]);
         }
    } else 
        mexErrMsgTxt("Unable to open File");
    
	plhs[1] = mxCreateStructArray(2, dims, NUMBER_OF_FIELDS, field_names);
	
    for (i=0; i<NUMBER_OF_STRUCTS; i++) {
        mxSetFieldByNumber(plhs[1],i, 0, mxCreateDoubleScalar(fI[i].height));          
        mxSetFieldByNumber(plhs[1],i, 1, mxCreateDoubleScalar(fI[i].width));
        mxSetFieldByNumber(plhs[1],i, 2, mxCreateDoubleScalar(fI[i].frames));       
        mxSetFieldByNumber(plhs[1],i, 3, mxCreateDoubleScalar(fI[i].dataSize));        
        mxSetFieldByNumber(plhs[1],i, 4, mxCreateString(format_names[fI[i].format]));//mxCreateDoubleScalar(fI[i].format));
		mxSetFieldByNumber(plhs[1],i, 5, mxCreateDoubleScalar(fI[i].exposure));
		mxSetFieldByNumber(plhs[1],i, 6, mxCreateString(fI[i].fileType));		
        mxSetFieldByNumber(plhs[1],i, 7, mxCreateLogicalScalar(fI[i].bReadable));
    }  
     

    
    mxFree(fileName);    

}