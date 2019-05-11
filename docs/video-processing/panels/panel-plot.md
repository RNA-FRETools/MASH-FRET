---
layout: default
title: Plot
parent: /video-processing/panels.html
grand_parent: /video-processing.html
nav_order: 2
---

<img src="../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Plot
{: .no_toc }

Plot is the first panel module Video processing.

Use this panel to set the appearance and units in the 
[Visualization area](area-visualization.html).

<a href="../../assets/images/gui/VP-panel-plot.png"><img src="../../assets/images/gui/VP-panel-plot.png" style="max-width: 130px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Pixel intensity units

Pixel intensities are expressed in (image) counts and can be given in counts per second by checking the **Units per s.** box.

Intensity units are used for 
[Video visualization](area-visualization.html#video-visualization), in the 
[Create trace tool](area-visualization.html#create-trace-tool) and in
[.spots files](../..//output-files/spots-spots-coordinates.html).

**<u>default</u>:** intensities are given in count per second.

---

## Color map

It is the color palette used to display pixel intensities.

It can be changed by selecting a new color map in the list. 
The list offers the standard color maps in MATLAB:

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

**<u>default</u>:** `Jet`


