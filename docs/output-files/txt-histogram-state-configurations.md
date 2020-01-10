---
layout: default
title: (*.txt) State configurations from Histogram analysis
parent: /output-files.html
nav_order: 33
nav_exclude: 1
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# State configuration files from Histogram analysis
{: .no_toc }

State configuration files are ASCII files with the extension `.txt`. They are usually found in the main`/histogram_analysis` folder.


## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

State configuration files are data-specific and contain the methods, parameters and results of state configuration analysis with module Histogram analysis.

They are created in the `/histogram_analysis` analysis sub-folder when exporting results in the 
[Project management](../histogram-analysis/panels/area-management.html#export-analysis-results) area of module Histogram analysis.


---

## File name

The file is named by the user during the export process.

By default, the file is named after the <u>project file</u> loaded in 
[Histogram analysis](../histogram-analysis/panels/area-management.html#project-list), and is appended with the extension `_[Ddd]_config`, where `[Ddd]` is the data type written in the file.

Data types supported in state configuration files are:
* `I[i]-[L]`: intensities in detection channel indexed `[i]` upon illumination with laser wavelength `[L]` nm
* `FRET[D]to[A]`: FRET from donor emitter detected in channel indexed `[D]` to acceptor emitter detected in channel indexed `[A]`
* `S[Eee]`: stoichiometry of emitter detected in channel labelled `[Eee]`

The data type is appended with a first extension `_[Ttt]` if a particular subgroup of molecules was analyzed, with `[Ttt]` the corresponding molecule tag.
A second extension `_discr` is added when state populations determined from state trajectories are written in the file.


---

## Structure

The first lines in file are dedicated to the method settings including the maximum model complexity allowed, the chosen model penalty as well as equations of the Gaussian mixtures fitted to the histogram, and are written such as:

```
Max. number of Gaussians:
Penalty:
Fitting equations:
- 1 Gaussians:	A_1*exp(-((x-mu_1).^2)/(2*(o_1^2)))
- 2 Gaussians:	A_1*exp(-((x-mu_1).^2)/(2*(o_1^2))) + A_2*exp(-((x-mu_2).^2)/(2*(o_2^2)))
- 3 Gaussians:	A_1*exp(-((x-mu_1).^2)/(2*(o_1^2))) + ... + A_3*exp(-((x-mu_3).^2)/(2*(o_3^2)))
```

The next lines contain the results of the state configuration in terms of the most sufficient model complexity written as:

```
Optimum number of Gaussians: 3
```

and the parameters of Gaussian mixture models inferred for all model complexity, organized column-wise with:
* column `number of Gaussians` containing model complexities in terms of number of Gaussian components in the model
* column `Log Likelihood` containing the logarithm of model likelihoods normalized by the number of data points
* column `BIC` containing the Bayesian information criteria of models
* columns `A_[j]`, `mu_[j]`, `FWHM_[j]` containing the optimum amplitude, mean and full width at half maximums of the `[j]`<sup>th</sup> Gaussian component in the mixture

```
Best parameters for all GMM with FWHM = o * 2*sqrt(2*ln(2)):
number of Gaussians	Log Likelihood	BIC		A_1		mu_1		FWHM_1		A_2		mu_2		FWHM_2		A_3		mu_3		FWHM_3		
1	5.865490e-01	-1.173034e+00	2.964029e-02	5.299770e-01	3.169462e-01
2	4.182709e-01	-8.363806e-01	2.061797e-02	4.357415e-01	2.324757e-01	2.191899e-02	6.281443e-01	2.099182e-01
3	5.943483e-02	-1.186117e-01	1.152534e-02	4.133546e-01	2.264146e-01	1.268416e-02	5.165872e-01	2.730222e-01	1.583160e-02	6.355509e-01	2.098214e-01
```
