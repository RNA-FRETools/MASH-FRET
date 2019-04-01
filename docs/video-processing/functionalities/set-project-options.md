---
layout: default
title: Set project options
parent: /video-processing/functionalities.html
grand_parent: /video-processing.html
nav_order: 1
---

# Set project options
{: .no_toc }

Project options are specific to each project and include emitter-laser relations, FRET and stoichiometry calculations, but also labels and colors used to present data.

They are initially set in module Video processing by pressing 
![Options...](../../assets/images/gui/VP-but-options3p.png "Options...") in panel 
[Experiment settings](../panels/panel-experiment-settings.html) and can be edited in module Trace processing by pressing 
![Edit ...](../../assets/images/gui/TP-but-edit-3p.png "Edit ...") in the 
[Project management area](.././trace-processing/panels/area-project-management.html) .

<a href="../../assets/images/gui/VP-panel-expset-opt.png"><img src="../../assets/images/gui/VP-panel-expset-opt.png" style="max-width: 546px;"/></a>


## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Project parameters

They concern the project title and some optional parameters.

<a href="../../assets/images/gui/VP-panel-expset-opt-projprm.png"><img src="../../assets/images/gui/VP-panel-expset-opt-projprm.png" style="max-width: 250px;"/></a>

The project title is the name appearing in the project lists. 
It can be modified in **(a)**.
Default titles are named after the
[MASH project file](../../output-files/mash-mash-project.html) or by the directory containing imported ASCII trajectories.

Optional project parameters include the name of the molecule under study, set in **(b)**, and a group of experimental parameters, set in **(c)**.
By default, the group in **(c)** contains parameters:
* `[Mg2+]`: milimolar (`mM`) concentration of Magnesium,
* `[K+] `: milimolar (`mM`) concentration of Potassium,
* `Power(xxxnm)`: power in `mW` of laser with wavelength xxxnm

The user can add personal parameters to the default group.
To do so, the parameter name (here: `buffer n°`) and units (here: empty) must be set in **(e)** and **(f)** respectively, prior pressing 
![Add](../../assets/images/gui/VP-but-add.png "Add").
All user-defined parameters are listed in **(d)** and can be removed by pressing 
![Remove](../../assets/images/gui/VP-but-remove.png "Remove"). 

For the moment, optional parameters solely act as project "tags" saved with the 
[MASH project file](../../output-files/mash-mash-project.html) and exported in
[Processing parameter files](../../output-files/log-processing-parameters.html).


---

## Video channels

They are the channel labels and excitation selectivity.

<a href="../../assets/images/gui/VP-panel-expset-opt-channels.png"><img src="../../assets/images/gui/VP-panel-expset-opt-channels.png" style="max-width: 250px;"/></a>

Channel labels are used to easily identify calculated and plotted data. 
Usually, the channel is labelled after the emitter from which photons are collected (ex: `Cy5`).

Emitters are usually excited by one particular laser. 
Knowing the excitation selectivity is necessary for FRET and stoichiometry calculations.

Channel label and excitation wavelength are set by first selecting the channel index in list **(a)** and then selecting the desired label and excitation wavelength in list **(b)** and **(c)** respectively.
Channel indexes correspond to the order of appearance in the video from left to right.

The user can add personal labels to the list **(b)** by writing the new label name in **(e)** and pressing 
![Add](../../assets/images/gui/VP-but-add.png "Add"). 
Labels can be removed from the list any time by pressing 
![Remove](../../assets/images/gui/VP-but-remove.png "Remove").

---

## FRET calculations

They are the possible energy transfer occurring between the detected emitters.

<a href="../../assets/images/gui/VP-panel-expset-opt-fret.png"><img src="../../assets/images/gui/VP-panel-expset-opt-fret.png" style="max-width: 250px;"/></a>

To define a donor-acceptor pair in the FRET network, respective labels must be selected in list **(a)** and **(b)** prior pressing 
![Add](../../assets/images/gui/VP-but-add.png "Add").
All transfers included in the network are listed in list **(c)** and can be removed any time by pressing 
![Remove](../../assets/images/gui/VP-but-remove.png "Remove").

In a FRET network composed of 
<span style="font-family: Times;"><i>K</i></span> 
emitters and where emitters are indexed according to the red-shift of their emission spectra (1 for the most blue-shifted and K for the most red-shifted), the apparent FRET value 
<span style="font-family: Times;">*E\**<sub>*D*,*A*</sub></span> 
of a pair donor-acceptor with respective indexes 
<span style="font-family: Times;">*D*</span> 
and 
<span style="font-family: Times;">*A*</span> 
is calculated as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<pre style="font-family: Times; border-radius: 5px;">
<i>E*</i><sub><i>D</i>,<i>A</i></sub> = <i>I</i><sub><i>A</i></sub><sup><i>D</i></sup> / { [ 1 - &#931;<sub><i>A</i>><i>k</i>&#8805;<i>K</i></sub>( <i>E*</i><sub><i>A</i>,<i>k</i></sub> ) ] &#215; &#931;<sub><i>D</i>&#8805;<i>k</i>&#8805;<i>K</i></sub>( <i>I</i><sub><i>k</i></sub><sup><i>D</i></sup> ) }<br>
                          - &#931;<sub><i>D</i>><i>k</i>><i>A</i></sub>{ <i>E*</i><sub><i>D</i>,<i>k</i></sub> &#215; &#928;<sub><i>k</i>><i>k'</i>&#8805;<i>A</i></sub>[ <i>E*</i><sub><i>k</i>,<i>k'</i></sub> &#215; &#928;<sub><i>k'</i>><i>k''</i>&#8805;<i>A</i></sub>( <i>E*</i><sub><i>k'</i>,<i>k''</i></sub> ) ] }
</pre>

with 
<span style="font-family: Times;">*I*<sub>*k*</sub><sup>*k'*</sup></span> 
the intensity collected in detection channel of emitter 
<span style="font-family: Times;">*k*</span> 
upon illumination specific to emitter 
<span style="font-family: Times;">*k'*</span>.

As the expression of 
<span style="font-family: Times;">*E\**<sub>*D*,*A*</sub></span> 
depends on other unknown apparent FRET values 
<span style="font-family: Times;">*E\**<sub>*A*,*k*</sub></span>, 
<span style="font-family: Times;">*E\**<sub>*D*,*k*</sub></span>, 
<span style="font-family: Times;">*E\**<sub>*k*,*k'*</sub></span> 
and 
<span style="font-family: Times;">*E\**<sub>*k*',*k''*</sub></span>, 
the equation is first solved for the most red-shifted donor, *i.e.*, for the pair 
(<span style="font-family: Times;">*D* = *K-1*</span>, 
<span style="font-family: Times;">*A* = *K*</span>).

In this case, the expression is simplified to a simple 2-color apparent FRET equation such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<pre style="font-family: Times; border-radius: 5px;">
<i>E*</i><sub><i>K</i>-1,<i>K</i></sub> = <i>I</i><sub><i>K</i></sub><sup><i>K</i>-1</sup> / &#931;<sub><i>K</i>-1&#8805;<i>k</i>&#8805;<i>K</i></sub>( <i>I</i><sub><i>k</i></sub><sup><i>K</i>-1</sup> )
</pre>

giving:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<pre style="font-family: Times; border-radius: 5px;">
<i>E*</i><sub><i>K</i>-1,<i>K</i></sub> = <i>I</i><sub><i>K</i></sub><sup><i>K</i>-1</sup> / ( <i>I</i><sub><i>K</i></sub><sup><i>K</i>-1</sup> + <i>I</i><sub><i>K</i>-1</sub><sup><i>K</i>-1</sup> )
</pre>

where 
<span style="font-family: Times;">*E\**<sub>*K*-1,*K*</sub></span> 
depends only on acquired intensity-time traces and thus, can be readily calculated.

Calculated 
<span style="font-family: Times;">*E\**<sub>*K*-1,*K*</sub></span> 
can then be used to solve the equation for the next most red-shifted donor, *i.e.*, for pairs 
(<span style="font-family: Times;">*D* = *K*-2</span>, 
<span style="font-family: Times;">*A* = *K*-1</span>) 
and 
(<span style="font-family: Times;">*D* = *K*-2</span>, 
<span style="font-family: Times;">*A* = *K*</span>).

In this case, the expression is simplified to a 3-color apparent FRET equation system such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<pre style="font-family: Times; border-radius: 5px;">
<i>E*</i><sub><i>K</i>-2,<i>K</i>-1</sub> = <i>I</i><sub><i>K</i>-1</sub><sup><i>K</i>-2</sup> / { [ 1 - &#931;<sub><i>K</i>-1><i>k</i>&#8805;<i>K</i></sub>( <i>E*</i><sub><i>K</i>-1,<i>k</i></sub> ) ] &#215; &#931;<sub><i>K</i>-2&#8805;<i>k</i>&#8805;<i>K</i></sub>( <i>I</i><sub><i>k</i></sub><sup><i>K</i>-2</sup> ) }<br>
<i>E*</i><sub><i>K</i>-2,<i>K</i></sub> = <i>I</i><sub><i>K</i></sub><sup><i>K</i>-2</sup> / &#931;<sub><i>K</i>-2&#8805;<i>k</i>&#8805;<i>K</i></sub>( <i>I</i><sub><i>k</i></sub><sup><i>K</i>-2</sup> ) - &#931;<sub><i>K</i>-2><i>k</i>><i>K</i></sub>[ <i>E*</i><sub><i>K</i>-2,<i>k</i></sub> &#215; &#928;<sub><i>k</i>><i>k'</i>&#8805;<i>K</i></sub>( <i>E*</i><sub><i>k</i>,<i>k'</i></sub> ) ]
</pre>

giving:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<pre style="font-family: Times; border-radius: 5px;">
<i>E*</i><sub><i>K</i>-2,<i>K</i>-1</sub> = <i>I</i><sub><i>K</i>-1</sub><sup><i>K</i>-2</sup> / ( 1 - <i>E</i><sub><i>K</i>-1,<i>K</i></sub> ) &#215; ( <i>I</i><sub><i>K</i></sub><sup><i>K</i>-2</sup> + <i>I</i><sub><i>K</i>-1</sub><sup><i>K</i>-2</sup> + <i>I</i><sub><i>K</i>-2</sub><sup><i>K</i>-2</sup> )<br>
<i>E*</i><sub><i>K</i>-2,<i>K</i></sub> = <i>I</i><sub><i>K</i></sub><sup><i>K</i>-2</sup> / ( <i>I</i><sub><i>K</i></sub><sup><i>K</i>-2</sup> + <i>I</i><sub><i>K</i>-1</sub><sup><i>K</i>-2</sup> + <i>I</i><sub><i>K</i>-2</sub><sup><i>K</i>-2</sup> ) - <i>E</i><sub><i>K</i>-2,<i>K</i>-1</sub> &#215; <i>E</i><sub><i>K</i>-1,<i>K</i></sub> 
</pre>

where 
<span style="font-family: Times;">*E\**<sub>*K*-2,*K*-1</sub></span> 
depends on acquired intensity-time traces and the previously calculated 
<span style="font-family: Times;">*E\**<sub>*K*-1,*K*</sub></span>.

Calculated 
<span style="font-family: Times;">*E\**<sub>*K*-2,*K*-1</sub></span> 
and 
<span style="font-family: Times;">*E\**<sub>*K*-2,*K*</sub></span> 
can then be used to solve the equation for the next most red-shifted donor and so on ...

To know more about how multi-color apparent FRET data are calculated, please refer to the respective functions in the source code:

```
MASH-FRET/buildFretexpr.m
MASH-FRET/source/traces/processing/FRET/calcFRET.m
```

---

## Stoichiometry calculations

They are the desired emitter stoichiometries to be calculated and plotted.

<a href="../../assets/images/gui/VP-panel-expset-opt-s.png"><img src="../../assets/images/gui/VP-panel-expset-opt-s.png" style="max-width: 250px;"/></a>

The stoichiometry of an emitter is usually used to estimate the ratio of different emitters on the single molecule under observation.

The stoichiometry 
<span style="font-family: Times;">*S*<sub>*em*0</sub></span> 
of an emitter specifically detected in channel 
<span style="font-family: Times;">*em*<sub>0</sub></span> 
and specifically excited by illumination 
<span style="font-family: Times;">*ex*<sub>0</sub></span> 
is calculated as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>S</i><sub><i>em</i>0</sub> = &#931;<i><sub>em</sub></i>( <i>I</i><sub><i>em</i></sub><sup><i>ex</i>0</sup> ) / &#931;<i><sub>em</sub></i>[ &#931;<sub><i>ex</i></sub>( <i>I</i><sub><i>em</i></sub><sup><i>ex</i></sup> ) ]
</p>

with 
<span style="font-family: Times;">*I*<sub>*em*</sub><sup>*ex*</sup></span> 
the intensity collected in channel 
<span style="font-family: Times;">*em*</span> 
and upon illumination 
<span style="font-family: Times;">*ex*</span>.

A stoichiometry 
<span style="font-family: Times;">*S*<sub>*em*0</sub></span> = 0.5 means that 50% of the total number of collected photons belongs to the emitter specifically detected in channel 
<span style="font-family: Times;">*em*<sub>0</sub></span> 
and specifically excited by illumination 
<span style="font-family: Times;">*ex*<sub>0</sub></span>.

To activate the calculation of an emitter stoichiometry, the corresponding channel label must be selected in **(a)** prior pressing 
![Add](../../assets/images/gui/VP-but-add.png "Add").
All desired stoichiometry calculations are listed in **(b)** and can be removed any time by pressing 
![Remove](../../assets/images/gui/VP-but-remove.png "Remove").

---

## Color code

They are the colors used to identify calculated and plotted traces

<a href="../../assets/images/gui/VP-panel-expset-opt-colors.png"><img src="../../assets/images/gui/VP-panel-expset-opt-colors.png" style="max-width: 250px;"/></a>

To set the RGB color of a specific trace, select the data in list **(a)** and set the red, green and blue values in **(b)**, **(c)** and **(d)** respectively.
Red, green and blue takes values between 0 and 1.

The resulting color is displayed in **(e)** and can be exported to list **(a)** by pressing 
![update](../../assets/images/gui/VP-but-update.png "update").

