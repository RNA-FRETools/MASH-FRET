function routinetest_VP_createProj(p,h_fig,prefix)

% create root folder if none
pname_root = p.annexpth;
if ~exist(pname_root,'dir')
    mkdir(pname_root);
end

% get interface parameters
h = guidata(h_fig);

% create new project
pushbutton_newProj_Callback([],2,h_fig);

% set default experiment settings for video
routinetest_setExperimentSettings(h_fig,p,'video',[prefix,'>> ']);

% set root folder
pushbutton_rootFolder_Callback({pname_root},[],h_fig);

% set module
switchPan(h.togglebutton_VP,[],h_fig);