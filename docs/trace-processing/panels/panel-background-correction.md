---
layout: default
title: Background correction
parent: /trace-processing/panels.html
grand_parent: /trace-processing.html
nav_order: 5
---

# Background correction
{: .no_toc }

<a href="../../assets/images/gui/TP-panel-bg.png"><img src="../../assets/images/gui/TP-panel-bg.png" style="max-width: 290px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Background correction settings

Use this interface to define the settings used for background correction.

<a href="../../assets/images/gui/TP-panel-bg-param.png"><img src="../../assets/images/gui/TP-panel-bg-param.png" style="max-width: 278px;"/></a>

Background estimation methods are configured for individual intensity-time traces selected in list **(a)**.
After method configuration, the same settings can be applied to all molecules by pressing 
![all](../../assets/images/gui/TP-but-all.png "all"); see 
[Apply settings to all molecules](#apply-settings-to-all-molecules).

MASH includes six background estimation methods that can be selected in list **(b)**.
To configure a method, set parameters **(c - g)** according to the detailed description given in the table below.

| filter                                            | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | default parameters                                                        |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `Mean value`                                      | The background intensity is estimated as *I*<sub>high</sub> + **(c)** &#215; *HWHM*<sub>high</sub>, with *I*<sub>high</sub> and *HWHM*<sub>high</sub> the respective mean and half-width at half-maximum of the high intensity distribution, high intensities being higher than *I*<sub>mean</sub> + **(d)** &#215; *&#963;*<sub>I</sub>, with *I*<sub>mean</sub> and *&#963;*<sub>I</sub> the respective mean and standard deviation of the intensity distribution in the sub-image of dimensions **(d)**-by-**(d)** pixels. | **(c)** = 0, **(d)** = 20                                                 |
| `Most frequent`                                   | The background intensity is estimated as the most frequent value in the sub-image of dimensions **(d)**-by-**(d)** pixels and considering a binning interval of (*I*<sub>max</sub>-*I*<sub>min</sub>) / **(c)**.                                                                                                                                                                                                                                                                                                              | **(c)** = 100, **(d)** = 20                                               |
| `Median value`                                    | The background intensity is estimated in the sub image of dimension **(d)**-by-**(d)**, either as the median of median pixels in the row dimension if **(c)** = 1, or as an average between the medians of median pixels in the row dimension and in the column dimension if **(c)** = 2                                                                                                                                                                                                                                      | **(c)** = 2, **(d)** = 20                                                 |
| `Histothresh`                                     | The background intensity is estimated as the intensity corresponding to a probability **(c)** in the cumulative distribution of intensities in the sub-image of dimensions **(d)**-by-**(d)** pixels.                                                                                                                                                                                                                                                                                                                         | **(c)** = 0.5, **(d)** = 20                                               |
| `<N median values>`                               | The background intensity is estimated as the average of median pixels in each columns of the sub-image of dimensions **(d)**-by-**(d)** pixels                                                                                                                                                                                                                                                                                                                                                                                | **(d)** = 20                                                              |
| `Dark trace`                                      | The background trace is calculated from a dark pixel located at position x=**(f)** and y=**(g)** that can be detected automatically in a **(d)**-by-**(d)** sub-image if **(h)** is activated. The trace is smoothed with an average window size of **(c)** frames prior being subtracted                                                                                                                                                                                                                                     |  **(c)** = 10, **(d)** = 20, **(e)** = 0, **(f)** = 0, **(g)** activated  |
| `Manual`                                          | The background intensity in estimated by the user and set in [Background intensity](#background-intensity)                                                                                                                                                                                                                                                                                                                                                                                                                    |                                                                           |


---

## Background analyzer

Opens the tool Background analyzer used to to screen parameter settings for background estimation.

To use Background analyzer, refer to 
[Use Background analyzer](../functionalities/use-background-analyzer.html).


---

## Background intensity

It displays the background intensity estimated with the method defined and for the intensity-time trace selected in 
[Background correction settings](#background-correction-settings).

For method `Manual`, the background intensity to subtract must be set here.

As the method `Dark tarce` calculates a background trajectory and not an intensity, the mean value of the dark trace is taken for the point estimate of the background intensity.


---

## Apply background correction

Activate this option to subtract the background to the intensity-time trace selected in 
[Background correction settings](#background-correction-settings), or deactivate this option to visualize the original intensity-time trace.


---

## Apply settings to all molecules

Use this command to apply the intensity-time trace-specific 
[Background correction settings](#background-correction-settings) to all molecules.

Corrections are applied to other molecules only when the corresponding data is processed, *i.e.*, when pressing 
![UPDATE ALL](../../assets/images/gui/TP-but-update-all.png "UPDATE ALL"); see 
[Process all molecules data](panel-sample-management.html#process-all-molecules-data) for more information.


