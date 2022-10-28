---
layout: default
title: Set export options
parent: Functionalities
grand_parent: Video processing
nav_order: 4
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Set export options
{: .no_toc }

Export options define the file formats in which time trace calculated in module Video processing will be written.

The window is accessed by pressing 
![EXPORT...](../../assets/images/gui/VP-but-export3p.png "EXPORT...") in the 
[Control area](../components/area-control.html).

Press 
![Next >>](../../assets/images/gui/TP-but-next-supsup.png "Next >>") to close the window and start writing files.

<a class="plain" href="../../assets/images/gui/VP-panel-integration-expopt.png"><img src="../../assets/images/gui/VP-panel-integration-expopt.png" style="max-width: 286px;"/></a>


## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## ASCII traces

Writes processing parameters and intensity-time traces to one or multiple ASCII files.

<a class="plain" href="../../assets/images/gui/VP-panel-integration-expopt-ascii.png"><img src="../../assets/images/gui/VP-panel-integration-expopt-ascii.png" style="max-width: 246px;"/></a>

Export single molecule data to one common ASCII file, by activating the option in **(a)**, and/or to individual ASCII files by activating **(b)**.

Exported single molecule data comprise: 
* experiment settings
* parameters and files used for intensity integration 
* single molecule coordinates
* single molecule intensity-time traces

See 
[Trace files from video](../../output-files/txt-traces-from-video.html) for more information.


---

## HaMMy-compatible

Writes single molecule intensity-time traces to one common ASCII file importable in the external software HaMMy (available 
[here](http://ha.med.jhmi.edu/resources/#1464200861600-0fad9996-bfd4)).

See 
[HaMMy trace files](../../output-files/dat-hammy-traces.html) for more information.


---

## vbFRET-compatible

Writes single molecule intensity-time traces to one common MATLAB binary file importable to the external software vbFRET (available 
[here](http://vbfret.sourceforge.net/)).

See 
[vbFRET trace files](../../output-files/mat-vbfret-traces.html) for more information.


---

## QUB-compatible

Writes single molecule intensity-time traces to one common ASCII file importable to the external software QUB (available 
[here](https://qub.mandelics.com/)).

See 
[QUB trace files from video](../../output-files/txt-qub-traces.html) for more information.


---

## SMART-compatible

Writes single molecule data to one common MATLAB binary file importable to the external software SMART (available 
[here](https://simtk.org/projects/smart)).

Exported single molecule data comprise: 
* single molecule coordinates
* single molecule intensity-time traces

See 
[SMART trace files](../../output-files/traces-smart-traces.html) for more information.


---

## ebFRET-compatible

Writes single molecule intensity-time traces to one common ASCII file importable to the external software ebFRET (available 
[here](http://ebfret.github.io/)).

See 
[ebFRET trace files](../../output-files/dat-ebfret-traces.html) for more information.

