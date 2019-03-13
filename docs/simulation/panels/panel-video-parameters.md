---
layout: default
title: Video parameters
parent: /simulation/panels
grand_parent: /simulation
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

It is usually noted *L*

**<u>default</u>:** *L* = 4000 frames

---

## Frame rate

It is acquisition rate of the video in frames per second (fps). 

It is usually noted *f*. It is linked to the acquisition time *t*<sub>exp</sub> by the relation:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>f</i> = 1 / <i>t</i><sub>exp</sub>
</p>

with *acq_t* is second

**<u>default</u>:** *f* = 10 fps

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

They are the settings to generate camera noise.

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

Add a constant offset value *&#956;*<sub>ic,d</sub>.

**<u>default</u>:** *&#956;*<sub>ic,d</sub> = 113 ic


### P- or Poisson
{: .no_toc }

Distribute intensities following a Poisson distribution with mean *&#955;*:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>&#955;</i> = <i>intensity</i> x <i>&#951;</i> + <i>&#956;</i><sub>ic,d</sub>
</p>

**<u>default</u>:**
* *&#956;*<sub>ic,d</sub> = 113 ic
* *&#951;* = 0.95 


### N- or Gaussian
{: .no_toc }

Distribute intensities following a Gaussian distribution with mean *&#956;*:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>&#956;</i> = <i>intensity</i> x <i>&#951;</i> x <i>K</i> + <i>&#956;</i><sub>ic,d</sub>
</p>

and standard deviation *&#963;*:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>&#963;</i> = (  <i>intensity</i> x <i>&#951;</i> x <i>K</i> + ( <i>K</i> x <i>&#963;</i><sub>d</sub> )<sup>2</sup> + <i>&#963;</i><sub>q</sub><sup>2</sup> )<sup>0.5</sup>
</p>

**<u>default</u>:** values taken from the literature (reference [here](../../citations.html#simulation-algorithm-testing)):
* *&#956;*<sub>ic,d</sub> = 113 ic.ec
* *&#951;* = 0.95 
* *K* = 57.8 ic/ec
* *&#963;*<sub>d</sub> = 0.067 ec
* *&#963;*<sub>q</sub> = 0 ic


### NExpN- or Gaussian + exponential tail
{: .no_toc }

Distribute intensities following an exponential-tailed Gaussian distribution with mean *&#956;*<sub>ic,d</sub>, standard deviation *&#963;*<sub>CIC</sub>, tail contribution *A*<sub>CIC</sub> and exponential decay *&#964;*<sub>CIC</sub>.

This model is purely empirical: model parameters are obtained by fitting the dark count distribution with the function:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
P = ( 1-<i>A</i><sub>CIC</sub> ) x exp( -( <i>intensity</i> - <i>&#956;</i><sub>ic,d</sub> )<sup>2</sup> / ( 2 x <i>&#963;</i><sub>CIC</sub><sup>2</sup> ) ) + <i>A</i><sub>CIC</sub> x exp( - <i>intensity</i> / <i>&#964;</i><sub>CIC</sub> )
</p>

**Note:** *Random generation of NExpN noise is very time consuming. Expect spending around 8 hours to simulate a 256-by-256-wide and 4000 frame-long video.*

**<u>default</u>:** values taken from the literature (reference [here](../../citations.html#simulation-algorithm-testing)):
* *&#956;*<sub>ic,d</sub> = 106.9 ic
* *A*<sub>CIC</sub> = 0.02 
* *&#963;*<sub>CIC</sub> = 4.9 ic
* *&#964;*<sub>CIC</sub> = 20.5
* *&#951;* = 0.95 
* *K* = 57.8 ic/ec

### PGN- or Hirsch
{: .no_toc }

Distribute intensities following the convolution of a Poisson distribution of mean *&#955;*<sub>p</sub>:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>&#955;</i><sub>p</sub> = <i>intensity</i> x <i>&#951;</i> + <i>CIC</i>
</p>

with a Gamma distribution of scale parameter *g*, and with a Gaussian distribution of mean *&#956;*<sub>g</sub>:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>&#956;</i><sub>g</sub> = <i>intensity</i> + <i>&#956;</i><sub>ic,d</sub>
</p>

and standard deviation *&#963;*<sub>g</sub>:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>&#963;</i><sub>g</sub> = <i>&#963;</i><sub>d</sub> x <i>g</i> / <i>s</i>
</p>

**<u>default</u>:** values taken from the literature (reference [here](../../citations.html#simulation-algorithm-testing)):
* *&#956;*<sub>ic,d</sub> = 113 ic.ec
* *&#951;* = 0.95 
* *g* = 300
* *&#963;*<sub>d</sub> = 0.067 ec
* *s* = 0 ic
* *CIC* = 0.02 ec


### Model parameters
{: .no_toc }

Parameters specific to camera noise model:

| parameter                   | units             | description                                  | in model               |
| :-------------------------: | :---------------: | -------------------------------------------- | ---------------------- |
| *&#956;*<sub>ic,d</sub>     | ic                | signal offset                                | none, P, N, NexpN, PGN |
| *&#951;*                    |                   | detection efficiency                         | P, N, NexpN, PGN       |
| *K*                         | pc/ec             | overall gain                                 | N, NExpN               |
| *sat* (read only)           | ic                | saturation value                             | N                      |
| *&#963;*<sub>d</sub>        | pc                | readout noise deviation                      | N, PGN                 |
| *&#963;*<sub>q</sub>        | pc                | analog-to-digital conversion noise deviation | N                      |
| *&#964;*<sub>CIC</sub>      | ec                | CIC exponential decay constant               | NExpN                  |
| *A*<sub>CIC</sub>           |                   | CIC exponential decay contribution           | NExpN                  |
| *&#963;*<sub>CIC</sub>      | ic                | Gaussian noise deviation                     | NExpN                  |
| *g*                         | pc/ic             | System gain                                  | PGN                    |
| *s*                         | ic/pc             | analog-to-digital factor                     | PGN                    |
| *CIC*                       | pc                | CIC offset                                   | PGN                    |

<u>Abbreviations</u>:
* **ic**: image count
* **pc**: photon count
* **ec**: electron count
* **CIC**: clock-induced charges
