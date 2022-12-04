function h = buildPanelTAtransitionRateConstants(h,p)
% h = buildPanelTAtransitionRateConstants(h,p)
%
% Builds panel "Transition rate constants" in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_transitionRateConstants: handle to panel "Transition rate constants"

% defaults
htxt0 = 14;
hbut0 = 20;
hedit0 = 20;
str0 = 'restart';
str1 = 'Estimate rate constants';
ttstr0 = wrapHtmlTooltipString('Number of <b>transition matrix initializations</b> in the Baum-Welch algorithm: a large number prevents to converge to a local maxima but is time consuming; <b>restart = 5</b> is a good compromise between time and accuracy');
ttstr1 = wrapHtmlTooltipString('<b>Start Baum-Welch inference</b> and subsequent validation by simulation.');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_transitionRateConstants;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wedit0 = pospan(3)-p.mg-p.mg/2-wbut0-p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TA_mdlRestartNb = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str0);

x = p.mg;
y = y-hedit0;

h.edit_TA_mdlRestartNb = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr0,'callback',...
    {@edit_TA_mdlRestartNb_Callback,h_fig});

x = x+wedit0+p.mg/2;
y = y-(hbut0-hedit0)/2;

h.pushbutton_TA_refreshModel = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hbut0],'string',str1,'tooltipstring',ttstr1,...
    'callback',{@pushbutton_TA_refreshModel_Callback,h_fig});

