---
layout: default
title: Control area
parent: Components
grand_parent: Simulation
nav_order: 5
---

<img src="../../assets/images/logos/logo-simulation_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Control area
{: .no_toc }

The control area includes the three main control buttons of module Simulation. 

Use this area to generate, refresh or export data.

## Area components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Generate state sequences

Press 
![Generate](../../assets/images/gui/sim-but-generate.png "Generate") to generate new FRET state sequences.

Random FRET state sequences are automatically generated using the 
[State configuration](panel-molecules.html#state-configuration), the 
[Transition rates](panel-molecules.html#transition-rates) and the 
[Photobleaching](panel-molecules.html#photobleaching) parameters.

FRET state sequences are then automatically converted to intensity-time traces and single molecule images as in 
[Refresh intensities](#refresh-intensity-calculations).

See
[Simulation workflow](../workflow.html#generate-random-fret-state-sequences) for more information.


---

## Refresh intensity calculations

Press 
![Update](../../assets/images/gui/sim-but-update.png "Update") to refresh intensity-time trace and single molecule image calculations.

It updates calculations starting with generated noiseless FRET-time traces, including 
[Donor emission](panel-molecules.html#donor-emission), 
[Cross-talks](panel-molecules.html#cross-talks), 
[Background](panel-experimental-setup.html#background), 
[Camera SNR characteristics](panel-video-parameters.html#camera-snr-characteristics) and 
[Point spread functions](panel-experimental-setup.html#point-spread-functions).

See
[Simulation workflow](../workflow.html#create-intensity-trajectories-and-images) for more information about the simulation procedure.


---

## Export data

Press 
![Export](../../assets/images/gui/sim-but-export.png "Export") to export simulated data to file formats selected in 
[File options](panel-export-options.html#file-options), and to import simulated intensity trajectories in module 
[Trace processing](../../trace-processing.html). 

This will have for effect to unlock the three modules 
[Trace processing](../../trace-processing.html), 
[Histogram analysis](../../histogram-analysis.html) and 
[Transition analysis](../../transition-analysis.html) in the 
[Tool bar](../../Getting_started.html#interface) and to automatically process the first molecule of the set in 
[Trace processing](../../trace-processing.html).

