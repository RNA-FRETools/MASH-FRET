---
layout: default
title: Home
nav_order: 0
---


<img src="assets/images/mash-fret_logo_500px.png" width="260" style="float:right"/>

# MASH-FRET
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}



## What is MASH-FRET?
MASH-FRET is a **Matlab** based software package for the analysis of **single-molecule FRET trajectories** developed in the group of Prof. Roland Sigel at the University of Zurich. The framework encompasses the entire workflow from spot detection and trace processing to histogram and dwell time analysis. The program is structured in five modules:
- [Simulation](simulation/simulation)
- [Video Processing](movie-processing/movie-processing)
- [Trace Processing](trace-processing/trace-processing)
- [Histogram Analysis](histogram-analysis/histogram-analysis)
- [Transition Analysis](transition-analysis/transition-analysis)

Inputs for analysis can be generated from simulations or single-molecule experiments.


## Getting started

Clone or download MASH-FRET into a directory of your choice.
```
git clone https://github.com/RNA-FRETools/MASH-FRET.git
```
Alternatively, you may also download the .zip package directly from [Github](https://github.com/RNA-FRETools/MASH-FRET)

Within Matlab, add MASH-FRET to you path by going to `Home → Set Path → Add with Subfolders`

Start MASH-FRET by typing `MASH` at the MATLAB command prompt.

If you would like a quick overview of MASH's individual modules and of how they inter-connect, have a look to the [General workflow](Getting_started.html#general-workflow) .


## Getting involved

MASH-FRET was developed by Mélodie Hadzic and Danny Kowerko in the group of Prof. Roland Sigel at the University of Zurich and is currently maintained by Fabio Steffen and Richard Börner.

Please report any **bugs** or **feature requests** through the [issue tracker](https://github.com/RNA-FRETools/MASH-FRET/issues) on Github.

If you have any questions, do not hesitate to contact us at rnafretools@chem.uzh.ch.


## Citing MASH-FRET

The various submodules of MASH-FRET (simulation, movie / trace processing, bootstrapping) have been described in several articles. If you use MASH-FRET in your work, please refer to the respective publication listed [here](citations.html).


## Licence
MASH-FRET is licensed under the GNU General Public License (GPLv3)
