---
layout: default
title: Plot
parent: Components
grand_parent: Trace processing
nav_order: 3
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

<a class="plain" href="../../assets/images/gui/TP-panel-plot.png"><img src="../../assets/images/gui/TP-panel-plot.png" style="max-width: 200px;"/></a>


## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Plot in top axes

Use these menus to define the intensity data to plot in 
[Intensity-time traces and histograms](area-visualization.html#intensity-time-traces-and-histograms).

<a class="plain" href="../../assets/images/gui/TP-panel-plot-top.png"><img src="../../assets/images/gui/TP-panel-plot-top.png" style="max-width: 165px;"/></a>

To plot intensity data upon illumination of a particular laser, select the corresponding wavelength in menu **(a)**, or select the option `all` to plot intensities upon all laser illuminations.

To plot intensity data of a particular emitter, select the corresponding detection channel in menu **(b)**, or select the option `all` to plot all emitter intensities.


---

## Plot in bottom axes

Use this menu to define the intensity ratios to plot in 
[Ratio-time traces and histograms](area-visualization.html#ratio-time-traces-and-histograms).

To plot the FRET data of a particular donor-acceptor pair, or the stoichiometry-time trace of a particular emitter, select the corresponding data in the list. 

To plot only FRET data of all donor-acceptor pairs, select the option `all FRET` in the list.

To plot only stoichiometry data of all emitters, select the option `all S` in the list.

To plot intensity ratio data, select the option `all`.


---

## Intensity units

Use this interface to define the intensity units used for plot and in processing parameters.

<a class="plain" href="../../assets/images/gui/TP-panel-plot-intunits.png"><img src="../../assets/images/gui/TP-panel-plot-intunits.png" style="max-width: 158px;"/></a>

Intensities 
[*&#956;*<sub>ic</sub>](){: .math_var} are written in the MASH project as image counts (ic) per video frame recorded with an acquisition time 
[*t*<sub>exp</sub>](){: .math_var}, and are calculated as the sum of 
[*n*<sub>pix</sub>](){: .math_var} pixels; see
[Integration parameters](../../video-processing/panels/panel-intensity-integration.html#integration-parameters) for more information.

Intensity units can be converted to image counts per seconds and/or per pixels, by respectively activating the option in **(a)** and/or **(b)**, and such as:

{: .equation}
<img src="../../assets/images/equations/TP-eq-units-01.gif" alt="\mu_{\textup{ic,s}} = \frac{\mu_{\textup{ic}}}{t_{\textup{exp}}}"><br>
<img src="../../assets/images/equations/TP-eq-units-02.gif" alt="\mu_{\textup{ic,pix}} = \frac{\mu_{\textup{ic}}}{n_{\textup{pix}}}">

with 
[*&#956;*<sub>ic,s</sub>](){: .math_var} intensities in counts per second  and 
[*&#956;*<sub>ic,pix</sub>](){: .math_var} per pixel.

Units conversion is valid only for display to avoid the confusion when merging ASCII files previously exported from Trace processing.

Units conversion concerns intensity-time trace and histogram plots, background intensities in panel 
[Background correction](panel-background-correction.html#background-intensity), as well as parameters of threshold methods in panels 
[Find states](panel-find-states.html#method-parameters) and 
[Photobleaching](panel-photobleaching.html#automatic-detection-settings).


---

## Time axis

Use this interface to define the time axis of time-traces.

<a class="plain" href="../../assets/images/gui/TP-panel-plot-xaxis.png"><img src="../../assets/images/gui/TP-panel-plot-xaxis.png" style="max-width: 165px;"/></a>

If needed, intensity-time traces can be truncated at the beginning of the time axis by setting the new starting point in **(b)**. 
To keep the starting point fixed for all single molecules, activate the option in **(a)**.

The time axis can display time units (in second) or video frame indexes by respectively activating or deactivating the option in **(c)**. 
Processing parameters affected by this options are the starting point set in **(b)** as well as the cutoff values in panel 
[Photobleaching cutoff](panel-photobleaching.html#photobleaching-cutoff) and in 
[Gamma factor settings](panel-factor-corrections#gamma-factor-settings).



