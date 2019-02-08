---
layout: default
title: Simulation
nav_order: 3
has_children: true
permalink: /docs/simulation
---

# Simulation
{: .no_toc }

Use this module to generate synthetic single molecule videos (SMV) and trajectories.

## Table of contents
{: .no_toc .text-delta }

<!-- Automatically generated TOC does not allow to return to the previous page after clicking one of its link
I'd rather use hand-made TOC until we find a better solution
1. TOC
{:toc}
-->

1. [Description](simulation.html#description)
1. [Requirements and limitations](simulation.html#requirements-and-limitations)
1. [Workflow](simulation.html#workflow)
1. [Panels](simulation.html#panels)
   1. [Video parameters](simulation.html#video-parameters)
   1. [Molecules](simulation.html#molecules)
   1. [Experimental setup](simulation.html#experimental-setup)
   1. [Export options](simulation.html#export-options)
1. [Remarks](simulation.html#remarks)

## Description

<a href="../assets/images/module_simulation.png"><img src="../assets/images/module_simulation.png" width="325" style="float:right"/></a>

The module Simulation is the first component of the software MASH and can be selected in MASH's top menu bar; see <a href="../Getting_started.html#general-workflow">General workflow</a> for more information.
It allows to generate synthetic single molecule videos (SMVs) and trajectories.

The interface can be divided into three subunits that respectively allow to:
* generate data
* visualize the generated data
* export the generated data to files

At the end of the procedure, the user holds synthetic SMVs and trajectories written to files that can be used for result validation, algorithm testing or external illustration.

## Requirements and limitations

Simulation framework is limited to:
* surface-immobilized molecules,
* two spectroscopic channels (one donor and one acceptor),
* continuous wavelength excitation (one laser).

## Workflow

The simulation procedure is performed in three steps. Each step requires specific parameters to be set:

1. **Generate random FRET state sequences** by pressing <img src="../assets/images/but_sim_generate.png" alt="Generate"/>

   A sequence is created by successively drawing a FRET value and a state duration from the <a href="simulation.html#thmodprm">Thermodynamic model</a>.
   The operation is repeated until the sequence length reaches the given <a href="simulation.html#simL">video length</a> and the number of sequences equals the <a href="simulation.html#simN">number of molecules</a>.  
     
	 *Examples of FRET sequences:*  
   [scheme]  
     
   ***Parameters to be set:*** <a href="simulation.html#thmodprm">Thermodynamic model</a> and <a href="simulation.html#simN">number of molecules</a> in panel <a href="simulation.html#molecules">Molecules</a>, <a href="simulation.html#simL">video length</a> and <a href="simulation.html#simf">frame rate</a> in panel <a href="simulation.html#video-parameters">Video parameters</a>.
   Generate new state sequences whenever one of these parameters is changed.

2. **Convert sequences into camera-detected intensity trajectories and images** by pressing <img src="../assets/images/but_sim_update.png" alt="Update"/>

   FRET values are converted into donor and acceptor fluorescence intensities according to fluorophore <a href="simulation.html#photprm">Photophysics</a>.
   Final intensity trajectories are obtained after adding <a href="simulation.html#bgprm">Fluorescent background</a> and <a href="simulation.html#camprm">Camera noise</a>.  
     
	 *Conversion to camera-detected intensity data:*  
   [scheme]  
     
   Images of the SMV are created using video <a href="simulation.html#simdim">dimensions</a> equally split into donor (left) and acceptor (right) channels.
   Pixel values are set to donor or acceptor intensities at <a href="simulation.html#simcrd">Molecule coordinates</a> and to <a href="simulation.html#bgprm">Fluorescent background</a> + <a href="simulation.html#camprm">Camera noise</a> otherwise.
   Final images are obtained after convolution of the pixel values with the channel-specific <a href="simulation.html#psfprm">Point spread functions</a>.  
     
	 *Building SMV images:*  
   [scheme]  
     
   After the simulation is completed, intensity trajectories of the first molecule and the first image of the SMV are instantly displayed.
     
   ***Parameters to be set:*** fluorophore <a href="simulation.html#photprm">Photophysics</a> and <a href="simulation.html#simcrd">Molecule coordinates</a> in panel <a href="simulation.html#molecules">Molecules</a>, <a href="simulation.html#bgprm">Fluorescent background</a> and <a href="simulation.html#psfprm">Point spread functions</a> in panel <a href="simulation.html#experimental-setup">Experimental setup</a>, video <a href="simulation.html#simdim">dimensions</a>, <a href="simulation.html#simpxsz">pixel size</a>, <a href="simulation.html#simBR">bit rate</a> and <a href="simulation.html#camprm">Camera noise</a> in panel <a href="simulation.html#video-parameters">Video parameters</a>.
   Update intensity data whenever one of these parameters is changed; see <a href="#remarks">Remarks</a> for details.

3. **Export trajectories and SMV data** by pressing <img src="../assets/images/but_sim_export.png" alt="Export Files"/>

   Simulated trajectories and simulation parameters are exported to files according to file options.  
   Video frames are successively written in files until the <a href="simulation.html#simL">video length</a> is reached; see <a href="simulation.html#remarks">Remarks</a> for details.
     
   ***Parameters to be set:***  file options in panel <a href = "simulation.html#export-options">Export options</a>.

## Panels

Simulation is composed of four panels:

1. [Video parameters](simulation.html#video-parameters)
1. [Molecules](simulation.html#molecules)
1. [Experimental setup](simulation.html#experimental-setup)
1. [Export options](simulation.html#export-options)

### Video parameters

<span id="simL"><u>video length</u> (*length*)</span>

<span id="simf"><u>frame rate</u> (*rate*)</span>

<span id="simpxsz"><u>pixel size</u> (*px size*)</span>

<span id="siBR"><u>bit rate</u> (*BR*)</span>

<span id="simdim"><u>dimensions</u></span>

<span id="camprm"><u>Camera noise</u> (*Camera SNR characteristics*)</span>

### Molecules

<span id="simN"><u>molecule number</u> (*N*)</span>

<span id="simcrd"><u>Molecule coordinates</u></span>

By default, molecule coordinates are generated randomly.

<span id="simpreset"><u>Pre-set parameters</u></span>

<span id="thmodprm"><u>Thermodynamic model</u></span>

<span id="photprm"><u>Photophysics</u></span>

### Experimental setup

<span id="psfprm"><u>Point spread functions</u> (*PSF*)</span>

<span id="simdef"><u>Defocusing</u></span>

<span id="bgprm"><u>Fluorescent background</u> (*Background*)</span>

### Export options

<u>Traces (*.mat)</u>

<u>Video (*.sira)</u>

<u>Video (*.avi)</u>

<u>Ideal traces (ASCII)</u>

<u>Dwell-times (ASCII)</u>

<u>Simulation parameters</u>

<u>Coordinates</u>

<u>Exported intensity units></u>

## Remarks

Updating intensity data and writing SMVs to files can be very time consuming depending on which camera characteristics are chosen; see <a href="simulation.html#camprm">Camera Noise</a> for more information.

Some parameters can be set by loading external files. This allows to bypass the limitations of the user interface in order to: work with more than five states, set parameters for individual molecules etc.; see <a href="simulation.html#simpreset">Pre-set parameters</a> for more information.
