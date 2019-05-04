---
layout: default
title: Use Trace manager
sub_title: Video view
parent: /trace-processing/functionalities.html
grand_parent: /trace-processing.html
main_nav: /trace-processing/functionalities/tm-overview.html
nav_order: 3
subnav_order: 3
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

Video view is used to visualize single molecules statuses in the video.

## Interface components
{: .no_toc .text-delta }

1. TOC
{:toc}

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-videoview.png" ><img src="../../assets/images/gui/TP-panel-sample-tm-videoview.png"/></a>


---

## Laser illumination

Use this menu to define the video frames taken into account for building the average image shown in the
[Visualization area](#visualization-area).

For experiments using alternated laser excitation (ALEX), video frames can be averaged over each laser illuminations.
Laser-specific average images allow to visualize the molecules labelled with the emitters that are specifically excited at this wavelength.
For instance, molecules labelled with Cy5 will be better visualized on the video frames recorded upon illumination at 638nm.

Select in the list the specific laser illumination wavelength to average video frames over, or choose `all` to average over all video frames.


---

## Molecule selection

Use this menu to define which molecule selection is shown in the
[Visualization area](#visualization-area).

To show:
- only selected molecules, choose the `selected` option
- only excluded molecules, choose the `unselected` option
- selected and excluded molecules, choose the `all` option


---

## Tag list

Adjust these options to show/hide specific molecule subgroups.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-videoview-taglist.png"><img src="../../assets/images/gui/TP-panel-sample-tm-videoview-taglist.png" style="max-width:216px;"></a>

The affiliation of molecules to subgroups is defined by the molecule tags, with each subgroup tag being defined by a specific name and color.
When molecules have no tag, they are automatically affiliated to the `not labelled` subgroup colored in white.

To show or hide molecule subgroups whose tag name is written and colored in **(b)**, respectively activate or deactivate the corresponding options in **(a)**.


---

## Visualization area

Use this interface to visualize molecule subgroups in the video.

If the project is associated with a single molecule video and single molecule coordinates, single molecules are shown on the average video frame upon the chosen
[Laser illumination](#laser-illumination) with colored circles centered on the corresponding molecule positions.
Circles are colored according to the tag-specific color and can be multiple if the same molecule is affiliated to several subgroups.

If the project is not associated with a single molecule video nor/or with a set of single molecule coordinates, Video view is not available and the visualization area display a warning.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-videoview-visu1.png"><img src="../../assets/images/gui/TP-panel-sample-tm-videoview-visu1.png" style="max-width:45%;"></a>
<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-videoview-visu2.png"><img src="../../assets/images/gui/TP-panel-sample-tm-videoview-visu2.png" style="max-width:45%;"></a>

