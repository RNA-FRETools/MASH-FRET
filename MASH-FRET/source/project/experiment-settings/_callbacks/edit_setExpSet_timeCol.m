function edit_setExpSet_timeCol(obj,evd,h_fig)

val = round(str2double(get(obj,'string')));
set(obj,'string',num2str(val));

proj = get(h_fig,'userdata');
proj.traj_import_opt{1}{1}(4) = val;
set(h_fig,'userdata',proj);

ud_trajImportOpt(h_fig);
ud_setExpSet_tabFstrct(h_fig);