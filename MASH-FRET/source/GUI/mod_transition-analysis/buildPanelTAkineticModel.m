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
hcb0 = 20;
hedit0 = 20;
wedit0 = 40;
str0 = 'Refresh model';
str1 = 'restart';
str2 = 'Plot:';
str3 = 'simulation';
str4 = 'experiment';
ttl0 = 'TDP';
ttl1 = 'Histogram';
ttl2 = 'Dwell times';
ttstr0 = wrapHtmlTooltipString('<b>Refresh transition rate constants</b> and simulation');
ttstr1 = wrapHtmlTooltipString('Number of <b>matrix initializations</b> used to infer transition rate constants: a large number prevents to converge to a local maxima but is time consuming; <b>restart = 5</b> is a good compromise between time and accuracy');
ttstr2 = wrapHtmlTooltipString('<b>Show simulated data</b> on comparison plot');
ttstr3 = wrapHtmlTooltipString('<b>Show experimental data</b> on comparison plot');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_kineticModel;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wtxt0 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl);
wcb0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb1 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
waxes0 = (pospan(3)-3*p.mg)/2;
haxes0 = pospan(4)-p.mgpan-htxt0-hbut0-2*p.mg;
wtab = waxes0;
htab = pospan(4)-p.mgpan-hcb0-2*p.mg;

x = p.mg;
y = pospan(4)-p.mgpan-htxt0-hbut0;

h.pushbutton_TA_refreshModel = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hbut0],'string',str0,'tooltipstring',ttstr0,...
    'callback',{@pushbutton_TA_refreshModel_Callback,h_fig});

x = x+wbut0+p.mg;
y = y+hbut0;

h.text_TA_mdlRestartNb = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str1);

y = y-hbut0+(hbut0-hedit0)/2;

h.edit_TA_mdlRestartNb = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@edit_TA_mdlRestartNb_Callback,h_fig});

x = p.mg;
y = y-(hbut0-hedit0)/2-p.mg-haxes0;

h.axes_TDPplot3 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'box','on','xtick',...
    [],'ytick',[],'color','none');

x = p.mg+waxes0+p.mg;
y = pospan(4)-p.mgpan-hcb0+(hcb0-htxt0)/2;

h.text_TA_simCompare = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str2,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hcb0-htxt0)/2;

h.checkbox_TA_mdlSim = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hcb0],'string',str3,'tooltipstring',ttstr2,'callback',...
    {@checkbox_TA_mdlSim_Callback,h_fig});

x = x+wcb0;

h.checkbox_TA_mdlExp = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb1,hcb0],'string',str4,'tooltipstring',ttstr3,'callback',...
    {@checkbox_TA_mdlExp_Callback,h_fig});

x = pospan(3)-p.mg-wtab;
y = y-p.mg-htab;

h.uitabgroup_TA_simModel = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab]);
h_tabgrp = h.uitabgroup_TA_simModel;

h.uitab_TA_tdp = uitab('parent',h_tabgrp,'units',p.posun,'title',ttl0);
h = buildTAtabTdp(h,p);

h.uitab_TA_histogram = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    ttl1);
h = buildTAtabHistogram(h,p);

h.uitab_TA_dwelltimes = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    ttl2);
h = buildTAtabDwelltimes(h,p);

