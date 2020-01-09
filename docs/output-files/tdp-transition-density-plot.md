---
layout: default
title: (*.tdp) Transition density plot
parent: /output-files.html
nav_order: 26
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Transition density plot files
{: .no_toc }

Transition density plot files are ASCII files with the extension `.tdp`. They are usually found in the main`/transition_analysis/clustering` folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

The Transition density plot files are written in an ASCII format and contains the settings used to build the TDP and the resulting matrix.

They are created in the `/transition_analysis/clustering` analysis sub-folder after exporting ASCII matrix from widow 
[Export options](../transition-analysis/functionalities/set-export-options.html#transition-density-plot-tdp) of module Transition analysis.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the selected <u>project file</u> and is appended with an extension that depends on how the TDP was built:
* `_[Ddd]_gconv` if the TDP was convoluted with a Gaussian filter, and where `[Ddd]` is the data type written in the file
* `_[Ddd]` otherwise

Data types supported in transition density plot files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[Eee]`: stoichiometry of emitter detected in channel labelled `[Eee]`

A second extension `_[Ttt]` is added to the data type `[Ddd]` if a particular subgroup of molecules is analyzed, with `[Ttt]` the corresponding molecule tag.


---

## Structure

TDP settings and matrix are written using the following structure:


### TDP settings
{: .no_toc }

TDP settings include the type of count used to sort transitions into bins, as well as axis labels, limits and bin sizes.
Settings are written in the first line of the file such as:

```
one transition count per molecule: [...]
x-axis: value before transition (m)
y-axis: value after transition (m*)
z-axis: occurence of transition amp(m,m*)
x-lim: [...,...], x bin:  [...]
y-lim: [...,...], y bin:  [...]
```


### TDP matrix
{: .no_toc }

The TDP matrix is written in double precision and using carriage returns to mark the end of TDP rows, such as:

```
0	0	0		0		0		0		0		0		0	0	0		0		0		0	
0	0	0		0		0		0		0		0		0	0	0		0		0		0	
0	0	0		1.481500e-03	2.467831e-01	5.531231e-01	1.844347e+00	1.120159e-02	0	0	3.613416e-05	5.938901e-03	3.613416e-05	0	
0	0	1.517635e-03	4.929288e-01	4.056411e+01	9.125658e+01	3.045172e+02	1.849479e+00	0	0	6.155706e-03	1.011769e+00	1.209461e-02	3.613416e-05	
```