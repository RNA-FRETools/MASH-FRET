---
layout: default
title: Main simulation procedure
parent: Simulation functionalities
grand_parent: Simulation
nav_order: 1
---

# Main simulation procedure 
{: .no_toc }

In this procedure you will create synthetic single molecule videos and trajectories. Exported data can then be used for 
[result validation](../../tutorials/validate-results), 
[algorithm testing](../../tutorials/test-algorithms) or external illustration.

The procedure includes three steps:

1. TOC
{:toc}

## Generate random FRET state sequences

A FRET state sequence is the ideal FRET trajectory followed by a single molecule. 
It consists in a succession of plateaus dwelling at a particular `FRETj` value before transiting to the next `FRETj'`. 

Sequences are created by randomly drawing FRET values and dwell times from the thermodynamic model, which includes possible `FRETj` values and state transition rates `kjj'`. 
The operation is repeated until the sequence length reaches the observation time and the number of sequences equals the number of molecules `N`. 
The observation time is limited by the video length `L` but can be randomly distributed by introducing fluorophore photobleaching.

![Scheme of FRET sequence](../../assets/images/sim-scheme-state-sequence.png "Example of FRET sequence")

To generate FRET state sequences:

{: .bg-grey-lt-000}
1. Set parameters:  
     
   [length](../panels/panel-video-parameters#length),  
   [frame rate](../panels/panel-video-parameters#frame-rate),  
   [number of molecules](../panels/panel-molecules#number-of-molecules-n),  
   [Thermodynamic model](../panels/panel-molecules#thermodynamic-model),  
   [Photobleaching](../panels/panel-photophysics#photobleaching).  
     
1. Press 
![Generate](../../assets/images/but-sim-generate.png "Generate") to generate random FRET state sequences,  
     
1. Generate new state sequences whenever one of the parameters is changed.


## Create intensity trajectories and images 

FRET state sequences are then converted into donor and acceptor fluorescence intensities using `Itot,em`, the pure donor emission in the absence of acceptor.
Donor anisotropy is introduced here, by adjusting donor fluorescence intensities with the gamma factor `g`.
Imperfect experimental setup is simulated by adding channel-specific bleedthrough `bt` and direct excitation `dE` to the respective fluorescence intensities.

*From FRET to fluorescence intensities:*  
[equations]  

Final camera-detected intensity-time traces are obtained by adding channel-specific background and uniform camera noise.
If the chosen camera characteristics does not include shot noise, Poisson noise is added to intensities prior the camera contribution; see [Camera SNR characteristics](../panels/panel-video-parameters#camera-snr-characteristics) for more information.

*Conversion to image counts:*  
[scheme]  

Images in the single molecule video (SMV) are created one by one, with the first image corresponding to the first time point in intensity-time traces.
Like in a 2-color FRET experiment, horizontal dimensions of the video are equally split into donor (left) and acceptor (right) channels. 
Single molecules are then spread randomly on the donor channel and directly translated into the acceptor channel.
Pixel values are set to donor or acceptor intensities at molecule coordinates and to dark count elsewhere (fluorescent background and camera noise). 
Finally, pixels are convolved with channel-specific point spread functions to obtain realistic diffraction-limited images. 

*Building SMV images:*  
[scheme]  

To create intensity trajectories and images:

{: .bg-grey-lt-000}
1. Set parameters:  
     
   [dimensions](../panels/panel-video-parameters#dimensions),  
   [pixel size](../panels/panel-video-parameters#pixel-size),  
   [bit rate](../panels/panel-video-parameters#bit-rate),  
   [Camera SNR characteristics](../panels/panel-video-parameters#camera-snr-characteristics),  
   [Molecule coordinates](../panels/panel-molecules#molecule-coordinates),  
   [Photophysics](../panels/panel-molecules#photophysics),  
   [Point spread functions](../panels/panel-experimental-setup#point-spread-functions),  
   [Background](../panels/panel-experimental-setup#background).  
     
1. Press 
![Update](../../assets/images/but-sim-update.png "Update") to convert FRET state sequences into camera-detected intensity trajectories and images. The execution time can be long; see 
[Remarks](#remarks) for details.  
     
1. Update intensity data whenever one of the parameters is changed.


## Export trajectories and video to files

Simulated data and simulation parameters can be exported to various file formats.  
When exporting the SMV, video frames are successively written in files until the video length is reached.

To export data to files:

{: .bg-grey-lt-000}
1. Set parameters in [Export options](../panels/panel-export-options),  
     
1. Press 
![Export files](../../assets/images/but-sim-export.png "Export files") to start writing data in files. The execution time can be long; see 
[Remarks](#remarks) for details.
 
## Remarks
{: .no_toc }

Updating intensity data and writing SMVs to files can be very time consuming depending on which camera characteristics are chosen; see 
[Camera SNR characteristics](../panels/panel-video-parameters#camera-snr-characteristics) for more information.

Some parameters can be set by loading external files. This allows to bypass the limitations of the user interface in order to work with more than five states or set parameters for individual molecules; see 
[Load pre-set parameters](load-preset-parameters.html) for more information.

