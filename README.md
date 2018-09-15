# ![](https://github.com/RNA-FRETools/MASH-FRET/blob/master/doc/images/mash-fret_logo.png) MASH-FRET 

## About MASH-FRET

This is the MASH-FRET MATLAB Package - A modular toolkit to process surface-immobilized single molecule data.

License: GPLv3

MASH was developed by **Mélodie C.A.-S. Hadzic** (University of Zürich, melodie.hadzic@chem.uzh.ch) and Danny Kowerko (Technical University of Chemnitz, danny.kowerko@informatik.tu-chemnitz.de). MASH was further developed and is currently taken care of by Fabio D. Steffen (University of Zürich, fabio.steffen@chem.uzh.ch) and Richard Börner (University of Zürich, richard.boerner@chem.uzh.ch). 

For more information please contact rnafretools@chem.uzh.ch.

If you use MASH-FRET in your work please cite ...

... for the simulation tool:

R. Börner*, D. Kowerko*, M. C.A.S. Hadzic*, S.L.B.König, M.Ritter, R.K.O.Sigel, "Simulations of Camera-Based Single-Molecule Fluorescence Experiments" *PLoS One* **2018**, *13*, e0195277. http://dx.doi.org/10.1371/journal.pone.0195277 

Supporting Information for parameter optimization and SM localization method comparison as well as reliable single-molecule video (SMV) test data sets ready for download (http://skinner.informatik.tu-chemnitz.de:9081/#/).

... for the model selection and state transition analyzing toolbox:

Mélodie C. A. S. Hadzic*, D. Kowerko, R. Börner, S. Zelger-Paulus, R.K.O. Sigel, "Detailed analysis of complex single molecule FRET data with the software MASH" *Proc. SPIE* **2016**, *9711*, 971119. http://dx.doi.org/10.1117/12.2211191

and 

Mélodie C. A. S. Hadzic*, R. Börner, D. Kowerko, S.L.B.König, R.K.O. Sigel, "Reliable State Identification and State Transition Detection in Fluorescence Intensity-Based Single-Molecule FRET Data" *J. Phys. Chem. B* **2018**, *122(23)*, 6134-6147. http://dx.doi.org/10.1021/acs.jpcb.7b12483

... for the bootstraping algorythm BOBA FRET:

S.L.B.König, Mélodie C. A. S. Hadzic*, Erica Fiorini, R. Börner, D. Kowerko, Wolf U. Blanckenhorn, R.K.O. Sigel, "BOBA FRET: bootstrap-based analysis of single-molecule FRET data" *PLoS One* **2013**, *8*(12), e84157. http://dx.doi.org/10.1371/journal.pone.0084157

Happy MASHing!

Your developers (Mélodie, Danny, Richard and Fabio)

## Installation

Download the folder "MASH-FRET" into the directory of your choice. Then within MATLAB go to file >> Set path... and add the directory containing "MASH-FRET" to the list (if it isn't already). That's it.

## Dependencies

MASH was developed with MATLAB 7.12 (R2011a) and operating system Windows 7. The compatibility was further tested on Windows 8, 8.1 and 10 with MATLAB 7.12 (R2011a) to 9.3 (R2017b).
MASH is (so far) not running under Matlab (R2018b). Character vector inputs have been removed for "solve" leading to multiple error messages. See MATLAB documentatin for immediate help.

## Usage

For information about the different modules in MASH-FRET please visit our [Wiki page](https://github.com/RNA-FRETools/MASH-FRET/wiki).

## External links

http://skinner.informatik.tu-chemnitz.de:9081/#/

http://www.chem.uzh.ch/en/sigel/research/software.html
