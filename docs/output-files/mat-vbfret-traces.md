---
layout: default
title: (*.mat) vbFRET traces
parent: /output-files.html
nav_order: 21
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# vbFRET trace files
{: .no_toc }

vbFRET trace files are Matlab binary files with the extension `.mat`. They are usually found in the main`/video_procssing/intensities/traces_vbFRET` or main`/traces_procssing/traces_vbFRET` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

These trace files are written in MATLAB binary format importable in the software vbFRET [<sup>1</sup>].
Each file contains intensity-time traces of a specific FRET pair, integrated from a single molecule video (SMV) or exported after trace processing.

They are created in the `/video_processing/intensities/traces_vbFRET` analysis sub-folder after creating and exporting vbFRET traces in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing, or in `/traces_processing/traces_vbFRET` if exported from panel 
[Sample management](../trace-processing/panels/panel-sample-management.html#export-processed-data)of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>video file</u> loaded in 
[Video processing](../video-processing/panels/area-visualization.html#load-videoimage-file) or the <u>project file</u> in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list) from which data are exported, and is appended with an extension `_all[N]FRET[D]to[A]_vbFRET` where `[N]` is the number of single molecules, and where `[D]` and `[A]` the channel indexes where donor and acceptor fluorescence are specifically detected.


---

## Structure

vbFRET trace files include single molecule data of all `N` molecules and consist in a 1-by-`N` cell array with each cell containing donor and acceptor intensity series.

For consistency, intensity-time traces exported from module Video processing or Trace processing are always given as the sum of the brightest pixel intensities per video frame, regardless the units defined in
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units) or 
[Intensity units](../trace-processing/panels/panel-plot.html#intensity-units) respectively.


---

## Compatibility

vbFRET trace files can be imported in external software vbFRET [<sup>1</sup>].

vbFRET trace files are MATLAB binary files and can be imported in MATLAB's workspace by simply drag-and-dropping the file, or by typing in MATLAB's command window:

```matlab
load('datafolder\vbFRET-file.traces','-mat');
```

and replacing `datafolder\vbFRET-file.traces` by your actual file name and directory.


---

## References

1. J.E. Bronson, J. Fei, J.M. Hofman, R.L. Gonzalez Jr, C.H. Wiggins, *Learning Rates and States from Biophysical Time Series: A Bayesian Approach to Model Selection and Single-Molecule FRET Data*, *Biophys. J.* **2009**, DOI: 
[10.1016/j.bpj.2009.09.031](https://dx.doi.org/10.1016%2Fj.bpj.2009.09.031)

