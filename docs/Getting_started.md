---
layout: default
title: Getting started
nav_order: 1
---
# Getting started
{: .no_toc }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}


## Installation
Clone or [download](https://github.com/RNA-FRETools/MASH-FRET/archive/master.zip) MASH-FRET into a directory of your choice.
```
git clone https://github.com/RNA-FRETools/MASH-FRET.git
```

Within Matlab add MASH-FRET to your path by going to `Home → Set Path → Add with Subfolders`
{: .pb-3 }

Start MASH-FRET by typing `MASH` at the MATLAB command prompt.

**Note:** *MASH-FRET is tested to run under Matlab version R2011a and above*

## Interface

<a href="../assets/images/interface-default.png"><img src="../assets/images/interface-default.png" width="300" style="float:right; margin-bottom:10px"/></a>

When you start MASH-FRET the **interactive interface** and **action history** open simultaneously.

The interactive interface appears in its default layout and includes:
* a **tool bar** to switch between <u>modules</u> (default: Video Processing) and set the <u>root folder</u> where generated files will be saved,
* a **main area** that contains the selected module,
* a **menu bar** to set the action history <u>view</u> and execute program <u>routines</u> (*advanced use*).

The action history lists the main events occurring in the program.

**Note:** *Keep the action history or the command window of Matlab visible when using MASH-FRET: information about running processes and failures are streaming in live.
To keep track, logs are automatically written in a 
[daily log file](../output-files/log-daily-logs.html)*.


## Modules

The program offers five modules to work with:

- [Simulation](/docs/simulation)
- [Video processing](/docs/video-processing)
- [Trace processing](/docs/trace-processing)
- [Histogram analysis](/docs/histogram-analysis)
- [Transition analysis](/docs/transition-analysis)

Module functionalities can be used separately or following a specific procedure.

Learn about <u>individual functionalities</u> in the respective module sections of the documentation or follow the <u>tutorials</u> to perform more complex tasks.

## Tutorials

You can follow the tutorials to perform the common tasks listed below:

* [Analyze experimental data](../tutorials/analyze-data)
* [Validate results](../tutorials/validate-results)
* [Test algorithms](../tutorials/test-algorithms)

