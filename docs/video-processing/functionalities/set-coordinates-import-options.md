---
layout: default
title: Set coordinates import options
parent: /video-processing/functionalities.html
grand_parent: /video-processing.html
nav_order: 3
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Set coordinates import options
{: .no_toc }

Import options are the settings used to import spots and reference coordinates from ASCII files. 
They are accessed from panel 
[Coordinates transformation](../panels/panel-molecule-coordinates.html#coordinates-transformation) by pressing 
![Options...](../../assets/images/gui/VP-but-options3p.png "Options...").

<a class="plain" href="../../assets/images/gui/VP-panel-molcoord-transf-impopt.png"><img src="../../assets/images/gui/VP-panel-molcoord-transf-impopt.png" style="max-width: 310px;"/></a>


## Window components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Reference coordinates

Modify these settings according to the structure of the file containing the reference coordinates.

<a class="plain" href="../../assets/images/gui/VP-panel-molcoord-transf-impopt-refcoord.png"><img src="../../assets/images/gui/VP-panel-molcoord-transf-impopt-refcoord.png" style="max-width: 274px;"/></a>

Reference coordinates are coordinates co-localized in each channel.
Channel-specific coordinates can be written in a column-wise or row-wise fashion to the file.
To read channel-specific coordinates column-wise, select **(a)**. 
To read channel-specific coordinates row-wise, select **(e)**.

### Column-wise
{: .no_toc }

Coordinates (x,y) of one single molecule in individual channels are written on the same line and in different columns.

The number of header lines in the file must be set in **(b)**.

For each channel, give the column indexes in the file where channel-specific x-coordinates, in **(c)**, and y-coordinates, in **(d)**, are written.


### Row-wise
{: .no_toc }

Coordinates (x,y) of one single molecule in individual channels are written on different lines and in the same columns.

This is the default import format and is based on the structure of 
[.map files](../../output-files/map-mapped-coordinates.html).

Give in the column indexes in the file where x-coordinates, in **(f)**, and y-coordinates, in **(g)**, are written.

For each channel, give in **(h)** the file line where channel-specific coordinates first appear, in **(l)** the number of file line to skip to access the next channel-specific coordinates, and in **(j)** the last file line containing coordinates data.

---

## Spots coordinates

Modify these settings according to the structure of the file containing the spots coordinates.

<a class="plain" href="../../assets/images/gui/VP-panel-molcoord-transf-impopt-spotscoord.png"><img src="../../assets/images/gui/VP-panel-molcoord-transf-impopt-spotscoord.png" style="max-width: 274px;"/></a>

Give in **(a)** and **(b)** the column indexes in the file where x- and y- coordinates are written.

---

## Reference image dimensions

Update these settings to the dimensions of the reference image used to calculate the transformation.

<a class="plain" href="../../assets/images/gui/VP-panel-molcoord-transf-impopt-viddim.png"><img src="../../assets/images/gui/VP-panel-molcoord-transf-impopt-viddim.png" style="max-width: 197px;"/></a>

They are the dimensions in the x-, set in **(a)**, and y-, set in **(b)**, direction of the reference image used to calculate the transformation.

These dimensions are used to exclude out-of-range spots coordinates prior transformation.

