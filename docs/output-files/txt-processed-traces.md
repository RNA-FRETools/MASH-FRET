---
layout: default
title: (*.txt) Traces from trace processing
parent: Output files
nav_exclude: 1
nav_order: 33
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Trace file from trace processing
{: .no_toc }

Processed trace files are ASCII files with the extension `.txt`. They are usually found in the main`/traces_processing/traces_ASCII` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

These trace files are written in ASCII format and contain processed intensity- and intensity-ratio-time traces.

They are created in the `/trace_processing/traces_ASCII` analysis sub-folder after exporting ASCII traces in panel 
[Sample management](../trace-processing/panels/panel-sample-management.html#export-processed-data) of module Video processing.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>project file</u> loaded in 
[Trace processing](../trace-processing/panels/area-project-management.html#project-list), and is appended with the extension `_mol[n]of[N]` with `[n]` the index of the molecule written in the file and `[N]` the total number of exported molecules.


---

## Structure

If the 
[Export options]() include processing parameters in the trace file header, processing parameters are first written as described in 
[Processing parameter files](log-processing.parameters.html#structure).

Intensity-time traces are organized column-wise with:
* columns `time at [L]nm` containing time points upon illumination with laser wavelength `L` (in second)
* columns `frame at [L]nm` containing frame indexes upon illumination with laser wavelength `L` (in second)
* columns `I_[i] at [L]nm` and `discr.I_[i] at [L]nm` containing channel- and illumination-specific intensity-time traces and state trajectories, with `[i]` the channel index
* columns `FRET_[D]>[A]` and `discr.FRET_[D]>[A]` containing FRET-time traces and state trajectories, with `[D]` and `[A]` the channel indexes where donor and acceptor fluorescence of the FRET pair are specifically detected
* columns `S_[D]>[A]` and `discr.S_[D]>[A]` containing stoichiometry-time traces and state trajectories associated with the FRET pair where `[D]` and `[A]` are the channel indexes where donor and acceptor fluorescence of the FRET pair are specifically detected

```
time at 532nm	frame at 532nm	I_1 at 532nm(counts)	I_2 at 532nm(counts)	I_3 at 532nm(counts)	time at 638nm	frame at 638nm	I_1 at 638nm(counts)	I_2 at 638nm(counts)	I_3 at 638nm(counts)	time at 532nm	frame at 532nm	FRET_1>2	discr.FRET_1>2	time at 532nm	frame at 532nm	S_1>2		discr.S_1>2
1.017500e-01	1		-3.162304e+02		-1.248107e+02		-4.999781e+01		2.035000e-01	2		-5.944420e+01		-2.638393e+00		1.688481e+01		1.017500e-01	1		2.541767e-01	-7.502669e-01	1.017500e-01	1		9.157130e-01	1.017316e+00
3.052500e-01	3		-1.323042e+01		-3.182207e+02		-1.269978e+02		4.070000e-01	4		-2.454442e+02		1.573616e+02		1.368848e+02		3.052500e-01	3		6.941246e-01	-7.502669e-01	3.052500e-01	3		1.119132e+00	1.017316e+00
5.087500e-01	5		-7.123042e+01		-4.542065e+01		-3.699781e+01		6.105000e-01	6		-2.514442e+02		-2.963839e+01		-1.181152e+02		5.087500e-01	5		2.956133e-01	-7.502669e-01	5.087500e-01	5		2.779232e-01	8.296395e-01
```

For consistency, intensities are always exported as the sum of the brightest pixel intensities per video frame, regardless the units defined in
[Intensity units](../trace-processing/panels/panel-plot.html#intensity-units).


---

## Compatibility

Processed trace files can be imported in modules 
[Trace processing](../trace-processing/workflow.html#import-single-molecule-data) and 
[Transition analysis](../transition-analysis/workflow.html#import-single-molecule-data) for analysis by adjusting the 
[Import options](../trace-processing/functionalities/set-import-options.html) to the actual file structure.

For ALEX experiments, files must be restructured prior import in MASH; see 
[Restructure ALEX data](../trace-processing/functionalities/merge-projects.html#restructure-alex-data) for help.
