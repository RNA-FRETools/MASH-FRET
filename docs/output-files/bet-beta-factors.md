---
layout: default
title: (*.bet) Beta factors
parent: /output-files.html
nav_order: 1
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Beta factor files
{: .no_toc }

Beta factor files are ASCII files with the extension `.bet`. They are usually found in the main`/traces_processing/parameters` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

The beta factor files are written in an ASCII format and contains beta factors to correct all stoichiometry-time traces in the project.

They are created in the `/trace_processing/parameters` analysis sub-folder after exporting .bet files from panel 
[Sample management](../trace-processing/panels/panel-sample-management.html#export-processed-data)of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>project file</u> selected in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list).


---

## Structure

FRET pair-specific beta factors are organized column-wise with each column corresponding to a FRET pair, and row-wise by appending the same columns for each molecule.

```
FRET1-2	FRET1-3	FRET2-3
1.000	1.000	1.000
0.825	1.000	0.900
0.900	1.000	1.000
```

FRET pairs are organized as listed in 
[FRET calculations](../video-processing/functionalities/set-project-options.html#fret-calculations).


---

## Compatibility

Beta factor file can be imported:
* along with ASCII traces in MASH's module
[Trace processing](../trace-processing/workflow.html#import-single-molecule-data) by adjusting the 
[Import options](../trace-processing/functionalities/set-import-options.html)
* after import from panel 
[Factor corrections](../trace-processing/panels/panel-factor-corrections.html)
