---
layout: default
title: Visualization area
parent: /simulation/panels.html
grand_parent: /simulation.html
nav_order: 5
---

<img src="../../assets/images/logos/logo-simulation_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Visualization area
{: .no_toc }

The visualization area is the main display of module Simulation. 

Use this area to visualize simulated data and control action logs.

<a class="plain" href="../../assets/images/gui/sim-area-visualization.png"><img src="../../assets/images/gui/sim-area-visualization.png" /></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Control panel 

Lists the action logs. 

Actions are automatically saved in a 
[daily log file](../../output-files/log-daily-logs.html).


---

## Intensity histograms

Shows the donor (blue) and acceptor (red) intensity distributions in simulated intensity-time traces of molecule n:°1. 

Histograms are built with the MATLAB built-in function `histcounts` that determines the optimal number of bins.

Intensity units are set in 
[Intensity units](panel-export-options.html#intensity-units).

Any graphics in MASH can be exported to an image file by right-clicking on the axes and selecting `Export graph`.

---


## Simulated intensity-time traces

Shows the simulated donor (blue) and acceptor (red) intensity-time traces for molecule n:°1. 

Intensity units are set in 
[Intensity units](panel-export-options.html#intensity-units).

Any graphics in MASH can be exported to an image file by right-clicking on the axes and selecting `Export graph`.

---


## Simulated video

Shows the first frame of the simulated single molecule video. 

The color scale for pixel values is indicated by the color bar. Pixel intensity units are set in 
[Intensity units](panel-export-options.html#intensity-units).

Any graphics in MASH can be exported to an image file by right-clicking on the axes and selecting `Export graph`.
