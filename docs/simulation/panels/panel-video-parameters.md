---
layout: default
title: Video parameters
parent: /simulation/panels.html
grand_parent: /simulation.html
nav_order: 1
---

# Video parameters
{: .no_toc }

<a href="../../assets/images/gui/sim-panel-video-parameters.png"><img src="../../assets/images/gui/sim-panel-video-parameters.png" style="max-width: 217px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Video length

It is the total number of image frames in the video. 

It is usually noted 
[*L*](){: .math_var }

**<u>default</u>:** 
[*L*](){: .math_var } = 4000 frames

---

## Frame rate

It is acquisition rate of the video in frames per second (fps). 

It is usually noted 
[*f*](){: .math_var }. 
It is linked to the acquisition time 
[*t*<sub>exp</sub>](){: .math_var } by the relation:

{: .equation }
*f* = 1 / *t*<sub>exp</sub>

with 
[*t*<sub>exp</sub>](){: .math_var } in seconds

**<u>default</u>:** 
[*f*](){: .math_var } = 10 fps

---

## Pixel size

It is the x- and y-dimensions of a pixel in micrometers. 

It is used in the conversion of PSF widths from micrometers to pixels.

**<u>default</u>:** 0.53 &#956;m

---

## Bit rate

It is the camera digitization bit depth in bit/pixel and defines the range of pixel values. 

It is used to calculate the saturation value in the video.

**<u>default</u>:** 14 bit/pixel

---

## Video dimensions

They are the dimensions of video frames in pixels , following the x- **(a)** and y- **(b)** directions.

**<u>default</u>:** 256-by-256 pixels

---

## Camera SNR characteristics

They are the settings to convert photon counts to images counts and generate camera noise.

<a href="../../assets/images/gui/sim-panel-video-parameters-camera.png"><img src="../../assets/images/gui/sim-panel-video-parameters-camera.png" style="max-width: 198px" /></a>

Select the model to generate camera noise in **(a)**. 
Model parameters to be set in **(b)** are automatically adapted to the model selected in **(a)**.

Available camera noise models are:
* [Offset only](#offset-only)
* [P- or Poisson](#p--or-poisson)
* [N- or Gaussian](#n--or-gaussian)
* [NExpN- or Gaussian + exponential tail](#nexpn--or-gaussian--exponential-tail)
* [PGN- or Hirsch](#pgn--or-hirsch)

Refer to table 
[Model parameters](#model-parameters) for an exhaustive list of model parameters.


### Offset only
{: .no_toc }

Photon counts 
[*&#956;*<sub>pc</sub>](){: .math_var } are ideally converted to image counts 
[*&#956;*<sub>ic</sub>](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ic</sub> = *&#956;*<sub>pc</sub>

A constant camera dark count 
[*&#956;*<sub>ic,d</sub>](){: .math_var } is then added.

**<u>default</u>:** 
[*&#956;*<sub>ic,d</sub>](){: .math_var } = 113 ic


### P- or Poisson
{: .no_toc }

Photon counts 
[*&#956;*<sub>pc</sub>](){: .math_var } are converted to electron counts 
[*&#956;*<sub>ec</sub>](){: .math_var } with a detection efficiency 
[*&#951;*](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ec</sub> = *&#956;*<sub>pc</sub> &#215; *&#951;*

Electron counts are distributed following a Poisson distribution and are ideally converted to image counts 
[*&#956;*<sub>ic</sub>](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ic</sub> = *&#956;*<sub>ec</sub>

A constant camera dark count 
[*&#956;*<sub>ic,d</sub>](){: .math_var } is then added.

**<u>default</u>:**
* [*&#956;*<sub>ic,d</sub>](){: .math_var } = 113 ic
* [*&#951;*](){: .math_var } = 0.95 ec/pc


### N- or Gaussian
{: .no_toc }

Photon counts 
[*&#956;*<sub>pc</sub>](){: .math_var } are converted to electron counts 
[*&#956;*<sub>ec</sub>](){: .math_var } with a detection efficiency 
[*&#951;*](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ec</sub> = *&#956;*<sub>pc</sub> &#215; *&#951;*

Electron counts are converted to image counts 
[*&#956;*<sub>ic</sub>](){: .math_var } with an overall gain 
[*K*](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ic</sub> = *&#956;*<sub>ec</sub> &#215; *K*

A constant camera dark count 
[*&#956;*<sub>ic,d</sub>](){: .math_var } is added and image counts are distributed following a Gaussian distribution of mean 
[*&#956;*<sub>ic</sub>](){: .math_var } and standard deviation 
[*&#963;*<sub>ic</sub>](){: .math_var } that depends on 
[*&#956;*<sub>ic</sub>](){: .math_var }, the readout noise standard deviation 
[*&#963;*<sub>d</sub>](){: .math_var } and the analog-to-digital noise standard deviation 
[*&#963;*<sub>q</sub>](){: .math_var } such as:

{: .equation }
*&#963;*<sub>ic</sub> = (  *&#956;*<sub>ic</sub> + ( *K* &#215; *&#963;*<sub>d</sub> )<sup>2</sup> + *&#963;*<sub>q</sub><sup>2</sup> )<sup>0.5</sup>

**<u>default</u>:** values taken from the literature (reference 
[here](../../citations.html#simulation-algorithm-testing)):
* [*&#956;*<sub>ic,d</sub>](){: .math_var } = 113 ic
* [*&#951;*](){: .math_var } = 0.95 ec/pc
* [*K*](){: .math_var } = 57.8 ic/ec
* [*&#963;*<sub>d</sub>](){: .math_var } = 0.067 ec
* [*&#963;*<sub>q</sub>](){: .math_var } = 0 ic


### NExpN- or Gaussian + exponential tail
{: .no_toc }

Photon counts 
[*&#956;*<sub>pc</sub>](){: .math_var } are converted to electron counts 
[*&#956;*<sub>ec</sub>](){: .math_var } with a detection efficiency 
[*&#951;*](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ec</sub> = *&#956;*<sub>pc</sub> &#215; *&#951;*

Electron counts are converted to image counts 
[*&#956;*<sub>ic</sub>](){: .math_var } with an overall gain 
[*K*](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ic</sub> = *&#956;*<sub>ec</sub> &#215; *K*

A constant camera dark count 
[*&#956;*<sub>ic,d</sub>](){: .math_var } is added and image counts are distributed following an exponential-tailed Gaussian distribution with mean 
[*&#956;*<sub>ic</sub>](){: .math_var }, standard deviation 
[*&#963;*<sub>ic</sub>](){: .math_var }, tail contribution 
[*A*<sub>CIC</sub>](){: .math_var } and exponential decay 
[*&#964;*<sub>CIC</sub>](){: .math_var }.

This model is purely empirical: model parameters are obtained by fitting the distribution 
[P](){: .math_var } of image counts obtain from a camera with closed shutter 
[*&#956;*<sub>ic,0</sub>](){: .math_var } with the function:

{: .equation }
P(*&#956;*<sub>ic,0</sub>) = ( 1-*A*<sub>CIC</sub> ) &#215; exp[ -( *&#956;*<sub>ic,0</sub> - *&#956;*<sub>ic,d</sub> )<sup>2</sup> / ( 2 &#215; *&#963;*<sub>ic</sub><sup>2</sup> ) ] + *A*<sub>CIC</sub> &#215; exp( - *&#956;*<sub>ic,0</sub> / *&#964;*<sub>CIC</sub> )

To fit dark count distribution with the NExpN model, you can use our home-written script located at:

```
MASH-FRET/fit_NExpN.m
```

**Note:** *Random generation of NExpN noise is relatively time consuming. 
Expect spending around 20 minutes to simulate a 256-by-256-wide and 4000 frame-long video.*

**<u>default</u>:** values taken from the literature (reference 
[here](../../citations.html#simulation-algorithm-testing)):
* [*&#956;*<sub>ic,d</sub>](){: .math_var } = 106.9 ic
* [*A*<sub>CIC</sub>](){: .math_var } = 0.02 
* [*&#963;*<sub>ic</sub>](){: .math_var } = 4.9 ic
* [*&#964;*<sub>CIC</sub>](){: .math_var } = 20.5 ic
* [*&#951;*](){: .math_var } = 0.95 ec/pc
* [*K*](){: .math_var } = 57.8 ic/ec

### PGN- or Hirsch
{: .no_toc }

Photon counts 
[*&#956;*<sub>pc</sub>](){: .math_var } are converted to electron counts 
[*&#956;*<sub>ec</sub>](){: .math_var } with a detection efficiency 
[*&#951;*](){: .math_var } and a contribution of clock-induced charges 
[*CIC*](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ec</sub> = *&#956;*<sub>pc</sub> &#215; *&#951;* + *CIC*

Electron counts are distributed following a Poisson distribution of mean 
[*&#956;*<sub>ec</sub>](){: .math_var } and are then multiplied in the electron-multiplier (EM) register following a gamma distribution with shape parameter 
[*&#956;*<sub>ec</sub>](){: .math_var } and the EM gain 
[*g*](){: .math_var }, for scale parameter.

Multiplied electron counts are converted to image counts 
[*&#956;*<sub>ic</sub>](){: .math_var } with an analog-to-digital factor 
[*s*](){: .math_var } such as:

{: .equation }
*&#956;*<sub>ic</sub> = *&#956;*<sub>ec</sub> / *s*

A constant camera dark count 
[*&#956;*<sub>ic,d</sub>](){: .math_var } is added and image counts are distributed following a Gaussian distribution of mean 
[*&#956;*<sub>ic</sub>](){: .math_var } and standard deviation 
[*&#963;*<sub>ic</sub>](){: .math_var } that represent the readout noise standard deviation 
[*&#963;*<sub>d</sub>](){: .math_var } converted to image counts with the analog-to-digital factor 
[*s*](){: .math_var } such as:

{: .equation }
*&#963;*<sub>ic</sub> = *&#963;*<sub>d</sub> / *s*

**<u>default</u>:** values taken from the literature (reference [here](../../citations.html#simulation-algorithm-testing)):
* [*&#956;*<sub>ic,d</sub>](){: .math_var } = 113 ic
* [*&#951;*](){: .math_var } = 0.95 ec/pc
* [*g*](){: .math_var } = 300
* [*&#963;*<sub>d</sub>](){: .math_var } = 0.067 ec
* [*s*](){: .math_var } = 5.199 ec/ic
* [*CIC*](){: .math_var } = 0.02 ec


### Model parameters
{: .no_toc }

Parameters specific to camera noise model:

| parameter                                     | units             | description                                  | in model               |
| :-------------------------------------------: | :---------------: | -------------------------------------------- | ---------------------- |
| [*&#956;*<sub>ic,d</sub>](){: .math_var }     | ic                | signal offset                                | none, P, N, NexpN, PGN |
| [*&#951;*](){: .math_var }                    | ec/pc             | detection efficiency                         | P, N, NexpN, PGN       |
| [*K*](){: .math_var }                         | ic                | overall gain                                 | N, NExpN               |
| [*sat*](){: .math_var } (read only)           | ic                | saturation value                             | N                      |
| [*&#963;*<sub>d</sub>](){: .math_var }        | ec                | readout noise deviation                      | N, PGN                 |
| [*&#963;*<sub>q</sub>](){: .math_var }        | ic                | analog-to-digital conversion noise deviation | N                      |
| [*&#964;*<sub>CIC</sub>](){: .math_var }      | ic                | exponential tail decay constant              | NExpN                  |
| [*A*<sub>CIC</sub>](){: .math_var }           |                   | exponential decay contribution               | NExpN                  |
| [*&#963;*<sub>ic</sub>](){: .math_var }       | ic                | Gaussian standard deviation                  | NExpN                  |
| [*g*](){: .math_var }                         |                   | system gain                                  | PGN                    |
| [*s*](){: .math_var }                         | ec/ic             | analog-to-digital factor                     | PGN                    |
| [*CIC*](){: .math_var }                       | ec                | CIC offset                                   | PGN                    |

<u>Abbreviations</u>:
* **ic**: image count
* **pc**: photon count
* **ec**: electron count
* **CIC**: clock-induced charges
