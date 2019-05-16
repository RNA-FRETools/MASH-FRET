---
layout: default
title: (*.gam) Gamma factors
parent: /output-files.html
nav_order: 10
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Gamma factor files
{: .no_toc }

Gamma factor files are ASCII files with the extension `.gam`. They are usually found in the main`/traces_processing/parameters` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

The gamma factor files are written in an ASCII format and contains gamma factors of to correct all FRET-time traces in the project.

They are created in the `/trace_processing/parameters` analysis sub-folder after exporting .gam files from panel 
[Sample management](../trace-processing/panels/panel-sample-management.html#export-processed-data)of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>project file</u> selected in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list).


---

## Structure

FRET pair-specific gamma factors are organized column-wise with each column corresponding to a FRET pair, and row-wise by appending the same columns for each molecule.

```
1.000	1.000	1.000
0.825	1.000	0.900
0.900	1.000	1.000
```

FRET pairs are organized as in the list 
[FRET calculations](../video-processing/functionalities/set-project-options.html#fret-calculations).


---

## Compatibility

Gamma factor file can be imported:
* along with ASCII traces in MASH's module
[Trace processing](../trace-processing/workflow.html#import-single-molecule-data) by adjusting the 
[Import options](../trace-processing/functionalities/set-import-options.html)
* directly in panel 
[Factor corrections](../trace-processing/panels/panel-factor-corrections.html#gamma-factor-settings)
