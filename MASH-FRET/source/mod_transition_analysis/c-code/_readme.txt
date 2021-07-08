To compile the mex functions:


1. set MATLAB's current search path to:

	$MASH-FRET$\MASH-FRET\source\mod_transition_analysis\kinetic_model\c-code

   where $MASH-FRET$ is the path to the "MASH-FRET" folder


2. Execute the following commands in MATLAB's command window:

	mex  -R2018a -O trainPH.c vectop.c
	mex  -R2018a -O baumwelch.c vectop.c fwdbwd.c
	mex  -R2018a -O calcmdlconfiv.c vectop.c fwdbwd.c


In case a compiler error is showing up in MATLAB's command window, follow MATLAB's instructions to install the compiler and repeat steps 1 & 2.
If the error persists, please signal the bug in Github's issue tracker (https://github.com/RNA-FRETools/MASH-FRET/issues)