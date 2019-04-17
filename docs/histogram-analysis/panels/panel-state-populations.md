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

State relative population are calculated as the surface of the corresponding histogram peak normalized by the total histogram surface.

Histogram peaks can be integrated in two ways:
* with [Gaussian fitting](#gaussian-fitting), by activating the option in **(a)**
* with [Thresholds](#thresholding) between histogram peaks, by activating the option in **(b)**

Additionally, the cross-sample variability of state populations can be estimated with the BOBA-FRET method by activating the option in **(c)**.
In that case, the number of replicates to build a bootstrap histogram sample must be set in **(d)** and the number of bootstrap samples in **(e)**.
By default, the number of replicates is set to the number of molecules in the project.

In order to not over-represent short trajectories in the bootstrap histograms, replicates can be given a weight proportional to the length of their time traces.
This is done by activating the option in **(f)**.


---

## Thresholding

Defines settings to calculate state populations with the Thresholding method.

<img src="../../assets/images/gui/HA-panel-state-populations-thresholding.png" style="max-width: 215px;"/>

With the thresholding method, histogram peaks are separated by fixed thresholds, histogram counts are summed up between thresholds and resulting integrals are normalized by the sum of all integrals to obtain the state relative populations as described in the
[State population](../workflow.html#estimate-state-populations-and-associated-cross-sample-variability) section of Histogram analyiss worklfow.

To calculate the relative populations of 
[*J*](){: .math_var } states, a number of 
[*J*-1](){: .math_var } thresholds must be used.
The number of threshold must be set in **(a)**, and each threshold in **(c)** after browsing the list in **(b)**.
Threshold can also be calculated from an inferred model; see 
[Inferred models](panel-state-configuration.html#inferred-models) for more information.

Calculation of state relative populations can be started after setting thresholds and by pressing 
![Start](../../assets/images/gui/HA-but-start.png).
If the 
[Method settings](#method-settings) include BOBA-FRET, histogram bootstrapping and subsequent thresholding will be performed.

<img src="../../assets/images/gui/HA-panel-state-populations-threshold-loadingbar.png" style="max-width:389px;">

After completion, relative population of the histogram peak selected in list **(d)** and corresponding to the color **(g)**, is displayed in **(e)**.
When using BOBA-FRET, the bootstrap mean and standard deviation of the state relative population are respectively displayed in **(e)** and **(f)**.


---

## Gaussian fitting

Defines settings to calculate state populations with the Gaussian fitting method.

<img src="../../assets/images/gui/HA-panel-state-populations-gaussian-fitting.png" style="max-width: 365px;"/>

With the Gaussian fitting method, the histogram is fitted with a mixture of Gaussian functions with each Gaussian defined as:

{: .equation }
<img src="../../assets/images/equations/HA-eq-gaussian.gif" alt="P_{j} = A_{j}\textup{exp}\left [-\frac{(x-\mu_{j})^{2}}{2\sigma_{j}^{2}} \right ]">

with 
[*A*<sub>*j*</sub>](){: .math_var },
[*&#956;*<sub>*j*</sub>](){: .math_var } and 
[*&#963;*<sub>*j*</sub>](){: .math_var } the amplitude, mean and standard deviation of the Gaussian modelling state 
[*j*](){: .math_var }.

After fitting, Gaussian integrals 
[*S*<sub>*j*</sub>](){: .math_var } are analytically calculated and normalized by the sum of all integrals to obtain the state relative populations as described in the
[State population](../workflow.html#estimate-state-populations-and-associated-cross-sample-variability) section of Histogram analyiss worklfow.

To calculate the relative populations of 
[*J*](){: .math_var } states, a number of 
[*J*](){: .math_var } Gaussian functions must be used.
The number of Gaussian functions must be set in **(a)**
Fitting parameters must be defined in **(b)**in **(d-i)** in terms of starting guesses and boundaries, for each Gaussian selected in list **(b)**.

Parameters 
[*A*<sub>*j*</sub>](){: .math_var },
[*&#956;*<sub>*j*</sub>](){: .math_var } and 
[*&#963;*<sub>*j*</sub>](){: .math_var } must be respectively set in rows **(d)**, **(e)** and **(f)**, with the staring guess in column **(h)**, the lower bound in column **(g)** and higher bound in column **(i)**.
Starting guess of fitting parameters can also be imported from an inferred model; see 
[Inferred models](panel-state-configuration.html#inferred-models) for more information.

After setting parameters, Gaussian fitting can be started by pressing 
![Start](../../assets/images/gui/HA-but-start.png).
If the 
[Method settings](#method-settings) include BOBA-FRET, histogram bootstrapping and subsequent Gaussian fitting will be performed.

<img src="../../assets/images/gui/HA-panel-state-populations-gaussian-fitting-loadingbar.png" style="max-width:389px;">

After completion, relative population of the Gaussian selected in list **(b)** and corresponding to the color **(c)**, is displayed in row **(j)** and column **(k)**.
When using BOBA-FRET, the bootstrap mean and standard deviation of the state relative population are respectively displayed in column **(k)** and **(l)**.
Similarly, the bootstrap mean and standard deviation of fit parameters 
[*A*<sub>*j*</sub>](){: .math_var },
[*&#956;*<sub>*j*</sub>](){: .math_var } and 
[*&#963;*<sub>*j*</sub>](){: .math_var } are respectively shown in rows **(d)**, **(e)** and **(f)**.


