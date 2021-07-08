---
layout: default
title: Set import options
parent: Functionalities
grand_parent: Trace processing
nav_order: 1
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Set import options
{: .no_toc }

Import options define the particular structure of ASCII trace and annexed files imported in modules Trace processing and Transition analysis.

The window is accessed by pressing 
![ASCII options ...](../../assets/images/gui/TP-but-ascii-options-3p.png "ASCII options ...") in the project management area of module Trace processing or Transition analysis.

After modification, press 
![Save](../../assets/images/gui/TP-but-save-bga.png "Save") to save import settings.

<a href="../../assets/images/gui/TP-area-proj-impopt.png"><img src="../../assets/images/gui/TP-area-proj-impopt.png" style="max-width: 507px;"/></a>

## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Molecule coordinates

Use this panel to define the import options for single molecule coordinates.

<a href="../../assets/images/gui/TP-area-proj-impopt-coord.png"><img src="../../assets/images/gui/TP-area-proj-impopt-coord.png" style="max-width: 250px;"/></a>

Single molecule coordinates are used to calculate initial intensity time traces and in background calculation.

If no coordinates are available, molecule positions can not be modified and only manual background setting will be allowed.

To import single molecule coordinates from the headers of trace files, activate the option in **(d)** and set in **(e)** the corresponding file line.

To import single molecule coordinates from an external ASCII file, activate the option in **(a)**, press 
![...](../../assets/images/gui/TP-but-3p.png "...") and select the proper file. 
Coordinates are sorted according to the specific x-range of each channel which is calculated from the initial video x-dimension set in **(c)**.
After import, the file name is displayed in **(b)**.

Coordinates are read in the file following user-defined import settings that can be accessed and modified by pressing 
![Import options](../../assets/images/gui/TP-but-import-options.png "Import options").

<a href="../../assets/images/gui/TP-area-proj-impopt-coord-impopt.png"><img src="../../assets/images/gui/TP-area-proj-impopt-coord-impopt.png" style="max-width: 226px;"/></a>

The number of file header lines to skip is set in **(f)** and channel-specific x- and y-coordinates are read from columns set in **(g)** and **(h)** respectively.
Import settings are saved only after pressing 
![Ok](../../assets/images/gui/TP-but-ok.png "Ok").


---

## Single molecule video

Use this panel to import a single molecule video (SMV).

<a href="../../assets/images/gui/TP-area-proj-impopt-vid.png"><img src="../../assets/images/gui/TP-area-proj-impopt-vid.png" style="max-width: 250px;"/></a>

The SMV is used to re-calculate intensity-time traces in case molecule positions are modified, and to calculate background intensities.

If no video is available, only manual background setting will be allowed.

By default, intensity-time traces are recalculated by summing up a 1-by-1 pixel area; see 
[Integration parameters](../../video-processing/panels/panel-intensity-integration.html#integration-parameters) for more information about intensity calculation.
Background intensity-time traces are also concerned in case 
[Background correction settings](../panels/panel-background-correction.html#background-correction-settings) include the background correction `Dark trace`.

Import a SMV file along with intensity-time traces by activating the option in **(a)**, pressing 
![...](../../assets/images/gui/TP-but-3p.png "...") and selecting the proper file. 
The imported file name is then displayed in **(b)**.

If possible, it is recommended to convert the file to the 
[.sira file](../../output-files/sira-mash-video.html) format prior import to increase speed of execution; see 
[Export video to file](../../video-processing/panels/panel-edit-video.html#export-video-to-file) for help.


---

## Intensity-time traces

Use this panel to define import options for intensity and time data.

<a href="../../assets/images/gui/TP-area-proj-impopt-intensity.png"><img src="../../assets/images/gui/TP-area-proj-impopt-intensity.png" style="max-width: 250px;"/></a>

Imported intensities are used to build initial intensity-time traces and are considered exempted of any correction.

If intensities are already corrected of some sort, do not forget to deactivate the corresponding corrections in Trace processing after import. 

Intensity data are read in one or several ASCII files according to the following structure:

- intensity data are located from file line **(a)** to **(b)** and from column **(c)** to **(d)**
- channel-specific intensities are distributed every **(g)**<sup>th</sup> file columns
- laser-specific intensities are distributed every **(h)**<sup>th</sup> file lines

Laser-specific wavelengths are used in FRET and stoichiometry calculations to identify the red-shift order of donors and acceptors; see 
[FRET calculations](../../video-processing/functionalities/set-project-options.html#fret-calculations) and 
[Stoichiometry calculations](../../video-processing/functionalities/set-project-options.html#stoichiometry-calculations) for more information.

Alternated lasers are named `exc [l]` in list **(i)**, with `[l]` the laser index respecting the order of appearance in the trajectory.
Set laser wavelength in **(j)** after changing selection in list **(i)**. 

If the files contain time data, activate the option in **(e)** and set in **(f)** the file column where time data are located in order to import the corresponding time axis.


---

## Correction factors

Use this panel to import molecule-specific gamma and beta correction factors.

<a href="../../assets/images/gui/TP-area-proj-impopt-gamma.png"><img src="../../assets/images/gui/TP-area-proj-impopt-gamma.png" style="max-width: 258px;"/></a>

Gamma factors account for differences in emission detection efficiencies and quantum yields between donor and acceptor emitters, whereas beta factors account for differences in extinction coefficients and excitation intensities.
Gamma factors are used in FRET and stoichiometry calculations, whereas beta factors are used in stoichiometry calculations only; see 
[Correct ratio values](../workflow.html#correct-ratio-values) for more information.

Correction factors are usually calculated or set in panel 
[Factor corrections](panel-factor-corrections), but can also be imported from one or several ASCII files side-by-side with ASCII trace files.

Gamma and beta factor files are ASCII files structured as described in
[.gam files](../..//output-files/gam-gamma-factors.html) and 
[.bet files](../..//output-files/bet-beta-factors.html) respectively.

To import gamma and/or beta factors, activate the option in **(a)** and/or **(c)** respectively, press the corresponding 
![...](../../assets/images/gui/TP-but-3p.png "...") button and select the proper file(s).
The imported file name is then displayed in **(b)** and/or **(d)** respectively.

If several files are selected, gamma and/or beta factors will be concatenated row-wise.


---

## State trajectories

Use this panel to import FRET state trajectories in module Transition analysis exclusively.
If state trajectories are imported in module Trace processing, they will be overwritten by newly calculated ones.

<a href="../../assets/images/gui/TP-area-proj-impopt-discr.png"><img src="../../assets/images/gui/TP-area-proj-impopt-discr.png" style="max-width: 243px;"/></a>

State trajectories are used in module 
[Transition analysis](../../transition-analysis.html) to infer state configurations and determine state transition rates.

They are usually read from a processed 
[.mash file](../../output-files/mash-mash-project.html) but can also be imported from the ASCII trace files.

To import FRET state trajectories from a single or multiple FRET pairs, activate the option in **(a)**.
In that case, state data will be read from file column **(b)** to **(c)** and skipping **(d)** columns.

In the case of multiple FRET pairs, channel indexes of donor (`[D]`) and acceptor (`[A]`) emitters are read from file column headers `discr.FRET_[D]>[A]` or `FRET[D]-[A]`.

**Note:** *For the moment, only FRET state trajectories can be imported.
In the future, this functionality will be extended to all kind of state data supported in MASH-FRET.*
