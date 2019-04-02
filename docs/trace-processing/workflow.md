---
layout: default
title: Workflow
parent: /trace-processing.html
nav_order: 2
---

# Trace processing workflow
{: .no_toc }

In this section you will learn how to correct single molecule intensity-time traces from experimental bias and how to obtain state trajectories. Exported data, in particular to the 
[mash project](../output-files/mash-mash-project.html) file, can further be used in modules Histogram analysis and Transition analysis for 
[data analysis](../tutorials/analyze-data.html).

The procedure includes eight steps:

1. TOC
{:toc}

## Import single molecule data

Single molecule data can be imported from a 
[.mash file](../output-files/mash-mash-project.html), previously created in Video processing, or from a set of ASCII files.
If data are imported from ASCII files, MASH must be informed about the particular file structure and about your experiment settings in order to adapt the software functionalities. 
In that case, data must be exported to a new 
[.mash file](../output-files/mash-mash-project.html) after import in order to use the processed data for further analysis.

After successful import, channel-specific images and trajectories of the first single molecule in the project are displayed in the 
[Visualization area](panels/area-visualization.html).

To import single molecule data from a 
[.mash file](../output-files/mash-mash-project.html):

{: .procedure }
1. Add the project to the list by pressing 
   ![Add](../assets/images/gui/TP-but-add.png "Add") and selecting the corresponding 
   [.mash file](../output-files/mash-mash-project.html)  
     
1. If not already done in Video processing, set the project options by selecting the project in the project list and pressing 
   ![Edit...](../assets/images/gui/TP-but-edit-3p.png "Edit..."); see 
   [Set project options](../video-processing/functionalities/set-project-options.html) for more information. 
   Save modifications to your project file by pressing 
   ![Save](../assets/images/gui/TP-but-save.png "Save") and overwriting the corresponding 
   [.mash file](../output-files/mash-mash-project.html).

To import single molecule data from a ASCII files:

{: .procedure }
1. Set the import settings by pressing 
   ![ASCII options ...](../assets/images/gui/TP-but-ascii-options-3p.png "ASCII options ..."); see 
   [Set project import options](functionalities/set-project-import-options.html) for more information  
     
1. Import data by pressing 
   ![Add](../assets/images/gui/TP-but-add.png "Add") and selecting the corresponding ASCII files; this will add a new project to the project list  
     
1. Set the project options by selecting the new project in the project list and pressing 
   ![Edit...](../assets/images/gui/TP-but-edit-3p.png "Edit..."); see 
   [Set project options](../video-processing/functionalities/set-project-options.html) for more information.
     
1. Save the new project to a 
   [.mash file](../output-files/mash-mash-project.html) by pressing 
   ![Save](../assets/images/gui/TP-but-save.png "Save").


## Adjust single molecule position

Single molecule image in each channel and upon a specific laser shine are shown in the 
[Visualization area](panels/area-visualization.html#single-molecule-images).
Single molecule positions are marked with red crosses and the dimensions of pixel area used to integrate the intensities are indicated by red squares.
To be obtain the most accurate intensities, the single molecule positions must be centered on the brightest pixel in the integration zone.

**[*scheme: sub-images with shifted and centered coordinates*]**

Because of imperfect coordinates transformation, it can happen that positions are shifted one or two pixels away from the brightest pixel.
In that case, the positions must be recentered.

To recenter single molecule positions:

{: .procedure }
1. Select the molecule index in the 
   [Molecule list](panels/panel-sample.html#molecule-list).  
     
1. If necessary, adjust the brightness and contrast in 
   [Single molecule images](panels/panel-subimage.html#single-molecule-images) to render the molecule profile the most apparent.  
     
1. Select the channel where position needs to be re-centered and activate the "recenter" option in 
   [Sub molecule coordinates](panels/panel-subimage.html#single-molecule-coordinates); intensity-time traces will automatically be recalculated after re-centering.  
     
1. To prevent re-centering on potentially empty single molecule images, deactivate the "recenter" option in 
   [Sub molecule coordinates](panels/panel-subimage.html#single-molecule-coordinates) after re-centering.

**Note:** *If necessary, molecule x- and y-coordinates can be modified manually; see 
[Sub molecule coordinates](panels/panel-subimage.html#single-molecule-coordinates) for more information.*


## Correct intensities

Raw intensities obtained after integration include the contribution of signals that must be subtracted to calculate reliable FRET and stoichiometry values.
These unwanted signals are the background intensity and the cross-talks.

### Background correction
{: .no_toc }

The background intensity is channel- and illumination-specific.
It consists mainly of the dark count of the detector and background light, like auto-fluorescence of the medium in the chamber for instance.
The background signal is usually spatially distributed over the single molecule image and is therefore more accurately estimated in single molecule local environments.
MASH offers a set of local background estimators that can be used for such purpose.

The intensity 
[*I*<sub>*em*,*ex*</sub>(*n*,*t*)](){: .math_var } of molecule 
[*n*](){: .math_var } detected in emission channel 
[*em*](){: .math_var } upon illumination with laser 
[*ex*](){: .math_var } at time 
[*t*](){: .math_var } is background-corrected such as:

{: .equation }
*I*<sup>\*</sup><sub>*em*,*ex*</sub>(*n*,*t*) = *I*<sub>*em*,*ex*</sub>(*n*,*t*) - *bg*<sub>*em*,*ex*</sub>(*n*,*t*)

with 
[*I*<sup>\*</sup><sub>*em*,*ex*</sub>(*n*,*t*)](){: .math_var } the background-corrected intensity and 
[*bg*<sub>*em*,*ex*</sub>(*n*,*t*)](){: .math_var } the estimated background intensity.

To correct intensities from background:

{: .procedure }
1. Select the molecule index in the 
   [Molecule list](panels/panel-sample.html#molecule-list).  
     
1. For each intensity-time trace, set parameters:  
     
   [Background correction settings](panels/panel-background-correction.html#background-correction-settings)  
   [Apply background correction](panels/panel-background-correction.html#apply-background-correction)  
     
1. If desired apply the same parameter settings to all molecules by pressing 
   ![all](../../assets/images/gui/TP-but-all.png "all")  
     
1. Update data correction and display for current molecule only or for all molecules by pressing 
   ![UPDATE](../../assets/images/gui/TP-but-update.png "UPDATE") or 
   ![UPDATE ALL](../../assets/images/gui/TP-but-update-all.png "UPDATE ALL") respectively.

   
### Cross-talk correction
{: .no_toc }

Cross-talks are due to instrumental imperfections and include two phenomena:
* the detection of an emitter fluorescence into unspecific video channels, called the <u>bleedthrough</u>
* the detection of an emitter fluorescence into specific video channel after unspecific laser illumination, called the <u>direct excitation</u>

The bleedthrough and direct excitation coefficient can be determined from control experiments involving single-labelled species.
The bleedthrough coefficient 
[*bt*<sub>*em*,*em*0</sub>](){: .math_var } of an emitter 
[*em*](){: .math_var } into detection channel of an emitter 
[*em*<sub>0</sub>](){: .math_var } is calculated from intensities measured from species single-labelled with emitter 
[*em*](){: .math_var } and after background correction, such as:

{: .equation }
*bt*<sub>*em*,*em*0</sub> = *I*<sup>\*</sup><sub>*em*0</sub><sup>*ex*</sup> / *I*<sup>\*</sup><sub>*em*</sub><sup>*ex*</sup>

The direct excitation coefficient 
[*dE*<sub>*em*0</sub><sup>*ex*&#8800;*ex*0</sup>](){: .math_var } for direct excitation of an emitter 
[*em*<sub>0</sub>](){: .math_var } specifically excited by illumination 
[*ex*<sub>0</sub>](){: .math_var } upon unspecific illumination 
[*ex*](){: .math_var } is calculated from intensities measured from species single-labelled with emitter 
[*em*<sub>0</sub>](){: .math_var } and after background correction, such as:

{: .equation }
*dE*<sub>*em*0</sub><sup>*ex*&#8800;*ex*0</sup> = *I*<sup>\*</sup><sub>*em*0</sub><sup>*ex*</sup> / *I*<sup>\*</sup><sub>*em*0</sub><sup>*ex*0</sup>

The background-corrected intensity 
[*I*<sup>\*</sup><sub>*em*0</sub><sup>*ex*</sup>(*n*,*t*)](){: .math_var } of molecule 
[*n*](){: .math_var } detected in emission channel 
[*em*<sub>0</sub>](){: .math_var } upon illumination with laser 
[*ex*](){: .math_var } at time 
[*t*](){: .math_var } is corrected from cross-talks such as:

{: .equation }
*I*<sup>\*\*</sup><sub>*em*0</sub><sup>*ex*</sup>(*n*,*t*) = *I*<sup>\*</sup><sub>*em*0</sub><sup>*ex*</sup>(*n*,*t*) - &#931;<sub>*em*&#8800;*em*0</sub>[ *bt*<sub>*em*,*em*0</sub>(*n*) &#215; *I*<sup>\*</sup><sub>*em*</sub><sup>*ex*</sup>(*n*,*t*) )]<br><br>
*I*<sup>\*\*\*</sup><sub>*em*0</sub><sup>*ex*&#8800;*ex*0</sup>(*n*,*t*) = *I*<sup>\*\*</sup><sub>*em*0</sub><sup>*ex*&#8800;*ex*0</sup>(*n*,*t*) - *dE*<sub>*em*0</sub><sup>*ex*&#8800;*ex*0</sup>(*n*) &#215; *I*<sup>\*\*</sup><sub>*em*0</sub><sup>*ex*0</sup>(*n*,*t*)

with 
[*I*<sup>\*\*</sup><sub>*em*0</sub><sup>*ex*</sup>(*n*,*t*)](){: .math_var } and 
[*I*<sup>\*\*\*</sup><sub>*em*0</sub><sup>*ex*</sup>(*n*,*t*)](){: .math_var }, the intensities corrected from bleedthrough-only and both cross-talks respectively.

To correct intensities from cross-talks:

{: .procedure }
1. Select the molecule index in the 
   [Molecule list](panels/panel-sample.html#molecule-list).  
     
1. For each emitter, set parameters 
   [Cross-talks settings](panels/panel-factor-corrections.html#cross-talks-settings)  
     
1. If desired, apply the same parameter settings to all molecules by pressing 
   ![all](../../assets/images/gui/TP-but-all.png "all") (usually the case)   
     
1. Update data correction and display for current molecule only or for all molecules by pressing 
   ![UPDATE](../../assets/images/gui/TP-but-update.png "UPDATE") or 
   ![UPDATE ALL](../../assets/images/gui/TP-but-update-all.png "UPDATE ALL") respectively.


## Correct FRET values

To recover absolute distances between a FRET pair and from apparent FRET values, it is necessary, but not sufficient, to have the donor and acceptor intensities on the same scale.
For this, differences in detection efficiencies and quantum yields between the donor 
[*D*](){: .math_var } and the acceptor 
[*A*](){: .math_var } of a FRET pair must be corrected.
These differences are accounted for in the FRET pair-specific
[*&#947;*<sub>*D*,*A*</sub>](){: .math_var } factor such as:

{: .equation }
*&#947;*<sub>*D*,*A*</sub> = *&#951;*<sub>*A*</sub>*&#934;*<sub>*A*</sub> / *&#951;*<sub>*D*</sub>*&#934;*<sub>*D*</sub>

with 
[*&#951;*<sub>A</sub>](){: .math_var } and 
[*&#951;*<sub>D</sub>](){: .math_var }, the respective photon detection efficiency in acceptor and donor emission channels, and 
[*&#934;*<sub>A</sub>](){: .math_var } and 
[*&#934;*<sub>D</sub>](){: .math_var }, the respective acceptor and donor quantum yields.

Apparent FRET values 
[*E*<sup>\*</sup><sub>*D*,*A*</sub>(*n*,*t*)](){: .math_var } from a donor emitter 
[*D*](){: .math_var } to an acceptor emitter 
[*A*](){: .math_var } are calculated according to 
[FRET calculation](../video-processing/functionalities/set-project-options.html#fret-calculations) and are 
[*&#947;*](){: .math_var }-corrected to 
[*E*<sub>*D*,*A*</sub>(*n*,*t*)](){: .math_var } values such as:

{: .equation }
*E*<sub>*D*,*A*</sub>(*n*,*t*) = *E*<sup>\*</sup><sub>*D*,*A*</sub>(*n*,*t*) / [ *&#947;*<sub>*D*,*A*</sub>(*n*) - *E*<sup>\*</sup><sub>*D*,*A*</sub>(*n*,*t*)  &#215;  ( *&#947;*<sub>*D*,*A*</sub>(*n*) - 1 ) ]

To correct apparent FRET-time traces with 
[*&#947;*](){: .math_var } factors:

{: .procedure }
1. Select the molecule index in the 
   [Molecule list](panels/panel-sample.html#molecule-list).  
     
1. For each donor-acceptor FRET pair, set parameters 
   [Gamma factor settings](panels/panel-factor-corrections.html#gamma-factor-settings)  
     
1. If desired, apply the same parameter settings to all molecules by pressing 
   ![all](../../assets/images/gui/TP-but-all.png "all")   
     
1. Update data correction and display for current molecule only or for all molecules by pressing 
   ![UPDATE](../../assets/images/gui/TP-but-update.png "UPDATE") or 
   ![UPDATE ALL](../../assets/images/gui/TP-but-update-all.png "UPDATE ALL") respectively.
 

## Sort trajectories with Trace manager



## Correct for photobleaching

## Smooth trajectories

## Determine state trajectories

## Export data
 
## Remarks
{: .no_toc }

