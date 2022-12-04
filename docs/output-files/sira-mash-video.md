---
layout: default
title: (*.sira) MASH video
parent: Output files
nav_exclude: 1
nav_order: 24
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# MASH video files
{: .no_toc }

MASH video files are binary files with the extension `.sira`. They are usually found in the main, main`/simulations`, or main`/video_processing/average_images` analysis folders.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

MASH video files are the graphic files written and used by MASH. 
They contain the strict necessary information about the single molecule video (SMV) or image, including pixel data, video dimensions, the frame rate and MASH-FRET version. 

They are created in the `/simulations` analysis sub-folder when exported from module Simulation, at a user-defined location or in `video_processing/average_images` when exported from module Video processing.

They are created when:
- exporting the simulated SMV in panel 
[Export options](..//simulation/panels/panel-export-options.html) of module Simulation
- exporting the SMV in panel 
[Edit video](../video-processing/panels/panel-edit-video.html#export-video-to-file) of module Video processing
- exporting the average image in panel 
[Molecule coordinates](../video-processing/panels/panel-molecule-coordinates.html#average-image) of module Video processing


---

## File name

The file is named by the user.

By default, the file is named after the <u>video file</u> loaded in module 
[Video processing](../video-processing.html), with the extension `_ave` for average images.


---

## Structure

The file header contains information about the version of MASH, the frame acquisition time and the video dimensions.

The version of MASH used at the creation of the video file is written in the first file line such as:

```
MASH-FRET exported binary graphic Version: X.X.X (prev. commit: XXXXXXX)
```

The frame acquisition time, x- and y- video dimensions and the video frame length are then written in the second file line using `double`, `single`, `single` and `single` precision respectively.
Finally, the file is appended with pixel data written column by column and frame by frame using `single precision`.

MATLAB scripts used to read and write .sira video files can be found in MASH source code at:

```
MASH-FRET/source/video_processing/graphic_files/readSira.m
MASH-FRET/source/video_processing/graphic_files/export2Sira.m
```

with the function `export2Sira.m` requiring the use of:

```
MASH-FRET/source/video_processing/graphic_files/getFrames.m
```
