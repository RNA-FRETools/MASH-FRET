---
layout: default
title: Project management area
parent: Components
grand_parent: Histogram analysis
nav_order: 1
---

<img src="../../assets/images/logos/logo-histogram-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Project management
{: .no_toc }

The project management area is the main import/export interface of module Histogram analysis.

Use this area to import MASH projects and save analysis results.

<a class="plain" href="../../assets/images/gui/HA-area-project-management.png"><img src="../../assets/images/gui/HA-area-project-management.png" style="max-width: 186px;"/></a>

## Area components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## ASCII import options

*Under construction*


---

## Project list

Use this list to access your projects imported in module Histogram analysis.

Projects contain original single molecule data, calculated data and parameters necessary for calculations in all modules of MASH-FRET.

Single molecule data can be imported in module Histogram analysis from a 
[.mash file](../../output-files/mash-mash-project.html) by pressing 
![Add](../../assets/images/gui/HA-but-add.png "Add") and selecting the corresponding 
[.mash file](../../output-files/mash-mash-project.html "Add").

After import, the new project is added to the project list and the 
[Visualization area](panel-visualization-area.html) area is updated with the first data available in the project.

Press 
![Remove](../../assets/images/gui/HA-but-remove.png "Remove") to close a project and remove it from the project list.


---

## Export analysis results

Press 
![Export...](../../assets/images/gui/HA-but-export3p.png "Export...") and select a destination directory to export the overall histogram and analysis results of the current data to files.

The type of exported files depends on which analysis was carried on: 

* [.hist files](../../output-files/hist-histograms.html) are systematically saved, 
* [.pdf files](../../output-files/pdf-histogram-analysis-figures.html) are saved when bootstrap analysis was used, 
* [_config.txt](../../output-files/txt-histogram-state-configurations.html) are saved when state configurations were determined, 
* [_thresh or _gauss.txt](../../output-files/txt-histogram-state-populations.html) are saved when state populations were calculated.

PDF export uses the MATLAB script `append_pdfs` developed by Oliver Woodford that can be found in the 
[MATLAB exchange platform](https://www.mathworks.com/matlabcentral/fileexchange/31215-append_pdfs).

**Note:** *Exporting PDF figures requires the installation of Ghostscript that can be downloaded 
[here](https://www.ghostscript.com/)*


---

## Save project

Press 
![Save](../../assets/images/gui/HA-but-save.png "Save") to a project to a
[.mash files](../../output-files/mash-mash-project.html).

To save modifications of one project, simply overwrite the existing 
[.mash file](../../output-files/mash-mash-project.html).

