function h = buildPanelTP(h,p)
% h = buildPanelTP(h,p);
%
% Builds "Trace processing" module including panels "Sample management", "Plot", "Sub-images", "Background corrections", "Cross-talks", "Factor corrections", "Denoising", "Photobleaching" and "Find states".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP: handle to the panel containing "Trace processing" module
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr2: text color in special pushbuttons
%   p.wbuth: pixel width of help buttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Last update, 10.1.2020 by MH: add panel "Cross-talks" and remove cross-talks parameters from panel "Factor corrections"
% created, 19.10.2019 by MH

% default
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
wedit0 = 40;
wbut0 = 23;
wlst1 = 90; % default label list width (invisible)
hlst1 = 80; % default label list height (invisible)
fact = 5;
[pname,o,o] = fileparts(mfilename('fullpath'));
cdata = imread(cat(2,pname,filesep,'arrow.png'));
str0 = 'auto.';
str1 = 'Show';
str2 = 'Opt.';
str3 = {'default labels'};
str4 = 'UPDATE';
str5 = 'UPDATE ALL';
str6 = 'EXPORT...';
ttl0 = 'Sample management';
ttl1 = 'Plot';
ttl2 = 'Sub-images';
ttl3 = 'Background correction';
ttl4 = 'Cross-talks';
ttl5 = 'Factor corrections';
ttl6 = 'Denoising';
ttl7 = 'Photobleaching';
ttl8 = 'Find states';
tabttl0 = 'Traces';
ttstr0 = wrapHtmlTooltipString('Go to <b>previous molecule</b> in the list.');
ttstr1 = wrapHtmlTooltipString('<b>Current molecule</b> index in the list.');
ttstr2 = wrapHtmlTooltipString('Go to <b>next molecule</b> in the list.');
ttstr3 = wrapHtmlTooltipString('<b>Refresh calculations</b> for current trajectories.');
ttstr4 = wrapHtmlTooltipString('<b>Refresh calculations</b> for all trajectories.');
ttstr5 = wrapHtmlTooltipString('Open <b>export options</b>.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP;

% dimensions
pospan = get(h_pan,'position');
wcb2 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wbut1 = getUItextWidth(str4,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut2 = getUItextWidth(str5,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut3 = getUItextWidth(str6,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut5 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut6 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpan1 = 2*p.mg+4*p.mg/fact+2*wedit0+wcb2+wbut5+wbut6;
wtab = pospan(3)-3*p.mg-wpan1;
htab = pospan(4)-2*p.mg;
wtxt0 = pospan(3)-p.mg-wtab-p.mg-2*wbut0+wedit0-p.mg/2-p.mg;
hpan0 = p.mgpan+6*p.mg/fact+2*p.mg+hpop0+6*hedit0+2*htxt0;
hpan1 = p.mgpan+htxt0+hpop0+p.mg/fact+htxt0+hpop0+p.mg/fact+htxt0+hedit0+...
    p.mg+hedit0+p.mg;
hpan2 = p.mgpan+3*htxt0+p.mg/fact+htxt0+p.mg/fact+htxt0+hpop0+p.mg;
hpan3 = p.mgpan+htxt0+hpop0+p.mg/fact+htxt0+hedit0+p.mg/fact+hedit0+...
    p.mg/fact+hedit0+p.mg;
hpan4 = p.mgpan+hpop0+p.mg/2+2*(htxt0+hpop0+p.mg/2)+p.mg/2;
hpan5 = p.mgpan+p.mg+p.mg/fact+hpop0+hedit0;
hpan6 = p.mgpan+p.mg+p.mg/fact+2*hpop0+2*htxt0;
hpan7 = p.mgpan+htxt0+hpop0+p.mg/fact+htxt0+hedit0+p.mg+p.mg/2;
hpan8 = p.mgpan+3*(htxt0+hpop0+p.mg)+htxt0+hedit0+p.mg/fact+hedit0+p.mg+...
    htxt0+hpop0+p.mg;

% GUI
x = p.mg;
y = p.mg;

h.uitabgroup_TP_plot = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab],'selectionchangedfcn',...
    {@uitabgroup_plot_SelectionChangedFcn,'TP',h_fig});
h_tabgrp = h.uitabgroup_TP_plot;

h.uitab_TP_plot_traces = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl0);
h = buildTPtabPlotTraces(h,p);

x = x+wtab+p.mg;
y = pospan(4)-p.mg-hpan0;

h.uipanel_TP_sampleManagement = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan0],'title',ttl0);
h = buildPanelTPsampleManagement(h,p);

y = y-p.mg-hpan1;

h.uipanel_TP_plot = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan1],'title',ttl1);
h = buildPanelTPplot(h,p);

y = y-p.mg-hpan2;

h.uipanel_TP_subImages = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan2],'title',ttl2);
h = buildPanelTPsubImages(h,p);

y = y-p.mg-hpan3;

h.uipanel_TP_backgroundCorrection = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan1,hpan3],'title',ttl3);
h = buildPanelTPbackgroundCorrection(h,p);

y = y-p.mg-hpan4;

h.uipanel_TP_crossTalks = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan4],'title',ttl4);
h = buildPanelTPcrossTalks(h,p);

y = y-p.mg-hpan5;

h.uipanel_TP_denoising = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan5],'title',ttl6);
h = buildPanelTPdenoising(h,p);

y = y-p.mg-hpan6;

h.uipanel_TP_photobleaching = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan6],'title',ttl7);
h = buildPanelTPphotobleaching(h,p);

y = y-p.mg-hpan7;

h.uipanel_TP_factorCorrections = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan7],'title',ttl5);
h = buildPanelTPfactorCorrections(h,p);

y = y-p.mg-hpan8;

h.uipanel_TP_findStates = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan8],'title',ttl8);
h = buildPanelTPfindStates(h,p);

x = p.mg+wtab+p.mg;
y = p.mg+hedit0+p.mg/2;

h.pushbutton_molPrev = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'position',[x,y,wbut0,hedit0],'tooltipstring',ttstr0,...
    'callback',{@pushbutton_molPrev_Callback,h_fig},'cdata',cdata,...
    'userdata','nohelp');

x = x+wbut0;

h.edit_currMol = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_currMol_Callback,h_fig},'tooltipstring',ttstr1);

x = x+wedit0;

h.pushbutton_molNext = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'position',[x,y,wbut0,hedit0],'tooltipstring',ttstr2,...
    'callback',{@pushbutton_molNext_Callback,h_fig},'cdata',flip(cdata,2),...
    'userdata','nohelp');

x = x+wbut0+p.mg/2;
y = y+(hedit0-htxt0)/2;

h.text_molTot = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string','','horizontalalignment','left');

x = p.mg+wtab+p.mg;
y = y-(hedit0-htxt0)/2-p.mg/2-hedit0;

h.pushbutton_ttGo = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wbut1,hedit0],'string',str4,'tooltipstring',ttstr3,...
    'callback',{@pushbutton_ttGo_Callback,h_fig},'foregroundcolor',...
    p.fntclr2);

x = x+wbut1+p.mg/2;

h.pushbutton_TP_updateAll = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut2,hedit0],'string',str5,'tooltipstring',...
    ttstr4,'callback',{@pushbutton_TP_updateAll_Callback,h_fig});

x = pospan(3)-p.mg-wbut3;

h.pushbutton_expTraces = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut3,hedit0],'string',str6,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_expTraces_Callback,h_fig});

% place invivisible label list
posbut = get(h.togglebutton_TP_addTag,'position');
pospan = get(h.uipanel_TP_sampleManagement,'position');
x = pospan(1)+posbut(1)-wlst1;
y = pospan(2)+posbut(2)+posbut(4)-hlst1;

h.listbox_TP_defaultTags = uicontrol('style','listbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wlst1,hlst1],'string',str3,'visible','off','callback',...
    {@listbox_TP_defaultTags_Callback,h_fig});


