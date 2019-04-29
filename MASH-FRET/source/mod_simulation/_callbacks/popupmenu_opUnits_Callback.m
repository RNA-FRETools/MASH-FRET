function popupmenu_opUnits_Callback(obj, evd, h)
switch get(obj, 'Value')
    case 1
        h.param.sim.intOpUnits = 'photon';
    case 2
        h.param.sim.intOpUnits = 'electron';
end
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');