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
hedit0 = 20;
htxt0 = 14;
wedit0 = 40;
fact = 5;
str0 = 'Data:';
str1 = {'Select data'};
str2 = 'Tag:';
str3 = {'Select subgroup'};
str4 = 'diagonal';
str7 = 'EXPORT...';
ttl0 = 'Transition density plot';
ttl1 = 'State configuration';
ttl2 = 'Dwell time hisotgrams';
ttl3 = 'Kinetic model';
tabttl0 = 'TDP';
tabttl1 = 'BIC (ML-GMM)';
tabttl2 = 'Dwell times';
tabttl3 = 'BIC (ML-DPH)';
tabttl4 = 'Diagram';
tabttl5 = 'Simulation';
ttstr0 = wrapHtmlTooltipString('<b>Select data</b> to histogram in 2D and analyze.');
ttstr1 = wrapHtmlTooltipString('<b>Select molecule subgroup</b> to histogram in 2D and analyze.');
ttstr2 = wrapHtmlTooltipString('Open options for <b>exporting analysis results</b>.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut0 = getUItextWidth(str7,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wpan0a = p.mg+wcb0+p.mg/fact+wcb0+p.mg;
wpan0 = p.mg+wedit0+p.mg/2+wedit0+p.mg+wpan0a+p.mg;
wtab = pospan(3)-2*p.mg-wpan0-p.mg;
htab = pospan(4)-2*p.mg;
wpop0 = (wpan0-p.mg/fact)/2;
hpan0 = p.mgpan+htxt0+hedit0+p.mg/2+5*hedit0+p.mg/2+hpop0+p.mg/2;
hpan1a = p.mgpan+hpop0+p.mg/2+htxt0+hpop0+p.mg/fact+hedit0+p.mg/2+...
    hedit0+p.mg/2+hedit0+p.mg;
hpan1b = p.mgpan+htxt0+hpop0+p.mg/2+hbut0+p.mg;
hpan1 = p.mgpan+hpan1a+p.mg+hpan1b+p.mg;
hpan2a = p.mgpan+htxt0+hpop0+p.mg/2+htxt0+hpop0+p.mg;
hpan2 = p.mgpan+htxt0+hedit0+hedit0/2+p.mg/2+htxt0+hpop0+p.mg/2+hbut0+...
    p.mg/2+hpan2a+p.mg;
hpan3 = p.mgpan+htxt0+hpop0+p.mg/2+hbut0+p.mg;

% GUI
x = p.mg;
y = p.mg;

h.uitabgroup_TA_plot = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab]);
h_tabgrp = h.uitabgroup_TA_plot;

h.uitab_TA_plot_TDP = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl0);
h = buildTAtabPlotTDP(h,p);

h.uitab_TA_plot_BICGMM = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl1);
h = buildTAtabPlotBICGMM(h,p);

h.uitab_TA_plot_dt = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl2);
h = buildTAtabPlotDt(h,p);

h.uitab_TA_plot_BICDPH = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl3);
h = buildTAtabPlotBICDPH(h,p);

h.uitab_TA_plot_mdl = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl4);
h = buildTAtabPlotMdl(h,p);

h.uitab_TA_plot_sim = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl5);
h = buildTAtabPlotSim(h,p);

x = x+wtab+p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TDPdataType = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = x+wpop0+p.mg/fact;

h.text_TDPtag = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str2);

x = p.mg+wtab+p.mg;
y = y-hpop0;

h.popupmenu_TDPdataType = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TDPdataType_Callback,h_fig});

x = x+wpop0+p.mg/fact;

h.popupmenu_TDPtag = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str3,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_TDPtag_Callback,h_fig});

x = p.mg+wtab+p.mg;
y = y-p.mg-hpan0;

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

x = pospan(3)-p.mg-wbut0;
y = p.mg;

h.pushbutton_TA_export = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str7,'tooltipstring',...
    ttstr2,'callback',{@pushbutton_TA_export_Callback,h_fig});


