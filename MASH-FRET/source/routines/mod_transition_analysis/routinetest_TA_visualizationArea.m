function routinetest_TA_visualizationArea(h_fig,p,prefix)
% routinetest_TA_visualizationArea(h_fig,p,prefix)
%
% Tests axes export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

setDefault_TA(h_fig,p);

h = guidata(h_fig);

% test graph export and zoom reset
disp(cat(2,prefix,'test graph export and zoom reset...'));
h_axes = getHandleWithPropVal(h.uipanel_TA,'Type','axes');
for ax = 1:numel(h_axes)
    set(h_fig,'CurrentAxes',h_axes(ax));
    exportAxes({[p.dumpdir,filesep,p.exp_axes,'_',num2str(ax)]},[],h_fig);
    ud_zoom([],[],'reset',h_fig);
end
