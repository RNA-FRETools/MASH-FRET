---
layout: default
title: Simulate larger systems
parent: Functionalities
grand_parent: Simulation
nav_order: 2
---

<img src="../../assets/images/logos/logo-simulation_400px.png" width="170" style="float:right; margin-left: 15px;"/>

# Simulate larger systems
{: .no_toc }

For more practicability, the matrix of
[Transition rates](../components/panel-molecules.html#transition-rates) in module Simulation is limited to a five-state system.
The simulation of larger systems requires to import FRET states and transition rates from an external pre-set parameter file.

To create and import simulation parameters for a large state system, follow the procedure described below.

## Procedure
{: .no_toc .text-delta }

1. TOC
{:toc}


---

## Create a pre-set file

The pre-set parameter file is a MATLAB binary file that can be created with the template file
`createSimPrm.m` in MATLAB's editor.

To simulate a 
[*J*](){: .math_var }-states system with 
[*J*](){: .math_var } greater than 5, the pre-set parameter file needs to contain the 
[*J*<sup>2</sup>](){: .math_var } state transition rates 
[*k*<sub>*jj'*</sub>](){: .math_var } defined for each of the 
[*N*](){: .math_var } molecules in the sample.

State transition rates are defined in the `trans_rates` variable of the template and as a 
[*J*](){: .math_var }-by-[*J*](){: .math_var }-by-[*N*](){: .math_var } matrix, where the cell (row 
[*j*](){: .math_var }, column [*j’*](){: .math_var }) concerns the unidirectional transition from state 
[*j*](){: .math_var } to state 
[*j’*](){: .math_var }.

Transition rates are given in second<sup>-1</sup> and set to zero to forbid particular state transitions.
The diagonal is naturally ignored during the simulation process and can be set to zero.

For example, the script below can be used to define a transition rate matrix for the 10-states system, allowing only step-wise transitions and with uniform rate coefficients 
[*k*<sub>*jj'*</sub>](){: .math_var } = 0.1 second<sup>-1</sup>, except for the transition from state 2 to state 3 
([*FRET*<sub>3</sub>](){: .math_var }=0.3 to [*FRET*<sub>4</sub>](){: .math_var }=0.4) that is governed by a rate coefficient of 0.5 second<sup>-1</sup>:

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
1. Open the pre-set template in MATLAB's editor by going to MATLAB's menu `HOME → Open → Open ...` and selecting the file `MASH-FRET/tools/createSimPrm.m`.  
      
1. Define the variables `FRET` and `trans_rates` in the corresponding sections of the template  
     
1. Run the script by pressing `Run` in MATLAB's menu `EDITOR` and export the pre-set file.


---

## Load pre-set in Simulation

To use the pre-set state configuration and transition rates, the pre-set file must be imported in module Simulation.

After successful import, the fields used to edit the 
[Number of molecules](../components/panel-molecules.html#number-of-molecules), the number of states in 
[State configuration](../components/panel-molecules.html#state-configuration) and the 
[Transition rates](../components/panel-molecules.html#transition-rates) will be locked.
Fields will be rendered editable when removing the pre-set file.

To import pre-sets fro simulation:

{: .procedure }
1. Load the pre-sets by pressing 
![...](../../assets/images/gui/sim-but-3p.png "...") in 
[Pre-set parameters](../components/panel-molecules.html#pre-set-parameters) and selecting the corresponding file

