---
layout: default
title: Simulate larger systems
parent: /simulation/functionalities.html
grand_parent: /simulation.html
nav_order: 2
---

# Simulate larger systems
{: .no_toc }

For more practicability, the matrix of
[Transition rates](../panels/panel-molecules.html#transition-rates) in module Simulation is limited to a five-state system.
The simulation of larger systems requires to import FRET states and transition rates from an external file into 
[Pre-set parameters](../panels/panel-molecules.html#pre-set-parameters).

To create and import simulation parameters for a large state system, follow the procedure described below.

## Procedure
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Create a pre-set file

The pre-set parameter file is a MATLAB binary file that can be created with the template function 
`createSimPrm` in MATLAB's editor.

To simulate systems with more than five states, the pre-set parameter file needs to contain the
[*J*](){: .math_var } FRET state values 
[*FRET*<sub>*j*</sub>](){: .math_var } with corresponding deviations 
[*wFRET*<sub>*j*</sub>](){: .math_var }, as well as the state transition rates 
[*k*<sub>*jj'*</sub>](){: .math_var }; see 
[State configuration](../panels/panel-molecules.html#state-configuration) and 
[Transition rates](../panels/panel-molecules.html#transition-rates) for more information about the meaning of these parameters.

The FRET state configuration is defined in the `FRET` variable of the template and as a 
[*J*](){: .math_var }-by-2-by-[*N*](){: .math_var } matrix, with 
[*N*](){: .math_var } the number of state trajectories to simulate. 
The first column contains the 
[*FRET*<sub>*j*</sub>](){: .math_var } and the second the corresponding deviations 
[*wFRET*<sub>*j*</sub>](){: .math_var }.

For example, to define a ten-states system with evenly-spaced 
[*FRET*<sub>*j*</sub>](){: .math_var } values and no sample heterogeneity:

```matlab
%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defines 10 states with FRETj and associated wFRETj values
FRET = [0.1 0
	0.2 0
	0.3 0
	0.4 0
	0.5 0
	0.6 0
	0.7 0
	0.8 0
	0.9 0];

% defines the number of trajectories to simulate
N = 60;

% replicate the same FRET configuration for all molecules with the repmat function
FRET = repmat(FRET,[1 1 N]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
```

State transition rates are defined in the `trans_rates` variable of the template and as a 
[*J*](){: .math_var }-by-[*J*](){: .math_var }-by-[*N*](){: .math_var } matrix, where the cell (row 
[*j*](){: .math_var }, column [*j’*](){: .math_var }) concerns the unidirectional transition from state 
[*j*](){: .math_var } to state 
[*j’*](){: .math_var }.
Transition rates are given in second<sup>-1</sup> and set to zero to forbid particular state transitions.
The diagonal is naturally ignored during the simulation process and can be set to zero.

For example, to define a transition rate matrix allowing only step-wise transitions in the 10-states system, with a uniform rate of 0.1 second<sup>-1</sup> except the transition state 2 to 3 
([*FRET*<sub>3</sub>](){: .math_var }=0.3 to [*FRET*<sub>4</sub>](){: .math_var }=0.4) governed by a rate coefficient of 0.5 second<sup>-1</sup>

```matlab
%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% defines 10-by-10 transition rates
trans_rates = [ 0   0.1 0   0   0   0   0   0   0   0
		0.1 0   0.1 0   0   0   0   0   0   0
		0   0.1 0   0.5 0   0   0   0   0   0
		0   0   0.1 0   0.1 0   0   0   0   0
		0   0   0   0.1 0   0.1 0   0   0   0
		0   0   0   0   0.1 0   0.1 0   0   0
		0   0   0   0   0.1 0   0.1 0   0   0
		0   0   0   0   0   0.1 0   0.1 0   0
		0   0   0   0   0   0   0.1 0   0.1 0
		0   0   0   0   0   0   0   0.1 0   0.1
		0   0   0   0   0   0   0   0   0.1 0  ];

% replicate the same transition rates matrix for all molecules with the repmat function
trans_rates = repmat(trans_rates,[1 1 N]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
```

To build and export the pre-set parameter file:

{: .procedure }
1. Open the pre-set template in MATLAB's editor by going to menu `Open → Open ...` and selecting the file `MASH-FRET/createSimPrm.m`.  
      
1. Define the variables `FRET` and `trans_rates` in the corresponding sections of the template  
     
1. Type `createSimPrm` in MATLAB's command window to run the script and export the pre-set parameter file.


---

## Load pre-set in Simulation

To use the pre-set FRET state configuration and transition rates, the pre-set file must be imported in module Simulation.
After successful import, the fields used to edit the number of molecules, the number of states, the 
[*FRET*<sub>*j*</sub>](){: .math_var } and 
[*wFRET*<sub>*j*</sub>](){: .math_var } values, as well as the transition rates will be locked.
Fields will be rendered editable when removing the pre-set file.

To import pre-sets fro simulation:

{: .procedure }
1. load the pre-sets by pressing 
![...](../../assets/images/gui/sim-but-3p.png "...") in 
[Pre-set parameters](../panels/panel-molecules.html#pre-set-parameters) and selecting the corresponding file
