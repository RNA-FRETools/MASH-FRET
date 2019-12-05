function h = buildPanelTAstateTransitionRates(h,p)
% h = buildPanelTAstateTransitionRates(h,p);
%
% Builds panel "State transition rates" in "Transition analysis" module including panels "Transitions" and "Fitting parameters".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_stateTransitionRates: handle to panel "State transition rates"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.warr: width of downwards arrow in popupmenu
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% Created by MH, 9.11.2019

% defaults
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
wedit1 = 40;
waxes1 = 83;
fact = 5;
mgprm = 1;
lim0 = [0,10000];
xlbl0 = 'dwell-times (s)';
ylbl0 = 'normalized (1 - cum(P))';
axttl0 = 'Kinetic analysis from dwell-times';
str0 = 'stretched';
str1 = 'BOBA';
str2 = 'replic.';
str3 = 'samp.';
str4 = 'nb. of decays:';
str5 = 'weight';
str6 = 'y-log scale';
str7 = 'dec.(s):';
ttl0 = 'Transitions';
ttl1 = 'Fitting parameters';
ttstr0 = wrapStrToWidth('<b>Fitting function:</b> when activated, a <b>stretched exponential decay</b> function, amp*exp[-(t/dec)^beta], is fitted to the dwell time histogram.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Molecule bootstrapping:</b> when activated, sample histograms are created from molecules randomly selected in the project (replicates) and are fitted with an exponential function; the resulting bootstrap mean and standard deviation of fit parameters are used to estimate the cross-sample variability of exponential decays and thus, of state transition rates.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Fitting function:</b> when activated, a <b>sum of exponential decay</b> functions, amp*exp(-t/dec), is fitted to the dwell time histogram.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Number of expoenntial functions</b> to sum up in the fitting model.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Replicate weighing:</b> when activated, replicates are being given a weight proportional to the length of their time traces; this prevents the over-representation of short trajectories in bootstrap samples.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Number of bootstrap replicates:</b> number of molecules randomly selected in the project, used to create one sample histogram.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('<b>Number of bootstrap samples:</b> number of sample histograms to create in order to estimate cross-sample variability.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr7 = wrapStrToWidth('Show histogram''s y-axis in a <b>logarithmic scale</b>.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_stateTransitionRates;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl);
wpan1 = 2*p.mg+3*mgprm+p.mg/2+wtxt0+5*wedit1;
hpan1 = p.mgpan+p.mg+p.mg/2+2*mgprm+hpop0+htxt0+3*hedit0;
wpan0 = pospan(3)-3*p.mg-wpan1;
hpan0 = p.mg/2+p.mg/fact+2*hedit0+hpan1;
wrb0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb0 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wedit0 = (wpan1-p.mg/fact-p.mg/2-wrb0-wcb0)/3;
waxes0 = pospan(3)-2*p.mg;
haxes0 = pospan(4)-p.mgpan-2*p.mg-hpan0;
wbut0 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% GUI
x = p.mg+wpan0+p.mg;
y = pospan(4)-p.mgpan-hedit0;

h.radiobutton_TDPstretch = uicontrol('style','radiobutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wrb0,hedit0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@radiobutton_TDPstretch_Callback,h_fig});

x = x+wrb0+wedit0+p.mg/2;

h.checkbox_BOBA = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str1,'tooltipstring',ttstr1,'callback',...
    {@checkbox_BOBA_Callback,h_fig});

x = x+wcb0;
y = y+(hedit0-htxt0)/2;

h.text_bs_nRep = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str2);

x = x+wedit0+p.mg/fact;

h.text_bs_nSamp = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str3);

x = p.mg+wpan0+p.mg;
y = y-p.mg/fact-hedit0;

h.radiobutton_TDPmultExp = uicontrol('style','radiobutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wrb0,hedit0],'string',str4,'tooltipstring',ttstr2,'callback',...
    {@radiobutton_TDPmultExp_Callback,h_fig});

x = x+wrb0;

h.edit_TDP_nExp = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_TDP_nExp_Callback,h_fig});

x = x+wedit0+p.mg/2;

h.checkbox_bobaWeight = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str5,'tooltipstring',ttstr4,'callback',...
    {@checkbox_bobaWeight_Callback,h_fig});

x = x+wcb0;

h.edit_TDPbsprm_01 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr5,'callback',...
    {@edit_TDPbsprm_01_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TDPbsprm_02 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr6,'callback',...
    {@edit_TDPbsprm_02_Callback,h_fig});

x = p.mg;
y = pospan(4)-p.mgpan-hpan0;

h.uipanel_TA_transitions = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelTAtransitions(h,p);

x = x+wpan0+p.mg;

h.uipanel_TA_fittingParameters = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan1,hpan1],'title',ttl1);
h = buildPanelTAfittingParameters(h,p);

x = p.mg;
y = y-p.mg-haxes0;

h.axes_TDPplot2 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'xlim',lim0,'ylim',...
    lim0);
h_axes = h.axes_TDPplot2;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl0);
title(h_axes,axttl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

x = posaxes(1)+posaxes(3)-waxes1;
y = posaxes(2)+posaxes(4)-waxes1;

h.axes_TDPplot3 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes1,waxes1],'xtick',[],'ytick',...
    []);

x = pospan(3)-p.mg-wbut0;
y = p.mg;

h.pushbutton_TDPfit_log = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str6,'tooltipstring',ttstr7,'callback',...
    {@pushbutton_TDPfit_log_Callback,h_fig});

