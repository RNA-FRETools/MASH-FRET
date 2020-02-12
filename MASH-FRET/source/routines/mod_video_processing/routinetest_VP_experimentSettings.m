function routinetest_VP_experimentSettings(h_fig,p,prefix)
% routinetest_VP_experimentSettings(h_fig,p,prefix)
%
% Tests experiment settings and project options
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% collect interface parameters
h = guidata(h_fig);