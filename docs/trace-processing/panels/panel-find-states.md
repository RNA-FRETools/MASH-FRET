---
layout: default
title: Find states
parent: /trace-processing/panels.html
grand_parent: /trace-processing.html
nav_order: 9
---

# Find states
{: .no_toc }

<a href="../../assets/images/gui/TP-panel-findstates.png"><img src="../../assets/images/gui/TP-panel-findstates.png"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Discretization method

Use this list to select the state finding algorithm to apply to traces selected in 
[Data to discretize](#data-to-discretize).

The list contains five different algorithms:
* [Thresholds](#thresholds)
* [vbFRET](#vbfret) [<sup>1</sup>](#references)
* [One state](#one-state)
* [CPA](#cpa) [<sup>2</sup>](#references)
* [STaSI](#stasi) [<sup>3</sup>](#references)

Each method requires parameters in 
[Method parameters](#method-parameters) to be set as described in the corresponding section.

The MATLAB scripts for method `vbFRET` was  downloaded from 
[vbFRET sourceforge](http://vbfret.sourceforge.net/) page.
The MATLAB scripts for method `STaSI` was downloaded from 
[LandesLab](https://github.com/LandesLab/STaSI) Github repository.


### Thresholds
{: .no_toc }

The threshold method does not make any assumption about the nature of FRET transitions or noise in the time trace.
The number and values of states to be found in the time trace are predefined and for each state is assigned a lower and a higher threshold.

It analyzes data points in the time trace one by one starting with the first point. 
The first data point of the time trace is assigned to the state having a lower threshold being inferior to the data point and being the closest in value to the data point.
A transition to another state is detected when the next data point goes beyond the lower of higher threshold of the current state.
The operation is repeated until every point in the time trace is assigned to a state.

The threshold method is fast and efficient for well-separated states but is not recommended to use for overlapping populations.
More representative results are obtained when the threshold method is combined with post-processing methods 
[State refinement](#state-refinement) and 
[Adjust states to data](#adjust-states-to-data).


### vbFRET
{: .no_toc }

The vbFRET 
[<sup>1</sup>](#references) method models time traces as Markov chains, *i.e.*, with exponentially distributed dwell-times, hidden in Gaussian noise. 
The method iteratively infers state trajectories determines the optimum state configuration in the trajectory by maximizing the evidence.

If the noise distribution in the time trace deviates from a Gaussian distribution, recurrent low-amplitude transition to blurr states might occurs. 
This artefact can be corrected by using the post processing method 
[State binning](#state-binning).


### One state
{: .no_toc }

The One state method is meant only for use on static time traces to save computation time.
It assumes no FRET transitions and considers the noise to be symmetrically distributed in the time trace.

The One state method averages the whole time trace into one state.


### CPA
{: .no_toc }

The change-point analysis (CPA) 
[<sup>2</sup>](#references) method does not make any assumption about the kinetic nature of FRET transitions, but considers the noise to be uniformly distributed in the time trace.
The method uses the uniform noise distribution in each state to detect state transitions, or change points.

The maximum amplitude jump induced by the noise in the time trace is first estimated by shuffling data points in the time trace to build a certain number of bootstrap samples, and record the maximum jump amplitude in each sample.
If the maximum jump amplitude found in the initial time trace is higher than for the samples with a certain confidence level, it is detected as a change point.
The exact change point can be assigned to the position where the maximum amplitude jump finishes, or at the point where the sum of root-mean squares before and after the change point is minimum.

More representative results are obtained when the CPA method is combined with post-processing methods 
[State refinement](#state-refinement) and 
[State binning](#state-binning).


### STaSI
{: .no_toc }

The STaSI 
[<sup>3</sup>](#references) method does not make any assumption about the nature of FRET transitions, but considers the noise to be uniformly distributed in the time trace. 
The method uses the uniform noise distribution in each state to detect state transitions with the Student's t-test and groups the resulting segments into the state configuration that minimizes the minimum description length.


### References
{: .no_toc }

1. J.E. Bronson, J. Fei, J.M. Hofman, R.L. Gonzalez Jr., C.H. Wiggins, *Learning Rates and States from Biophysical Time Series: A Bayesian Approach to Model Selection and Single-Molecule FRET Data*, *Biophysical J.* **2009**, DOI: [10.1016/j.bpj.2009.09.031](https://doi.org/10.1016/j.bpj.2009.09.031)
1. W.A. Taylor, *Change-Point Analysis: A Powerful New Tool For Detecting Changes*, *Taylor enterprises* **2000**, web: [https://variation.com/change-point-analysis-a-powerful-new-tool-for-detecting-changes](https://variation.com/change-point-analysis-a-powerful-new-tool-for-detecting-changes/)
1. B. Shuang, D. Cooper, J.N. Taylor, L. Kisley, J. Chen, W. Wang, C.B. Li, T. Komatsuzaki, C.F. Landes, *Fast Step Transition and State Identification (STaSI) for Discrete Single-Molecule Data Analysis*, *J. Phys. Chem. Lett.* **2014**, DOI: [10.1021/jz501435p](https://dx.doi.org/10.1021%2Fjz501435p)


---

## Data to discretize

Use this list to select the data to discretize and the way discretization is calculated.

Three discretization mode are available:
* `bottom` to infer state trajectories in FRET- and stoichiometry-time traces only
* `top` to infer state trajectories in intensity-time traces and deduce from shared transitions the state trajectories in FRET- and stoichiometry-time traces
* `all` to infer state trajectories in all time traces

In the case of a `top` discretization mode, the post-processing method
[Find shared transitions](#find-shared-transitions) is applied to intensity state trajectories.


---

## Method parameters

Defines the settings used to discretize the selected trajectory.

<a href="../../assets/images/gui/TP-panel-findstates-param.png"><img src="../../assets/images/gui/TP-panel-findstates-param.png" style="max-width: 289px;"/></a>

Parametrization of the method selected in 
[Discretization method](#discretization-method) must be specifically set for each time-trace.
Time traces are be selected in list **(a)** prior setting parameters **(b-h)** as described in the table below.

| method                                         | parametrization                                                                                                                                                                                                     | default parameters                |
| ---------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------- |
| `Threshold`                                    | **(b)**: maximum number of states, **(e)**: state selection, **(f)**: state's lower threshold, **(g)**: state's value, **(h)**: state's higher threshold                                                            | **(f)**=3, **(g)**=3, **(h)**=3   |
| `vbFRET` [<sup>1</sup>](#references)           | **(b)**: minimum number of states , **(c)**: maximum number of states, **(d)**: number of process iterations                                                                                                        | **(b)**=1, **(c)**=2, **(d)**=5   |
| `One state`                                    | no parameter to be set                                                                                                                                                                                              |                                   |
| `CPA` [<sup>2</sup>](#references)              | **(b)**: number of bootstrap samples, **(c)**: confidence level to identify a transition (%), **(d)**: change point localization by (1) maximum jump amplitude, or (2) minimum RMSE before and after change point   | **(b)**=50, **(c)**=90, **(d)**=2 |
| `STaSI` [<sup>3</sup>](#references)            | **(b)**: maximum number of states                                                                                                                                                                                   | **(b)**=2                         |


---

## Post-processing methods

Defines parameters to process states trajectories.

<a href="../../assets/images/gui/TP-panel-findstates-postparam.png"><img src="../../assets/images/gui/TP-panel-findstates-postparam.png" style="max-width: 158px;"/></a>

Post-processing methods are algorithms that applies to state trajectories inferred by discretization methods. 
Four post-processing methods are available, following the post-processing order:
* [State binning](#state-binning)
* [State refinement](#state-refinement)
* [Adjust states to data](#adjust-states-to-data)
* [Find shared transitions](#find-shared-transitions)


### State binning
{: .no_toc }

The state binning method bins segments in the state trajectories with a bin size set in **(c)**.

This method is useful in case small amplitude jumps to blur states are occurring in state trajectories.


### State refinement
{: .no_toc }

The refinement method corrects state assignment without modifying the values. 
Each segment is reassigned to the state having the closest value to the average data behind the segment.
The state refinement method is an iterative process with each iteration refining the new state trajectory.
The number of refinement iterations in set in **(b)**.

This method is useful to correct state trajectories from noise-induced transitions.


### Adjust states to data
{: .no_toc }

Adjusting states to data consists in recalculating states without modifying state transitions.
States are recalculated as the average data behind each segment of the state trajectory.

This method is useful to obtain more representative states when using predefined levels, *e. g.* with the Threshold method.


### Find shared transitions
{: .no_toc }

Finding shared transitions is used after each `top` discretization, in order to build FRET- and stoichiometry- state trajectories from intensity state trajectories; see 
[Data to discretize](#data-to-discretize) for more details.
For FRET transitions, the algorithm looks for transitions detected in donor and acceptor state trajectories that occurs less than a certain number of frame away.
For stoichiometry transitions, intensity state trajectories are first summed over all channels and (1) over the emitter's specific excitation, and (2) over all laser illumination, prior looking for shared transitions.

The maximum frame gap between donor and acceptor transitions or emitter's sum and overall sum transitions, is set in **(a)** for FRET or stoichiometry data respectively.


---

## Found states

Shows states found in selected trajectory.

<a href="../../assets/images/gui/TP-panel-findstates-results.png"><img src="../../assets/images/gui/TP-panel-findstates-results.png" style="max-width: 217px;"/></a>

The values of states found after discretizattion and post processing can be displayed in **(b)** after selecting the state index in list **(a)**.


---

## Apply settings to all molecules

Use this command to apply the 
[Discretization method](#discretization-method), 
[Method parameters](#method-parameters) to all molecules.

Corrections are applied to other molecules only when the corresponding data is processed, *i.e.*, when pressing 
![UPDATE ALL](../../assets/images/gui/TP-but-update-all.png "UPDATE ALL"); see 
[Process all molecules data](panel-sample-management.html#process-all-molecules-data) for more information.


