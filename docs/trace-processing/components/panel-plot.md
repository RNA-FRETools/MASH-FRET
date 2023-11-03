---
layout: default
title: Plot
parent: Components
grand_parent: Trace processing
nav_order: 1
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Plot
{: .no_toc }

Plot is the second panel of Trace processing. 
Access the panel content by pressing 
![Bottom arrow](../../assets/images/gui/interface-but-bottomarrow.png). 
The panel closes automatically after other panels open or after pressing 
![Top arrow](../../assets/images/gui/interface-but-toparrow.png). 

Use this panel to define which time traces to plot in the 
[Visualization area](area-visualization.html).

<a class="plain" href="../../assets/images/gui/TP-panel-plot.png"><img src="../../assets/images/gui/TP-panel-plot.png" style="max-width: 238px;"/></a>


## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Plot in top axes

Use these menus to define the intensity data to plot in 
[Intensity-time traces and histograms](area-visualization.html#intensity-time-traces-and-histograms).

<a class="plain" href="../../assets/images/gui/TP-panel-plot-top.png"><img src="../../assets/images/gui/TP-panel-plot-top.png" style="max-width: 228px;"/></a>

To plot intensity data upon illumination of a particular laser, select the corresponding wavelength in menu **(a)**, or select the option `all` to plot intensities upon all laser illuminations.

To plot intensity data of a particular emitter, select the corresponding detection channel in menu **(b)**, or select the option `all` to plot all emitter intensities.

The upper and lower limits of the intensity axis can be set to constant values by activating the option in **(c)** and setting the limits in **(d)** and **(e)**. Intensity units are defined in menu `Units`>`intensities` of the 
[menu bar](../../Getting_started.html#interface).


---

## Plot in bottom axes

Use this menu to define the intensity ratios to plot in 
[Ratio-time traces and histograms](area-visualization.html#ratio-time-traces-and-histograms).

To plot the FRET data of a particular donor-acceptor pair, or the stoichiometry-time trace of a particular emitter, select the corresponding data in the list. 

To plot only FRET data of all donor-acceptor pairs, select the option `all FRET` in the list.

To plot only stoichiometry data of all emitters, select the option `all S` in the list.

To plot intensity ratio data, select the option `all`.


---

## Time axis

Use this interface to define the time axis of time-traces.

<a class="plain" href="../../assets/images/gui/TP-panel-plot-xaxis.png"><img src="../../assets/images/gui/TP-panel-plot-xaxis.png" style="max-width: 236px;"/></a>

If needed, intensity-time traces can be truncated at the beginning of the time axis by setting the new starting point in **(b)**. 
To keep the starting point fixed for all single molecules, activate the option in **(a)**.

The starting point is given in time units defined in the menu `Units` of the 
[menu bar](Getting_started.html#interface).



