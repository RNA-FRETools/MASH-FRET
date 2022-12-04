function h = buildPanelHAstateConfiguration(h,p)
% h = buildPanelHAstateConfiguration(h,p)
%
% Builds "State configuration" panel in module "Histogram analysis"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA_stateConfiguration: handle to panel "State configuration"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.fntclr2: text color in special pushbuttons
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 3.11.2019

% default
htxt0 = 14;
hedit0 = 20;
hpop0 = 22;
fact = 5;
fntsz2 = 10;
str0 = 'Max. number of Gaussians:';
str1 = 'Start analysis';
str1b = 'Penalty:';
str2 = 'min. improvement:';
str3 = 'BIC';
str3b = 'Likelihood:';
str3c = {'complete data','incomplete data'};
str4 = 'Suggested configuration:';
str5 = '99';
str6 = 'Model:';
str7 = {'Select a model'};
str8 = 'Gaussian nb.';
str9 = 'LogL:';
str10 = 'BIC:';
str11 = '>>';
ttstr0 = wrapHtmlTooltipString('<b>Maximum model complexity:</b> largest number of Gaussians to fit to the histogram.');
ttstr1 = wrapHtmlTooltipString('<b>Infer state configurations:</b> Gaussian mixtures with increasing complexities will be successfully fit to the histogram.');
ttstr2 = wrapHtmlTooltipString('<b>Model selection:</b> overfitting is penalized using a <b>minimum improvement</b> in likelihood (the model is selected if further increase in complexity does not sufficiently improve the likelihood).');
ttstr3 = wrapHtmlTooltipString('<b>Improvement factor:</b> multiplication factor that expresses the minimum improvement in likelihood (example: 1.2 set a minimum improvement of 20%).');
ttstr4 = wrapHtmlTooltipString('<b>Model selection:</b> overfitting is penalized using the <b>BIC</b> (the selected model minimizes the BIC).');
ttstr4b = wrapHtmlTooltipString('<b>Likelihood calculation:</b> <u>complete data:</u> each bin is associated to one and only Gaussian; <u>incomplete data:</u> bins have a non-null probability to belong to each Gaussian (subject to overestimation of model complexity).');
ttstr5 = wrapHtmlTooltipString('Select an inferred <b>state configuration</b> to show on the histogram plot: configurations are labelled with the corresponding number of Gaussians.');
ttstr6 = wrapHtmlTooltipString('<b>Export Gaussian parameters</b> of the selected state configuration to panel "State populations" as starting guesses for state population analysis.');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_HA_stateConfiguration;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop0 = getUItextWidth(str3c{1},p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wtxt6 = getUItextWidth(str1b,p.fntun,p.fntsz1,'normal',p.tbl);
wrb0 = getUItextWidth(str2,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbox;
wrb1 = getUItextWidth(str3,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbox;
wtxt1 = getUItextWidth(str4,p.fntun,fntsz2,'normal',p.tbl);
wtxt3 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt4 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl);
wbut1 = getUItextWidth(str11,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wtxt2 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = pospan(3)-p.mg-wpop0-p.mg-wrb0-p.mg;
wedit1 = pospan(3)-p.mg-wtxt0-p.mg-wbut0-p.mg;
wedit2 = (pospan(3)-p.mg-wtxt3-wtxt4-3*p.mg/fact-wbut1-p.mg)/2;
htxt1 = (fntsz2/p.fntsz1)*htxt0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0+(hedit0-htxt0)/2;

h.text_thm_maxGaussNb = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0);

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

h.edit_thm_maxGaussNb = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'callback',{@edit_thm_maxGaussNb_Callback,h_fig},...
    'tooltipstring',ttstr0);

x = x+wedit1+p.mg;

h.pushbutton_thm_RMSE = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str1,'tooltipstring',ttstr1,'callback',...
    {@pushbutton_thm_RMSE_Callback,h_fig});

x = p.mg;
y = y-p.mg-htxt0;

h.text_thm_likelihood = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str3b);

y = y-hpop0;

h.popupmenu_thm_likelihood = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str3c,'tooltipstring',ttstr4b,'callback',...
    {@popupmenu_thm_likelihood_Callback,h_fig});

x = x+wpop0+p.mg;
y = y+hpop0;

h.text_thm_penalty = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt6,htxt0],'string',str1b,'horizontalalignment','left');

y = y-hpop0+(hpop0-hedit0)/2;

h.radiobutton_thm_penalty = uicontrol('style','radiobutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wrb0,hedit0],'string',str2,'tooltipstring',ttstr2,'callback',...
    {@radiobutton_thm_penalty_Callback,h_fig});

x = x+wrb0;

h.edit_thm_penalty = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_thm_penalty_Callback,h_fig},...
    'tooltipstring',ttstr3);

x = x-wrb0;
y = y-p.mg/fact-hedit0;

h.radiobutton_thm_BIC = uicontrol('style','radiobutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wrb1,hedit0],'string',str3,'tooltipstring',ttstr4,'callback',...
    {@radiobutton_thm_BIC_Callback,h_fig});

x = p.mg;
y = y-p.mg-htxt1;

h.text_thm_suggNgauss = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',fntsz2,'position',...
    [x,y,wtxt1,htxt1],'string',str4,'horizontalalignment','right');

x = x+wtxt1+p.mg/fact;

h.text_thm_calcNgauss = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',fntsz2,'fontweight','bold',...
    'position',[x,y,wtxt2,htxt1],'foregroundcolor',p.fntclr2,'string',...
    str5);

x = p.mg;
y = y-p.mg/2-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_thm_for = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt3,htxt0],'string',str6);

x = x+wtxt3;
y = y-(hpop0-htxt0)/2;

h.popupmenu_thm_nTotGauss = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt4,hpop0],'string',str7,'tooltipstring',ttstr5,'callback',...
    {@popupmenu_thm_nTotGauss_Callback,h_fig});

y = y+hpop0;

h.text_thm_nTotGauss = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt4,htxt0],'string',str8);

x = x+wtxt4+p.mg/fact;

h.text_thm_LogL = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wedit2,htxt0],'string',str9);

x = x+wedit2+p.mg/fact;

h.text_thm_BIC = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wedit2,htxt0],'string',str10);

x = x-wedit2-p.mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

h.edit_thm_LogL = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit2,hedit0],...
    'enable','inactive','callback',{@edit_thm_LogL_Callback,h_fig});

x = x+wedit2+p.mg/fact;

h.edit_thm_BIC = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit2,hedit0],...
    'enable','inactive','callback',{@edit_thm_BIC_Callback,h_fig});

x = x+wedit2+p.mg/fact;

h.pushbutton_thm_impPrm = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str11,'tooltipstring',ttstr6,'callback',...
    {@pushbutton_thm_impPrm_Callback,h_fig});

