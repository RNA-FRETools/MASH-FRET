function h = buildPanelTAstateDegeneracy(h,p)
% h = buildPanelTAstateDegeneracy(h,p)
%
% Builds panel "State degeneracy" in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_stateDegeneracy: handle to panel "State degeneracy"

% defaults
htxt0 = 14;
hbut0 = 20;
hpop0 = 22;
hedit0 = 20;
fact = 5;
str0 = 'method';
str1 = 'bin';
str2 = 'Dmax';
str3 = 'restart';
str4 = {'ML-DPH',...
    'From exponential fit'};
str5a = 'Start ML-DPH';
str5b = 'Import states';
str6 = 'Results:';
str7 = 'histogram';
str8 = {'Select a dwell time histogram'};
str9 = 'D';
str10 = 'degen';
str11 = {'Select a degenerate state'};
str12 = 'lifetime(s)';
str13 = 'transition';
str14 = {'Select a transition'};
str15 = 'w';
ttstr0 = wrapHtmlTooltipString('Method to determine the <b>number of degenerate states</b> in each dwell time histogram: <b>ML-DPH:</b> determined via E-M inferrences of DPH fit and BIC-based model selection; <b>From exponential fit:</b> use the number of exponential functions found in panel "Dwell time histograms".');
ttstr1 = wrapHtmlTooltipString('<b>Bin size</b> (in time steps) of the dwell time histogram prior performing ML-DPH fit. This value is relative to the resolution limit in time of the state finding algorithm used.');
ttstr2 = wrapHtmlTooltipString('<b>Maximum number of degenerate states</b> to find in the dwell time histogram.');
ttstr3 = wrapHtmlTooltipString('Number of <b>DPH parameters initialization</b> used in ML-DPH: a large number prevents to converge to a local maxima but is time consuming; <b>restart = 5</b> is a good compromise between time and accuracy');
ttstr4 = wrapHtmlTooltipString('<b>Start ML-DPH fit</b> and subsequent BIC selection.');
ttstr5 = wrapHtmlTooltipString('Select a <b>dwell time histogram</b> to show the corresponding ML-DPH results.');
ttstr6 = wrapHtmlTooltipString('<b>Optimum state degeneracy</b> determine by ML-DPH.');
ttstr7 = wrapHtmlTooltipString('Select a <b>degenerate state</b> to show the corresponding lifetime and transition probabilities determine by ML-DPH.');
ttstr8 = wrapHtmlTooltipString('Degenerate state''s <b>lifetime</b> determined by ML-DPH.');
ttstr9 = wrapHtmlTooltipString('Select a degenerate state''s <b>transition</b> to show the corresponding probability determine by ML-DPH.');
ttstr10 = wrapHtmlTooltipString('Degenerate state''s <b>transition probability</b> determined by ML-DPH.');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_stateDegeneracy;

% dimensions
pospan = get(h_pan,'position');
wedit0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wpop0 = pospan(3)-p.mg-3*(p.mg/fact+wedit0)-p.mg;
wbut0 = max([getUItextWidth(str5a,p.fntun,p.fntsz1,'normal',p.tbl),...
    getUItextWidth(str5b,p.fntun,p.fntsz1,'normal',p.tbl)])+p.wbrd;
wtxt0 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
wpop1 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl);
wedit1 = pospan(3)-p.mg-wtxt0-p.mg/fact-wpop1-p.mg/fact-p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TA_mdlMethod = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = x+wpop0+p.mg/fact;

h.text_TA_mdlBin = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str1);

x = x+wedit0+p.mg/fact;

h.text_TA_mdlJmax = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str2);

x = x+wedit0+p.mg/fact;

h.text_TA_mdlDPHrestart = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = p.mg;
y = y-hpop0;

h.popupmenu_TA_mdlMeth = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop0,hpop0],'string',str4,'tooltipstring',ttstr0,...
    'callback',{@popupmenu_TA_mdlMeth_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TA_mdlBin = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@edit_TA_mdlBin_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TA_mdlJmax = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@edit_TA_mdlJmax_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TA_mdlDPHrestart = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr3,'callback',...
    {@edit_TA_mdlDPHrestart_Callback,h_fig});

x = pospan(3)-p.mg-wbut0;
y = y-(hpop0-hedit0)/2-p.mg/2-hbut0;

h.pushbutton_TA_fitMLDPH = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hbut0],'string',str5a,'tooltipstring',ttstr4,...
    'callback',{@pushbutton_TA_fitMLDPH_Callback,h_fig},'userdata',...
    {str5a,str5b});

x = p.mg;
y = y-p.mg-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_TA_mdlRes = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str6);

x = x+wtxt0+p.mg/fact;
y = y-(hpop0-htxt0)/2+hpop0;

h.text_TA_mdlHist = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str7);

y = y-hpop0;

h.popupmenu_TA_mdlHist = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop1,hpop0],'string',str8,'tooltipstring',ttstr5,...
    'callback',{@popupmenu_TA_mdlHist_Callback,h_fig});

x = x+wpop1+p.mg/fact;
y = y+hpop0;

h.text_TA_mdlD = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,htxt0],'string',str9);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TA_mdlD = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'tooltipstring',ttstr6,'callback',...
    {@edit_TA_mdlD_Callback,h_fig});

x = p.mg+wtxt0+p.mg/fact;
y = y-(hpop0-hedit0)/2-p.mg/2-htxt0;

h.text_TA_mdlDegen = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str10);

y = y-hpop0;

h.popupmenu_TA_mdlDegen = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop1,hpop0],'string',str11,'tooltipstring',ttstr7,...
    'callback',{@popupmenu_TA_mdlDegen_Callback,h_fig});

x = x+wpop1+p.mg/fact;
y = y+hpop0;

h.text_TA_mdlLifetime = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,htxt0],'string',str12);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TA_mdlLifetime = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'tooltipstring',ttstr8,'callback',...
    {@edit_TA_mdlLifetime_Callback,h_fig});

x = p.mg+wtxt0+p.mg/fact;
y = y-(hpop0-hedit0)/2-p.mg/2-htxt0;

h.text_TA_mdlTrans = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str13);

y = y-hpop0;

h.popupmenu_TA_mdlTrans = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop1,hpop0],'string',str14,'tooltipstring',ttstr9,...
    'callback',{@popupmenu_TA_mdlTrans_Callback,h_fig});

x = x+wpop1+p.mg/fact;
y = y+hpop0;

h.text_TA_mdlTransProb = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,htxt0],'string',str15);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TA_mdlTransProb = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'tooltipstring',ttstr10,'callback',...
    {@edit_TA_mdlTransProb_Callback,h_fig});



