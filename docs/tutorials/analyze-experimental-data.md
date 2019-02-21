---
layout: default
title: Analyze experimental data
parent: Tutorials
nav_order: 1
---


# Analyze experimental data
{: .no_toc }

Follow this procedure to process your experimental **single molecule videos** (SMVs) or **trajectories** and characterize the molecule dynamics of your sample.

Experimental data analysis is performed in five main steps.

1. TOC
{:toc}

**Note:** *Ignore step 1 if you already possess intensity-time traces in ASCII or 
[mash project](../output-files/mash-mash-project.html) files.*


## Create intensity-time traces

In this step, single molecules are localized on the SMV and intensity trajectories are calculated.

1. Create a <u>root folder</u> named after your experiment and set root path in MASH-FRET's <u>tool bar</u>.
1. Select module 
[Video processing](../video-processing) in MASH-FRET's <u>tool bar</u>.
1. With a reference **beads image** or video in hands:  
     
   &#9745; <u>export an average image</u> of the beads video if necessary,  
   &#9745; <u>map reference</u> coordinates on the beads image and export to file, 
   &#9745; <u>calculate transformation</u> and save to file, 
   &#9745; fill in the <u>experiment settings</u>,  
   &#9745; <u>localize</u> single molecule coordinates,  
   &#9745; create <u>intensity-time traces</u> of donor and acceptor channels and save data to a 
   [mash project](../output-files/mash-mash-project.html) file.

   
## Find states and state transitions in individual trajectories
   
1. Load your freshly created 
[mash project](../output-files/mash-mash-project.html) in 
[Trace processing](../trace-processing) to:  
     
   &#9745; visualize and <u>select</u> single molecules with coherent intensity trajectories,  
   &#9745; <u>correct intensities</u> from experimental bias (background, cross-talks, gammma, photobleaching),  
   &#9745;  <u>discretize</u> FRET trajectories into states,  
   &#9745; save modifications and calculation to your 
   [mash project](../output-files/mash-mash-project.html) file.
   

## Identify sample's most relevant state configuration

1. Load the *
[.mash project](../output-files/mash-mash-project.html) in 
[Transition analysis](../transition-analysis) to:  
     
   &#9745; determine <u>FRET states</u> from the transition density plot,  
     
   **Note:** *For FRET histograms with well-separated peaks, FRET states can also be estimated with 
   [Histogram analysis](../histogram-analysis).*


## Characterize state transition rates

   &#9745; calculate state <u>transition rates</u> from dwell-time histograms,  
   &#9745; save calculations to your 
   [mash project](../output-files/mash-mash-project.html) file.  

   
## Characterize state relative population

1. After estimating the number of states, load the *
[.mash project](../output-files/mash-mash-project.html)  containing FRET data in 
[Histogram analysis](../histogram-analysis) to:  
     
   &#9745; quantify the <u>relative population</u> of each state,  
   &#9745; evaluate the <u>cross-sample variability</u> of FRET populations in your molecule set,  
   &#9745; save calculations to your 
   [mash project](../output-files/mash-mash-project.html) file.

