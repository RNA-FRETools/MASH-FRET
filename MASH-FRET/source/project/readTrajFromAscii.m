function [mov,coord,intensities,FRET] = readTrajFromAscii(pname,fname,proj,h_fig)
% [mov,coord,intensities,factors,FRET_DTA] = readTrajFromAscii(pname,fname,proj,h_fig)
%
% Read video data, molecule coordinates, intensity trajectories, FRET state 
% sequences and correction factors (gamma & beta) from input files using 
% input import options.
%
% INPUTS:
% pname: file location
% fname: file names
% proj: project data structure
% h_fig: handle to main figure
%
% RETURNS:
% mov:
% coord:
% intensities:
% FRET:

impPrm = proj.traj_imp_opt;

