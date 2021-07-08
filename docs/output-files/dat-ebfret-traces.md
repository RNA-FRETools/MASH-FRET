---
layout: default
title: (*.dat) ebFRET traces
parent: Output files
nav_exclude: 1
nav_order: 6
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# ebFRET trace files
{: .no_toc }

ebFRET trace files are ASCII files with the extension `.dat`. They are usually found in the main`/video_processing/intensities/traces_ebFRET` or main`/traces_processing/traces_ebFRET` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

These trace files are written in an ASCII format importable in the software ebFRET [<sup>1</sup>].
Each file contains intensity-time traces of a specific FRET pair, integrated from a single molecule video (SMV) or exported after trace processing.

They are created in the `/video_processing/intensities/traces_ebFRET` analysis sub-folder after creating and exporting ebFRET traces in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing, or in or `/traces_processing/traces_ebFRET` if exported from panel 
[Sample management](../trace-processing/panels/panel-sample-management.html#export-processed-data)of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>video file</u> loaded in 
[Video processing](../video-processing/panels/area-visualization.html#load-videoimage-file) or the <u>project file</u> in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list) from which data are exported, and is appended with an extension `_all[N]FRET[D]to[A]_ebFRET` where `[N]` is the number of single molecules, and where `[D]` and `[A]` the channel indexes where donor and acceptor fluorescence are specifically detected.


---

## Structure

FRET pair-specific intensity-time traces are organized row-wise by appending the same columns for each molecule, and column-wise with molecule indexes written in column 1, donor intensities in column 2 and acceptor intensities in column 3.

```
1	1.076712e+04	2.959472e+03
1	6.776125e+03	1.706861e+03
1	9.744125e+03	1.914148e+03
1	6.183125e+03	1.632889e+03
```

For consistency, intensity-time traces exported from module Video processing or Trace processing are always given as the sum of the brightest pixel intensities per video frame, regardless the units defined in
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units) or 
[Intensity units](../trace-processing/panels/panel-plot.html#intensity-units) respectively.


---

## Compatibility

ebFRET trace files can be imported in external software ebFRET [<sup>1</sup>] and in MASH's module
[Trace processing](../trace-processing/workflow.html#import-single-molecule-data) by adjusting the 
[Import options](../trace-processing/functionalities/set-import-options.html) to the actual file structure.


---

## References

1. J.W. van de Meent, J.E. Bronson, C.H. Wiggins, R.L. Gonzalez Jr, *Empirical Bayes methods enable advanced population-level analyses of single-molecule FRET experiments*, *Biophys. J.* **2013**, DOI: 
[10.1016/j.bpj.2013.12.055](https://dx.doi.org/10.1016%2Fj.bpj.2013.12.055)

