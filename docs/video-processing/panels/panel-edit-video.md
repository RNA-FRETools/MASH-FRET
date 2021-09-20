---
layout: default
title: Edit video
parent: Functionalities
grand_parent: Video processing
nav_order: 4
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Edit video
{: .no_toc }

Edit video is the third panel of module Video processing.

Use this panel to apply image filters or correct the single molecule video and to export the video to various file formats.

<a class="plain" href="../../assets/images/gui/VP-panel-videdit.png"><img src="../../assets/images/gui/VP-panel-videdit.png" style="max-width: 562px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Filter settings

Use this interface to apply one or several image filters to the loaded video or image.

<a class="plain" href="../../assets/images/gui/VP-panel-videdit-filterprm.png"><img src="../../assets/images/gui/VP-panel-videdit-filterprm.png" style="max-width: 231px;"/></a>

Image filters treat video channels separately and uses zero to two parameters.
To configure a filter, select first the channel in list **(c)**, then the image filter in list **(a)** and set filter parameters in **(c)** and **(d)**. 

A detailed description of each filter is given in 
[Filters](#filters) and references to the scientific literature are given in 
[References](#references).

Filters can be applied to the current video frame only or to all video frames by deactivating or activating the option in **(e)**. 

After configuration, the filter can be applied to the loaded video or image by pressing 
![Add](../../assets/images/gui/VP-but-add.png "Add"). 

All filters used on the video or image are listed in the 
[Filter list](#filter-list) and can be removed by pressing 
![Remove filter](../../assets/images/gui/VP-but-remove-filter.png "Remove filter").


### Filters
{: .no_toc }

| filter                                            | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | default *p*<sub>1</sub> | default *p*<sub>2</sub> |
| ------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------: | :---------------------: |
| `Gaussian filter`                                 | Pixels are convolved with a Gaussian function with ***p*<sub>1</sub>** the size of the kernel and ***p*<sub>2</sub>** the Gaussian standard deviation.                                                                                                                                                                                                                                                                                                                                                                                                                                        | 3                       | none                    |
| `mean filter`                                     | Pixels are convolved with a rectangle function with ***p*<sub>1</sub>** the size of the kernel.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | 3                       | none                    |
| `median filter`                                   | Pixels are replaced by the median value of the ***p*<sub>1</sub>** neighbouring pixels.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | 3                       | none                    |
| `Crocker-Grier filter`<sup>[1](#references)</sup> | Mean-filtered pixels are subtracted to Gaussian filtered-pixels, using ***p*<sub>1</sub>** as the kernel size and ***p*<sub>2</sub>** as the Gaussian standard deviation                                                                                                                                                                                                                                                                                                                                                                                                                      | 3                       | 1                       |
| `local Wiener filter`                             | The estimated noise intensity per pixel ***p*<sub>2</sub>** is subtracted to the ***p*<sub>1</sub>**-by-***p*<sub>1</sub>** neighbouring pixel area. If ***p*<sub>2</sub>**=0, the noise intensity is calculated as 10% of the maximum intensity in the ***p*<sub>1</sub>**-by-***p*<sub>1</sub>** neighbouring pixel area                                                                                                                                                                                                                                                                    | 3                       | 200                     |
| `global Wiener filter`                            | The estimated noise intensity per pixel ***p*<sub>2</sub>** is subtracted to all pixels in the image. If ***p*<sub>2</sub>**=0, the noise intensity is calculated as 10% of the maximum intensity in the image                                                                                                                                                                                                                                                                                                                                                                                | 200                     | none                    |
| `outlier filter`                                  | Identifies bright spots from the mean and standard deviation of the intensity distribution in the ***p*<sub>1</sub>**-by-***p*<sub>1</sub>** neighbouring pixels, with a confidence level ***p*<sub>2</sub>**. Pixels that does not belong to the ***p*<sub>1</sub>**-by-***p*<sub>1</sub>** area are set to 0.                                                                                                                                                                                                                                                                               | 3                       | 0.99                    |
| `histothresh filter`                              | Pixels that have an intensity lower than ***p*<sub>1</sub>**% of the pixels in the image are set to 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 0.5                     | none                    |
| `simplethresh filter`                             | Pixels that have an intensity lower than ***p*<sub>1</sub>** are set to 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 1500                    | none                    |
| `mean value`                                      | **Background correction:** the estimated background intensity *I*<sub>BG</sub> is subtracted to all pixels with *I*<sub>BG</sub>=*I*<sub>high</sub>+***p*<sub>1</sub>**x*HWHM*<sub>high</sub>.<br>*I*<sub>high</sub> and *HWHM*<sub>high</sub> are the mean and the half-width at half-maximum of the distribution of high intensities.<br>High intensities are intensities higher than *I*<sub>mean</sub>+***p*<sub>1</sub>**x*&#963;*<sub>I</sub>, with *I*<sub>mean</sub> and *&#963;*<sub>I</sub> being the mean value and standard deviation of the intensity distribution in the image. | 0                       | none                    |
| `most frequent`                                   | **Background correction:** the estimated background intensity *I*<sub>BG</sub> is subtracted to all pixels with *I*<sub>BG</sub>=*I*<sub>most</sub>+***p*<sub>1</sub>**x*HWHM*<sub>most</sub>.<br>*I*<sub>most</sub> is the most frequent value in the image considering a binning interval (*I*<sub>max</sub>-*I*<sub>min</sub>)/***p*<sub>2</sub>**, and HWHM*<sub>most</sub> is the half-width at half maximum of the intensity distribution in the image.                                                                                                                                 | 0                       | 50                      |
| `histothresh`                                     | **Background correction:** the estimated background intensity *I*<sub>BG</sub> is subtracted to all pixels with *I*<sub>BG</sub>=*I*<sub>2</sub>+***p*<sub>1</sub>**x*HWHM*<sub>2</sub>.<br>*I*<sub>2</sub> is the intensity corresponding to a probability ***p*<sub>2</sub>** in the cumulative distribution of intensities in the image.                                                                                                                                                                                                                                                   | none                    | 0.5                     |
| `Ha average` <sup>[2](#references)</sup>          | **Background correction:** the video is averaged into one image which is then resized to square-rooted dimensions by averaging pixel values. The background image is then resized to original video dimensions and is subtracted to each video frame.                                                                                                                                                                                                                                                                                                                                         | none                    | none                    |
| `Ha framewise` <sup>[2](#references)</sup>        | **Background correction:** each video frame is resized to square-rooted dimensions by averaging pixel values. The background image is then resized to original video dimensions and is subtracted to the original video frame.                                                                                                                                                                                                                                                                                                                                                                | none                    | none                    |
| `Twotone` <sup>[3](#references)</sup>             | Mean-filtered pixels are subtracted to Gaussian-filtered pixels, using ***p*<sub>1</sub>** as the kernel size and a Gaussian standard deviation of 1 pixel.                                                                                                                                                                                                                                                                                                                                                                                                                                   | 3                       | 1                       |
| `subtract image`                                  | **Background correction:** a background image is loaded from an external file and is subtracted to each video frame.                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | none                    | none                    |
| `multiplication`                                  | Pixel values are multiplied by a factor ***p*<sub>1</sub>**.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 1                       | none                    |
| `addition`                                        | An constant intensity ***p*<sub>2</sub>** is added to each pixel value.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | 0                       | none                    |

Filters `Gaussian filter`, `mean filter`, `median filter`, `Crocker-Grier filter`, `local Wiener filter`, `global Wiener filter`, `outlier filter`, `histothresh filter` and `simmplethresh filter` were written and generously shared by Dr Mario Heidernätsch from the Institute of Physics, Chemnitz University of Technology.
These filters were written in C and were compiled to .mex files via the `mex` function of MATLAB. 
The .mex files may work with certain MATLAB versions and lead to errors with others. 

If the use of one of these filters gives an error, please recompile the .mex files by following the instructions from file:

```
MASH-FRET/source/extern/README-MEX-FILES.txt
```

If the error persists, please inform us via the 
[issue tracker](https://github.com/RNA-FRETools/MASH-FRET/issues) on Github.


### References
{: .no_toc }

1. J.C. Crocker, D.G. Grier, *Methods of Digital Video Microscopy for Colloidal Studies*, *J. Colloid Interface Sci.* **1996**, DOI: [10.1006/jcis.1996.0217](https://doi.org/10.1006/jcis.1996.0217)
1. P.R. Selvin, T. Ha, *Single molecule Techniques: A Laboratory Manual*, Cold Spring Harbor laboratory Press **2008**, ISBN: 978-087969775-4.
1. A.N. Kapanidis, N.K. Lee, T.A. Laurence, S. Doose, E.Margeat, S. Weiss, *Defining the Limits of Single-Molecule FRET Resolution in TIRF Microscopy*, *Proc. Nat. Acad. Sci.* **2004**, DOI: [10.1016/j.bpj.2010.09.005](https://doi.org/10.1016/j.bpj.2010.09.005)


---

## Filter list

Use this list to visualize or cancel filters applied to the current frame, with the top-filter being applied first.

To cancel a filter, select the corresponding name in the list and press 
![Remove filter](../../assets/images/gui/VP-but-remove-filter.png "Remove filter").


---

## Export video to file

Press
![Export...](../../assets/images/gui/VP-but-export3p.png "Export...") to export the video or image to a file.

The exported image/video will be truncated according to the 
[Frame range](#frame-range) and modified according to the filters in the 
[Filter list](#filter-list).

Supported file formats are:
* [MASH video format](../../output-files/sira-mash-video.html) (<u>.sira</u>)
* Tagged Image File format (<u>.tif</u>)
* Graphics Interchange Format (<u>.gif</u>)
* MATLAB binary file (<u>.mat</u>)
* Audio Video Interleave (<u>.avi</u>)
* Portable Network Graphics (<u>.png</u>)

For further use with MASH-FRET, it is recommended to export modified or original videos in the 
[MASH video format](../../output-files/sira-mash-video.html): processes and calculations will be less time consuming.

File formats <u>.avi</u> and <u>.gif</u> can be used to export animated illustration but not for further analysis as the data accuracy and coherence between frames are lost during the writing process.

To programmatically add new video formats, update the following function in the source code:

```
MASH-FRET/source/mod_video_processing/graphic_files/exportMovie.m
```

---

## Frame range

Defines the range of video frames to export.

<a class="plain" href="../../assets/images/gui/VP-panel-videdit-framerange.png"><img src="../../assets/images/gui/VP-panel-videdit-framerange.png" style="max-width: 106px;"/></a>

Sometimes, the frame range of a video needs to be re-adjusted, because of partial failure in recording, or simply to export light animated GIF files for illustration.

To do so, set the starting frame index in **(a)** and the ending frame index in **(b)** prior exporting the video in 
[Export video to file](#export-video-to-file).
