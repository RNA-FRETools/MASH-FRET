function h = buildPanelTAclusters(h,p)
% h = buildPanelTAclusters(h,p);
%
% Builds panel "Clusters" in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_clusters: handle to panel "Clutsters"
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
fact = 5;
file_icon1a = 'icon_circle.png';
file_icon1b = 'icon_square.png';
file_icon2 = 'icon_ellips_straight.png';
file_icon3 = 'icon_ellips_diagonal.png';
file_icon4 = 'icon_ellips_free.png';
str9 = {'matrix','symmetrical','free'};
str10 = 'diagonal';
str0 = '\default';
str1 = 'cluster';
str2 = 'shape:';
str3 = 'state';
str4 = {'Select a state'};
str5 = 'likelihood';
str6 = 'value';
str7 = 'radius';
str8 = {'complete data','incomplete data'};

ttstr9 = wrapStrToWidth('<b>Cluster constraints:</b> <u>matrix:</u> cluster centers are combinations of states (state transition matrix); <u>symmetrical:</u> cluster centers have their projection on the opposite TDP half delimited by the diagonal; <u>free:</u> cluster centers are free of constraint.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr10 = wrapStrToWidth('<b>Diagonal clusters:</b> activate this option to cluster transitions located on the TDP diagonal; this is used to group together low-amplitude state transitions that are usually artefacts rising from noise discretization.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr0 = wrapStrToWidth('Make cluster centers <u>evenly spaced</u> (<b>starting guess</b>).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Clear cluster selection</b> or switch to <b>zoom</b> pointer.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Start clustering</b> with current method settings.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('Select a state to configure',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Cluster x-radius</b>: used for <b>k-mean</b> or <b>manual</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Cluster x-center</b>: used for <b>k-mean</b> or <b>manual</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('<b>Cluster y-center</b>: used for <b>k-mean</b> or <b>manual</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr7 = wrapStrToWidth('<b>Cluster y-radius</b>: used for <b>k-mean</b> or <b>manual</b> clustering',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr8 = wrapStrToWidth('<b>Likelihood calculation:</b> <u>complete data:</u> each transition is associated to one and only cluster; <u>incomplete data:</u> transitions have a non-null probability to belong to each cluster (subject to overestimation of model complexity).',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_clusters;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpop0 = pospan(3)-2*p.mg-wcb0-p.mg/fact;
wtxt0 = pospan(3)-2*p.mg;
wtxt1 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl);
wedit0 = (pospan(3)-2*p.mg-2*p.mg/fact)/3;
wbut2 = (pospan(3)-2*p.mg-wtxt1-3*p.mg/fact)/4;

% images
img1a = imread(file_icon1a);
img1b = imread(file_icon1b);
img2 = imread(file_icon2);
img3 = imread(file_icon3);
img4 = imread(file_icon4);

% GUI

x = p.mg;
y = pospan(4)-p.mgpan-hpop0;

h.popupmenu_TA_clstMat = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str9,'tooltipstring',ttstr9,'callback',...
    {@popupmenu_TA_clstMat_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.checkbox_TA_clstDiag = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str10,'tooltipstring',ttstr10,'callback',...
    {@checkbox_TA_clstDiag_Callback,h_fig});

x = p.mg;
y = y-(hpop0-hedit0)/2-p.mg/2-htxt0;

h.text_TDPlike = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str5);

h.text_TDPstate = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str3,'visible','off');

x = x+wedit0+p.mg/fact;

h.text_TDPiniVal = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str6,'visible','off');

x = x+wedit0+p.mg/fact;

h.text_TDPradius = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str7,'visible','off');

x = p.mg;
y = y-hpop0;

h.popupmenu_TDPlike = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'callback',{@popupmenu_TDPlike_Callback,h_fig},...
    'string',str8,'tooltipstring',ttstr8);

h.popupmenu_TDPstate = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hpop0],'callback',{@popupmenu_TDPstate_Callback,h_fig},...
    'string',str4,'tooltipstring',ttstr3,'visible','off');

y = y+(hpop0-hedit0)/2;
x = x+wedit0+p.mg/fact;

h.edit_TDPiniValX = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPiniVal_Callback,1,h_fig},...
    'tooltipstring',ttstr5,'visible','off');

x = x+wedit0+p.mg/fact;

h.edit_TDPradiusX = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPradius_Callback,1,h_fig},...
    'tooltipstring',ttstr4,'visible','off');

x = p.mg;
y = y-p.mg/fact-hedit0;

h.pushbutton_TDPautoStart = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@pushbutton_TDPautoStart_Callback,h_fig},'visible','off');

x = x+wedit0+p.mg/fact;

h.edit_TDPiniValY = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPiniVal_Callback,2,h_fig},...
    'tooltipstring',ttstr6,'visible','off');

x = x+wedit0+p.mg/fact;

h.edit_TDPradiusY = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TDPradius_Callback,2,h_fig},...
    'tooltipstring',ttstr7,'visible','off');

x = p.mg;
y = y-p.mg/2-hpop0+(hedit0-htxt0)/2;

h.text_TDPshape = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str2,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hpop0-htxt0)/2;

h.togglebutton_TDPshape1 = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'callback',{@togglebutton_TDPshape_Callback,1,h_fig},...
    'cdata',img1a,'userdata',{img1b,img1a,img1b});

x = x+wbut2+p.mg/fact;

h.togglebutton_TDPshape2 = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'callback',{@togglebutton_TDPshape_Callback,2,h_fig},...
    'cdata',img2);

x = x+wbut2+p.mg/fact;

h.togglebutton_TDPshape3 = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'callback',{@togglebutton_TDPshape_Callback,3,h_fig},...
    'cdata',img3);

x = x+wbut2+p.mg/fact;

h.togglebutton_TDPshape4 = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'callback',{@togglebutton_TDPshape_Callback,4,h_fig},...
    'cdata',img4);

h.tooglebutton_TDPmanStart = uicontrol('style','togglebutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut2,hedit0],'tooltipstring',ttstr1,'callback',...
    {@tooglebutton_TDPmanStart_Callback,h_fig,'open'},'userdata',1,...
    'visible','off');

x = p.mg;
y = y-p.mg/2-hedit0;

h.pushbutton_TDPupdateClust = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wtxt0,hedit0],'string',str1,'tooltipstring',ttstr2,...
    'callback',{@pushbutton_TDPupdateClust_Callback,h_fig});


