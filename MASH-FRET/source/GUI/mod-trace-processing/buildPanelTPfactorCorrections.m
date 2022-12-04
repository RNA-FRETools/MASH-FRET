function h = buildPanelTPfactorCorrections(h,p)
% h = buildPanelTPfactorCorrections(h,p);
%
% Builds panel "Factor corrections" in module "Trace processing"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_factorCorrections: handle to panel "Factor corrections"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.fntclr2: text color in special pushbuttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% update: by MH, 10.1.2020: remove cross-talks parameters
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
wedit0 = 40;
fact = 5;
str0 = 'data';
str1 = 'method';
str2 = {'Manual','From acceptor photobleaching','Linear regression'};
str3 = 'Load';
str4 = 'Results:';
str5 = {'Select a FRET pair'};
str6 = 'gamma';
str7 = 'beta';
str8 = 'all';
ttstr0 = wrapHtmlTooltipString('Select an <b>estimation method:</b> photobleaching-based estimation of gamma factors requires acceptor to photobleach.');
ttstr1 = wrapHtmlTooltipString('Select a <b>FRET pair</b> to configure the gamma correction for.');
ttstr2 = wrapHtmlTooltipString('<b>Gamma factor</b> for the selected FRET pair.');
ttstr3 = wrapHtmlTooltipString('<b>Beta factor</b> for the selected FRET pair.');
ttstr4 = wrapHtmlTooltipString('Apply current factor corrections settings to all molecules.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_factorCorrections;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wtxt0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wpop0 = (pospan(3)-p.mg-2*p.mg/fact-wbut0-p.mg)/2;
wbut1 = getUItextWidth(str8,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;

x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TP_factors_data = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = x+wpop0+p.mg/fact;

h.text_TP_factors_method = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str1);

x = p.mg;
y = y-hpop0;

h.popupmenu_gammaFRET = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str5,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_gammaFRET_Callback,h_fig});

x = x+wpop0+p.mg/fact;

h.popupmenu_TP_factors_method = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop0,hpop0],'string',str2,'tooltipstring',ttstr0,...
    'callback',{@popupmenu_TP_factors_method_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.pushbutton_optGamma = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str3,'callback',...
    {@pushbutton_optGamma_Callback,h_fig});

x = p.mg+wtxt0;
y = y-(hpop0-hedit0)/2-p.mg/fact-htxt0;

h.text_TP_factors_gamma = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str6);

x = x+wedit0+p.mg/fact;

h.text_TP_factors_beta = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str7);

x = p.mg;
y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_TP_factors_fact = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str4,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_gammaCorr = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_gammaCorr_Callback,h_fig},'tooltipstring',ttstr2);

x = x+wedit0+p.mg/2;

h.edit_betaCorr = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_betaCorr_Callback,h_fig},'tooltipstring',ttstr3);

x = pospan(3)-p.mg-wbut1;

h.pushbutton_applyAll_corr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hedit0],'string',str8,'callback',...
    {@pushbutton_applyAll_corr_Callback,h_fig},'tooltipstring',ttstr4,...
    'foregroundcolor',p.fntclr2);


