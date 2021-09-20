---
layout: default
title: Histogram and plot
parent: Panels
grand_parent: Histogram analysis
nav_order: 2
---

<img src="../../assets/images/logos/logo-histogram-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Histogram and plot
{: .no_toc }

Histogram and plot is the first panel of module Histograms analysis.

Use this panel to select data and build histogram.

<a class="plain" href="../../assets/images/gui/HA-panel-plot.png"><img src="../../assets/images/gui/HA-panel-plot.png" style="max-width: 170px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Data list

Use this list to select the data to be analyzed in Histogram analysis.

Supported data are:

* intensities from time traces
* intensities from states trajectories (`discr.`)
* donor intensities in absence of acceptor from time traces (`total`)
* donor intensities in absence of acceptor from states trajectories (`discr.`total)
* FRET from time traces (`FRET`)
* FRET from states trajectories (`discr. FRET`)
* stoichiometries from time traces (`S`)
* stoichiometries from states trajectories (`discr. S`)


---

## Molecule subgroup list

Use this list to select the molecule subgroup to be analyzed in Histogram analysis.

Molecule subgroups are defined by the molecule tags that are created and assigned to molecules in module 
[Trace processing](../../trace-processing.html) exclusively.

Molecule tags are created in 
[Molecule selection](../../trace-processing/functionalities/tm-overview.html#molecule-selection) and can be assigned to individual molecules in 
[Molecule selection](../../trace-processing/functionalities/tm-overview.html#molecule-selection) or in 
[Molecule status](../../trace-processing/panels/panel-sample-management.html#molecule-status).

Molecule tags can also be assigned to groups of molecules defined by specific data ranges with 
[Automatic sorting](../../trace-processing/functionalities/tm-automatic-sorting.html#tm-menu).


---

## Histogram bounds

Use this interface to define limits for the histogram x-axis.

<img src="../../assets/images/gui/HA-panel-plot-bounds.png" style="max-width: 171px;"/>

Histogram x-axis define the range of data used in the analysis. 
The lower limit is set in **(a)** and the higher limit in **(b)**.

For more information about the influence of x-axis limits on the analysis, please refer to 
[Build histogram](../workflow.html#build-histogram) in Histogram analysis workflow.

<u>default</u>: [-0.2;1.2] for ratio data


---

## Histogram bin size

Defines the sorting interval of the histogram.

For more information about the influence of bin size on the analysis, please refer to 
[Build histogram](../workflow.html#build-histogram) in Histogram analysis workflow.

<u>default</u>: 0.025 for ratio data


---

## Overflow bins

Activate this option to remove extreme bins from the histogram.

Sorting data into specific bins often leads to large counts in the two bins flanking the x-axis, which bias the state configuration and state population analysis. 

To prevent such undesired effect, the extreme bins can be removed from the histogram by activating this option. 
To keep extreme bins for analysis, deactivate this option.

<u>default</u>: activated
