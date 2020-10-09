function routinetest_HA_statePopulations(h_fig,p,prefix)
% routinetest_HA_stateConfiguration(h_fig,p,prefix)
%
% Tests calculation of state populations by Gaussian fitting, thresholding and bootstrapping
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_HA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

setDefault_HA(h_fig,p);

h = guidata(h_fig);

% test Gaussian fitting
disp(cat(2,prefix,'test simple Gaussian fitting...'));
prm = p.popMethPrm;
prm(1) = 1; % gauss fit
prm(2) = 0; % boba
set_HA_statePop(prm,p.gaussPrm,p.threshPrm,h_fig);
pushbutton_thm_fit_Callback(h.pushbutton_thm_fit,[],h_fig);

% test result display
J = numel(get(h.popupmenu_thm_gaussNb,'string'));
for j = 1:J
    set(h.popupmenu_thm_gaussNb,'value',j);
    popupmenu_thm_gaussNb_Callback(h.popupmenu_thm_gaussNb,[],h_fig);
end

% export
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_1_gauss.png']},[],h_fig);
set(h_fig,'currentaxes',h.axes_hist2);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_2_gauss.png']},[],h_fig);
pushbutton_thm_export_Callback({p.dumpdir,[p.exp_pop,'_gauss.txt']},[],...
    h_fig);
pushbutton_thm_saveProj_Callback({p.dumpdir,[p.exp_pop,'_gauss.mash']},[],...
    h_fig);

disp(cat(2,prefix,'test bootstrap Gaussian fitting...'));

% test bootstrap Gaussian fitting with weighing
disp(cat(2,prefix,'>> with weighing...'));
prm = p.popMethPrm;
prm(1) = 1; % gauss fit
prm(2) = 1; % boba
prm(4) = 1; % weighing
set_HA_statePop(prm,p.gaussPrm,p.threshPrm,h_fig);
pushbutton_thm_fit_Callback(h.pushbutton_thm_fit,[],h_fig);

% test result display
J = numel(get(h.popupmenu_thm_gaussNb,'string'));
for j = 1:J
    set(h.popupmenu_thm_gaussNb,'value',j);
    popupmenu_thm_gaussNb_Callback(h.popupmenu_thm_gaussNb,[],h_fig);
end

% export
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_1_gauss_wboba.png']},[],h_fig);
set(h_fig,'currentaxes',h.axes_hist2);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_2_gauss_wboba.png']},[],h_fig);
pushbutton_thm_export_Callback({p.dumpdir,[p.exp_pop,'_gauss_wboba.txt']},...
    [],h_fig);
pushbutton_thm_saveProj_Callback(...
    {p.dumpdir,[p.exp_pop,'_gauss_wboba.mash']},[],h_fig);

% test bootstrap Gaussian fitting without weighing
disp(cat(2,prefix,'>> without weighing...'));
prm = p.popMethPrm;
prm(1) = 1; % gauss fit
prm(2) = 1; % boba
prm(4) = 0; % weighing
set_HA_statePop(prm,p.gaussPrm,p.threshPrm,h_fig);
pushbutton_thm_fit_Callback(h.pushbutton_thm_fit,[],h_fig);

% test result display
J = numel(get(h.popupmenu_thm_gaussNb,'string'));
for j = 1:J
    set(h.popupmenu_thm_gaussNb,'value',j);
    popupmenu_thm_gaussNb_Callback(h.popupmenu_thm_gaussNb,[],h_fig);
end

% export
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_1_gauss_boba.png']},[],h_fig);
set(h_fig,'currentaxes',h.axes_hist2);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_2_gauss_boba.png']},[],h_fig);
pushbutton_thm_export_Callback({p.dumpdir,[p.exp_pop,'_gauss_boba.txt']},...
    [],h_fig);
pushbutton_thm_saveProj_Callback(...
    {p.dumpdir,[p.exp_pop,'_gauss_boba.mash']},[],h_fig);

% test thresholding
disp(cat(2,prefix,'test simple thresholding...'));
prm = p.popMethPrm;
prm(1) = 2; % thresholds
prm(2) = 0; % boba
set_HA_statePop(prm,p.gaussPrm,p.threshPrm,h_fig);
pushbutton_thm_threshStart_Callback(h.pushbutton_thm_threshStart,[],h_fig);

% test result display
nThresh = numel(get(h.popupmenu_thm_pop,'string'));
for thresh = 1:nThresh
    set(h.popupmenu_thm_pop,'value',thresh);
    popupmenu_thm_pop_Callback(h.popupmenu_thm_pop,[],h_fig);
end

% export
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_1_thresh.png']},[],h_fig);
set(h_fig,'currentaxes',h.axes_hist2);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_2_thresh.png']},[],h_fig);
pushbutton_thm_export_Callback({p.dumpdir,[p.exp_pop,'_thresh.txt']},[],...
    h_fig);
pushbutton_thm_saveProj_Callback({p.dumpdir,[p.exp_pop,'_thresh.mash']},[],...
    h_fig);

disp(cat(2,prefix,'test bootstrap thresholding...'));

% test bootstrap thresholding with weighing
disp(cat(2,prefix,'>> with weighing...'));
prm = p.popMethPrm;
prm(1) = 2; % thresholds
prm(2) = 1; % boba
prm(4) = 1; % weighing
set_HA_statePop(prm,p.gaussPrm,p.threshPrm,h_fig);
pushbutton_thm_threshStart_Callback(h.pushbutton_thm_threshStart,[],h_fig);

% test result display
nThresh = numel(get(h.popupmenu_thm_pop,'string'));
for thresh = 1:nThresh
    set(h.popupmenu_thm_pop,'value',thresh);
    popupmenu_thm_pop_Callback(h.popupmenu_thm_pop,[],h_fig);
end

% export
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_1_thresh_wboba.png']},[],h_fig);
set(h_fig,'currentaxes',h.axes_hist2);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_2_thresh_wboba.png']},[],h_fig);
pushbutton_thm_export_Callback({p.dumpdir,[p.exp_pop,'_thresh_wboba.txt']},...
    [],h_fig);
pushbutton_thm_saveProj_Callback(...
    {p.dumpdir,[p.exp_pop,'_thresh_wboba.mash']},[],h_fig);

% test bootstrap thresholding without weighing
disp(cat(2,prefix,'>> without weighing...'));
prm = p.popMethPrm;
prm(1) = 2; % thresholds
prm(2) = 1; % boba
prm(4) = 0; % weighing
set_HA_statePop(prm,p.gaussPrm,p.threshPrm,h_fig);
pushbutton_thm_threshStart_Callback(h.pushbutton_thm_threshStart,[],h_fig);

% test result display
nThresh = numel(get(h.popupmenu_thm_pop,'string'));
for thresh = 1:nThresh
    set(h.popupmenu_thm_pop,'value',thresh);
    popupmenu_thm_pop_Callback(h.popupmenu_thm_pop,[],h_fig);
end

% export
set(h_fig,'currentaxes',h.axes_hist1);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_1_thresh_boba.png']},[],h_fig);
set(h_fig,'currentaxes',h.axes_hist2);
exportAxes({[p.dumpdir,filesep,p.exp_pop,'_2_thresh_boba.png']},[],h_fig);
pushbutton_thm_export_Callback({p.dumpdir,[p.exp_pop,'_thresh_boba.txt']},...
    [],h_fig);
pushbutton_thm_saveProj_Callback(...
    {p.dumpdir,[p.exp_pop,'_thresh_boba.mash']},[],h_fig);

% close project
pushbutton_thm_rmProj_Callback(h.pushbutton_thm_rmProj,[],h_fig);
