function write_defaults_analysis(settings,folder)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% create analysis_defaults.m using current settings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

if isunix
    fid = fopen([folder '/analysis_defaults.m'],'w');
else
    fid = fopen([folder '\analysis_defaults.m'],'w');
end

% write the file
fprintf(fid,'function analysis = analysis_defaults()\n\n');

fprintf(fid,'%% options from the main gui\n\n%% range for number of states fit to data\n');
fprintf(fid,'analysis.minK = %d;\n',settings.analysis.minK);
fprintf(fid,'analysis.maxK = %d;\n',settings.analysis.maxK);
fprintf(fid,'%% number of fitting attempts for each value of K\n');
fprintf(fid,'analysis.numrestarts = %d;\n',settings.analysis.numrestarts);
fprintf(fid,'%% is the Use guesses for FRET states box checked\n');
fprintf(fid,'analysis.use_guess = 0;\n');
fprintf(fid,'%% did the user enter (an acceptable) guess\n');
fprintf(fid,'analysis.exist_guess = 0;\n');
fprintf(fid,'%% initialize cell matrix for future user generated guesses\n');
fprintf(fid,'analysis.guess = {};\n\n');

fprintf(fid,'%% keeps track of how many traces have been analyzed\n');
fprintf(fid,'analysis.cur_trace = %d;\n\n',settings.analysis.cur_trace);
fprintf(fid,'%%defaults from the advanced menu\n%%VBEM options\n\n%% set default analysis to be in 1D\n');
fprintf(fid,'analysis.dim = %d;\n\n',settings.analysis.dim);
fprintf(fid,'%% stop after vb_opts iterations if program has not yet converged\n');
fprintf(fid,'analysis.maxIter = %d;\n',settings.analysis.maxIter);
fprintf(fid,'%% stop when two iterations have the same evidence to within:\n');
fprintf(fid,'analysis.threshold = %g;\n\n',settings.analysis.threshold);

fprintf(fid,'%% plot traces as they are analyzed\n');
fprintf(fid,'analysis.plot = %g;\n',settings.analysis.plot);
fprintf(fid,'analysis.display_progress = %g;\n\n',settings.analysis.display_progress);
fprintf(fid,'%% blur state options\n');

fprintf(fid,'analysis.remove_blur = %g;\n\n',settings.analysis.remove_blur);
fprintf(fid,'%% hyperparameters\n');
fprintf(fid,'analysis.PriorPar.upi = %g;\n',settings.analysis.PriorPar.upi);
fprintf(fid,'%% will become ''mu*ones(D,1)''\n');
fprintf(fid,'analysis.PriorPar.mu = %g;\n',settings.analysis.PriorPar.mu);
fprintf(fid,'analysis.PriorPar.beta = %g;\n',settings.analysis.PriorPar.beta);
fprintf(fid,'%% will become ''W*eye(D)'';\n');
fprintf(fid,'analysis.PriorPar.W = %g;\n',settings.analysis.PriorPar.W);
fprintf(fid,'analysis.PriorPar.v = %g;\n',settings.analysis.PriorPar.v);
fprintf(fid,'analysis.PriorPar.ua = %g;\n',settings.analysis.PriorPar.ua);
fprintf(fid,'analysis.PriorPar.uad = %g;\n\n',settings.analysis.PriorPar.uad);

fprintf(fid,'%% should autosave be a default\n');
fprintf(fid,'analysis.auto_save = %g;\n',settings.analysis.auto_save);
fprintf(fid,'%% initialize autosave path name\n');
fprintf(fid,'analysis.auto_name = {};\n');
fprintf(fid,'%% set autosave frequency (-1 = only when analysis is done/paused)\n');
fprintf(fid,'analysis.auto_rate = %g;\n',settings.analysis.auto_rate);
% close the analysis settings file now that it's fully written
fclose(fid);