function h = buildPanelTAstateConfiguration(h,p)
% h = buildPanelTAstateConfiguration(h,p);
%
% Builds panel "State configuration" in "Transition analysis" module including panels "Clusters" and "Results".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_stateConfiguration: handle to panel "State configuration"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 8.11.2019

% defaults
hedit0 = 20;
hbut0 = 20;
htxt0 = 14;
hpop0 = 22;
wedit0 = 40;
fact = 5;
lim0 = [-1000,1000];
lim1 = [0,10000];
meth = 2;
xlbl0 = 'Value before transition';
ylbl0 = 'Value after transition';
clbl0 = 'normalized occurrence';
str11 = {'red','green','blue','yellow','cyan','magenta','olive','orange',...
    'wine','marine','kaki','turpuoise','purple','brown','pink','violet',...
    'grey','canary','pastel blue'};
str0 = 'method';
str2 = {'k-mean','GM','simple'};
str3 = 'Jmax';
str4 = 'BOBA FRET';
str5 = 'replic.';
str6 = 'samp.';
str7 = 'x=0 y=0';
str8 = 'cluster:';
str9 = {'Select cluster'};
str10 = 'Set color';
ttl0 = 'Clusters';
ttl1 = 'Results';
ttstr0 = wrapHtmlTooltipString('<b>Clustering method:</b> <u>k-mean:</u> iterative process where state transitions are assigned to the nearest cluster center; <u>GM:</u> iterative process where transitions are assigned to the most probable Gaussian cluster (<i>model selection:</i> 2D-Gaussian mixtures with increasing complexities are successively fit to the TDP and overfitting is penalized using the BIC); <u>simple:</u> state transitions are assigned to the cluser in which they are contained.');
ttstr2 = wrapHtmlTooltipString('<b>TDP bootstrapping:</b> when activated, sample TDPs are created prior clustering and from molecules randomly selected in the project (replicates); the resulting bootstrap mean and standard deviation are used to estimate the cross-sample variability of model complexity.');
ttstr3 = wrapHtmlTooltipString('<b>Number of bootstrap replicates:</b> number of molecules randomly selected in the project, used to create one sample TDP.');
ttstr4 = wrapHtmlTooltipString('<b>Number of bootstrap samples:</b> number of sample TDPs to create in order to estimate cross-sample variability.');
ttstr5 = wrapHtmlTooltipString('Open color picker to set <b>cluster color</b>.');
ttstr6 = wrapHtmlTooltipString('Select a transition cluster');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_stateConfiguration;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wtxt0 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl);
warea = 2*p.mg+p.mg/2+2*wedit0;
wpop0 = warea-2*p.mg;
wcb0 = warea-2*p.mg;
wedit1 = (warea-2*p.mg-p.mg/fact)/2;
wpan0 = 2*p.mg+2*p.mg/fact+3*wedit0;
hpan0 = p.mgpan+hpop0+p.mg/2+htxt0+hpop0+p.mg/fact+hedit0+p.mg/2+hedit0+...
    p.mg/2+hedit0+p.mg;
mgarea = (hpan0-htxt0-hpop0-htxt0-hedit0-hedit0-p.mg/fact-htxt0-hedit0-p.mg)/2;
wpan1 = pospan(3)-warea-wpan0-2*p.mg;
waxes0 = warea+wpan0+wpan1-2*p.mg;
haxes0 = pospan(4)-p.mgpan-hpan0-p.mg-hpop0-2*p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TA_clstMeth = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = p.mg;
y = y-hpop0;

h.popupmenu_TA_clstMeth = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str2,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TA_clstMeth_Callback,h_fig},'value',meth);

x = p.mg;
y = y-mgarea-htxt0;

h.text_TDPnStates = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str3);

x = x+wedit0+p.mg/fact;

h.text_TDPiter = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0]);

x = p.mg;
y = y-hedit0;

h.edit_TDPnStates = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPnStates_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TDPmaxiter = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPmaxiter_Callback,h_fig});

x = p.mg;
y = y-mgarea-hedit0;

h.checkbox_TDPboba = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str4,'tooltipstring',ttstr2,'callback',...
    {@checkbox_TDPboba_Callback,h_fig});

y = y-p.mg/fact-htxt0;

h.text_TDPnRepl = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,htxt0],...
    'string',str5);

x = x+wedit1+p.mg/2;

h.text_TDPnSpl = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,htxt0],...
    'string',str6);

x = p.mg;
y = y-hedit0;

h.edit_TDPnRepl = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_TDPnRepl_Callback,h_fig});

x = x+wedit1+p.mg/2;

h.edit_TDPnSpl = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'tooltipstring',ttstr4,'callback',{@edit_TDPnSpl_Callback,h_fig});

x = p.mg;
y = p.mg+(hpop0-htxt0)/2;

h.text_TA_tdpCoord = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'position',[x,y,waxes0,htxt0],'fontunits',p.fntun,'fontsize',...
    p.fntsz1,'horizontalalignment','left','string',str7);

x = pospan(3)-p.mg-wbut0;
y = y-(hbut0-htxt0)/2;

h.pushbutton_TA_setClstClr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hbut0],'string',str10,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_TA_setClstClr_Callback,h_fig});

x = x-p.mg-wedit0;
y = y-(hpop0-hbut0)/2;

h.popupmenu_TA_setClstClr = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hpop0],'string',str9,'tooltipstring',ttstr6,'callback',...
    {@popupmenu_TA_setClstClr_Callback,h_fig});

x = x-p.mg-wtxt0;
y = y+(hpop0-hbut0)/2;

h.text_TA_setClstClr = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'position',[x,y,wtxt0,htxt0],'fontunits',p.fntun,'fontsize',...
    p.fntsz1,'horizontalalignment','left','string',str8);

x = p.mg;
y = y-(hpop0-htxt0)/2+hpop0+p.mg;

h.axes_TDPplot1 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'xlim',lim0,'ylim',...
    lim0,'clim',lim1,'nextplot','replacechildren','xaxislocation','top',...
    'yaxislocation','right','userdata',{[],false},'buttondownfcn',...
    {@axes_TDPplot1_ButtonDownFcn,h_fig});
h_axes = h.axes_TDPplot1;
xlabel(h_axes,xlbl0);
ylabel(h_axes,ylbl0);
% axis(h_axes,'square');
h.colorbar_TA = colorbar(h_axes,'units',p.posun);
ylabel(h.colorbar_TA,clbl0);
pos_cb = get(h.colorbar_TA,'position');
% adjust axes dimensions
tiaxes = get(h_axes,'tightinset');
posaxes = getRealPosAxes([x,y,waxes0-pos_cb(3)-p.mg/2,haxes0],tiaxes,'traces');
set(h_axes,'position',posaxes);

x = warea;
y = pospan(4)-p.mgpan-hpan0;

h.uipanel_TA_clusters = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelTAclusters(h,p);

x = x+wpan0+p.mg;

h.uipanel_TA_results = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan1,hpan0],'title',ttl1);
h = buildPanelTAresults(h,p);

h.uipanel_TA_selectTool = uipanel('parent',h_pan,'units',p.posun,'title',...
    '','visible','off');
h = buildPanelTAselectTool(h,p);

% adjust panel position
posbut = get(h.tooglebutton_TDPmanStart,'position');
pospan1 = get(h.uipanel_TA_clusters,'position');
pospan2 = get(h.uipanel_TA_selectTool,'position');
pospan2(1) = pospan1(1)+posbut(1)+posbut(3);
pospan2(2) = pospan1(2)+posbut(2)-(pospan2(4)-posbut(4))/2;
set(h.uipanel_TA_selectTool,'position',pospan2);

% store default color list
h.color_list = str0;

