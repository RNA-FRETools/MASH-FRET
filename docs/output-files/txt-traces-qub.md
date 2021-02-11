---
layout: default
title: (*.txt) QUB traces
parent: /output-files.html
nav_order: 34
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# QUB trace files from video
{: .no_toc }

QUB trace files are ASCII files with the extension `.txt`. They are usually found in the main`/video_processing/intensities/traces_QUB` or main`/traces_processing/traces_QUB` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

These trace files are written in an ASCII format importable in the software QUB [<sup>1</sup>].
The files contains intensity-time traces of a specific FRET pair, each molecule saved in individual files when integrated from a single molecule video (SMV) or all molecules saved in one file when exported after trace processing.

They are created in the `/video_processing/intensities/traces_QUB` analysis sub-folder after creating and exporting QUB traces in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing, or in or `/traces_processing/traces_QUB` if exported from panel 
[Sample management](../trace-processing/panels/panel-sample-management.html#export-processed-data)of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>video file</u> loaded in 
[Video processing](../video-processing/panels/area-visualization.html#load-videoimage-file) or the <u>project file</u> in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list) from which data are exported, and is appended with the extension:
* `_all[N]FRET[D]to[A]_QUB` when exported from module Trace processing, where `[N]` is the number of single molecules, and where `[D]` and `[A]` are the channel indexes where donor and acceptor fluorescence are specifically detected
* `_mol[n]of[N]FRET[D]to[A]_QUB` when exported from module Video processing and where `[n]` is the exported molecule index


---

## Structure

FRET pair-specific intensity-time traces are organized column-wise with donor intensities being written in odd-indexed columns and acceptor in even-indexed columns.

```
9.193820e+03	-6.026230e+01	
8.319470e+03	1.600877e+02	
8.428510e+03	5.383770e+01	
9.067810e+03	-2.038123e+02	
```

For consistency, intensity-time traces exported from module Video processing or Trace processing are always given as the sum of the brightest pixel intensities per video frame, regardless the units defined in
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units) or 
[Intensity units](../trace-processing/panels/panel-plot.html#intensity-units) respectively.


---

## Compatibility

QUB trace files can be imported in external software QUB [<sup>1</sup>] and in MASH's module
[Trace processing](../trace-processing/workflow.html#import-single-molecule-data) by adjusting the 
[Import options](../trace-processing/functionalities/set-import-options.html) to the actual file structure.


---

## References

1. C. Nicolai, F. Sachs, *Solving Ion Channel Kinetics with the QuB Software*, *Biophys. Rev. and Letters* **2013**, DOI: 
[10.1142/S1793048013300053](https://doi.org/10.1142/S1793048013300053)