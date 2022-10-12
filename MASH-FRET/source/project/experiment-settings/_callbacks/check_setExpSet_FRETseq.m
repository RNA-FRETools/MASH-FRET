function check_setExpSet_FRETseq(obj,evd,h_fig)

proj = get(h_fig,'userdata');
proj.traj_import_opt{1}{1}(6) = get(obj,'value');
set(h_fig,'userdata',proj);

ud_setExpSet_tabFstrct(h_fig);