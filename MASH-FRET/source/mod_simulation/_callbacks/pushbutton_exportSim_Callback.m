function pushbutton_exportSim_Callback(obj, evd, h)
% Set fields to proper values
updateFields(h.figure_MASH, 'sim');
exportResults(h.figure_MASH);
updateFields(h.figure_MASH, 'sim');