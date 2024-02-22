function routinetest_menu_tools(h_fig,p,prefix)
% routinetest_menu_tools(h_fig,p,prefix)
%
% Tests tool "Check dependency"
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_menu
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

disp(cat(2,prefix,'test "Check dependency"...'));
menu_toolboxDependency_Callback(h.menu_toolboxDependency,[],'analysis');
menu_toolboxDependency_Callback(h.menu_toolboxDependency,[],'dscovery');

