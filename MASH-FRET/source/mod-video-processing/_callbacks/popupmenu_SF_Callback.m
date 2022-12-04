function popupmenu_SF_Callback(obj, evd, h_fig)

% save spot finder method
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.VP.curr.gen_crd{2}{1}(1) = get(obj,'value');

h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);