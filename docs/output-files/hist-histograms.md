---
layout: default
title: (*.hist) Histograms
parent: /output-files.html
nav_order: 12
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Histogram files
{: .no_toc }

Histogram files are ASCII files with the extension `.hist`. They are usually found in the main`/traces_procssing/histograms` or main/`histogram_analysis` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

The histogram files are written in ASCII format and contain data distributions of the corresponding single molecule state trajectory.

They are created in the `/trace_processing/histograms` analysis sub-folder when exported from module Trace processing, or in `histogram_analysis` when exported from module Histogram analysis.

They are created when:
- exporting single molecule histograms in 
[Export options](../trace-processing/functionalities/set-export-options.html#export-dwell-times) of module Trace processing
- exporting sample histograms along with analysis results in 
[Export analysis results](../histogram-analysis/panels/area-management.html#export-analysis-results) of module Histogram analysis


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>project file</u> loaded in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list) or 
[Histogram analysis](../histogram-analysis/panels/area-management.html#project-list), and is appended with the extension `_[Ddd]`, where `[Ddd]` is the data type written in the file.

When exporting from 
[Histogram analysis](../histogram-analysis/panels/area-management.html#project-list), the data type is appended with the extension `_[Ttt]` if a particular subgroup of molecules was analyzed, with `[Ttt]` the corresponding molecule tag.

Data types supported in histogram files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[Eee]`: stoichiometry of emitter detected in channel labelled `[Eee]`

A second extension `_discr` is added to the file name when distributions of state trajectories are written in the file.


---

## Structure

Histograms are organized column-wise with:
* column `[Ddd]` containing binned data
* column `frequency count` absolute histogram count
* column `probability` histogram count normalized by the sum
* column `cumulative frequency count` absolute cumulative histogram count
* column `cumulative probability` cumulative histogram count normalized by the maximum

```
FRET		frequency count	probability	cumulative frequency count	cumulative probability
-7.000000e-02	0		0		0				0	
-6.000000e-02	1		2.500000e-04	1				2.500000e-04	
-5.000000e-02	2		5.000000e-04	3				7.500000e-04	
-4.000000e-02	6		1.500000e-03	9				2.250000e-03	
```
