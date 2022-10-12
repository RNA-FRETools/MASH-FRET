function tbl_intCol_CellEdit(obj,evd,h_fig)

val = round(str2double(evd.EditData));
chan = evd.Indices(1);
col = evd.Indices(2)-1;
obj.Data{evd.Indices(1),evd.Indices(2)} = num2str(val);

proj = get(h_fig,'userdata');
rowwise = proj.traj_import_opt{1}{1}(5);
isalex = proj.nb_excitations>1;
if rowwise==1 || ~isalex
    proj.traj_import_opt{1}{3}(chan,col) = val;
    if proj.traj_import_opt{1}{1}(7) && col==1 % one molecule per file
        proj.traj_import_opt{1}{3}(chan,2) = val;
    end

elseif rowwise==2
    l = ceil(chan/proj.nb_channel);
    chan = chan-(l-1)*proj.nb_channel;
    proj.traj_import_opt{1}{4}(chan,col,l) = val;
    if proj.traj_import_opt{1}{1}(7) && col==1  % one molecule per file
        proj.traj_import_opt{1}{4}(chan,2,l) = val;
    end
end

set(h_fig,'userdata',proj);

ud_trajImportOpt(h_fig);
ud_setExpSet_tabFstrct(h_fig);
