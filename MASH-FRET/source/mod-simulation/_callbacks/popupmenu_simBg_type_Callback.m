function popupmenu_simBg_type_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{8}{1} = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

ud_S_expSetupPan(h_fig);