---
layout: default
title: Use Trace manager
sub_title: Overview
parent: /trace-processing/functionalities.html
grand_parent: /trace-processing.html
main_nav: /trace-processing/functionalities/tm-overview.html
nav_order: 3
subnav_order: 1
select_with_subnav: true
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

Overall plot shows the following cumulated data plots for the molecule sample selected in panel 
[Molecule selection](#molecule-selection):
- [Concatenated traces](#concatenated-traces)
- [Histograms](#histograms)

Data plots must be updated after modification of the molecule selection by pressing 
![UPDATE](../../assets/images/gui/TP-but-update-tm.png "UPDATE").

<a href="../../assets/images/gui/TP-panel-sample-tm-loadingbar.png"><img src="../../assets/images/gui/TP-panel-sample-tm-loadingbar.png" style="max-width:389px;"/></a>

The final molecule selection is exported to module Trace processing by pressing 
![TO MASH](../../assets/images/gui/TP-but-to-mash.png "TO MASH"); as the operation can not be undone, a warning pops up.

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-overallplot-warn.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-overallplot-warn.png" style="max-width:479px"></a>


### Concatenated traces
{: .no_toc }

Concatenated time traces of selected molecules are shown in axes **(c)** and allow to identify outliers. 
For instance, intensity-time traces with abnormally high or low intensities are easily visible and are good candidates for exclusion from the set.
Data available in menu **(a)** for concatenated trace plot are:
* intensity-time traces
* FRET-time traces
* Stoichiometry-time traces


### Histograms
{: .no_toc }

Overall 1D- or 2D-data histograms and are shown in axes **(d)**.
Data are sorted into bins defined by the x- and y-axis parameters set in row **(e)** and **(f)** respectively, and in columns **(g)** (lowest limit), **(h)** (bin size) and **(l)** (highest limit).
Histogram plots are used to identify different sub-populations in the sample and to control the homogeneity of data distribution.
For instance, the presence of single labelled species is easily identified on the overall stoichiometry histogram and indicates the need for further sample refinement.
Data available in menu **(b)** for histogram plot are:
* intensities histograms
* FRET histograms
* Stoichiometry histograms
* E-S histograms


---

## Molecule selection

Use this interface to assemble the molecule selection.

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection.png"/></a>

Molecule sleection shows individual single molecule data plots that can be browsed using the sliding bar in **(i)**. 
The interface can be optimized by adjusting the number of molecules per page in **(d)**, and by hiding the panel 
[Overall plot](#overall-plot) when pressing 
![\^](../../assets/images/gui/TP-but-triangle.png "^").

Single molecule intensity-time traces and histograms are respectively shown in axes **(h)** and **(l)**, whereas FRET- and stoichiometry-time traces and histograms are respectively shown in axes **(j)** and **(k)**. 

Individual single molecule data are inspected one by one to define their status, which includes:
* [Sample exclusion](#sample-exclusion) 
* [Subgroup affiliation](#subgroup-affiliation)

For instance, single molecules with incoherent intensity-time traces can be excluded from the selection and static FRET traces can be affiliated to the `static` subgroup. 


### Sample exclusion
{: .no_toc }

Selection or exclusion of individual molecules is done by activating/deactivating the option in **(e)**.

To help with sample selection, groups of molecules can be selected/unselected at the same time using the list of criteria in menu **(a)**.
Selection criteria are:
- `current`: uses the current selection (default)
- `all`: selects all molecules
- `none`: exclude all molecules
- `inverse`: select excluded molecules and exclude selected molecules in the current selection
- `add [Tag]`: add molecules affiliated to subgroup `[Tag]` to the current selection
- `remove [Tag]`: remove molecules affiliated to subgroup `[Tag]` from the current selection

As the operation can not be undone, a warning pops up.

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection-warn1.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection-warn1.png" style="max-width:409px"></a>


### Subgroup affiliation
{: .no_toc }

Subgroup affiliations of individual molecules are listed in **(f)** and can be extended by selecting a subgroup in menu **(g)** and pressing 
![Tag](../../assets/images/gui/TP-but-tag.png "tag"), or removed by pressing 
![Untag](../../assets/images/gui/TP-but-untag.png "Untag").

Tag removal can also be performed for all molecules at once by pressing 
![Untag all](../../assets/images/gui/TP-but-untag.png "Untag").

To help with molecule tagging, groups of molecules can be tagged at the same time using specific data criteria with tool 
[Automatic sorting](tm-automatic-sorting.html).
To identify molecule subgroups in the video, molecule tags can be visualized on the average video image with tool 
[Video view](tm-video-view.html).

Customed subgroup tags can be created in **(b)** by simply typing the tag name and 
tag color can be modified any time by pressing 
![Set](../../assets/images/gui/TP-but-set.png "Set").
Specific tags can be deleted pressing 
![Delete tag](../../assets/images/gui/TP-but-delete-tag.png "Delete tag"); as the operation can not be undone, a warning pops up if some molecules are affiliated to the corresponding subgroup.

<a href="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection-warn2.png"><img src="../../assets/images/gui/TP-panel-sample-tm-overview-moleculeselection-warn2.png" style="max-width:489px"></a>
