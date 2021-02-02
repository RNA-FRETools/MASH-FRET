---
layout: default
title: Sample management
parent: Panels
grand_parent: Trace processing
nav_order: 2
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Sample management
{: .no_toc }

Sample management is the first panel of module Trace processing.

Use this panel to browse, sort and clear molecules in the project, as well as refresh and export single molecule data.

<a class="plain" href="../../assets/images/gui/TP-panel-sample.png"><img src="../../assets/images/gui/TP-panel-sample.png" style="max-width: 288px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Molecule list

Use this list to browse single molecules in your sample.

Molecules indexes are listed and colored according to the molecule tags defined in 
[Molecule status](#molecule-status).

Press 
![left arrow button](../../assets/images/gui/TP-but-arrow-left.png) or 
![right arrow button](../../assets/images/gui/TP-but-arrow-right.png) to display the previous or next molecule respectively, or simply select the molecule index in the list.

After selection of a molecule index, the
[Visualization area](area-visualization.html) is updated and the processing parameters of panels 
[Sub-images](panel-subimage.html), 
[Background correction](panel-background-correction.html),
[Factor corrections](panel-factor-corrections.html), 
[Photobleaching](panel-photobleaching.html), 
[Denoising](panel-denoising.html) and 
[Find states](panel-find-states.html) are adapted to the selected molecule.


---

## Current molecule

Defines the current molecule index.

After editing the current molecule index, the 
[Visualization area](area-visualization.html) is updated and the processing parameters of panels 
[Sub-images](panel-subimage.html), 
[Background correction](panel-background-correction.html), 
[Factor corrections](panel-factor-corrections.html), 
[Photobleaching](panel-photobleaching.html), 
[Denoising](panel-denoising.html) and 
[Find states](panel-find-states.html) are adapted to the current molecule.


---

## Process current molecule data

Press
![UPDATE](../../assets/images/gui/TP-but-update.png "UPDATE") to update corrections and calculations for the current molecule.

Operations include all intensity corrections as configured in panels 
[Background correction](panel-background-correction.html),
[Factor corrections](panel-factor-corrections.html), 
[Photobleaching](panel-photobleaching.html) and 
[Denoising](panel-denoising.html), as well as calculations of state trajectories as configured in panel 
[Find states](panel-find-states.html) for the current molecule.

Usually, this functionality is used after changing any processing parameters in the sub-mentioned panels.


---

## Process all molecules data

Press 
![UPDATE ALL](../../assets/images/gui/TP-but-update-all.png "UPDATE ALL") to update corrections and calculations for all molecules in the sample.

<img src="../../assets/images/gui/TP-panel-sample-update-all-loadingbar.png" style="max-width:389px;">

Operations include all intensity corrections as configured in panels 
[Background correction](panel-background-correction.html),
[Factor corrections](panel-factor-corrections.html), 
[Photobleaching](panel-photobleaching.html) and 
[Denoising](panel-denoising.html), as well as calculations of state trajectories as configured in panel 
[Find states](panel-find-states.html) for all molecules.

Usually, this functionality is used before 
[saving the MASH project](area-project-management.html#save-project) or opening the 
[Trace manager](#trace-manager).


---

## Export processed data

Press
![Export ASCII...](../../assets/images/gui/TP-but-export-ascii-3p.png "Export ASCII...") to open the export options.

Export options defines the file formats to export, including ASCII files and figures.

To set export options, refer to 
[Set export options](../functionalities/set-export-options.html).


---

## Trace manager

Press 
![TM](../../assets/images/gui/TP-but-tm.png "TM") to open the 
Trace manager.

Trace manager is used to have an overview of all molecules in the sample and sort them into subgroups.

At opening, Trace manager imports and processes all single molecule data in the project up to gamma correction of FRET-time trace; see Trace processing 
[Workflow](../workflow.html) for more details. 
Processed time traces are then concatenated into on single trace and overall data histograms are built.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-tm-loadingbar.png"><img src="../../assets/images/gui/TP-panel-sample-tm-loadingbar.png" style="max-width:389px;"/></a>

To use Trace manager, refer to 
[Use Trace manager](../functionalities/tm-overview.html).


---

## Molecule status

Use this area to define the current molecule status.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-mol.png"><img src="../../assets/images/gui/TP-panel-sample-mol.png" style="max-width: 271px;"/></a>

Molecule statuses are defined by the sample inclusion/exclusion and the subgroup assignment

To exclude the molecule from the sample, deactivate the option in **(a)**. 
Time traces of excluded molecules are plotted on a darker background in the 
[Visualization area](area-visualization.html#intensity-time-traces-and-histograms) for easier identification.

Excluded molecules can be definitely deleted from the project by pressing 
![Clear](../../assets/images/gui/TP-but-clear.png "Clear").

To assign a specific tag to the current molecule, press 
![Add>>](../../assets/images/gui/TP-but-addsupsup.png "Add>>") and select a tag in list **(c)**.
Tags assigned to the current molecule are listed in **(b)** and can be dismissed by pressing 
![Del.](../../assets/images/gui/TP-but-delp.png "Del.").

To define customed tags, please refer to 
[Use Trace manager](../functionalities/tm-overview.html#molecule-selection).
