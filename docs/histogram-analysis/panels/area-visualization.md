---
layout: default
title: Visualization area
parent: /histogram-analysis/panels.html
grand_parent: /histogram-analysis.html
nav_order: 5
---

# Visualization area
{: .no_toc }

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Top axes

The top axes display various histogram plots depending on which stage the histogram analysis is at.

Any graphics in MASH can be exported to an image file by right-clicking on the axes and selecting `Export graph`.


### Default
{: .no_toc }

When opening a new project in Histogram analysis and providing that the data selected in the
[Data list](panel-histogram-and-plot.html#data-list) exists in the project, the normalized data histogram is built as defined in 
[Histogram and plot](panel-histogram-and-plot.html) and is plotted in the top axes.

<img src="../../assets/images/gui/HA-area-visualization-top-default.png" style="max-width:482px;">


### Inferred state configuration
{: .no_toc }

After completing the state configuration analysis, the most sufficient Gaussian mixture model is plotted over the data histogram with each Gaussian being color-coded as shown in 
[Gaussian fitting](panel-state-populations#gaussian-fitting); see the section
[State configuration analysis](../workflow.html#determine-the-most-sufficient-state-configuration) of Histogram analysis workflow for more information about state configuration analysis.

<img src="../../assets/images/gui/HA-area-visualization-top-gaussian.png" style="max-width:482px;">


### After Gaussian fitting
{: .no_toc }

After performing a simple Gaussian fitting to estimate state relative populations, the resulting fit is displayed as for 
[Inferred state configuration](#inferred-state-configuration).

When the 
[Method settings](panel-state-populations.html#method-settings) include the use of BOBA-FRET, the Gaussian fit functions giving the lowest and highest populations for each state are plotted in dotted lines. 
This gives an visual estimation of the cross-sample variability of state populations.

<img src="../../assets/images/gui/HA-area-visualization-top-gaussian-boba.png" style="max-width:482px;">


### After thresholding
{: .no_toc }

After setting the thresholds used to calculate state relative populations with the thresholding method, the histogram is partitioned into the resulting state populations, each being color-coded as shown in 
[Thresholding](panel-state-populations#thresholding).

<img src="../../assets/images/gui/HA-area-visualization-top-threshold.png" style="max-width:482px;">


---

## Bottom axes

The bottom axes display various scatter plots depending on which stage the histogram analysis is at.

Any graphics in MASH can be exported to an image file by right-clicking on the axes and selecting `Export graph`.

### Default
{: .no_toc }

When opening a new project in Histogram analysis and providing that the data selected in the
[Data list](panel-histogram-and-plot.html#data-list) exists in the project, the normalized cumulative data histogram is plotted in the top axes.

<img src="../../assets/images/gui/HA-area-visualization-bottom-default.png" style="max-width:482px;">

In this plot, histogram peaks are visualized as steps.


### After Gaussian fitting
{: .no_toc }

After performing a simple Gaussian fitting, the resulting state relative populations are plotted as colored cross marks in function of the respective Gaussian means.
When the 
[Method settings](panel-state-populations.html#method-settings) include the use of BOBA-FRET, state populations are plotted for each bootstrap sample, which gives an visual estimation of the cross-sample variability of state populations.

<img src="../../assets/images/gui/HA-area-visualization-bottom-gaussian-boba.png" style="max-width:482px;">


### After thresholding
{: .no_toc }

After setting the thresholds used to calculate state relative populations with the 
[Thresholding](panel-state-populations#thresholding) method, thresholds are shown as vertical black lines over the normalized cumulative histogram.

<img src="../../assets/images/gui/HA-area-visualization-bottom-threshold.png" style="max-width:482px;">


