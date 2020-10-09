function routinetest_S_visualizationArea(h_fig,p,prefix)
% routinetest_S_visualizationArea(h_fig,p,prefix)
%
% Tests graph export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_S
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

% set interface defaults
setDefault_S(h_fig,p);

disp(cat(2,prefix,'test graph export and zoom reset...'));
h_axes = [h.axes_example,h.axes_example_mov,h.axes_example_hist];
for a = 1:numel(h_axes)
    set(h_fig,'CurrentAxes',h_axes(a));
    
    % test graph export
    exportAxes({[p.dumpdir,filesep,sprintf(p.exp_axes,a)]},[],h_fig);
    
    % test zoom reset
    ud_zoom([],[],'reset',h_fig);
end