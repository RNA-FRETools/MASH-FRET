function routinetest_menu_units(h_fig,p,prefix)
% routinetest_menu_units(h_fig,p,prefix)
%
% Tests time and intensity units
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_menu
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

% open project
pushbutton_openProj_Callback({p.annexpth,p.mash_file},[],h_fig);

% test menus
disp(cat(2,prefix,'test time units...'));
menu_units_Callback(h.menu_inSec,[],h_fig);
menu_units_Callback(h.menu_inFrame,[],h_fig);

disp(cat(2,prefix,'test intensity units...'));
menu_units_Callback(h.menu_perSec,[],h_fig);
menu_units_Callback(h.menu_perSec,[],h_fig);

% close project
pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);