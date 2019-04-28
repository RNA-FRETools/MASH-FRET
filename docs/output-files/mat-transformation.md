---
layout: default
title: (*.mat) Transformation
parent: /output-files.html
nav_order: 20
nav_exclude: 1
---


# Transformation files
{: .no_toc }

Transformation files are binary Matlab files with the extension `.mat`. They are usually found in the main`/video_processing/coordinates/transformed` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

The transformation file is written in the MATLAB binary format and contains the channel transformation.

It is created in the `/video_processing/coordinates/transformed` analysis sub-folder when calculating and exporting the channel transformation in panel 
[Coordinates transformation](../video-processing/panels/panel-molecule-coordinates.html#coordinates-transformation) of module Video processing.

---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>reference coordinates file</u> loaded in panel 
[Coordinates transformation](../video-processing/panels/panel-molecule-coordinates.html#coordinates-transformation).


---

## Structure

Transformations are created from reference coordinates with the MATLAB build-in functions:
* `fitgeotrans` for MATLAB versions newer than 9.0 (R2016a)
* `cp2tform` otherwise

Please visit the respective sections of MATLAB's documentation 
([cp2tform](https://fr.mathworks.com/help/images/ref/cp2tform.html) and 
[fitgeotrans](https://fr.mathworks.com/help/images/ref/fitgeotrans.html)) for more information about the file content.


---

## Compatibility

Transformation files can be imported as channel transformation in panel 
[Coordinates transformation](../video-processing/panels/panel-molecule-coordinates.html#coordinates-transformation) to transform spots coordinates to single molecule coordinates.

Transformation files are MATLAB binary files and can be imported in MATLAB's workspace by simply drag-and-dropping the file, or by typing in MATLAB's command window:

```matlab
load('datafolder\transformation-file.mat','-mat');
```

and replacing `datafolder\transformation-file.mat` by your actual file name and directory.
