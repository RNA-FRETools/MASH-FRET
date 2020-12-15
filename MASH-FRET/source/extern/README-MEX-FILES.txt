1) Set MATLAB's current folder to MASH-FRET\source\extern\ITALS\package

If working with Windows 64bit:

	2) Type in MATLAB command window:

	mex 'FiterArray.c' -L./lib -lITASL64
	mex 'SIFImport.c' -L./lib -lITASL64
	mex 'SPEImport.c' -L./lib -lITASL64

	3) move the new .mexw64 files to MASH-FRET\source\extern\ITALS\runtime64

If working with Windows 32bit:

	2) Type in MATLAB command window:

	mex 'FiterArray.c' -L./lib -lITASL32
	mex 'SIFImport.c' -L./lib -lITASL32
	mex 'SPEImport.c' -L./lib -lITASL32

	3) move the new .mexw32 files to MASH-FRET\source\extern\ITALS\runtime32

If you have the MATLAB error message about a msising compiler, go to MATLAB menu "Environment"/"Add ons" and search for "mingw-w64".
Then follow the prompt instruction.

Once installed, try again steps 2) and 3).
To be sure, test by add the "Gaussian filter (sensitive)".


4) Set MATLAB's current folder to MASH-FRET\source\extern\schmied2012

5) Type in MATLAB command window:

mex 'forloop.c'

To be sure, test by add the "Schmied2012" spotfinder method.
