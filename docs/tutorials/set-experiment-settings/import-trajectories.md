---
layout: default
title: Option 3
subtitle: Trajectory-based project
grand_parent: Tutorials
parent: Set experiment settings
nav_order: 3
has_toc: false
nav_exclude: true
---

<img src="../../assets/images/logos/logo-tutorials_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Set experiment settings
{: .no_toc}

Follow the appropriate procedure to set the experiment settings of your new project. To create a new project, please refer to [First steps](../../Getting_started.html#first-steps).

{% include tutorial_toc.html %}

---

{% include tutorial_head.html %}

In this section, experiment settings are set for projects starting with trajectories import.

They are specific to each project and include video channel information, emitter and laser configurations, FRET and stoichiometry calculations, the structure of trajectory files but also experimental conditions and colors used to present data.

They are initially set when creating a new trajectory-based project by pressing 
![New project](../../assets/images/gui/interface-but-newproj.png "New project") in the  
[Project management area](../../Getting_started.html#project-management-area) and can be edited by pressing 
![Edit project](../../assets/images/gui/interface-but-editproj.png "Edit project") in the same area.

Press 
![Next](../../assets/images/gui/newproj-but-next.png "Next") to navigate through the settings and 
![Save](../../assets/images/gui/newproj-but-save.png "Save") to complete the creation of the new project or immediately apply the modifications to the existing project.
1. TOC
{:toc}


---

## Import

Use this tab to define the trajectory and annexed files to be imported.

<a href="../../assets/images/gui/newproj-traj-expset1.png"><img src="../../assets/images/gui/newproj-traj-expset1.png" /></a>

* **(1)** [Trajectory files](#trajectory-files)
* **(2)** [Video file](#video-file)
* **(3)** [Coordinates file](#coordinates-file)
* **(4)** [Correction factor files](#correction-factor-files)


### Trajectory files
{: .no_toc }

Imported intensities are used to build initial intensity-time traces and are therefore considered to be exempted of any correction. 
If intensities are already corrected of some sort, do not forget to deactivate the corresponding corrections in module 
[Trace processing](../../trace-processing.html) after import. 

<a href="../../assets/images/gui/newproj-traj-expset1-traj.png"><img src="../../assets/images/gui/newproj-traj-expset1-traj.png" /></a>

To import a set of trajectory files, press 
![...](../../assets/images/gui/newproj-but-dotdotdot.png "...") and select the files in the browser.
Trajectory files are then listed in **(a)**.

Trajectory files can contain data of one or multiple single molecules. 
Their structure must follow certain rules:
* intensities specific to the <u>emission channels</u> must be organized in a <u>column-wise</u> manner, 
* intensities specific to <u>laser illuminations</u> can be organized in a <u>column-</u> or <u>row-wise</u> manner,
* (optional) time stamps must be organized in a <u>column-wise</u> manner,
* (optional) state sequences specific to the FRET pairs must be organized in a <u>column-wise</u> manner.


### Video file
{: .no_toc }

The single molecule video is used to recalculate initial intensity trajectories when the molecule position is modified, and in a specific background calculation. 
If no video is available, intensities will not be recalculated and only manual background setting will be allowed.

<a href="../../assets/images/gui/newproj-traj-expset1-vid.png"><img src="../../assets/images/gui/newproj-traj-expset1-vid.png" /></a>

It is possible to import one multi-channel video (where a video frame is spacially divided into a number of emission channels) or multiple single-channel videos recorded in parallel (where each video contains a single emission channel) by activating the option **(a)** or **(b)**, repsectively.

The interface **(c)** defines the video files to be imported and depends on the import type:

* [Import of a multi-channel video](#import-of-a-multi-channel-video)
* [Import of single-channel videos](#import-of-single-channel-videos)

<u>default</u>: multi-channel video.

After reading the necessary information from the video file, MASH calculates the channel- and laser-specific average images shown in 
tabs [Channels](#channels) and 
[Lasers](#lasers), respectively.

![Calculate average image](../../assets/images/gui/newproj-vid-expset1-lb.png)

Once the import is completed, the 
[Video sampling time](#video-sampling-time) is automatically updated is tab
[Divers](#divers) and the channel- and laser-specific average images in tabs 
[Channels](#channels) and 
[Lasers](#lasers), respectively.

Supported file formats are:
* Olympus CellSense Format (*.<u>vsi</u> associated with *.<u>ets</u>)
* Source Input Format (<u>.sif</u>)
* [WinSpec CCD Capture format](http://www.mpi.stonybrook.edu/nsls/X17B2/support/camera.htm) (<u>.spe</u>)
* [Single data acquisition format](https://cplc.illinois.edu/research/tools) (<u>.pma</u>)
* Audio Video Interleave (<u>.avi</u>)
* Tagged Image File format (<u>.tif</u>)
* Graphics Interchange Format (<u>.gif</u>)
* [MASH video format](../../output-files/sira-mash-video.html) (<u>.sira</u>)
* Portable Network Graphics (<u>.png</u>)

New video formats can be added programmatically by updating the following functions in the source code:

```
MASH-FRET/source/mod_video_processing/graphic_files/getFrames.m
MASH-FRET/source/mod_video_processing/graphic_files/exportMovie.m
```

#### Import of a multi-channel video
{: .no_toc }

<a href="../../assets/images/gui/newproj-traj-expset1-vid-multichan.png"><img src="../../assets/images/gui/newproj-traj-expset1-vid-multichan.png" /></a>

To import a multi-channel video or image, press 
![...](../../assets/images/gui/newproj-but-dotdotdot.png "...") and select the corresponding file.

Once the import is completed, the multi-channel video file name is shown in **(c1)**.


#### Import of single-channel videos
{: .no_toc }

<a href="../../assets/images/gui/newproj-traj-expset1-vid-singlechan.png"><img src="../../assets/images/gui/newproj-traj-expset1-vid-singlechan.png" /></a>

To import single-channel videos or images, set, first, the appropriate number of channels using the 
![Plus](../../assets/images/gui/newproj-but-plus.png "plus") or 
![Minus](../../assets/images/gui/newproj-but-minus.png "minus") button to add or remove channels, respectively.
The channel configuration is automatically updated in tab 
[Channels](#channels).

After the number of video channels is correctly set, import each single-channel video by pressing the appropriate 
![...](../../assets/images/gui/newproj-but-dotdotdot.png "...") button and selecting the corresponding file.

Once the import is completed, single-channel video file names are shown in **(c1)**-**(c3)**.


### Coordinates file
{: .no_toc }

Single molecule coordinates are used to recalculate intensity time traces when the molecule position is modified and in a specific background calculation. 
If no coordinates are available, intensities will not be recalculated and only manual background setting will be allowed.

<a href="../../assets/images/gui/newproj-traj-expset1-coord.png"><img src="../../assets/images/gui/newproj-traj-expset1-coord.png" /></a>

To import a coordinates file, press 
![...](../../assets/images/gui/newproj-but-dotdotdot.png "...") and select the proper file. 
After import, the file name is displayed in **(a)**.

The coordinates file contains the x- and y- pixel positions of each single molecule in each emission channel. 
It must be structure following certain rules:
* <u>molecules</u> must be written in <u>rows</u>
* <u>x- and y-coordinates</u> must be organized in <u>columns</u>

Coordinates are read using the import settings that can be modified by pressing 
![Import options](../../assets/images/gui/newproj-but-import-options.png "Import options").

<a href="../../assets/images/gui/newproj-traj-expset1-coordopt.png"><img src="../../assets/images/gui/newproj-traj-expset1-coordopt.png" /></a>

The number of file header lines is set in **(b)** and channel-specific x- and y-coordinates are read from columns set in **(c)** and **(d)** respectively.
Import settings are saved only after pressing 
![Ok](../../assets/images/gui/newproj-but-ok.png "Ok").


### Correction factor files
{: .no_toc }

Gamma factors account for differences in emission detection efficiencies and quantum yields between donor and acceptor emitters, whereas beta factors account for differences in extinction coefficients and excitation intensities.

Gamma factors are used in FRET and stoichiometry calculations, whereas beta factors are used in stoichiometry calculations only; see 
[Correct ratio values](../../trace-processing/workflow.html#correct-ratio-values) for more information.

Correction factors are usually calculated or set in panel 
[Factor corrections](../../trace-processing/components/panel-factor-corrections), but can also be imported from one or several files along with the trajectories.

<a href="../../assets/images/gui/newproj-traj-expset1-factors.png"><img src="../../assets/images/gui/newproj-traj-expset1-factors.png" /></a>

To import gamma and/or beta factors, press the corresponding 
![...](../../assets/images/gui/TP-but-3p.png "...") button and select the proper file(s).
The imported file names are then displayed in **(a)** and/or **(b)** respectively.

Gamma and beta factor files are structured as described in
[.gam files](../..//output-files/gam-gamma-factors.html) and 
[.bet files](../..//output-files/bet-beta-factors.html) respectively.

If several files are selected, gamma and/or beta factors will be concatenated row-wise.

 
## Channels

Use this tab to configure the emission channels.

<a href="../../assets/images/gui/newproj-traj-expset2.png"><img src="../../assets/images/gui/newproj-traj-expset2.png" /></a>

If not already done in the 
[Import](#import) tab when defining the single-channel video files, the number of emission channels in your experiment must be set in **(1)**.
Upon modification, the tab interface is automatically adjusted.

Each emission channel is associated to a particular emitter and must be labelled accordingly in **(2)**. 
These labels are later used to identify the corresponding trajectories.

When a video was imported along with the trajectories, channel plots in **(3)** show the portion of the average image that correspond to each emission channels; see 
[Video-based project](import-video.html#channels) for more details.
Otherwise, they are left blank.

<u>default</u>: 2 channels labelled `chan [c]`, with `[c]` the channel index.
 
 
## Lasers

Use this tab to configure the illumination setup.

<a href="../../assets/images/gui/newproj-traj-expset3.png"><img src="../../assets/images/gui/newproj-traj-expset3.png" /></a>

The number of alternated lasers with different wavelengths used in the experiment is set in **(1)**. 
For continuous-wavelength excitation, it must be set to 1.
Upon modification, the tab's interface is automatically adjusted.

Selective emitter excitation and laser wavelength must be defined for each laser by selecting the proper emitter in **(3)** and typing the the wavelength in nanometers in **(2)**. 
These two parameters are used to label data and sort emitters according to the red-shift of there absorption spectra, which is necessary in FRET and stoichiometry calculations; see 
[Calculations](#calculations) for more details.

If a video was imported along with the trajectories, plots in **(4)** show the average images of the video frames recorded upon illumination of each laser, lasers being numbered following the chronological order in the video; see 
[Video-based project](import-video.html#lasers) for more details.

<u>default</u>: one laser, wavelength: 532 nm, emitter: channel 1
 
 
## Calculations

Use this panel to define the FRET and stoichiometry ratios to be calculated and plotted.

<a href="../../assets/images/gui/newproj-traj-expset4.png"><img src="../../assets/images/gui/newproj-traj-expset4.png" /></a>

The FRET and Stoichiometry ratios are calculated according to 
[FRET calculations](#fret-calculations) and
[Stoichiometry calculations](#stoichiometry-calculations), respectively.

To activate the FRET calculation for a FRET pair in particular, selective laser excitation of the donor must be present in the experiment.
In this case, select the donor and acceptor channel labels in list **(1)** and **(2)**, respectively, and press 
![Add](../../assets/images/gui/newproj-but-add.png "Add"). 
All FRET calculations are listed in **(3)** and can be removed any time by pressing 
![Remove](../../assets/images/gui/newproj-but-remove.png "Remove").


To activate the stoichiometry calculation for a FRET pair in particular, the FRET pair must be listed in **(3)** and selective laser excitation of the acceptor must be present in the experiment. 
In this case, select the desired FRET pair in **(4)** and press 
![Add](../../assets/images/gui/newproj-but-add.png "Add"). 
All stoichiometry calculations are listed in **(5)** and can be removed any time by pressing 
![Remove](../../assets/images/gui/newproj-but-remove.png "Remove").

<u>default</u>: no calculations


### FRET calculations
{: .no_toc }

In a network composed of several emitters, quantities of energy absorbed by each of the emitters can be emitted as light or transferred via FRET to other emitters providing a non-negligible overlap of the donor emission spectrum with the absorption spectra of the acceptors. 

These energy movements can be represented on a scheme where:
- emitters are numbered according to the red shift of the absorption spectrum
- the energy quantity absorbed by emitter 
[*i*](){: .math_var } exclusively is noted 
[*q*<sub>0,*i*</sub>](){: .math_var }, 
- the quantity of energy emitted by emitter 
[*i*](){: .math_var } is noted 
[*q*<sub>*i*</sub>](){: .math_var },
- the energy quantity transferred by FRET from emitter 
[*i*](){: .math_var } to emitter 
[*j*](){: .math_var } is noted 
[*q*<sub>*i*,*j*</sub>](){: .math_var }.

For example, the energy movements in a FRET-pair network composed of four emitters with different absorption and emission properties are summarized in the following scheme.

<a class="plain" href="../../assets/images/figures/newproj-FRET-calculations-4-color-scheme.png"><img src="../../assets/images/figures/newproj-FRET-calculations-4-color-scheme.png" style="max-width: 250px;"/></a>

In an ideal system that includes radiative processes and energy transfers only, the law of conservation of energy supposed that:

{: .equation }
<img src="../../assets/images/equations/newproj-eq-fret-calc-01.gif" alt="q_{i}=q_{0,i}+\sum_{j<i}q_{j,i}-\sum_{j>i}q_{i,j}"/>

The energy quantity 
[*q*<sub>*i*</sub>](){: .math_var} is comparable to the intensity detected in emission channel of emitter 
[*i*](){: .math_var} and corrected from background and cross-talks. 
Thus, 
[*q*<sub>*i*</sub>](){: .math_var} values are measured during the experiment.

The apparent efficiency 
[*E*\*<sub>*D*,*A*</sub>](){: .math_var} of an energy transfer from a donor 
[*D*](){: .math_var} to an acceptor 
[*A*](){: .math_var} is calculated as:

{: .equation }
<img src="../../assets/images/equations/newproj-eq-fret-calc-02.gif" alt="E_{D,A}^{*}=\frac{q_{D,A}}{q_{D}+q_{D,A}}"/>

To obtain the probability of energy transfer 
[*E*<sub>*D*,*A*</sub>](){: .math_var}, which is inversely proportional to the distance 
[*r*](){: .math_var} between the two dyes, 
[*E*\*<sub>*D*,*A*</sub>](){: .math_var} must later be corrected by considering (1) the different quantities of non-radiative energy lost during the process by both emitters 
[*D*](){: .math_var} and 
[*A*](){: .math_var} as well as (2) the different detection efficiencies of photons emitted by emitters
[*D*](){: .math_var} and 
[*A*](){: .math_var}; see 
[Correct ratio values](../../trace-processing/workflow.html#correct-ratio-values) for more information.

The energy quantity 
[*q*<sub>*i*,*j*</sub>](){: .math_var} is calculated from intensities measured upon different laser illuminations, <u>starting with specific excitation of the most red-shifted donor</u>. 
For the limiting case where the most red-shifted donor transfers energy to multiple acceptors, FRET efficiencies can not be analytically calculated.

Translated in a four-emitter network, the most red-shifted donor is the emitter 3, which can transfer energy to emitter 4 only. 
This comes down to a simple two-emitter network where energy movements can be depicted as in the following scheme.

<a class="plain" href="../../assets/images/figures/newproj-FRET-calculations-4-color-scheme-exc3.png"><img src="../../assets/images/figures/newproj-FRET-calculations-4-color-scheme-exc3.png" style="max-width: 250px;"/></a>

Using the law of conservation of energy and the definition of the apparent FRET efficiency of the donor-acceptor pair 3- 4, we can readily calculate 
[*E*\*<sub>3,4</sub>](){: .math_var} from measured intensities such as:

{: .equation }
<img src="../../assets/images/equations/newproj-eq-fret-calc-05.gif" alt="E_{3,4}^*=\frac{q_{3,4}}{q_3+q_{3,4}}=\frac{q_4}{q_3+q_4}=\frac{I_4^3}{I_3^3+I_4^3}"/>

The next most red-shifted donor is the emitter 2, which can transfer energy to emitters 3 and 4. 
This comes down to a three-emitter network where energy movements can be depicted as in the following scheme.
 
<a class="plain" href="../../assets/images/figures/newproj-FRET-calculations-4-color-scheme-exc2.png"><img src="../../assets/images/figures/newproj-FRET-calculations-4-color-scheme-exc2.png" style="max-width: 250px;"/></a>

Using the law of conservation of energy and the definition of the apparent FRET efficiencies of the donor-acceptor pairs 2- 3 and 2-4, we can express
[*E*\*<sub>2,3</sub>](){: .math_var} and
[*E*\*<sub>2,4</sub>](){: .math_var} in function of measured intensities and the quantity 
[*q*<sub>3,4</sub>](){: .math_var} such as:

{: .equation }
<img src="../../assets/images/equations/newproj-eq-fret-calc-07.gif" alt="E_{2,3}^*=\frac{q_{2,3}}{q_{2,3}+q_2}=\left (1+\frac{q_2}{q_3+q_{3,4}}\right )^{-1} = \left ( 1+\frac{I_2^2}{I_3^2+q_{3,4}}\right )^{-1}"/><br>
<img src="../../assets/images/equations/newproj-eq-fret-calc-08.gif" alt="E_{2,4}^*=\frac{q_{2,4}}{q_{2,4}+q_2}=\left (1+\frac{q_2}{q_4-q_{3,4}}\right )^{-1} = \left ( 1+\frac{I_2^2}{I_4^2-q_{3,4}}\right )^{-1}"/>

According to the definition of the apparent FRET efficiency, 
[*q*<sub>3,4</sub>](){: .math_var} can be expressed in function of measured intensities and the known 
[*E*\*<sub>3,4</sub>](){: .math_var}, such as:

<img src="../../assets/images/equations/newproj-eq-fret-calc-09.gif" alt="q_{3,4}=\frac{E_{3,4}^*}{1-E_{3,4}^*}I_3^2"/>

Put together, these equations allow to calculate 
[*E*\*<sub>2,3</sub>](){: .math_var} and
[*E*\*<sub>2,4</sub>](){: .math_var} in function of measured intensities and the known 
[*E*\*<sub>3,4</sub>](){: .math_var}, such as:

<img src="../../assets/images/equations/newproj-eq-fret-calc-10.gif" alt="E_{2,3}^*= \left ( 1+\frac{I_2^2}{I_3^2+\frac{E_{3,4}^*}{1-E_{3,4}^*}I_3^2}\right )^{-1}=\left [ 1+\frac{I_2^2\left( 1-E_{3,4}^*\right )}{I_3^2}\right ]^{-1}"/><br>
<img src="../../assets/images/equations/newproj-eq-fret-calc-11.gif" alt="E_{2,4}^*= \left ( 1+\frac{I_2^2}{I_4^2-\frac{E_{3,4}^*}{1-E_{3,4}^*}I_3^2}\right )^{-1}"/>

The next most red-shifted donor is the emitter 1, which can transfer energy to emitters 1, 3 and 4. 
Energy movements can be depicted as in the following scheme:
 
<a class="plain" href="../../assets/images/figures/newproj-FRET-calculations-4-color-scheme-exc1.png"><img src="../../assets/images/figures/newproj-FRET-calculations-4-color-scheme-exc1.png" style="max-width: 250px;"/></a>

FRET efficiencies for the FRET pairs 1-2, 1-3 and 1-4 are determined using the same deductive path as presented above, giving:

{: .equation }
<img src="../../assets/images/equations/newproj-eq-fret-calc-12.gif" alt=""/><br>
<img src="../../assets/images/equations/newproj-eq-fret-calc-13.gif" alt=""/><br>
<img src="../../assets/images/equations/newproj-eq-fret-calc-14.gif" alt=""/>

This demonstration can be generalized to a 
[*K*](){: .math_var }-emitter network with the apparent FRET efficiency 
[*E*\*<sub>*D*,*A*</sub>](){: .math_var} – of a donor-acceptor pair 
[*D*](){: .math_var }-[*A*](){: .math_var } with 
[*A*](){: .math_var }>[*D*](){: .math_var } – being calculated from intensities detected upon excitation of emitter 
[*D*](){: .math_var } and apparent FRET efficiencies obtained from more red-shifted FRET-pairs, such as:

<img src="../../assets/images/equations/newproj-eq-fret-calc-15.gif" alt="E_{D,A}^*= \left \{ 1+\frac{I_{D,em}^{D,ex}}{I_{A,em}^{D,ex} \left [1+\sum_{i>A}\left (\frac{E_{A,i}^*}{1-E_{A,i}^*}\right )\right ] -\sum_{D<i<A}\left( \frac{E_{i,A}^*}{1-E_{i,A}^*}I_{i,em}^{D,ex}\right )}  \right \}^{-1}"/>

with 
[*I*<sub>*k*,em</sub><sup>*k'*,ex,\*\*\*</sup>](){: .math_var } the intensity collected in channel specific to emitter 
[*k*](){: .math_var }, upon laser illumination that specifically excites emitter 
[*k'*](){: .math_var }, and after background and cross-talk corrections.

To know more about how multi-color apparent FRET data are calculated, please refer to the respective functions in the source code:

```
MASH-FRET/source/mod-trace-processing/FRET/buildFretexpr.m
MASH-FRET/source/mod-trace-processing/FRET/calcFRET.m
```

### Stoichiometry calculations
{: .no_toc }

The stoichiometry of an emitter is usually used to estimate the ratio of different emitters attached to the single molecule under observation.

The apparent stoichiometry 
[*S*\*<sub>*D*,*A*</sub>](){: .math_var } for a FRET pair composed of donor emitter 
[*D*](){: .math_var } and an acceptor emitter 
[*A*](){: .math_var }, specifically excited by the respective illuminations 
[*D*<sub>ex</sub>](){: .math_var } and 
[*A*<sub>ex</sub>](){: .math_var } in a labelling scheme consisting of 
[*K*](){: .math_var } emitters, is calculated as:

{: .equation }
<img src="../../assets/images/equations/newproj-eq-s-calc.gif" alt="S_{D,A}^{*} = \frac{\sum_{k}\left (I_{k,em}^{D,ex} \right )}{\sum_{k}\left( I_{k,em}^{D,ex} + I_{k,em}^{A,ex} \right ) }">

with 
[*I*<sub>*k*,em</sub><sup>*k'*,ex,\*\*\*</sup>](){: .math_var } the intensity collected in channel specific to emitter 
[*k*](){: .math_var }, upon laser illumination that specifically excites emitter 
[*k'*](){: .math_var }, and after background and cross-talk corrections.

To obtain the stoichiometry
[*S*<sub>*D*,*A*</sub>](){: .math_var}, which correspond to the ratio of different emitters attached to the single molecule under observation, 
[*S*\*<sub>*D*,*A*</sub>](){: .math_var} must later be corrected by considering the differences for emitters 
[*D*](){: .math_var} and 
[*A*](){: .math_var} in: (1) quantities of non-radiative energy lost during the process by the emitters, (2) camera detection efficiencies of emitter photons, (3) quantities of energy released by the emitter-specific illuminations, (4) quantities of energy absorbed by the emitters; see 
[Correct ratio values](../../trace-processing/workflow.html#correct-ratio-values) for more information.

A stoichiometry 
[*S*<sub>*D*,*A*</sub>](){: .math_var } = 0.5 means that half of the total number of 
[*D*](){: .math_var }  and 
[*A*](){: .math_var } emitters attached to the molecule are 
[*D*](){: .math_var } emitters.

To know more about how multi-color Stoichiometry is calculated, please refer to the respective functions in the source code:

```
MASH-FRET/source/mod-trace-processing/FRET/buildSexpr.m
MASH-FRET/source/mod-trace-processing/FRET/calcS.m
```
 
 
## File structure

Use this tab to define the structure of trajectory files.

<a href="../../assets/images/gui/newproj-traj-expset5.png"><img src="../../assets/images/gui/newproj-traj-expset5.png" /></a>

Set parameters parameters **(1)** to **(7)** to define the structure of the trajectory files. 
Use the 
[File preview](#file-preview) in **(8)** to verify the proper reading of file columns and trajectory data when adjusting parameters. 

* **(1)** [Header lines](#header-lines)
* **(2)** [Column delimiter](#column-delimiter)
* **(3)** [Molecule sample](#molecule-sample)
* **(4)** [ALEX data organization](#alex-data-organization)
* **(5)** [Time data](#time-data)
* **(6)** [Intensity data](#intensity-data)
* **(7)** [FRET state sequence data](#fret-state-sequence-data)
* **(8)** [File preview](#file-preview)

The structure define on the example above is used to import 
[Processed trace files](../../output-files/txt-processed-traces.html) of a 3-channel and 2-laser experiment. 
The other trajectory file structure used by MASH is the one of 
[Trace files from video](../../output-files/txt-traces-from-video.html) and would correspond to the following settings:

<a href="../../assets/images/gui/newproj-traj-expset5-ex2.png"><img src="../../assets/images/gui/newproj-traj-expset5-ex2.png" /></a>


### Header lines
{: .no_toc }

The number of header lines is the number of lines on top of the file that do not contain any intensity data. 
Header lines are represented with a gray-colored font in the 
[File preview](#file-preview).


### Column delimiter
{: .no_toc }

Column delimiters are characters written in the file that separate column data. 
Supported delimiters are:
* `blanks (tab,spaces)`: both tab and space characters
* `tab`: tab character (in most ASCII files exported from MASH)
* `,`: comma character
* `;`: semi-column character
* `space`: space character

You can ensure a proper column separation by using the 
[File preview](#file-preview).

***Note :** In later versions, the supported file structures will be extended with a custom delimiter and the .json format.*


### Molecule sample
{: .no_toc }

The molecule sample indicates whether the file contains data of one or multiple single molecules:
* `one molecule`: data are imported for only one molecule and [Intensity data](#intensity-data) and [FRET state sequence data](#fret-state-sequence-data) are written in single columns (labelled: from),
* `multiple molecules`: data are imported for multiple molecules and [Intensity data](#intensity-data) and [FRET state sequence data](#fret-state-sequence-data) are written in column ranges (labelled: from, to, skip), where the number of columns scales with the number of molecules.

You can ensure a proper reading of molecule-specific data by using the 
[File preview](#file-preview).


### ALEX data organization
{: .no_toc }

Data from experiments that use alternating lasers can be organized in two ways:
* `row-wise`: Data are written as they are recorded, meaning that each row in the file is a recording step. In this case, data recorded under a specific laser illumination are written every `nL` rows, with `nL` the number of lasers alternated in the experiment.
* `column-wise`: Specific data recorded under specific laser illuminations are written in specific file columns.

Data in the 
[File preview](#file-preview) are colored following the 
[Plot colors](#plot-colors) to ensure a proper reading of laser-specific data. 


### Time data
{: .no_toc }

This interface defines the organization of time data in the file and depends on the 
[ALEX data organization](#alex-data-organization):

* `row-wise`:  
  
  <a href="../../assets/images/gui/newproj-traj-expset5-tarea-rowwise.png"><img src="../../assets/images/gui/newproj-traj-expset5-tarea-rowwise.png" /></a>  
  
  If the files contain time data, activate the option in **(a)** and set in **(b)** the file column where time data are located.

* `column-wise`:  
  
  <a href="../../assets/images/gui/newproj-traj-expset5-tarea-colwise.png"><img src="../../assets/images/gui/newproj-traj-expset5-tarea-colwise.png" /></a>
  
  If the files contain time data, activate the option in **(a)** and set in **(b)**-**(c)** the file column where laser-specific time data are located.
  
If trajectories are imported without video, the 
[Video sampling time](#video-sampling-time) is deduced from the time data and is automatically updated in tab 
[Divers](#divers).
  
Time data are colored in pink in the 
[File preview](#file-preview) to ensure a proper reading of time columns.


### Intensity data
{: .no_toc }

This table defines the file columns where intensity data are written and depends on the 
[Molecule sample](#molecule-sample) and 
[ALEX data organization](#alex-data-organization).

The first table column `data` lists the data for which the file columns have to be defined. 
They are colored according to the 
[Plot colors](#plot-colors) and named after the channel labels `[em]` and the laser wavelengths `[wl]`, depending on the 
[ALEX data organization](#alex-data-organization):
* `[em]` for a <u>row-wise</u> organization
* `[em]at[wl]nm` for a <u>column-wise</u> organization

Intensity columns in the files are then defined in table columns:
* `from`: the <u>only column</u> where data are written if the [Molecule sample](#molecule-sample) is set to `one molecule`, or the <u>first column</u> of the range if it is set to `multiple molecule`,
* `to`: (only for `multiple molecule`) <u>last column</u> of the range,
* `skip`: (only for `multiple molecule`) the number of <u>columns to skip</u> to find the data of the next molecule.

Data in the 
[File preview](#file-preview) are also colored according to the 
[Plot colors](#plot-colors) to ensure a proper reading of intensity columns. 


### FRET state sequence data
{: .no_toc }

This interface defines the import of FRET state data.

Imported FRET state trajectories will be shown in 
[Trace processing](../../trace-processing.html) and used in 
[Transition analysis](../../transition-analysis.html) and 
[Histogram analysis](../../histogram-analysis.html) modules. 
If imported trajectories are pocessed in module 
[Trace processing](../../trace-processing.html), state sequences will be overwritten by the newly calculated ones.

<a href="../../assets/images/gui/newproj-traj-expset5-seq.png"><img src="../../assets/images/gui/newproj-traj-expset5-seq.png" /></a>

To import FRET state trajectories, activate the option **(a)** and set the file columns in table **(b)**.

Table **(b)** defines the file columns where FRET state data are written and depends on the 
[Molecule sample](#molecule-sample). 
The first table column `data` lists the FRET pairs for which the file columns have to be defined. 
They are colored according to the 
[Plot colors](#plot-colors) and named after the donor and acceptor channel indexes. 
FRET state columns in the files are then defined in table columns:
* `from`: the <u>only column</u> where data are written if the [Molecule sample](#molecule-sample) is set to `one molecule`, or the <u>first column</u> of the range if it is set to `multiple molecule`,
* `to`: (only for `multiple molecule`) <u>last column</u> of the range,
* `skip`: (only for `multiple molecule`) the number of <u>columns to skip</u> to find the data of the next molecule.

Data in the 
[File preview](#file-preview) are also colored according to the 
[Plot colors](#plot-colors) to ensure a proper reading of FRET state columns. 

***Note**: After import, the first molecule in the sample is automatically processed in module 
[Trace processing](../../trace-processing.html) and state sequences are overwritten by the newly calculated ones; this will be corrected in later versions. 
However, the state sequences used in 
[Transition analysis](../../histogram-analysis.html) and 
[Histogram analysis](../../transition-analysis.html) are not affected as long as all molecule data are not processed at once in Trace processing; see 
[Process all molecules data](../../trace-processing/components/panel-sample-management.html#process-all-molecules-data).*


### File preview
{: .no_toc }

The file preview shows the content of the first trajectory file using the current define structure. 
The file content is color-coded, where 
[Header lines](#header-lines) are grayed out, 
[Time data](#time-data) are colored in pink, and 
[Intensity data](#intensity-data) and 
[FRET state sequence data](#fret-state-sequence-data) are color-coded using the 
[Plot colors](#plot-colors). 

It can be used to verify the proper reading of file columns and trajectory data when adjusting parameters **(1)**-**(7)**. 


## Divers

Use this tab to define the project's title, optional parameters, the video sampling time and plot colors.

<a href="../../assets/images/gui/newproj-traj-expset6.png"><img src="../../assets/images/gui/newproj-traj-expset6.png" /></a>

* (1) [Project's title](#projects-title)
* (2) [Optional parameters](#optional-parameters)
* (3) [Video sampling time](#video-sampling-time)
* (4) [Plot colors](#plot-colors)


### Project's title
{: .no_toc }

The title is the name appearing in the 
[project list](../../Getting_started.html#interface). 
It is defined in **(1)**.
Leaving **(1)** empty will give the title "Project" to your project.

<u>default</u>: `trajectories`


### Optional parameters
{: .no_toc }

<a href="../../assets/images/gui/newproj-traj-expset6-expcond.png"><img src="../../assets/images/gui/newproj-traj-expset6-expcond.png" /></a>

Optional parameters include the name of the investigated molecule, set in **(a)**, and the experimental conditions set in **(b)**.

Experimental conditions can be added, modified and removed by simply editing the condition's name, value and units in the corresponding column of table **(b)**. 

Optional parameters solely act as project "tags" saved with the 
[MASH project file](../../output-files/mash-mash-project.html) and exported in
[Processing parameter files](../../output-files/log-processing-parameters.html).

<u>default</u>: `[Mg2+]` in `mM` (magnesium molar concentration) and `[K+]` in `mM` (potassium molar concentration).


### Video sampling time
{: .no_toc }

The video sampling time is shown in seconds in **(3)**.
In the case the sampling time was successfully read from either the trajectory files or the video file, this property is read-only. 
If not, the sampling time must be set manually.

<u>default</u>: 1 second


### Plot colors
{: .no_toc }

Use this panel to define the colors used to plot and identify the time traces.

<a href="../../assets/images/gui/newproj-vid-expset5-plotclr.png"><img src="../../assets/images/gui/newproj-vid-expset5-plotclr.png" /></a>

To set the RGB color of a specific trace, select the data in list **(a)** and press
![Set color](../../assets/images/gui/newproj-but-setcolor.png "Set color") to open the color picker.

To use a predefined set of colors adapted to simulations, press 
![Apply default colors](../../assets/images/gui/newproj-but-applydefclr.png "Apply default colors").

<u>default</u>: from green to red for intensities, shades of black for FRET ratios and shades of blue for stoichiometry ratios.


---

{% include tutorial_footer.html %}
 
