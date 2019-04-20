---
layout: default
title: (*.dt) Dwell times
parent: /output-files.html
nav_order: 8
nav_exclude: 1
---


# Dwell time files
{: .no_toc }

Dwell time files are ASCII files with the extension `.dt`. They are usually found in the main`/simulations/dwell-times` or main`/traces_processing/dwell-times` analysis folders.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

The dwell time files are written in ASCII format and contain state durations in the corresponding single molecule state trajectory.

They are created in the `/simulations/dwell-times` analysis sub-folder when exported from module Simulation, or in `trace_processing/dwell-times` when exported from module Trace processing.

They are created when:
- exporting simulated dwell times in panel 
[Export options](..//simulation/panels/panel-export-options.html) of module Simulation
- exporting processed dwell times in window 
[Export options](../trace-processing/functionalities/set-export-options.html#export-dwell-times) of module Trace processing


---

## File name

The file is named by the user during the export process, and is appended with the extension `_molMofN_Ddd`, where `M` is the index of the molecule written in the file, `N` the total number of exported molecules, and `Ddd` the data type written in the file.

Data types supported in dwell time files are:
* `Ix-yyy`: intensities in detection channel indexed `x` upon illumination with laser wavelength `yyy` nm
* `FRETxtoy`: FRET from donor emitter detected in channel indexed `x` to acceptor emitter detected in channel indexed `y`
* `Sxxx`: stoichiometry of emitter detected in channel labelled `xxx`


---

## Structure

Dwell times are organized column-wise with:
* column `dwell-time (second)` containing state durations in second before transition
* column `state` containing state values before transition
* columns `state after transition` containing state values after transitions

```
dwell-time (second)	state	state after transition
4.074967e+01	2.000000e-01	4.000000e-01
2.270107e+01	4.000000e-01	6.000000e-01
3.884042e+00	6.000000e-01	2.000000e-01
```

The last value in column `state after transition` is set to `NaN` when the state after transition is unknown, *e. g.* when the last dwell time is truncated by the limited observation time.

