function routinetest_TP_background(h_fig,p,prefix)
% routinetest_TP_background(h_fig,p,prefix)
%
% Tests different background estimators and Background analyzer
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

% test different background corrections
disp(cat(2,prefix,'test different background corrections...'));
routinetest_TP_backgroundCorrections(h_fig,p,(2,prefix,'>> '))

% test Background analyzer
disp(cat(2,prefix,'test Background analyzer...'));
routinetest_TP_backgroundAnalyzer(h_fig,p,cat(2,prefix,'>> '))
