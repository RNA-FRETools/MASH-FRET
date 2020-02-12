function popupmenu_colorMap_Callback(obj, evd, h_fig)

% collect interface parameters
str_pop = get(obj,'String');
val = get(obj, 'Value');
h = guidata(h_fig);
p = h.param.movPr;

p.cmap = val;

% set colormap
cm_str = str_pop{val};
updateActPan([cm_str ' colormap applied.'], h_fig);

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_plotPan(h_fig);
