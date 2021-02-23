---
layout: default
title: (*.txt) Traces from simulation
<<<<<<< HEAD
parent: /output-files.html
nav_order: 32
=======
parent: Output files
>>>>>>> MASH-FRET-1.3.2-doc
nav_exclude: 1
nav_order: 34
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Trace file from simulation
{: .no_toc }

Trace files from simulation are ASCII files with the extension `.txt`. They are usually found in the main`/simulations/traces_ASCII` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

These trace files are the simulated data of individual molecules written in ASCII format.
They contain the molecule coordinates in the video, the simulated intensity- and FRET-time traces as well as the corresponding state trajectories.

They are created in the `/simulations/traces_ASCII` analysis sub-folder after exporting ASCII traces in panel 
[Export options](../simulation/panels/panel-export-options.html) of module Simulation.


---

## File name

The file is named by the user during the export process, and is appended with the extension `_molMofN`, where `M` is the index of the molecule written in the file and `N` the total number of simulated molecules.


---

## Structure

The molecule coordinates in each video channel are written in the first file line such as:

```
coordinates 	xxx,yyy	XXX,YYY
```
with `xxx,yyy` and `XXX,YYY`, the x- and y-coordinates in donor and acceptor channel respectively.

Simulate time traces and state trajectories are organized column-wise with:
* column `time(s)` containing time data in second
* column `frame` containing frame indexes
* columns `Idon noise(a.u.)` and `Iacc noise(a.u.)` containing donor and acceptor intensity-time traces respectively, in image or photon counts
* columns `Idon ideal(a.u.)` and `Iacc ideal(a.u.)` containing the noiseless, background-free and gamma factor-free photon count-time traces of donor and acceptor respectively
* column `FRET` containing FRET-time traces
* column `FRET ideal (blurr)` containing noiseless, background-free and gamma factor-free FRET-time traces with camera blurring effect
* column `FRET ideal` containing noiseless, background-free and gamma factor-free FRET-time traces without camera blurring effect
* column `state sequence` containing state indexes

```
time(s)	frame	Idon noise(photons)	Iacc noise(photons)	Idon ideal(photons)	Iacc ideal(photons)	FRET	FRET ideal (blurr)	FRET ideal	state sequence
2.000000e-01	1	1.996415e+01	4.003952e+01	1.680000e+01	3.920000e+01	6.672846e-01	7.000000e-01	7.000000e-01	2
4.000000e-01	2	1.767607e+01	4.298884e+01	1.680000e+01	3.920000e+01	7.086278e-01	7.000000e-01	7.000000e-01	2
6.000000e-01	3	1.528009e+01	3.938020e+01	1.680000e+01	3.920000e+01	7.204535e-01	7.000000e-01	7.000000e-01	2
```


---

## Compatibility

Simulated trace files can be imported in modules 
[Trace processing](../trace-processing/workflow.html#import-single-molecule-data) and 
[Transition analysis](../transition-analysis/workflow.html#import-single-molecule-data) for analysis by adjusting the 
[Import options](../trace-processing/functionalities/set-import-options.html) to the actual file structure.
