---
layout: default
title: (*.txt) Transition density coordinates
parent: /output-files.html
nav_order: 36
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Transition density coordinates files
{: .no_toc }

Transition density coordinates files are ASCII files with the extension `.txt`. They are usually found in the main`/transition_analysis/clustering` folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

The Transition density coordinates files are written in an ASCII format and contains the settings used to build the TDP and the resulting 3D-coordinates.

They are created in the `/transition_analysis/clustering` analysis sub-folder after exporting ASCII coordinates (x,y,occurrence) from widow 
[Export options](../transition-analysis/functionalities/set-export-options.html#transition-density-plot-tdp) of module Transition analysis.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the selected <u>project file</u> and is appended with the extension `_[Ddd]_coord`, where `[Ddd]` is the data type written in the file.

Data types supported in transition density coordinates files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[Eee]`: stoichiometry of emitter detected in channel labelled `[Eee]`

The extension `_[Ttt]` is added to the data type `[Ddd]` if a particular subgroup of molecules is analyzed, with `[Ttt]` the corresponding molecule tag.

---

## Structure

TDP settings and 3D-coordinates are written using the following structure:


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

### 3D-coordinates
{: .no_toc }

TDP 3D-coordinates are organized column-wise such as:
* columns `before trans.` and `after trans.` containing respectively the x- and y-axis of the TDP
* column `occurence` containing the z-values of the TDP

```
before trans.	after trans.	occurence
-1.950000e-01	-1.950000e-01	0
-1.950000e-01	-1.850000e-01	0
-1.950000e-01	-1.750000e-01	0
```

