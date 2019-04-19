---
layout: default
title: Project management
parent: /transition-analysis/panels.html
grand_parent: /transition-analysis.html
nav_order: 1
---

# Project management
{: .no_toc }

<a href="../../assets/images/gui/TA-area-project-management.png"><img src="../../assets/images/gui/TA-area-project-management.png" style="max-width:199px;"></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## ASCII import options

ASCII files are imported according to the file structure defined by the import options. 
Import options can be modified by pressing 
![ASCII Import](../../assets/images/gui/TA-but-ascii-import.png "ASCII Import").

To set the options, please refer to 
[Set project import options](../../trace-processing/functionalities/set-import-options.html).


---

## Project list

Use this area to manage your projects imported in module Transition analysis.

Projects contain original single molecule data, calculated data and parameters necessary for calculations in all modules of MASH-FRET.

Single molecule data can be imported in module Transition analysis from:
* a [.mash file](../../output-files/mash-mash-project.html)
* a set of ASCII files with import options defined in 
[ASCII import options](#ascii-import-options).

Import single molecule data by pressing 
![Add](../../assets/images/gui/TA-but-add.png "Add") and selecting the 
[.mash file](../../output-files/mash-mash-project.html) or the set of ASCII files to import.

After import, the new project is added to the project list and the transition density plot is built according to 
[Transition density plot](panel-transition-density-plot.html) for the first data in the project.

To close a project and remove it from the project list, select the project in the list and press 
![Remove](../../assets/images/gui/TA-but-remove.png "Remove").


---

## Export analysis results

Pressing 
![Export](../../assets/images/gui/TA-but-export.png "Export") opens the export options window.
Export options define the files formats to export analysis results, including ASCII files and images.

To set export options, refer to 
[Set export options](../functionalities/set-export-options.html).


---

## Save project

Projects can be exported to 
[.mash files](../../output-files/mash-mash-project.html) by selecting the project in list **(a)** and pressing 
![Save](../../assets/images/gui/TA-but-save.png "Save").
To save modifications of one project, simply overwrite the existing 
[.mash file](../../output-files/mash-mash-project.html).


---

## Control panel 

It lists the action logs. Actions are automatically saved in a 
[daily log file](../../output-files/log-daily-logs.html).
