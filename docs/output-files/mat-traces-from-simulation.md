---
layout: default
title: (*.mat) Traces from simulation
parent: /output-files.html
nav_order: 19
nav_exclude: 1
---


# Trace file from simulation
{: .no_toc }

Trace files from simulation are binary Matlab files with the extension `.mat`. They are usually found in the main`/simulation` analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

This trace file contains the simulated data of all molecules written in MATLAB binary format.
It includes molecule coordinates in the video, simulated intensity-time traces and intensity units.

It is created in the `/simulation` analysis sub-folder after exporting *.mat traces in panel 
[Export options](..//simulation/panels/panel-export-options.html) of module Simulation.


---

## File name

The file is named by the user during the export process.


---

## Structure

The simulated trace file consists in a data structure with the following fields:

| field name  | description                                             | data type              | value               |
| ----------- | ------------------------------------------------------- | ---------------------- | ------------------- |
| `coord`     | coordinates in the simulated video of the `N` molecules | `N`-by-4 double        |                     |
| `Trace_all` | simulated intensity-time traces of length `L`           | `L`-by-(2+2`N`) double |                     |
| `units`     | intensity units                                         | string                 | `a.u.` or `photons` |

`coord` is organized in a column-wise fashion, with x- and y-coordinates in donor channel written in columns 1 and 2 respectively, and written in columns 3 and 4 for the acceptor channel.

`Trace_all` is also organized in a column-wise fashion, with column 1 containing time data column 2 the frame indexes.
Intensities are written in the following columns, with donor intensities in odd- and acceptor in even-indexed columns respectively.

---

## Compatibility

Simulated trace files are MATLAB binary files and can be imported in MATLAB's workspace by simply drag-and-dropping the file, or by typing in MATLAB's command window:

```matlab
load('datafolder\traces.mat','-mat');
```

and replacing `datafolder\traces.mat` by your actual file name and directory.
