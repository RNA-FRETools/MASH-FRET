function routinetest_HA_stateConfiguration(h_fig,p,prefix)
% routinetest_HA_stateConfiguration(h_fig,p,prefix)
%
% Tests model selection on histogram
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_HA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

setDefault_HA(h_fig,p);

h = guidata(h_fig);

% test model selection
disp(cat(2,prefix,'test GM model selection...'));
pushbutton_thm_RMSE_Callback(h.pushbutton_thm_RMSE,[],h_fig);

% test BIC-based selection
cnfgPrm = p.cnfgPrm;
cnfgPrm(2) = 2;
set_HA_stateConfig(cnfgPrm,h_fig);
set(h_fig,'currentaxes',h.axes_thm_BIC);
exportAxes({[p.dumpdir,filesep,p.exp_BICplot,'_BIC.png']},[],h_fig);
pushbutton_thm_export_Callback({p.dumpdir,p.exp_BIC},[],h_fig);

% test penalty-based selection
cnfgPrm(2) = 1;
cnfgPrm(3) = 1.2;
set_HA_stateConfig(cnfgPrm,h_fig);
set(h_fig,'currentaxes',h.axes_thm_BIC);
exportAxes({[p.dumpdir,filesep,p.exp_BICplot,'_penalty.png']},[],h_fig);
pushbutton_thm_export_Callback({p.dumpdir,p.exp_penalty},[],h_fig);

% test model export
disp(cat(2,prefix,'test model export...'));
nMdl = numel(get(h.popupmenu_thm_nTotGauss,'string'));
for mdl = 1:nMdl
    set(h.popupmenu_thm_nTotGauss,'value',mdl);
    popupmenu_thm_nTotGauss_Callback(h.popupmenu_thm_nTotGauss,[],h_fig);
    
    pushbutton_thm_impPrm_Callback(h.pushbutton_thm_impPrm,[],h_fig);
end

% save project
pushbutton_thm_saveProj_Callback({p.dumpdir,p.exp_config},[],h_fig);

% close project
pushbutton_thm_rmProj_Callback(h.pushbutton_thm_rmProj,[],h_fig);
