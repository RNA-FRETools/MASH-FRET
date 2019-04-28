---
layout: default
title: (*.hdt) Dwell time histogram
parent: /output-files.html
nav_order: 11
nav_exclude: 1
---


# Dwell time histogram files
{: .no_toc }

Dwell time histogram files are ASCII files with the extension `.hdt`. They are usually found in the main`/transition_analysis/kinetics` folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

The dwell time histogram files are written in ASCII format and contain state dwell time distributions prior a specific state transition.

They are created in the `/transition_analysis/kinetics` analysis sub-folder when exporting dwell time histograms from widow 
[Export options](../transition-analysis/functionalities/set-export-options.html#transition-density-plot-tdp) of module Transition analysis.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the selected <u>project file</u> and is appended with the extension `_[Ddd]_[j]to[j']`, where `[Ddd]` is the data type written in the file and `[j]` and `[j']` are the respective x- and y- coordinates of the transition cluster.

Data types supported in dwell time histogram files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[Eee]`: stoichiometry of emitter detected in channel labelled `[Eee]`


---

## Structure

Dwell time histograms are organized column-wise with:
* column `dwell-times(s)` containing binned dwell times
* column `count` absolute histogram count
* column `norm. count` histogram count normalized by the sum
* column `cum. count` absolute cumulative histogram count
* column `compl. norm. count` complementarity of the cumulative histogram count normalized by the maximum

```
dwell-times(s)	count	norm. count	cum. count	compl. norm. count
0		0	0		0		1
1.017500e-01	17	2.575758e-01	17		7.424242e-01
2.035000e-01	8	1.212121e-01	25		6.212121e-01
```