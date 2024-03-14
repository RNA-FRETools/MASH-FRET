---
layout: default
title: Intensity integration
parent: Components
grand_parent: Video processing
nav_order: 4
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Intensity integration
{: .no_toc }

Intensity integration is the fourth panel of module Video processing. 
Access the panel content by pressing 
![Bottom arrow](../../assets/images/gui/interface-but-bottomarrow.png). 
The panel closes automatically after other panels open or after pressing 
![Top arrow](../../assets/images/gui/interface-but-toparrow.png). 

Use this panel to create and export single molecule intensity-time traces.

<a class="plain" href="../../assets/images/gui/VP-panel-integration.png"><img src="../../assets/images/gui/VP-panel-integration.png" style="max-width: 316px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Input coordinates

Use this interface to import single molecule coordinates used to build intensity-time traces.

<a class="plain" href="../../assets/images/gui/VP-panel-integration-loadcoord.png"><img src="../../assets/images/gui/VP-panel-integration-loadcoord.png" style="max-width: 296px;"/></a>

The calculation of intensity-time traces requires the single molecule coordinates transformed in all video channels. 
The availability of single moelcule coordinates are indicated by the icon located in **(a)** that displays <span style="color:rgb(0, 127, 0);">&#10004;</span> if data is available and <span style="color:rgb(255, 0, 0);">&#10006;</span> if data must still be calculated or imported. 

In case single molecule coordinates are unavailable:
* Start a spot finding procedure with 
[Spotfinder](panel-molecule-coordinates.html#spotfinder) and, for multi-channel video projects, transform spots coordinates in 
[Coordinates transformation](panel-molecule-coordinates.html#coordinates-transformation).
* Or, import molecule coordinates from an external file by pressing 
![Open](../../assets/images/gui/VP-but-open.png "Open") and selecting the corresponding file; coordinates are read according to the 
[Import options](#import-options) that can be accessed by pressing 
![Import options](../../assets/images/gui/VP-but-impopt.png).


### Import options
{: .no_toc }

Import options defined the way single molecule coordinates are read from file.

<a class="plain" href="../../assets/images/gui/VP-panel-integration-loadcoord-impopt.png"><img src="../../assets/images/gui/VP-panel-integration-loadcoord-impopt.png" style="max-width: 238px;"/></a>

Single molecule coordinates are coordinates co-localized in each channel, with each channel corresponding to a specific x-range.
The number of file header lines set in **(b)** is skipped before reading coordinates and channel-specific x- and y-coordinates are read from columns set in **(c)** and **(d)** respectively.

If all channel-specific data are organized in the same two columns, coordinates are sorted according to the specific x-range of each channel.

Save import settings by pressing 
![Ok](../../assets/images/gui/VP-but-ok.png).


---

## Integration parameters

Use this interface to define the settings for intensity calculation.

<a class="plain" href="../../assets/images/gui/VP-panel-integration-calculation.png"><img src="../../assets/images/gui/VP-panel-integration-calculation.png" style="max-width: 295px;"/></a>

To obtain the single molecule intensity at one particular frame or time point, a square area of dimension **(a)** pixels around the molecule coordinates is defined.
The positions of the **(b)** brightest pixels in the corresponding average sub-image are determined and used when summing up the **(b)** pixels in each frame.






