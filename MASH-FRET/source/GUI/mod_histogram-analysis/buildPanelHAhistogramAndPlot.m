function h = buildPanelHAhistogramAndPlot(h,p)
% h = buildPanelHAhistogramAndPlot(h,p)
%
% Builds "Histogram and plot" panel in module "Histogram analysis"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA_histogramAndPlot: handle to panel "Histogram and plot"
%   h.listbox_thm_projLst: handle to project list
%   h.pushbutton_thm_saveProj: handle to "Save" pushbutton
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 3.11.2019

% default
hpop0 = 22;
hedit0 = 20;
htxt0 = 14;
fact = 5;
str0 = 'data';
str1 = {'Select data'};
str2 = 'subgroup';
str3 = {'Select subgroup'};
str4 = 'x-limits:';
str5 = 'x-binning:';
str6 = 'overflow bins';
ttstr0 = wrapHtmlTooltipString('<b>Select data</b> to histogram and analyze.');
ttstr1 = wrapHtmlTooltipString('<b>Select subgroup</b> to histogram and analyze.');
ttstr2 = wrapHtmlTooltipString('<b>Histogram boundaries:</b> lower limit of x-axis.');
ttstr3 = wrapHtmlTooltipString('<b>Histogram boundaries:</b> upper limit of x-axis.');
ttstr4 = wrapHtmlTooltipString('<b>Histogram binning:</b> bin size.');
ttstr5 = wrapHtmlTooltipString('<b>Histogram extremities:</b> when activated, the first and the last histogram bins are included, otherwise they are ignored (including overflow bins can substantially reduce the goodness of Gaussian fits).');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA_histogramAndPlot;
h_lst = h.listbox_thm_projLst;
h_but = h.pushbutton_thm_saveProj;

% dimensions
poslist = get(h_lst,'position');
posbut = get(h_but,'position');
wpan = poslist(3);
hpan = p.mgpan+2*(htxt0+hpop0)+p.mg/fact+3*(p.mg/fact+hedit0)+p.mg;
xpan = p.mg;
ypan = posbut(2)-p.mg-hpan;
wpop0 = wpan-2*p.mg;
wtxt0 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = (wpop0-wtxt0-p.mg/fact)/2;

% adjust panel dimensions
set(h_pan,'position',[xpan,ypan,wpan,hpan]);

% GUI
x = p.mg;
y = hpan-p.mgpan-htxt0;

h.text_thm_data = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpop0,htxt0],...
    'string',str0,'horizontalalignment','left');

y = y-hpop0;

h.popupmenu_thm_tpe = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_thm_tpe_Callback,h_fig});

y = y-p.mg/fact-htxt0;

h.text_thm_tag = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpop0,htxt0],...
    'string',str2,'horizontalalignment','left');

y = y-hpop0;

h.popupmenu_thm_tag = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str3,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_thm_tag_Callback,h_fig});

y = y-p.mg/2-hedit0+(hedit0-htxt0)/2;

h.text_thm_xlim = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str4);

x = x+wtxt0+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_thm_xlim1 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr2,'callback',{@edit_thm_xlim1_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_thm_xlim2 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_thm_xlim2_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_thm_xbin = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str5);

x = x+wtxt0+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_thm_xbin = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'callback',{@edit_thm_xbin_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-hedit0;

h.checkbox_thm_ovrfl = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hedit0],'string',str6,'tooltipstring',ttstr5,'callback',...
    {@checkbox_thm_ovrfl_Callback,h_fig});
