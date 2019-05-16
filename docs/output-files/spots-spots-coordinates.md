---
layout: default
title: (*.spots) Spotfinder coordinates
parent: /output-files.html
nav_order: 24
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Spotfinder coordinates files
{: .no_toc }

Spotfinder coordinates files are ASCII files with the extension `.spots`. They are usually found in the main`/video_processing/coordinates/spotfinder` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

The spots coordinates file is written in ASCII format and contain pixel positions of bright spots detected with 
[Spotfinder](../video-processing/panel-molecule-coordinates.html#spot-finder).

It is created in the `/video_processing/coordinates/spotfinder` analysis sub-folder when saving spots coordinates in panel 
[Molecule coordinates](../video-processing/panel-molecule-coordinates.html#spot-finder) of module Video processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>image/video file</u> name loaded in 
[Video processing](../video-processing.html).


---

## Structure

Coordinates are written in double precision and are organized in a column-wise fashion with:
* columns `x` and `y` containing x- and y- spots coordinates respectively
* column `I` containing the pixel intensities at spots positions using 
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units)
* column `frame` containing frame indexes on which the spot detection was performed

```
x		y		I	frame
1.450000e+01	3.450000e+01	518	1
7.350000e+01	2.150000e+01	542	1
1.350000e+01	1.405000e+02	547	1
```

In the case where the 
[Method settings](/video-processing/panels/panel-molecule-coordinates.html#spotfinder) include Gaussian fitting, the column `I` contains Gaussian numeric integrals and the following columns and inserted:
* `assymetry` containing spot asymmetries in %, being equal of greater than 100%
* `width` and `height` containing Gaussian standard deviations in the x- and y- direction respectively and given in pixel
* `theta` Gaussian orientation in radian
* `z-offset` Gaussian offset given in 
[Pixel intensity units](../video-processing/panels/panel-plot.html#pixel-intensity-units)

```
x		y		I		assymetry	width		height		theta		z-offset	frame
1.500000e+01	3.800000e+01	1.200463e+02	1.000000e+00	3.402311e-01	3.402311e-01	-3.230343e+04	1.129999e+03	1
1.033617e+02	1.942211e+02	1.212129e+02	1.162688e+00	8.045870e-01	6.920058e-01	-9.087937e+00	1.129771e+03	1
3.499995e+01	1.107173e+02	1.260142e+02	1.708943e+00	7.835743e-01	4.585141e-01	-1.169097e+05	1.129877e+03	1
```


---

## Compatibility

Spots coordinates files can be imported for coordinates transformation in panel 
[Coordinates transformation](../video-processing/panels/panel-molecule-coordinates.html#coordinates-transformation) by adjusting the corresponding 
[Import options](../video-processing/functionalities/set-coordinates-import-options.html) to the actual file structure


