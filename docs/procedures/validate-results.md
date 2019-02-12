---
layout: default
title: Validate results
parent: Procedures
nav_order: 2
---


# Validate results
{: .no_toc }

Follow this procedure to validate the thermodynamic model determined from smFRET video analysis:

1. Use the **files** exported during your previous analysis to collect or calculate <u>experimental parameters</u>:  
     
   &#9745; number of molecules  
   &#9745; summed fluorescence <u>intensities</u> (corrected donor + acceptor intensities)  (in [trace files](output-files/txt-trace-processing-traces.html)  
   &#9745; average channel-specific <u>background</u> intensities  (in [parameters files](output-files/log-trace-processing-parameters.html))  
   &#9745; <u>FRET states</u>  
   &#9745; state <u>transition rates</u>  
   
1. Use the experimental parameters and your **setup characteristics** in [Simulation](docs/simulation/simulation.html) to <u>generate</u> synthetic intensity-time traces.  
      
	**Note:** *To simulate kinetic heterogeneity, use a number of degenerated FRET states equal to the number of exponential components*.
     
   Export generated time-traces to "Ideal traces" ASCII files.
   
1. Load your freshly exported **ASCII files** in [Trace processing](docs/trace-processing/trace-processing.html) to edit <u>project parameters</u>.  
     
   Save modifications and calculation to a new *[.mash project](output-files/mash-mash-project.html). Use a file name different from the experimental project (for example with the extension *_sim).

1. Perform steps 3, 4 and 5 of [smFRET video analysis](Getting_starded.html#smfret-video-analysis) on your *[.mash project](output-files/mash-mash-project.html).

1. Validate or invalidate your experimental thermodynamic model by comparing with results on simulation:  
     
	&#9745; the <u>FRET states</u>  
	&#9745; the state <u>transition rates</u>  
    &#9745; the states <u>relative populations</u>  