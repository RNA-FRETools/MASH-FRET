function h = buildPanelVPmoleculeCoordinates(h,p)
% h = buildPanelVPmoleculeCoordinates(h,p);
%
% Builds "Molecule coordinates" panel in module "Video processing" including panels "Spotfinder" and "Coordinates transformation"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP_moleculeCoordinates: handle to the panel "Molecule coordinates"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr1: text color in file/folder fields
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hpop0 = 20;
hedit0 = 20;
htxt0 = 14;
fact = 5;
str0 = 'Average image:';
str1 = 'Go';
str2 = '...';
str3 = 'Exp';
ttl0 = 'Spotfinder';
ttl1 = 'Coordinates transformation';
ttstr0 = wrapHtmlTooltipString('<b>Frame interval</b> in the range of video frames to average (ex: 3 = average every third frames).');
ttstr1 = wrapHtmlTooltipString('<b>First video frame</b> in the range of video frames to average.');
ttstr2 = wrapHtmlTooltipString('<b>Last video frame</b> in the range of video frames to average.');
ttstr3 = wrapHtmlTooltipString('<b>Calculate and export</b> avergae image to file.');
ttstr4 = wrapHtmlTooltipString('Open browser and <b>select an average image file</b> to import for single moelcule localization.');
ttstr5 = wrapHtmlTooltipString('<b>Export average image</b> to a file.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_moleculeCoordinates;

% dimensions
pospan = get(h_pan,'position');
wtxt1 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wedit0 = (pospan(3)-p.mg-wtxt1-3*p.mg/fact-3*(p.mg/fact+wbut0)-p.mg)/3;
wpan0 = pospan(3)-2*p.mg;
hpan0 = p.mgpan+hpop0+p.mg/2+hpop0+p.mg/2+hedit0+p.mg/2+hedit0+p.mg;
hpan1 = p.mgpan+3*hedit0+3*p.mg/2+hedit0+p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0+(hedit0-htxt0)/2;

h.text_aveImg = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str0,'horizontalalignment','left');

y = y-(hedit0-htxt0)/2;
x = x+wtxt1+p.mg/fact;

h.edit_aveImg_iv = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_aveImg_iv_Callback,h_fig},'tooltipstring',ttstr0);

x = x+wedit0+p.mg/fact;

h.edit_aveImg_start = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_aveImg_start_Callback,h_fig},...
    'tooltipstring',ttstr1);

x = x+wedit0+p.mg/fact;

h.edit_aveImg_end = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_aveImg_end_Callback,h_fig},...
    'tooltipstring',ttstr2);

x = x+wedit0+p.mg/fact;

h.pushbutton_aveImg_go = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str1,'callback',...
    {@pushbutton_aveImg_go_Callback,h_fig},'tooltipstring',ttstr3);

x = x+wbut0+p.mg/fact;

h.pushbutton_aveImg_load = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str2,'callback',...
    {@pushbutton_aveImg_load_Callback,h_fig},'tooltipstring',ttstr4);

x = x+wbut0+p.mg/fact;

h.pushbutton_aveImg_save = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str3,'callback',...
    {@pushbutton_aveImg_save_Callback,h_fig},'tooltipstring',ttstr5);

x = p.mg;
y = y-p.mg/2-hpan0;

h.uipanel_VP_spotfinder = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],...
    'title',ttl0);
h = buildPanelVPspotfinder(h,p);

y = y-p.mg/2-hpan1;

h.uipanel_VP_coordinatesTransformation = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelVPcoordinatesTransformation(h,p);
