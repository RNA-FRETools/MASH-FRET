---
layout: default
title: Set export options
parent: /transition-analysis/functionalities.html
grand_parent: /transition-analysis.html
nav_order: 1
---

<img src="../../assets/images/logos/logo-transition-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Set export options
{: .no_toc }

Export options define the particular files to export from an analysis with module Transition analysis.

The window is accessed by pressing 
![Export](../../assets/images/gui/TA-but-export.png "Export") in the project management area of module Transition analysis.

Press 
![Next >>](../../assets/images/gui/TA-but-next-supsup.png "Next >>") to start file export.

<a href="../../assets/images/gui/TA-area-project-management-export.png"><img src="../../assets/images/gui/TA-area-project-management-export.png" style="max-width: 246px;"/></a>

## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Transition density plot (TDP)

Use this panel to define the file formats to export the TDP and clustering results.

<img src="../../assets/images/gui/TA-area-project-management-export-tdp.png" style="max-width: 219px;"/>

The TDP can be exported to ASCII files by activating the option in **(a)**.
In this case, the TDP can be exported in the different format listed in **(b)**:
* `matrix(*.tdp)`: exported as a matrix
* `gauss. convoluted matrix(*.tdp)`: exported as a Gaussian-filtered matrix
* `coordinates (x,y,occurrence)(*.txt)`: exported as 3D-coordinates
* `all(*.tdp, *.txt)`: all three formats

For more information about the file structures, please refer to 
[Transition density plot file](../../output-files/tdp-transition-density-plot.html) and 
[Transition density coordinates file](../../output-files/txt-transition-density-coordinates.html).

The TDP matrix can also be exported to a PNG image file by activating the option in **(c)** and selecting one of the plot listed in **(d)**:
* `original`: shows initial transition counts
* `Gaussian-convoluted`: shows Gaussian-filtered counts
* `all`: export both images

**Note:** *Transition densities written in files are counted as defined in 
[Transition count](../panels/panel-transition-density-plot.html#transition-count)*


---

## Kinetic analysis

Use this panel to define the file formats to export dwell time histograms and fitting results.

<img src="../../assets/images/gui/TA-area-project-management-export-kin.png" style="max-width: 218px;"/>

Dwell time histograms can be exported to ASCII 
[.hdt files](../../output-files/hdt-dwelltime-histogram.html) by activating the options in **(a)**.

Fitting results can also be exported to separated ASCII
[.fit files](../../output-files/fit-dwelltime-fit.html) by activating the option in **(b)**. 

If the fitting 
[Method settings](../panels/panel-state-transition-rates.html#method-settings) include BOBA-FRET, the same exported file can be appended with bootstrapping parameters and results by activating the option in **(c)**.

