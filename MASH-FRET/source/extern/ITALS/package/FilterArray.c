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
	
	mwSize width, height, nFilter;
	mwIndex jstruct;  //current structure element
	mwSize NStructElems; //number of structure elements, i.e. number of filters
	mxArray *tmp; //temporary array to store struct data
	mwSize ndim, dataSize;
	const mwSize *dims;

	bool withBackg = false;

	struct filterSet fP[] = {{-1,0.0,0.0},{-1,0.0,0.0},{-1,0.0,0.0}};
	axpSInt8* pINT8DataIn;
	axpSInt8* pINT8DataOut;
	axpSInt8* pINT8DataBackg;
	axpUInt8* pUINT8DataIn;
	axpUInt8* pUINT8DataOut;
	axpUInt8* pUINT8DataBackg;
	axpSInt16* pINT16DataIn;
	axpSInt16* pINT16DataOut;
	axpSInt16* pINT16DataBackg;
	axpUInt16* pUINT16DataIn;
	axpUInt16* pUINT16DataOut;
	axpUInt16* pUINT16DataBackg;
	axpSInt32* pINT32DataIn;
	axpSInt32* pINT32DataOut;
	axpSInt32* pINT32DataBackg;
	axpUInt32* pUINT32DataIn;
	axpUInt32* pUINT32DataOut;
	axpUInt32* pUINT32DataBackg;
	axpSInt64* pINT64DataIn;
	axpSInt64* pINT64DataOut;
	axpSInt64* pINT64DataBackg;
	axpUInt64* pUINT64DataIn;
	axpUInt64* pUINT64DataOut;
	axpUInt64* pUINT64DataBackg;
	axpReal32* pFLOATDataIn;
	axpReal32* pFLOATDataOut;
	axpReal32* pFLOATDataBackg;
	axpReal64* pDOUBLEDataIn;
	axpReal64* pDOUBLEDataOut;
	axpReal64* pDOUBLEDataBackg;

	size_t nFilters;
	
    mwSize buflen,buflen2,i;
    const char *field_names[] = {"filter", "P1", "P2"};
	char* filtername;
	char* buffer;
	  
    /* check proper input and output */
    if(nrhs < 2) 
        mexErrMsgTxt("At least one filter has to be spezified.\n");
    else if(nrhs > 2)
		mexErrMsgTxt("Too many input arguments.\n");

	if(2 == nlhs)
		withBackg = true;

	NStructElems = mxGetNumberOfElements(prhs[1]);
	//mexPrintf("Number of filters %d \n", NStructElems);

	nFilters = 0;

	for(jstruct = 0; jstruct < NStructElems; jstruct++) {
		bool filtererror = false;
		bool othererror = false;
		if(nFilters == 2) {
			mexPrintf("more than 3 filters in a row => additional filters ignored\n");
			break;
		}		
		//first filter specifier
		tmp = mxGetField(prhs[1], jstruct, field_names[0]);
		if(tmp == NULL) {
			mexPrintf("The filter field with number %d is empty!\n", jstruct +1);
			filtererror = true;
		} else if(!mxIsChar(tmp)) {
			mexPrintf("The filter field with number %d must have string data.\n", jstruct+1);
			filtererror = true;
		} else {
			buflen = (mxGetM(tmp) * mxGetN(tmp)) + 1;
			filtername = mxArrayToString(tmp);
			if(strcmp(filtername, "none") == 0) {
				fP[jstruct].filtertype = -1;
			} else if(strcmp(filtername, "gauss") == 0) {
				fP[jstruct].filtertype = 0;
			} else if(strcmp(filtername, "mean") == 0) {
				fP[jstruct].filtertype = 1;
			} else if(strcmp(filtername, "median") == 0) {
				fP[jstruct].filtertype = 4;
			} else if(strcmp(filtername, "ggf") == 0) {
				fP[jstruct].filtertype = 5;
			} else if(strcmp(filtername, "lwf") == 0) {
				fP[jstruct].filtertype = 6;
			} else if(strcmp(filtername, "gwf") == 0) {
				fP[jstruct].filtertype = 7;
			} else if(strcmp(filtername, "outlier") == 0) {
				fP[jstruct].filtertype = 11;
			} else if(strcmp(filtername, "histotresh") == 0) {
				fP[jstruct].filtertype = 12;
			} else if(strcmp(filtername, "simpletresh") == 0) {
				fP[jstruct].filtertype = 13;
			} else {
				mexPrintf("The filter %s is not known!", filtername);
			}
		}
		tmp = mxGetField(prhs[1], jstruct, field_names[1]);
		if(tmp == NULL) {
			mexPrintf("The P1 field of filter %d is empty !\n", jstruct +1);
			othererror = true;
		} else if(mxIsComplex(tmp) || mxGetNumberOfElements(tmp)!=1) {
			mexPrintf("The P1 field of filter %d must be scalar and noncomplex!\n", jstruct+1);
			othererror = true;
		} else {
				if(mxIsNumeric(tmp))
					fP[jstruct].P1 = (double)mxGetScalar(tmp);
				else {
					buflen2 = (mxGetM(tmp) * mxGetN(tmp)) + 1;
					buffer = mxArrayToString(tmp);
					fP[jstruct].P1 = atof(buffer);
					mxFree(buffer);
				}
		}
		tmp = mxGetField(prhs[1], jstruct, field_names[2]);
		if(fP[jstruct].filtertype == 5 || fP[jstruct].filtertype == 6 || fP[jstruct].filtertype == 11 ) {
			if(tmp == NULL) {
				mexPrintf("The P2 field of filter %d is empty, the filter %s needs the second parameter set!\n", jstruct +1, filtername);
				othererror = true;
			} else if(mxIsComplex(tmp) || mxGetNumberOfElements(tmp)!=1) {
				mexPrintf("The P2 field of filter %d must be scalar and noncomplex!\n", jstruct+1);
				othererror = true;
			} else {
				if(mxIsNumeric(tmp))
					fP[jstruct].P2 = (double)mxGetScalar(mxGetField(prhs[1], jstruct, field_names[1]));
				else {
					buflen2 = (mxGetM(tmp) * mxGetN(tmp)) + 1;
					buffer = mxArrayToString(tmp);
					fP[jstruct].P2 = atof(buffer);
					mxFree(buffer);
				}
			}
		}
		if(!filtererror){
			mxFree(filtername);
			if(othererror) {
				mexPrintf("something is not set properly => no filtering!");
				return;
			}
		} else if(othererror) {
			mexPrintf("something is not set properly => no filtering!");
			return;
		}
		nFilters++;

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
	//mexPrintf("dataSize = %d, width = %d, height = %d", dataSize, height, width);
   //do nothing now
	if(mxIsInt8(prhs[0])) {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxINT8_CLASS, mxREAL);
		pINT8DataIn = mxGetPr(prhs[0]);
		pINT8DataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxINT8_CLASS, mxREAL);
			pINT8DataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix	
			if(withBackg)
				filterArrayInt8Back(pINT8DataIn,pINT8DataOut, pINT8DataBackg, width, height,fP,nFilters);
			else
				filterArrayInt8(pINT8DataIn,pINT8DataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayInt8Back(&pINT8DataIn[i*dataSize],&pINT8DataOut[i*dataSize], &pINT8DataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayInt8(&pINT8DataIn[i*dataSize],&pINT8DataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else if(mxIsUint8(prhs[0])) {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxUINT8_CLASS, mxREAL);
		pUINT8DataIn = mxGetPr(prhs[0]);
		pUINT8DataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxUINT8_CLASS, mxREAL);
			pUINT8DataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix	
			if(withBackg)
				filterArrayUInt8Back(pUINT8DataIn,pUINT8DataOut,pUINT8DataBackg , width, height,fP,nFilters);
			else
				filterArrayUInt8(pUINT8DataIn,pUINT8DataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayUInt8Back(&pINT8DataIn[i*dataSize],&pUINT8DataOut[i*dataSize], &pUINT8DataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayUInt8(&pUINT8DataIn[i*dataSize],&pUINT8DataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else if(mxIsInt16(prhs[0])) {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxINT16_CLASS, mxREAL);
		pINT16DataIn = mxGetPr(prhs[0]);
		pINT16DataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxINT16_CLASS, mxREAL);
			pINT16DataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix	
			if(withBackg)
				filterArrayInt16Back(pINT16DataIn,pINT16DataOut, pINT16DataBackg, width, height,fP,nFilters);
			else
				filterArrayInt16(pINT16DataIn,pINT16DataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayInt16Back(&pINT16DataIn[i*dataSize],&pINT16DataOut[i*dataSize], &pINT16DataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayInt16(&pINT16DataIn[i*dataSize],&pINT16DataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else if(mxIsUint16(prhs[0])) {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxUINT16_CLASS, mxREAL);
		pUINT16DataIn = mxGetPr(prhs[0]);
		pUINT16DataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxUINT16_CLASS, mxREAL);
			pUINT16DataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix		
			if(withBackg)
				filterArrayUInt16Back(pUINT16DataIn,pUINT16DataOut, pUINT16DataBackg, width, height,fP,nFilters);
			else
				filterArrayUInt16(pUINT16DataIn,pUINT16DataOut, width, height,fP,nFilters);
		} else{
			if(withBackg){
				for(i = 0; i< dims[2]; ++i) {
					filterArrayUInt16Back(&pUINT16DataIn[i*dataSize],&pUINT16DataOut[i*dataSize], &pUINT16DataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayUInt16(&pUINT16DataIn[i*dataSize],&pUINT16DataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else if(mxIsInt32(prhs[0])) {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxINT32_CLASS, mxREAL);
		pINT32DataIn = mxGetPr(prhs[0]);
		pINT32DataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxINT32_CLASS, mxREAL);
			pINT32DataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix
			if(withBackg)
				filterArrayInt32Back(pINT32DataIn,pINT32DataOut, pINT32DataBackg, width, height,fP,nFilters);
			else
				filterArrayInt32(pINT32DataIn,pINT32DataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayInt32Back(&pINT32DataIn[i*dataSize],&pINT32DataOut[i*dataSize], &pINT32DataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayInt32(&pINT32DataIn[i*dataSize],&pINT32DataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else if(mxIsUint32(prhs[0])) {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxUINT32_CLASS, mxREAL);
		pUINT32DataIn = mxGetPr(prhs[0]);
		pUINT32DataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxUINT32_CLASS, mxREAL);
			pUINT32DataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix
			if(withBackg) 
				filterArrayUInt32Back(pUINT32DataIn,pUINT32DataOut, pUINT32DataBackg, width, height,fP,nFilters);
			else
				filterArrayUInt32(pUINT32DataIn,pUINT32DataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayUInt32Back(&pUINT32DataIn[i*dataSize],&pUINT32DataOut[i*dataSize], &pUINT32DataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayUInt32(&pUINT32DataIn[i*dataSize],&pUINT32DataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else if(mxIsInt64(prhs[0])) { //64bit integer not supported up to now
		plhs[0] = mxCreateNumericArray(ndim, dims, mxINT64_CLASS, mxREAL);
		pINT64DataIn = mxGetPr(prhs[0]);
		pINT64DataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxINT64_CLASS, mxREAL);
			pINT64DataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix	
			if(withBackg) 
				filterArrayInt64Back(pINT64DataIn,pINT64DataOut, pINT64DataBackg, width, height,fP,nFilters);
			else
				filterArrayInt64(pINT64DataIn,pINT64DataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayInt64Back(&pINT64DataIn[i*dataSize],&pINT64DataOut[i*dataSize], &pINT64DataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayInt64(&pINT64DataIn[i*dataSize],&pINT64DataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else if(mxIsUint64(prhs[0])) {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxUINT32_CLASS, mxREAL);
		pUINT64DataIn = mxGetPr(prhs[0]);
		pUINT64DataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxUINT64_CLASS, mxREAL);
			pUINT64DataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix	
			if(withBackg) 
				filterArrayUInt64Back(pUINT64DataIn,pUINT64DataOut, pUINT64DataBackg, width, height,fP,nFilters);
			else 
				filterArrayUInt64(pUINT64DataIn,pUINT64DataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayUInt64Back(&pUINT64DataIn[i*dataSize],&pUINT64DataOut[i*dataSize], &pUINT64DataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayUInt64(&pUINT64DataIn[i*dataSize],&pUINT64DataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else if(mxIsSingle(prhs[0])) {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxSINGLE_CLASS, mxREAL);
		pFLOATDataIn = mxGetPr(prhs[0]);
		pFLOATDataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxSINGLE_CLASS, mxREAL);
			pFLOATDataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix	
			if(withBackg) 
				filterArrayReal32Back(pFLOATDataIn,pFLOATDataOut, pFLOATDataBackg, width, height,fP,nFilters);
			else
				filterArrayReal32(pFLOATDataIn,pFLOATDataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayReal32Back(&pFLOATDataIn[i*dataSize],&pFLOATDataOut[i*dataSize],&pFLOATDataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayReal32(&pFLOATDataIn[i*dataSize],&pFLOATDataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	} else {
		plhs[0] = mxCreateNumericArray(ndim, dims, mxDOUBLE_CLASS, mxREAL);
		pDOUBLEDataIn = mxGetPr(prhs[0]);
		pDOUBLEDataOut  = mxGetPr(plhs[0]);
		if(withBackg) {
			plhs[1]  = mxCreateNumericArray(ndim, dims, mxDOUBLE_CLASS, mxREAL);
			pDOUBLEDataBackg  = mxGetPr(plhs[1]);
		}
		if(ndim == 2 || dims[2] == 1) {//onedimensional matrix	
			if(withBackg) 
				filterArrayReal64Back(pDOUBLEDataIn,pDOUBLEDataOut, pDOUBLEDataBackg, width, height,fP,nFilters);
			else
				filterArrayReal64(pDOUBLEDataIn,pDOUBLEDataOut, width, height,fP,nFilters);
		} else{
			if(withBackg) {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayReal64Back(&pDOUBLEDataIn[i*dataSize],&pDOUBLEDataOut[i*dataSize], &pDOUBLEDataBackg[i*dataSize], width, height,fP,nFilters);
				}
			} else {
				for(i = 0; i< dims[2]; ++i) {
					filterArrayReal64(&pDOUBLEDataIn[i*dataSize],&pDOUBLEDataOut[i*dataSize], width, height,fP,nFilters);
				}
			}
		}
	}

}