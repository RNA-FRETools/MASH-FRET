---
layout: default
title: (*.traces) SMART traces
parent: /output-files.html
nav_order: 28
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# SMART trace files
{: .no_toc }

SMART trace files are Matlab binary files with the extension `.traces`. They are usually found in the main`/video_processing/intensities/traces_SMART` or main`/traces_processing/traces_SMART` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

These trace files are written in MATLAB binary format importable in the software SMART [<sup>1</sup>].
Each file contains intensity-time traces of a specific FRET pair, integrated from a single molecule video (SMV) or exported after trace processing.

They are created in the `/video_processing/intensities/traces_SMART` analysis sub-folder after creating and exporting SMART traces in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing, or in or `/traces_processing/traces_SMART` if exported from panel 
[Sample management](../trace-processing/panels/panel-sample-management.html#export-processed-data)of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>video file</u> loaded in 
[Video processing](../video-processing/panels/area-visualization.html#load-videoimage-file) or the <u>project file</u> in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list) from which data are exported, and is appended with an extension `_all[N]FRET[D]to[A]_SMART` where `[N]` is the number of single molecules, and where `[D]` and `[A]` the channel indexes where donor and acceptor fluorescence are specifically detected.


---

## Structure

SMART trace files include single molecule data of all the `N` molecules and consist in a `N`-by-3 cell array with:
* column 1 containing structures with the following fields:

   | field name       | description                          | data type       | example                              |
   | ---------------- | ------------------------------------ | --------------- | ------------------------------------ |
   | `name`           | file name                            | string          | `'data_all100FRET1to2_SMART.traces'` |
   | `gp_num`         | sub-group index = NaN                | double          | `'NaN'` (fixed)                      |
   | `movie_num`      | video index = 1                      | double          | `1` (fixed)                          |
   | `movie_ser`      | video series index = 1               | double          | `1` (fixed)                          |
   | `trace_num`      | molecule index                       | double          | `12`                                 |
   | `spots_in_movie` | number of molecules in the set       | double          | `100`                                |
   | `position_x`     | x-coordinates in video               | double          | `65.5`                               |
   | `position_y`     | y-coordinates in video               | double          | `38.5`                               |
   | `positions`      | all molecule cooridnates in the set  | `N`-by-4 double |                                      |
   | `fps`            | video frame rate (in s<sup>-1</sup>) | double          | `9.8280`                             |
   | `len`            | trace length (in frame)              | double          | `4000`                               |
   | `nchannels`      | number of detection channels = 2     | double          | `2` (fixed)                          |
   
* column 2 containing donor and acceptor intensities written in double precision
* column 3 containing a boolean vector indicating data points included in /excluded from the analysis

For consistency, intensity-time traces exported from module Video processing or Trace processing are always given as the sum of the brightest pixel intensities per video frame, regardless the units defined in
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units) or 
[Intensity units](../trace-processing/panels/panel-plot.html#intensity-units) respectively.


---

## Compatibility

SMART trace files can be imported in external software SMART [<sup>1</sup>].

SMART trace files are MATLAB binary files and can be imported in MATLAB's workspace by typing in MATLAB's command window:

```matlab
load('datafolder\SMART-file.traces','-mat');
```

and replacing `datafolder\SMART-file.traces` by your actual file name and directory.


---

## References

1. M. Greenfeld, D.S. Pavlichin, H. Mabuchi, D. Herschlag, *Single Molecule Analysis Research Tool (SMART): An Integrated Approach for Analyzing Single Molecule Data*, *PLoS ONE* **2012**, DOI: 
[10.1371/journal.pone.0030024](https://doi.org/10.1371/journal.pone.0030024)
