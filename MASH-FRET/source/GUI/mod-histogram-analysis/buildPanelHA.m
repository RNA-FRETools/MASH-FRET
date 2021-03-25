function h = buildPanelHA(h,p)
% h = buildPanelHA(h,p);
%
% Builds "Histogram analysis" module including panels "Histogram and plot", "State configuration" and "State populations".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA: handle to the panel containing the "Histogram analysis" module
%   h.pushbutton_traceImpOpt: handle to pushbutton "ASCII options..." in module "Trace processing"
%   h.pushbutton_addTraces: handle to pushbutton "Add" in module "Trace processing"
%   h.listbox_traceSet: handle to project list in module "Trace processing"
%   h.pushbutton_remTraces: handle to pushbutton "Remove" in module "Trace processing"
%   h.pushbutton_editParam: handle to pushbutton "Edit" in module "Trace processing"
%   h.pushbutton_expProj: handle to pushbutton "Save" in module "Trace processing"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.warr: width of downwards arrow in popupmenu
%   p.fntclr2: text color in special pushbuttons
%   p.wbuth: pixel width of help buttons
%   p.tbl: reference table listing character pixel dimensions
%   p.fname_boba: image file containing BOBA FRET icon

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% update by MH, 12.12.2019: plot boba icon in corresponding axes
% created by MH, 19.10.2019

% default
hpop0 = 22;
hedit0 = 20;
htxt0 = 14;
wedit0 = 40;
fact = 5;
str2 = 'Gaussian fitting';
str3 = 'relative pop.:';
ttl0 = 'Histogram and plot';
ttl1 = 'State configuration';
ttl2 = 'State populations';
tabttl0 = 'Histograms';

% parents
h_pan = h.uipanel_HA;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wtxt0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
hpan0 = p.mgpan+htxt0+hpop0+p.mg+hedit0+p.mg/2+hedit0+p.mg+hedit0+p.mg;
hpan1_1 = p.mgpan+p.mg+p.mg/2+4*p.mg/fact+6*hedit0;
hpan1_2 = 2*p.mgpan+2*p.mg+3*p.mg/2+2*p.mg/fact+5*hedit0+hpop0+htxt0;
hpan1 = p.mgpan+p.mg+p.mg/2+hpan1_1+hpan1_2;
wpan0_1 = wcb0+2*p.mg;
wpan0_2 = 2*p.mg+2*p.mg/fact+2*wedit0+wtxt0;
wpan0 = 3*p.mg+wpan0_1+wpan0_2;
htab = pospan(4)-2*p.mg;
wtab = pospan(3)-3*p.mg-wpan0;

% GUI

x = p.mg;
y = p.mg;

h.uitabgroup_HA_plot = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab]);
h_tabgrp = h.uitabgroup_HA_plot;

h.uitab_HA_plot_hist = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl0);
h = buildHAtabPlotHist(h,p);

x = x+wtab+p.mg;
y = pospan(4)-p.mgpan-hpan0;

h.uipanel_HA_histogramAndPlot = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelHAhistogramAndPlot(h,p);

y = y-p.mg-hpan1;

h.uipanel_HA_stateConfiguration = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelHAstateConfiguration(h,p);

y = y-p.mg-hpan1;

h.uipanel_HA_statePopulations = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan1],'title',ttl2);
h = buildPanelHAstatePopulations(h,p);

