function routinetest_VP_editAndExportVideo(h_fig,p,prefix)
% routinetest_VP_editAndExportVideo(h_fig,p,prefix)
%
% Tests different image filters, filter list management and video export to files of different formats
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% collect interface parameters
h = guidata(h_fig);