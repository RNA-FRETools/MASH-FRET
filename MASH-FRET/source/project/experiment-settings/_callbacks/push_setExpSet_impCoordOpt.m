function push_setExpSet_impCoordOpt(obj,evd,h_fig,h_fig0)

% retrieve project data
proj = h_fig.UserData;

% adapt import options to channel nb.
xycol = proj.traj_import_opt{3}{3}{1};
for i = 1:proj.nb_channel
    if i > size(xycol,1)
        xycol(i,1:2) = xycol(i-1,1:2) + 2;
    end
end
proj.traj_import_opt{3}{3}{1} = xycol(1:proj.nb_channel,:);
h_fig.UserData = proj;

% show process
setContPan('Opens coordinates import options...','process',h_fig0);

% opens options
openItgOpt(obj,[],h_fig);

% show success
setContPan('Coordinates import options ready!','success',h_fig0);