---
layout: default
title: Simulate sample heterogeneity
parent: /simulation/functionalities.html
grand_parent: /simulation.html
nav_order: 3
---

# Simulate sample heterogeneity
{: .no_toc }

Sample heterogeneity is characterized by the presence of molecule sub-populations with different characteristics.
It can be simulated for various characteristics by using one of the following methods:

1. TOC
{:toc}


---

## Parameter deviations

This method can be used to introduce sample heterogeneity in FRET states 
[*FRET*<sub>*j*</sub>](){: .math_var }, donor emission in absence of acceptor 
[*I*<sub>tot,em</sub>](){: .math_var } and gamma factors 
[*&#947;*](){: .math_var }.

Parameters are randomly generated for each molecule by drawing from Gaussian distributions with means respectively defined in fields 
`FRETj`, `Itot,em`, `γ`, and standard deviation in fields `wFRETj`, `wItot,em` and `wγ`.

This method produces a continuous sample heterogeneity, *i.e.*, a broadening of molecule characteristics as opposed to the creation of sub-populations of molecules with distinguishable characteristics.


---

## Molecule-specific pre-sets

This method can be used to introduce sample heterogeneity in FRET states 
[*FRET*<sub>*j*</sub>](){: .math_var }, state transition rates 
[*k*<sub>*jj'*</sub>](){: .math_var }, donor emission in absence of acceptor 
[*I*<sub>tot,em</sub>](){: .math_var }, gamma factors 
[*&#947;*](){: .math_var } and PSF widths 
[*w*<sub>det</sub>](){: .math_var }.

Parameters are defined individually for each molecule by loading a pre-set parameter file with the respective variables `FRET`, `trans_rates`, `tot_intensity`, `gamma` and `psf_width` set accordingly. 
For more information about the structure and use of pre-set parameter file, please refer to 
[Pre-set parameters](../panels/panel-molecules.html#pre-set-parameters).

This method allows to custom the type of sample heterogeneity by either producing a broadening of molecule characteristics or by creating sub-populations of molecules with distinguishable characteristics.

As an example, this script creates two distinct molecule sub-populations of equal size, with one population allowing step-wise and reversible state transitions, and one getting trapped after an off-path state transition:

```matlab
%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defines 4-by-4 transition rates for the first population
trans_rates1 = [ 0   0.1 0   0
		 0.1 0   0.1 0
		 0   0.1 0   0.1
		 0   0   0.1 0];
		
% defines 4-by-4 transition rates for the second population
trans_rates2 = [ 0   0.1 0   0
		 0.1 0   0   0.1
		 0   0   0   0
		 0   0   0   0];

% replicate the first and second transition rates matrix for half of the molecules with the repmat function
trans_rates1 = repmat(trans_rates1,[1 1 N/2]);
trans_rates2 = repmat(trans_rates2,[1 1 N/2]);

% concatenate both sub-populations into one sample
trans_rates = cat(3,trans_rates1,trans_rates2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
```

To build and export the pre-set parameter file:

{: .procedure }
1. Open the pre-set template in MATLAB's editor by going to menu `Open → Open ...` and selecting the file `MASH-FRET/createSimPrm.m`.  
      
1. Define the variable `trans_rates` in the corresponding section of the template  
     
1. Type `createSimPrm` in MATLAB's command window to run the script and export the pre-set parameter file.  
     
1. load the pre-sets by pressing 
![...](../../assets/images/gui/sim-but-3p.png "...") in 
[Pre-set parameters](../panels/panel-molecules.html#pre-set-parameters) and selecting the corresponding file


---

## Partitioned transition rate matrix

This method can be used to introduce sample heterogeneity in state transition rates 
[*k*<sub>*jj'*</sub>](){: .math_var } and consists in defining closed transition networks within the same 
[Transition rates matrix](../panels/panel-molecules.html#transition-rates), with each state having a certain probability to start a state trajectory.
In that way, trajectories in the sample can follow only one of the state network defined in the transition rates matrix.

This method produces a discontinuous sample heterogeneity, *i.e.*, it creates sub-populations of molecules with distinguishable characteristics as opposed to a broadening of molecule characteristics.

As an example, this partition of the transition rate matrix produces two distinct molecule sub-populations following either the state network (1,2) or (3,4,5).

| states  | 1       | 2       | 3       | 4       | 5       |
| :-----: | :-----: | :-----: | :-----: | :-----: | :-----: |
| **1**   | 0       | **0.1** | 0       | 0       | 0       |
| **2**   | **0.1** | 0       | 0       | 0       | 0       |
| **3**   | 0       | 0       | 0       | **0.1** | 0       |
| **4**   | 0       | 0       | **0.1** | 0       | **0.1** |
| **5**   | 0       | 0       | 0       | **0.1** | 0       |

The size of the two sub-populations depends on the overall probability to start the state trajectory with one of the states of the respective network.
