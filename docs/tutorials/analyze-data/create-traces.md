---
layout: default
title: Create traces
grand_parent: /tutorials
parent: /tutorials/analyze-data
nav_order: 1
nav_exclude: true
has_toc: false
---


# Analyze data
{: .no_toc }

Follow this procedure to process your single molecule videos (SMVs) or trajectories and characterize the molecule dynamics in your sample.

* **Step 1: Create traces**
* [Step 2: Find states in traces](find-states-in-traces.html)
* [Step 3: Identify state network](identify-state-network.html)
* [Step 4: Determine state populations](determine-state-populations.html)

**Note:** *Skip step 1 if already in possession of intensity-time traces files (ASCII or 
[mash project](../../output-files/mash-mash-project.html)).*

<span id="steps"></span>

---

<span class="fs-3">[STEP 1](create-traces.html#steps){: .btn .btn-green .mr-4} [STEP 2](find-states-in-traces.html#steps){: .btn .mr-4} [STEP 3](identify-state-network.html#steps){: .btn .mr-4} [STEP 4](determine-state-populations.html#steps){: .btn .mr-4}</span>

# STEP 1: Create traces
{: .no_toc }

---

In this step, bright spots are first localized in the average image of the single molecule video, coordinates are transformed in other channels and respective intensity-time traces are then calculated.

1. TOC
{:toc}

---

## Setup working area

During your analysis, several files will be automatically or manually exported.
For organisation purpose, we recommend to create one root folder per video file and to place the video file in this folder.

To prepare the working area for analysis:

- <u>Create a root folder</u>: name it after your video file for instance.

- <u>Set root folder</u>: browse and select your root folder in MASH-FRET's 
[tool bar](../../Getting_started.html#interface).

- <u>Select module</u>: 
[Video processing](../../video-processing) in MASH-FRET's 
[tool bar](../../Getting_started.html#interface).


## Fill in experiment settings

MASH-FRET is compatible with various experiment settings. 
The functionalities adapts automatically to the number of channels, number of alternating lasers and fluorophore properties.

To inform the software about your experiment settings:

- <u>Fill in</u> panel 
[Experiment Settings](../../video-processing/panels/panel-experiment-settings.html); see 
[Set experiment settings](../../video-processing/functionalities/set-experiment-settings.html) for more information.


## Crate the transformation file

The transformation file contains mathematical operations used to transpose positions from one video channel to all others. 
Skip this step if your experiment is set with only one channel.

The transformation is calculated from a set of reference coordinates mapped and transposed by hand. 
This is done on a **reference image**, where reference emitters (usually fluorescent beads) shine light in all video channels.

To obtain the reference image from a reference video:

- <u>Load the reference video</u> file in the 
[Visualization area](../../video-processing/panels/area-visualization.html)

- <u>Export an average image</u>: use the full video length (from frame 1 to ending frame) and a frame interval of 1; see 
[Average image](../../video-processing/panels/panel-molecule-coordinates#average-image.html) for more information.

To map reference coordinates:

- <u>Load the reference image</u>

- <u>Map coordinates</u>

- <u>Export reference coordinates</u>

To create the transformation file:

- <u>Calculate transformation</u> and save to file.

- <u>Check the quality</u> of transformation

The transformation is specific to your setup. 
Create a new transformation file solely when your setup gets realigned.


## Localize bright spots

1. With your SMV file in hands export an <u>average image</u>.

1. Find and save bright spots coordinates with <u>Spotfinder</u>.


## Transform spots coordinates

1. <u>Transform</u> spots coordinates to other channels.


## Create and export intensity-time traces

Create <u>intensity-time traces</u> of donor and acceptor channels and save data to a 
[mash project](../../output-files/mash-mash-project.html) file.

---

<span class="fs-3">[STEP 1](create-traces.html#steps_bottom){: .btn .btn-green .mr-4} [STEP 2](find-states-in-traces.html#steps_bottom){: .btn .mr-4} [STEP 3](identify-state-network.html#steps_bottom){: .btn .mr-4} [STEP 4](determine-state-populations.html#steps_bottom){: .btn .mr-4}</span>

---

<span id="steps_bottom"></span>
