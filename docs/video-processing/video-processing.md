---
layout: default
title: Video processing
nav_order: 4
has_children: true
permalink: /docs/video-processing
---

# Video processing
<!-- Automatically generated TOC does not allow to return to the previous page after clicking one of its link
I'd rather use hand-made TOC until we find a better solution
{: .no_toc } -->

Use this module to obtain single molecule intensity trajectories from a single molecule video (SMV).

## Table of contents
{: .no_toc .text-delta }

<!-- 1. TOC
{:toc} -->

1. [Description](video-processing.html#description)
1. [Requirement and limitations](video-processing.html#requirements-and-limitations)
1. [Workflow](video-processing.html#workflow)
1. [Panels](video-processing.html#panels)
   1. [Visualization area](video-processing.html#visualization-area)
   1. [Plot](video-processing.html#plot)
   1. [Experiment](video-processing.html#experiment)
   1. [Image correction](video-processing.html#image-correction)
   1. [Molecule coordinates](video-processing.html#molecule-coordinates)
   1. [Intensity integration](video-processing.html#intensity-integration)
1. [Remarks](video-processing.html#remarks)

## Description

The module Video processing is the second component of the software MASH and can be selected in MASH's upper menu bar; see <a href="../Getting_started.html#general-workflow">General workflow</a> for more information.
It allows to create single molecule intensity-time traces from a single molecule video (SMV).

The interface can be divided into several subunits dedicated to:
* visualize and navigate through the video
* parameters of the experiment
* correct images
* determine single molecule coordinates
* calculate and export single molecule intensity trajectories

At the end of the procedure, the user holds single molecule coordinates and intensity-time traces written to files, in particular to the *.mash project file.

## Requirements and limitations

Video processing framework is limited to:
* surface-immobilized molecules,
* import SMV file formats: Source Input Format (**.sif**), Tagged Image File format (**.tif**), Graphics Interchange Format (**.gif**), WinSpec CCD Capture format (**.spe**), Single data acquisition format (**.pma**), Audio Video Interleave (**.avi**), MASH video format (**.sira**); see <a href="video-processing.html#loadvid">Load video/image file</a> for more information.

## Workflow

## Panels

Video processing is composed of one visualization area and five panels:

### Visualization area

<span id="loadvid"><u>Load video/image file</u></span>

<span id="navvid"><u>Navigate through video</u></span>

<span id="tools"><u>Tools</u></span>

### Plot

<span id="persec"><u>units per second</u> (*units per s.*)</span>

<span id="persec"><u>colormap</u> (*cmap*)</span>

### Experiment

<span id="Nlasers"><u>number of lasers</u> (*Nb. of lasers*)</span>

<span id="ilaserwl"><u>laser wavelength</u></span>

<span id="Nchan"><u>number of spectroscopic channels</u> (*Nb. of channels*)</span>

<span id="expt"><u>Exposure time</u></span>

<span id="projopt"><u>Project options</u> (*Options...*)</span>

### Image correction

### Molecule coordinates

### Intensity integration

## Remarks