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

{: .bg-grey-lt-000 .pt-3 .pb-2 .pl-7 .pr-4}
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

{: .bg-grey-lt-000 .pt-3 .pb-2 .pl-7 .pr-4}
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

{: .bg-grey-lt-000 .pt-3 .pb-2 .pl-7 .pr-4}
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
<span style="font-family: Times;">*I*<sub>*em*,*ex*</sub>(*n*,*t*)</span> 
 of molecule 
<span style="font-family: Times;">*n*</span> 
detected in emission channel 
<span style="font-family: Times;">*em*</span> 
upon illumination with laser 
<span style="font-family: Times;">*ex*</span> 
at time 
<span style="font-family: Times;">*t*</span> 
is background-corrected such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>I</i><sub><i>em</i>,<i>ex</i></sub><i><sup>*</sup></i>(<i>n</i>,<i>t</i>) = <i>I</i><sub><i>em</i>,<i>ex</i></sub>(<i>n</i>,<i>t</i>) - <i>bg</i><sub><i>em</i>,<i>ex</i></sub>(<i>n</i>,<i>t</i>)
</p>

with 
<span style="font-family: Times;">*I*<sub>*em*,*ex*</sub><sup>\*</sup>(*n*,*t*)</span> 
the background-corrected intensity and 
<span style="font-family: Times;">*bg*<sub>*em*,*ex*</sub>(*n*,*t*)</span> 
the estimated background intensity.

To correct intensities from background:

{: .bg-grey-lt-000 .pt-3 .pb-2 .pl-7 .pr-4}
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

The bleedthrough and direct excitation coefficient are determined from control experiments involving single-labelled species.

The background-corrected intensity 
<span style="font-family: Times;">*I*<sub>*em*,*ex*</sub>\*(*n*,*t*)</span> 
 of molecule 
<span style="font-family: Times;">*n*</span> 
detected in emission channel 
<span style="font-family: Times;">*em*</span> 
upon illumination with laser 
<span style="font-family: Times;">*ex*</span> 
at time 
<span style="font-family: Times;">*t*</span> 
is corrected from cross-talks such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>I</i><sub><i>em</i>,<i>ex</i></sub><i><sup>**</sup></i>(<i>n</i>,<i>t</i>) = <i>I</i><sub><i>em</i>,<i>ex</i></sub><sup>*</sup>(<i>n</i>,<i>t</i>) - &#931;<sub>em2&#8800;em</sub>[ <i>bt</i><sub><i>em2</i>,<i>em</i></sub>(<i>n</i>) &#215; <i>I</i><sub><i>em2</i>,<i>ex</i></sub><sup>*</sup>(<i>n</i>,<i>t</i>) )]<br><br>
<i>I</i><sub><i>em</i>,<i>ex</i></sub><i><sup>***</sup></i>(<i>n</i>,<i>t</i>) = <i>I</i><sub><i>em</i>,<i>ex</i></sub><sup>**</sup>(<i>n</i>,<i>t</i>) - <i>dE</i><sub><i>em</i>,<i>ex</i></sub>(<i>n</i>) &#215; <i>I</i><sub><i>em</i>,<i>ex0</i></sub><sup>**</sup>(<i>n</i>,<i>t</i>) <br>
</p>

with 
<span style="font-family: Times;">*I*<sub>*em*,*ex*</sub><sup>\*\*\*</sup>(*n*,*t*)</span> 
the intensity corrected from cross-talks, 
<span style="font-family: Times;">*bt*<sub>*em2*,*em*</sub>(*n*)</span> 
the bleedthrough coefficient of emitter 
<span style="font-family: Times;">*em*<sub>2</sub></span> 
into detection channel of emitter 
<span style="font-family: Times;">*em*</span>, 
<span style="font-family: Times;">*dE*<sub>*em*,*ex*</sub>(*n*)</span> 
the coefficient for direct excitation of emitter 
<span style="font-family: Times;">*em*</span> 
upon unspecific illumination 
<span style="font-family: Times;">*ex*</span> 
and 
<span style="font-family: Times;">*I*<sub>*em*,*ex0*</sub><sup>\*\*</sup>(*n*,*t*)</span> 
the bleedthrough-corrected intensity of emitter 
<span style="font-family: Times;">*em*</span> 
upon specific illumination 
<span style="font-family: Times;">*ex*<sub>0</sub></span>.

To correct intensities from cross-talks:

{: .bg-grey-lt-000 .pt-3 .pb-2 .pl-7 .pr-3}
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

Differences in detection efficiency and 

## Sort trajectories with Trace manager

## Correct for photobleaching

## Smooth trajectories

## Determine state trajectories

## Export data
 
## Remarks
{: .no_toc }

