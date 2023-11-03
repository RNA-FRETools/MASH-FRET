---
layout: default
title: Visualization area
parent: Components
grand_parent: Trace processing
nav_order: 11
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Visualization area
{: .no_toc }

The visualization area is the main display of module Trace processing. 
It consists in one tab showing molecule images and trajectories.

Use this area to visualize processed and calculated data. 
Any graphics in MASH-FRET can be exported to an image file by right-clicking on the axes and selecting `Export graph`.

## Area components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Traces

Use this tab to visualize the current molecule images and trajectories.

<a class="plain" href="../../assets/images/gui/TP-area-visu-traces.png"><img src="../../assets/images/gui/TP-area-visu-traces.png" style="max-width: 595px;"/></a>

* **(1)** [Single molecule images](#single-molecule-image)
* **(2)** [Intensity-time traces and histograms](#intensity-time-traces-and-histograms)
* **(3)** [Ratio-time traces and histograms](#ratio-time-traces-and-histograms)


### Single molecule images
{: .no_toc }

Single molecule images show a close-up on the current single molecule position in each detection channel.
Average image at specific laser illumination are used.
Laser illumination and image appearance can be adjusted in panel 
[Sub-images](panel-subimage.html).

![Molecule image](../../assets/images/gui/TP-area-visu-traces-subimages.png "Molecule image")

Single molecule positions are indicated by crosses and framed by squares used for intensity integration; see 
[Integration parameters](../../video-processing/components/panel-intensity-integration.html#integration-parameters) for more information.

The position of the current molecule selected in the 
[Molecule list](panel-sample-management.html#molecule-list) is displayed in red, whereas other molecules are displayed in yellow.
When using the `Dark trace` background correction method, dark coordinates are shown in green; see 
[Background correction settings](panel-background-correction.html#background-correction-settings) for more information.


### Intensity-time traces and histograms
{: .no_toc }

Trace axes show the current single molecule intensity-time traces selected in 
[Plot in top axes](panel-plot.html#plot-in-top-axes), using intensity and time units defined in menu `Units` of the 
[menu bar](../../Getting_started.html#interface) as well as intensity limits defined in 
[Plot in top axes](panel-plot.html#plot-in-top-axes).
Histogram axes show the corresponding intensity histograms built by sorting intensities in 100 bins between the minimum and maximum intensities.

![Intensity-time traces](../../assets/images/gui/TP-area-visu-traces-top.png "Intensity-time traces")

The time axis of trace axes can be truncated by setting the starting point in 
[Time axis](panel-plot.html#time-axis) and the ending point in 
[Photobleaching cutoff](panel-photobleaching.html#photobleaching-cutoff).

Colors used in trace and histogram plots are defined in the experiment settings. 
They can be modified any time by pressing 
![Edit project](../../assets/images/gui/interface-but-editproj.png "Edit project") in the 
[project management area](../../Getting_started.html#project-management-area). 


### Ratio-time traces and histograms
{: .no_toc }

Trace axes show the current single molecule FRET- and stoichiometry-time traces selected in 
[Plot in bottom axes](panel-plot.html#plot-in-bottom-axes), using time units defined in menu `Units` of the 
[menu bar](../../Getting_started.html#interface), and histogram axes show the corresponding histograms built by sorting FRET and stoichiometry values into bins of size 0.01 between -0.2 and 1.2.

![Ratio-time traces](../../assets/images/gui/TP-area-visu-traces-bottom.png "Ratio-time traces")

The time axis of trace axes can be truncated by setting the starting point in 
[Time axis](panel-plot.html#time-axis) and the ending point in 
[Photobleaching cutoff](panel-photobleaching.html#photobleaching-cutoff).

FRET and stoichiometry calculations, as well as colors used in trace and histogram plots, are defined in the experiment settings. 
They can be modified any time by pressing 
![Edit project](../../assets/images/gui/interface-but-editproj.png "Edit project") in the 
[project management area](../../Getting_started.html#project-management-area). 


