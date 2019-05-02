---
layout: default
title: Use Trace manager
sub_title: Overview
parent: /trace-processing/functionalities.html
grand_parent: /trace-processing.html
main_nav: /trace-processing/functionalities/use-trace-manager.html
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

{% include tm_head.html %}

<a href="../../assets/images/gui/TP-panel-sample-tm-overview.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview.png"/></a>

## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Overall plot

Use this interface to identify outliers and control the homogeneity of data distributions.

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-overallplot.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-overallplot.png"/></a>

Overall plot shows cumulated data plots for the sample assembled in panel 
[Overview](#overview).
Cumulated data plots must be updated by pressing 
![UPDATE](../../assets/images/gui/TP-but-update-tm.png "UPDATE") after any modifications in the molecule selection.
The final molecule selection can be exported to module Trace processing by pressing 
![TO MASH](../../assets/images/gui/TP-but-to-mash.png "TO MASH").

Concatenated time traces of selected molecules are shown in axes **(c)** and allow to identify outliers. 
For instance, intensity-time traces with abnormally high or low intensities are easily visible and are good candidates for exclusion from the set.
Data available in list **(a)** for concatenated trace plot are:
* intensity-time traces
* FRET-time traces
* Stoichiometry-time traces

Overall data histograms are build with x-axis parameters set in **(e)** (lowest limit), **(f)** (bin size) and **(g)** (highest limit), and are shown in axes **(d)**.
The histogram plot allows and visualize the different sub-populations in the sample and to control the homogeneity of data distribution.
For instance, the presence of single labelled species is easily identified on the overall stoichiometry histogram and indicates the need for further sample refinement.
Data available in list **(b)** for histogram plot are:
* intensities histograms
* FRET histograms
* Stoichiometry histograms
* E-S histograms

Any graphics in MASH can be exported to an image file by left-clicking on the axes and selecting `Export graph`.

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-overallplot-warn.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-overallplot-warn.png" style="max-width:479px"></a>


---

## Molecule selection

Use this interface to exclude outliers and assemble sub-groups.

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection.png"/></a>

Overview shows individual single molecule data plots that can be browsed using the sliding bar in **(n)**. 
The interface can be optimized by adjusting in **(f)** the number of molecules per page, and by hiding the panel 
[Overall plot](#overall-plot) when pressing 
![\^](../../assets/images/gui/TP-but-triangle.png "^") in **(g)**.

Single molecule intensity-time traces and histograms are respectively shown in axes **(j)** and **(k)**, whereas FRET- and stoichiometry-time traces and histograms are respectively shown in axes **(l)** and **(m)**. 

Individual single molecule data are inspected one to define their status in the sample, which includes:
* sample exclusion/inclusion, set in **(i)**
* subgroup affiliation, set in **(h)**
For instance, single molecules with incoherent intensity-time traces will be excluded from the sample and static FRET traces will be sorted into a "static" subgroup. 

To help with sample selection, all molecules can be selected/unselected at once using the box in **(a)**, and the current selection can be inverted by pressing 
![Invert Selection](../../assets/images/gui/TP-but-invert-selection.png "Invert Selection").

For more complex sorting, customed group labels can be created in **(c)**. 
Labels can be deleted any time by selecting in the list **(d)** and pressing 
![delete tag](../../assets/images/gui/TP-but-delete-tag.png "delete tag").

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection-warn1.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection-warn1.png" style="max-width:409px"></a>

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection-warn2.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection-warn2.png" style="max-width:489px"></a>
