---
layout: default
title: (*.txt) Traces from video processing
parent: Output files
nav_exclude: 1
nav_order: 35
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Trace file from video processing
{: .no_toc }

Trace files from video are ASCII files with the extension `.txt`. They are usually found in the main `/video_processing/intensities/traces_ASCII` or main`/video_processing/intensities/traces_ASCII/single_traces` analysis folders.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

These trace files are written in ASCII format and contain the intensity-time traces integrated from the single molecule video (SMV).

They are created in the `/video_processing/intensities/traces_ASCII` analysis sub-folder if molecules are saved in individual files, or `/video_processing/intensities/traces_ASCII/single_traces` if all molecules are saved in one file, after creating and exporting ASCII traces in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>video file</u> loaded in 
[Video processing](../video-processing.html), and is appended with an extension depending on the exported format selected in 
[Export options](../video-processing/functionalities/set-export-options.html):
* `_mol[n]of[N]` if molecules are saved in individual files
* `_all[N]` if all molecules are saved in one file

where `[n]` is the index of the molecule written in the file and `[N]` the total number of molecules.


---

## Structure

File headers include the date and software version at export, the experiment settings, intensity integration parameters and are written such as:

```
creation date:
MASH-FRET version:
movie file:
coordinates file:
number of channels:
excitation wavelengths:
frame rate:
integration area:
number of brightest pixels:
experimental parameters: 
```

Molecule coordinates in each video channel are written in the following line such as:

```
coordinates:		[x],[y]	[x],[y]	[x],[y]
```

with `[x],[y]` the respective x- and y-coordinates from the left-most to the right-most channel.
If all molecules are saved in the same file, the line is appended with all other molecule coordinates following the same channel order.

Intensity-time traces are organized column-wise with:
* column `time(s)` containing time data in second
* column `frames` containing frame indexes
* columns `I_[i](a.u.)` containing channel-specific intensity-time traces, with `[i]` the channel index

```
time(s)		frames	I_1(a.u.)	I_2(a.u.)	I_3(a.u.)
1.017500e-01	1	3181		17475		3741
2.035000e-01	2	14617		6545		3304
3.052500e-01	3	2975		18031		3755
```

For consistency, intensities are always given as the sum of the brightest pixel intensities per video frame, regardless the units defined in
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units).


---

## Compatibility

Trace files from video can be imported in modules 
[Trace processing](../trace-processing/workflow.html#import-single-molecule-data) and 
[Transition analysis](../transition-analysis/workflow.html#import-single-molecule-data) for analysis by adjusting the 
[Import options](../trace-processing/functionalities/set-import-options.html) to the actual file structure.
