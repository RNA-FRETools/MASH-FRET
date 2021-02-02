---
layout: default
title: (*.log) Parameters from trace processing
parent: Output files
nav_exclude: 1
nav_order: 15
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Parameter file from trace processing
{: .no_toc }

Processing parameter files are ASCII files with the extension `.log`. They are usually found in the main`/traces_processing/parameters` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Processing parameter files are molecule-specific and contain the methods and parameters used to process the exported data set.

They are created in the `/trace_processing/parameters` analysis sub-folder when exporting parameters to an external file in window 
[Export options](../trace-processing/functionalities/set-export-options.html) of module Trace processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>project file</u> loaded in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list), and is appended with the extension `_mol[n]of[N]` with `[n]` the index of the molecule written in the file and `[N]` the total number of exported molecules.


---

## Structure

Processing methods and parameters are recorded using the following structure:

### Project
{: .no_toc }

Project parameters are common to all type of processing and are written such as:

```
> project file: 
> project created with MASH-FRET version:
> project creation:
> last project modification:
> file exported with MASH-FRET version:
```


### Video processing
{: .no_toc }

These parameters consist in the video and coordinates used to build initial intensity-time traces. 
Video processing parameters common to all types of import are:

```
> frame rate:
> pixel integration area:
> number of brightest pixels integrated:
```

If traces were exported form panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing or if a single molecule video (SMV) was imported together with ASCII traces in module Trace processing according to the 
[Import options](../trace-processing/functionalities/set-import-options.html), the SMV file is written such as:

```
> movie file: C:\MyDataFolder\experiment_01\simulations\sim.sira
```

Similarly, if a traces were exported form panel 
[Intensity integration](../video-processing/panels/panel-intensity-integration.html#create-and-export-intensity-time-traces) of module Video processing or if single molecule coordinates were imported together with ASCII traces in module Trace processing according to the 
[Import options](../trace-processing/functionalities/set-import-options.html), the coordinates file is written such as:

```
> coordinates file: C:\MyDataFolder\experiment_01\video_processing\coordinates\transformed\sim_ave.coord
```


### Experiment settings
{: .no_toc }

Experiment settings are common to all types of projects and are written such as:

```
> alternated lasers used in experiment (chronological order):
> emitter-specific detection channels and illuminations:
> experimental parameters:
> FRET calculations:
> stoichiometry calculations:
```


### Molecule
{: .no_toc }

These parameters consist in the molecule status in the sample, as well as the methods and parameters used to process intensity-time traces. 
Molecule parameters  are common to all types of processing and are written such as:

```
> molecule index:
> molecule label:
> molecule coordinates: 
> intensity units:
> background correction: 
> factor corrections: 
> denoising:
> photobleaching correction:
> discretisation:
```

Factor correction parameters depends on the experiment settings.
Factor correction parameters written in file for experiments with more than one detection channel are: 

```
	bleedthrough coefficients of emitter [Eee0]: Bt=[...] in [Eee1]
```

or otherwise:

```
	no bleedthrough possible
```

with `[Eee0]` and `[Eee1]` the labels of two different detection channels.

Factor correction parameters written in file for experiments with several alternated laser are: 

```
	direct excitation coefficients of emitter [Eee0]: DE=[...] at [L]nm
```

or, in case emitter-specific excitation laser wavelength is undefined:

```
	direct excitation coefficients of emitter [Eee0]: not possible (emitter-specific illumination not defined or used in experiment)
```

or otherwise:

```
	no direct excitation possible
```

with `[Eee0]` the label of a detection channel and `[L]` an unspecific excitation laser wavelength.

Factor correction parameters written in file for project including FRET calculations: 

```
	correction factors for FRET_[Ddd]>[Aaa]: gamma=..., beta=...
```

or otherwise:

```
	no gamma or beta correction possible
```

with `[Ddd]` and `[Aaa]` the labels of detection channels where donor and acceptor fluorescence are specifically detected.

