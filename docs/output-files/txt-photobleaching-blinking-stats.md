---
layout: default
title: (*.txt) Photobleaching/blinking stats
parent: Output files
nav_exclude: 1
nav_order: 32
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Photobleaching/blinking stats files
{: .no_toc }

Photobleaching/blinking stats files are ASCII files with the extension `.txt`. They are usually found in the main analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Photobleaching/blinking stats files are emitter- and data-specific. They contain statistics on times until emitter photobleaching or blinking dwell times detected in Trace processing.

They are created in the analysis root folder when exporting results from window 
[Stats](../trace-processing/components/panel-photobleaching.html#stats) of module Trace processing.


---

## File name

The file is named by the user during the export process.
By default, the file is named after the selected <u>project file</u>.

The file name is appended with the extension `_stats_[Ddd]_[Eee]` where `[Ddd]` is `bleach`, `blink-off` or `blink-on` whether the stats concern time until photobleaching, dwell times in the "off" state or dwell times in the "on" state. `[Eee]` is the emitter label as defined in the [Experiment settings](../tutorials/set-experiment-settings/import-trajectories.html#channels).


---

## Structure

The statistics are organized column-wise with:
* column `bin centers` containing the centers of the dwell time histogram bins, given in time units defined in interface's menu `Units`
* column `bin edges` containing the edges of the dwell time histogram bins, given in time units defined in interface's menu `Units`
* column `count` containing dwell time histogram counts
* column `1-CDF` containing the survival dwell time probability (complementary of the cumulative probability)
* column `fit` containing the exponential fit curve that uses the bootstrap mean of the fit parameters (equation is given in the header with the time constant given in time units defined in interface's menu `Units`
* column `lower bound` containing the exponential fit curve that uses the lower bound (-1$$\sigma$$) of the confidence interval of fit parameters (equation is given in the header with the time constant given in time units defined in interface's menu `Units`
* column `upper bound` containing the exponential fit curve that uses the upper bound (+1$$\sigma$$) of the confidence interval of fit parameters (equation is given in the header with the time constant given in time units defined in interface's menu `Units`)

```
bin centers (time steps)  bin edges (time steps)  count 1-CDF fit 1.70*exp(-t/1702.45)  lower bound (1.70-0.25)exp(-t/(1702.45-298.47)) upper bound (1.70+0.25)exp(-t/(1702.45+298.47))
2.038889e+01  1 0 1 1.680086e+00  1.424994e+00  1.934999e+00
5.916667e+01  3.977778e+01  0 1 1.642250e+00  1.386174e+00  1.897860e+00
9.794444e+01  7.855556e+01  0 1 1.605266e+00  1.348412e+00  1.861433e+00
1.367222e+02  1.173333e+02  0 1 1.569115e+00  1.311679e+00  1.825706e+00
1.755000e+02  1.561111e+02  0 1 1.533779e+00  1.275946e+00  1.790665e+00
```
