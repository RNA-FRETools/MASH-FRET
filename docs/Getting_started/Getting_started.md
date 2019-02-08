---
layout: default
title: Getting started
nav_order: 1
has_children: true
permalink: /docs/Getting_started
---
# Getting started
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

<!-- Automatically generated links in TOC does not allow the "return" function
I'd rather use hand-made TOC until we find a better solution
1. TOC
{:toc}
-->

1. [Installation](Getting_started.html#installation)
1. [Interface](Getting_started.html#interface)
1. [Recommended procedures](Getting_started.html#recommended-procedures)
   1. [Analyze smFRET videos](Getting_started.html#analyze-smfret-videos)
   1. [Validate results](Getting_started.html#validate-results)
   1. [Test algorithms](Getting_started.html#test-algorithms)


## Installation
Clone or [download](https://github.com/RNA-FRETools/MASH-FRET/archive/master.zip) MASH-FRET into a directory of your choice.
```
git clone https://github.com/RNA-FRETools/MASH-FRET.git
```

Within Matlab add MASH-FRET to you path by going to `Home → Set Path → Add with Subfolders`
{: .pb-3 }

Start MASH-FRET by typing `MASH` at the MATLAB command prompt.

**Note:** *MASH-FRET is tested to run under Matlab version R2011a and above*

## Interface

<a href="../assets/images/main.png"><img src="../assets/images/main.png" width="325" style="float:right"/></a>

When you start MASH-FRET, the graphical interface appears in its default layout (Video processing module) and includes:

* a permanent **menu bar** to switch between <u>modules</u> and set the <u>root folder</u> where all generated files will be saved.
* a **main area** that contains the selected module to work with.

For a first use, it is recommended to create one <u>root folder</u> for one video file analyzed.

**Note:** *Keep the Matlab command window visible when using MASH-FRET: information about running processes and failure stream in live.
To keep tracks, logs are automatically written in a [daily log file](../output-files/log-daily-logs.html)*.


## Recommended procedures

The modules of MASH-FRET perform different tasks to generate different type of results. They must be used with a specific procedure depending on what is to be achieved.

Follow the recommended procedures depending on what you want to achieve:

* [Analyze smFRET videos](Getting_started.html#analyze-smfret-videos)
* [Validate results](Getting_started.html#validate-results)
* [Test algorithms](Getting_started.html#test-algorithms)

For more detail about how to use the individual modules, please refer to the respective sections of the documentation ([Simulation](docs/simulation/simulation.html), [Video processing](docs/video-processing/video-processing.html), [Trace processing](docs/trace-processing/trace-processing.html), [Histogram analysis](docs/histogram-analysis/histogram-analysis.html), [Transition analysis](docs/transition-analysis/transition-analysis.html)).

### Analyze smFRET videos

Follow this procedure to determine the <u>thermodynamic model</u> (states, state transition rates) and state <u>relative populations</u> of molecules in your single molecule video (SMV):

1. Create a folder named after your SMV and set it as the root folder in the menu bar.

1. With your **SMV file** and a reference **beads image** or video in hands, use [Video processing](docs/video-processing/video-processing.html) to:  
     
   &#9745; localize single <u>molecules coordinates</u>,  
   &#9745; calculate donor and acceptor <u>intensity-time traces</u>.  
     
   Molecule coordinates and intensity data are exported to a [*.mash project](output-files/mash-mash-project.html) file.

1. Load your freshly created [*.mash project](output-files/mash-mash-project.html) in [Trace processing](docs/trace-processing/trace-processing.html) to:  
     
   &#9745; visualize and <u>select</u> single molecules with coherent intensity trajectories,  
   &#9745; <u>correct intensities</u> from experimental bias,  
   &#9745; <u>discretize</u> FRET trajectories into states.  
     
   Save modifications and calculation to your [*.mash project](output-files/mash-mash-project.html) file.

1. Load the *[.mash project](output-files/mash-mash-project.html) containing FRET state trajectories in [Transition analysis](docs/transition-analysis/transition-analysis.html) to:  
     
   &#9745; determine <u>FRET states</u> from the transition density plot,  
   &#9745; calculate state <u>transition rates</u> from dwell-time histograms.  
     
   Save calculations to your [*.mash project](output-files/mash-mash-project.html) file.  
     
   **Note:** *For FRET histograms with well-separated peaks, FRET states can also be estimated with [Histogram analysis](docs/histogram-analysis/histogram-analysis.html).*

1. After estimating the number of states, load the *[.mash project](output-files/mash-mash-project.html)  containing FRET data in [Histogram analysis](histogram-analysis/histogram-analysis.html) to:  
     
   &#9745; quantify the <u>relative population</u> of each state,  
   &#9745; evaluate the <u>cross-sample variability</u> of FRET populations in your molecule set.  
     
   Save calculations to your [*.mash project](output-files/mash-mash-project.html) file.

### Validate results

Follow this procedure to validate the thermodynamic model determined from smFRET video analysis:

1. Use the **ASCII files** exported during your previous analysis to collect or calculate <u>experimental parameters</u>:  
     
   &#9745; number of molecules  
   &#9745; summed fluorescence <u>intensities</u> (corrected donor + acceptor intensities)  (in [trace files](output-files/txt-trace-processing-traces.html)  
   &#9745; average channel-specific <u>background</u> intensities  (in [parameters files](output-files/log-trace-processing-parameters.html))  
   &#9745; <u>FRET states</u>  
   &#9745; state <u>transition rates</u>  
   
1. Use the experimental parameters and your **setup characteristics** in [Simulation](docs/simulation/simulation.html) to <u>generate</u> synthetic intensity-time traces.  
      
	**Note:** *To simulate kinetic heterogeneity, use a number of degenerated FRET states equal to the number of exponential components*.
     
   Export generated time-traces to "Ideal traces" ASCII files.
   
1. Load your freshly exported **ASCII files** in [Trace processing](docs/trace-processing/trace-processing.html) to edit <u>project parameters</u>.  
     
   Save modifications and calculation to a new *[.mash project](output-files/mash-mash-project.html). Use a file name different from the experimental project (for example with the extension *_sim).

1. Perform steps 3, 4 and 5 of [smFRET video analysis](Getting_starded.html#smfret-video-analysis) on your *[.mash project](output-files/mash-mash-project.html).

1. Validate or invalidate your experimental thermodynamic model by comparing with results on simulation:  
     
	&#9745; the <u>FRET states</u>  
	&#9745; the state <u>transition rates</u>  
    &#9745; the states <u>relative populations</u>  

### Test algorithms

Follow this procedure to determine the optimal methods and method parameters to analyse your data:

1. Use the ASCII files exported during your previous analysis to collect or calculate <u>experimental parameters</u>:  
     
   &#9745; spots coordinates and spots widths in the SMV  
