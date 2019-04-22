---
layout: default
title: (*.tbl) Intensity statistics
parent: /output-files.html
nav_order: 25
nav_exclude: 1
---


# Intensity statistics files
{: .no_toc }

Intensity statistics files are ASCII files with the extension `.tbl`. They are usually found in the main`/video_processing/intensities/statistics` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Intensity statistics files are are written in ASCII format and contain statistics on single molecule intensity-time traces created from video.

They are automatically created in the `/video_processing/intensities/statistics` analysis sub-folder after creating and exporting ASCII traces in panel 
[Intensity integration](/video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>video file</u> name loaded in 
[Video processing](../video-processing.html), and is appended with the extension `_all[N]` where `[N]` the total number of single molecules in the file.


---

## Structure

Intensity statistics are organized column-wise with:
* columns `x[i]` and `y[i]` containing the respective x- and y- coordinates of single molecules in detection channel `[i]`
* columns `signal[i] at[X]nm(average)` and `noise[i] at[X]nm` respectively containing the mean and standard deviation of the single molecule intensity time-trace in detection channel `[i]` and upon illumination with laser wavelength `[X]`

```
x1	y1	x2	y2	x3	y3	signal1 at532nm(average)	noise1 at532nm	signal2 at532nm(average)	noise2 at532nm	signal3 at532nm(average)	noise3 at532nm	signal1 at638nm(average)	noise1 at638nm	signal2 at638nm(average)	noise2 at638nm	signal3 at638nm(average)	noise3 at638nm	
23.50	236.50	106.50	234.50	193.50	233.50	3.120360e+03	7.832579e+01	1.823166e+04	5.581996e+02	3.753180e+03	1.245068e+02	1.447566e+04	4.174090e+02	6.381140e+03	2.771405e+02	3.178780e+03	9.213284e+01	
32.50	234.50	115.50	233.50	201.50	232.50	3.105880e+03	8.532785e+01	1.669468e+04	4.847707e+02	3.631360e+03	1.064208e+02	1.348702e+04	4.926447e+02	6.009400e+03	2.174408e+02	3.165260e+03	8.514832e+01	
23.50	213.50	107.50	211.50	194.50	211.50	3.195020e+03	1.056437e+02	1.851750e+04	4.460192e+02	3.803560e+03	1.514825e+02	1.425510e+04	4.189313e+02	6.485420e+03	2.257640e+02	3.228260e+03	8.053667e+01	
```

For consistency, intensities are always given as the sum of the brightest pixel intensities per video frame, regardless the units defined in
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units).

