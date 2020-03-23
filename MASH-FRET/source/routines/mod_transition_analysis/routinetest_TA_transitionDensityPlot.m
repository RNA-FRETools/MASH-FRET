function routinetest_TA_transitionDensityPlot(h_fig,p,prefix)
% routinetest_TA_transitionDensityPlot(h_fig,p,prefix)
%
% Tests transition density plot building and processing
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
opt0 = [true,4,false,3,false,false,false,false];

setDefault_TA(h_fig,p);

h = guidata(h_fig);

% test different data
disp(cat(2,prefix,'test molecule subgroups...'));
nTag = numel(get(h.popupmenu_TDPdataType,'string'));
for tag = 1:nTag
    set(h.popupmenu_TDPdataType,'value',tag);
    popupmenu_TDPdataType_Callback(h.popupmenu_TDPdataType,[],h_fig);
end

% test different molecule subgroups
disp(cat(2,prefix,'test molecule subgroups...'));
nTag = numel(get(h.popupmenu_TDPtag,'string'));
for tag = 1:nTag
    set(h.popupmenu_TDPtag,'value',tag);
    popupmenu_TDPtag_Callback(h.popupmenu_TDPtag,[],h_fig);
end

% test option "include statics"
disp(cat(2,prefix,'test option "include statics"...'));
tdpPrm = p.tdpPrm;
tdpPrm(4) = ~tdpPrm(4);
set_TA_TDP(p.tdpDat,1,tdpPrm,h_fig);
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
set_TA_expOpt(opt0,h_fig);
pushbutton_expTDPopt_next_Callback({p.dumpdir,[p.exp_tdp,'_stat.tdp']},[],...
    h_fig);

% test option "single count per molecules"
disp(cat(2,prefix,'test option "single count per mol."...'));
tdpPrm = p.tdpPrm;
tdpPrm(5) = ~tdpPrm(5);
set_TA_TDP(p.tdpDat,1,tdpPrm,h_fig);
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
set_TA_expOpt(opt0,h_fig);
pushbutton_expTDPopt_next_Callback({p.dumpdir,[p.exp_tdp,'_single.tdp']},...
    [],h_fig);

% test option "re-arrange sequences"
disp(cat(2,prefix,'test option "re-arrange sequences"...'));
tdpPrm = p.tdpPrm;
tdpPrm(6) = ~tdpPrm(6);
set_TA_TDP(p.tdpDat,1,tdpPrm,h_fig);
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
set_TA_expOpt(opt0,h_fig);
pushbutton_expTDPopt_next_Callback({p.dumpdir,[p.exp_tdp,'_rearr.tdp']},[],...
    h_fig);

% test option "Gaussian filter"
disp(cat(2,prefix,'test option "Gaussian filter"...'));
tdpPrm = p.tdpPrm;
tdpPrm(7) = ~tdpPrm(7);
set_TA_TDP(p.tdpDat,1,tdpPrm,h_fig);
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig);
opt = opt0;
opt(1) = false;
opt(3) = true;
opt(4) = 2;
set_TA_expOpt(opt,h_fig);
pushbutton_expTDPopt_next_Callback({p.dumpdir,[p.exp_tdp,'_gauss.tdp']},[],...
    h_fig);

% test option "Norm."
disp(cat(2,prefix,'test option "Norm."...'));
tdpPrm = p.tdpPrm;
tdpPrm(8) = ~tdpPrm(8);
set_TA_TDP(p.tdpDat,1,tdpPrm,h_fig);
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
