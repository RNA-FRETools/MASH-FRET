function h = buildPanelHAgaussianFitting(h,p)
% h = buildPanelHAgaussianFitting(h,p)
%
% Builds "Gaussian fitting" panel in module "Histogram analysis" including panel "Fitting parameters"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA_gaussianFitting: handle to panel "Gaussian fitting"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbox: box's pixel width in checkboxes
%   p.warr: width of downwards arrow in popupmenu
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 6.11.2019

% default
hedit0 = 20;
htxt0 = 14;
wedit0 = 40;
str0 = 'nb. of Gaussians:';
str1 = 'Fit';
ttl0 = 'Fitting parameters';
ttstr0 = wrapHtmlTooltipString('<b>Number of Gaussians</b> used to fit to and integrate all histogram peaks.');
ttstr1 = wrapHtmlTooltipString('<b>Start peak integration</b> with Gaussian fitting.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA_gaussianFitting;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpan0 = pospan(3)-2*p.mg;
hpan0 = pospan(4)-p.mgpan-p.mg-p.mg/2-hedit0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0+(hedit0-htxt0)/2;

h.text_thm_nGauss = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0);

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_thm_nGaussFit = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr0,'callback',...
    {@edit_thm_nGaussFit_Callback,h_fig});

x = x+wedit0+p.mg;

h.pushbutton_thm_fit = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str1,'tooltipstring',ttstr1,'callback',...
    {@pushbutton_thm_fit_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-hpan0;

h.uipanel_HA_fittingParameters = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],...
    'title',ttl0);
h = buildPanelHAfittingParameters(h,p);

