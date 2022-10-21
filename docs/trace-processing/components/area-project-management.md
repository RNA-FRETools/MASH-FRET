---
layout: default
title: Project management
parent: Components
grand_parent: Trace processing
nav_order: 1
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Project management area
{: .no_toc }

The project management area is the main import/export interface of module Trace processing.

Use this area to import, edit and export MASH projects.

<a class="plain" href="../../assets/images/gui/TP-area-proj.png"><img src="../../assets/images/gui/TP-area-proj.png" style="max-width: 192px;"/></a>

## Area components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## ASCII import options

Press 
![ASCII options ...](../../assets/images/gui/TP-but-ascii-options-3p.png "ASCII options ...") to open options for trace import.

Import options define the structure of ASCII files from which intensity-time traces are imported and the potential annexed files associated with the traces.

To set the import options, please refer to 
[Set project import options](../functionalities/set-import-options.html).


---

## Project list

Use this list to browse and manage imported projects.

Projects contain original single molecule data, calculated data and parameters necessary for calculations in all modules of MASH-FRET.

Single molecule data can be imported in module Trace processing from:
* a [.mash file](../../output-files/mash-mash-project.html)
* a set of ASCII files with import options defined in 
[ASCII import options](#ascii-import-options).

Import single molecule data by pressing 
![Add](../../assets/images/gui/TP-but-add.png "Add") and selecting the 
[.mash file](../../output-files/mash-mash-project.html) or the set of ASCII files to import.

If a video is assigned to the imported data, laser-specific average images used for sub-images and background correction are calculated during the import process; see 
[Sub-images](panel-subimage.html) and 
[Background correction](panel-background-correction.html) for more information.

<a class="plain" href="../../assets/images/gui/TP-area-proj-loadingbar.png"><img src="../../assets/images/gui/TP-area-proj-loadingbar.png" style="max-width: 300px;"/></a>

After import, the new project is added to the project list and the 
[Sample management](panel-sample-management.html) panel is updated to the first molecule in the project.

Project settings such as relations between channels and lasers, FRET calculations, stoichiometry calculations, plot colors and project tags can be modified any time by pressing 
![Edit...](../../assets/images/gui/TP-but-edit-3p.png "Edit...") or right-clicking and selecting `Edit...`; see 
[Edit project options](#edit-project-options) for more details.

Press 
![Remove](../../assets/images/gui/TP-but-remove.png "Remove") or right-click and select `Close` to close a project and remove it from the project list.

Right-click and select `Merge projects` to merge multiple projects with <u>identical experimental conditions</u> into one; see 
[Save project and export data](../workflow.html#save-project-and-export-data) for more information.


---

## Edit project options

Press 
![Edit...](../../assets/images/gui/TP-but-edit-3p.png "Edit...") or right-click and select `Edit...` to open the project settings.

To modify project settings, please refer to 
[Set project options](../../video-processing/functionalities/set-project-options.html).

If the project was imported from a 
[.mash file](../../output-files/mash-mash-project.html) that was created in module Video processing, settings were pre-defined in 
[Experiment settings](../../video-processing/panels/panel-experiment-settings.html#project-options).

If the project was imported from ASCII files, project options are set to default values.


---

## Save project

Press ![Save](../../assets/images/gui/TP-but-save.png "Save") or right-click and select `Save as...` to export the project to a 
[.mash file](../../output-files/mash-mash-project.html).

To save project modifications, simply overwrite the existing 
[.mash file](../../output-files/mash-mash-project.html).



