---
layout: default
title: Histogram and plot
parent: /histogram-analysis/panels.html
grand_parent: /histogram-analysis.html
nav_order: 2
---

# Histogram and plot
{: .no_toc }

<a href="../../assets/images/gui/HA-panel-plot.png"><img src="../../assets/images/gui/HA-panel-plot.png" style="max-width: 200px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Data list

Selects the data to be analyzed in Histogram analysis.

Supported data are:
* intensities from time traces
* intensities from states trajectories (`discr.`)
* FRET from time traces (`FRET`)
* FRET from states trajectories (`discr. FRET`)
* stoichiometries from time traces (`S`)
* stoichiometries from states trajectories (`discr. S`)


---

## Histogram bounds

Defines limits for the histogram x-axis.

<img src="../../assets/images/gui/HA-panel-plot-bounds.png" style="max-width: 171px;"/>

Histogram x-axis limits define the range of data used in the analysis. 
The lower limit is set in **(a)** and the higher limit in **(b)**.

For more information about the influence of x-axis limits on the analysis, please refere to 
[Build histogram](../workflow.html#build-histogram) in Histogram analysis workflow.

**<u>default</u>:** [-0.2; 1.2] for ratio data


---

## Histogram bin size

The histogram bin size defines the sorting interval of the time traces data into the histogram.

For more information about the influence of bin size on the analysis, please refere to 
[Build histogram](../workflow.html#build-histogram) in Histogram analysis workflow.

**<u>default</u>:** 0.025 for ratio data


---

## Overflow bins

Sorting a data set into specific bins often leads to large counts in the two bins flanking the x-axis, which bias the state configuration and state population analysis. 

To prevent such undesired effect, the extreme bins can be removed from the histogram by activating this option. 
To keep extreme bins for analysis, deactivate this option.

**<u>default</u>:** activated
