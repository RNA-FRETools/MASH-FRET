---
layout: default
title: (*.mash) MASH-FRET project
parent: /output-files.html
nav_order: 18
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# MASH-FRET project files
{: .no_toc }

MASH-FRET project files are Matlab binary files with the extension `.mash`. They are usually found in the main`/video_processing` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

MASH project files are the <u>main analysis files</u>. They contain information about loaded experimental data, calculated data and method settings.

They are created at a user-defined location.

They are created/updated when:
- the user create and saves intensity-time traces in 
[Video processing](../video-processing.html),
- the user save modifications and calculations in 
[Trace processing](../trace-processing.html), [Histogram analysis](../histogram-analysis.html) or 
[Transition analysis](../transition-analysis.html).


---

## File name

The file is named by the user.

By default, the file is named after:
- the <u>video file</u> name loaded in 
[Video processing](../video-processing.html),
- the <u>current project file</u> name loaded in 
[Trace processing](../trace-processing.html).
- the <u>folder</u> containing the trace files imported in 
[Trace processing](../trace-processing.html). 


---

## Structure

MASH-FRET project files consist in data structures with the following fields:


### Project-related fields:
{: .no_toc }

| field name        | description                                                      | data type | example                                     |
| ----------------- | ---------------------------------------------------------------- | --------- | ------------------------------------------- |
| `date_creation`   | date of project creation in format DD-Mon-YYYY hh:mm:ss          | string    | `'05-Feb-2019 12:51:06'`                    |
| `date_last_modif` | date of last project modification in format DD-Mon-YYYY hh:mm:ss | string    | `'20-Mar-2019 14:02:32'`                    |
| `MASH_version`    | version of MASH when project was created                         | string    | `'1.1.2'`                                   |
| `proj_file`       | path to project file                                             | string    | `'C:\MyDataFolder\experiment_01\data.mash'` |


### Video-related fields
{: .no_toc }

| `is_movie`   | a video file is/isn't attached to the project     | 1/0           | 1                                           |
| `movie_file` | path to video file                                | string        | `'C:\MyDataFolder\experiment_01\data.sira'` |
| `movie_dim`  | video dimensions in pixel (width,height)          | 1-by-2 double | `[256,256]`                                 |
| `movie_dat`  | parameters used to read pixel data in video file  | 1-by-3 cell   |                                             |
| `frame_rate` | acquisition **time** of one video frame in second | double        | `0.1`                                       |


### Experiment settings fields
{: .no_toc }

| `nb_channel`     | number of spectroscopic channel `nC`                                   | double           | `2`                                                                                                        |
| `nb_excitations` | number of alternated lasers `nL`                                       | double           | `2`                                                                                                        |
| `excitations`    | excitation wavelengths                                                 | 1-by-`nL` double | `[638,532]`                                                                                                |
| `chanExc`        | laser indexes for channel direct excitation                            | 1-by-`nC` double | channel 1 is directly excited by 2nd laser: `[2,1]`                                                        |
| `labels`         | labels for spectroscopic channel                                       | 1-by-`nC` cell   | `{ 'Cy3','Cy5' }`                                                                                          |
| `colours`        | RGB colors used to plot trajectories and labels (intensities, FRET, S) | 1-by-3 cell      | for 2 channel and 2 alternated lasers: `{ {[0,0.5,0],[0.5,0.5,0];[0,1,0],[1,1,0]}, [0,0,0], [0,0,1] }`     |
|`exp_parameters`  | a number `nP` of user-defined project parameters (name, value, units)  | `nP`-by-3 cell   | `{ 'Project title','data_D135_01',[]; 'Molecule name','D135',[]; '[Mg2+]','100','mM'; '[K+]','500','mM' }` |


### Molecule fields
{: .no_toc }

| `is_coord`        | molecule coordinates are/aren't attached to the project            | 1/0                  | `1`                                                                                       |
| `coord`           | a number `M` of molecule coordinates (x,y)                         | `M`-by-`2*nC` double |                                                                                           |
| `coord_file`      | file from which molecule coordinates were read                     | string               | `'C:\MyDataFolder\experiment_01\video_processing\coordinates\transformed\data_ave.coord'` |
| `coord_imp_param` | parameters that were used to import molecule coordinates from file | 1-by-`nC` cell       |                                                                                           |
| `coord_incl`      | molecule is selected/unselected                                    | 1-by-`M` true/false  |                                                                                           |
| `molTag`          | molecule's tag (1,2 or 3)                                          | 1-by-`M` double      |                                                                                           |
| `molTagNames`     | default tag  name                                                  | cell array           | `{ static, dynamic, D-only, A-only }`                                                     |
| `molTagClr`       | hexadecimal default tag colors                                     | cell array           | `{ '#B3D9FF, '#0066CC }`                                                                  |


### Intensity fields
{: .no_toc }

| `intensities`           | raw intensity trajectories with a number `L` of data point       | `L`-by-`nC*M` double  |         |
| `pix_intgr`             | pixel area size and number of pixels used to integrate intensity | 1-by-2 double         | `[5,8]` |
| `cnt_p_pix`             | units are/aren't counts per pixel                                | 1/0                   | `1`     |
| `cnt_p_sec`             | units are/aren't counts per second                               | 1/0                   | `1`     |
| `intensities_bgCorr`    | background-corrected intensity trajectories                      | `L`-by-`nC*M` double  |         |
| `intensities_crossCorr` | background- & cross-talk-corrected intensity trajectories        | `L`-by-`nC*M` double  |         |
| `intensities_denoise`   | corrected and smoothed intensity trajectories                    | `L`-by-`nC*M` double  |         |
| `intensities_DTA`       | discretized intensity trajectories                               | `L`-by-`nC*M` double  |         |
| `bool_intensities`      | included/ignored intensity data points                           | `L`-by-`M` true/false |         |


### FRET- and stoichiometry- fields
{: .no_toc }

| `FRET`     | a number `nF` of different FRET pair channel indexes for FRET calculations | `nF`-by-2 double     | FRET from channel 1 to 2: `[1,2]` |
| `FRET_DTA` | discretized FRET trajectories                                              | `L`-by-`nF*M` double |                                   |
| `S`        | a number `nS` of different channel indexes for stoichiometry calculations  | 1-by-`nS` double     | S of channel 1: `[1]`             |
| `S_DTA`    | discretized stoichiometry trajectories                                     | `L`-by-`nS*M` double |                                   |


### Analysis settings
{: .no_toc }

| `prmTT`  | parameter settings of module Trace processing                                             | 1-by-`M` cell  |  |
| `expTT`  | export settings in Trace processing                                                       | struct         |  |
| `prmThm` | parameter settings of module Histogram analysis treating a number `nH` of different data  | 1-by-`nH` cell |  |
| `expThm` | export settings of module Histogram analysis                                              | empty          |  |
| `prmTDP` | parameter settings of module Transition analysis treating a number `nT` of different data | 1-by-`nT` cell |  |
| `expTDP` | export settings of module Transition analysis                                             | 1-by-3 cell    |  |

For more information about how the analysis settings fields are structured, please refer to the respective function in the source code:

```
MASH-FRET/source/project/setDefPrm_traces.m
MASH-FRET/source/project/setDefPrm_thm.m
MASH-FRET/source/project/setDefPrm_TDP.m
```


---

## Compatibility

MASH project files are MATLAB binary files and can be imported in MATLAB's workspace by typing in MATLAB's command window:

```matlab
load('datafolder\project-file.mash','-mat');
```

and replacing `datafolder\project-file.mash` by your actual file name and directory.

