---
layout: default
title: Experiment settings
parent: Functionalities
grand_parent: Video processing
nav_order: 3
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Experiment settings
{: .no_toc }

Experiment settings is the second panel of module Video processing.

Use this panel to inform MASH-FRET about your experiment setup and set project options.

<a class="plain" href="../../assets/images/gui/VP-panel-expset.png"><img src="../../assets/images/gui/VP-panel-expset.png" style="max-width: 426px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Number of alternated lasers

Defines the number of alternated lasers with different wavelengths used in the experiment. 

For continuous-wavelength excitation, *e.g.* in videos simulated with MASH-FRET, it is set to 1.

<u>default</u>: 1


---

## Laser wavelengths

Use this interface to define the relevant wavelengths of each alternated laser. 

<a class="plain" href="../../assets/images/gui/VP-panel-expset-laser.png"><img src="../../assets/images/gui/VP-panel-expset-laser.png" style="max-width: 138px;"/></a>

Laser wavelengths are used to label data and identify which channel is directly excited by the laser; see 
[Video channels](../functionalities/set-project-options.html#video-channels) for more details.

To set the wavelength, select the laser index in **(a)** and set the wavelength in **(b)**. 
Laser indexes correspond to the order of appearance in the video and can easily be identified by navigating through the first frames of the video; see 
[Navigation](area-visualization.html#navigation) for more information.

<u>default</u>: 
* laser 1: 532 nm (wavelength used to excite Cy3)
* following lasers: previous laser's wavelength increased by 20%


---

## Number of video channels

Defines the number of horizontal divisions in the video, each usually corresponding to a detection wavelength range, and thus, to an emitter.

Upon modification, channel-dependant parameters and channel limits on video display are automatically updated.

<u>default</u>: 2


---

## Exposure time

It is the time spent by the camera to acquire one video frame.

It is noted 
[*t*<sub>exp</sub>](){: .math_var } and is linked to the video frame rate 
[*f*](){: .math_var } by the relation:

{: .equation }
<img src="../../assets/images/equations/VP-eq-exp-time.gif" alt="t_{\textup{exp}} = \frac{1}{f}">

with 
[*f*](){: .math_var } in frame per second (fps).

It is automatically updated from the video file. 
If the file does not contain such information, it must be set manually.

<u>default</u>: [*t*<sub>exp</sub>](){: .math_var } = 1 second


---

## Project options

Press 
![Options...](../../assets/images/gui/VP-but-options3p.png "Options...") to open settings of the 
[.mash project](../../output-files/mash-mash-project.html) file exported at the end of Video processing workflow; see 
[Workflow](../workflow.html) for more information.

To set the project options, please refer to 
[Set project options](../functionalities/set-project-options.html).

Project options can be modified any time in module Trace processing; see 
[Edit project options](../../trace-processing/panels/area-project-management.html#edit-project-options) for more information.

