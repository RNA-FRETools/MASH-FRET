function checkbox_convPSF_Callback(obj, evd, h_fig)

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{6}{1} = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_expSetupPan(h_fig);