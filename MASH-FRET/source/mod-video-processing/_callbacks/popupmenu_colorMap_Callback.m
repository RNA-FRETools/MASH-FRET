function popupmenu_colorMap_Callback(obj, evd, h_fig)

% save colormap
h = guidata(h_fig);
p = h.param;

val = get(obj, 'Value');
p.proj{p.curr_proj}.VP.curr.plot{1}(2) = val;

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_VP_plotPan(h_fig);

% display success
str_pop = get(obj,'String');
setContPan([str_pop{val} ' colormap applied.'],'success',h_fig);
