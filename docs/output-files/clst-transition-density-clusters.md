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

Method settings common to all types of clustering concern the clustering method, the cluster configuration as well as the cluster shapes, and are written as:

```
method: [...] clustering
constraint on clusters: [...]
diagonal clusters: [...]
cluster shape: [...]
bootstrapping: [...]
```

If the TDP is processed with `k-mean` clustering, the maximum number of k-mean iterations is written as:

```
max. number of iterations: [...]
```

If the TDP is processed with `GM` clustering, the number of E-M initializations and the type of likelihood calculation are written as:

```
number of model initialisations: [...]
likelihood: [...]
```

If TDP bootstrapping was used, the bootstrap parameters are written as:
```
number of samples: [...]
number of replicates: [...]
```

The maximum complexity of the cluster configuration depends on the cluster contraint that was used and is written as:
- for the `matrix` constraint:
```
max. number of states: [...]
```
- for the `symmetrical` constraint:
```
max. number of clusters in a half-TDP: [...]
```
- for the `free` constraint:
```
max. number of clusters: [...]
```

Finally, if the TDP is processed with `k-mean` or `simple` clustering, the starting guess for states and state-specific tolerance radii are listed as:
```
state [j]: [...], tolerance radius: [...]
```
with `[j]` the state indexe.

When the `symmetrical` or `free` cluster constraints were used, the state transitions associated to each cluster are listed as:
```
cluster [k]: state [j] to [j']
```
with `[k]` the cluster index and `[j]`/`[j']` the state indexes.

### Clustering results
{: .no_toc }

The final configuration complexity used to cluster transitions depends on the cluster constraint that was used and is written as:
- for the `matrix` constraint:
```
number of states in model: [...]
```
- for the `symmetrical` constraint:
```
number of clusters in model for half-TDP: [...]
```
- for the `simple` constraint:
```
number of clusters in model: [...]
```

with a special mention to the BIC value corresponding to the optimum model if the `GM` clustering was used.

Clustering results are ommon to all type of clustering and concern the inferred states (cluster centers), the associated time fraction in state trajectories, as well as the cluster populations relative to the the total number of clustered transitions.
Results are written such as:
```
state: [j]: [...], time fraction: [...]
cluster [k] (state [j] to state [j'] ), relative population: [...]
```
with `[k]` the cluster index and `[j]`/`[j']` the state indexes.

If method settings include TDP bootstrapping, the bootstrap mean and standard deviation of the most sufficient complexity across the samples is written as:
- for the `matrix` constraint:
```
bootstrapped number of states: [...] +/- [...]
```
- for the `symmetrical` constraint:
```
bootstrapped number of clusters in model for half-TDP: [...] +/- [...]
```
- for the `simple` constraint:
```
bootstrapped number of clusters: [...] +/- [...]
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
