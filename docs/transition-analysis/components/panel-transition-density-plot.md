---
layout: default
title: Transition density plot
parent: Components
grand_parent: Transition analysis
nav_order: 2
---

<img src="../../assets/images/logos/logo-transition-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Transition density plot
{: .no_toc }

Transition density plot (TDP) is the first panel of module Transition analysis. 
Access the panel content by pressing 
![Bottom arrow](../../assets/images/gui/interface-but-bottomarrow.png). 
The panel closes automatically after other panels open or after pressing 
![Top arrow](../../assets/images/gui/interface-but-toparrow.png). 

Use this panel to select data and build the TDP. 
Press 
![Update](../../assets/images/gui/TA-but-update.png "Update") to recalculate the TDP with the new settings.
For more information about how TDPs are built, please refer to 
[Build transition density plot](../workflow.html#build-transition-density-plot) in Transitions analysis workflow.

<a class="plain" href="../../assets/images/gui/TA-panel-transition-density-plot.png"><img src="../../assets/images/gui/TA-panel-transition-density-plot.png" style="max-width:294px;"></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Bounds and bin size

Use this interface to define TDP limits and sorting intervals.

<a class="plain" href="../../assets/images/gui/TA-panel-transition-density-plot-axis.png"><img src="../../assets/images/gui/TA-panel-transition-density-plot-axis.png" style="max-width:272px;"></a>

TDP limits define the range of data used in the analysis, and the bin size defines the intervals used to sort data in the transition density plot (TDP).

Limits and bin sizes are identical for the x- and y-axis.
The lower limit is set in **(a)**, the bin size in **(b)** and the higher limit in **(c)**.

For more information about the influence of limits and bin size on the analysis, please refer to 
[Build transition density plot](../workflow.html#build-transition-density-plot) in Transition analysis workflow.

<u>default</u>: For ratio data, default limits are set to [-0.2;1.2] and the bin size to 0.01


---

## Include static molecules

Activate this option to make last states of sequences, and thus one-state sequences, visible in the TDP.

In the TDP, state transitions are represented as a 2D-point with coordinates (state1,state2) with state1 being the state prior transition and state2, after transition. 
State sequences made of only one state, called "static", can not be represented in the TDP with the regular coordinate system and are therefore excluded from the TDP and dwell time histograms.

When activating this option, the last state of every sequence (and thus the only state of static sequences) are positionned on the diagonal (state1=state2).

To work with state transitions only, and thus, exclude static state sequences, deactivate this option.

***Note:** Including statics has an effect on transition densities used in clustering and on the dwell time histograms in
[State transition rates](panel-state-transition-rates.html).*


---

## Single count per molecule

Activate this option to build the TDP with single transition counts per trajectory.

Single transition count allows to scale equally the most and least occurring transitions in the TDP.

To build the TDP with absolute transition counts and obtain the genuine transition probability distribution, deactivate this option.

***Note:** Transition counts in the TDP are used for clustering only.*


---

## Re-arrange sequences

Activate this option to re-build state sequences only with states visible the TDP.

In the regular building process, states that lay out-of-TDP-range are ignored, creating time gaps in the state sequences where states are left unidentified. 

Sequence re-arrangement allows to fill these time gaps by prolonging the duration of identified states preceeding the outliers in the sequence.
If no state preceeding the outliers was identified, the duration of the identified state following in the sequence is prolonged.

To work with initial state durations, and thus, with time-gapped state sequences, deactivate this option.

***Note:** Sequence re-arrangement has an effect on transition densities used in clustering only.*


---

## Gaussian filter

Activate this option to convolute the TDP with a 2D Gaussian.

Gaussian convolution eases the identification of transition clusters for 
[State configuration](panel-state-configuration.html) analysis.

Deactivate this option to use the genuine transition probability distribution for clustering.

***Note:** Gaussian-convoluted counts in the TDP are used only for clustering.*


---

## Normalize

Activate this option to display the TDP in normalized counts.

In this case, counts are normalized by the sum for display only, and are color-coded as shown in the color bar located on the right-hand side of the 
[Visualization area](panel-state-configuration.html#visualization-area).


---

## Color map

Use this list to define the color scale used in the 
[Visualization area](panel-state-configuration.html#visualization-area).

The list contains the standard color maps of MATLAB:

| name     | palette                                                           |
| :------: | :---------------------------------------------------------------: |
| `parula` | <img src="../../assets/images/gui/VP-panel-plot-mapparula.png" /> |
| `turbo` | <img src="../../assets/images/gui/VP-panel-plot-mapturbo.png" /> |
| `hsv` | <img src="../../assets/images/gui/VP-panel-plot-maphsv.png" /> |
| `hot` | <img src="../../assets/images/gui/VP-panel-plot-maphot.png" /> |
| `cool` | <img src="../../assets/images/gui/VP-panel-plot-mapcool.png" /> |
| `spring` | <img src="../../assets/images/gui/VP-panel-plot-mapspring.png" /> |
| `summer` | <img src="../../assets/images/gui/VP-panel-plot-mapsummer.png" /> |
| `autumn` | <img src="../../assets/images/gui/VP-panel-plot-mapautumn.png" /> |
| `winter` | <img src="../../assets/images/gui/VP-panel-plot-mapwinter.png" /> |
| `gray` | <img src="../../assets/images/gui/VP-panel-plot-mapgray.png" /> |
| `bone` | <img src="../../assets/images/gui/VP-panel-plot-mapbone.png" /> |
| `copper` | <img src="../../assets/images/gui/VP-panel-plot-mapcopper.png" /> |
| `pink` | <img src="../../assets/images/gui/VP-panel-plot-mappink.png" /> |
| `jet` | <img src="../../assets/images/gui/VP-panel-plot-mapjet.png" /> |
| `lines` | <img src="../../assets/images/gui/VP-panel-plot-maplines.png" /> |
| `colorcube` | <img src="../../assets/images/gui/VP-panel-plot-mapcolorcube.png" /> |
| `prism` | <img src="../../assets/images/gui/VP-panel-plot-mapprism.png" /> |
| `flag` | <img src="../../assets/images/gui/VP-panel-plot-mapflag.png" /> |
| `white` | <img src="../../assets/images/gui/VP-panel-plot-mapwhite.png" /> |

<u>default</u>: `turbo`

