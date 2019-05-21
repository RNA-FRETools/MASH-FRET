---
layout: default
title: Experimental setup
parent: /simulation/panels.html
grand_parent: /simulation.html
nav_order: 3
---

<img src="../../assets/images/logos/logo-simulation_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Experimental setup
{: .no_toc }

Experimental setup is the third panel of module Simulation. 

Use this panel to define experimental variables related to the measuring setup, including the background light and diffraction limit.

<a class="plain" href="../../assets/images/gui/sim-panel-experimental-setup.png"><img src="../../assets/images/gui/sim-panel-experimental-setup.png" style="max-width: 220px;"  /></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Point spread functions

Use these settings to simulate diffraction-limited images.

<a class="plain" href="../../assets/images/gui/sim-panel-experimental-setup-psf.png"><img src="../../assets/images/gui/sim-panel-experimental-setup-psf.png" style="max-width: 177px;" /></a>

The point spread function (PSF) shapes the intensity 2D-profile of single molecules as diffraction-limited spots. 
The PSF is modelled with a spherical 2D-Gaussian centred on the single molecule coordinates and with a standard deviation 
[*w*<sub>det</sub>](){: .math_var }.
As the PSF width depends on the wavelength of the detected light, it is different for the donor and the acceptor channel.

PSF convolution is activated by activating the option in **(a)**.
The donor and acceptor PSF widths 
[*w*<sub>det,D</sub>](){: .math_var } and 
[*w*<sub>det,A</sub>](){: .math_var } are set in micrometers in **(b)** and **(c)** respectively.

<u>default</u>: PSF convolution is activated and defined according to our setup:
* [*w*<sub>det,D</sub>](){: .math_var } = 0.353 &#956;m
* [*w*<sub>det,A</sub>](){: .math_var } = 0.383 &#956;m

**Note:** *Pixel values are calculated by numerical integration of each 2D-Gaussian and can be relatively time consuming for large PSF.*


---

## Defocusing

Use these settings to simulate defocusing while video recording.

<a class="plain" href="../../assets/images/gui/sim-panel-experimental-setup-defocus.png"><img src="../../assets/images/gui/sim-panel-experimental-setup-defocus.png" style="max-width: 220px;" /></a>

*Under construction.*


---

## Background

Use these settings to generate a channel-specific background signal.

<a class="plain" href="../../assets/images/gui/sim-panel-experimental-setup-background.png"><img src="../../assets/images/gui/sim-panel-experimental-setup-background.png" style="max-width: 200px;" /></a>

The background is a source of unwanted photons that adds up to each video channel. 
It can be uniform in space or spatially distributed, but also constant or dynamic in time.


### Uniform background
{: .no_toc}

To apply a uniform background, select `Uniform` in list **(a)**. 

Background intensities are set in **(b)** and **(c)** for donor and acceptor channel respectively and are given in units defined by 
[Intensity units](panel-molecules.html#intensity-units).

Experimental 
[*bg*<sub>D</sub>](){: .math_var } and 
[*bg*<sub>A</sub>](){: .math_var } values in image counts are obtained by subtracting the known camera offset to the background intensities calculated in Trace processing; see 
[Background correction](../../trace-processing/panels/panel-subimage-background-correction.html#background) for more information about background correction.

<u>default</u>: no background light
* [*bg*<sub>D</sub>](){: .math_var } = 0 pc
* [*bg*<sub>A</sub>](){: .math_var } = 0 pc


### Gaussian-distributed background
{: .no_toc}

The background is spatially distributed following a 2D-Gaussian model. 
This can be used to model a realistic TIRF excitation profile.

To apply a <u>2D-Gaussian background</u>, select `2D Gaussian profile` in list **(a)**.

In that case, the background follows a 2D-Gaussian distribution centred on each channel, having common x- and y-standard deviations, 
[*w*<sub>0,ex,x</sub>](){: .math_var } and 
[*w*<sub>0,ex,y</sub>](){: .math_var }, given in pixels and set in **(d)** and **(e)** respectively.

Gaussian amplitudes 
[*bg*<sub>D</sub>](){: .math_var } in donor channel and 
[*bg*<sub>A</sub>](){: .math_var } in acceptor channel are set in **(b)** and **(c)** respectively and are given in units defined in 
[Intensity units](panel-molecules.html#intensity-units).

<u>default</u>: 2D-Gaussian widths are set to half-channel dimensions in a video of 256-by-256 pixels:
* [*w*<sub>0,ex,x</sub>](){: .math_var } = 64 px
* [*w*<sub>0,ex,y</sub>](){: .math_var } = 128 px


### Background from image file
{: .no_toc}

The spatial distribution of the background is set by an external image file. 
This can be used to reproduce image imperfections present in experimental recordings.

To add a <u>background image</u>, select `Pattern` in list **(a)**.

In that case, the background image or video must be imported just after pressing 
![Update](../../assets/images/gui/sim-but-update.png "Update").

Supported graphic file formats are: *.<u>sif</u>, *.<u>sira</u>, *.<u>tif</u>, *.<u>gif</u>, *.<u>png</u>, *.<u>spe</u>, *.<u>pma</u>.
If the loaded file is a video, the first frame will be used as the background image.

<u>default</u>: no background image is loaded.


### Background decaying in time
{: .no_toc}

The background intensities are decaying in time. 
This can be used to model the photobleaching of an autofluorescent medium.

To obtain uniform or spatially distributed background intensities decaying in time, activate the option in **(f)**.

In that case, the background intensity in each pixel decays exponentially with a time decay constant
[*dec*](){: .math_var } given in seconds and set in **(g)**.
The starting background intensities can be modulated by a factor 
[*amp*](){: .math_var } set in **(h)**. 

<u>default</u>: decay time constant is set to 10 times the default trajectory length:
* [*dec*](){: .math_var } = 4000 seconds
* [*amp*](){: .math_var } = 1



