function h = buildPanelHA(h,p)
% h = buildPanelHA(h,p);
%
% Builds "Histogram analysis" module including panels "Histogram and plot", "State configuration" and "State populations".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA: handle to the panel containing the "Histogram analysis" module
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
str0 = 'data';
str1 = {'Select data'};
str2 = 'subgroup';
str3 = {'Select subgroup'};
str5 = 'Gaussian fitting';
str6 = 'relative pop.:';
str7 = 'EXPORT...';
tabttl0 = 'Histograms';
tabttl1 = 'Model selection';
ttstr0 = wrapHtmlTooltipString('<b>Select data</b> to histogram and analyze.');
ttstr1 = wrapHtmlTooltipString('<b>Select subgroup</b> to histogram and analyze.');
ttstr2 = wrapHtmlTooltipString('<b>Export analysis results</b> to ASCII files.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wtxt0 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str7,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
hpan0 = pospan(4)-p.mgpan-htxt0-hpop0-2*p.mg-hedit0-p.mg;
wpan0_1 = wcb0+2*p.mg;
wpan0_2 = 2*p.mg+2*p.mg/fact+2*wedit0+wtxt0;
wpan0 = 3*p.mg+wpan0_1+wpan0_2;
htab = pospan(4)-2*p.mg;
wtab = pospan(3)-3*p.mg-wpan0;
wpop0 = (wpan0-p.mg/fact)/2;

% GUI

x = p.mg;
y = p.mg;

h.uitabgroup_HA_plot = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab],'selectionchangedfcn',...
    {@uitabgroup_plot_SelectionChangedFcn,'HA',h_fig});
h_tabgrp = h.uitabgroup_HA_plot;

h.uitab_HA_plot_hist = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl0);
h = buildHAtabPlotHist(h,p);

h.uitab_HA_plot_mdlSlct = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl1);
h = buildHAtabPlotMdlSlct(h,p);

x = x+wtab+p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_thm_data = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpop0,htxt0],...
    'string',str0);

x = x+wpop0+p.mg/fact;

h.text_thm_tag = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpop0,htxt0],...
    'string',str2);

x = p.mg+wtab+p.mg;
y = y-hpop0;

h.popupmenu_thm_tpe = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_thm_tpe_Callback,h_fig});

x = x+wpop0+p.mg/fact;

h.popupmenu_thm_tag = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str3,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_thm_tag_Callback,h_fig});

x = p.mg+wtab+p.mg;
y = y-p.mg-hpan0;

h.uipanel_HA_scroll = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],'title',[]);
h = buildPanelScrollHA(h,p);

x = pospan(3)-p.mg-wbut0;
y = p.mg;

h.pushbutton_HA_export = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str7,'tooltipstring',...
    ttstr2,'callback',{@pushbutton_HA_export_Callback,h_fig});
