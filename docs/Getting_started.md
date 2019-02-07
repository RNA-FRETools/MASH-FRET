---
layout: default
title: Getting started
nav_order: 1
---
# Getting started
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


## Installation
Clone the MASH-FRET into a directory of your choice.
```
git clone https://github.com/RNA-FRETools/MASH-FRET.git
```
Alternatively, you may also download the .zip package directly from [Github](https://github.com/RNA-FRETools/MASH-FRET)

Within Matlab add MASH-FRET to you path by going to `Home → Set Path → Add with Subfolders`
{: .pb-3 }

**Note:** *MASH-FRET is tested to run under Matlab version R2011a and above*

## Interface

<a href="assets/images/main.png"><img src="assets/images/main.png" width="325" style="float:right"/></a>

The graphical interface consists of a permanent menu bar located on the top and a main area located below.

The menu bar allows you to switch between <u>modules</u> and to set the <u>root folder</u>, where all generated files will be saved.
The main area contains the selected module to work with.

For a first use, it is recommended to create one <u>root folder</u> for each video analysed.


## <span id="genwkflw">General workflow</span>

This section describes the recommended procedures for internal use.
For more detail about how to use the individual modules ([Simulation](docs/simulation/simulation.html), [Video processing](docs/video-processing/video-processing.html), [Trace processing](docs/trace-processing/trace-processing.html), [Histogram analysis](docs/histogram-analysis/histogram-analysis.html), [Transition analysis](docs/transition-analysis/transition-analysis.html)), please refer to the respective sections of the documentation.

### smFRET video analysis

1. With your **single molecule video** (SMV) file and a **reference beads image** or video in hands, use [Video processing](docs/video-processing/video-processing.html) to:  
     
   &#9745; localize single molecules,  
   &#9745; calculate donor and acceptor intensity-time traces.  
     
   <u>Molecule coordinates</u> and <u>intensity data</u> are exported to a ***.mash project** file.

2. Load your freshly created ***.mash project** in [Trace processing](docs/trace-processing/trace-processing.html) to:  
     
   &#9745; visualize and <u>select</u> single molecule with coherent intensity trajectories,  
   &#9745; <u>correct intensities</u> from experimental bias,  
   &#9745; <u>discretize</u> FRET or intensity trajectories into states.  
     
   Save modifications and calculation to your ***.mash project**.

3. Load the ***.mash project** containing state trajectories in [Transition analysis](docs/transition-analysis/transition-analysis.html) to:  
     
   &#9745; estimate of the <u>number of states</u> from the transition density plot,  
   &#9745; determine the state <u>transition rates</u> from dwell-time histograms.  
     
   Save calculations to your ***.mash project**.  
     
   **Note:** *For systems with well-separated states, the number of states can also be estimated from the FRET histogram with [Histogram analysis](docs/histogram-analysis/histogram-analysis.html).*

4. After estimating the number of states, load the ***.mash project**  containing FRET data in [Histogram analysis](docs/histogram-analysis/histogram-analysis.html) to:  
   &#9745; quantify the <u>relative population</u> of each state,  
   &#9745; evaluate the <u>cross-sample variability</u> of FRET populations in your molecule set.

### Result validation

### Procedure optimization



