/*
ITALS - image tools and spot library
This program is designed for simulation and analysis of diffusion processes in thin liquid layers.
.
Copyright (C) [2011-2012] [Mario Heidernätsch]

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>
*/

#ifndef __ITASL_EXTRA_H__
#define __ITASL_EXTRA_H__

#ifndef EXPORT
#define EXPORT
#endif

struct fileInfo{
	int width;
	int height;
	int frames;
	int dataSize; //width*height*frames
	int format; //0->float, 1->long int, 2->int, 3->uint
	float exposure; //exposure time or inverse of fps
	char fileType[4]; //"SPE","SIF" or "AVI"
	bool bReadable; //file readable or not
};

struct filterSet{
	int filtertype; //type of filter see filterbox.h
	double P1; //parameter 1 of filter
	double P2; //evt. parameter 2 of filter
};

struct trackSetup{
	int width, height; //dimensions of the dataset
	int method;
	double cutoffRadius;
	int memSize;
};

#if defined(_MSC_VER)
//	EXPORT void foo();
	
	//sets up the spottracker adn does tracking
	EXPORT bool SetupAndTrackData(double *data, struct trackSetup* config, bool bIOistransposed);

	//get width of the tracjetory data
	EXPORT signed __int32 getTSizeX();

	//get height of the tracjetory data
	EXPORT signed __int32 getTSizeY();

	//gets trajectory data and resets spottracker
	EXPORT void getTData(double *Tdata);

	//function to convert a SIF or a SPE file to 256 Bit greyscale AVI file
	EXPORT void ConvertToAVI(const char* fileName, size_t strlen);

	//function to read an SPE, SIF or AVI file, calls on of the subsequent functions
	EXPORT bool loadFile(const char* fileName, size_t strlen, struct fileInfo* fI);

	//function to read an SPE file 
	EXPORT bool loadSPEFile(const char* fileName, size_t strlen, struct fileInfo* fI);

	//function to read an SIF file 
	EXPORT bool loadSIFFile(const char* fileName, size_t strlen, struct fileInfo* fI);

	//function to read an 256Bit Greyscale AVI file
	EXPORT bool loadAVIFile(const char* fileName, size_t strlen, struct fileInfo* fI);
	
	//functions to read the data, dependent on the loaded file
	EXPORT void getDataInt8(signed __int8 *data, struct fileInfo* fI);

	EXPORT void getDataUInt8(unsigned __int8 *data, struct fileInfo* fI);

	EXPORT void getDataInt16(signed __int16 *data, struct fileInfo* fI);

	EXPORT void getDataUInt16(unsigned __int16 *data, struct fileInfo* fI);

	EXPORT void getDataInt32(signed __int32 *data, struct fileInfo* fI);

	EXPORT void getDataUInt32(unsigned __int32 *data, struct fileInfo* fI);

	EXPORT void getDataReal32(float *data, struct fileInfo* fI);

	EXPORT void getDataReal64(double *data, struct fileInfo* fI);

	EXPORT void filterArrayInt8(signed __int8* in, signed __int8* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt8Back(signed __int8* in, signed __int8* out, signed __int8* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt8(unsigned __int8* in, unsigned __int8* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt8Back(unsigned __int8* in, unsigned __int8* out, unsigned __int8* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt16(signed __int16* in, signed __int16* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt16Back(signed __int16* in, signed __int16* out, signed __int16* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt16(unsigned __int16* in, unsigned __int16* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt16Back(unsigned __int16* in, unsigned __int16* out,unsigned __int16* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt32(signed __int32* in, signed __int32* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt32Back(signed __int32* in, signed __int32* out, signed __int32* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt32(unsigned __int32* in, unsigned __int32* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt32Back(unsigned __int32* in, unsigned __int32* out, unsigned __int32* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt64(signed __int64* in, signed __int64* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt64Back(signed __int64* in, signed __int64* out, signed __int64* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt64(unsigned __int64* in, unsigned __int64* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt64Back(unsigned __int64* in, unsigned __int64* out, unsigned __int64* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayReal32(float* in, float* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayReal32Back(float* in, float* out, float* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayReal64(double* in, double* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayReal64Back(double* in, double* out, double* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

#else
//	EXPORT void foo();
	//sets up the spottracker adn does tracking
	EXPORT bool SetupAndTrackData(double *data, struct trackSetup* config, bool bIOistransposed);

	//get width of the tracjetory data
	EXPORT signed __int32 getTSizeX();

	//get height of the tracjetory data
	EXPORT signed __int32 getTSizeY();

	//gets trajectory data and resets spottracker
	EXPORT void getTData(double *Tdata);

	//function to convert a SIF or a SPE file to 256 Bit greyscale AVI file
	EXPORT void ConvertToAVI(const char* fileName, size_t strlen);

	//function to read an SPE, SIF or AVI file, calls on of the subsequent functions
	EXPORT bool loadFile(const char* fileName, size_t strlen, struct fileInfo* fI);

	//function to read an SPE file 
	EXPORT bool loadSPEFile(const char* fileName, size_t strlen, struct fileInfo* fI);

	//function to read an SIF file 
	EXPORT bool loadSIFFile(const char* fileName, size_t strlen, struct fileInfo* fI);

	//function to read an 256Bit Greyscale AVI file
	EXPORT bool loadAVIFile(const char* fileName, size_t strlen, struct fileInfo* fI);

	//functions to read the data, dependent on the loaded file
	EXPORT void getDataInt8(signed char *data, struct fileInfo* fI);

	EXPORT void getDataUInt8(unsigned char *data, struct fileInfo* fI);

	EXPORT void getDataInt16(signed short *data, struct fileInfo* fI);

	EXPORT void getDataUInt16(unsigned short *data, struct fileInfo* fI);

	EXPORT void getDataInt32(signed __int32 *data, struct fileInfo* fI);

	EXPORT void getDataUInt32(unsigned __int32 *data, struct fileInfo* fI);

	EXPORT void getDataReal32(float *data, struct fileInfo* fI);

	EXPORT void getDataReal64(double *data, struct fileInfo* fI);

	EXPORT void filterArrayInt8(signed char* in, signed char* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt8Back(signed char* in, signed char* out, signed char* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt8(unsigned char* in, unsigned char* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt8Back(unsigned char* in, unsigned char* out, unsigned char* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt16(signed short* in, signed short* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt16Back(signed short* in, signed short* out, signed short* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt16(unsigned short* in, unsigned short* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt16Back(unsigned short* in, unsigned short* out, unsigned short* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt32(signed int* in, signed int* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt32Back(signed int* in, signed int* out,  signed int* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt32(unsigned int* in, unsigned int* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt32Back(unsigned int* in, unsigned int* out, unsigned int* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt64(signed long long* in, signed long long* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayInt64Back(signed long long* in, signed long long* out, signed long long* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt64(unsigned long long* in, unsigned long long* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayUInt64Back(unsigned long long* in, unsigned long long* out, unsigned long long* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayReal32(float* in, float* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayReal32Back(float* in, float* out, float* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayReal64(double* in, double* out, size_t width, size_t height, struct filterSet* fP, size_t nF);

	EXPORT void filterArrayReal64Back(double* in, double* out, double* backg, size_t width, size_t height, struct filterSet* fP, size_t nF);
#endif


#endif
