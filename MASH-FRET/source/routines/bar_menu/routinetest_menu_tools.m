function routinetest_menu_tools(h_fig,p,prefix)
% routinetest_menu_tools(h_fig,p,prefix)
%
% Tests tools "Check dependency", "Restructure files" and "Bin trajectories"
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_menu
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

disp(cat(2,prefix,'test "Check dependency"...'));
menu_toolboxDependency_Callback(h.menu_toolboxDependency,[],'analysis');
menu_toolboxDependency_Callback(h.menu_toolboxDependency,[],'dscovery');

disp(cat(2,prefix,'test "Restructure files"...'));
for i = 1:size(p.dataset_restruct,2)
    menu_restructFiles_Callback(h.menu_restructFiles,[],...
        cat(2,p.annexpth,filesep,p.dataset_restruct{i}),p.wl{i},p.dumpdir);
end

disp(cat(2,prefix,'test "Bin trajectories"...'));
for i = 1:size(p.dataset_timebin,2)
    menu_binTimeAxis_Callback(h.menu_binTimeAxis,[],p.expT(i),cat(2,...
        p.annexpth,filesep,p.dataset_timebin{i}),p.headers{i},p.dumpdir);
end