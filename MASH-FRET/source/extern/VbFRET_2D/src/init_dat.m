function dat = init_dat()
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% holds list of files to be loaded
dat.inputFileNames = {};
% holds raw (2 channel) data contained in the input files prior to any
% photobleaching removal
dat.raw_bkup = {};
% holds the labels for back up traces
dat.labels_bkup = {};
% raw (2 channel) data 
dat.raw = {};
% holds the labels for traces
dat.labels = {};
% FRET transform of raw data (channel 2 / sum(channel 1 & 2))
dat.FRET = {};
% holds best fit lines inferred for the traces (after analysis)
dat.x_hat = {};
% holds hidden states inferred for the traces (after analysis)
dat.z_hat = {};

% %blur state removal
% holds raw data after blur state removal
dat.raw_db = {};
% holds FRET data after blur state removal
dat.FRET_db = {};
% holds best fit lines inferred for the traces (after analysis)
dat.x_hat_db = {};
% holds hidden states inferred for the traces (after analysis) 
dat.z_hat_db = {};
