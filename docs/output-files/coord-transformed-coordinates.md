---
layout: default
title: (*.coord) Transformed coordinates
parent: /output-files.html
nav_order: 4
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Transformed coordinates files
{: .no_toc }

Transformed coordinates files are ASCII files with the extension `.coord`. They are usually found in the main`/video_processing/coordinates/transformed` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Transformed coordinates files are written in ASCII format and contains single molecule coordinates co-localized in all video channels.

They are created in the `/video_processing/coordinates/transformed` analysis sub-folder when transforming and exporting coordinates in the panel
[Coordinates transformation](../video-processing/panels/panel-molecule-coordinates.html#coordinates-transformation) of module Video processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>spots coordinates file</u> loaded in 
[Coordinates transformation](../video-processing/panels/panel-molecule-coordinates.html#coordinates-transformation) for transformation.


---

## Structure

Coordinates are written in double precision and are organized in a column-wise fashion with columns `x[i]` and `y[i]` containing the respective x- and y- coordinates of single molecules in detection channel `[i]`.

```
x1		y1		x2		y2
7.500000e+00	8.650000e+01	1.355000e+02	8.650000e+01
9.050000e+01	9.550000e+01	2.185000e+02	9.550000e+01
1.145000e+02	2.505000e+02	2.425000e+02	2.505000e+02
```


---

## Compatibility

Transformed coordinates files can be imported:
* as single molecule coordinates in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#input-coordinates) by adjusting the corresponding import options
* together with ASCII trace files in module 
[Trace processing](../transition-analysis/workflow.html#import-single-molecule-data) for trace processing
