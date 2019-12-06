function pushbutton_startSim_Callback(obj, evd, h_fig)
% Make sure all Parameters are updated.
updateFields(h_fig, 'sim');

% Simulate trajectories and initialize movie simulation
buildModel(h_fig);

% Make sure all Parameters are updated.
updateFields(h_fig, 'sim');