function popupmenu_opUnits_Callback(obj, evd, h_fig)
h = guidata(h_fig);
switch get(obj, 'Value')
    case 1
        h.param.sim.intOpUnits = 'photon';
    case 2
        h.param.sim.intOpUnits = 'electron';
end
guidata(h_fig, h);
updateFields(h_fig, 'sim');