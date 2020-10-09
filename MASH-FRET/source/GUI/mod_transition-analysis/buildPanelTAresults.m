function h = buildPanelTAresults(h,p)
% h = buildPanelTAresults(h,p);
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
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% Created by MH, 8.11.2019

% defaults
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
wedit0 = 40;
fact = 5;
lim0 = [0.5,10.5];
axttl0 = 'BIC';
str0 = 'Jopt';
str1 = 'sigma';
str2 = 'Show model:';
str3 = 'J =';
str4 = {'Select a number of states'};
str5 = '>>';
str6 = 'reset';
ttstr0 = wrapStrToWidth('<b>Model complexity:</b> optimum number of states; when BOBA FRET activated, the bootstrap mean is shown here.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Sample variability:</b> when BOBA FRET activated, the bootstrap standard deviation of optimum number of states is shown here.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Export transition clusters</b> from the selected state configuration to panel "State trasition rates" for dwell time analysis.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Delete clustering</b> results.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_results;

% dimensions
pospan = get(h_pan,'position');
waxes0 = pospan(3)-p.mg-p.mg/2-p.mg/fact-2*wedit0;
haxes0 = pospan(4)-p.mgpan-p.mg;
wtxt0 = pospan(3)-p.mg-p.mg/2-waxes0;
wtxt1 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop0 = pospan(3)-p.mg-p.mg/2-p.mg/fact-waxes0-wtxt1-wbut0;
mgres = (pospan(4)-p.mgpan-p.mg-p.mg/fact-2*hedit0-hpop0-2*htxt0)/2;

% GUI
x = 0;
y = pospan(4)-p.mgpan-haxes0;

h.axes_tdp_BIC = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'ylim',lim0,'xtick',...
    [], 'nextplot', 'replacechildren');
h_axes = h.axes_tdp_BIC;
title(h_axes,axttl0);
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

x = waxes0+p.mg/2;
y = pospan(4)-p.mgpan-htxt0;

h.text_TDPbobaRes = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str0);

x = x+wedit0+p.mg/fact;

h.text_TDPbobaSig = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str1);

x = waxes0+p.mg/2;
y = y-hedit0;

h.edit_TDPbobaRes = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr0,'callback',...
    {@edit_TDPbobaRes_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TDPbobaSig = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@edit_TDPbobaSig_Callback,h_fig});

x = waxes0+p.mg/2;
y = y-mgres-htxt0;

h.text_tdp_showModel = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str2,'horizontalalignment','left');

y = y-p.mg/fact-hpop0+(hpop0-htxt0)/2;

h.text_tdp_Jequal = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str3);

x = x+wtxt1;
y = y-(hpop0-htxt0)/2;

h.popupmenu_tdp_model = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str4,'callback',...
    {@popupmenu_tdp_model_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.pushbutton_tdp_impModel = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str5,'tooltipstring',ttstr3,'callback',...
    {@pushbutton_tdp_impModel_Callback,h_fig});

x = waxes0+p.mg/2;
y = y-mgres-hedit0;

h.pushbutton_TDPresetClust = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hedit0],'string',str6,'tooltipstring',ttstr4,'callback',...
    {@pushbutton_TDPresetClust_Callback,h_fig});

