function routinetest_TP_createProj(p,h_fig,prefix)

% create root folder if none
pname_root = p.annexpth;
if ~exist(pname_root,'dir')
    mkdir(pname_root);
end

% get interface parameters
h = guidata(h_fig);

% create new project
disp([prefix,'create new trajectory project ...']);
pushbutton_newProj_Callback([],3,h_fig);

% set default experiment settings for video
disp([prefix,'set experiment settings ...']);
routinetest_setExperimentSettings(h_fig,p,'trajectories',[prefix,'>> ']);

% set root folder
disp([prefix,'set root folder ...']);
pushbutton_rootFolder_Callback({pname_root},[],h_fig);

% set module
disp([prefix,'select TP module ...']);
switchPan(h.togglebutton_TP,[],h_fig);