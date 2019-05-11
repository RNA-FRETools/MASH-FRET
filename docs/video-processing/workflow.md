---
layout: default
title: Workflow
parent: /video-processing.html
nav_order: 2
---

<img src="../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Workflow
{: .no_toc }

In this section you will learn how to process single molecule videos to obtain single molecule coordinates and intensity-time traces. Exported data, in particular the 
[mash project](../output-files/mash-mash-project.html) file, can further be used in module Trace processing for 
[data analysis](../tutorials/analyze-data.html).

The procedure includes four steps:

1. TOC
{:toc}


---

## Register experiment settings

In theory, the software is compatible with:
* an unlimited number of video channels, 
* an unlimited number of alternated lasers,
* FRET calculations for an unlimited size of donor-acceptor network.

To adapt the software functionalities to your own experiment setup, MASH must be informed about the particular settings.

To register your experiment settings:

{: .procedure }
1. Set parameters:  
     
   [Number of alternated lasers](panels/panel-experiment-settings.html#number-of-alternated-lasers)  
   [Laser wavelengths](panels/panel-experiment-settings.html#laser-wavelengths)  
   [Number of video channels](panels/panel-experiment-settings.html#number-of-video-channels)  
   [Project options](panels/panel-experiment-settings.html#project-options)  
   [Exposure time](panels/panel-experiment-settings.html#exposure-time) (optional); see 
   [Remarks](#remarks) for more details.  
     
1. Modify experiment settings whenever the laser or channel order changes, or when experimental conditions vary.


---

## Localize bright spots

Bright spots coordinates are different from single molecule coordinates to the extent that molecule coordinates are paired across all video channels and spots coordinates concern individual channels.
Spot detection in single molecule videos (SMV) is often made more complicated by the presence of competitive background noise and by the variation of single molecule brightness in time.

To increase the contrast between bright spots and background, and thus ease spot detection, SMVs can be treated with image filters.
MASH offers a set of basic or smFRET-specific image filters that can be used for such purpose.
Some image filters can also be used as background correction prior creating intensity-time traces; see 
[Remarks](#remarks) for more details.

<a class="plain" href="../assets/images/figures/VP-workflow-scheme-filter-video.png">![Apply image filter to video](../assets/images/figures/VP-workflow-scheme-filter-video.png "Apply image filter to video")</a>

In any case, it is recommended to export SMVs to 
[.sira files](../output-files/sira-mash-video.html). 
This will eventually reduce the processing time in module Trace processing.

To get rid of brightness variations in time and smooth the background noise, video frames are averaged into one average image.
Finally, spot detection is performed on the average image with the Spotfinder tool.

<a class="plain" href="../assets/images/figures/VP-workflow-scheme-average-sf.png">![Average image and spot detection](../assets/images/figures/VP-workflow-scheme-average-sf.png "Average video and detect spots")</a>

To localize bright spots in the SMV:

{: .procedure }
1. [Load](panels/area-visualization.html#load-videoimage-file) the SMV file by pressing 
   ![Load...](../assets/images/gui/VP-but-load.png "Load...")  
     
1. Set parameters in 
   [Filter settings](panels/panel-edit-video.html#filter-settings) and apply filter by pressing 
   ![Add](../assets/images/gui/VP-but-add.png "Add"). Filters can be cumulated and are managed in the 
   [Filter list](panels/panel-edit-video.html#filter-list).  
     
1. Set parameters in 
   [Frame range](panels/panel-edit-video.html#frame-range) and export the original or modified video to a 
   [.sira file](../output-files/sira-mash-video.html) by pressing 
   ![Create & Export...](../assets/images/gui/VP-but-export.png "Create & Export...").   
     
1. [Load](panels/area-visualization.html#load-videoimage-file) the newly exported SMV file by pressing 
   ![Load...](../assets/images/gui/VP-but-load.png "Load...")  
     
1. Set parameters in 
   [Average image](panels/panel-molecule-coordinates.html#average-image) and export the average image to a 
   [_ave.* file](../output-files/ave-average-image.html) by pressing 
   ![Go](../assets/images/gui/VP-but-go.png "Go")  
     
1. Load the average image by pressing 
   ![...](../assets/images/gui/VP-but-3p.png "...") in
   [Average image](panels/panel-molecule-coordinates.html#average-image)  
     
1. Detect bright spots with 
   [Spotfinder](panels/panel-molecule-coordinates.html#spotfinder) in each channel and export spots coordinates to a 
   [.spots file](../output-files/spots-spots-coordinates.html) by pressing 
   ![Save...](../assets/images/gui/VP-but-save3p.png "Save...")


---

## Transform spots coordinates

To obtain single molecules coordinates, spots coordinates must be transformed into other channels.
This implies the calculation of a spatial transformation specific to your setup.

The spatial transformation is calculated from an already co-localized set of coordinates called the reference coordinates.
They are mapped manually using a reference image where reference samples emits in all channels.

<a class="plain" href="../assets/images/figures/VP-workflow-scheme-map-reference.gif">![Map reference coordinates](../assets/images/figures/VP-workflow-scheme-map-reference.gif "Map reference coordinates")</a>

The transformation from one channel to another uses a combination of symmetry operations which is specific to the recording setup. 
A list of transformation types is available for such purpose, going from the most simple to the most complex combination.

At first, the proper transformation type is usually unknown.
A good practice is to use the most simple one and check the quality of the calculated transformation.
The quality of the transformation is judged by the user's eye from the superposition of the original (in red) and transformed (in green) reference images.
If the transformation is correct, reference emitters will appear as yellow dots on a dark background.
If the quality is poor, red and green dots will be visible and the operation must be repeated with increasing complexity of the combination.

<a class="plain" href="../assets/images/figures/VP-workflow-scheme-transformation-calculation.png">![Transform spots coordinates](../assets/images/figures/VP-workflow-scheme-transformation-calculation.png "Transform spots coordinates")</a>

To calculate and export the spatial transformation:

{: .procedure }
1. Load the reference image by pressing 
   ![Map](../assets/images/gui/VP-but-map.png "Map"),  
   [Use the mapping tool](functionalities/use-mapping-tool.html) to map positions in every channels and export reference coordinates to a 
   [.map file](../output-files/map-mapped-coordinates.html) by closing the mapping tool.  
     
1. Select the 
   [Transformation type](panels/panel-molecule-coordinates.html#transformation-type) and export the transformation to a 
   [.mat file](../output-files/mat-transformation.html) by pressing 
   ![Calculate](../assets/images/gui/VP-but-calculate.png "Calculate").
     
1. Load the reference image by pressing 
   ![Check quality...](../assets/images/gui/VP-but-check-quality.png "Check quality...") and judge the transformation quality; 
   if the quality is not satisfying, return to step 3.  
     
1. Recalculate the transformation whenever the setup is realigned. 
   Otherwise, the same transformation [.mat file](../output-files/mat-transformation.html) can be re-used; see 
   [Coordinates transformation](panels/panel-molecule-coordinates.html#coordinates-transformation) for more information.

To transform spots coordinates:

{: .procedure }
1. Transform the spots coordinates and export the single molecule coordinates to a 
   [.coord file](../output-files/coord-transformed-coordinates.html) by pressing 
   ![Transform](../assets/images/gui/VP-but-transform.png "Transform").


---

## Create and export intensity-time traces

Intensities are calculated by summing up the brightest pixels laying in a square area drawn around the molecule coordinates.
The operation is repeated on every video frame to build the single molecule intensity-time traces.

Intensity-time traces and project parameters are automatically saved to a 
[.mash project](../output-files/mash-mash-project.html) and statistics on intensities are automatically exported to a 
[.tbl file](../output-files/tbl-intensity-statistics.html), but intensity data can be also exported to other optional files.

To calculate and export the intensity-time traces:

{: .procedure }
1. Load the unmodified SMV file by pressing 
   ![...](../assets/images/gui/VP-but-3p.png "...") in 
   [Input video](panels/panel-intensity-integration.html#input-video).
   Background-corrected video files can also be used here; see 
   [Remarks](#remarks) for more details.   
     
1. Load the single molecule coordinates 
   [.coord file](../output-files/coord-transformed-coordinates.html) by pressing 
   ![...](../assets/images/gui/VP-but-3p.png "...") in 
   [Input coordinates](panels/panel-intensity-integration.html#input-coordinates)  
     
1. Set parameters:  
     
   [Integration parameters](panels/panel-intensity-integration.html#integration-parameters)  
   [Export options](panels/panel-intensity-integration.html#export-options)  
     
1. Calculate and export intensity-time traces to a 
   [.mash project](../output-files/mash-mash-project.html) and to selected ASCII files by pressing 
   ![Create & Export...](../assets/images/gui/VP-but-export.png "Create & Export..."); see 
   [Remarks](#remarks) for more details.


---

## Remarks
{: .no_toc}

The exposure time is automatically updated from the video file. 
If the file does not contain such information, the exposure time must be manually set in 
[Exposure time](panels/panel-experiment-settings.html#exposure-time).

Even though background correction is more accurate when performed in module Trace processing, some image filters can be used as background correction; see 
[Filters](panels/panel-edit-video.html#filters) for more information.
In that case, the background-corrected video file can be used to create intensity-time traces, but background correction must be deactivated in module Trace processing; see
[Background correction](../trace-processing/panels/panel-subimage-background-correction.html#background-correction) for more information.

Creating intensity-time traces can be a slow process if not enough free RAM is available; see 
[Create and export intensity-time traces](panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) for more information.