---
layout: default
title: State configuration
parent: Components
grand_parent: Histogram analysis
nav_order: 3
---

<img src="../../assets/images/logos/logo-histogram-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# State configuration
{: .no_toc }

State configuration is the second panel of module Histograms analysis. 
Access the panel content by pressing 
![Bottom arrow](../../assets/images/gui/interface-but-bottomarrow.png). 
The panel closes automatically after other panels open or after pressing 
![Top arrow](../../assets/images/gui/interface-but-toparrow.png). 

Use this panel to determine the optimum number of histogram peaks.

<a class="plain" href="../../assets/images/gui/HA-panel-state-configuration.png"><img src="../../assets/images/gui/HA-panel-state-configuration.png" style="max-width: 365px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Maximum number of Gaussians

Defines the maximum model complexity to consider for model fitting, *i.e.*, the maximum number of Gaussian in the Gaussian mixture models to infer; see 
[Determine the most sufficient state configuration](../workflow.html#determine-the-most-sufficient-state-configuration) in Histogram analysis worklow for more information about state configuration analysis.

The maximum number of Gaussian in the model is the only parameter necessary to infer models.

Press 
![Start analysis](../../assets/images/gui/HA-but-start-analysis.png) to start model inference.

<u>default</u>: 10


---

## Model penalty

Use this interface to define model overfitting penalty.

<a class="plain" href="../../assets/images/gui/HA-panel-state-configuration-penalty.png"><img src="../../assets/images/gui/HA-panel-state-configuration-penalty.png" style="max-width: 344px;"/></a>

The goodness of the gaussian mixture fit is evaluated by the likelihood of the model. 
The likelihood can be calculated in two manners listed in **(a)**:

* `complete data` where each bin is associated to one and only Gaussian,
* `incomplete data` where bins have a non-null probability to belong to each Gaussian (subject to overestimation of model complexity).'

In both cases, the likelihood inevitably increases with the fit model compexity. 
To prevent overfitting, the likelihood can be penalized in two ways:

* [Minimum improvement in likelihood](#minimum-improvement-in-likelihood), by activating the option in **(b)** 
* [Bayesian information criterion](#bayesian-information-criterion) (BIC), by activating the option in **(c)**

The overfitting penalty can be modified before or after inferring the different models, *i.e.*, before or after pressing 
![Start analysis](../../assets/images/gui/HA-but-start-analysis.png).


### Minimum improvement in likelihood
{: .no_toc }

With this penalty, a certain improvement in the model <u>log</u>-likelihood is expected when adding a new component to the model. 
The improvement is expressed as a multiplication factor that can be set in **(d)**.
For instance, set a penalty of 1.2 for an improvement of 20% in the <u>log</u>-likelihood, or of 10<sup>0.2</sup> in the likelihood.

The most sufficient model is the least complex model for which adding a component does not fulfill this requirement.


### Bayesian information criterion
{: .no_toc }

The BIC is used to rank models according to their sufficiency, with the most sufficient model having the lowest 
[*BIC*](){: .math_var }.

The 
[*BIC*](){: .math_var } is similar to a penalized likelihood and it is expressed such as:

{: .equation }
<img src="../../assets/images/equations/HA-eq-bic.gif" alt="BIC\left (V \right ) = p\left (V \right ) \times \log ( M_{\textup{total}} ) - 2 \times \log \left [ likelihood\left (V \right ) \right ]">

with 
[*p*](){: .math_var } the number of parameters necessary to describe the model with 
[*V*](){: .math_var } components and
[*M*<sub>total</sub>](){: .math_var } the total number of counts in the histogram.

The number of parameters necessary to describe the model includes the number of Gaussian means 
[*p*<sub>means</sub>](){: .math_var }, standard deviations 
[*p*<sub>widths</sub>](){: .math_var } and relative weights 
[*p*<sub>weights</sub>](){: .math_var }, and is calculated such as:

{: .equation }
<img src="../../assets/images/equations/HA-eq-bic-02.gif" alt="p\left ( V\right ) = p_{\textup{means}} + p_{\textup{widths}} + p_{\textup{weights}} = 3V - 1">


---

## Inferred models

Use this interface to visualize the results of state configuration analysis.

<a class="plain" href="../../assets/images/gui/HA-panel-state-configuration-penalty.png"><img src="../../assets/images/gui/HA-panel-state-configuration-models.png" style="max-width: 344px;"/></a>

The number of components in the most sufficient model according to the 
[Model penalty](#model-penalty) is shown in **(a)** and the corresponding gaussian mixture can be visualized in the 
[Top axes](area-visualization.html#inferred-state-configuration).

Other inferred models can be visualized by selecting the corresponding number of components in the list **(b)**. 
In this case, the log-likelihood and BIC of the selected model are respectively displayed in **(c)** and **(d)**.

The parameters of any model can be imported in 
[Thresholding](panel-state-populations#thresholding) or 
[Gaussian fitting](panel-state-populations#gaussian-fitting) as starting guess for state population analysis, by pressing 
![>>](../../assets/images/gui/HA-but-supsup.png ">>").

