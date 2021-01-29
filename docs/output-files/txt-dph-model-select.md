---
layout: default
title: (*.txt) DPH model selection
parent: /output-files.html
nav_order: 8
nav_exclude: 1
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
* columns `nb. of degen. levels (state [val])` containing state state degeneracy for state value `[val]`
* column `BIC` containing BIC values calculated as described in Transition analysis 
  [Workflow](../transition-analysis/workflow.html#model-selection-on-phase-type-distributions)

```
nb. of degen. levels (state -0.00)	nb. of degen. levels (state 0.70)	BIC
1	1	4.375403e+03
2	1	4.397227e+03
1	2	4.311630e+03
```
