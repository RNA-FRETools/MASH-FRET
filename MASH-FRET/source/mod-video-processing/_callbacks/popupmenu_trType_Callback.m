function popupmenu_trType_Callback(obj, evd, h_fig)

% save transformation type
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.VP.curr.gen_crd{3}{3}{2} = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_coordTransfPan(h_fig);