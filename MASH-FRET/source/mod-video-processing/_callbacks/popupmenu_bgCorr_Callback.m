function popupmenu_bgCorr_Callback(obj, evd, h_fig)

% save filter index
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.VP.curr.edit{1}{1}(1) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_edExpVidPan(h_fig);

