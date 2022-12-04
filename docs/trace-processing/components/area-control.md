---
layout: default
title: Control area
parent: Components
grand_parent: Trace processing
nav_order: 10
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Control area
{: .no_toc }

The control area consists in a navigation dashbord and the three main control buttons. 

Use this area to browse molecules in the sample and to refresh or export single molecule data.

<a class="plain" href="../../assets/images/gui/TP-area-control.png"><img src="../../assets/images/gui/TP-area-control.png" style="max-width: 258px;"/></a>

## Area components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Navigation dashboard

Defines the current molecule index.

<a class="plain" href="../../assets/images/gui/TP-area-control-nav.png"><img src="../../assets/images/gui/TP-area-control-nav.png" style="max-width: 258px;"/></a>

The index of the molecule which is currently in display can be edited in **(a)** and the total size of the molecule sample is shown in **(b)**.

Press 
![left arrow button](../../assets/images/gui/TP-but-arrow-left.png) or 
![right arrow button](../../assets/images/gui/TP-but-arrow-right.png) to display the previous or next molecule in the sample, respectively.

After changing the current molecule index, the 
[Visualization area](area-visualization.html) is updated and the processing parameters of panels 
[Sub-images](panel-subimage.html), 
[Background correction](panel-background-correction.html), 
[Factor corrections](panel-factor-corrections.html), 
[Photobleaching](panel-photobleaching.html), 
[Denoising](panel-denoising.html) and 
[Find states](panel-find-states.html) are adapted to the current molecule.


---

## Process current molecule data

Press
![UPDATE](../../assets/images/gui/TP-but-update.png "UPDATE") to update corrections and calculations for the current molecule.

Operations include all intensity corrections as configured in panels 
[Background correction](panel-background-correction.html), 
[Cross talks](panel-cross-talks.html), 
[Denoising](panel-denoising.html), 
[Photobleaching](panel-photobleaching.html) and 
[Factor corrections](panel-factor-corrections.html), as well as calculations of state trajectories as configured in panel 
[Find states](panel-find-states.html).

Usually, this functionality is used after changing any processing parameters in the sub-mentioned panels.

After processing, input data in modules 
[Histogram analysis](../../histogram-analysis.html) and 
[Transition analysis](../../transition-analysis.html) are immediately refreshed.


---

## Process all molecules data

Press 
![UPDATE ALL](../../assets/images/gui/TP-but-update-all.png "UPDATE ALL") to update corrections and calculations for all molecules in the sample.

<img src="../../assets/images/gui/TP-panel-sample-update-all-loadingbar.png" style="max-width:389px;">

Operations include all intensity corrections as configured in panels 
[Background correction](panel-background-correction.html), 
[Cross talks](panel-cross-talks.html), 
[Denoising](panel-denoising.html), 
[Photobleaching](panel-photobleaching.html) and 
[Factor corrections](panel-factor-corrections.html), as well as calculations of state trajectories as configured in panel 
[Find states](panel-find-states.html).

After processing, input data in modules 
[Histogram analysis](../../histogram-analysis.html) and 
[Transition analysis](../../transition-analysis.html) are immediately refreshed.

Usually, this functionality is used before 
proceeding with histogram or transition analysis, 
[saving the MASH project](area-project-management.html#save-project) or opening the 
[Trace manager](#trace-manager).


---

## Export processed data

Press
![EXPORT...](../../assets/images/gui/TP-but-exportdotdotdot.png "EXPORT...") to open the export options.

Export options defines the file formats to export, including ASCII files and figures.

To set export options, refer to 
[Set export options](../functionalities/set-export-options.html).


