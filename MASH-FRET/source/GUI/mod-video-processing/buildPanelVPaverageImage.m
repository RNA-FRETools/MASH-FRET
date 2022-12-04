function h = buildPanelVPaverageImage(h,p)
% h = buildPanelVPaverageImage(h,p);
%
% Builds "Average image" panel in module "Video processing"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP_averageImage: handle to the panel "Average Image"
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
hedit0 = 20;
htxt0 = 14;
fact = 5;
file_icon0 = 'save_file.png';
file_icon1 = 'open_file.png';
str0 = 'intv';
str1 = 'start';
str2 = 'stop';
str3 = 'Calc.';
ttstr0 = wrapHtmlTooltipString('<b>Frame interval</b> in the range of video frames to average (ex: 3 = average every third frames).');
ttstr1 = wrapHtmlTooltipString('<b>First video frame</b> in the range of video frames to average.');
ttstr2 = wrapHtmlTooltipString('<b>Last video frame</b> in the range of video frames to average.');
ttstr3 = wrapHtmlTooltipString('<b>Calculate average image</b>.');
ttstr4 = wrapHtmlTooltipString('Import an <b>average image file</b>.');
ttstr5 = wrapHtmlTooltipString('<b>Export average image</b> to a file.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_averageImage;

% dimensions
pospan = get(h_pan,'position');
wbut0 = getUItextWidth(str3,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wedit0 = (pospan(3)-p.mg-2*p.mg/fact-p.mg/fact-wbut0-p.mg/fact-p.wbut1-...
    p.mg/fact-p.wbut1-p.mg)/3;

% images
pname = [fileparts(mfilename('fullpath')),filesep,'..',filesep];
img0 = imread([pname,file_icon0]);
img1 = imread([pname,file_icon1]);

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_aveImg_iv = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str0);

y = y-hedit0;

h.edit_aveImg_iv = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_aveImg_iv_Callback,h_fig},'tooltipstring',ttstr0);

x = x+wedit0+p.mg/fact;
y = y+hedit0;

h.text_aveImg_start = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str1);

y = y-hedit0;

h.edit_aveImg_start = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_aveImg_start_Callback,h_fig},...
    'tooltipstring',ttstr1);

x = x+wedit0+p.mg/fact;
y = y+hedit0;

h.text_aveImg_end = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str2);

y = y-hedit0;

h.edit_aveImg_end = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_aveImg_end_Callback,h_fig},...
    'tooltipstring',ttstr2);

x = x+wedit0+p.mg/fact;

h.pushbutton_aveImg_go = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str3,'callback',...
    {@pushbutton_aveImg_go_Callback,h_fig},'tooltipstring',ttstr3);

x = x+wbut0+p.mg/fact;

h.pushbutton_aveImg_load = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'cdata',img1,'tooltipstring',ttstr4,'callback',...
    {@pushbutton_aveImg_load_Callback,h_fig});

x = x+p.wbut1+p.mg/fact;

h.pushbutton_aveImg_save = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,p.wbut1,hedit0],'cdata',img0,'tooltipstring',ttstr5,'callback',...
    {@pushbutton_aveImg_save_Callback,h_fig});
