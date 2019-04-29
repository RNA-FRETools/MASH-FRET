function checkbox_photon_Callback(obj, evd, h)
switch(get(obj, 'Value'))
    case 1
        h.param.sim.intUnits = 'photon';
    case 0
        h.param.sim.intUnits = 'electron';
end
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');