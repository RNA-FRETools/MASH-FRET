---
layout: default
title: Collect parameters for simulation
grand_parent: /tutorials
parent: /tutorials/validate-results
nav_order: 1
nav_exclude: true
has_toc: false
---



# Validate results
{: .no_toc }

Follow this procedure to validate the state configuration, state populations and state transition rates determined from an experimental smFRET video analysis.

* **Step 1: Collect parameters for simulation**
* [Step 2: ]()
* [Step 3: ]()
* [Step 4: ]()

<span id="steps"></span>

---

<span class="fs-3">
[STEP 1](collect-simulation-parameters#steps){: .btn .btn-green .mr-4} 
[STEP 2](#steps){: .btn .mr-4} 
[STEP 3](#steps){: .btn .mr-4} 
[STEP 4](#steps){: .btn .mr-4}
</span>

# STEP 1: Collect parameters for simulation
{: .no_toc }

---

In this step, a maximum number of parameters are collected or calculated from the previous experimental data analysis.

1. TOC
{:toc}

---

1. Use the **files** exported during your previous analysis to collect or calculate <u>experimental parameters</u>:  
     
   &#9745; number of molecules  
   &#9745; summed fluorescence <u>intensities</u> (corrected donor + acceptor intensities)  (in 
   [trace files](../../output-files/txt-processed-traces.html))  
   &#9745; average channel-specific <u>background</u> intensities  (in 
   [parameters files](../../output-files/log-processing-parameters.html))  
   &#9745; <u>FRET states</u>  
   &#9745; state <u>transition rates</u>  
   
1. Use the experimental parameters and your **setup characteristics** in 
[Simulation](../../simulation) to <u>generate</u> synthetic intensity-time traces.  
      
	**Note:** *To simulate kinetic heterogeneity, use a number of degenerated FRET states equal to the number of exponential components*.
     
   Export generated time-traces to "Ideal traces" ASCII files.
   
1. Load your freshly exported **ASCII files** in 
[Trace processing](../../trace-processing) to edit <u>project parameters</u>.  
     
   Save modifications and calculation to a new 
   [mash project](../../output-files/mash-mash-project.html). Use a file name different from the experimental project (for example with the extension *_sim).

1. Perform steps 3, 4 and 5 of 
[smFRET video analysis](../analyze-data) on your 
[mash project](../../output-files/mash-mash-project.html).

1. Validate or invalidate your experimental thermodynamic model by comparing with results on simulation:  
     
	&#9745; the <u>FRET states</u>  
	&#9745; the state <u>transition rates</u>  
    &#9745; the states <u>relative populations</u>  

---

<span class="fs-3">
[STEP 1](collect-simulation-parameters#steps_bottom){: .btn .btn-green .mr-4} 
[STEP 2](#steps_bottom){: .btn .mr-4} 
[STEP 3](#steps_bottom){: .btn .mr-4} 
[STEP 4](#steps_bottom){: .btn .mr-4}</span>

---

<span id="steps_bottom"></span>
