function h = buildPanelTA(h,p)
% h = buildPanelTA(h,p);
%
% Builds "Transition analysis" module including panels "Transition density plot", "State configuration", "State lifetimes" and "Kinetic model".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA: handle to the panel containing the "Transition analysis" module
%   h.pushbutton_traceImpOpt: handle to pushbutton "ASCII options..." in module "Trace processing"
%   h.pushbutton_addTraces: handle to pushbutton "Add" in module "Trace processing"
%   h.listbox_traceSet: handle to project list in module "Trace processing"
%   h.pushbutton_remTraces: handle to pushbutton "Remove" in module "Trace processing"
%   h.pushbutton_expProj: handle to pushbutton "Save" in module "Trace processing"
%   h.pushbutton_thm_export: handle to pushbutton "Export" in module "Histogram analysis"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.warr: width of downwards arrow in popupmenu
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 19.10.2019

% default
str0 = 'ASCII options...';
str1 = 'Add';
str2 = 'Remove';
str3 = 'Export...';
str4 = 'Save';
ttl0 = 'Transition density plot';
ttl1 = 'State configuration';
ttl2 = 'State lifetimes';
ttl3 = 'Kinetic model';
ttstr0 = wrapHtmlTooltipString('Open <b>import options</b> to configure how state sequences are imported from ASCII files.');
ttstr1 = wrapHtmlTooltipString('<b>Import state sequences</b> from a .mash file or from a set of ASCII files.');
ttstr2 = wrapHtmlTooltipString('<b>Close selected project</b> and remove it from the list.');
ttstr3 = wrapHtmlTooltipString('<b>Export results</b> to ASCII files: including transition density plots, state configurations and state transition rates.');
ttstr4 = wrapHtmlTooltipString('<b>Export selected project</b> to a .mash file.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA;

% dimensions
pospan = get(h_pan,'position');
posbut0 = get(h.pushbutton_traceImpOpt,'position');
posbut1 = get(h.pushbutton_addTraces,'position');
poslst0 = get(h.listbox_traceSet,'position');
posbut2 = get(h.pushbutton_remTraces,'position');
posbut3 = get(h.pushbutton_thm_export,'position');
posbut4 = get(h.pushbutton_expProj,'position');
wedit0 = poslst0(3);
wpan1 = (pospan(3)-4*p.mg-poslst0(3))/2;
hpan1 = pospan(4)-2*p.mg;
hpan2 = (pospan(4)-2*p.mg-p.mg/2)/2;
hpan3 = pospan(4)-2*p.mg-p.mg/2-hpan2;

% GUI
h.pushbutton_TDPimpOpt = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    posbut0,'string',str0,'tooltipstring',ttstr0,'callback',...
    {@pushbutton_TDPimpOpt_Callback,h_fig});

h.pushbutton_TDPaddProj = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',posbut1,'string',str1,'tooltipstring',ttstr1,...
    'callback',{@pushbutton_TDPaddProj_Callback,h_fig},'foregroundcolor',...
    p.fntclr2);

h.listbox_TDPprojList = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    poslst0,'callback',{@listbox_TDPprojList_Callback,h_fig});

h.pushbutton_TDPremProj = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    posbut2,'string',str2,'tooltipstring',ttstr2,'callback',...
    {@pushbutton_TDPremProj_Callback,h_fig});

h.pushbutton_TDPexport = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',posbut3,'string',str3,'tooltipstring',ttstr3,...
    'callback',{@pushbutton_TDPexport_Callback,h_fig});

h.pushbutton_TDPsaveProj = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',posbut4,'string',str4,'tooltipstring',ttstr4,...
    'callback',{@pushbutton_TDPsaveProj_Callback,h_fig});

h.uipanel_TA_transitionDensityPlot = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'title',ttl0);
[h,pospan0] = buildPanelTAtransitionDensityPlot(h,p);

hedit1 = posbut4(2)-3*p.mg-pospan0(4);
x = p.mg;
y = posbut4(2)-p.mg-hedit1;

h.edit_TDPcontPan = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'max',2,'position',...
    [x,y,wedit0,hedit1],'enable','inactive','horizontalalignment','left');

x = x+poslst0(3)+p.mg;
y = p.mg;

h.uipanel_TA_stateConfiguration = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan1],'title',ttl1);
h = buildPanelTAstateConfiguration(h,p);

x = x+wpan1+p.mg;
y = pospan(4)-p.mg-hpan2;

h.uipanel_TA_stateLifetimes = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan2],'title',ttl2);
h = buildPanelTAstateLifetimes(h,p);

y = y-p.mg/2-hpan3;

h.uipanel_TA_kineticModel = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan1,hpan3],'title',ttl3);
h = buildPanelTAkineticModel(h,p);


