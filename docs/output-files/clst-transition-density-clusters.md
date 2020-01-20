---
layout: default
title: (*.clst) Transition density clusters
parent: /output-files.html
nav_order: 3
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Transition density cluster files
{: .no_toc }

Transition density cluster files are ASCII files with the extension `.clst`. They are usually found in the main`/transition_analysis/clustering` folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

The transition density cluster files are written in ASCII format and contain methods, parameters and results of the TDP clustering.

They are created in the `/transition_analysis/clustering` analysis sub-folder when completing a clustering procedure and exporting clusters from window 
[Export options](../transition-analysis/functionalities/set-export-options.html) in module Transition analysis.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the selected <u>project file</u> and is appended with the extension `_[Ddd]`, where `[Ddd]` is the data type written in the file.

Data types supported in transition density cluster files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[D]to[A]`: stoichiometry associated to donor emitter detected in channel indexed `[D]` and acceptor emitter detected in channel indexed `[A]`

The extension `_[Ttt]` is added to the data type `[Ddd]` if a particular subgroup of molecules is analyzed, with `[Ttt]` the corresponding molecule tag.


---

## Structure

Clustering methods, parameters and results are written using the following structure:

### Method settings
{: .no_toc }

Method settings common to all type of clustering concern the clustering method, the maximum number of state to use in the cluster configuration, as well as TDP bootstrapping parameters, and are written such as:

```
method: [...]
number of max. states: [...]
bootstrapping: [...]
```

If the TDP is processed with k-mean clustering, the starting guess for states, state-specific tolerance radii and the maximum umber of k-mean iterations are written as:

```
state [j]:[...], tolerance radius: [...]
max. number of k-mean iterations: [...]
```

If the TDP is processed with 2D Gaussian mixture model-based clustering, the cluster shape and the number of E-M initializations are written as:

```
cluster shape: [...]
number of model initialisations: [...]
```

### Clustering results
{: .no_toc }

Clustering results common to all type of clustering concern the number of states used to cluster transitions, as well as the inferred states (or cluster centers) and corresponding time fraction in state trajectories.
Results are written such as:

```
number of states in model: [...]
state [j]: [...], time fraction: [...]
```
with `[j]` the state index.

If method settings include TDP bootstrapping, the bootstrap mean and standard deviation of the most sufficient number of states across the samples is written as:

```
bootstrapped number of states: [...] +/- [...]
```

If the TDP is processed with 2D Gaussian mixture model-based clustering, optimum parameters of 2D-Gaussian in the model are added such as:

```
optimum model parameters:
	alpha_[j][j']	[...]
	sigma_11[j][j']	[...]	[...]
			[...]	[...]
```

with `alpha_[j][j']` and `sigma_11[j][j']` the respective weight and covariance matrix of the 2D-Gaussian clustering transitions from state `[j]` to state `[j']`.

Finally, clustered data are written and organized in a column-wise fashion, where:
* the column `dwell-times(s)` contains state durations prior transition
* the columns `m` and `m*` contain state values prior and after transition respectively
* the column `molecule` contains the molecule indexes
* the columns `x(m)` and `x(m*)` contain the state coordinates in the TDP of states `m` and `m*` respectively, given in number of bins
* the columns `s_i` and `s_j` contain the state indexes to which the initial states `m` and `m*` are respectively assigned after clustering

```
dwell-times(s)	m		m*		molecule	x(m)	y(m*)	s_i	s_j
2.035000e+02	-3.242494e-02	NaN		1		0	0	0	0
5.189250e+01	-8.254869e-02	5.152345e-01	2		12	72	1	3
6.949525e+01	5.152345e-01	-8.254869e-02	2		72	12	3	1
```

State values after transitions are set to NaN when it is unknown, *e. g.* when the last dwell time of a state trajectory is truncated by the limited observation time, and TDP and cluster assignments are set to 0
