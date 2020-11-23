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
wedit0 = 40;
fact = 5;
str0 = ' Go! ';
str1 = 'model complexity';
str2 = {'Find most sufficient complexity (recommended)',...
    'Use "State lifetimes" complexity'};
str3 = 'max';
str4 = 'restart';
ttl0 = 'BIC';
ttl1 = 'Dwell times';
ttl2 = 'Pop.';
ttl3 = 'Trans.';
ttstr0 = wrapHtmlTooltipString('Method to determine the <b>number of degenerated levels</b> for each state value: (1) determined via E-M inferrences of DPH fit and BIC-based model selection, and (2) use the model complexity defined in panel "State lifetimes".');
ttstr1 = wrapHtmlTooltipString('Maximum number of degenerated levels to fit');
ttstr2 = wrapHtmlTooltipString('Number of <b>matrix initializations</b> used to infer transition rate constants: a large number prevents to converge to a local maxima but is time consuming; <b>restart = 5</b> is a good compromise between time and accuracy');
ttstr3 = wrapHtmlTooltipString('<b>Refresh transition rate constants</b> and simulation');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_kineticModel;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop0 = (pospan(3)-3*p.mg)/2-2*wedit0-wbut0-3*p.mg/fact;
waxes0 = (pospan(3)-3*p.mg)/2;
haxes0 = pospan(4)-p.mgpan-htxt0-hpop0-2*p.mg;
wtab = waxes0;
htab = pospan(4)-p.mgpan-p.mg;

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
    'position',[x,y,wpop0,hpop0],'string',str2,'tooltipstring',ttstr0,...
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

x = x+wedit0+p.mg/fact;
y = y+(hedit0-hbut0)/2;

h.pushbutton_TA_refreshModel = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hbut0],'string',str0,'tooltipstring',ttstr3,...
    'callback',{@pushbutton_TA_refreshModel_Callback,h_fig});

x = p.mg;
y = y+(hbut0-hpop0)/2-p.mg-haxes0;

h.axes_TDPplot3 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'box','on','xtick',...
    [],'ytick',[],'color','none');

x = pospan(3)-p.mg-wtab;
y = pospan(4)-p.mgpan-htab;

h.uitabgroup_TA_simModel = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab]);
h_tabgrp = h.uitabgroup_TA_simModel;

h.uitab_TA_mdlBIC = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    ttl0);
h = buildTAtabBIC(h,p);

h.uitab_TA_dwelltimes = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    ttl1);
h = buildTAtabDwelltimes(h,p);

h.uitab_TA_pop = uitab('parent',h_tabgrp,'units',p.posun,'title',ttl2);
h = buildTAtabPop(h,p);

h.uitab_TA_trans = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    ttl3);
h = buildTAtabTrans(h,p);

