---
layout: default
title: (*.txt) Kinetic model
parent: /output-files.html
nav_order: 8
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Kinetic model files
{: .no_toc }

Kinetic model files are ASCII files with the extension `.txt`. They are usually found in the main`/transition-analysis/kinetic model` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Kinetic model files are data-specific and contain parameters of the kinetic model inferred in Transition analysis.

They are created in the `/transition_analysis/kinetic-model` analysis sub-folder when exporting results in window 
[Export options](../transition-analysis/functionalities/set-export-options.html#kinetic-model) of module Transition analysis.


---

## File name

The file is named by the user during the export process.
By default, the file is named after the selected <u>project file</u>.

The file name is appended with the extension `_[Ddd]_mdl` where `[Ddd]` is the data type written in the file.

Data types supported in dwell time files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[D]to[A]`: stoichiometry associated to donor emitter detected in channel indexed `[D]` and acceptor emitter detected in channel indexed `[A]`


---

## Structure

The parameters of the inferred kinetic model are organized column-wise with:
* column `states` containing state indexes
* column `values` containing state values
* column `lifetimes(s)` containing the state lifetimes calculated as the inverse sum of the exit rate coefficients
* column `initial prob.` containing the state initial probabilities
* columns `k(s-1)` containing the matrix of transition rate coefficients where row numbers correspond to the state index before transition and column numbers to the state after transition
* columns `+dk(s-1)` and `-dk(s-1)` containing the positive and negative errors of transition rate coefficients calculated as described in Transition analysis 
  [Workflow](../transition-analysis/workflow.html#via-transition-probabilities)

```
states	values	lifetimes(s)	initial prob.	k(s-1)	k(s-1)	k(s-1)	+dk(s-1)	+dk(s-1)	+dk(s-1)	-dk(s-1)	-dk(s-1)	-dk(s-1)
1	-4.998780e-03	5.185646e+01	2.203390e-01	0	1.153360e-03	1.813064e-02	0	7.295450e-04	8.949940e-04	0	4.070347e-03	4.304173e-04
2	6.950000e-01	4.314437e+01	7.568592e-01	1.255807e-04	0	2.305242e-02	2.205439e-04	0	1.801500e-03	9.300039e-03	0	9.665214e-04
3	6.950000e-01	2.398177e+00	2.280182e-02	1.288703e-01	2.881131e-01	0	2.317237e-02	5.438044e-02	0	1.878421e-02	4.398762e-02	0
```
