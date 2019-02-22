---
layout: default
title: Create traces
grand_parent: Tutorials
parent: Analyze data
nav_order: 1
nav_exclude: true
has_toc: false
---


# Analyze data
{: .no_toc }

Follow this procedure to process your single molecule videos (SMVs) or trajectories and characterize the molecule dynamics in your sample.

* **Step 1: Create traces**
* [Step 2: Find states in traces](find-states-in-traces.html)
* [Step 3: Identify state network](identify-state-network.html)
* [Step 4: Determine state populations](determine-state-populations.html)

**Note:** *Skip step 1 if already in possession of intensity-time traces files (ASCII or 
[mash project](../../output-files/mash-mash-project.html)).*

<span id="steps"></span>

---

<span class="fs-3">[STEP 1](create-traces.html#steps){: .btn .btn-green .mr-4} [STEP 2](find-states-in-traces.html#steps){: .btn .mr-4} [STEP 3](identify-state-network.html#steps){: .btn .mr-4} [STEP 4](determine-state-populations.html#steps){: .btn .mr-4}</span>

## STEP 1: Create traces
{: .no_toc }

---

In this step, single molecules are first localized on the single molecule video and respective intensity-time traces are then calculated.

1. TOC
{:toc}

---

### Setup working area

1. Create a <u>root folder</u> named after your experiment and set root path in MASH-FRET's [tool bar](../../Getting_started.html#interface).

1. Select module 
[<u>Video processing</u>](../../video-processing) in MASH-FRET's [tool bar](../../Getting_started.html#interface).


### Obtain transformation file

1. With a reference **beads image** or video in hands export an <u>average image</u> of the beads video if necessary.

1. Map <u>reference coordinates</u> on the beads image and export to file.

1. Calculate <u>channel transformation</u> and save to file.

1. Check the <u>quality</u> of transformation


### Fill in experiment settings


### Create single molecule coordinates file

1. With your SMV file in hands export an <u>average image</u>.

1. Find and save bright spots coordinates with <u>Spotfinder</u>.

1. <u>Transform</u> spots coordinates to other channels.


### Create and export intensity-time traces

Create <u>intensity-time traces</u> of donor and acceptor channels and save data to a 
[mash project](../../output-files/mash-mash-project.html) file.

---

<span class="fs-3">[STEP 1](create-traces.html#steps_bottom){: .btn .btn-green .mr-4} [STEP 2](find-states-in-traces.html#steps_bottom){: .btn .mr-4} [STEP 3](identify-state-network.html#steps_bottom){: .btn .mr-4} [STEP 4](determine-state-populations.html#steps_bottom){: .btn .mr-4}</span>

---

<span id="steps_bottom"></span>
