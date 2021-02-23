---
layout: default
title: Use Background analyzer
parent: Functionalities
grand_parent: Trace processing
nav_order: 7
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Use Background analyzer
{: .no_toc }

The background analyzer allows to screen parameter settings for background estimation.

It is accessed by pressing 
![Opt.](../../assets/images/gui/TP-but-optp.png "Opt.") in the 
[Background correction](../panels/panel-background-correction.html) panel of module Trace processing.

Background analyzer is used to evaluate the performances of background estimation methods on simulated data, *i.e.*, in the frame of algorithm testing.

Background analyzer window is divided into two panels **(1-2)** and one visualization area **(3)**.

<a class="plain" href="../../assets/images/gui/TP-panel-bg-bga.png"><img src="../../assets/images/gui/TP-panel-bg-bga.png" style="max-width: 531px;"/></a>

## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Method settings

Use this panel to set the background estimation method.

<a class="plain" href="../../assets/images/gui/TP-panel-bg-bga-method.png"><img src="../../assets/images/gui/TP-panel-bg-bga-method.png" style="max-width: 491px;"/></a>

Background estimation methods are configured for individual intensity-time traces.

Select the molecule by using 
![<](../../assets/images/gui/TP-but-inf.png "<") and 
![>](../../assets/images/gui/TP-but-sup.png ">"), or by setting the molecule index in **(a)**, and the intensity time trace in list **(b)**.

MASH includes six background estimation methods that can be selected in list **(b)**.
After selecting a method, set parameters **(d - i)** according to the detailed description given in the table below.

| filter                                            | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | default parameters                                                        |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------- |
| `Mean value`                                      | The background intensity is estimated as *I*<sub>high</sub> + **(c)** &#215; *HWHM*<sub>high</sub>, with *I*<sub>high</sub> and *HWHM*<sub>high</sub> the respective mean and half-width at half-maximum of the high intensity distribution, high intensities being higher than *I*<sub>mean</sub> + **(d)** &#215; *&#963;*<sub>I</sub>, with *I*<sub>mean</sub> and *&#963;*<sub>I</sub> the respective mean and standard deviation of the intensity distribution in the sub-image of dimensions **(d)**-by-**(d)** pixels. | **(c)** = 0, **(d)** = 20                                                 |
| `Most frequent`                                   | The background intensity is estimated as the most frequent value in the sub-image of dimensions **(d)**-by-**(d)** pixels and considering a binning interval of (*I*<sub>max</sub>-*I*<sub>min</sub>) / **(c)**.                                                                                                                                                                                                                                                                                                              | **(c)** = 100, **(d)** = 20                                               |
| `Median value`                                    | The background intensity is estimated in the sub image of dimension **(d)**-by-**(d)**, either as the median of median pixels in the row dimension if **(c)** = 1, or as an average between the medians of median pixels in the row dimension and in the column dimension if **(c)** = 2                                                                                                                                                                                                                                      | **(c)** = 2, **(d)** = 20                                                 |
| `Histothresh`                                     | The background intensity is estimated as the intensity corresponding to a probability **(c)** in the cumulative distribution of intensities in the sub-image of dimensions **(d)**-by-**(d)** pixels.                                                                                                                                                                                                                                                                                                                         | **(c)** = 0.5, **(d)** = 20                                               |
| `<N median values>`                               | The background intensity is estimated as the average of median pixels in each columns of the sub-image of dimensions **(d)**-by-**(d)** pixels                                                                                                                                                                                                                                                                                                                                                                                | **(d)** = 20                                                              |
| `Dark trace`                                      | The background trace is calculated from a dark pixel located at position x=**(f)** and y=**(g)** that can be detected automatically in a **(d)**-by-**(d)** sub-image if **(h)** is activated. The trace is smoothed with an average window size of **(c)** frames prior being subtracted                                                                                                                                                                                                                                     |  **(c)** = 10, **(d)** = 20, **(e)** = 0, **(f)** = 0, **(g)** activated  |
| `Manual`                                          | The background intensity in estimated by the user and set in [Background intensity](#background-intensity)                                                                                                                                                                                                                                                                                                                                                                                                                    |                                                                           |

After method configuration, the same settings can be applied to all intensity-time traces of the current molecule by pressing 
![Set for all channels](../../assets/images/gui/TP-but-set-for-all-channels.png "Set for all channels"), and to all molecules by pressing 
![Set for all molecules](../../assets/images/gui/TP-but-set-for-all-molecules.png "Set for all molecules").

**Note:** *As the method `Dark trace` calculates a background trajectory and not an intensity, the mean value of the dark trace is taken for point estimate of the background intensity*


---

## Parameter screening

Use this panel to define the parameter ranges to be screened.

<a class="plain" href="../../assets/images/gui/TP-panel-bg-bga-param.png"><img src="../../assets/images/gui/TP-panel-bg-bga-param.png" style="max-width: 153px;"/></a>

Parameter screening can be applied to the current molecule only or to all molecules by respectively deactivating or activating the option in **(a)**.

If allowed by the background estimation method used in 
[Method settings](#method-settings), one or both of the parameters `dim` and `param` can be varied up to ten different values. 

To screen parameter `dim` and/or `param`, deactivate the respective option in **(d)** and or **(e)**, and set the screening values in **(b)** and/or **(c)** respectively.

Start background estimation with parameter screening by pressing 
![Start](../../assets/images/gui/TP-but-start.png "Start"); after completion, the 
[Visualization area](#visualization-area) is automatically updated with screening results for the current molecule. 

Results of uni- or multidimensional background estimations can be exported to 
[.bga files](../../output-files/bga-background-analyzer.html) by pressing 
![Save](../../assets/images/gui/TP-but-save-bga.png "Save").


---

## Visualization area

Use this area to visualize screening results.

Any graphics in MASH-FRET can be exported to an image file by left-clicking on the axes and selecting `Export graph`.


### no screening
{: .no_toc }

When both parameters `dim` and `param` are fixed, the background estimate is written in the axes together with the parameter values.

<img src="../../assets/images/gui/TP-panel-bg-bga-visu0D.png" style="max-width: 394px;"/>


### 1-parameter screening
{: .no_toc }

When one of the two parameters `dim` or `param` is screened, the variation of background estimates is plotted as a 2D scatter plot titled with the fixed parameter value.

<img src="../../assets/images/gui/TP-panel-bg-bga-visu1D.png" style="max-width: 394px;"/>


### 2-parameters screening
{: .no_toc }

When both parameters `dim` or `param` are screened, the variation of background estimates is plotted as a 3D surface.

<img src="../../assets/images/gui/TP-panel-bg-bga-visu2D.png" style="max-width: 394px;"/>

