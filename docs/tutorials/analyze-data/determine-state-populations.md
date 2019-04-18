---
layout: default
title: Determine state populations
grand_parent: /tutorials.html
parent: /tutorials/analyze-data.html
nav_order: 4
nav_exclude: true
has_toc: false
---


# Analyze data
{: .no_toc }

Follow this procedure to process your single molecule videos (SMVs) or trajectories and characterize the molecule dynamics in your sample.

**Note:** *Skip step 1 if already in possession of intensity-time traces files (ASCII or 
[mash project](../../output-files/mash-mash-project.html)).*

{% include tutorial_head.html %}

In this step, state relative populations and sample variability are estimated from histogram data and according to the state configuration determined previously.

1. TOC
{:toc}

---

<!--

## Setup working area

1. Select module 
[Histogram analysis](../../histogram-analysis.html) in MASH-FRET's 
[tool bar](../../Getting_started.html#interface).

1. Load your 
[mash project](../../output-files/mash-mash-project.html)

1. Select data type "FRET"


## Build the FRET histogram

1. Set FRET limits as desired.
Usually limits are set to [-0.1,1.1] for FRET data.

1. Set FRET binning as desired.
Usually binning is set to 0.01 for FRET data.  
     
   **Note:** *The larger the binning, the faster calculations. Yet a binning too large may lead to the fusion of two neighbouring peaks which bias the estimation.*


## Identify the most sufficient state model

1. Set the maximum number of states to be found

1. Start model estimation

1. Select the penalty. We recommend to use BIC penalty as it excludes user bias.


## Estimate state populations with Gaussian fitting

1. Choose the Gaussian fitting method.

1. Select the most sufficient state configuration in the list and import model characteristics to Gaussian fitting panel.  
     
   **Note:** *State relative populations can be calculated faster with thresholding, although the method is inaccurate for overlapping peaks; see 
   [Histogram thresholding](../../histogram-analysis/functionalities/histogram-thresholding.html) for more information*

1. Fit data without bootstraping.


## Estimate sample variability with bootstrapping

1. Paste previous fitting results to starting fit parameters

1. Set bootstraping parameters.
Usually number of replicate is set to the total number of molecules and the number of samples to 100.

1. Start bootstrap fit


## Save and export

1. Save modifications and calculation to your 
[mash project](../../output-files/mash-mash-project.html) file.

1. (optional) Export state population calculations to ASCII files.

-->

---

{% include tutorial_footer.html %}