function checkbox_simBleach_Callback(obj, evd, h_fig)

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dt{1}(5) = get(obj,'value');

h.param = p;
guidata(h_fig, h);

% refresh panel
ud_S_moleculesPan(h_fig);