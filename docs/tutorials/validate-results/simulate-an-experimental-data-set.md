---
layout: default
title: Simulate an experimental data set
grand_parent: /tutorials.html
parent: /tutorials/validate-results.html
nav_order: 2
nav_exclude: true
has_toc: false
---

<img src="../../assets/images/logos/logo-tutorials_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Validate results
{: .no_toc }

Follow this procedure to validate the state configuration, state populations and state transition rates determined from an experimental smFRET video analysis.

{% include tutorial_head.html %}

In this step, synthetic data are generated with collected experimental parameters to obtain an experimental-alike data set.

1. TOC
{:toc}

---

*In construction*

<!--
1. Use the **files** exported during your previous analysis to collect or calculate <u>experimental parameters</u>:  
     
   &#9745; number of molecules  
   &#9745; summed fluorescence <u>intensities</u> (corrected donor + acceptor intensities)  (in 
   [trace files](../../output-files/txt-processed-traces.html))  
   &#9745; average channel-specific <u>background</u> intensities  (in 
   [parameters files](../../output-files/log-processing-parameters.html))  
   &#9745; <u>FRET states</u>  
   &#9745; state <u>transition rates</u>  
   
1. Use the experimental parameters and your **setup characteristics** in 
[Simulation](../../simulation.html) to <u>generate</u> synthetic intensity-time traces.  
      
	**Note:** *To simulate kinetic heterogeneity, use a number of degenerated FRET states equal to the number of exponential components*.
     
   Export generated time-traces to "Ideal traces" ASCII files.
   
1. Load your freshly exported **ASCII files** in 
[Trace processing](../../trace-processing.html) to edit <u>project parameters</u>.  
     
   Save modifications and calculation to a new 
   [mash project](../../output-files/mash-mash-project.html). Use a file name different from the experimental project (for example with the extension *_sim).

1. Perform steps 3, 4 and 5 of 
[smFRET video analysis](../analyze-data.html) on your 
[mash project](../../output-files/mash-mash-project.html).

1. Validate or invalidate your experimental thermodynamic model by comparing with results on simulation:  
     
	&#9745; the <u>FRET states</u>  
	&#9745; the state <u>transition rates</u>  
    &#9745; the states <u>relative populations</u>  

-->
	
---

{% include tutorial_footer.html %}
