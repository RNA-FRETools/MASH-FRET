---
layout: default
title: Intensity integration
parent: /video-processing/panels.html
grand_parent: /video-processing.html
nav_order: 6
---

# Intensity integration
{: .no_toc }

<a href="../../assets/images/gui/VP-panel-integration.png"><img src="../../assets/images/gui/VP-panel-integration.png" style="max-width: 562px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Input video

Manages the import of single molecule video used to build intensity-time traces.

<a href="../../assets/images/gui/VP-panel-integration-loadvid.png"><img src="../../assets/images/gui/VP-panel-integration-loadvid.png" style="max-width: 345px;"/></a>

The single molecule video is imported from a file by pressing 
![...](../../assets/images/gui/VP-but-3p.png).
Supported file formats are described in detail in 
[Load video/image file](visualization-area.html#load-videoimage-file).
The imported file name is then displayed in **(a)**.


---

## Input coordinates

Manages the import of single molecule coordinates used to build intensity-time traces.

<a href="../../assets/images/gui/VP-panel-integration-loadcoord.png"><img src="../../assets/images/gui/VP-panel-integration-loadcoord.png" style="max-width: 426px;"/></a>

Single molecule coordinates are imported from an ASCII file by pressing 
![...](../../assets/images/gui/VP-but-3p.png).
The imported file name is then displayed in **(a)**.

Coordinates are read from the file following user-defined import settings.
Import settings can be accessed and modified by pressing 
![Options ...](../../assets/images/gui/VP-but-options3p.png).
In that case the import option window opens:

<a href="../../assets/images/gui/VP-panel-integration-loadcoord-impopt.png"><img src="../../assets/images/gui/VP-panel-integration-loadcoord-impopt.png" style="max-width: 226px;"/></a>

Single molecule coordinates are coordinates co-localized in each channel, with channel-specific coordinates being written in a column-wise fashion to the file. 
This means that coordinates (x,y) of one single molecule in individual channels must be written on the same line and in different columns.

A number of file header lines set in **(b)** is skipped before reading coordinates data.
The column indexes in the file where channel-specific x- and y-coordinates are written, are set in **(c)** and **(d)** respectively.
Import settings are saved only after pressing 
![Ok](../../assets/images/gui/VP-but-ok.png).


---

## Integration parameters

These are the settings used to calculate intensities in intensity-time traces.

<a href="../../assets/images/gui/VP-panel-integration-calculation.png"><img src="../../assets/images/gui/VP-panel-integration-calculation.png" style="max-width: 214px;"/></a>

To obtain the single molecule intensity at one particular frame or time point, a square area of dimension **(a)** pixels around the molecule coordinates is defined and the **(b)** brightest pixel values in this area are summed up.

Only summed intensities are written to files during export.
However, intensity-time traces can be plotted as average intensity per pixel by checking the box in **(c)**.
In this case, the y-axis of intensity-time trace plots when using the 
[Create trace tool](area-visualization.html#create-trace-tool) is affected.


---

## Export options

These settings define the file formats to export.

To set export options, please refer to 
[Set export options](../functionalities/set-export-options.html).


---

## Create and export intensity-time traces

Command that starts intensity calculations for each molecule coordinates present in 
[Input coordinates](#input-coordinates), on each video frame present in 
[Input video](#input-video), with parameters defined in 
[Integration parameters](#integration-parameters), and exports single molecule intensity-time traces to files selected in 
[Export options](#export-options).

This process is relatively slow as the underlying algorithm is adapted to low-RAM computer: pixel values in the video are not loaded all at once in memory but the video file is browsed every time a pixel value is needed for calculation. 
For more information, please refer to the respective functions in the source code:

```
MASH-FRET/source/traces/creation/create_trace.m
MASH-FRET/source/traces/creation/getIntTrace.m
```



