function routinetest_HA_createProj(p,h_fig,prefix)
% routinetest_HA_createProj(p,h_fig,prefix)
%
% Tests histogram-based poject creation
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_HA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% create root folder if none
pname_root = p.annexpth;
if ~exist(pname_root,'dir')
    mkdir(pname_root);
end

% get interface parameters
h = guidata(h_fig);

% create new project
pushbutton_newProj_Callback([],4,h_fig);

% set default experiment settings for video
routinetest_setExperimentSettings(h_fig,p,'histogram',[prefix,'>> ']);

% set root folder
pushbutton_rootFolder_Callback({pname_root},[],h_fig);

% set module
switchPan(h.togglebutton_HA,[],h_fig);
