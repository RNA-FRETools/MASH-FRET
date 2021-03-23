To solve MEX file compilation issues happening at MASH-FRET startup on Linux, please read the following instructions.

ERROR MESSAGE 1:
	An error occurred:
	Supported compiler not found. For options, visit https://www.mathworks.com/support/compilers.
	function: checkMASHmex, line: 7
	function: MASH, line: 13

SOLUTION 1:
	MATLAB supports GCC compiler up to version 9.x
	Install gcc-9 package with the shell command:
		sudo apt install gcc-9
	Create a soft link "gcc" pointing to gcc-9 with the shell comand:
		sudo ln -s /usr/bin/gcc-9 /usr/bin/gcc

ERROR MESSAGE 2:
	An error occurred:
	/usr/bin/ld : ne peut trouver -lstdc++
	collect2: error: ld returned 1 exit status
	function: checkMASHmex, line: 7
	function: MASH, line: 13
	
SOLUTION 2:
	MATLAB looks for a file named libstdc++.so which is named "libstdc++.so.6" on your computer
	Create a soft link "libstdc++.so" pointing to libstdc++.so.6 with the shell comand:
		sudo ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib/x86_64-linux-gnu/libstdc++.so
