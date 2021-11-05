function h = buildPanelVPintensityIntegration(h,p)
% h = buildPanelVPintensityIntegration(h,p);
%
% Builds "Intensity integration" panel in module "Video processing"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP_intensityIntegration: handle to the panel "Intensity integration"
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
wedit1 = 40;
file_icon0 = 'open_file.png';
str1 = 'Input coordinates:';
str2 = 'Import Options...';
str3 = 'Integrated pixels:';
str4 = char(10006);
ttstr0 = wrapHtmlTooltipString('Open browser and <b>select the coordinates file</b> that contains single moelcule coordinates in all channels.');
ttstr1 = wrapHtmlTooltipString('Open <b>import options</b> to configure coordinates import.');
ttstr2 = wrapHtmlTooltipString('<b>Integration area dimensions (in pixels)</b>: defines the size of the square area around the single molecule.');
ttstr3 = wrapHtmlTooltipString('<b>Number of brightest pixels</b> to sum up.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_intensityIntegration;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wbut1 = getUItextWidth(str2,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;

% images
pname = [fileparts(mfilename('fullpath')),filesep,'..',filesep];
img0 = imread([pname,file_icon0]);

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0+(hedit0-htxt0)/2;

h.text_VP_checkCoordsm = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz0,'fontweight','bold',...
    'foregroundcolor',p.fntclr3,'position',[x,y,wtxt1,htxt0],'string',...
    str4);

x = x+wtxt1;

h.text_TTgen_coord = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str1,'horizontalalignment','left');

x = x+wtxt0+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.pushbutton_TTgen_loadCoord = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,p.wbut1,hedit0],'tooltipstring',ttstr0,'cdata',img0,...
    'callback',{@pushbutton_TTgen_loadCoord_Callback,h_fig});

x = x+p.wbut1+p.mg/fact;

h.pushbutton_TTgen_loadOpt = uicontrol('style','pushbutton','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wbut1,hedit0],'string',str2,'tooltipstring',ttstr1,...
    'callback',{@pushbutton_TTgen_loadOpt_Callback,h_fig});

x = p.mg+wtxt1;
y = y-p.mg/2-hedit0+(hedit0-htxt0)/2;

h.text_intg = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str3,'horizontalalignment','left');

x = x+wtxt0+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.edit_TTgen_dim = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'tooltipstring',ttstr2,'callback',{@edit_TTgen_dim_Callback,h_fig});

x = x+wedit1+p.mg/fact;

h.edit_intNpix = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit1,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_intNpix_Callback,h_fig});

