function routinetest_general(varargin)
% routinetest_general()
%
% This routine execute main GUI-based actions performed when setting up the working area.
% The script can be executed from MATLAB's command window or from the routine menu of MASH.
% It deletes default_param.ini, runs MASH (if executed from comand window), tests menu callbacks, tests resize and close functions of main figure and action panel, tests module callbacks and sets the root folder.

% defaults
pname_root = 'C:\MyDataFolder\experiment_01\';
fileprm = '..\..\default_param.ini';

% delete default_param.ini
[pth,o,o] = fileparts(mfilename('fullpath'));
if exist([pth,filesep,fileprm],'file')
    delete([pth,filesep,fileprm]);
end

% run MASH
h_fig = MASH;

% test figure resizing function
figure_MASH_SizeChangedFcn(h_fig,[]);

% test history window and corresponding menu
h = guidata(h_fig);
figureActPan_ResizeFcn(h.figure_actPan,[]);
figureActPan_CloseRequestFcn(h.figure_actPan,[]);
menu_showActPan_Callback(h.menu_showActPan,[],h_fig);

% test overwrite files menus
menu_overwrite_Callback(h.menu_rename, [], h_fig);
menu_overwrite_Callback(h.menu_ask, [], h_fig);
menu_overwrite_Callback(h.menu_overWrite, [], h_fig);

% test access to modules
switchPan(h.togglebutton_S,[],h_fig);
switchPan(h.togglebutton_VP,[],h_fig);
switchPan(h.togglebutton_TP,[],h_fig);
switchPan(h.togglebutton_HA,[],h_fig);
switchPan(h.togglebutton_TA,[],h_fig);

% test root folder
pushbutton_rootFolder_Callback({pname_root},[],h_fig);

% test figure closing function
figure_MASH_CloseRequestFcn(h_fig,[]);
