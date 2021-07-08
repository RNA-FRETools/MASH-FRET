---
layout: default
title: (*.crd) Simulated coordinates
parent: Output files
nav_exclude: 1
nav_order: 5
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Simulated coordinates files
{: .no_toc }

Simulated coordinates files are ASCII files with the extension `.crd`. They are usually found in the main`/simulations/coordinates` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

The simulated coordinates file is written in ASCII format and contain pixel positions of single molecules in the simulated video.

It is created in the `/simulations/coordinates` analysis sub-folder when exporting simulated coordinates in panel 
[Export options](../simulation/panels/panel-export-options.html) of module Simulation.


---

## File name

The file is named by the user during the export process.


---

## Structure

Coordinates are written in double precision and are organized in a column-wise fashion.
X- and y-coordinates in donor channel are written in columns 1 and 2 respectively, and in columns 3 and 4 for the acceptor channel.

```
4.2285969e+01   1.9739940e+02   1.7028597e+02   1.9739940e+02
1.6971164e+01   4.3859023e+01   1.4497116e+02   4.3859023e+01
1.2137841e+01   8.4467824e+01   1.4013784e+02   8.4467824e+01
```


---

## Compatibility

Simulated coordinates files can be imported:
* as reference or spots coordinates in panel 
[Coordinates transformation](../video-processing/panels/panel-molecule-coordinates.html#coordinates-transformation) by adjusting the corresponding 
[Import options](../video-processing/functionalities/set-coordinates-import-options.html) to the actual file structure
* as single molecule coordinates in panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#input-coordinates) by adjusting the corresponding import options
* as a graphic file in the 
[Visualization area](../video-processing/panels/area-visualization.html#load-videoimage-file) to visualize the simulated single molecule density
* together with ASCII trace files in module 
[Trace processing](../transition-analysis/workflow.html#import-single-molecule-data) for trace processing

