function routinetest_TA_kineticModel(h_fig,p,prefix)
% routinetest_TA_kineticModel(h_fig,p,prefix)
%
% Tests DPH fit, calculation of rate coefficients, axes export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
opt0 = [false,4,false,3,false,false,false,false,false,true,true,true];

setDefault_TA(h_fig,p);

h = guidata(h_fig);

% start clustering
pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,[],h_fig);
V = numel(get(h.popupmenu_TA_slStates,'string'));

fprintf(cat(2,prefix,'test model inferrence starting with a guess from ',...
    'exponential fit ...\n'));

% automated fit on all histograms
expPrm = p.expPrm;
expPrm(1) = 1;
for v = 1:V
    set_TA_expFit(v,expPrm,p.fitPrm,h_fig);
end
pushbutton_TDPfit_fit_Callback(h.pushbutton_TA_slFitAll,[],h_fig);

% model inference
set_TA_mdl(2,p.Dmax,p.mdlRestart,h_fig);
pushbutton_TA_refreshModel_Callback(h.pushbutton_TA_refreshModel,[],h_fig);

% save project
pushbutton_TDPsaveProj_Callback({p.dumpdir,[p.exp_mdl,'_fromExpfit.mash']},...
    [],h_fig);

% export model
pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
set_TA_expOpt(opt0,h_fig);
pushbutton_expTDPopt_next_Callback(...
    {p.dumpdir,[p.exp_mdl,'_fromExpfit.mdl']},[],h_fig);

fprintf(cat(2,prefix,'test model inferrence starting with a guess from ',...
    'DPH fit ...\n'));

% model inference
set_TA_mdl(1,p.Dmax,p.mdlRestart,h_fig);
pushbutton_TA_refreshModel_Callback(h.pushbutton_TA_refreshModel,[],h_fig);

% save project
pushbutton_TDPsaveProj_Callback({p.dumpdir,[p.exp_mdl,'_fromDPHfit.mash']},...
    [],h_fig);

% export model
pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
set_TA_expOpt(opt0,h_fig);
pushbutton_expTDPopt_next_Callback(...
    {p.dumpdir,[p.exp_mdl,'_fromDPHfit.mdl']},[],h_fig);

disp(cat(2,prefix,'test visualization area...'));

% test axes export
set(h_fig,'currentaxes',h.axes_TA_mdlBIC);
exportAxes({[p.dumpdir,filesep,p.exp_mdlBIC]},[],h_fig);
ud_zoom([],[],'reset',h_fig); % test zoom reset

V = numel(get(h.popupmenu_TA_mdlDtState,'string'));
for v = 1:V
    set(h.popupmenu_TA_mdlDtState,'value',v);
    popupmenu_TA_mdlDat_Callback(h.popupmenu_TA_mdlDtState,[],h_fig);
    set(h_fig,'currentaxes',h.axes_TA_mdlDt);
    exportAxes({[p.dumpdir,filesep,sprintf(p.exp_mdlSimdt,v)]},[],h_fig);
end
ud_zoom([],[],'reset',h_fig); % test zoom reset

set(h_fig,'currentaxes',h.axes_TA_mdlPop);
exportAxes({[p.dumpdir,filesep,p.exp_mdlPop]},[],h_fig);
ud_zoom([],[],'reset',h_fig); % test zoom reset

set(h_fig,'currentaxes',h.axes_TA_mdlTrans);
exportAxes({[p.dumpdir,filesep,p.exp_mdlTrans]},[],h_fig);
ud_zoom([],[],'reset',h_fig); % test zoom reset

% remove project from list
pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);

