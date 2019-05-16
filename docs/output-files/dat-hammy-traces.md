---
layout: default
title: (*.dat) HaMMy traces
parent: /output-files.html
nav_order: 7
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# HaMMy trace files
{: .no_toc }

HaMMy trace files are ASCII files with the extension `.dat`. They are usually found in the main`/video_processing/intensities/traces_HaMMy` or main`/traces_processing/traces_HaMMy` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

These trace files are written in an ASCII format importable in the software HaMMy [<sup>1</sup>].
Each file contains intensity-time traces of a specific molecule and FRET pair, integrated from a single molecule video (SMV) or exported after trace processing.

They are created in the `/video_processing/intensities/traces_HaMMy` analysis sub-folder after creating and exporting HaMMy traces in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing, or in or `/traces_processing/traces_HaMMy` if exported from panel 
[Sample management](../trace-processing/panels/panel-sample-management.html#export-processed-data)of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>video file</u> loaded in 
[Video processing](../video-processing/panels/area-visualization.html#load-videoimage-file) or the <u>project file</u> in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list) from which data are exported, and is appended with an extension `_mol[n]of[N]FRET[D]to[A]_HaMMy` where `[n]` is the exported molecule index, `[N]` is the number of single molecules, and where `[D]` and `[A]` the channel indexes where donor and acceptor fluorescence are specifically detected.


---

## Structure

FRET pair-specific intensity-time traces are organized row-wise by appending the same columns for each molecule, and column-wise with time data written in column 1, donor intensities in column 2 and acceptor intensities in column 3.

```
1.017500e-01	2067	1085
3.052500e-01	2013	1044
5.087500e-01	1950	1216
7.122500e-01	2405	1443
```

For consistency, intensity-time traces exported from module Video processing or Trace processing are always given as the sum of the brightest pixel intensities per video frame, regardless the units defined in
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units) or 
[Intensity units](../trace-processing/panels/panel-plot.html#intensity-units) respectively.


---

## Compatibility

HaMMy trace files can be imported in external software HaMMy [<sup>1</sup>] and in MASH's module
[Trace processing](../trace-processing/workflow.html#import-single-molecule-data) by adjusting the 
[Import options](../trace-processing/functionalities/set-import-options.html) to the actual file structure.


---

## References

1. S.A. McKinney, C. Joo, T. Ha *Analysis of Single-Molecule FRET Trajectories Using Hidden Markov Modeling*, *Biophys. J.* **2006**, DOI: 
[10.1529/biophysj.106.082487](https://dx.doi.org/10.1529%2Fbiophysj.106.082487)
