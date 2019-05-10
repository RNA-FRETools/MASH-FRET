//Mex-Interface for Array Filtering

#include "mex.h"
#include "ITASL_Extra.h"
#include "type_def.h"
#include <string.h>
/*
 * left-hand-side-output (plhs) [height,width,frames] size filtered matrix
 * right-hand-side-input (prhs) [height,width,frames(optional)] size matrix, structure with {string filter; double P1 ; double P2(opt)} which defines the filter
*/ 

void mexFunction(int nlhs, mxArray *plhs[],
                 int nrhs, const mxArray *prhs[])
{ 
	
	mwSize width, height, TWidth, THeight, ndimT, dimsT[2];
	mwIndex jstruct;  //current structure element
	mwSize NStructElems; //number of structure elements, i.e. number of filters
	mxArray *tmp; //temporary array to store struct data
	mwSize ndim, dataSize;
	const mwSize *dims;

	struct trackSetup tS = {0,0,0,0.0,1};
	
	axpReal64* pDOUBLEDataIn;
	axpReal64* pDOUBLEDataOut;
	
    mwSize buflen,buflen2,i;
    const char *field_names[] = {"method", "cutoffRadius", "memSize"};
	char* filtername;
	char* buffer;
	  
    /* check proper input and output */
    if(nrhs < 1) 
        mexErrMsgTxt("No Point Array!\n");
    else if(nrhs < 2) 
		mexPrintf("No tracking configuration given, assuming standard configuration!\n method->0; cutoffRadius->1; memSize->1");
	if(nrhs > 2)
		mexErrMsgTxt("Too many input arguments.\n");

	if(nrhs == 2) {
		NStructElems = mxGetNumberOfElements(prhs[1]);
		//mexPrintf("Number of filters %d \n", NStructElems);

		for(jstruct = 0; jstruct < NStructElems; jstruct++) {
			//method specifier
			tmp = mxGetField(prhs[1], jstruct, field_names[0]);
			if(tmp == NULL || !mxIsNumeric(tmp)) {		
				mexPrintf("no tracking method spezified, assuming method = 0\n");
				tS.method = 0;
			} else {
				tS.method = (int)mxGetScalar(tmp);
				if(tS.method != 1 && tS.method != 0 ) {
					mexPrintf("invalid method chosen->set to 0\n");
					tS.method = 0;
				}
			}
			tmp = mxGetField(prhs[1], jstruct, field_names[1]);
			if(tmp == NULL || !mxIsNumeric(tmp)) {		
				mexPrintf("no proper cutoffRadius set, assuming cutoff = 1.0\n");
				tS.cutoffRadius = 1.0;
			} else {
				tS.cutoffRadius = (double)mxGetScalar(tmp);
				if(tS.cutoffRadius  < 0.0) {
					mexPrintf("negative cutoffRadius->set to 1.0\n");
					tS.cutoffRadius = 1.0;
				}
			}		
			tmp = mxGetField(prhs[1], jstruct, field_names[2]);
			if(tmp == NULL || !mxIsNumeric(tmp)) {		
				mexPrintf("no proper cutoffRadius set, assuming cutoff = 1.0\n");
				tS.memSize = 1;
			} else {
				tS.memSize = (int)mxGetScalar(tmp);
				if(tS.memSize < 1) {
					mexPrintf("incorred memSize->set to 1\n");
					tS.memSize = 1;
				}
			}
		}
	} else {
		tS.method = 0;
		tS.cutoffRadius = 1.0;
		tS.memSize = 1;
	}
	//mexPrintf("fp[0].filter = %d, fp[0].P1 = %f, fp[0].P2 = %f\n", fP[0].filtertype, fP[0].P1, fP[0].P2);
	//mexPrintf("fp[1].filter = %d, fp[1].P1 = %f, fp[1].P2 = %f\n", fP[1].filtertype, fP[1].P1, fP[1].P2);
	//mexPrintf("fp[2].filter = %d, fp[2].P1 = %f, fp[2].P2 = %f\n", fP[2].filtertype, fP[2].P1, fP[2].P2);

	//data dimensions
	dims = mxGetDimensions(prhs[0]);
	ndim = mxGetNumberOfDimensions(prhs[0]);
	dataSize = dims[0]*dims[1];
	height = dims[0];
	width = dims[1];
	tS.height = (int)height;
	tS.width = (int)width;	
	
	pDOUBLEDataIn = mxGetPr(prhs[0]);
	if(SetupAndTrackData(pDOUBLEDataIn, &tS,true)) {
		TWidth = (mwSize)getTSizeX();
		THeight = (mwSize)getTSizeY();
		ndimT = 2;
        dimsT[0] = THeight;
		dimsT[1] = TWidth;
		plhs[0] = mxCreateNumericArray(ndimT, dimsT, mxDOUBLE_CLASS, mxREAL);
		pDOUBLEDataOut  = mxGetPr(plhs[0]);
		getTData(pDOUBLEDataOut);
	} else  mexErrMsgTxt("Unable to read data");	

}