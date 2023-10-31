function h = buildPanelS(h,p)
% h = buildPanelS(h,p);
%
% Builds module "Simulation" including panels "Video parameters", "Molecules", "Experimental setup" and "Export options".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S: handle to the panel containing "Simulation" module
%
% p: structure containing default and often-used parameters that must 
% contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr1: text color in file/folder fields

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
fact = 5;
hedit0 = 20;
wedit0 = 40;
str0 = 'nb. of states (J)';
str1 = 'GENERATE';
str2 = 'UPDATE';
str3 = 'EXPORT';
tabttl0 = 'Video';
tabttl1 = 'Traces';
tabttl2 = 'Distributions';
ttstr0 = wrapHtmlTooltipString('Generate <b>new FRET state sequences</b>.');
ttstr1 = wrapHtmlTooltipString('<b>Refresh calculations</b> of intensities in traces and single molecule images.');
ttstr2 = wrapHtmlTooltipString('<b>Export simulated data</b> to selected files.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str1,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str2,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut2 = getUItextWidth(str3,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wspan0 = p.mg+wtxt0+wedit0+p.mg/2+wedit0+p.mg/fact+wedit0+p.mg/fact+wedit0+...
    p.mg;
wpan0 = 2*p.mg+wspan0;
wtab = pospan(3)-3*p.mg-wpan0;
htab = pospan(4)-2*p.mg;
hpan0 = htab-2*p.mg-hedit0;

% builds GUI
x = p.mg;
y = p.mg;

h.uitabgroup_S_plot = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab],'selectionchangedfcn',...
    {@uitabgroup_plot_SelectionChangedFcn,'S',h_fig});
h_tabgrp = h.uitabgroup_S_plot;

h.uitab_S_plot_vid = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl0);
h = buildStabPlotVid(h,p);

h.uitab_S_plot_traces = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl1);
h = buildStabPlotTraces(h,p);

h.uitab_S_plot_distrib = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl2);
h = buildStabPlotDistrib(h,p);

x = x+wtab+p.mg;
y = pospan(4)-p.mg-hpan0;

h.uipanel_S_scroll = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],'title',[]);
h = buildPanelScrollSim(h,p);

y = p.mg;
x = pospan(3)-p.mg-wbut2-p.mg/2-wbut1-p.mg/2-wbut0;

h.pushbutton_startSim = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'fontweight','bold','position',[x,y,wbut0,hedit0],'string',str1,...
    'callback',{@pushbutton_startSim_Callback,h_fig},'tooltipstring',...
    ttstr0);

x = x+wbut0+p.mg/2;

h.pushbutton_updateSim = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hedit0],'string',str2,'callback',...
    {@pushbutton_updateSim_Callback,h_fig},'tooltipstring',ttstr1);

x = x+wbut1+p.mg/2;

h.pushbutton_exportSim = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut2,hedit0],'string',str3,'callback',...
    {@pushbutton_exportSim_Callback,h_fig},'tooltipstring',ttstr2);

