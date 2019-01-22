---
layout: default
title: Home
nav_order: 0
---



# ![logo](assets/images/mash-fret_logo.png)    MASH-FRET
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

## What is MASH-FRET?
MASH-FRET is a **Matlab** based software package for the analysis of **single-molecule FRET trajectories**. The framework encompasses the entire workflow from spot detection and trace processing to histogram and dwell time analysis. The program is structured in five modules:
- [Simulation](simulation/simulation.md)
- [Movie Processing](movie-processing/movie-processing.md)
- [Trace Processing](trace-processing/trace-processing.md)
- [Histogram Analysis](histogram-analysis/histogram-analysis.md)
- [Transition Analysis](transition-analysis/transition-analysis.md)

Inputs can either be generated from simulations or from experimental data.

## Getting involved

Please report any **bugs** or **feature requests** through the [issue tracker](https://github.com/RNA-FRETools/MASH-FRET/issues).

Specific requests may also be addressed directly to Richard Börner (richard.boerner@chem.uzh.ch).

## Citing MASH-FRET

The various submodules of MASH-FRET (simulation, movie / trace processing, bootstrapping) have been described separately in different publications.

### Simulation routine

R. Börner, D. Kowerko, M.C.A.S. Hadzic, S.L.B. König, M. Ritter, R.K.O. Sigel, *PLoS One* **2018**, *13*, e0195277. [![](https://img.shields.io/badge/DOI-10.1371/journal.pone.0195277-blue.svg)](https://doi.org/10.1371/journal.pone.0195277)

```
@article{BoernerPlosOne2018,
    author = {Börner, Richard and Kowerko, Danny and Hadzic, Melodie C. A. S. and König, Sebastian L. B. and Ritter, Marc and Sigel, Roland K. O.},
    title = {Simulations of camera-based single-molecule fluorescence experiments},
    journal = {PLOS ONE},
    year = {2018},
    volume = {13},
    number = {4},
    pages = {1-23},
    doi = {10.1371/journal.pone.0195277}}
```


### Model selection and trace processing

M.C.A.S. Hadzic, R. Börner, D. Kowerko, S.L.B. König, R.K.O. Sigel, *J. Phys. Chem. B* **2018**, *122*, 6134-6147. [![](https://img.shields.io/badge/DOI-10.1021/acs.jpcb.7b12483-blue.svg)](https://doi.org/10.1021/acs.jpcb.7b12483)

```
@article{HadzicJPCB2018,
    author = {Hadzic, Melodie C. A. S. and Börner, Richard and König, Sebastian L. B. and Kowerko, Danny and Sigel, Roland K. O.},
    title = {Reliable State Identification and State Transition Detection in Fluorescence Intensity-Based Single-Molecule Förster Resonance Energy-Transfer Data},
    journal = {The Journal of Physical Chemistry B},
    year = {2018},
    volume = {122},
    number = {23},
    pages = {6134-6147},
    doi = {10.1021/acs.jpcb.7b12483}}
```

and

M.C.A.S. Hadzic, D. Kowerko, R. Börner, S. Zelger-Paulus, R.K.O. Sigel, *Proc. SPIE* **2016**, *9711*, 971119. [![](https://img.shields.io/badge/DOI-10.1117/12.2211191-blue.svg)](https://doi.org/10.1117/12.2211191)

```
@article{HadzicProcSPIE2016,
    author = {Hadzic, Melodie C. A. S. and Kowerko, Danny and Börner, Richard and Zelger-Paulus, Susann and Sigel, Roland K. O.},
    title = {Detailed analysis of complex single molecule FRET data with the software MASH},
    journal = {Proc. SPIE},
    year = {2016},
    volume = {9711},
    pages = {1-8},
    doi = {10.1117/12.2211191}}
```


### Bootstrapping BOBA-FRET

S.L.B König, M.C.A.S. Hadzic, E. Fiorini, R. Börner, D. Kowerko, W. Blanckenhorn, R.K.O. Sigel, *Plos One* **2013**, *8*, 1-17. [![](https://img.shields.io/badge/DOI-10.1371/journal.pone.0084157-blue.svg)](https://doi.org/10.1371/journal.pone.0084157)

```
@article{KoenigPlosOne2013,
    author = {König, Sebastian L. B. AND Hadzic, Mélodie AND Fiorini, Erica AND Börner, Richard AND Kowerko, Danny AND Blanckenhorn, Wolf U. AND Sigel, Roland K. O.},
    title = {BOBA FRET: Bootstrap-Based Analysis of Single-Molecule FRET Data},
    journal = {PLOS ONE},
    year = {2013},
    volume = {8},
    number = {12},
    pages = {1-17},
    doi = {10.1371/journal.pone.0084157}}
```

## Licence
MASH-FRET is licensed under the GNU General Public License (GPLv3)
