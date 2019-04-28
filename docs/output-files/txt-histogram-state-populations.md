---
layout: default
title: (*.txt) State populations from Histogram analysis
parent: /output-files.html
nav_order: 34
nav_exclude: 1
---


# State population files from Histogram analysis
{: .no_toc }

State population files are ASCII files with the extension `.txt`. They are usually found in the main`/histogram_analysis` folder.


## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

State population files are data-specific and contain methods, parameters and results of state population analysis.

They are created in the `/histogram_analysis` analysis sub-folder after state population analysis and when exporting results from the 
[Project management](../histogram-analysis/panels/area-management.html#export-analysis-results) area of module Histogram analysis.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>project file</u> loaded in 
[Histogram analysis](../histogram-analysis/panels/area-management.html#project-list), and is appended with an extension depending on the 
[Method settings](../histogram-analysis/panels/panel-state-populations.html#method-settings):
* `_[Ddd]_gauss` if populations are calculated with Gaussian fitting, where `[Ddd]` is the data type written in the file
* `_[Ddd]_thresh` if populations are calculated with thresholding

Data types supported in state population files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[Eee]`: stoichiometry of emitter detected in channel labelled `[Eee]`

A second extension `_discr` is added when state populations determined from state trajectories are written in the file.


---

## Structure

### Method settings
{: .no_toc }

The first lines in file are dedicated to the method settings and depends on how populations are calculated.

For population calculated with thresholding, threshold positions and limits of each state populations are given such as:

```
Thresholds:

- population [j]: from	[...]	to	[...]
```

with `[j]` the state index.

For population calculated with Gaussian fitting, the fitting equation and starting fit parameters are given such as:

```
Fitting equation:

Starting fit parameters with FWHM = o * 2*sqrt(2*ln(2)):
- Gaussian [j]:	A_[j]=[...]	mu_[j]=[...]	FWHM_[j]=[...]
```

with `A_[j]`, `mu_[j]`, `FWHM_[j]` containing the starting guess for the amplitude, mean and full width at half maximum of the `[j]`<sup>th</sup> Gaussian component.

If method settings include BOBA-FRET, bootstrapping parameters are given such as:

```
Bootstraping parameters:
```

### Analysis results
{: .no_toc }

The next lines contain the results of the state population analysis and depends on how populations are calculated.

For population analysis with thresholds, state relative populations are written at: 

```
Relative occurences:
```

If method include BOBA-FRET, bootstrap means and standard deviations of relative populations are written instead and at:

```
Bootstrap mean (relative occurences):
Bootstrap standard deviation (relative occurences):
```

and relative populations for each bootstrap sample is recorded in a column-wise fashion, such as:
* column `sample` containing sample indexes
* columns `population [j]` containing the relative population of state `[j]`

```
Bootstrap samples (relative occurences):
sample	population 1	population 2	population 3	
1	7.213219e-01	1.704264e-01	1.082517e-01	
2	6.873816e-01	1.948943e-01	1.177242e-01	
3	7.742181e-01	1.596652e-01	6.611676e-02	
```

For population analysis with Gaussian fitting, Gaussian parameters and relative populations from the fit are written in a column-wise fashion with:
* column `Gaussian` containing the Gaussian components index
* columns `A`, `mu`, `FWHM` containing the amplitudes, means and full widths at half maximum of Gaussian components in the mixture
* column `relative occurence` containing the state relative population

```
Fit parameters:
Gaussian	A	mu	FWHM	relative occurence
1	1.748954e-01	-7.565527e-03	7.943746e-02	6.315490e-01
2	1.747060e-02	1.590892e-01	5.012021e-01	3.684510e-01
```

If method include BOBA-FRET, bootstrap means and standard deviations of Gaussian parameters and relative populations are written instead, such as:

```
Bootstrap mean:
Gaussian	A	mu	FWHM	relative occurence
1	1.742200e-01	-7.892227e-03	7.939498e-02	6.270481e-01
2	1.799302e-02	1.632702e-01	5.146596e-01	3.729519e-01

Bootstrap standard deviation:
Gaussian	A	mu	FWHM	relative occurence
1	1.596279e-02	2.501341e-03	4.625068e-03	4.822357e-02
2	3.537184e-03	2.178907e-02	1.126754e-01	4.822357e-02
```

and fit parameters and relative populations for each bootstrap sample is recorded in a column-wise fashion, such as:
* column `sample` containing sample indexes
* columns `A_[j]`, `mu_[j]`, `FWHM_[j]` containing the amplitudes, means and full widths at half maximum of the `[j]`<sup>th</sup> Gaussian components in the mixture
* columns `relocc_[j]` containing the state relative population of the `[j]`<sup>th</sup> Gaussian components in the mixture

```
Bootstrap samples:
sample	A_1	mu_1	FWHM_1	relocc_1	A_2	mu_2	FWHM_2	relocc_2
1	1.636259e-01	-4.350341e-03	8.568204e-02	6.282864e-01	1.745914e-02	1.834205e-01	4.978150e-01	3.717136e-01
2	1.618894e-01	-7.044866e-03	8.539515e-02	6.143356e-01	1.440769e-02	2.036760e-01	6.708602e-01	3.856644e-01
3	1.703852e-01	-7.264723e-03	7.297065e-02	5.679364e-01	2.628222e-02	1.760318e-01	3.740112e-01	4.320636e-01
```

