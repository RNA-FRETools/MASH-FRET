function h = buildPanelTAfittingParameters(h,p)
% h = buildPanelTAfittingParameters(h,p);
%
% Builds panel "Fitting parameters" in "Transition analysis".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_fittingParameters: handle to panel "Fitting parameters"
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
% Created by MH, 9.11.2019

% defaults
htxt0 = 14;
hedit0 = 20;
hpop0 = 22;
mgprm = 1;
str0 = 'exponential n°:99';
str1 = {'Select an exponential'};
str2 = 'Fit';
str3 = 'lower';
str4 = 'start';
str5 = 'upper';
str6 = 'fit';
str7 = 'sigma';
str8 = 'amp.:';
str9 = 'dec.(s):';
str10 = 'beta:';
ttstr0 = wrapHtmlTooltipString('Select an <b>exponential component</b> to adjust fitting parameters or show best fit parameters and bootstrapping results.');
ttstr1 = wrapHtmlTooltipString('<b>Start exponential fit</b> with current settings.');
ttstr2 = wrapHtmlTooltipString('Exponential''s <b>lowest amplitude</b> allowed in fit.');
ttstr3 = wrapHtmlTooltipString('<b>Starting guess</b> for exponential''s <b>amplitude</b>');
ttstr4 = wrapHtmlTooltipString('Exponential''s <b>highest amplitude</b> allowed in fit.');
ttstr5 = wrapHtmlTooltipString('Exponential''s <b>lowest decay constant</b> allowed in fit.');
ttstr6 = wrapHtmlTooltipString('<b>Starting guess</b> for exponential''s <b>decay constant</b>');
ttstr7 = wrapHtmlTooltipString('Exponential''s <b>highest decay constant</b> allowed in fit.');
ttstr8 = wrapHtmlTooltipString('Exponential''s <b>lowest stretching exponent</b> allowed in fit.');
ttstr9 = wrapHtmlTooltipString('<b>Starting guess</b> for exponential''s <b>stretching exponent</b>');
ttstr10 = wrapHtmlTooltipString('Exponential''s <b>highest stretching exponent</b> allowed in fit.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_fittingParameters;

% dimensions
pospan = get(h_pan,'position');
wpop0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wtxt0 = getUItextWidth(str9,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = (pospan(3)-2*p.mg-p.mg/2-3*mgprm-wtxt0)/5;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hpop0;

h.popupmenu_TDP_expNum = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TDP_expNum_Callback,h_fig});

x = pospan(3)-p.mg-wedit0;
y = y+(hpop0-hedit0)/2;

h.pushbutton_TDPfit_fit = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'string',str2,'tooltipstring',ttstr1,'callback',...
    {@pushbutton_TDPfit_fit_Callback,h_fig});

x = p.mg+wtxt0;
y = y-p.mg/2-htxt0;

h.text_TDPfit_lower = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = x+wedit0+mgprm;

h.text_TDPfit_start = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str4);

x = x+wedit0+mgprm;

h.text_TDPfit_upper = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str5);

x = x+wedit0+p.mg/2;

h.text_TDPfit_res = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wedit0,htxt0],'string',str6);

x = x+wedit0+mgprm;

h.text_TDPfit_bsRes = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wedit0,htxt0],'string',str7);

x = p.mg;
y = y-hedit0+(hedit0-htxt0)/2;

h.text_TDPfit_amp = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str8,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_TDPfit_aLow = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@edit_TDPfit_aLow_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_TDPfit_aStart = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr3,'callback',...
    {@edit_TDPfit_aStart_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_TDPfit_aUp = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr4,'callback',...
    {@edit_TDPfit_aUp_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_TDPfit_aRes = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x+wedit0+mgprm;

h.edit_TDPfit_ampBs = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = p.mg;
y = y-mgprm-hedit0+(hedit0-htxt0)/2;

h.text_TDPdec_amp = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str9,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_TDPfit_decLow = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr5,'callback',...
    {@edit_TDPfit_decLow_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_TDPfit_decStart = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr6,'callback',...
    {@edit_TDPfit_decStart_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_TDPfit_decUp = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr7,'callback',...
    {@edit_TDPfit_decUp_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_TDPfit_decRes = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x+wedit0+mgprm;

h.edit_TDPfit_decBs = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = p.mg;
y = y-mgprm-hedit0+(hedit0-htxt0)/2;

h.text_TDPfit_beta = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str10,'horizontalalignment','right');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_TDPfit_betaLow = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr8,'callback',...
    {@edit_TDPfit_betaLow_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_TDPfit_betaStart = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr9,'callback',...
    {@edit_TDPfit_betaStart_Callback,h_fig});

x = x+wedit0+mgprm;

h.edit_TDPfit_betaUp = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr10,'callback',...
    {@edit_TDPfit_betaUp_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.edit_TDPfit_betaRes = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');

x = x+wedit0+mgprm;

h.edit_TDPfit_betaBs = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive');


