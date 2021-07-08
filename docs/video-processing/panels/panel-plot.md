---
layout: default
title: Plot
parent: Functionalities
grand_parent: Video processing
nav_order: 2
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Plot
{: .no_toc }

Plot is the first panel of module Video processing.

Use this panel to set the appearance and pixel intensity units in the 
[Visualization area](area-visualization.html).

<a class="plain" href="../../assets/images/gui/VP-panel-plot.png"><img src="../../assets/images/gui/VP-panel-plot.png" style="max-width: 130px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Pixel intensity units

Activate/deactivate this option to show pixel intensities in image counts per second/per frame.

Intensity units are used for 
[Video visualization](area-visualization.html#video-visualization), in the 
[Create trace tool](area-visualization.html#create-trace-tool) and in
[.spots files](../..//output-files/spots-spots-coordinates.html).

<u>default</u>: intensities are given in count per second.


---

## Color map

Use this list to define the color palette used to display pixel intensities.

The list contains the standard color maps of MATLAB:

| name     | palette                                                           |
| :------: | :---------------------------------------------------------------: |
| `Jet`    | <img src="../../assets/images/gui/VP-panel-plot-mapjet.png" />    |
| `Gray`   | <img src="../../assets/images/gui/VP-panel-plot-mapgray.png" />   |
| `Hot`    | <img src="../../assets/images/gui/VP-panel-plot-maphot.png" />    |
| `Cool`   | <img src="../../assets/images/gui/VP-panel-plot-mapcool.png" />   |
| `Spring` | <img src="../../assets/images/gui/VP-panel-plot-mapspring.png" /> |
| `Summer` | <img src="../../assets/images/gui/VP-panel-plot-mapsummer.png" /> |
| `Autumn` | <img src="../../assets/images/gui/VP-panel-plot-mapautumn.png" /> |
| `Winter` | <img src="../../assets/images/gui/VP-panel-plot-mapwinter.png" /> |
| `Pink`   | <img src="../../assets/images/gui/VP-panel-plot-mappink.png" />   |
| `Bone`   | <img src="../../assets/images/gui/VP-panel-plot-mapbone.png" />   |
| `Copper` | <img src="../../assets/images/gui/VP-panel-plot-mapcopper.png" /> |

<u>default</u>: `Jet`


