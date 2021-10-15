function checkbox_photon_Callback(obj, evd, h_fig)

% get proper input intensity units appelation
switch(get(obj, 'Value'))
    case 1
        inun = 'photon';
    case 0
        inun = 'electron';
    otherwise
        return
end

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.sim.curr.gen_dat{3}{2} = inun;

h.param = p;
guidata(h_fig, h);

% refresh panels
ud_S_moleculesPan(h_fig);
ud_S_expSetupPan(h_fig);