function h = buildPanelHAfittingParameters(h,p)
% h = buildPanelHAfittingParameters(h,p)
%
% Builds "Fitting parameters" panel in module "Histogram analysis"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA_fittingParameters: handle to panel "Fitting parameters"
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
% Created by MH, 7.11.2019

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
fact = 5;
mgprm = 1;
str0 = 'Gaussian n°: 99';
str1 = {'Select a Gaussian'};
str2 = 'color';
str3 = 'lower';
str4 = 'start';
str5 = 'upper';
str6 = 'fit';
str7 = 'sigma';
str8 = 'amp.:';
str9 = 'center:';
str10 = 'FWHM:';
str11 = 'relative population:';
ttstr0 = wrapHtmlTooltipString('<b>Select a Gaussian</b> to adjust fitting parameters or show best fit parameters, calculated relative populations, bootstrapping results and associated plot color.');
ttstr1 = wrapHtmlTooltipString('Gaussian''s <b>lowest amplitude</b> used in fit.');
ttstr2 = wrapHtmlTooltipString('<b>Starting guess</b> for Gaussian''s <b>amplitude</b>: Gaussian parameters can be automatically imported from an inferred state configuration in panel "State configurations".');
ttstr3 = wrapHtmlTooltipString('Gaussian''s <b>highest amplitude</b> used in fit.');
ttstr4 = wrapHtmlTooltipString('Gaussian''s <b>lowest mean</b> used in fit.');
ttstr5 = wrapHtmlTooltipString('<b>Starting guess</b> for Gaussian''s <b>mean</b>: Gaussian parameters can be automatically imported from an inferred state configuration in panel "State configurations".');
ttstr6 = wrapHtmlTooltipString('Gaussian''s <b>highest mean</b> used in fit.');
ttstr7 = wrapHtmlTooltipString('Gaussian''s <b>narrowest width</b> used in fit.');
ttstr8 = wrapHtmlTooltipString('<b>Starting guess</b> for Gaussian''s <b>width</b>: Gaussian parameters can be automatically imported from an inferred state configuration in panel "State configurations".');
ttstr9 = wrapHtmlTooltipString('Gaussian''s <b>largest width</b> used in fit.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA_fittingParameters;

% dimensions
pospan = get(h_pan,'position');
wpop0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wtxt0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = (pospan(3)-2*p.mg-3*mgprm-2*p.mg/2-wtxt1)/5;
wtxt2 = getUItextWidth(str11,p.fntun,p.fntsz1,'normal',p.tbl);

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hpop0;

h.popupmenu_thm_gaussNb = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_thm_gaussNb_Callback,h_fig});

x = x+wpop0+p.mg;
y = y+(hpop0-htxt0)/2;

h.text_gaussClr = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str2);

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_thm_gaussClr = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = p.mg+wtxt1;
y = y-p.mg/2-htxt0;

h.text_thm_low = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str3);

x = x+wedit0+mgprm;

h.text_thm_start = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str4);

x = x+wedit0+mgprm;

h.text_thm_up = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str5);

x = x+wedit0+p.mg/2;

h.text_thm_fit = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wedit0,htxt0],'string',str6);

x = x+wedit0+mgprm;

h.text_thm_sigma = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wedit0,htxt0],'string',str7);

x = p.mg;
y = y-hedit0+(hedit0-htxt0)/2;

h.text_thm_amp = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str8,'horizontalalignment','right');

x = x+wtxt1+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_thm_ampLow = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@edit_thm_ampLow_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_thm_ampStart = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@edit_thm_ampStart_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_thm_ampUp = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_thm_ampUp_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_thm_ampFit = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x+wedit0+mgprm;

h.edit_thm_ampSigma = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = p.mg;
y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_thm_centre = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str9,'horizontalalignment','right');

x = x+wtxt1+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_thm_centreLow = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr4,'callback',...
    {@edit_thm_centreLow_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_thm_centreStart = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr5,'callback',...
    {@edit_thm_centreStart_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_thm_centreUp = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr6,'callback',...
    {@edit_thm_centreUp_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_thm_centreFit = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x+wedit0+mgprm;

h.edit_thm_centreSigma = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = p.mg;
y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_thm_fwhm = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str10,'horizontalalignment','right');

x = x+wtxt1+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_thm_fwhmLow = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr7,'callback',...
    {@edit_thm_fwhmLow_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_thm_fwhmStart = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr8,'callback',...
    {@edit_thm_fwhmStart_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_thm_fwhmUp = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr9,'callback',...
    {@edit_thm_fwhmUp_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_thm_fwhmFit = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x+wedit0+mgprm;

h.edit_thm_fwhmSigma = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

y = y-p.mg/2-hedit0;

h.edit_thm_relOccSigma = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x-mgprm-wedit0;

h.edit_thm_relOccFit = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x-p.mg/2-wtxt2;

h.text_thm_relOcc = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt2,htxt0],'string',str11,'horizontalalignment','right');

