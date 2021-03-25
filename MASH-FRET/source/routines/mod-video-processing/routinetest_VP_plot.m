function routinetest_VP_plot(h_fig,p,prefix)
% routinetest_VP_plot(h_fig,p,prefix)
%
% Tests different color maps
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_VP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% collect interface parameters
h = guidata(h_fig);

% set defaults
setDefault_VP(h_fig,p);

% test intensity units
disp(cat(2,prefix,'test intensity units...'));
set(h.checkbox_int_ps,'value',~p.perSec);
checkbox_int_ps_Callback(h.checkbox_int_ps,[],h_fig);

% test different color maps
disp(cat(2,prefix,'test different color maps...'));
nMap = numel(get(h.popupmenu_colorMap,'string'));
for map = 1:nMap
    set(h.popupmenu_colorMap,'value',map);
    popupmenu_colorMap_Callback(h.popupmenu_colorMap,[],h_fig);
end

