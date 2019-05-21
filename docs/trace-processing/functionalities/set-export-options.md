---
layout: default
title: Set export options
parent: /trace-processing/functionalities.html
grand_parent: /trace-processing.html
nav_order: 2
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Set export options
{: .no_toc }

Export options define the particular files to export from module Trace processing.

The window is accessed by pressing 
![Export ASCII...](../../assets/images/gui/TP-but-export-ascii-3p.png "Export ASCII...") in the project management area of module Trace processing.

After modification, press 
![Next >>](../../assets/images/gui/TP-but-next-supsup.png "Next >>") to start file export.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-export.png"><img src="../../assets/images/gui/TP-panel-sample-export.png" style="max-width: 516px;"/></a>

## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Export trajectories and processing parameters

Use this panel to export time-traces and processing parameters files in various formats.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-export-traces.png"><img src="../../assets/images/gui/TP-panel-sample-export-traces.png" style="max-width: 235px;"/></a>

To export time traces and processing parameters activate the option in **(a)**, otherwise activate the option in **(b)**.

Time traces can be exported in the following file formats by selecting the appropriate option in list **(c)**:
- `customed format (*.txt)`; see [Customed format](#customed-format)
- `HaMMy-compatible (*.dat)`; see [HaMMy trace files](../../output-files/dat-hammy-traces)
- `vbFRET-compatible (*.mat)`; see [vbFRET trace files](../../output-files/mat-vbfret-traces)
- `SMART-compatible (*.traces)`; see [SMART trace files](../../output-files/traces-smart-traces)
- `QUB-compatible (*.txt)`; see [QUB trace files](../../output-files/txt-qub-traces)
- `ebFRET-compatible (*.dat)`; see [ebFRET trace files](../../output-files/dat-ebfret-traces)
- `All formats` to export all file formats sub mentioned

Processing parameters can be exported in file headers with the customed format by selecting `ASCII file headers` in list **(i)**, or to individual files by selecting `external file(*.log)`; see 
[Processing parameters file](../../output-files/log-processing-parameters.html) for more information about the file structure.

To ignore processing parameters select `none` in list **(i)**.


### Customed format
{: .no_toc }

The content of these trace files is customizable and can include:
* <u>intensity-time traces</u> by activating the option in **(d)**
* <u>FRET-time traces</u> by activating the option in **(e)**
* <u>stoichiometry-time traces</u> by activating the option in **(f)**
* <u>trace processing parameters</u> by activating the option in **(i)**

Specific data-time traces can be exported to one common ASCII file per molecule or to individual ASCII files, by respectively activating or deactivating the option in **(g)**.

See 
[Processed trace files](../../output-files/txt-processed-traces.html) for more information about the file structure.


---

## Export histograms

Use this panel to export histogram files.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-export-hist.png"><img src="../../assets/images/gui/TP-panel-sample-export-hist.png" style="max-width: 245px;"/></a>

Export histograms by activating the option in **(a)**, otherwise activate the option in **(b)**.

Trace-specific histograms can be exported to individual 
[.hist files](../../output-files/hist-histograms) for the following data:
* <u>intensity</u> by activating the option in **(c)**
* <u>FRET</u> by activating the option in **(d)**
* <u>stoichiometry</u> by activating the option in **(e)**

Histogram binning is defined by the histogram bounds set in **(g)** and **(i)** and the bin size set in **(h)**.

If desired, <u>histograms of states trajectories</u> can also be exported to individual files by activating the option in **(f)**.


---

## Export dwell times

Use this panel to export dwell-times and statistics on dwell-times to files.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-export-dt.png"><img src="../../assets/images/gui/TP-panel-sample-export-dt.png" style="max-width: 235px;"/></a>

Dwell times are the durations of each state in state trajectories.
Dwell time files are specific to a state trajectory and list the state durations in chronological order.

Export dwell times and/or statistics on dwell times by activating the option in **(a)**, otherwise activate the option in **(b)**.

Trace-specific dwell times can be exported to individual 
[.dt files](../../output-files/dt-dwelltimes) for the following data:
* <u>intensity</u> by activating the option in **(c)**
* <u>FRET</u> by activating the option in **(d)**
* <u>stoichiometry</u> by activating the option in **(e)**

If desired, data-specific <u>statistics on dwell times</u> can also be exported to one common file by activating the option in **(f)**; see 
[Dwell time statistics files](../../output-files/kin-dwelltime-stats.html) for more information about the content of these files.


---

## Export figures

Use this panel to export figure files.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-export-figures.png"><img src="../../assets/images/gui/TP-panel-sample-export-figures.png" style="max-width: 245px;"/></a>

Figure files contain graphics representing individual time traces, histograms, and/or single molecule images as shown in the 
[Visualization area](../panels/area-visualization.html) of Trace processing.

Export figures by activating the option in **(a)**, otherwise activate the option in **(b)**.

Figures  can be exported in the following file formats by selecting the appropriate option in list **(c)**:
- `Portable Document format(*.pdf)` (PDF)
- `Portable network graphics(*.png)` (PNG)
- `Joint Photographic Experts Group(*.jpeg)` (JPEG)

For format PDF, pages are exported to one single file, whereas for other formats, pages are exported to individual files by appending the file name with the corresponding molecule indexes.

The number of molecules per figure page is set in **(d)**.

The content of figure files is customizable and can include:
- <u>sub-images</u> of molecules, by activating the option **(f)**
- <u>intensity-time traces</u> of emitters selected in list **(h)** and upon illumination selected in list **(i)**, by activating the option **(g)**
- <u>intensity ratio-time traces</u> selected in list **(h)**, by activating the option **(j)**

If desired, <u>histograms</u> and/or <u>state trajectories</u> can also be included by activating the respective options in **(l)** and/or **(m)**.

The resulting figure can be previewed by pressing 
![Preview](../../assets/images/gui/TP-but-preview.png "Preview").

PDF export uses the MATLAB script `append_pdfs` developed by Oliver Woodford that can be found in the 
[MATLAB exchange platform](https://www.mathworks.com/matlabcentral/fileexchange/31215-append_pdfs).

**Note:** *Exporting PDF figures requires the installation of Ghostscript that can be downloaded 
[here](https://www.ghostscript.com/)*


---

## Molecule status

Defines the status of the molecule sample to export.

<a class="plain" href="../../assets/images/gui/TP-panel-sample-export-mol.png"><img src="../../assets/images/gui/TP-panel-sample-export-mol.png" style="max-width: 270px;"/></a>

To only export the molecules that are selected in the 
[Molecule list](../panels/panel-sample-management.html#molecule-list), activate the box in **(a)**.

To export a sub-group of molecules, select the proper tag in list **(b)**, otherwise, select `All molecules` to export all molecules.

