---
layout: default
title: Set import options
parent: /trace-processing/functionalities.html
grand_parent: /trace-processing.html
nav_order: 1
---

# Set import options
{: .no_toc }

<a href="../../assets/images/gui/TP-area-proj-impopt.png"><img src="../../assets/images/gui/TP-area-proj-impopt.png" style="max-width: 286px;"/></a>

## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Molecule coordinates

Defines import options for single molecule coordinates.

<a href="../../assets/images/gui/TP-area-proj-impopt-coord.png"><img src="../../assets/images/gui/TP-area-proj-impopt-coord.png" style="max-width: 250px;"/></a>

Single molecule coordinates are used to calculate initial intensity time traces and to define the sub-image for background calculation.
If no coordinates are available, only manual background setting will be allowed.

Single molecule coordinates can be imported from an external ASCII file by activating the box in **(a)**, or from the headers of trace files by activating the box in **(d)** and setting in **(e)** the corresponding source line in file.

The coordinates file can be imported along with ASCII traces by pressing 
![...](../../assets/images/gui/TP-but-3p.png) and selecting the proper file. 
The imported file name is then displayed in **(b)**.
Coordinates are read following user-defined import settings that can be accessed and modified by pressing 
![Import options](../../assets/images/gui/TP-but-import-options.png).

<a href="../../assets/images/gui/TP-area-proj-impopt-coord-impopt.png"><img src="../../assets/images/gui/TP-area-proj-impopt-coord-impopt.png" style="max-width: 226px;"/></a>

Single molecule coordinates are coordinates co-localized in each channel, with each channel corresponding to a specific x-range.
The number of file header lines set in **(d)** is skipped before reading coordinates data and channel-specific x- and y-coordinates are read from columns set in **(c)** and **(d)** respectively.
Coordinates are sorted according to the specific x-range of each channel which is calculated from the initial video x-dimension set in **(c)**.
Import settings are saved only after pressing 
![Ok](../../assets/images/gui/TP-but-ok.png).

---

## Single molecule video

Defines import options for single molecule video (SMV).

<a href="../../assets/images/gui/TP-area-proj-impopt-vid.png"><img src="../../assets/images/gui/TP-area-proj-impopt-vid.png" style="max-width: 250px;"/></a>

The SMV is used to re-calculate intensity-time traces in case molecule positions are modified, and to calculate background intensities
If no video is available, only manual background setting will be allowed.

The SMV file can be imported along with the ASCII traces by activating the option in **(a)**, pressing 
![...](../../assets/images/gui/TP-but-3p.png) and selecting the proper file. 
The imported file name is then displayed in **(b)**.
If possible, it is recommended to convert the file to the 
[.sira file](../../output-files/sira-mash-video.html) format to increase speed of execution; see 
[Export video to file](../../video-processing/panels/panel-edit-video.html#export-video-to-file) for help.

---

## Intensity-time traces

Defines import options for intensity and time data.

<a href="../../assets/images/gui/TP-area-proj-impopt-intensity.png"><img src="../../assets/images/gui/TP-area-proj-impopt-intensity.png" style="max-width: 250px;"/></a>

Imported intensities are used in initial intensity-time trajectories and are considered exempted of any correction.
if imported trajectories are already corrected of some sort, do not forget to deactivate the corresponding corrections in MASH after the import is complete. 

Intensity data are read in one or several ASCII files according to the following structure:

- intensity data are located in files from line **(a)** to **(b)** and from column **(c)** to **(d)**
- intensities detected in one specific video channel are distributed every **(g)**<sup>th</sup> file columns
- intensities collected upon one specific laser illumination are distributed every **(h)**<sup>th</sup> file lines

Lasers are later identified by their excitation wavelength, which must be set for all lasers in **(j)**, after selecting the corresponding laser in **(i)**.

If the files contain specific time data, activate the option in **(e)** and set in **(f)** the file column where time data are located.

---

## Gamma factors

Defines import options for gamma factors.

<a href="../../assets/images/gui/TP-area-proj-impopt-gamma.png"><img src="../../assets/images/gui/TP-area-proj-impopt-gamma.png" style="max-width: 250px;"/></a>

Gamma factors account for differences in emission detection efficiencies and quantum yields of donor and acceptor emitters and are used in FRET calculations; see 
[Correct FRET values](../workflow.html#correct-fret-values) for more information.
They can be set in panel 
[Factor corrections](panel-factor-corrections) or imported from one or several ASCII files along with the ASCII traces.

Gamma factor files are organized in columns with each column corresponding to one donor-acceptor pair and each line corresponding to one molecule of the imported set.
Gamma factors are imported from files by activating the option in **(a)**, pressing 
![...](../../assets/images/gui/TP-but-3p.png) and selecting the proper file(s).
The imported file name is then displayed in **(b)**.
If several files are selected, gamma factors will be concatenated line-wise.


---

## State trajectories

Defines import options for state trajectories for module Transition analysis exclusively

<a href="../../assets/images/gui/TP-area-proj-impopt-discr.png"><img src="../../assets/images/gui/TP-area-proj-impopt-discr.png" style="max-width: 250px;"/></a>

State trajectories are used in module 
[Transition analysis](../../transition-analysis.html) to infer state configurations and determine state transition rates.
They are usually read from a processed 
[.mash file](../../output-files/mash-mash-project.html) but can also be imported from the ASCII trace files.

If the trace files contain FRET state trajectories, activate the option in **(a)**.
In that case, states data are distributed every **(b)**<sup>th</sup> file columns in the ASCII trace files.

If state trajectories are imported in module Trace processing, they will be overwritten by newly calculated ones.

**Note:** *For the moment, only FRET state trajectories can be imported.
In the future, this functionality will be extended to all kind of state data.*
