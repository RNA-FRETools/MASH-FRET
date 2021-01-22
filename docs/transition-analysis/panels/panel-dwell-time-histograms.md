---
layout: default
title: Dwell time histograms
parent: /transition-analysis/panels.html
grand_parent: /transition-analysis.html
nav_order: 4
---

<img src="../../assets/images/logos/logo-transition-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Dwell time histograms
{: .no_toc }

Dwell time histograms is the third panel of module Transition analysis.

Use this panel to estimate state degeneracy, 2-state-restricted transition rates and associated cross-sample variability with BOBA-FRET.

<a class="plain" href="../../assets/images/gui/TA-panel-dwell-time-histograms.png"><img src="../../assets/images/gui/TA-panel-dwell-time-histograms.png" style="max-width:386px;"></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Dwell time processing

Use this panel to process state sequences prior building histograms.

<img src="../../assets/images/gui/TA-panel-dwell-time-histograms-dt-processing.png" style="max-width:164px;">


---

## Fit settings

Press 
![Fit settings](../../assets/images/gui/TA-but-fit-settings.png "Fit settings") to open settings and set the fitting model as well as the starting guess, or to look at fitting results.

<img src="../../assets/images/gui/TA-panel-dwell-time-histograms-fit-param.png" style="max-width:309px;">


---

## Start fit

Press 
![Fit current](../../assets/images/gui/TA-but-fit-current.png "Fit current") to fit the currently displayed dwell time histogram with the fitting method defined in 
[Fit settings](#fit-settings).

Press 
![Fit all](../../assets/images/gui/TA-but-fit-all.png "Fit all") to fit all dwell time histograms.


---

## State lifetimes

Watch this area to obtain state lifetimes after histogram fitting is completed.

<img src="../../assets/images/gui/TA-panel-dwell-time-histograms-lifetimes.png" style="max-width:152px;">


---

## Visualization area

Use this interface to visualize the cumulative dwell time histogram and fitting results.

The histogram plot depends on the 
[Fit settings](#fit-settings) and the stage the transition analysis is at.

Any graphics in MASH can be exported to an image file by right-clicking on the axes and selecting `Export graph`.


### Default
{: .no_toc }

Just after clustering and providing that the dwell time set selected in the
[State lifetimes](#state-lifetimes) is not empty, the corresponding cumulative and complementary dwell time histogram is plotted with blue solid markers.

<img src="../../assets/images/gui/TA-panel-dwell-time-histograms-plot-default.png" style="max-width:216px;">

To identify potential multiple decays, the dwell time histogram can be visualized on a semi-log scale by pressing 
![y-log scale](../../assets/images/gui/TA-but-y-log-scale.png "y-log scale").

<img src="../../assets/images/gui/TA-panel-dwell-time-histograms-plot-log.png" style="max-width:224px;">


### After fit
{: .no_toc }

After performing exponential fitting, the resulting fit function is plotter over the histogram as a solid red line.

<img src="../../assets/images/gui/TA-panel-dwell-time-histograms-plot-fit.png" style="max-width:228px;">

When the 
[Fit settings](#fit-settings) include bootstrapping, the exponential function built with bootstrap means of the fitting parameters is plotted as a red solid line.

Exponential fit functions giving the lowest and highest lifetimes are plotted in dotted lines. 
This gives an visual estimation of the cross-sample variability of state lifetimes.

<img src="../../assets/images/gui/TA-panel-dwell-time-histograms-plot-boba.png" style="max-width:224px;">


