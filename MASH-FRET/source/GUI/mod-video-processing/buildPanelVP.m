function h = buildPanelVP(h,p)
% h = buildPanelVP(h,p);
%
% Builds module "Video processing" including panels "Edit video", "Coordinates" and "Intensity integration".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP: handle to the panel containing "Video processing" module
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr1: text color in file/folder fields
%   p.wbuth: pixel width of help buttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
hsld0 = 20;
fact = 5;
gray = [0.93,0.93,0.93];
str1 = '+';
str2 = 'Z';
str3 = 'Tool:';
str4 = 'EXPORT...';
str5 = 'CALCULATE TRACES';
tabttl0 = 'Video';
tabttl1 = 'Average image';
tabttl2 = 'Transformed image';
ttstr0 = wrapHtmlTooltipString('Activate <b>"create trace" cursor:</b> clicking on one pixel of the video will create intensity-time traces from this position.');
ttstr1 = wrapHtmlTooltipString('Activate <b>zoom cursor:</b> regular MATLAB zoom tool.');
ttstr2 = wrapHtmlTooltipString('<b>Export intensity-time traces:</b> opens export options.');
ttstr3 = wrapHtmlTooltipString('<b>Create intensity-time traces</b> using the transformed coordinates.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP;

% dimensions
pospan = get(h_pan,'position');
wbut0 = max([getUItextWidth(str1,p.fntun,p.fntsz1,'bold',p.tbl),...
    getUItextWidth(str2,p.fntun,p.fntsz1,'bold',p.tbl)])+p.wbrd;
wbut1 = getUItextWidth(str4,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut2 = getUItextWidth(str5,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wtxt0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
htab0 = pospan(4)-3*p.mg-hedit0;
wtab0 = htab0-hedit0-2*p.mg-hsld0-p.mg-htxt0;
htab1 = htab0-p.mgtab-p.mg;
wtab1 = wtab0-2*p.mg;
wpan0 = pospan(3)-3*p.mg-wtab0;
hpan0 = pospan(4)-2*p.mg-hedit0-p.mg/2;

% GUI
x = p.mg;
y = pospan(4)-p.mg-htab0;

h.uitabgroup_VP_plot = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab0,htab0],'selectionchangedfcn',...
    {@uitabgroup_plot_SelectionChangedFcn,'VP',h_fig});
h_tabgrp = h.uitabgroup_VP_plot;

h.uitab_VP_plot_vid = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl0);

h = buildVPtabPlotVid(h,p);

h.uitab_VP_plot_avimg = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl1);

y = h.uitab_VP_plot_avimg.Position(4)-p.mg-htab1;

h.uitabgroup_VP_plot_avimg = uitabgroup('parent',h.uitab_VP_plot_avimg,...
    'units',p.posun,'position',[x,y,wtab1,htab1],'tablocation','bottom',...
    'selectionchangedfcn',...
    {@uitabgroup_chanPlot_SelectionChangedFcn,h_fig});

h.uitab_VP_plot_tr = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl2);

y = h.uitab_VP_plot_tr.Position(4)-p.mg-htab1;

h.uitabgroup_VP_plot_tr = uitabgroup('parent',h.uitab_VP_plot_tr,...
    'units',p.posun,'position',[x,y,wtab1,htab1],'tablocation','bottom',...
    'selectionchangedfcn',...
    {@uitabgroup_chanPlot_SelectionChangedFcn,h_fig});

x = p.mg+wtab0-p.mg-wbut0;
y = p.mg;

h.togglebutton_zoom = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str2,'callback',...
    {@switchMovTool,h_fig},'value',1,'tooltipstring',ttstr1,...
    'backgroundcolor',gray);

x = x-p.mg/fact-wbut0;

h.togglebutton_target = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str1,'callback',...
    {@switchMovTool,h_fig},'value',0,'tooltipstring',ttstr0,...
    'backgroundcolor',gray);

x = x-p.mg/fact-wtxt0;
y = y+(hedit0-htxt0)/2;

h.text_tool = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str3);

x = p.mg+wtab0+p.mg;
y = pospan(4)-p.mg-hpan0;

h.uipanel_VP_scroll = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],'title',[]);
h = buildPanelScrollVP(h,p);

x = pospan(3)-p.mg-wbut1-p.mg-wbut2;
y = p.mg/2;

h.pushbutton_TTgen_create = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'fontweight','bold','position',[x,y,wbut2,hedit0],'string',str5,...
    'tooltipstring',ttstr3,'callback',...
    {@pushbutton_TTgen_create_Callback,h_fig});

x = x+wbut2+p.mg;

h.pushbutton_TTgen_fileOpt = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'fontweight','bold','position',[x,y,wbut1,hedit0],'string',str4,...
    'tooltipstring',ttstr2,'callback',...
    {@pushbutton_TTgen_fileOpt_Callback,h_fig});

