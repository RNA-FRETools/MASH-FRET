function pushbutton_exportSim_Callback(obj, evd, h_fig)
% Set fields to proper values
updateFields(h_fig, 'sim');
exportResults(h_fig);
updateFields(h_fig, 'sim');