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

setDefault_VP(h_fig,p,prefix);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_VP_plot,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

% test different color maps
disp(cat(2,prefix,'test different color maps...'));
nMap = numel(get(h.popupmenu_colorMap,'string'));
for map = 1:nMap
    set(h.popupmenu_colorMap,'value',map);
    popupmenu_colorMap_Callback(h.popupmenu_colorMap,[],h_fig);
end

