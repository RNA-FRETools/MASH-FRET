function checkbox_photon_Callback(obj, evd, h_fig)
h = guidata(h_fig);
switch(get(obj, 'Value'))
    case 1
        h.param.sim.intUnits = 'photon';
    case 0
        h.param.sim.intUnits = 'electron';
end
guidata(h_fig, h);

ud_S_moleculesPan(h_fig);
ud_S_expSetupPan(h_fig);