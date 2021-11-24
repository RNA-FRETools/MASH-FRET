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

% test graph export and zoom reset
disp(cat(2,prefix,'test graph export and zoom reset...'));
h_axes = getHandleWithPropVal(h.uipanel_S,'Type','axes');
for ax = 1:numel(h_axes)
    set(h_fig,'CurrentAxes',h_axes(ax));
    exportAxes({[p.dumpdir,filesep,p.exp_axes,'_',num2str(ax)]},[],h_fig);
    ud_zoom([],[],'reset',h_fig);
end