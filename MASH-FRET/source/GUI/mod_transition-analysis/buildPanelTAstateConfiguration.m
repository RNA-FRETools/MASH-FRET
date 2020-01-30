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
lim0 = [-1000,1000];
lim1 = [0,10000];
meth = 2;
xlbl0 = 'Value before transition';
ylbl0 = 'Value after transition';
clbl0 = 'normalized occurrence';
str0 = 'method';
str1 = {'k-mean','GM','manual'};
str2 = 'matrix';
str3 = 'Jmax';
str4 = 'diagonal clusters';
str5 = 'BOBA FRET';
str7 = 'replic.';
str8 = 'samp.';
str9 = 'x=0 y=0';
str10 = char(9668);
ttl0 = 'Clusters';
ttl1 = 'Results';
ttstr0 = wrapStrToWidth('<b>Clustering method:</b> <u>k-mean</u> (iterative process where state transitions are assigned to the nearest cluster center which are then re-calulated with the new TDP partition; iteration stops when the TDP partition does not change or when the maximum iteration is reached), <u>GM</u> (2D-Gaussian mixtures with increasing complexities are successfully fit to the TDP; overfitting is penalized using the BIC and transitions are assigned to the cluster where they hit the maximum probability), <u>manual</u> (clusters limits are drawn by hand with the selection tool)',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Cluster matrix:</b> activate this option to define states and set cluster centers as combinations of states (state transition matrix); when deactivated, cluster centers are free of constraint.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Diagonal clusters:</b> activate this option to cluster transitions located on the TDp diagonal; this is used to group together low-amplitude state transitions that are usually artefacts rising from noise discretization.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Maximum model complexity:</b> largest number of states in the TDP.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>TDP bootstrapping:</b> when activated, sample TDPs are created prior clustering and from molecules randomly selected in the project (replicates); the resulting bootstrap mean and standard deviation are used to estimate the cross-sample variability of model complexity.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Number of bootstrap replicates:</b> number of molecules randomly selected in the project, used to create one sample TDP.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('<b>Number of bootstrap samples:</b> number of sample TDPs to create in order to estimate cross-sample variability.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_stateConfiguration;

% dimensions
pospan = get(h_pan,'position');
warea = 2*p.mg+p.mg/2+2*wedit0;
wpop0 = warea-p.mg--p.mg/fact-wedit0-p.mg;
wcb0 = warea-2*p.mg;
wedit1 = (warea-2*p.mg-p.mg/fact)/2;
wpan0 = 2*p.mg+2*p.mg/fact+3*wedit0;
hpan0 = p.mgpan+p.mg+2*p.mg/2+p.mg/fact+2*htxt0+hpop0+3*hedit0;
mgarea = (hpan0-htxt0-hpop0-htxt0-hedit0-p.mg/fact-hedit0-hedit0-p.mg/fact-...
    htxt0-hedit0)/2;
wpan1 = pospan(3)-warea-wpan0-2*p.mg;
waxes0 = warea+wpan0+wpan1-2*p.mg;
haxes0 = pospan(4)-p.mgpan-hpan0-p.mg-htxt0-2*p.mg;
wbut2 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TA_clstMeth = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = x+wpop0+p.mg/fact;

h.text_TDPiter = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0]);

x = p.mg;
y = y-hpop0;

h.popupmenu_TA_clstMeth = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TA_clstMeth_Callback,h_fig},'value',meth);

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TDPmaxiter = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPmaxiter_Callback,h_fig});

x = p.mg;
y = y-mgarea-htxt0;

h.text_TDPnStates = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str3);

x = p.mg;
y = y-hedit0;

h.edit_TDPnStates = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr3,'callback',...
    {@edit_TDPnStates_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.checkbox_TA_clstMat = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hedit0],'string',str2,'tooltipstring',ttstr1,'callback',...
    {@checkbox_TA_clstMat_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-hedit0;

h.checkbox_TA_clstDiag = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str4,'tooltipstring',ttstr2,'callback',...
    {@checkbox_TA_clstDiag_Callback,h_fig});

y = y-mgarea-hedit0;

h.checkbox_TDPboba = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str5,'tooltipstring',ttstr4,'callback',...
    {@checkbox_TDPboba_Callback,h_fig});

y = y-p.mg/fact-htxt0;

h.text_TDPnRepl = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,htxt0],...
    'string',str7);

x = x+wedit1+p.mg/2;

h.text_TDPnSpl = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,htxt0],...
    'string',str8);

x = p.mg;
y = y-hedit0;

h.edit_TDPnRepl = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'tooltipstring',ttstr5,'callback',{@edit_TDPnRepl_Callback,h_fig});

x = x+wedit1+p.mg/2;

h.edit_TDPnSpl = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'tooltipstring',ttstr6,'callback',{@edit_TDPnSpl_Callback,h_fig});

x = p.mg;
y = p.mg;

h.text_TA_tdpCoord = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'position',[x,y,waxes0,htxt0],'fontunits',p.fntun,'fontsize',...
    p.fntsz1,'horizontalalignment','left','string',str9);

y = y+htxt0+p.mg;

h.axes_TDPplot1 = axes('parent',h_pan,'units',p.posun,'fontunits',p.fntun,...
    'fontsize',p.fntsz1,'position',[x,y,waxes0,haxes0],'xlim',lim0,'ylim',...
    lim0,'clim',lim1,'nextplot','replacechildren','xaxislocation','top',...
    'yaxislocation','right','userdata',0,'buttondownfcn',...
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

