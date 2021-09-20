---
layout: default
title: Molecule coordinates
parent: Functionalities
grand_parent: Video processing
nav_order: 5
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Molecule coordinates
{: .no_toc }

Molecule coordinates is the fourth panel of module Video processing.

Use this panel to target single molecules in the video and obtain single molecule coordinates.

<a class="plain" href="../../assets/images/gui/VP-panel-molcoord.png"><img src="../../assets/images/gui/VP-panel-molcoord.png" style="max-width: 562px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Average image

Use this interface to import or export an average image of the video.

<a class="plain" href="../../assets/images/gui/VP-panel-molcoord-aveim.png"><img src="../../assets/images/gui/VP-panel-molcoord-aveim.png" style="max-width: 232px;"/></a>

The average image is calculated over a frame range defined by the starting frame index, set in **(a)**, the frame interval, set in **(b)**, and the ending frame index, set in **(c)**.

Press 
![Go](../../assets/images/gui/VP-but-go.png "Go") to calculate and export the average image.

Supported file formats are:
* [MASH video format](../../output-files/sira-mash-video.html) (<u>.sira</u>)
* Tagged Image File format (<u>.tif</u>)
* Portable Network Graphics (<u>.png</u>)

To rapidly access the average image folder and load an average image file, press 
![...](../../assets/images/gui/VP-but-3p.png "...").


---

## Spotfinder

Use this panel to find bright spots in the average image or video and export coordinates.

<a class="plain" href="../../assets/images/gui/VP-panel-molcoord-sf.png"><img src="../../assets/images/gui/VP-panel-molcoord-sf.png" style="max-width: 241px;"/></a>

Spotfinder is limited to the detection of bright spots in video frames and does not include tracking.

To configure the search algorithm, select the detection method in **(a)**.
The four detection methods available are described in the respective sections:
* [in-series screening](#in-series-screening)
* [houghpeaks](#houghpeaks)
* [Schmied2012](#schmied2012)
* [Twotone](#twotone)

As the search algorithm looks for bright spots in individual video channels, method parameters are different for each channel.
To configure the method, select the channel in list **(c)** and set parameters in **(d)**, **(g)** and/or **(h)** according to the method description.

Bright spot intensity profiles can be fitted with 2D-Gaussians to extract shape features by activating the option in **(b)**; see 
[Gaussian fitting](#gaussian-fitting) for more details.

Start spot detection and subsequent Gaussian fitting by pressing 
![Find](../../assets/images/gui/VP-but-find.png "Find").
Detected spots are automatically shown on the 
[Visualization area](area-visualization.html#video-visualization) with red circles.

Spots are then sorted according to user-defined criteria on the number, position, intensity and shape of spots; see 
[Exclusion rules](#exclusion-rules) for more details.
The number of spots found after applying the exclusion rules is displayed in **(q)**.

The final set of spot coordinates can be exported to a 
[.spots file](../../output-files/spots-spots-coordinates) by pressing 
![Save...](../../assets/images/gui/VP-but-save3p.png "Save...").


### Gaussian fitting
{: .no_toc }

When Gaussian fitting is activated, a pixel area of **(e)**-by-**(f)** pixels centered on the spot position is fitted with a tilted ellipsoid Gaussian function expressed as:

{: .equation }
<img src="../../assets/images/equations/VP-eq-spots-01.gif" alt="I(x,y) = offset + I_{0}\textup{exp}\left \{ - \left [ a(x - x_{0})^{2} + 2b(x - x_{0})(y - y_{0}) + c(y - y_{0})^{2} \right ] \right \}">

with 
[*offset*](){: .math_var } the Gaussian offset, 
[*I*<sub>0</sub>](){: .math_var } the Gaussian amplitude, 
[*x*<sub>0</sub>](){: .math_var } and 
[*y*<sub>0</sub>](){: .math_var } the x- and y- spot coordinates, and with coefficient 
[*a*,](){: .math_var } 
[*b*](){: .math_var } and 
[*c*](){: .math_var } containing information about Gaussian width and orientation:

{: .equation }
<img src="../../assets/images/equations/VP-eq-spots-02.gif" alt="a = \frac{\textup{cos}^{2}( \theta )}{2\sigma_{\textup{x}}^{2}} + \frac{\textup{sin}^{2}( \theta )}{2\sigma_{\textup{y}}^{2}}"><br>
<img src="../../assets/images/equations/VP-eq-spots-03.gif" alt="b = - \frac{\textup{sin}( 2\theta )}{4\sigma_{\textup{x}}^{2}} + \frac{\textup{sin}( 2\theta )}{4\sigma_{\textup{y}}^{2}}"><br>
<img src="../../assets/images/equations/VP-eq-spots-04.gif" alt="c = \frac{\textup{sin}^{2}( \theta )}{2\sigma_{\textup{x}}^{2}} +  \frac{\textup{cos}^{2}( \theta )}{2\sigma_{\textup{y}}^{2}}">

with 
[*&#963;*<sub>x</sub>](){: .math_var } and 
[*&#963;*<sub>y</sub>](){: .math_var } the Gaussian standard deviations in the x- and y- direction, and 
[*&#952;*](){: .math_var } the Gaussian orientation angle.


### Exclusion rules
{: .no_toc }

Exclusion rules are set in **(j-p)** and are described in details in the table below.

| field   | description                                                                                                                                                                                                                                               | default |
| :-----: | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :-----: |
| **(j)** | Maximum number of spots allowed. The brightest spots a preserved.                                                                                                                                                                                         | 200     |
| **(k)** | Minimum spot intensity allowed. Without Gaussian fitting, Intensities are single pixel values. With Gaussian fitting, intensities are the sums of pixel values in the fitting area reduced by the Gaussian offset.                                        | 0 ic    |
| **(l)** | Minimum distance allowed between spots (in pixel).                                                                                                                                                                                                        | 0 px    |
| **(m)** | Minimum distance allowed between spots and image edges (in pixel).                                                                                                                                                                                        | 3 px    |
| **(n)** | *(only with Gaussian fitting)* Minimum Gaussian standard deviation allowed (in pixel).                                                                                                                                                                    | 0 px    |
| **(o)** | *(only with Gaussian fitting)* Maximum Gaussian standard deviation allowed (in pixel).                                                                                                                                                                    | 5 px    |
| **(p)** | *(only with Gaussian fitting)* Maximum Gaussian asymmetry allowed (in percent). The minimum value is 100% for a perfectly spherical Gaussian. An asymmetry of 200% represents a Gaussian twice larger in the x- (or y-) than in the y- (or x-) direction. | 150%    |


### in series-screening
{: .no_toc }

It is a home-made algorithm adapted from 
[houghpeaks](#houghpeaks) but faster. It processes as described below:

1. searches for the brightest pixel in the image considering a minimum pixel intensity set in **(d)** 
1. sets an area of **(g)**-by-**(h)** pixels centered on the brightest pixel to zero
1. repeats steps 1 and 2 until no pixel with intensity higher than **(d)** is found.


### houghpeaks
{: .no_toc }

It is a built-in function of MATLAB and is described in details in 
[MATLAB's documentation](https://fr.mathworks.com/help/images/ref/houghpeaks.html).

The houghpeaks method uses the same principle and parameters as 
[in-serie screening](#in-series-screening) but works slower.


### Schmied2012
{: .no_toc }

It is an algorithm originally designed for super-resolution microscopy and published in the literature<sup>[1](#references)</sup>. 

It identifies bright spots considering:
* a minimum ratio spot intensity over background set in **(d)** 
* a minimum distance to the image edge set in **(h)**.

The Schmied2012 algorithm was written in C and was compiled to .mex file via the `mex` function of MATLAB. 
The .mex file may work with certain MATLAB versions and lead to errors with others. 
If the use of Schmied2012 gives an error, please recompile the .mex file by entering in MATLAB's command window the following:

```matlab
cd 'xxxxx\MASH-FRET\source\extern\schmied2012'
mex 'xxxxx\MASH-FRET\source\extern\schmied2012\forloop.c'
```

with `xxxxx` the path on your computer to the MASH-FRET folder.

If the error persists, please inform us via the 
[issue tracker](https://github.com/RNA-FRETools/MASH-FRET/issues) on Github.


### Twotone
{: .no_toc }

It is an algorithm originally designed to localize single molecules in TIRF-FRET videos and is used in the software Twotone published in the literature<sup>[2](#references)</sup>.

It processes as described below:
1. applies the Twotone image filter to the average image or video frame with a kernel size set in **(d)**; see 
   [Filters](panel-edit-video.html#filters) for more information
1. searches in the filtered image for pixels brighter than the intensity threshold set in **(g)**
1. selects pixels that are local maxima in the 3-by-3 pixel area around them.


### References
{: .no_toc }

1. J.J. Schmied, A. Gietl, P. Holzmeister, C. Forthmann, C. Steinhauer, T. Dammeyer, P. Tinnefeld, *Fluorescence and super-resolution standards based on DNA origami*, *Nature Methods* **2012**, DOI: [10.1038/nmeth.2254](https://doi.org/10.1038/nmeth.2254).
1. A.N. Kapanidis, N.K. Lee, T.A. Laurence, S. Doose, E.Margeat, S. Weiss, *Defining the Limits of Single-Molecule FRET Resolution in TIRF Microscopy*, *Proc. Nat. Acad. Sci.* **2004**, DOI: [10.1016/j.bpj.2010.09.005](https://doi.org/10.1016/j.bpj.2010.09.005)

---

## Coordinates transformation

Use this panel to transform spots coordinates into other video channels and obtain single molecule coordinates.

<a class="plain" href="../../assets/images/gui/VP-panel-molcoord-transf.png"><img src="../../assets/images/gui/VP-panel-molcoord-transf.png" style="max-width: 289px;"/></a>

Spots coordinates are translated in other channels after applying a group of specific symmetry operations, called the spatial transformation.
Transformed coordinates are called single molecule coordinates and are exported to a 
[.coord file](../../output-files/coord-transformed-coordinates) by pressing 
![Transform](../../assets/images/gui/VP-but-transform.png "Transform").
Before transforming spots coordinates, make sure the spots coordinates and the spatial transformation are imported as described below.

Spots coordinates written in ASCII files can be imported in **(d)**:
* either automatically, after saving spots coordinates with Spotfinder; see 
[Spotfinder](#spotfinder) for more information
* or by pressing 
![...](../../assets/images/gui/VP-but-3p.png "...") and selecting the previously exported spots coordinates file; coordinates are imported according to the 
[Import options](#import-options).

The spatial transformation stored in a 
[.mat file](../../output-files/mat-transformation.html) can be imported in **(c)**:
* either automatically, after calculation from a set of reference coordinates, according to the transformation type selected in **(b)**, and by pressing 
![Calculate](../../assets/images/gui/VP-but-calculate.png "Calculate"); see 
[Transformation types](#transformation-types) for more details about the available types
* or by pressing 
![...](../../assets/images/gui/VP-but-3p.png "...") and selecting the previously exported transformation 
[.mat file](../../output-files/mat-transformation.html).

Reference coordinates written in ASCII files can be imported in **(a)**:
* either automatically after mapping coordinates on a reference image with the mapping tool that can be accessed by pressing 
![Map](../../assets/images/gui/VP-but-map.png "Map"); see 
[Use the mapping tool](../functionalities/use-the-mapping-tool.html) to use the mapping tool
* or by pressing 
![...](../../assets/images/gui/VP-but-3p.png "...") and selecting the previously exported reference coordinates file; coordinates are imported according to the 
[Import options](#import-options).

Before transforming any set of coordinates, it is recommended to test the validity of the transformation on a benchmark image (usually the average image of a single bead video recorded parallel to the experiment).
This is done by overlaying the original benchmark image (colored in red) with the transformed one (colored in green).
Perfect transformation will result in a perfect overlay of images and thus, in a yellow image.
When the original and transformed images are shifted, a new transformation needs to be calculated from a new set of reference coordinates.

<img src="../../assets/images/figures/VP-transformation-quality.png" />

Transformation quality can be checked by pressing 
![Check quality...](../../assets/images/gui/VP-but-check-quality.png "Check quality...") and selecting the benchmark image file.


### Transformation types
{: .no_toc }

Transformation types are groups of symmetry operations.
All transformation types are given in MATLAB and are explained in details in 
[MATLAB's documentation](https://fr.mathworks.com/help/images/ref/cp2tform.html#f1-283651-transformtype) or in the table below.
Each type necessitates a minimum number of reference coordinates, which is indicated in the last column.

| type                        | symmetry operations                                                                                                    | min. ref |
| :-------------------------: | ---------------------------------------------------------------------------------------------------------------------- | :------: |
| `Non reflective similarity` | translation, rotation, uniform scaling                                                                                 | 2        |
| `Similarity`                | translation, rotation, uniform scaling, reflection                                                                     | 3        |
| `Affine`                    | translation, rotation, uniform scaling, reflection, uniaxial linear distortion                                         | 3        |
| `Projective`                | translation, rotation, uniform scaling, reflection, biaxial linear distortion                                          | 4        |
| `Plynomial ord2`            | translation, rotation, uniform scaling, reflection, curvilinear distortion by applying a 2nd order polynomial function | 6        |
| `Plynomial ord3`            | translation, rotation, uniform scaling, reflection, curvilinear distortion by applying a 3rd order polynomial function | 10       |
| `Plynomial ord4`            | translation, rotation, uniform scaling, reflection, curvilinear distortion by applying a 4th order polynomial function | 15       |
| `Piecewise linear`          | scaling specific to different parts of the image                                                                       | 4        |
| `Local mean weight`         | locally specific scaling                                                                                               | 12       |


### Import options
{: .no_toc }

Press 
![Options...](../../assets/images/gui/VP-but-options3p.png "Options...") to open the settings to import reference and spots coordinates from ASCII files.

To set the import options, please refer to 
[Set coordinates import options](../functionalities/set-coordinates-import-options.html).

