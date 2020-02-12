function h = buildPanelVPcoordinatesTransformation(h,p)
% h = buildPanelVPcoordinatesTransformation(h,p);
%
% Builds "Coordinates transformation" panel in module "Video processing"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP_coordinatesTransformation: handle to the panel "Coordinates transformation"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wttsr: pixel width of tooltip box
%   p.fntclr1: text color in file/folder fields
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
fact = 5;
str0 = 'Calculate transformation:';
str1 = 'Map';
str2 = '...';
str3 = {'Transformation type','Nonreflective similarity (2)',...
    'Similarity (3)','Affine  (3)','Projective (4)','Polynomial ord2 (6)',...
    'Polynomial ord3 (10)','Polynomial ord4 (15)','Piecewise linear (4)',...
    'Local weighted mean (12)'};
str4 = 'Calculate';
str5 = 'Transformation file:';
str6 = 'Check quality...';
str7 = 'Input coordinates file:';
str8 = 'Options...';
str9 = 'Transform';
ttstr0 = wrapStrToWidth('Open the <b>Mapping tool</b> to map reference coordinates used to calculate the transformation.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('Open browser and select the <b>reference coordinates file</b> used to calculate channel transformation.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('Select a <b>combination of symmetry operations</b> to calculate the transformation.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Calculate transformation</b> and export to file.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('Open browser and select the <b>transformation file</b>: source file where channel transformations are taken from.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('Open browser and select the <b>reference image</b> to check the quality of imported transformation.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('Open browser and select the <b>spots coordinates file</b> to transform.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr7 = wrapStrToWidth('Open <b>import options</b> to configure how coordinates are imported from the reference and spots coordinate files.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr8 = wrapStrToWidth('Transform and export coordinates',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_coordinatesTransformation;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = pospan(3)-2*p.mg;
wbut0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wedit0 = pospan(3)-2*p.mg-2*p.mg/fact-wbut0-wbut1;
wbut2 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop0 = pospan(3)-2*p.mg-p.mg/fact-wbut2;
wedit1 = pospan(3)-2*p.mg-p.mg/fact-wbut1;
wbut3 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut4 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut5 = getUItextWidth(str9,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
mgtrsf = (pospan(4)-p.mgpan-p.mg/2-6*p.mg/fact-5*hedit0-hpop0-3*htxt0)/2;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_VP_calcTransfo = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0,'horizontalalignment','left');

y = y-p.mg/fact-hedit0;

h.pushbutton_trMap = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@pushbutton_trMap_Callback,h_fig});

x = x+wbut0+p.mg/fact;

h.pushbutton_trLoadRef = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str2,'tooltipstring',ttstr1,'callback',...
    {@pushbutton_trLoadRef_Callback,h_fig});

x = x+wbut1+p.mg/fact;

h.edit_refCoord_file = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'enable','inactive','foregroundcolor',p.fntclr1);

x = p.mg;
y = y-p.mg/fact-hedit0;

h.popupmenu_trType = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hedit0],'string',str3,'tooltipstring',ttstr2,'callback',...
    {@popupmenu_trType_Callback,h_fig});

x = x+wpop0+p.mg/fact;

h.pushbutton_calcTfr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'string',str4,'tooltipstring',ttstr3,'callback',...
    {@pushbutton_calcTfr_Callback,h_fig});

x = p.mg;
y = y-mgtrsf-htxt0;

h.text_VP_transfFile = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str5,'horizontalalignment','left');

y = y-p.mg/fact-hedit0;

h.pushbutton_trLoad = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str2,'tooltipstring',ttstr4,'callback',...
    {@pushbutton_trLoad_Callback,h_fig});

x = x+wbut1+p.mg/fact;

h.edit_tr_file = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'enable','inactive','foregroundcolor',p.fntclr1);

x = pospan(3)-p.mg-wbut3;
y = y-p.mg/fact-hedit0;

h.pushbutton_checkTr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut3,hedit0],'string',str6,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_checkTr_Callback,h_fig});

x = p.mg;
y = y-mgtrsf-htxt0;

h.text_VP_coordFile = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str7,'horizontalalignment','left');

y = y-p.mg/fact-hedit0;

h.pushbutton_impCoord = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut1,hedit0],'string',str2,'tooltipstring',ttstr6,'callback',...
    {@pushbutton_impCoord_Callback,h_fig});

x = x+wbut1+p.mg/fact;

h.edit_coordFile = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'enable','inactive','foregroundcolor',p.fntclr1);

x = p.mg;
y = p.mg/2;

h.pushbutton_trOpt = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut4,hedit0],'string',str8,'tooltipstring',ttstr7,'callback',...
    {@pushbutton_trOpt_Callback,h_fig});

x = pospan(3)-p.mg-wbut5;

h.pushbutton_trGo = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut5,hedit0],'string',str9,'tooltipstring',ttstr8,'callback',...
    {@pushbutton_trGo_Callback,h_fig});


