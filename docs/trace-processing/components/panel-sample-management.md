---
layout: default
title: Sample management
parent: Components
grand_parent: Trace processing
nav_order: 10
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Sample management
{: .no_toc }

Sample management is the first panel of module Trace processing. 
Access the panel content by pressing 
![Bottom arrow](../../assets/images/gui/interface-but-bottomarrow.png). 
The panel closes automatically after other panels open or after pressing 
![Top arrow](../../assets/images/gui/interface-but-toparrow.png). 

Use this panel to browse, sort and clear molecules in the project.

<a class="plain" href="../../assets/images/gui/TP-panel-sample.png"><img src="../../assets/images/gui/TP-panel-sample.png" style="max-width: 338px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Molecule list

Use this list to browse single molecules in your sample.

Molecules indexes are listed and colored according to the molecule tags defined in 
[Molecule status](#molecule-status).

After selection of a molecule in the list, the
[Visualization area](area-visualization.html) is updated and the processing parameters of panels 
[Sub-images](panel-subimage.html), 
[Background correction](panel-background-correction.html),
[Factor corrections](panel-factor-corrections.html), 
[Photobleaching](panel-photobleaching.html), 
[Denoising](panel-denoising.html) and 
[Find states](panel-find-states.html) are shown for the selected molecule.


---

## Molecule status

Use this area to define the current molecule status.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-mol.png"><img src="../../assets/images/gui/TP-panel-sample-mol.png" style="max-width: 338px;"/></a>

Molecule statuses are defined by the sample inclusion/exclusion and the subgroup assignment.

To exclude the molecule from the sample, deactivate the option in **(a)**. 
Time traces of excluded molecules are plotted on a darker background in the 
[Visualization area](area-visualization.html#intensity-time-traces-and-histograms) for easier identification.

Excluded molecules can be definitely deleted from the project by pressing 
![Clear](../../assets/images/gui/TP-but-clear.png "Clear").

To assign a specific tag to the current molecule, press 
![<Add](../../assets/images/gui/TP-but-infadd.png "<Add") and select a tag in list **(c)**.
Tags assigned to the current molecule are listed in **(b)** and can be dismissed by pressing 
![Del.](../../assets/images/gui/TP-but-delp.png "Del.").

To define customed tags, please refer to 
[Use Trace manager](../functionalities/tm-overview.html#molecule-selection).


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

