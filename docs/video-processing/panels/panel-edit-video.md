---
layout: default
title: Edit video
parent: /video-processing/panels
grand_parent: /video-processing
nav_order: 4
---

# Edit video
{: .no_toc }

<a href="../../assets/images/gui/VP-panel-videdit.png"><img src="../../assets/images/gui/VP-panel-videdit.png" style="max-width: 562px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Filter settings

Use these settings to configure an image filter to apply to the loaded video or image.

<a href="../../assets/images/gui/VP-panel-videdit-filterprm.png"><img src="../../assets/images/gui/VP-panel-videdit-filterprm.png" style="max-width: 231px;"/></a>

Image filters treat each video channels separately. 
To configure a filter, select the first channel in list **(c)** and the image filter in list **(a)**. 
Each filter uses zero to two user-defined parameters that can be set in **(c)** and **(d)** and that are detailed in the table below.

| filter                                                                         | description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | default *p*<sub>1</sub> | default *p*<sub>2</sub> |
| ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------------- | --------------- |
| `Gaussian filter`                                                              | Pixels are convolved with a Gaussian function with ***p*<sub>1</sub>** the size of the kernel and ***p*<sub>2</sub>** the Gaussian standard deviation.                                                                                                                                                                                                                                                                                                                                                                                                             |  |  |
| `mean filter`                                                                  | Pixels are convolved with a rectangle function with ***p*<sub>1</sub>** the size of the kernel.                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |  |  |
| `median filter`                                                                | Pixels are replaced by the median value of the ***p*<sub>1</sub>** neighbouring pixels.                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |  |  |
| `Crocker-Grier filter`<sup>[ref](https://doi.org/10.1006/jcis.1996.0217)</sup> | Mean-filtered pixels are subtracted to Gaussian filtered-pixels, using ***p*<sub>1</sub>** as the kernel size and ***p*<sub>2</sub>** as the Gaussian standard deviation                                                                                                                                                                                                                                                                                                                                                                                           |  |  |
| `local Wiener filter`                                                          | The estimated noise intensity per pixel ***p*<sub>2</sub>** is subtracted to the ***p*<sub>1</sub>**-by-***p*<sub>1</sub>** neighbouring pixel area. If ***p*<sub>2</sub>**=0, the noise intensity is calculated as 10% of the maximum intensity in the ***p*<sub>1</sub>**-by-***p*<sub>1</sub>** neighbouring pixel area                                                                                                                                                                                                                                         |  |  |
| `global Wiener filter`                                                         | The estimated noise intensity per pixel ***p*<sub>2</sub>** is subtracted to all pixels in the image. If ***p*<sub>2</sub>**=0, the noise intensity is calculated as 10% of the maximum intensity in the image                                                                                                                                                                                                                                                                                                                                                     |  |  |
| `outlier filter`                                                               | Identifies bright spots from the mean and standard deviation of the intensity distribution in the ***p*<sub>1</sub>**-by-***p*<sub>1</sub>** neighbouring pixels. Pixels that does not belong to the ***p*<sub>1</sub>**-by-***p*<sub>1</sub>** area are set to 0.                                                                                                                                                                                                                                                                                                 |  |  |
| `histothresh filter`                                                           | Pixels that have an intensity lower than ***p*<sub>1</sub>**% of the pixels in the image are set to 0                                                                                                                                                                                                                                                                                                                                                                                                                                                              |  |  |
| `simplethresh filter`                                                          | Pixels that have an intensity lower than ***p*<sub>1</sub>** are set to 0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |  |  |
| `mean value`                                                                   | The estimated background intensity *I*<sub>BG</sub> is subtracted to all pixels with *I*<sub>BG</sub>=*I*<sub>high</sub>+***p*<sub>1</sub>**x*HWHM*<sub>high</sub>.<br>*I*<sub>high</sub> and *HWHM*<sub>high</sub> are the mean and the half-width at half-maximum of the distribution of high intensities.<br>High intensities are intensities higher than *I*<sub>mean</sub>+***p*<sub>1</sub>**x*&#963;*<sub>I</sub>, with *I*<sub>mean</sub> and *&#963;*<sub>I</sub> being the mean value and standard deviation of the intensity distribution in the image. |  |  |
| `most frequent`                                                                | The estimated background intensity *I*<sub>BG</sub> is subtracted to all pixels with *I*<sub>BG</sub>=*I*<sub>most</sub>+***p*<sub>1</sub>**x*HWHM*<sub>most</sub>.<br>*I*<sub>most</sub> is the most frequent value in the image considering a binning interval (*I*<sub>max</sub>-*I*<sub>min</sub>)/***p*<sub>2</sub>**, and HWHM*<sub>most</sub> is the half-width at half maximum of the intensity distribution in the image.                                                                                                                                 |  |  |
| `histothresh`                                                                  |  |  |  |
| `Ha average`                                                                   |  |  |  |
| `Ha framewise`                                                                 |  |  |  |
| `Twotone`                                                                      |  |  |  |
| `subtract image`                                                               |  |  |  |
| `multiplication`                                                               |  |  |  |
| `addition`                                                                     |  |  |  |

Image filters can be configured for only the current frame or for all video frames, by respectively uncheking or checking the box in **(e)**. 

After configuration, the filter can be applied to the loaded video or image by pressing **Add**. 
All filters used on the video or image are listed in the 
[Filter list](#filter list) and can be removed by pressing **Remove filter**

---

## Filter list


---

## Export video to file

---

## Frame range

<a href="../../assets/images/gui/VP-panel-videdit-framerange.png"><img src="../../assets/images/gui/VP-panel-videdit-framerange.png" style="max-width: 106px;"/></a>

Sometimes the frame range of a video needs to be re-adjusted, because of partial failure in recording or to export light animated GIF files for illustration.
