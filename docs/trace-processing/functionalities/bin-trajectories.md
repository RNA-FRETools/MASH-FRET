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
In the future, the functionality will be available for projects listed in the 
[Project list](../panels/area-project-management.html).

To bin trajectories, follow the procedure described below.

## Procedure
{: .no_toc .text-delta }

1. TOC
{:toc}

**Note:** *As binned trajectories are not synchronized with the initial single molecule video, video data gets lost after completing the binning procedure.
Therefore, it is recommended to perform all adjustments of molecule positions and background corrections prior binning.*


---

## Export traces to ASCII files

The binning process is performed on ASCII traces.
Therefore, intensity-time traces in the project must be exported to ASCII files.

To export traces to ASCII files:

{: .procedure }
1. Select module Trace processing in MASH's 
   [tool bar](../../Getting_started.html#interface)  
     
1. Import the project by pressing 
   ![Add](../../assets/images/gui/TP-but-add.png "Add") and selecting the 
   [mash file](../../output-files/mash-mash-project.html)  
     
1. Open export options by pressing 
   ![Export ASCII...](../../assets/images/gui/TP-but-export-ascii-3p.png "Export ASCII...") and set the options as desired; please refer to 
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

## Create a new MASH project

To create a project out of binned traces, the ASCII files need to be imported together in module Trace processing and saved to a new common 
[.mash file](../../output-files/mash-mash-project.html).
To correctly import data, MASH must be informed about the particular structure of the files.

Once the new project is created, project parameters including FRET and stoichiometry calculations, must be re-defined.

To create the project out of binned traces:

{: .procedure }
1. Select module Trace processing in MASH's 
   [tool bar](../../Getting_started.html#interface)  
     
1. Set the import settings by pressing 
   ![ASCII options ...](../../assets/images/gui/TP-but-ascii-options-3p.png "ASCII options ..."); see 
   [Set project import options](set-import-options.html) for help  
     
1. Import data by pressing 
   ![Add](../../assets/images/gui/TP-but-add.png "Add") and selecting the ASCII files; this will add a new project to the project list  
     
1. Set the project parameters by selecting the new project in the project list and pressing 
   ![Edit...](../../assets/images/gui/TP-but-edit-3p.png "Edit..."); see 
   [Set project options](../../video-processing/functionalities/set-project-options.html) for more information.
     
1. Save the new project to a 
   [.mash file](../output-files/mash-mash-project.html) by pressing 
   ![Save](../../assets/images/gui/TP-but-save.png "Save").

