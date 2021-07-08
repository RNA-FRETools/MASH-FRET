---
layout: default
title: Restructure ALEX files
parent: Functionalities
grand_parent: Trace processing
nav_order: 8
---

<img src="../../assets/images/logos/logo-trace-processing_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Restructure ALEX files
{: .no_toc }

Intensities recorded with alternating laser excitations (ALEX) can be imported to MASH-FRET from ASCII files. 
When laser-specific intensities are written in a column-wise fashion, files must be restructured prior being imported.

To import ALEX data from ASCII files, follow the procedure described below.

## Procedure
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Restructure ALEX data

File reformatting is performed by using the tool `Restructure files` accessed from MASH-FRET's menu bar.
After completion, the set of restructured ASCII files are available in a new sub-folder appended with the actual date: `\restructured DD-Mmm-YYYY`

Reformatting can be done in two ways:
- for Trace processing import, where only intensity data are formatted
- for Transition analysis import, where all data are formatted, including ratio data

To correctly format data for import in Transition analysis, the script must be informed about which laser wavelength is assigned to which ratio data. 

To restructure ALEX trace files:

{: .procedure }
1. Group all ASCII trace files to restructure together into one directory
     
1. In MASH-FRET's menu bar, go to `Tools` > `Restructure files` and select the group directory; a window pops up:  
     
   <img src="../../assets/images/gui/TP-merge-project-warn1.png" style="max-width:555px;">  
     
1. Choose the proper file format by pressing 
   ![for Trace processing](../../assets/images/gui/TP-but-for-trace-processing.png)  to start formatting, or 
   ![for Transition analysis](../../assets/images/gui/TP-but-for-transition-analysis.png) to assign laser wavelengths to each ratio data  
     
   <img src="../../assets/images/gui/TP-merge-project-warn2.png" style="max-width:206px;">  
	 
1. After assigning laser wavelengths press 
   ![Save](../../assets/images/gui/TP-but-save.png "Save") to start formatting


---

## Create a mash project

To group all traces into one project, the ASCII files need to be imported together in module Trace processing and saved to a new common 
[.mash file](../../output-files/mash-mash-project.html).
To correctly import data, MASH must be informed about the particular structure of the files.

Once the project is created, project parameters including FRET and stoichiometry calculations, must be defined.

To create the project:

{: .procedure }
1. Select module Trace processing in MASH's 
   [tool bar](../../Getting_started.html#interface)  
     
1. Set the import settings by pressing 
   ![ASCII options ...](../../assets/images/gui/TP-but-ascii-options-3p.png "ASCII options ..."); see 
   [Set import options](set-import-options.html) for help  
     
1. Import data by pressing 
   ![Add](../../assets/images/gui/TP-but-add.png "Add") and selecting the ASCII files to merge; this will add a new project to the project list  
     
1. Set the project parameters by pressing 
   ![Edit...](../../assets/images/gui/TP-but-edit-3p.png "Edit..."); see 
   [Set project options](../../video-processing/functionalities/set-project-options.html) for more information.
     
1. Save the project to a 
   [.mash file](../output-files/mash-mash-project.html) by pressing 
   ![Save](../../assets/images/gui/TP-but-save.png "Save").

