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

% test graph export and zoom reset
disp(cat(2,prefix,'test graph export and zoom reset...'));
chld = h.uipanel_HA.Children;
h_axes = [];
for c = 1:numel(chld)
    if strcmp(chld(c).Type,'axes')
        h_axes = cat(2,h_axes,chld(c));
    end
end
for ax = 1:numel(h_axes)
    set(h_fig,'CurrentAxes',h_axes(ax));
    exportAxes({[p.dumpdir,filesep,p.exp_axes,'_',num2str(ax)]},[],h_fig);
    ud_zoom([],[],'reset',h_fig);
end