---
layout: default
title: Find states in traces
grand_parent: Tutorials
parent: Analyze data
nav_order: 2
nav_exclude: true
has_toc: false
---


# Analyze data
{: .no_toc }

Follow this procedure to process your single molecule videos (SMVs) or trajectories and characterize the molecule dynamics in your sample.

* [Step 1: Create traces](create-traces.html)
* **Step 2: Find states in traces**
* [Step 3: Identify state network](identify-state-network.html)
* [Step 4: Determine state populations](determine-state-populations.html)

**Note:** *Skip step 1 if already in possession of intensity-time traces files (ASCII or 
[mash project](../../output-files/mash-mash-project.html)).*

<span id="steps"></span>

---

<span class="fs-3">[STEP 1](create-traces.html#steps){: .btn .mr-4} [STEP 2](find-states-in-traces.html#steps){: .btn .btn-green .mr-4} [STEP 3](identify-state-network.html#steps){: .btn .mr-4} [STEP 4](determine-state-populations.html#steps){: .btn .mr-4}</span>

## STEP 2: Find states in traces 
{: .no_toc }

---

In this step, single molecules are sorted, intensity-time traces are corrected from experimental bias and state sequences are inferred for individual traces.

1. TOC
{:toc}

---

### Setup working area

1. Select module 
[Trace processing](../../trace-processing) in MASH-FRET's [tool bar](../../Getting_started.html#interface).

1. Load your freshly created 
[mash project](../../output-files/mash-mash-project.html)


### Correct for experimental bias

<u>Adjust single molecule position</u>

1. Re-center target on the brightest pixel

1. Unselect molecules with overlap

<u>Set up background corrections</u>

<u>Set up factor corrections</u>


### Refine your single molecule set

<u>Sort single molecules with Trace Manager</u>

1. Visualize and <u>select</u> appropriate intensity-time traces

1. (optional) Set intensity-time trace labels

<u>Clear inappropriate trajectories from the set</u>

1. Clear

1. Save project


### Discretize time-traces

1. Cut out photobleached segments in intensity-time traces

1. <u>discretize</u> FRET trajectories into states


### Save and export

1. Save modifications and calculation to your 
[mash project](../../output-files/mash-mash-project.html) file.

1. (optional) Export corrected time-traces and calculations to ASCII files.

---

<span class="fs-3">[STEP 1](create-traces.html#steps_bottom){: .btn .mr-4} [STEP 2](find-states-in-traces.html#steps_bottom){: .btn .btn-green .mr-4} [STEP 3](identify-state-network.html#steps_bottom){: .btn .mr-4} [STEP 4](determine-state-populations.html#steps_bottom){: .btn .mr-4}</span>

---

<span id="steps_bottom"></span>
