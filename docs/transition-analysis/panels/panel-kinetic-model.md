---
layout: default
title: Kinetic model
parent: /transition-analysis/panels.html
grand_parent: /transition-analysis.html
nav_order: 5
---

<img src="../../assets/images/logos/logo-transition-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Kinetic model
{: .no_toc }

Kinetic model is the fourth panel of module Transition analysis.

Use this panel to infer the most probable kinetic model and compare experiment to simulation.

<a class="plain" href="../../assets/images/gui/TA-panel-kinetic-model.png"><img src="../../assets/images/gui/TA-panel-kinetic-model.png" style="max-width:359px;"></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Model inferrence

Use this interface to set the starting conditions of model inference and visualize the inferred model.

<img src="../../assets/images/gui/TA-panel-kinetic-model-settings.png" style="max-width:174px;">

The state configuration used in model inferrence can be determined via two methods listed in **(a)**:
- `Find most sufficient complexity (recommended)`
  [<sup>1</sup>](#references): finds state degeneracy via optimization and BIC-selection of discrete-phase type distributions on dwell time histograms
- `Use "State lifetimes" complexity`: uses the state degeneracy from dwell time histogram fit in panel [State lifetimes](panel-dwelltime-histograms.html#state-lifetimes)

With the first method, a maximum degeneracy (maximum number of degenerated levels for one observed state value) must be defined in **(b)**.

Additionally and in both cases, a number of model initializations must be defined in **(c)** (the larger the more accurate, but also the higher the computation cost).

The kinetic model is then obtain by optimizing transition probabilities for state sequences with the Baum-Welch algorithm as described in Transition analysis
[Workflow](../workflow.html#solve-the-kinetic-model).
After model inferrence, the negative and positive errors 
[&Delta;*p<sub>jj'</sub>*<sup>-</sup>](){: .math_var } and 
[&Delta;*p<sub>jj'</sub>*<sup>+</sup>](){: .math_var } on transition probabilities are automatically estimated via a 95% confidence likelihood ratio test
[<sup>2</sup>](#references), giving an estimated range delimited by the lower bound 
[*p<sub>j,j'</sub>* - &Delta;*p<sub>jj'</sub>*<sup>-</sup>](){: .math_var } and the upper bound 
[*p<sub>j,j'</sub>* + &Delta;*p<sub>jj'</sub>*<sup>+</sup>](){: .math_var }.

&#8618; Press 
![Go!](../../assets/images/gui/TA-but-go.png "Go!") to start model inference and error estimation.
The inferrence time varies from seconds to days depending on (1) the size of the data set, (2) the model complexity (number of states) and (3) the number of model initializations.
Unfortunately, once started the process can not be interrupted in a standard manner.
To stop calculations, Matlab must be forced to close.

Once model inferrence is completed, the most probable kinetic model (maximum likelihood estimator) is show as a treillis diagram in **(d)** and plots in the 
[Visualization area](#visualization-area) are updated.


### References
{: .no_toc }

1. M. Bladt and B.F. Nielsen, *Estimation of Phase-Type Distributions. In: Matrix-Exponential Distributions in Applied Probability.*,  *Probability Theory and Stochastic Modelling* **2017**, DOI: [10.1007/978-1-4939-7049-0_13](https://doi.org/10.1007/978-1-4939-7049-0_13)
2. S. Schmid and T. Hugel, *Efficient use of single molecule time traces to resolve kinetic rates, models and uncertainties*, *J Chem Phys.* **2018**, DOI: [10.1063/1.5006604](https://doi.org/10.1063/1.5006604)

---

## Visualization area

Use this interface to visualize model selection on discrete phase type distibutions and to compare experimental data with simulation from inferred kinetic parameters.

Four plots are presented in four panel tabs:
- [`BIC`](#BIC)
- [`Dwell times`](#dwell-times)
- [`Pop.`](#pop)
- [`Trans.`](#trans)

Any graphics in MASH can be exported to an image file by right-clicking on the axes and selecting `Export graph`.


### BIC

If 
[Model inferrence](#model-inferrence) settings include model selection on discrete phase-type distributions, the BIC values are plotted against the respective model complexities, with the most sufficient complexity plotted in red.

<img src="../../assets/images/gui/TA-panel-kinetic-model-plot-bic.png" style="max-width:166px;">

A degeneracy `121` means that one state has value 1, two states have the same value 2 and one state has value 3.


### Dwell times

Experimental normalized cumulated dwell time histograms of the observed state selected in **(a)** (in blue) is compared to simulation (in red).

<img src="../../assets/images/gui/TA-panel-kinetic-model-plot-cumhist.png" style="max-width:166px;">


### Pop

Experimental populations of observed states (in blue) are compared to simulation (in red).

<img src="../../assets/images/gui/TA-panel-kinetic-model-plot-pop.png" style="max-width:166px;">

State populations are calculated as the sum of corresponding dwell times.


### Trans

Experimental number of transitions between observed states (in blue) are compared to simulation (in red).

<img src="../../assets/images/gui/TA-panel-kinetic-model-plot-trans.png" style="max-width:166px;">


