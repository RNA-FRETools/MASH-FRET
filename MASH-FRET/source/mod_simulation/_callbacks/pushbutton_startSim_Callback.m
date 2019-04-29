function pushbutton_startSim_Callback(obj, evd, h)
% Make sure all Parameters are updated.
updateFields(h.figure_MASH, 'sim');

% Simulate trajectories and initialize movie simulation
buildModel(h.figure_MASH);

% Make sure all Parameters are updated.
updateFields(h.figure_MASH, 'sim');