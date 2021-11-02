function h = buildPanelTAkineticModel(h,p)
% h = buildPanelTAkineticModel(h,p)
%
% Builds panel "Kinetic model" in "Transition analysis" module, including tabs "TDP", "Histogram" and "Dwell times".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_kineticModel: handle to panel "Kinetic model"

% defaults
htxt0 = 14;
hbut0 = 20;
hpop0 = 22;
hedit0 = 20;
fact = 5;
str0 = 'Find best model';
str1 = 'state degeneracy';
str3 = 'Dmax';
str4 = 'restart';
str5 = {'Estimate with BIC-ML-DPH',...
    'From exponential fit'};
ttstr0 = wrapHtmlTooltipString('Method to determine the <b>number of degenerate levels</b> for each observed state: (1) determined via E-M inferrences of DPH fit and BIC-based model selection, and (2) use the number of exponential functions defined in panel "Dwell time histograms".');
ttstr1 = wrapHtmlTooltipString('Maximum number of degenerate states');
ttstr2 = wrapHtmlTooltipString('Number of <b>transition matrix initializations</b> used to infer transition rate constants: a large number prevents to converge to a local maxima but is time consuming; <b>restart = 5</b> is a good compromise between time and accuracy');
ttstr3 = wrapHtmlTooltipString('<b>Start model inference</b> and subsequent validation by simulation.');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_kineticModel;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop0 = getUItextWidth(str5{1},p.fntun,p.fntsz1,'normal',p.tbl)+p.warr;
wedit0 = (pospan(3)-p.mg-wpop0-p.mg/fact-p.mg/fact-p.mg)/2;

x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TA_mdlComplexity = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str1);

x = x+wpop0+p.mg/fact;

h.text_TA_mdlJmax = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = x+wedit0+p.mg/fact;

h.text_TA_mdlRestartNb = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str4);

x = p.mg;
y = y-hpop0;

h.popupmenu_TA_mdlMeth = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop0,hpop0],'string',str5,'tooltipstring',ttstr0,...
    'callback',{@popupmenu_TA_mdlMeth_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TA_mdlJmax = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@edit_TA_mdlJmax_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TA_mdlRestartNb = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@edit_TA_mdlRestartNb_Callback,h_fig});

x = p.mg;
y = y-(hpop0-hedit0)/2-p.mg/2-hbut0;

h.pushbutton_TA_refreshModel = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hbut0],'string',str0,'tooltipstring',ttstr3,...
    'callback',{@pushbutton_TA_refreshModel_Callback,h_fig});

