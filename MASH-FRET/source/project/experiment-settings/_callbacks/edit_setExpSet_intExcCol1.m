function edit_setExpSet_intExcCol1(obj,evd,l,h_fig)

val = round(str2double(get(obj,'string')));
set(obj,'string',num2str(val));

proj = get(h_fig,'userdata');
proj.traj_import_opt{1}{3}(l,1) = val;
set(h_fig,'userdata',proj);

ud_trajImportOpt(h_fig);
ud_setExpSet_tabFstrct(h_fig);