---
layout: default
title: Control area
parent: Components
grand_parent: Histogram analysis
nav_order: 5
---

<img src="../../assets/images/logos/logo-histogram-analysis_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Control area
{: .no_toc }

The control area contains the export button of module Histogram analysis. 

Use this area to export data.


## Area components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Export data

Press 
![Export...](../../assets/images/gui/HA-but-exportdotdotdot.png "EXPORT...") and select a destination directory to start writing histogram and analysis results to files.

The type of exported files depends on which analysis was carried on:

* [.hist files](../../output-files/hist-histograms.html) are systematically saved,
* [.pdf files](../../output-files/pdf-histogram-analysis-bootstrap-plots.html) are saved when bootstrap analysis was used,
* [_config.txt](../../output-files/txt-histogram-state-configurations.html) are saved when state configurations were determined,
* [_thresh](../../output-files/txt-histogram-state-populations.html) or 
[_gauss.txt](../../output-files/txt-histogram-state-populations.html) are saved when state populations were calculated.

PDF export uses the MATLAB script `append_pdfs` developed by Oliver Woodford that can be found in the 
[MATLAB exchange platform](https://www.mathworks.com/matlabcentral/fileexchange/31215-append_pdfs).

***Note:** Exporting PDF figures requires the installation of Ghostscript that can be downloaded 
[here](https://www.ghostscript.com/)*

