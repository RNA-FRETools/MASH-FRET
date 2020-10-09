---
layout: default
title: (*.fit) Dwell time fit
parent: /output-files.html
nav_order: 9
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Dwell time fit files
{: .no_toc }

Dwell time fit files are ASCII files with the extension `.fit`. They are usually found in the main`/transition_analysis/kinetics` folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Dwell time fit files are written in ASCII format and contain methods, parameters and results of the dwell time histogram fit.

They are created in the `/transition_analysis/kinetics` analysis sub-folder when exporting fitting curves & parameters and/or BOBA FRET results from window 
[Export options](../transition-analysis/functionalities/set-export-options.html) in module Transition analysis.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the selected <u>project file</u> and is appended with the extension `_[Ddd]_[j]to[j']`, where `[Ddd]` is the data type written in the file and `[j]` and `[j']` are the respective x- and y- coordinates of the transition cluster.

Data types supported in dwell time fit files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[Eee]`: stoichiometry of emitter detected in channel labelled `[Eee]`

The extension `_[Ttt]` is added to the data type `[Ddd]` if a particular subgroup of molecules is analyzed, with `[Ttt]` the corresponding molecule tag.

---

## Structure

Fitting methods, parameters and results are written using the following structure:

### Method settings
{: .no_toc }

Method settings common to all type of fit include the fitting function which is written in the first line of the file such as:

```
equation: [...]
```

The starting guess and bounds for fitting parameters depends on the function used to fit the dwell time histogram.
If the dwell time histogram is fitted with a sum of exponential functions, starting parameters are written such as:

```
starting parameters:
	parameter	lower	start	upper
	a_[z]:		[...]	[...]	[...]
	b_[z](s):	[...]	[...]	[...]
```

with `a_[z]` and `b_[z]` the respective amplitude and decay constant (in second) of the `[z]`<sup>th</sup> exponential component in the mixture.

If the dwell time histogram is fitted with a stretched exponential function, a third parameter is added and starting parameters are written such as:

```
starting parameters:
	parameter	lower	start	upper
	a:		[...]	[...]	[...]
	b(s):		[...]	[...]	[...]
	c:		[...]	[...]	[...]
```

with `a`, `b` and `c` the respective amplitude, decay constant (in second) and beta exponent of the stretched exponential.

If method settings include dwell time bootstrapping, bootstrap parameters are added, such as:

```
bootstrap parameters:
	weighting: [...]
	number of samples: [...]
	number of replicates: [...]
```

### Fitting results
{: .no_toc }

Fitting results include the fitting parameters for the original dwell time histogram and  depends on the function used to fit the dwell time histogram.
If the dwell time histogram is fitted with a sum of exponential functions, fitting parameters are written such as:

```
fitting results (reference):
	a_[z]:	[...]
	b_[z](s):	[...]
```

If the dwell time histogram is fitted with a stretched exponential, fitting parameters are written such as:

```
fitting results (reference):
	a:	[...]
	b(s):	[...]
	c:	[...]
```

If method settings include dwell time bootstrapping, the bootstrap mean and standard deviation of the fitting parameters are written such as:

```
fitting results (bootstrap):
	parameter	mean	sigma
	a_[z]:		[...]	[...]
	b_[z](s):	[...]	[...]

```

after fitting a sum of exponential functions, or as:

```
fitting results (bootstrap):
	parameter	mean	sigma
	a:		[...]	[...]
	b(s):		[...]	[...]
	c:		[...]	[...]
```

after fitting a stretched exponential function.

