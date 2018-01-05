function save_autosave(dat, fit_par, plot, debleach, analysis)

% this function autosaves the current session as a vbFRET 'save session'

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% save a variable to let vbFRET know this is a saved session file
vbFRET_saved_session = 'file type';
% get date and time stamp
d_t = clock;
date_and_time = sprintf('Date: %s   Time: %02d:%02d',date,d_t(4),d_t(5));

% save current settings/analysis
session_settings.dat = dat;
session_settings.fit_par = fit_par;
session_settings.plot = plot;
session_settings.debleach = debleach;
session_settings.analysis = analysis;

% save current plot
session_settings.current_plot = find(fit_par.bestLP == -inf,1)-1;
% if all traces are analyzed, set current plot to 1
if isempty(session_settings.current_plot)
    session_settings.current_plot = 1;
end

%save file
save(analysis.auto_name,'vbFRET_saved_session','date_and_time','session_settings');
