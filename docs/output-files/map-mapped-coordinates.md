---
layout: default
title: (*.map) Mapped coordinates
parent: /output-files.html
nav_order: 17
nav_exclude: 1
---


# Mapped coordinates files
{: .no_toc }

Mapped coordinates files are ASCII files with the extension `.map`. They are usually found in the main`/video_processing/coordinates/mapping` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Map coordinates files are written in ASCII format and contains reference coordinates mapped with the 
[Mapping tool](../video-processing/functionalities/use-mapping-tool.html).

They are created in the `/video_processing/coordinates/mapping` analysis sub-folder when exporting mapped coordinates with the 
[Mapping tool](../video-processing/functionalities/use-mapping-tool.html) of module Video processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>reference image file</u> loaded in 
[Mapping tool](../video-processing/functionalities/use-mapping-tool.html).


---

## Structure

Coordinates are written in double precision and are organized in a row-wise fashion with coordinates corresponding to one emitter in each channel being written successively on separated lines, and in a column-wise fashion with columns `x` and `y` containing x- and y- reference coordinates respectively.

```
x		y
1.045000e+02	2.365000e+02
2.325000e+02	2.365000e+02
6.250000e+01	2.385000e+02
```


---

## Compatibility

Mapped coordinates files can be imported:
* as reference or spots coordinates in panel 
[Coordinates transformation](../video-processing/panels/panel-molecule-coordinates.html#coordinates-transformation) by adjusting the corresponding 
[Import options](../video-processing/functionalities/set-coordinates-import-options.html) to the actual file structure
* as single molecule coordinates in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#input-coordinates) by adjusting the corresponding import options
* together with ASCII trace files in module 
[Trace processing](../transition-analysis/workflow.html#import-single-molecule-data) for trace processing

