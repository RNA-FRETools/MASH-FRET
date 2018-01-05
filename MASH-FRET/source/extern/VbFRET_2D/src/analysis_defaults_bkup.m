function analysis = analysis_defaults_bkup()
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% options from the main gui

% range for number of states fit to data
analysis.minK = 1;
analysis.maxK = 5;
% number of fitting attempts for each value of K
analysis.numrestarts = 10;
% is the Use guesses for FRET states box checked
analysis.use_guess = 0;
% did the user enter (an acceptable) guess
analysis.exist_guess = 0;
% initialize cell matrix for future user generated guesses
analysis.guess = {};

% keeps track of how many traces have been analyzed
analysis.cur_trace = -1;

%defaults from the advanced menu 
%VBEM options

% set default analysis to be in 1D
analysis.dim = 1;

% stop after vb_opts iterations if program has not yet converged
analysis.maxIter = 100;
% stop when two iterations have the same evidence to within:
analysis.threshold = 1e-5;

%plot traces as they are analyzed
analysis.plot = 1;
analysis.display_progress = 1;

%blur state options
analysis.remove_blur = 0;

%hyperparameters
analysis.PriorPar.upi = 1;
% will become 'mu*ones(D,1)'
analysis.PriorPar.mu = .5;
analysis.PriorPar.beta = 0.25;
% will become 'W*eye(D)';
analysis.PriorPar.W = 50;
analysis.PriorPar.v = 5.0;
analysis.PriorPar.ua = 1.0;
analysis.PriorPar.uad = 0.0;

% should autosave be a default
analysis.auto_save = 1;
% initialize autosave path name
analysis.auto_name = {};
% set autosave frequency (-1 = only when analysis is done/paused)
analysis.auto_rate = -1;