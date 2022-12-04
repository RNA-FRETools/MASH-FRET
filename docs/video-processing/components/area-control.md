---
layout: default
title: Control area
parent: Components
grand_parent: Video processing
nav_order: 5
---

<img src="../../assets/images/logos/logo-video-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Control area
{: .no_toc }

The control area consists in two main control buttons. 

Use this area to create and export single molecule intensity-time traces.

## Area components
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Calculate intensity-time traces

Press 
![CALCULATE TRACES](../../assets/images/gui/VP-but-calculatetraces.png "CALCULATE TRACES") to calculate intensity-time traces for each 
[Input coordinates](VP-panel-integration#input-coordinates) and each video frame with parameters defined in 
[Integration parameters](VP-panel-integration#integration-parameters). 
Once the caculations are completed, data in modules 
[Trace processing](../../trace-processing.html) and 
[Histogram analysis](../../histogram-analysis.html) will automatically be refreshed. 

This process can be relatively slow if not enough free memory is available on the computer; in this case the video file is browsed every time a pixel value is needed for calculation. 
For more information, please refer to the respective functions in the source code:

```
MASH-FRET/source/mod_video_processing/create_traces/create_trace.m
MASH-FRET/source/mod_video_processing/create_traces/getIntTrace.m
```


---

## Export data

Press 
![EXPORT...](../../assets/images/gui/VP-but-export3p.png "EXPORT...") to open and set the export options. 
To set export options, please refer to 
[Set export options](../functionalities/set-export-options.html).

After completion, single molecule intensity-time traces are written to the selected file formats along with a 
[.tbl file](../../output-files/tbl-intensity-statistics.html) containing statistics on intensity-time traces.


