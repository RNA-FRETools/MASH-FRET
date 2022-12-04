---
layout: default
title: Bin trajectories
parent: Functionalities
grand_parent: Trace processing
nav_order: 9
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Bin trajectories
{: .no_toc }

Binning trajectories in time can be used to merge projects with different recording rates or to artificially change experimental conditions.

The binning process is performed on ASCII trace files.

To bin trajectories, follow the procedure described below.


## Procedure
{: .no_toc .text-delta }

1. TOC
{:toc}

***Notes:***
* *In the future, the functionality will be available for projects listed in the 
[Project list](../../Getting_started.html#project-management-area).*
* *As binned trajectories are not synchronized with the initial single molecule video, video data gets lost after completing the binning procedure.
Therefore, it is recommended to perform all adjustments of molecule positions and background corrections prior binning.*


---

## Export traces to ASCII files

The binning process is performed on ASCII traces.
Therefore, intensity-time traces in the project must be exported as such.

To export traces to ASCII files:

{: .procedure }
1. Select module Trace processing in MASH's 
   [tool bar](../../Getting_started.html#interface)  
     
1. Import the project by pressing 
   ![Add](../../assets/images/gui/TP-but-add.png "Add") and selecting the 
   [mash file](../../output-files/mash-mash-project.html)  
     
1. Open export options by pressing 
   ![EXPORT...](../../assets/images/gui/TP-but-exportdotdotdot.png "EXPORT...") and set the options as desired; please refer to 
   [Set export options](set-export-options.html) for help.
     
1. Press 
   ![Next >>](../../assets/images/gui/TP-but-next-supsup.png "Next >>") to start writing processed data to files. 


---

## Bin traces and export ASCII files

Trace binning is performed by using the tool `Bin time axis` accessed from MASH-FRET's menu bar.
After completion, the set of binned ASCII files are available in a new sub-folder appended with the actual date: `\binned DD-Mmm-YYYY`

To bin data, the script must be informed about the new time bin in seconds. 
The new time bin must be greater than the original one.

To export certain file columns and not others, use the function `binTrajfiles` in MATLAB's command window; for more information, type `help binTrajfiles` in MATLAB's command window.

To bin trace files:

{: .procedure }
1. Group into one directory the ASCII trace files to bin 
     
1. In MASH-FRET's menu bar, go to `Tools` > `Bin time axis` and select the group directory; a window pops up:  
     
   <img src="../../assets/images/gui/TP-bin-traj-input.png" style="max-width:235px;">  
     
1. Enter the new bin time in seconds (ex: 0.2) and validate by pressing 
   ![OK](../../assets/images/gui/TP-but-ok.png)
     
1. Select the group directory to start trace binning and export.


---

## Create a trajectory-based project

Binned trace files need now to be imported all together in a new trajectory-based project. 
To correctly import data, the experiment setup and FRET and stoichiometry calculations must be configured again in the experiment settings, and the data structure in the imported files must be defined.

To create the project out of binned traces:

{: .procedure }
1. Open the experiment settings window by pressing 
   ![New project](../../assets/images/gui/interface-but-newproj.png "New project") in the 
   [project management area](../../Getting_started#project-management-area) and selecting `import trajectories`.  
     
1. Import a the binned trajectory files and define your experiment setup by configuring tabs:  
     
   [Import](../../tutorials/set-experiment-settings/import-trajectories.html#import)  
   [Channels](../../tutorials/set-experiment-settings/import-trajectories.html#channels)  
   [Lasers](../../tutorials/set-experiment-settings/import-trajectories.html#lasers)  
   [Calculations](../../tutorials/set-experiment-settings/import-trajectories.html#calculations)  
   [Divers](../../tutorials/set-experiment-settings/import-trajectories.html#divers)  
     
   If necessary, modify settings in 
   [Calculations](../../tutorials/set-experiment-settings/import-trajectories.html#calculations) and 
   [Divers](../../tutorials/set-experiment-settings/import-trajectories.html#divers) any time after project creation.  
     
1. Define how data are structured in the files by configuring tab 
   [File structure](../../tutorials/set-experiment-settings/import-trajectories.html#file-structure)  
     
1. Finalize the creation of your project by pressing 
   ![Save](../../assets/images/gui/newproj-but-save.png); the experiment settings window now closes and the interface switches to module Trace processing.  
     
1. Save modifications to a 
   [.mash file](../../output-files/mash-mash-project.html) by pressing 
   ![Save project](../../assets/images/gui/interface-but-saveproj.png "Save project") in the 
   [project management area](../../Getting_started#project-management-area).

