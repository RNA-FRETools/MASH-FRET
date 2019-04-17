---
layout: default
title: State populations
parent: /histogram-analysis/panels.html
grand_parent: /histogram-analysis.html
nav_order: 4
---

# State populations
{: .no_toc }

<a href="../../assets/images/gui/HA-panel-state-populations.png"><img src="../../assets/images/gui/HA-panel-state-populations.png" style="max-width: 388px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Method settings

Defines the method to calculate state populations.

<img src="../../assets/images/gui/HA-panel-state-populations-method.png" style="max-width: 156px;"/>


---

## Thresholding

Defines settings to calculate state populations with the Thresholding method.

<img src="../../assets/images/gui/HA-panel-state-populations-thresholding.png" style="max-width: 215px;"/>

States are separated by fixed thresholds, histogram counts are summed up between thresholds and resulting populations are normalized.

* Set `J-1` thresholds in edit fieldd **(a)** for a model containing *J* of states.
* Select threshold with dropdown menu **(b)** and set the threshold value in edit field **(c)**.
* Start calculations with button 
![Start](../../assets/images/gui/HA-but-start.png)
* <u>Start thresholding</u>

* <u>Calculation results</u>


---

## Gaussian fitting

Defines settings to calculate state populations with the Gaussian fitting method.

<img src="../../assets/images/gui/HA-panel-state-populations-gaussian-fitting.png" style="max-width: 365px;"/>

Histogram is fitted with a mixture of Gaussians and 

* <u>Fitting model</u>

* <u>Start fitting</u>

* <u>Fitting results and state populations</u>


