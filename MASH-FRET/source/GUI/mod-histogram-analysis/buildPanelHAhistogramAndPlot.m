function h = buildPanelHAhistogramAndPlot(h,p)
% h = buildPanelHAhistogramAndPlot(h,p)
%
% Builds "Histogram and plot" panel in module "Histogram analysis"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA_histogramAndPlot: handle to panel "Histogram and plot"
%   h.listbox_thm_projLst: handle to project list
%   h.pushbutton_thm_export: handle to "Export..." pushbutton
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
hedit0 = 20;
htxt0 = 14;
fact = 5;
str4 = 'min';
str5 = 'binning';
str6 = 'max';
str7 = 'overflow bins';
ttstr2 = wrapHtmlTooltipString('<b>Histogram boundaries:</b> lower limit of x-axis.');
ttstr3 = wrapHtmlTooltipString('<b>Histogram boundaries:</b> upper limit of x-axis.');
ttstr4 = wrapHtmlTooltipString('<b>Histogram binning:</b> bin size.');
ttstr5 = wrapHtmlTooltipString('<b>Histogram extremities:</b> when activated, the first and the last histogram bins are included, otherwise they are ignored (including overflow bins can substantially reduce the goodness of Gaussian fits).');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA_histogramAndPlot;

% dimensions
pospan = get(h_pan,'position');
wcb0 = pospan(3)-2*p.mg;
wedit0 = (pospan(3)-p.mg-2*p.mg/fact-p.mg)/3;

% GUI

x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_thm_xlim1 = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str4);

y = y-hedit0;

h.edit_thm_xlim1 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr2,'callback',{@edit_thm_xlim1_Callback,h_fig});

x = x+wedit0+p.mg/fact;
y = y+hedit0;

h.text_thm_xbin = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str5);

y = y-hedit0;

h.edit_thm_xbin = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'callback',{@edit_thm_xbin_Callback,h_fig});

x = x+wedit0+p.mg/fact;
y = y+hedit0;

h.text_thm_xlim2 = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str6);

y = y-hedit0;

h.edit_thm_xlim2 = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_thm_xlim2_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-hedit0;

h.checkbox_thm_ovrfl = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str7,'tooltipstring',ttstr5,'callback',...
    {@checkbox_thm_ovrfl_Callback,h_fig});
