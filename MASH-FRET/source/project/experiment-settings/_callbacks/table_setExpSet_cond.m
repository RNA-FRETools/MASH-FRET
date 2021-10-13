function table_setExpSet_cond(obj,evd,h_fig)

% retrieve project content
proj = h_fig.UserData;

val = obj.Data{evd.Indices(1),evd.Indices(2)};
proj.exp_parameters{2+evd.Indices(1),evd.Indices(2)} = val;

% save modifications
h_fig.UserData = proj;

% refresh interface
ud_setExpSet_tabDiv(h_fig);