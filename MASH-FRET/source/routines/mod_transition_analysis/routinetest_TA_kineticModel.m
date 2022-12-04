function routinetest_TA_kineticModel(h_fig,p,prefix)
% routinetest_TA_kineticModel(h_fig,p,prefix)
%
% Tests DPH fit, calculation of rate coefficients
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
opt0 = [false,4,false,3,false,false,false,false,false,true,true,true];

% set TA's defaults
setDefault_TA(h_fig,p);

% retrieve interface defaults
h = guidata(h_fig);

% start clustering
h_but = getHandlePanelExpandButton(h.uipanel_TA_stateConfiguration,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,[],h_fig);
V = numel(get(h.popupmenu_TA_slStates,'string'));

fprintf(cat(2,prefix,'test model inferrence starting with a guess from ',...
    'exponential fit ...\n'));

% automated fit on all histograms
h_but = getHandlePanelExpandButton(h.uipanel_TA_dtHistograms,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
set(h.checkbox_TA_slExcl,'value',p.dtExcl);
checkbox_TA_slExcl_Callback(h.checkbox_TA_slExcl,[],h_fig);
set(h.checkbox_tdp_rearrSeq,'value',p.dtRearr);
checkbox_tdp_rearrSeq_Callback(h.checkbox_tdp_rearrSeq,[],h_fig);
expPrm = p.expPrm;
expPrm(1) = 1;
for v = 1:V
    set_TA_expFit(v,expPrm,p.fitPrm,h_fig);
end
pushbutton_TDPfit_fit_Callback(h.pushbutton_TA_slFitAll,[],h_fig);

% import state degeneracy
h_but = getHandlePanelExpandButton(h.uipanel_TA_kineticModel,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end
set_TA_mdl(2,[],[],[],p.mdlRestart,h_fig);
pushbutton_TA_fitMLDPH_Callback(h.pushbutton_TA_fitMLDPH,[],h_fig);

% test results display
for v = 1:V
    h.popupmenu_TA_mdlHist.Value = v;
    popupmenu_TA_mdlHist_Callback(h.popupmenu_TA_mdlHist,[],h_fig);
    edit_TA_mdlD_Callback(h.edit_TA_mdlD,[],h_fig);
    for d = 1:numel(h.popupmenu_TA_mdlDegen.String)
        h.popupmenu_TA_mdlDegen.Value = d;
        popupmenu_TA_mdlDegen_Callback(h.popupmenu_TA_mdlDegen,[],h_fig);
        edit_TA_mdlLifetime_Callback(h.edit_TA_mdlLifetime,[],h_fig);
    end
end

% calculate rate constants
pushbutton_TA_refreshModel_Callback(h.pushbutton_TA_refreshModel,[],h_fig);

% save project
pushbutton_saveProj_Callback({p.dumpdir,[p.exp_mdl,'_fromExpfit.mash']},...
    [],h_fig);

% export model
pushbutton_TA_export_Callback(h.pushbutton_TA_export,[],h_fig)
set_TA_expOpt(opt0,h_fig);
pushbutton_expTDPopt_next_Callback(...
    {p.dumpdir,[p.exp_mdl,'_fromExpfit.mdl']},[],h_fig);

fprintf(cat(2,prefix,'test model inferrence starting with a guess from ',...
    'DPH fit ...\n'));

% calculate state degeneracy with ML-DPH
set_TA_mdl(1,p.dtbin,p.Dmax,p.dphRestart,p.mdlRestart,h_fig);
pushbutton_TA_fitMLDPH_Callback(h.pushbutton_TA_fitMLDPH,[],h_fig);

% test results display
for v = 1:V
    h.popupmenu_TA_mdlHist.Value = v;
    popupmenu_TA_mdlHist_Callback(h.popupmenu_TA_mdlHist,[],h_fig);
    edit_TA_mdlD_Callback(h.edit_TA_mdlD,[],h_fig);
    for d = 1:numel(h.popupmenu_TA_mdlDegen.String)
        h.popupmenu_TA_mdlDegen.Value = d;
        popupmenu_TA_mdlDegen_Callback(h.popupmenu_TA_mdlDegen,[],h_fig);
        edit_TA_mdlLifetime_Callback(h.edit_TA_mdlLifetime,[],h_fig);
        for tr = 1:numel(h.popupmenu_TA_mdlTrans.String)
            h.popupmenu_TA_mdlTrans.Value = tr;
            popupmenu_TA_mdlTrans_Callback(h.popupmenu_TA_mdlTrans,[],...
                h_fig);
            edit_TA_mdlTransProb_Callback(h.edit_TA_mdlTransProb,[],h_fig);
        end
    end
end

% calculate rate constants
pushbutton_TA_refreshModel_Callback(h.pushbutton_TA_refreshModel,[],h_fig);

% save project
pushbutton_saveProj_Callback({p.dumpdir,[p.exp_mdl,'_fromDPHfit.mash']},...
    [],h_fig);

% export model
pushbutton_TA_export_Callback(h.pushbutton_TA_export,[],h_fig)
set_TA_expOpt(opt0,h_fig);
pushbutton_expTDPopt_next_Callback(...
    {p.dumpdir,[p.exp_mdl,'_fromDPHfit.mdl']},[],h_fig);

disp(cat(2,prefix,'test visualization area...'));

% test axes export & reset: ML-DPH BIC plot
set(h_fig,'currentaxes',h.axes_TA_mdlBIC);
exportAxes({[p.dumpdir,filesep,p.exp_mdlBIC]},[],h_fig);
ud_zoom([],[],'reset',h_fig);

% test axes export & reset: simulated vs experimental dwell time distributions
V = numel(get(h.popupmenu_TA_mdlDtState,'string'));
for v = 1:V
    set(h.popupmenu_TA_mdlDtState,'value',v);
    popupmenu_TA_mdlDat_Callback(h.popupmenu_TA_mdlDtState,[],h_fig);
    set(h_fig,'currentaxes',h.axes_TA_mdlDt);
    exportAxes({[p.dumpdir,filesep,sprintf(p.exp_mdlSimdt,v)]},[],h_fig);
end
ud_zoom([],[],'reset',h_fig);

% test axes export & reset: simulated vs experimental state populations
set(h_fig,'currentaxes',h.axes_TA_mdlPop);
exportAxes({[p.dumpdir,filesep,p.exp_mdlPop]},[],h_fig);
ud_zoom([],[],'reset',h_fig);

% test axes export & reset: simulated vs experimental transition counts
set(h_fig,'currentaxes',h.axes_TA_mdlTrans);
exportAxes({[p.dumpdir,filesep,p.exp_mdlTrans]},[],h_fig);
ud_zoom([],[],'reset',h_fig);

% remove project from list
pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);

