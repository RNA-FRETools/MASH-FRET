---
layout: default
title: (*.kin) Dwell time statistics
parent: /output-files.html
nav_order: 13
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Dwell time statistics
{: .no_toc }

Dwell time statistics files are ASCII files with the extension `.kin`. They are usually found in the main`/traces_processing/dwell-times` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Dwell time statistics files are written in ASCII format and contain statistics on state transitions and state durations in all exported state trajectories.

They are created in the `trace_processing/dwell-times` analysis sub-folder after exporting .kin files from window 
[Export options](../trace-processing/functionalities/set-export-options.html#export-dwell-times) of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default the file is named after the selected <u>project file</u> and is appended with the extension `_[Ddd]`, where `[Ddd]` the data type written in the file.

Data types supported in dwell time statistics files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[D]to[A]`: stoichiometry associated to donor emitter detected in channel indexed `[D]` and acceptor emitter detected in channel indexed `[A]`


---

## Structure

Dwell time statistics are organized column-wise with:
* column `file name` containing names of exported dwell time files from which statistics are calculated
* columns `state1` and `state2` containing state values before and after transition respectively
* columns `total time spent in [j]` containing summed durations of state `[j]` (in second)
* columns `average time in [j]` containing average duration of state `[j]` in the trajectory (in second)
* columns `ratio average time 1/2` containing the ratio of the average dwell time before transition over the average dwell time after transition; this can be used as an approximation of the thermodynamic constant for a two-state system

```
file name	state1	state2	total time spent in 1	total time spent in 2	average time in 1	average time in 2	ratio average time 1/2
sim_mol1of85_FRET1to2.dt	2.068498e-02	1.000513e+00	18	17	1.637000e+02	2.321000e+02	9.094444e+00	1.365294e+01	6.661161e-01
sim_mol1of85_FRET1to2.dt	1.000513e+00	2.068498e-02	17	18	2.321000e+02	1.637000e+02	1.365294e+01	9.094444e+00	1.501240e+00
sim_mol2of85_FRET1to2.dt	2.265396e-02	1.000780e+00	19	19	1.343000e+02	2.503000e+02	7.068421e+00	1.317368e+01	5.365561e-01
```

If a state transition is not found reversible in the dwell time file, columns `total time spent in [j]` are set to `0` and columns `average time in [j]` as well as `ratio average time 1/2` are set to `NaN`.
