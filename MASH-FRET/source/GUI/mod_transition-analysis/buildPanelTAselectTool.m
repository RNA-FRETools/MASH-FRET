function h = buildPanelTAselectTool(h,p)
% h = buildPanelTAselectTool(h,p);
%
% Builds title-less panel for tool selection in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_selectTool: handle to title-less panel for tool selection
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% Created by MH, 24.1.2020

% defaults
hedit0 = 20;
fact = 5;
file_icon1 = 'icon_square.png';
file_icon2 = 'icon_ellips_straight.png';
file_icon3 = 'icon_ellips_diagonal.png';
file_icon4 = 'icon_clear.png';
file_icon5 = 'icon_mouse.png';
str0 = char(9668);
ttstr0 = wrapStrToWidth('<b>Selection tool:</b> square-shaped',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('<b>Selection tool:</b> straight elipsoid-shaped',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Selection tool:</b> diagonal elipsoid-shaped',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('Reset selection',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('Deactivate selection tool',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('Close',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_selectTool;

% dimensions
wbut0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% images
img1 = imread(file_icon1);
img2 = imread(file_icon2);
img3 = imread(file_icon3);
img4 = imread(file_icon4);
img5 = imread(file_icon5);

% GUI
x = p.mg/2;
y = p.mg/2;

h.tooglebutton_TDPselectSquare = uicontrol('style','togglebutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,hedit0,hedit0],'tooltipstring',ttstr0,'callback',...
    {@tooglebutton_TDPselect_Callback,h_fig,1},'cdata',img1);

x = x+hedit0+p.mg/fact;

h.tooglebutton_TDPselectElStr = uicontrol('style','togglebutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,hedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@tooglebutton_TDPselect_Callback,h_fig,2},'cdata',img2);

x = x+hedit0+p.mg/fact;

h.tooglebutton_TDPselectElDiag = uicontrol('style','togglebutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,hedit0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@tooglebutton_TDPselect_Callback,h_fig,3},'cdata',img3);

x = x+hedit0+p.mg/fact;

h.pushbutton_TDPselectClear = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,hedit0,hedit0],'tooltipstring',ttstr3,'callback',...
    {@tooglebutton_TDPselect_Callback,h_fig,4},'cdata',img4);

x = x+hedit0+p.mg/fact;

h.pushbutton_TDPselectMouse = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,hedit0,hedit0],'tooltipstring',ttstr4,'callback',...
    {@tooglebutton_TDPselect_Callback,h_fig,5},'cdata',img5);

x = x+hedit0+p.mg/2;

h.pushbutton_TDPmanStart = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut0,hedit0],'string',str0,'tooltipstring',ttstr5,...
    'callback',{@tooglebutton_TDPmanStart_Callback,h_fig,'close'});


