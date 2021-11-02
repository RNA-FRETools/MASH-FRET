function h = buildPanelTAclustResults(h,p)
% h = buildPanelTAclustResults(h,p);
%
% Builds panel "Results" in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_results: handle to panel "Results"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 8.11.2019

% defaults
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
wedit0 = 40;
fact = 5;
str0 = 'Vopt';
str1 = 'sigma';
str2 = 'Model:';
str3 = 'V';
str4 = {'Select a number of states'};
str5 = 'Use this config.';
str6 = 'BIC:';
str7 = 'Reset results';
ttstr0 = wrapHtmlTooltipString('<b>Model complexity:</b> optimum number of states; when BOBA FRET activated, the bootstrap mean is shown here.');
ttstr1 = wrapHtmlTooltipString('<b>Sample variability:</b> when BOBA FRET activated, the bootstrap standard deviation of optimum number of states is shown here.');
ttstr3 = wrapHtmlTooltipString('<b>Export transition clusters</b> from the selected state configuration to panel "State trasition rates" for dwell time analysis.');
ttstr4 = wrapHtmlTooltipString('<b>Bayesian information criterion</b> corresponding to selected model complexity.');
ttstr5 = wrapHtmlTooltipString('<b>Delete clustering</b> results.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_results;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl);
wpop0 = pospan(3)-p.mg-wedit0-p.mg/fact-wedit0-wtxt0-2*p.mg/fact-wedit0-...
    p.mg;
wbut0 = wpop0+p.mg/fact+wedit0;
wbut1 = wedit0+p.mg/fact+wedit0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TDPbobaRes = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str0);

x = x+wedit0+p.mg/fact;

h.text_TDPbobaSig = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str1);

x = p.mg;
y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TDPbobaRes = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr0,'callback',...
    {@edit_TDPbobaRes_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TDPbobaSig = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@edit_TDPbobaSig_Callback,h_fig});

x = x+wedit0;
y = y+(hedit0-htxt0)/2;

h.text_tdp_showModel = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str2,'horizontalalignment','right');

x = x+wtxt0+p.mg/fact;
y = y-(hpop0-htxt0)/2+hpop0;

h.text_tdp_Jequal = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str3);

y = y-hpop0;

h.popupmenu_tdp_model = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str4,'callback',...
    {@popupmenu_tdp_model_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+hpop0;

h.text_tdp_BIC =  uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str6);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_tdp_BIC = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'callback',{@edit_tdp_bic_Callback,h_fig});

x = x-p.mg/fact-wpop0;
y = y-hpop0-p.mg/2;

h.pushbutton_tdp_impModel = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str5,'tooltipstring',ttstr3,'callback',...
    {@pushbutton_tdp_impModel_Callback,h_fig});

x = p.mg;

h.pushbutton_TDPresetClust = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str7,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_TDPresetClust_Callback,h_fig});

