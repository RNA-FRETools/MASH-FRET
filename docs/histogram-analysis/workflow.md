---
layout: default
title: Workflow
parent: Histogram analysis
nav_order: 2
---

<img src="../assets/images/logos/logo-histogram-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Workflow
{: .no_toc }

In this section you will learn how to determine the most sufficient state configuration from histograms, to obtain the relative state populations and to estimate the associated cross-sample variability. 

Initial data are the trajectories from 
[Trace processing](../trace-processing.html)'s output.

The procedure includes four steps:

1. TOC
{:toc}


---

## Build histogram

To build an histogram, data are limited to specific boundaries and sorted into bins of specific size.
Ideally, each state population appears as a Gaussian-shaped peak in the histogram.

The bin size has a substantial influence on the histogram shape: large bins will increase the overlap between neighbouring peaks until the extreme case where all peaks are merged in one, whereas short bins will flatten the peaks until the extreme case where no peak is distinguishable.

Histogram boundaries are important as they define the range of data considered for analysis.
Large data ranges can include outliers that would bias the state analysis and narrow ranges can exclude relevant contribution for population analysis.

The histogram limits and bin size have to be carefully chosen in order to enhance the natural shape of data distribution without altering it.

![Effect of histogram bin size](../assets/images/figures/HA-workflow-scheme-bin-size.png "Effect of histogram bin size")

To build the histogram:

{: .procedure }
1. Select the data and molecule subgroup to export in the 
   [Data list](components/area-data-selection.html#data-list) and 
   [Molecule subgroup list](components/area-data-selection.html#molecule-subgroup-list), respectively  
     
1. Set parameters:  
     
   [Histogram binning](components/panel-histogram-and-plot.html#histogram-binning)  
   [Overflow bins](components/panel-histogram-and-plot.html#overflow-bins)  
     
   The histogram is instantly built with the new parameters and displayed in the 
   [Visualization area](components/area-visualization.html#histograms)


---

## Determine the most sufficient state configuration

In histogram analysis, states are identified as histogram peaks that are ideally modelled by a Gaussian distribution.
Therefore, the overall histogram can be described by the sum of 
[*J*](){: .math_var } Gaussian distributions, with 
[*J*](){: .math_var } the number of states.

In the case of well-separated peaks, 
[*J*](){: .math_var } is easily determined by eye, but most of the time, the histogram peaks overlap each other and can't be accurately distinguished.

![Histogram peak overlap](../assets/images/figures/HA-workflow-scheme-peak-overlap.png "Histogram peak overlap")

One way of objectively identifying the number of overlapping peaks in a histogram is to, first, find the Gaussian mixtures that describe the data the best for different 
[*J*](){: .math_var }, and then to compare optimum models with each other.
As the goodness of fit, or model likelihood, fundamentally increases with the number of components, inferred models can be compared via:

* the improvement in goodness of fit
* the Bayesian information criterion (BIC)

In the first case, a certain improvement in model likelihood is expected when adding a new component to the model, *e. g.* an increase of 20%.
Here, the most sufficient model is the least complex model for which adding a component does not fulfil this requirement.

In the second case, the BIC is used to rank models according to their sufficiency, with the most sufficient model having the lowest BIC.

To determine the most sufficient state configuration:

{: .procedure }
1. If not already done, select the data and molecule subgroup to export in the 
   [Data list](components/area-data-selection.html#data-list) and 
   [Molecule subgroup list](components/area-data-selection.html#molecule-subgroup-list), respectively  
     
1. Set parameters:  
     
   [Maximum number of Gaussians](components/panel-state-configuration.html#maximum-number-of-gaussians)  
   [Model penalty](components/panel-state-configuration.html#model-penalty)  
     
1. Start inference of state configurations by pressing 
   ![Start analysis](../assets/images/gui/HA-but-start-analysis.png "Start analysis"); after completion, the display is instantly updated with the most sufficient Gaussian mixture


---

## Estimate state populations and associated cross-sample variability

The relative population 
[*X*<sub>*j*</sub>](){: .math_var} of a state 
[*j*](){: .math_var } is associated to the probability of finding a molecule in state 
[*j*](){: .math_var } any time in the sample.

It can be estimated from the histogram by integrating each peak to a value 
[*S*<sub>*j*</sub>](){: .math_var } and calculating the ratio:

{: .equation }
<img src="../assets/images/equations/HA-eq-pop.gif" alt="X_{j} = \frac{S_{j}}{\sum_{j'=1}^{J}( S_{j'})}">

For well-separated histogram peaks, 
[*S*<sub>*j*</sub>](){: .math_var } values are calculated using thresholds between peaks.
For overlapping peaks, a mixture of 
[*J*](){: .math_var } Gaussians is fitted to the histogram and Gaussian integrals are used as 
[*S*<sub>*j*</sub>](){: .math_var } values.

![Estimation of state's relative populations](../assets/images/figures/HA-workflow-scheme-populations.png "Estimation of state's relative populations")

The outcome of such analysis are single estimates of relative state populations, meaning that they carry no information about the variability across the molecule sample.

One way to evaluate the cross-sample variability of relative state populations is to use the bootstrap-based analysis called BOBA-FRET.
BOBA-FRET applies to both threshold and Gaussian-fitting methods, and infers the bootstrap mean 
[*&#956;*<sub>*X*,*j*</sub>](){: .math_var } and bootstrap standard deviation
[*&#963;*<sub>*X*,*j*</sub>](){: .math_var } of state populations for the given sample.

![Estimation of cross sample variability with BOBA-FRET](../assets/images/figures/HA-workflow-scheme-bobafret.png "Estimation of cross sample variability with BOBA-FRET")

To calculate relative state populations:

{: .procedure }
1. If not already done, select the data and molecule subgroup to export in the 
   [Data list](components/area-data-selection.html#data-list) and 
   [Molecule subgroup list](components/area-data-selection.html#molecule-subgroup-list), respectively  
     
1. Set parameters in 
   [Method settings](components/panel-state-populations.html#method-settings)  
     
1. Import parameters of one of the inferred state configurations by selecting the configuration in 
   [Inferred models](components/panel-state-configuration.html#inferred-models) and pressing 
   ![>>](../assets/images/gui/HA-but-supsup.png ">>")  
     
1. Adjust parameters in 
   [Thresholding](components/panel-state-populations.html#thresholding) or 
   [Gaussian fitting](components/panel-state-populations.html#gaussian-fitting) and respectively press 
   ![Start](../assets/images/gui/HA-but-start.png "Start") or 
   ![Fit](../assets/images/gui/HA-but-fit.png "Fit") to calculate state relative populations


---

## Export data

Histograms, analysis results and analysis parameters can be exported to ASCII files and PDF figures; see 
[Remarks](#remarks) for more information. 

To export data to files:

{: .procedure }
1. If not already done, select the data and molecule subgroup to export in the 
   [Data list](components/area-data-selection.html#data-list) and 
   [Molecule subgroup list](components/area-data-selection.html#molecule-subgroup-list), respectively  
     
1. Press
   ![EXPORT...](../../assets/images/gui/HA-but-exportdotdotdot.png "EXPORT...") and select the desired destination to start writing files.


---
 
## Remarks
{: .no_toc }

The type of exported files depends on which analysis was carried on; see 
[Export analysis results](components/area-control.html#export-data) for more information.


