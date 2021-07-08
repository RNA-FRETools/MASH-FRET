---
layout: default
title: (*.log) Parameters from simulation
parent: Output files
nav_exclude: 1
nav_order: 16
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Parameter file from simulation
{: .no_toc }

Simulation parameters files are ASCII files with the extension `.log`. They are usually found in the main`/simulations` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Simulation parameter files contain the methods and parameters used to simulate the exported data set.

They are created in the `/simulations` analysis sub-folder when exporting simulation parameters in panel 
[Export options](../simulation/panels/panel-export-options.html) of module Simulation.


---

## File name

The file is named by the user during the export process, and is appended with the extension `_param`.


---

## Structure

Simulation methods and parameters are recorded using the following structure:

### Video parameters
{: .no_toc }

Video parameters common to all type of simulations are:

```
> frame rate (s-1)
> trace length (frame)
> movie dimension (pixels)
> pixel dimension (um)
> bit rate
> camera noise model
```

Camera noise parameters depends on the noise model used.
Parameters written in file for `P` model are: 

```
	parameter mu_ic,dark
	parameter eta
	parameter K
```

Parameters written in file for `N` model are: 

```
	parameter mu_ic,dark
	parameter sigma_d
	parameter eta
	parameter sigma_q
	parameter K
```

Parameters written in file for `NExpN` model are: 

```
	parameter mu_ic,dark
	parameter A_CIC
	parameter eta
	parameter sigma_ic
	parameter K
	parameter tau_CIC
```

Parameters written in file for `Offset only` model are: 

```
	parameter mu_ic,dark
	parameter K
	parameter eta
```

Parameters written in file for `PGN` model are: 

```
	parameter mu_ic,dark
	parameter sigma_d
	parameter eta
	parameter CIC
	parameter g
	parameter s
```


### Presets
{: .no_toc }

If a pre-set parameter file was used for the simulation, the source file is written such as:

```
> input parameters file: C:\MyDataFolder\experiment_01\simulations\sim_param.mat
```


### Molecules
{: .no_toc }

Molecule parameters common to all simulation types are:

```
> number of traces
> number of states
> state values
> transitions rates (sec-1)
> total intensity
> gamma factor
> donor bleedthrough coefficient
> acceptor bleedthrough coefficient
> donor direct excitation coefficient
> acceptor direct excitation coefficient
```

If an external coordinates file was used for the simulation, the source file is written such as:

```
> input coordinates file: C:\MyDataFolder\experiment_01\simulations\coordinates\sim.crd
```

If the photobleaching option was activated in the simulation, parameters written in file are:

```
> photobleaching time decay
```

### Experimental setup
{: .no_toc }

If the point spread function option is activated, parameters written in file are:

```
> donor PSF standard deviation (um)
> acceptor PSF standard deviation  (um)
> background type
```

Background parameters depends on the type of background.
Parameters written in file for `Uniform` type are:

```
> fluorescent background intensity in donor channel
> fluorescent background intensity in acceptor channel
```

Parameters written in file for `2D Gaussian profile` type are:

```
> fluorescent background intensity in donor channel
> fluorescent background intensity in acceptor channel
> TIRF (x,y) widths (pixel)
```

If a background image file was used for the simulation of a `Pattern` type, the source file is written such as:

```
> background image file: C:\MyDataFolder\camera_noise\video_processing\average_images\background_ave.png
```

If the exponentially decaying background option is activated, parameters written in file are:

```
> background decay (s)
> initial background amplitude
```

### Export options
{: .no_toc }

Export options written in file are:

```
> export traces
> export *.sira video
> export *.avi video
> export ideal traces
> export dwell-times
> export coordinates
```
