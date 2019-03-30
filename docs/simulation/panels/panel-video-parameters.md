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
<span style="font-family: Times;">*L*</span>

**<u>default</u>:** 
<span style="font-family: Times;">*L*</span> = 4000 frames

---

## Frame rate

It is acquisition rate of the video in frames per second (fps). 

It is usually noted 
<span style="font-family: Times;">*f*</span>. 
It is linked to the acquisition time 
<span style="font-family: Times;">*t*<sub>exp</sub></span> 
by the relation:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>f</i> = 1 / <i>t</i><sub>exp</sub>
</p>

with 
<span style="font-family: Times;">*t*<sub>exp</sub></span> 
in seconds

**<u>default</u>:** 
<span style="font-family: Times;">*f*</span> = 10 fps

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
<span style="font-family: Times;">*&#956;*<sub>pc</sub></span> 
are ideally converted to image counts 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ic</sub> = <i>&#956;</i><sub>pc</sub>
</p>

A constant camera dark count 
<span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> 
is then added.

**<u>default</u>:** 
<span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> = 113 ic


### P- or Poisson
{: .no_toc }

Photon counts 
<span style="font-family: Times;">*&#956;*<sub>pc</sub></span> 
are converted to electron counts 
<span style="font-family: Times;">*&#956;*<sub>ec</sub></span> 
with a detection efficiency 
<span style="font-family: Times;">*&#951;*</span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ec</sub> = <i>&#956;</i><sub>pc</sub> &#215; <i>&#951;</i>
</p>

Electron counts are distributed following a Poisson distribution and are ideally converted to image counts 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ic</sub> = <i>&#956;</i><sub>ec</sub>
</p>

A constant camera dark count 
<span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> 
is then added.

**<u>default</u>:**
* <span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> = 113 ic
* <span style="font-family: Times;">*&#951;*</span> = 0.95 ec/pc


### N- or Gaussian
{: .no_toc }

Photon counts 
<span style="font-family: Times;">*&#956;*<sub>pc</sub></span> 
are converted to electron counts 
<span style="font-family: Times;">*&#956;*<sub>ec</sub></span> 
with a detection efficiency 
<span style="font-family: Times;">*&#951;*</span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ec</sub> = <i>&#956;</i><sub>pc</sub> &#215; <i>&#951;</i>
</p>

Electron counts are converted to image counts 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span> 
with an overall gain 
<span style="font-family: Times;">*K*</span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ic</sub> = <i>&#956;</i><sub>ec</sub> &#215; <i>K</i>
</p>

A constant camera dark count 
<span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> 
is added and image counts are distributed following a Gaussian distribution of mean 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span> 
and standard deviation 
<span style="font-family: Times;">*&#963;*<sub>ic</sub></span> 
that depends on 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span>, 
the readout noise standard deviation 
<span style="font-family: Times;">*&#963;*<sub>d</sub></span> 
and the analog-to-digital noise standard deviation 
<span style="font-family: Times;">*&#963;*<sub>q</sub></span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#963;</i><sub>ic</sub> = (  <i>&#956;</i><sub>ic</sub> + ( <i>K</i> &#215; <i>&#963;</i><sub>d</sub> )<sup>2</sup> + <i>&#963;</i><sub>q</sub><sup>2</sup> )<sup>0.5</sup>
</p>

**<u>default</u>:** values taken from the literature (reference 
[here](../../citations.html#simulation-algorithm-testing)):
* <span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> = 113 ic
* <span style="font-family: Times;">*&#951;*</span> = 0.95 ec/pc
* <span style="font-family: Times;">*K*</span> = 57.8 ic/ec
* <span style="font-family: Times;">*&#963;*<sub>d</sub></span> = 0.067 ec
* <span style="font-family: Times;">*&#963;*<sub>q</sub></span> = 0 ic


### NExpN- or Gaussian + exponential tail
{: .no_toc }

Photon counts 
<span style="font-family: Times;">*&#956;*<sub>pc</sub></span> 
are converted to electron counts 
<span style="font-family: Times;">*&#956;*<sub>ec</sub></span> 
with a detection efficiency 
<span style="font-family: Times;">*&#951;*</span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ec</sub> = <i>&#956;</i><sub>pc</sub> &#215; <i>&#951;</i>
</p>

Electron counts are converted to image counts 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span> 
with an overall gain 
<span style="font-family: Times;">*K*</span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ic</sub> = <i>&#956;</i><sub>ec</sub> &#215; <i>K</i>
</p>

A constant camera dark count 
<span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> 
is added and image counts are distributed following an exponential-tailed Gaussian distribution with mean 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span>, 
standard deviation 
<span style="font-family: Times;">*&#963;*<sub>ic</sub></span>, 
tail contribution 
<span style="font-family: Times;">*A*<sub>CIC</sub></span> 
and exponential decay 
<span style="font-family: Times;">*&#964;*<sub>CIC</sub></span>.

This model is purely empirical: model parameters are obtained by fitting the distribution 
<span style="font-family: Times;">P</span> 
of image counts obtain from a camera with closed shutter 
<span style="font-family: Times;">*&#956;*<sub>ic,0</sub></span>
with the function:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
P(<i>&#956;</i><sub>ic,0</sub>) = ( 1-<i>A</i><sub>CIC</sub> ) &#215; exp( -( <i>&#956;</i><sub>ic,0</sub> - <i>&#956;</i><sub>ic,d</sub> )<sup>2</sup> / ( 2 &#215; <i>&#963;</i><sub>ic</sub><sup>2</sup> ) ) + <i>A</i><sub>CIC</sub> &#215; exp( - <i>intensity</i> / <i>&#964;</i><sub>CIC</sub> )
</p>

**Note:** *Random generation of NExpN noise is very time consuming. 
Expect spending around 8 hours to simulate a 256-by-256-wide and 4000 frame-long video.*

**<u>default</u>:** values taken from the literature (reference 
[here](../../citations.html#simulation-algorithm-testing)):
* <span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> = 106.9 ic
* <span style="font-family: Times;">*A*<sub>CIC</sub></span> = 0.02 
* <span style="font-family: Times;">*&#963;*<sub>ic</sub></span> = 4.9 ic
* <span style="font-family: Times;">*&#964;*<sub>CIC</sub></span> = 20.5 ic
* <span style="font-family: Times;">*&#951;*</span> = 0.95 ec/pc
* <span style="font-family: Times;">*K*</span> = 57.8 ic/ec

### PGN- or Hirsch
{: .no_toc }

Photon counts 
<span style="font-family: Times;">*&#956;*<sub>pc</sub></span> 
are converted to electron counts 
<span style="font-family: Times;">*&#956;*<sub>ec</sub></span> 
with a detection efficiency 
<span style="font-family: Times;">*&#951;*</span> 
and a contribution of clock-induced charges 
<span style="font-family: Times;">*CIC*</span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ec</sub> = <i>&#956;</i><sub>pc</sub> &#215; <i>&#951;</i> + <i>CIC</i>
</p>

Electron counts are distributed following a Poisson distribution of mean 
<span style="font-family: Times;">*&#956;*<sub>ec</sub></span> 
and are then multiplied in the electron-multiplier (EM) register following a gamma distribution with shape parameter 
<span style="font-family: Times;">*&#956;*<sub>ec</sub></span> 
and the EM gain 
<span style="font-family: Times;">*g*</span>,
for scale parameter.

Multiplied electron counts are converted to image counts 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span> 
with an analog-to-digital factor 
<span style="font-family: Times;">*s*</span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#956;</i><sub>ic</sub> = <i>&#956;</i><sub>ec</sub> / <i>s</i>
</p>

A constant camera dark count 
<span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> 
is added and image counts are distributed following a Gaussian distribution of mean 
<span style="font-family: Times;">*&#956;*<sub>ic</sub></span> 
and standard deviation 
<span style="font-family: Times;">*&#963;*<sub>ic</sub></span> 
that represent the readout noise standard deviation 
<span style="font-family: Times;">*&#963;*<sub>d</sub></span> 
converted to image counts with the analog-to-digital factor 
<span style="font-family: Times;">*s*</span> 
such as:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3}
<p style="font-family: Times; border-radius: 5px;">
<i>&#963;</i><sub>ic</sub> = <i>&#963;</i><sub>d</sub> / <i>s</i>
</p>

**<u>default</u>:** values taken from the literature (reference [here](../../citations.html#simulation-algorithm-testing)):
* <span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span> = 113 ic
* <span style="font-family: Times;">*&#951;*</span> = 0.95 ec/pc
* <span style="font-family: Times;">*g*</span> = 300
* <span style="font-family: Times;">*&#963;*<sub>d</sub></span> = 0.067 ec
* <span style="font-family: Times;">*s*</span> = 5.199 ec/ic
* <span style="font-family: Times;">*CIC*</span> = 0.02 ec


### Model parameters
{: .no_toc }

Parameters specific to camera noise model:

| parameter                                                            | units             | description                                  | in model               |
| :------------------------------------------------------------------: | :---------------: | -------------------------------------------- | ---------------------- |
| <span style="font-family: Times;">*&#956;*<sub>ic,d</sub></span>     | ic                | signal offset                                | none, P, N, NexpN, PGN |
| <span style="font-family: Times;">*&#951;*</span>                    | ec/pc             | detection efficiency                         | P, N, NexpN, PGN       |
| <span style="font-family: Times;">*K*</span>                         | ic                | overall gain                                 | N, NExpN               |
| <span style="font-family: Times;">*sat*</span> (read only)           | ic                | saturation value                             | N                      |
| <span style="font-family: Times;">*&#963;*<sub>d</sub></span>        | ec                | readout noise deviation                      | N, PGN                 |
| <span style="font-family: Times;">*&#963;*<sub>q</sub></span>        | ic                | analog-to-digital conversion noise deviation | N                      |
| <span style="font-family: Times;">*&#964;*<sub>CIC</sub></span>      | ic                | exponential tail decay constant              | NExpN                  |
| <span style="font-family: Times;">*A*<sub>CIC</sub></span>           |                   | exponential decay contribution               | NExpN                  |
| <span style="font-family: Times;">*&#963;*<sub>ic</sub></span>       | ic                | Gaussian standard deviation                  | NExpN                  |
| <span style="font-family: Times;">*g*</span>                         |                   | system gain                                  | PGN                    |
| <span style="font-family: Times;">*s*</span>                         | ec/ic             | analog-to-digital factor                     | PGN                    |
| <span style="font-family: Times;">*CIC*</span>                       | ec                | CIC offset                                   | PGN                    |

<u>Abbreviations</u>:
* **ic**: image count
* **pc**: photon count
* **ec**: electron count
* **CIC**: clock-induced charges
