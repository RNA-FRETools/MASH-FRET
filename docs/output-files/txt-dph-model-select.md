---
layout: default
title: (*.txt) DPH model selection
parent: Output files
nav_exclude: 1
nav_order: 29
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# DPH model selection files
{: .no_toc }

DPH model selection files are ASCII files with the extension `.txt`. They are usually found in the main`/transition-analysis/kinetic model` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

DPH model selection files are data-specific and contain the results of state degeneracy analysis via discrete phase-type distributions in module Transition analysis.

They are created in the `/transition_analysis/kinetic-model` analysis sub-folder when exporting results in window 
[Export options](../transition-analysis/functionalities/set-export-options.html#kinetic-model) of module Transition analysis.


---

## File name

The file is named by the user during the export process.
By default, the file is named after the selected <u>project file</u>.

The file name is appended with the extension `_[Ddd]_BIC` where `[Ddd]` is the data type written in the file.

Data types supported in dwell time files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[D]to[A]`: stoichiometry associated to donor emitter detected in channel indexed `[D]` and acceptor emitter detected in channel indexed `[A]`


---

## Structure

Model selection results are organized column-wise with:
* column `D` containing state degeneracy 
* columns `BIC (state [val])` containing BIC values calculated for observed state value `[val]` as described in Transition analysis 
  [Workflow](../transition-analysis/workflow.html#model-selection-on-phase-type-distributions)

```
D	BIC(state -0.00)	BIC(state 0.70)	
1	2.437739e+03	3.264867e+03	
2	2.443784e+03	3.195992e+03	
3	2.468310e+03	3.224519e+03	
```
