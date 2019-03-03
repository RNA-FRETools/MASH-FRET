---
layout: default
title: Video parameters
parent: Simulation panels
grand_parent: Simulation
nav_order: 2
---

# Video parameters
{: .no_toc }

<a href="../../assets/images/gui/sim-panel-video-parameters.png"><img src="../../assets/images/gui/sim-panel-video-parameters.png" style="max-width: 217px;"/></a>

## Panel components
{: .no_toc .text-delta }

1. TOC
{:toc}

## Video length

Total number of image frames in the video. It is usually noted *L*

## Frame rate

Number of frames per second. It is usually noted *f*. It is linked to the acquisition time *acq_t* by the relation:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>f</i> = 1 / <i>acq_t</i>
</p>

## Pixel size

Dimensions of a square pixel in micrometers. It is used in the conversion of PSF widths from micrometers to pixels.

## Bit rate

Camera bit rate in bits per second. It is used to calculate the saturation value in the video.

## Video dimensions

Dimensions in pixels of video frames, in the x- **(a)** and y- **(b)** directions.

## Camera SNR characteristics

<a href="../../assets/images/gui/sim-panel-video-parameters-camera.png"><img src="../../assets/images/gui/sim-panel-video-parameters-camera.png" style="max-width: 198px" /></a>

The models available to generate camera noise are listed in **(a)**. Model parameters to be set in **(b)** are automatically adapted to the model selected in **(a)**.

### Model: none
{: .no_toc }

Add a constant offset value *&#956;*<sub>ic,d</sub>.

### Model: P- or Poisson
{: .no_toc }

Distribute intensities following a Poisson distribution with mean *&#955;*:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
<i>&#955;</i> = <i>intensity</i> x <i>&#951;</i> + <i>&#956;</i><sub>ic,d</sub>
</p>

### Model: N- or Gaussian
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

### Model: NExpN- or Gaussian + exponential tail
{: .no_toc }

Distribute intensities following an exponential-tailed Gaussian distribution with mean *&#956;*<sub>ic,d</sub>, standard deviation *&#963;*<sub>CIC</sub>, tail contribution *A*<sub>CIC</sub> and exponential decay *&#964;*<sub>CIC</sub>.

This model is purely empirical: model parameters are obtained by fitting the dark count distribution with the function:

{: .bg-grey-lt-000 .pt-3 .pb-3 .pl-3 .pr-3 .fs-3}
<p style="border-radius: 5px;">
P = ( 1-<i>A</i><sub>CIC</sub> ) x exp( -( <i>intensity</i> - <i>&#956;</i><sub>ic,d</sub> )<sup>2</sup> / ( 2 x <i>&#963;</i><sub>CIC</sub><sup>2</sup> ) ) + <i>A</i><sub>CIC</sub> x exp( - <i>intensity</i> / <i>&#964;</i><sub>CIC</sub> )
</p>

### Model: PGN- or Hirsch
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
| *&#963;*<sub>d</sub>        | pc                | read-out noise deviation                     | PGN                    |
| *CIC*                       | pc                | CIC offset                                   | PGN                    |

<u>Abbreviations</u>:
* **ic**: image count
* **pc**: photon count
* **ec**: electron count
* **CIC**: clock-induced charges
