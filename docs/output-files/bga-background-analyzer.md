---
layout: default
title: (*.bga) Background analyzer
parent: /output-files.html
nav_order: 2
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Background analyzer files
{: .no_toc }

Background analyzer files are ASCII files with the extension `.bga`. They are usually found in the main analysis folder.


## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Background analyzer files are data-specific and contain background intensities for all molecules in the project, calculated by screening method parameters.

They are created in the main analysis folder after saving results from window 
[Background analyzer](../trace-processing/functionalities/use-background-analyzer.html) of module Trace processing.


---

## File name

The file is named after the selected <u>project file</u> in module 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list) with the extension `_[Eee]-[L]nm`, where `[Eee]` is the label given to the detection channel and `[L]` the laser excitation wavelength.


---

## Structure

Background intensities are organized column-wise with:
* columns `subimage_size(pix)` and `param_1` containing the first and second method parameters
* columns  `mean_value` and `std_value` containing the mean and standard deviations of background intensities calculated for all molecules, using units defined in 
[Intensity units](../trace-processing/panels/panel-plot.html#intensity-units)
* columns `mol_[n]` containing background intensities calculated for molecule `[n]`

```
subimage_size(pix)	param_1	mean_value(a.u. /pix /s)	std_value(a.u. /pix /s)	mol_1(a.u. /pix /s)	mol_2(a.u. /pix /s)	mol_3(a.u. /pix /s)	...
1			3	1454.842			126.1346		1367.62			1454.621		1424.812		...
1			5	1421.966			59.79676		1366.395		1435.047		1425.016		...
1			7	1409.24				42.70327		1362.665		1432.15			1426.82			...
```

