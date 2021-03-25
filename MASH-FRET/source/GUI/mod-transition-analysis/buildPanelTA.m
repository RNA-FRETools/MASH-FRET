function h = buildPanelTA(h,p)
% h = buildPanelTA(h,p);
%
% Builds "Transition analysis" module including panels "Transition density plot", "State configuration", "Dwell time histograms" and "Kinetic model".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA: handle to the panel containing the "Transition analysis" module
%   h.pushbutton_traceImpOpt: handle to pushbutton "ASCII options..." in module "Trace processing"
%   h.pushbutton_addTraces: handle to pushbutton "Add" in module "Trace processing"
%   h.listbox_traceSet: handle to project list in module "Trace processing"
%   h.pushbutton_remTraces: handle to pushbutton "Remove" in module "Trace processing"
%   h.pushbutton_expProj: handle to pushbutton "Save" in module "Trace processing"
%   h.pushbutton_thm_export: handle to pushbutton "Export" in module "Histogram analysis"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.warr: width of downwards arrow in popupmenu
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 19.10.2019

% default
hpop0 = 22;
hbut0 = 20;
hcb0 = 20;
hedit0 = 20;
htxt0 = 14;
fact = 5;
ttl0 = 'Transition density plot';
ttl1 = 'State configuration';
ttl2 = 'Dwell time hisotgrams';
ttl3 = 'Kinetic model';
tabttl0 = 'TDP';
tabttl1 = 'Dwell times';
tabttl2 = 'BIC (ML-DPH)';
tabttl3 = 'Diagram';
tabttl4 = 'Simulation';

% parents
h_pan = h.uipanel_TA;

% dimensions
pospan = get(h_pan,'position');
wtab = (pospan(3)-3*p.mg)/2;
htab = pospan(4)-2*p.mg;
wpan0 = pospan(3)-3*p.mg-wtab;
hpan0 = p.mgpan+hpop0+2*(htxt0+hedit0+p.mg/2)+p.mg+3*(hedit0+p.mg/2)+p.mg/2+hbut0+p.mg;
hpan1 = p.mgpan+p.mgpan+hpop0+p.mg/2+htxt0+hpop0+p.mg/fact+hedit0+p.mg/2+...
    hedit0+p.mg/2+hedit0+p.mg+p.mg;
hpan2 = p.mgpan+hedit0+2*(p.mg/fact+hcb0)+2*(p.mg+hbut0)+p.mg;
hpan3 = p.mgpan+htxt0+hpop0+p.mg;

% GUI
x = p.mg;
y = p.mg;

h.uitabgroup_TA_plot = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab]);
h_tabgrp = h.uitabgroup_TA_plot;

h.uitab_TA_plot_TDP = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl0);
h = buildTAtabPlotTDP(h,p);

h.uitab_TA_plot_dt = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl1);
h = buildTAtabPlotDt(h,p);

h.uitab_TA_plot_BIC = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl2);
h = buildTAtabPlotBIC(h,p);

h.uitab_TA_plot_mdl = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl3);
h = buildTAtabPlotMdl(h,p);

h.uitab_TA_plot_sim = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl4);
h = buildTAtabPlotSim(h,p);

x = x+wtab+p.mg;
y = pospan(4)-p.mgpan-hpan0;

h.uipanel_TA_transitionDensityPlot = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelTAtransitionDensityPlot(h,p);

y = y-p.mg-hpan1;

h.uipanel_TA_stateConfiguration = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelTAstateConfiguration(h,p);

y = y-p.mg-hpan2;

h.uipanel_TA_dtHistograms = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan2],'title',ttl2);
h = buildPanelTAdtHistograms(h,p);

y = y-p.mg-hpan3;

h.uipanel_TA_kineticModel = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan3],'title',ttl3);
h = buildPanelTAkineticModel(h,p);


