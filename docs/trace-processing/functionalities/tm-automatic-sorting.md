---
layout: default
title: Use Trace manager
sub_title: Automatic sorting
parent: /trace-processing/functionalities.html
grand_parent: /trace-processing.html
main_nav: /trace-processing/functionalities/tm-overview.html
nav_order: 3
subnav_order: 2
nav_exclude: true
toc_exclude: true
---

# Use Trace manager
{: .no_toc }

The trace manager allows to visualize data of all single molecules in the project, and is used to sort molecules into sub-groups and/or exclude irrelevant traces from the set.
Trace manager is accessed by pressing 
![TM](../../assets/images/gui/TP-but-tm.png "TM") in the 
[Sample management](../panels/panel-sample-management.html#trace-manager) panel of module Trace processing.

---

{% include tm_head.html %}

Automatic sorting is used to tag groups of molecules based on specific data criteria.

## Interface components
{: .no_toc .text-delta }

1. TOC
{:toc}

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting.png"/></a>


---

## Data and histogram

Use this interface to define the data to be sorted and displayed.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting-histogram.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting-histogram.png"/></a>

Data available for sorting are listed in menu **(a)** and include:
* `[E] at [W]nm` for intensity data, with `[E]` the emitter-specific detection channel label and `[W]` the laser wavelength
* `FRET [D]>[A]` for FRET data, with `[D]` and `[A]` the labels of donor- and acceptor-specific detection channels respectively
* `S [E]` for stoichiometry data 
* `FRET [D]>[A]-S [E]` for 2D FRET-Stoichiometry data 

Molecule sorting can be performed on full-length data-time traces or state trajectories, but also on different descriptive statistical values.
The type of data sets can be selected in menu **(b)** and include:
* `original time traces` for individual full-length data-time traces
* `means` for the mean values in individual data-time traces
* `minima` for the maximum values in individual data-time traces
* `maxima` for the minimum values in individual data-time traces
* `medians` for the median values in individual data-time traces
* `state trajectories` for individual full-length data state trajectories

To use the option `state trajectories`, all the molecules of the selection must have the corresponding data-time trace discretized.
If some state trajectories are missing, a data-customed warning pops up.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting-warn1.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting-warn1.png" style="max-width:443px;"/></a>

To represent the sample assembled with tool 
[Overview](tm-overview.html), an overall 1D- or 2D-data histogram is plotted in 
[Histogram plot](#histogram-plot) with x- and y-axis defined by their respective lower bounds set in **(c)** and **(f)**, bin sizes set in **(d)** and **(g)**, and higher limit set in **(e)** and **(h)**.

The building of 2D histograms uses the MATLAB script `hist2` developed by Tudor Dima that can be found in the 
[MATLAB exchange platform](https://www.mathworks.com/matlabcentral/fileexchange/18386-2d-histogram-exact-and-fast-binning-crop-and-stretch-grid-adjustment?s_tid=prof_contriblnk).


---

## Data range

Use this interface to define the sorting criteria.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting-range.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting-range.png" style="max-width:182px;"/></a>

Individual molecule data are sorted according to a specific value range.
The range is defined by a minimum value set in **(a)** or **(c)** and a maximum value set in **(b)** or **(d)**  for the x- or y-axis respectively.
The range is represented on the
[Histogram plot](#histogram-plot) with out-of-ranges values being covered by a transparent black mask.
Range bounds can also be defined by simply clicking on the 
[Histogram plot](#histogram-plot).

If molecule data are `original time traces` or `state trajectories`, the confidence level for inclusion in the range must be defined.
The confidence level can be set as:
- `at least` with the minimum confidence level set in **(f)**
- `at most` with the maximum confidence level set in **(f)**
- `between` with the minimum and maximum confidence levels set in **(f)** and **(g)** respectively

The confidence levels in **(f)** and **(g)** can be expressed in trace percentage or in number of data points per trace by selecting the respective options `percents of the trace` or `data points` in menu **(h)**.

The resulting number of molecule included in the current range is displayed in **(i)**.

To define a subgroup affiliation for the molecules included in the current range, settings must be saved by pressing 
![Save subgroup](../../assets/images/gui/TP-but-save-subgroup.png "Save subgroup"). 
Additionally, when saved, range settings can be accessed any time in 
[Molecule subgroups](#molecule-subgroups).


---

## Molecule subgroups

Use this interface to define subgroup affiliations.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting-subgroup.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting-subgroup.png" style="max-width:182px;"/></a>

Ranges saved in 
[Data range](#data-range) are listed in **(a)** and can be dismissed by pressing
![Dismiss subgroup](../../assets/images/gui/TP-but-dismiss-subgroup.png "Dismiss subgroup").

To define a subgroup affiliation for the molecules included in the range selected in list **(a)**, choose a subgroup tag in menu **(b)** and press 
![Tag](../../assets/images/gui/TP-but-tag.png "Tag").
All tags assigned to the selected range are listed in **(c)** and can be removed one by one by pressing 
![Untag](../../assets/images/gui/TP-but-untag.png "Untag").

Molecule tags are eventually applied to individual molecules after pressing 
![APPLY TAG TO MOLECULES](../../assets/images/gui/TP-but-apply-tag-to-molecules.png "APPLY TAG TO MOLECULES"); as the operation can not be reversed, a confirmation warning pops up.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting-warn2.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting-warn2.png" style="max-width:471px;"/></a>


---

## Histogram plot

Use this interface to visualize the data distribution and defined sorting criteria by clicking.

Data is distributed into a 1D- or 2D-histogram built with settings defined in 
[Data and histogram](#data-and-histogram).
Ranges defined in 
[Data range](#data-range) or defined by clicking on the plot, are highlighted in white for 1D-histograms and within a gray rectangle for 2D-histograms.
Out-of-range data covered with a transparent black mask.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting-plot1D.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting-plot1D.png" style="max-width:45%;"/></a>
<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting-plot2D.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting-plot2D.png" style="max-width:45%;"/></a>



---

## Concatenated trace plot

Use this interface to visualize the time-traces affiliated to the current molecule subgroup.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-autosorting-concatenatedtrace.png"><img src="../../assets/images/gui/TP-panel-sample-tm-autosorting-concatenatedtrace.png"/></a>

The concatenated trace plot shows time-traces of the molecule selection at last update in panel
[Overall plots](tm-overview.html#overall-plots).
Concatenated trace plot allows to visualize which time traces are included or excluded from the current subgroup.
Included time traces are highlighted with a white background and excluded time traces are covered with a transparent black mask.

Data available for concatenated trace plot are listed in menu **(a)** and include:
* `[E] at [W]nm` for intensity-time traces, with `[E]` the emitter-specific detection channel label and `[W]` the laser wavelength
* `FRET [D]>[A]` for FRET-time traces, with `[D]` and `[A]` the labels of donor- and acceptor-specific detection channels respectively
* `S [E]` for stoichiometry-time traces
