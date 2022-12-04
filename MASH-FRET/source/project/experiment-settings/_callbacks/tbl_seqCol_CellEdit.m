function tbl_seqCol_CellEdit(obj,evd,h_fig)

val = round(str2double(evd.EditData));
pair = evd.Indices(1);
col = evd.Indices(2)-1;
obj.Data{evd.Indices(1),evd.Indices(2)} = num2str(val);

proj = get(h_fig,'userdata');
proj.traj_import_opt{1}{5}(pair,col) = val;
if proj.traj_import_opt{1}{1}(7) && col==1 % one molecule per file
    proj.traj_import_opt{1}{5}(pair,2) = val;
end

set(h_fig,'userdata',proj);

ud_trajImportOpt(h_fig);
ud_setExpSet_tabFstrct(h_fig);
