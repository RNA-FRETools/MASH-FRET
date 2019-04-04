---
layout: default
title: Workflow
parent: /transition-analysis.html
nav_order: 2
---

# Transition analysis workflow
{: .no_toc }

In this section you will learn how to determine the most sufficient state configuration from state transitions, obtain state transition rates and estimate the associated variability in the molecule sample. 
Transition analysis results are saved in the 
[mash project](../output-files/mash-mash-project.html) and/or exported to ASCII files for traceability.

The procedure include four steps:

1. TOC
{:toc}


---

## Import single molecule data

Single molecule data can be imported from a 
[.mash file](../output-files/mash-mash-project.html), ideally processed in module Trace processing, or from a set of traces written in ASCII files.
If data are imported from ASCII files, MASH must be informed about the particular file structure. 
In that case, it is recommended to export the imported data set to a new 
[.mash file](../output-files/mash-mash-project.html) in order to save analysis results and allow further review.

After successful import, the list of data available in the project (*e.g.*, intensities, FRET or stoichiometry) is updated in 
[](), and the transition density plot of the first data in the list (usually first channel intensities upon first illumination) is displayed in the 
[Visualization area](panels/area-visualization.html) providing that state trajectories exist in the project; see 
[Determine state trajectories](../trace-processing/workflow.html#determine-state-trajectories) for more information about how to obtain state trajectories.

To import single molecule data:

{: .procedure }
1. Add the project to the list by pressing 
   ![Add](../assets/images/gui/TA-but-add.png "Add") and selecting the corresponding 
   [.mash file](../output-files/mash-mash-project.html)  

To import single molecule data from a ASCII files:

{: .procedure }
1. Set the import settings by pressing 
   ![ASCII options ...](../assets/images/gui/TA-but-ascii-options-3p.png "ASCII options ..."); see 
   [Set project import options](functionalities/set-project-import-options.html) for help  
     
1. Import data by pressing 
   ![Add](../assets/images/gui/TA-but-add.png "Add") and selecting the corresponding ASCII files; this will add a new project to the project list  
     
1. Save the new project to a 
   [.mash file](../output-files/mash-mash-project.html) by pressing 
   ![Save](../assets/images/gui/TA-but-save.png "Save").

   
---

## Build transition density plot

In a transition density plot (TDP), a transition from a state 
[*val*<sub>*i*</sub>](){: .math_var } to a state 
[*val*<sub>*j*</sub>](){: .math_var } is represented as a point with coordinates 
( [*val*<sub>*i*</sub>](){: .math_var };[*val*<sub>*j*</sub>](){: .math_var } ). 
To build a TDP, states in state trajectories are first limited to specific boundaries and transitions 
( [*val*<sub>*i*</sub>](){: .math_var };[*val*<sub>*j*</sub>](){: .math_var } ) are then sorted into bins of specific size.
Ideally, transitions involving similar states assemble into clusters in the TDP: the identification of these clusters, *e. g.* by clustering algorithms, is crucial to determine the overall state configuration.

The regular way of sorting transitions into bins, *i.e.*, counting transition absolute occurrences, will systematically favour state transitions that occur the most in trajectories at the expense of rarely occurring state transitions.
For instance, rapid interconversion of two states will appear as intense clusters whereas irreversible state transitions might be barely visible.
One way of scaling equally the two type of clusters is to assign one transition count per trajectory, regardless the amount of times it occurs in the trajectory.

**[*scheme: effect of single count per molecule on rarely occurring state transitions in TDP*]**

The bin size has a substantial influence on the cluster shapes: large bins will increase the overlap between neighbouring clusters until the extreme case where all clusters are merged in one, whereas short bins will spread out the clusters until the extreme case where no cluster is distinguishable.
TDP boundaries are important to exclude out-of range states that would bias the determination of state configuration.
Therefore, data-specific TDP limits and bin size have to be carefully chosen in order to make transition clusters visible and sufficiently separated.

**[*scheme: effect of bin size on TDP*]**

Transition clusters are easier identified by eyes and by clustering algorithms if a Gaussian filter is applied to the TDP.
This has for effect to smooth the cluster's edges and to enhance the Gaussian shape of their 2D-profile.

**[*scheme: effect of Gaussian filter on TDP*]**

To build the TDP:

{: .procedure }
1. Select a data type in the 
   [Data list](panels/panel-transition-density-plot.html#data-list)
     
1. Set parameters:
     
   [Bounds and bin size](panels/panel-transition-density-plot.html#bounds-and-bin-size)  
   [Count per molecule](panels/panel-transition-density-plot.html#histogram-bin-size)  
   [Gaussian filter](panels/panel-transition-density-plot.html#gaussian-filter)  
     
1. Update the TDP and display by pressing 
   ![update](../../assets/images/gui/TA-but-update.png "update").


---

## Determine the most sufficient state configuration


---

## Estimate state transition rates and associated cross-sample variability


---

## Export data


---
 
## Remarks
{: .no_toc }

