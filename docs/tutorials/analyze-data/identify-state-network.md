---
layout: default
title: Step 3
subtitle: Identify state network
grand_parent: /tutorials.html
parent: /tutorials/analyze-data.html
nav_order: 3
has_toc: false
nav_exclude: true
---

<img src="../../assets/images/logos/logo-tutorials_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Analyze data
{: .no_toc }

Follow this procedure to process your single molecule videos (SMVs) or trajectories and characterize the molecule dynamics in your sample.

**Note:** *Skip step 1 if already in possession of intensity-time traces files (ASCII or 
[mash project](../../output-files/mash-mash-project)).*

{% include tutorial_toc.html %}


---

{% include tutorial_head.html %}

In this step, the sample's most sufficient state configuration is identified and state transition rates are estimated from transitions detected in single molecule traces.

1. TOC
{:toc}

**Note:** *Alternatively, if states are sufficiently separated, the most sufficient state configuration can be identified from histogram data; see
[Workflow](../../histogram-analysis/workflow.html) for more information.*

---

*In construction*

<!--

## Setup working area

1. Select module 
[Transition analysis](../../transition-analysis.html) in MASH-FRET's 
[tool bar](../../Getting_started.html#interface).

1. Load your 
[mash project](../../output-files/mash-mash-project.html)

1. Select data type "FRET"


## Build the transition density plot (TDP)

1. Set TDP's limits as desired.
Usually limits are set to [0,1] for FRET data.

1. Set TDP's binning as desired.
Usually binning is set to 0.01 or 0.02 for FRET data.  
     
   **Note:** *The larger the binning, the faster calculations. Yet a binning too large may lead to the fusion of two neighbouring transition clusters which bias the estimation.*

1. Add a Gaussian filter to smooth the TDP

1. Display in counts or normalized probability


## Identify the most sufficient state configuration

1. Set the maximum number of states to be found

1. Set the number of iteration.
Usually the number of iteration is set to 5.

1. Set the cluster shape according to the discretisation algorithm used.

1. Start transition clustering


## Estimate state transition rates with exponential fit

1. Select a FRET transition in the list.

1. Plot the complement probability of the corresponding state dwell times in semi-log axis.

1. Fit data without bootstraping and with one exponential decay.
If the fit looks poor, increase the number of exponential decays or fit with a beta-exponential.


## Estimate sample variability with bootstrapping

1. Paste fitting results to starting fit parameters

1. Set bootstraping parameters.
Usually number of replicate is set to the number of dwell-times  and the number of samples to 100.

1. Start bootstrap fit


## Save and export

1. Save modifications and calculation to your 
[mash project](../../output-files/mash-mash-project.html) file.

1. (optional) Export state model and transition rate calculations to ASCII files.

-->

---

{% include tutorial_footer.html %}