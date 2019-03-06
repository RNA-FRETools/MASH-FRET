---
layout: default
title: Simulation workflow
parent: Simulation
nav_order: 2
---

# Simulation workflow
{: .no_toc }

In this section you will learn how to create synthetic single molecule videos and trajectories. Exported data can then be used for 
[result validation](../tutorials/validate-results), 
[algorithm testing](../tutorials/test-algorithms) or external illustration.

The procedure includes three steps:

1. TOC
{:toc}

## Generate random FRET state sequences

A FRET state sequence is the ideal FRET trajectory followed by a single molecule. 
It consists in a succession of plateaus dwelling at a particular *FRET*j value before transiting to the next *FRET*j'. 

Sequences are created by randomly drawing FRET values and dwell times from the thermodynamic model, which includes possible *FRET*j values and state transition rates *k*jj'. 
The operation is repeated until the sequence length reaches the observation time and the number of sequences equals the number of molecules *N*. 
The observation time is limited by the video length *L* but can be randomly distributed by introducing fluorophore photobleaching.

![FRET state sequence](../assets/images/figures/sim-workflow-scheme-state-sequence.png "Generate FRET state sequences")

To generate FRET state sequences:

{: .bg-grey-lt-000 .pt-3 .pb-2 .pl-7 .pr-4}
1. Set parameters:  
     
   [Video length](panels/panel-video-parameters#video-length)  
   [Frame rate](panels/panel-video-parameters#frame-rate)  
   [Number of molecules](panels/panel-molecules#number-of-molecules)  
   [State configuration](panels/panel-molecules#state-configuration)  
   [Transition rates](panels/panel-molecules#transition-rates)  
   [Photobleaching](panels/panel-molecules#photobleaching)  
     
1. Press 
![Generate](../assets/images/gui/but-sim-generate.png "Generate") to generate random FRET state sequences,  
     
1. Generate new state sequences whenever one of the parameters is changed.


## Create intensity trajectories and images 

FRET state sequences are then converted into donor and acceptor fluorescence intensities using *I*tot,em, the pure donor emission in the absence of acceptor.

Donor anisotropy is introduced here, by adjusting donor fluorescence intensities with the gamma factor *g*.

Imperfect experimental setup is simulated by adding channel-specific bleedthrough *bt* and direct excitation *dE* to the respective fluorescence intensities.

![Conversion to fluorescence](../assets/images/figures/sim-workflow-scheme-convert-to-intensity.png "Convert sequences to fluorescence intensities")

Final camera-detected intensity-time traces are obtained by adding channel-specific background and uniform camera noise.
If the chosen noise model does not include shot noise of photon emission, intensities are distributed following a Poisson distribution prior adding the camera contribution; see 
[Camera SNR characteristics](panels/panel-video-parameters#camera-snr-characteristics) for more information.

![Conversion to image counts](../assets/images/figures/sim-workflow-scheme-convert-to-image-count.png "Convert fluorescence intensities to image counts")

Images in the single molecule video (SMV) are created one by one, with the first image corresponding to the first time point in intensity-time traces.
Like in a 2-color FRET experiment, horizontal dimensions of the video are equally split into donor (left) and acceptor (right) channels. 
Single molecules are then spread randomly on the donor channel and directly translated into the acceptor channel.

At molecule coordinates, pixel values are set to donor or acceptor pure fluorescence intensities, including donor anisotropy and setup cross-talks.
Channel-specific fluorescent background is added to consider all sources of detected lights. 
Pixels are then convolved with channel-specific point spread functions to obtain realistic diffraction-limited images. 
Finally, uniform camera noise is added to all pixels to convert fluorescence intensities to camera-detected signal. 

![Building SMV](../assets/images/figures/sim-workflow-scheme-build-video.gif "Building SMV from fluorescence intensity-time traces")

To create intensity trajectories and images:

{: .bg-grey-lt-000 .pt-3 .pb-2 .pl-7 .pr-4}
1. Set parameters:  
     
   [Video dimensions](panels/panel-video-parameters#video-dimensions)  
   [Pixel size](panels/panel-video-parameters#pixel-size)  
   [Bit rate](panels/panel-video-parameters#bit-rate)  
   [Camera SNR characteristics](panels/panel-video-parameters#camera-snr-characteristics)  
   [Molecule coordinates](panels/panel-molecules#molecule-coordinates)  
   [Donor emission](panels/panel-molecules#donor-emission)  
   [Cross-talks](panels/panel-molecules#cross-talks)  
   [Point spread functions](panels/panel-experimental-setup#point-spread-functions)  
   [Background](panels/panel-experimental-setup#background)  
     
1. Press 
![Update](../assets/images/gui/but-sim-update.png "Update") to convert FRET state sequences into camera-detected intensity trajectories and images. The execution time can be long; see 
[Remarks](#remarks) for details.  
     
1. Update intensity data whenever one of the parameters is changed.


## Export trajectories and video to files

Simulated data and simulation parameters can be exported to various file formats.
Intensities can be converted into photon counts or electron counts before writing in files.
When exporting the SMV, video frames are successively written in files until the video length is reached.

To export data to files:

{: .bg-grey-lt-000 .pt-3 .pb-2 .pl-7 .pr-4}
1. Set parameters:
     
   [File options](panels/panel-export-options#file-options)  
   [Intensity units](panels/panel-export-options#intensity-units)
     
1. Press 
![Export files](../assets/images/gui/but-sim-export.png "Export files") to start writing data in files. The execution time can be long; see 
[Remarks](#remarks) for details.
 
## Remarks
{: .no_toc }

Updating intensity data and writing SMVs to files can be very time consuming depending on which camera characteristics are chosen; see 
[Camera SNR characteristics](panels/panel-video-parameters#camera-snr-characteristics) for more information.

Some parameters can be set by loading external files. This allows to bypass the limitations of the user interface in order to work with more than five states or set parameters for individual molecules; see 
[Pre-set parameters](panels/panel-molecules#pre-set-parameters) for more information.

