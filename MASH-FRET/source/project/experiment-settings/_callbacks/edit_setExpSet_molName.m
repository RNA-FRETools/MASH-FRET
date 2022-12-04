function edit_setExpSet_molName(obj,evd,h_fig)

% retrieve project content
proj = h_fig.UserData;

proj.exp_parameters{2,2} = get(obj,'string');

% save modifications
h_fig.UserData = proj;

% update interface
ud_setExpSet_tabDiv(h_fig);
