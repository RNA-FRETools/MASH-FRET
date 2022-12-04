function pop_setExpSet_oneMol(obj,evd,h_fig)

proj = get(h_fig,'userdata');
switch get(obj,'value')
    case 1
        onemol = 1;
        proj.traj_import_opt{1}{3}(:,2) = proj.traj_import_opt{1}{3}(:,1);
        proj.traj_import_opt{1}{4}(:,2,:) = ...
            proj.traj_import_opt{1}{4}(:,1,:);
        proj.traj_import_opt{1}{5}(:,2) = proj.traj_import_opt{1}{5}(:,1);
        
    case 2
        onemol = 0;
end
proj.traj_import_opt{1}{1}(7) = onemol;
set(h_fig,'userdata',proj);

% refresh panels
ud_setExpSet_tabFstrct(h_fig);