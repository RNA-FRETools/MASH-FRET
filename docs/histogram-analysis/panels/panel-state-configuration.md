---
layout: default
title: State configuration
parent: /histogram-analysis/panels.html
grand_parent: /histogram-analysis.html
nav_order: 3
---

# State configuration
{: .no_toc }

<a href="../../assets/images/gui/HA-panel-state-configuration.png"><img src="../../assets/images/gui/HA-panel-state-configuration.png" style="max-width: 166px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Maximum number of Gaussians


---

## Model penalty

Use this interface to set the model overfitting penalty

<img src="../../assets/images/gui/HA-panel-state-configuration-penalty.png" style="max-width: 160px;"/>

The 
[*BIC*](){: .math_var } is similar to a penalized likelihood and is expressed such as:

{: .equation }
*BIC* = *p*( <sub>*J*</sub> ) &#215; log( *N*<sub>total</sub> ) - log[ *likelihood*( *J* ) ]

with 
[*p*<sub>*J*</sub>](){: .math_var } the number of parameters necessary to describe the model with 
[*J*](){: .math_var } components, 
[*N*<sub>total</sub>](){: .math_var } the total number of counts in the TDP.
Here, the most sufficient model has the lowest 
[*BIC*](){: .math_var }.


---

## Inferred models

Use this interface to visualize the different inferred models

<img src="../../assets/images/gui/HA-panel-state-configuration-models.png" style="max-width: 150px;"/>

<img src="../../assets/images/gui/HA-panel-state-configuration-bic.png" style="max-width: 147px;"/>
