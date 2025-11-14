---
layout: default
title: (*.txt) Trace manager's auto-sorting data
parent: Output files
nav_exclude: 1
nav_order: 29
---

<img src="../assets/images/logos/logo-output-files_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Auto-sorting data files
{: .no_toc }

AUto-sorting data files are ASCII files with the extension `.txt`. They are usually found in the main analysis folder.

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Description

Auto-sorting data files are data-specific and contain the 1 or 2D histogram that is used in Trace manager's Auto-sorting tool of Trace processing module.

They are created in the main analysis folder when exporting results from panel [Data](../trace-processing/functionalities/tm-automatic-sorting.html#data) of Trace manager's Auto-sorting tool in module Trace Processing.


---

## File name

The file is named by the user during the export process.
By default, the file is named after the selected <u>project file</u>.

The file name is appended with the extension `_autosort`.


---

## Structure

One or two header lines describe which data are histogrammed, using appelations given in panel [Data](../trace-processing/functionalities/tm-automatic-sorting.html#data).

FOr 1D histograms:
```
data: [...]
```

For 2D histograms:
```
x-data: [...]
y-data: [...]
```

1D histogram data are organized column-wise with:
* column `bin edges` containing edges of histogram bins
* column `bin center` containing centers of histogram bins
* column `count` containing histogram counts

```
bin edges bin center  count
0 2.222020e+03  0
4.444039e+03  6.666059e+03  0
8.888079e+03  1.111010e+04  0
1.333212e+04  1.555414e+04  0
1.777616e+04  1.999818e+04  2
```

2D histogram data are organized in a matrix with:
* the first column containing the centers in the **y-direction** of the histogram bins
* the first row containing the centers in the **x-direction** of the histogram bins
* the other cells containing histogram counts

```
          NaN   2.2220196e+03   6.6660589e+03   1.1110098e+04   1.5554137e+04   1.9998177e+04   2.4442216e+04   2.8886255e+04   3.3330295e+04   3.7774334e+04   4.2218373e+04   4.6662412e+04   5.1106452e+04   5.5550491e+04   5.9994530e+04   6.4438569e+04   6.8882609e+04   7.3326648e+04   7.7770687e+04   8.2214727e+04   8.6658766e+04   9.1102805e+04   9.5546844e+04   9.9990884e+04   1.0443492e+05   1.0887896e+05   1.1332300e+05   1.1776704e+05   1.2221108e+05   1.2665512e+05   1.3109916e+05   1.3554320e+05   1.3998724e+05   1.4443128e+05   1.4887532e+05   1.5331935e+05   1.5776339e+05   1.6220743e+05   1.6665147e+05   1.7109551e+05   1.7553955e+05   1.7998359e+05   1.8442763e+05   1.8887167e+05   1.9331571e+05   1.9775975e+05   2.0220379e+05   2.0664783e+05   2.1109187e+05   2.1553590e+05   2.1997994e+05
   1.8031829e+03   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00
   5.4095488e+03   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00
   9.0159147e+03   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00
   1.2622281e+04   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00   0.0000000e+00
```