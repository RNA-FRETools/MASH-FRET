function check_setExpSet_timeDat(obj,evd,h_fig)

% store new value
proj = get(h_fig,'userdata');
proj.traj_import_opt{1}{1}(3) = get(obj,'value');

% save modifications
set(h_fig,'userdata',proj);

% update import options
ud_trajImportOpt(h_fig);

% refresh panels
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);