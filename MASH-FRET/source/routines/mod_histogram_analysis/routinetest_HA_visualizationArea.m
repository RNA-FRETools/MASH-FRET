function routinetest_HA_visualizationArea(h_fig,p,prefix)
% routinetest_HA_visualizationArea(h_fig,p,prefix)
%
% Tests axes export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_HA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

setDefault_HA(h_fig,p);

h = guidata(h_fig);

% test axes export
disp(cat(2,prefix,'test axes export...'));
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_axes,'_1.png']},[],h_fig);
set(h_fig,'currentaxes',h.axes_hist2);
exportAxes({[p.dumpdir,filesep,p.exp_axes,'_2.png']},[],h_fig);

% test zoom reset
disp(cat(2,prefix,'test zoom reset...'));
set(h_fig,'currentaxes',h.axes_hist1);
ud_zoom([],[],'reset',h_fig);
set(h_fig,'currentaxes',h.axes_hist2);
ud_zoom([],[],'reset',h_fig);