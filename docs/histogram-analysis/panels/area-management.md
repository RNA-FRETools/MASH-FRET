---
layout: default
title: Project management
parent: /histogram-analysis/panels.html
grand_parent: /histogram-analysis.html
nav_order: 1
---

# Project management
{: .no_toc }

<a href="../../assets/images/gui/HA-area-project-management.png"><img src="../../assets/images/gui/HA-area-project-management.png" style="max-width: 186px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## ASCII import options

*Under construction*


---

## Project list

Use this area to manage your projects imported in module Trace processing.

Projects contain original single molecule data, calculated data and parameters necessary for calculations in all modules of MASH-FRET.

Single molecule data can be imported in module Histogram analysis from a 
[.mash file](../../output-files/mash-mash-project.html) by pressing 
![Add](../../assets/images/gui/HA-but-add.png "Add") and selecting the corresponding 
[.mash file](../../output-files/mash-mash-project.html "Add").

After import, the new project is added to the project list and the 
[Visualization area](panel-visualization-area.html) area is updated with the first data available in the project.

To close a project and remove it from the project list, select the project in the list and press 
![Remove](../../assets/images/gui/HA-but-remove.png "Remove").


---

## Export analysis results

Press 
![Export...](../../assets/images/gui/HA-but-export3p.png "Export...") and select a destination directory to export the overall histogram and analysis results of the current data to files.

The type of exported files depends on which analysis was carried on: 
* [.hist files](../../output-files/hist-histograms.html) are systematically saved, 
* [.pdf files](../../output-files/pdf-histogram-analysis-figures.html) are saved when bootstrap analysis was used, 
* [_config.txt](../../output-files/txt-histogram-state-configurations.html) are saved when state configurations were determined, 
* [_thresh or _gauss.txt](../../output-files/txt-histogram-gaussian-populations.html) are saved when state populations were calculated.

PDF export uses the MATLAB script `append_pdfs` developed by Oliver Woodford that can be found in the 
[MATLAB exchange platform](https://www.mathworks.com/matlabcentral/fileexchange/31215-append_pdfs).

**Note:** *Exporting PDF figures requires the installation of Ghostscript that can be downloaded 
[here](https://www.ghostscript.com/)


---

## Save project

Projects can be exported to 
[.mash files](../../output-files/mash-mash-project.html) by selecting the project in list **(a)** and pressing 
![Save](../../assets/images/gui/HA-but-save.png "Save").
To save modifications of one project, simply overwrite the existing 
[.mash file](../../output-files/mash-mash-project.html).

