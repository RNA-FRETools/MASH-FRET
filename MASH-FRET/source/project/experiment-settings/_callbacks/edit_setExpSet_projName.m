function edit_setExpSet_projName(obj,evd,h_fig)

% retrieve project content
proj = h_fig.UserData;

proj.exp_parameters{1,2} = get(obj,'string');

% save modifications
h_fig.UserData = proj;

% refresh interface
ud_setExpSet_tabDiv(h_fig);