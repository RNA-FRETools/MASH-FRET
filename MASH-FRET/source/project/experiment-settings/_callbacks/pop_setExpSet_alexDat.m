function pop_setExpSet_alexDat(obj,evd,h_fig)

proj = get(h_fig,'userdata');
proj.traj_import_opt{1}{1}(7) = get(obj,'value');
set(h_fig,'userdata',proj);

ud_setExpSet_tabFstrct(h_fig);