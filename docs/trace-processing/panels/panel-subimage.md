---
layout: default
title: Sub-images
parent: /trace-processing/panels.html
grand_parent: /trace-processing.html
nav_order: 4
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Sub-images
{: .no_toc }

Sub-images is the third panel of module Trace processing.

Use this panel to adjust the appearance of 
[Single molecule images](area-visualization.html#single-molecule-images) and adjust molecule positions.

<a class="plain" href="../../assets/images/gui/TP-panel-subimages.png"><img src="../../assets/images/gui/TP-panel-subimages.png" style="max-width: 292px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Single molecule images

Use this interface to set the appearance of single molecule images.

<a class="plain" href="../../assets/images/gui/TP-panel-subimages-images.png"><img src="../../assets/images/gui/TP-panel-subimages-images.png" style="max-width: 265px;"/></a>

Single molecule sub-images are clipped out of the average video frame with dimensions set in 
[Background correction settings](panel-background-correction.html#background-correction-settings).

Sub-images are shown for a particular laser illumination that can be selected in menu **(a)**.

The brightness and contrast of sub-images can be adjusted by using the respective sliding bars in **(b)** and **(c)**.
These functionalities show useful when the single molecule is too bright or the signal is too low.


---

## Single molecule coordinates

Use this interface to adjust single molecule positions.

<a class="plain" href="../../assets/images/gui/TP-panel-subimages-coord.png"><img src="../../assets/images/gui/TP-panel-subimages-coord.png" style="max-width: 267px;"/></a>

X- and y- pixel coordinates of the current single molecule in video channel selected in list **(a)** can be modified manually in **(b)** and **(c)** respectively. 

Molecule positions can also be automatically recentered on the nearest brightest pixels by pressing 
![recenter all](../../assets/images/gui/TP-but-recenter-all.png "recenter all").
In that case, the algorithm iteratively looks for the brightest pixel in a 3-by-3 pixel area around the initial positions in each detection channel, and stop after a maximum of three iterations.

After recentering, new intensity-time traces are calculated and initial shifted positions are lost.

The algorithm works with the average image calculated for laser illumination defined in 
[Single molecule images](#single-molecule-images).

