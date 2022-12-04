function routinetest_S_experimentalSetup(h_fig,p,prefix)
% routinetest_S_experimentalSetup(h_fig,p,prefix)
%
% Tests PSF convolution, background spatial distributions, dynamic background
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_S
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% default
expopt = [false,false,false,false,false,true,false]; % parameters to export only log files

h = guidata(h_fig);

% set interface defaults
setDefault_S(h_fig,p);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_S_experimentalSetup,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

% generate state sequences with defaults
disp(cat(2,prefix,'test generation of state sequences...'));
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);

% test PSF convolution
disp(cat(2,prefix,'test PSF convolution...'));
psf = ~p.psf;
set_S_psf(psf,p.psfW,h_fig);
pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);
set_S_fileExport(expopt,h_fig);
pushbutton_exportSim_Callback({p.dumpdir,'expset_psf'}, [], h_fig);

% set interface defaults
setDefault_S(h_fig,p);

% generate state sequences with defaults
disp(cat(2,prefix,'test generation of state sequences...'));
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);

% test background spatial distribution
disp(cat(2,prefix,'test different background spatial distributions...'));
str_pop = get(h.popupmenu_simBg_type,'string');
nbg = numel(str_pop);
for n = 1:nbg
    disp(cat(2,prefix,'>> test "',str_pop{n},'" spatial distribution...'));
    set_S_spatialBG(n,p.bgI,p.bgW,p.annexpth,p.bgImg,h_fig);
    pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);
    
    set_S_fileExport(expopt,h_fig);
    ext = str_pop{n};
    ext(ext==' ') = [];
    pushbutton_exportSim_Callback({p.dumpdir,cat(2,'expset_bg_',ext)}, [], ...
        h_fig);
end

% set interface defaults
setDefault_S(h_fig,p);

% generate state sequences with defaults
disp(cat(2,prefix,'test generation of state sequences...'));
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);

% test dynamic background
disp(cat(2,prefix,'test dynamic background...'));
bgDec = ~p.bgDec;
set_S_dynamicBG(bgDec,p.bgDec_prm,h_fig);
pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);
set_S_fileExport(expopt,h_fig);
pushbutton_exportSim_Callback({p.dumpdir,'expset_bg_dyn'}, [], h_fig);
