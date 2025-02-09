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
%   p.fntclr1: text color in file/folder fields
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
fact = 5;
file_icon0 = 'view.png';
file_icon1 = 'save_file.png';
file_icon2 = 'open_file.png';
str0 = 'Spots coordinates:';
str2 = 'Transform';
str4 = 'Transformation:';
str5 = 'Calc.';
str7 = 'Reference coord.:';
str8 = 'Map';
str9 = 'Import options...';
str10 = char(10006);
ttstr0 = wrapHtmlTooltipString('<b>Export mapped coordinates</b> to a file.');
ttstr1 = wrapHtmlTooltipString('Import the <b>reference coordinates file</b> used to calculate channel transformation.');
ttstr2 = wrapHtmlTooltipString('<b>Calculate transformation</b> from reference coordinates.');
ttstr3 = wrapHtmlTooltipString('<b>Export transformation</b> to a file.');
ttstr4 = wrapHtmlTooltipString('Import the <b>transformation file</b>.');
ttstr5 = wrapHtmlTooltipString('Check the <b>channel transformation quality</b> on a reference image.');
ttstr6 = wrapHtmlTooltipString('<b>Export transformed coordinates</b> to a file.');
ttstr7 = wrapHtmlTooltipString('Open <b>import options</b> to configure how coordinates are imported from the reference and spots coordinate files.');
ttstr8 = wrapHtmlTooltipString('<b>Transform</b> coordinates');
ttstr9 = wrapHtmlTooltipString('Import the <b>coordinates file</b> to be transformed.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_coordinatesTransformation;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt2 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt3 = max([wtxt0,wtxt1,wtxt2]);
wtxt4 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut2 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut4 = getUItextWidth(str9,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut5 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% images
pname = [fileparts(mfilename('fullpath')),filesep,'..',filesep];
img0 = imread([pname,file_icon0]);
img1 = imread([pname,file_icon1]);
img2 = imread([pname,file_icon2]);

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0+(hedit0-htxt0)/2;

h.text_VP_checkCoord2tr = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz0,'fontweight','bold',...
    'foregroundcolor',p.fntclr3,'position',[x,y,wtxt4,htxt0],'string',...
    str10);

x = x+wtxt4;

h.text_VP_coordFile = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt3,htxt0],'string',str0,'horizontalalignment','right');

x = x+wtxt3;
y = y-(hedit0-htxt0)/2;

h.pushbutton_impCoord = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr9,'cdata',img2,'callback',...
    {@pushbutton_impCoord_Callback,h_fig});

x = x+p.wbut1+p.mg/fact;

h.pushbutton_trGo = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut5,hedit0],'string',str2,'tooltipstring',ttstr8,'callback',...
    {@pushbutton_trGo_Callback,h_fig});

x = pospan(3)-p.mg-p.wbut1;

h.pushbutton_expTrsfCoord = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr6,'cdata',img1,'callback',...
    {@pushbutton_expTrsfCoord_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-hedit0+(hedit0-htxt0)/2;

h.text_VP_checkTrsf = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz0,'fontweight','bold',...
    'foregroundcolor',p.fntclr3,'position',[x,y,wtxt4,htxt0],'string',...
    str10);

x = x+wtxt4;

h.text_VP_transfFile = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt3,htxt0],'string',str4,'horizontalalignment','right');

x = x+wtxt3;
y = y-(hedit0-htxt0)/2;

h.pushbutton_trLoad = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr4,'cdata',img2,'callback',...
    {@pushbutton_trLoad_Callback,h_fig});

x = x+p.wbut1+p.mg/fact;

h.pushbutton_calcTfr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'string',str5,'tooltipstring',ttstr2,'callback',...
    {@pushbutton_calcTfr_Callback,h_fig});

x = x+wbut2+p.mg/fact;

h.pushbutton_checkTr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr5,'cdata',img0,'callback',...
    {@pushbutton_checkTr_Callback,h_fig});

x = pospan(3)-p.mg-p.wbut1;

h.pushbutton_saveTfr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr3,'cdata',img1,'callback',...
    {@pushbutton_saveTfr_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-hedit0+(hedit0-htxt0)/2;

h.text_VP_checkCoordref = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz0,'fontweight','bold',...
    'foregroundcolor',p.fntclr3,'position',[x,y,wtxt4,htxt0],'string',...
    str10);

x = x+wtxt4;

h.text_VP_calcTransfo = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt3,htxt0],'string',str7,'horizontalalignment','right');

x = x+wtxt3;
y = y-(hedit0-htxt0)/2;

h.pushbutton_trLoadRef = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr1,'cdata',img2,'callback',...
    {@pushbutton_trLoadRef_Callback,h_fig});

x = x+p.wbut1+p.mg/fact;

h.pushbutton_trMap = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str8,'tooltipstring',ttstr0,'callback',...
    {@pushbutton_trMap_Callback,h_fig});

x = pospan(3)-p.mg-p.wbut1;

h.pushbutton_trSaveRef = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'tooltipstring',ttstr0,'cdata',img1,'callback',...
    {@pushbutton_trSaveRef_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-hedit0;

h.pushbutton_trOpt = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut4,hedit0],'string',str9,'tooltipstring',ttstr7,'callback',...
    {@pushbutton_trOpt_Callback,h_fig});

