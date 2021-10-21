function h = buildPanelVPplot(h,p)
% h = buildPanelVPplot(h,p);
%
% Builds "Plot" panel in "Video processing" module
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP_plot: handle to the panel "Plot"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
str0 = 'Units per s.';
str1 = 'colormap:';
str2 = {'parula','turbo','hsv','hot','cool','spring','summer','autumn',...
    'winter','gray','bone','copper','pink','jet','lines','colorcube',...
    'prism','flag','white'};
ttstr0 = wrapHtmlTooltipString('<b>Intensity units:</b> image counts per time bin or per second (affects displayed intensities in the visualization area, displayed intensities when using the "create trace" cursor and intensity parameters used in Spotfinder).');
ttstr1 = wrapHtmlTooltipString('<b>Select a colormap:</b> color scale for pixel intensities.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_VP_plot;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wtxt0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl);
wpop0 = pospan(3)-p.mg/2-wcb0-p.mg-wtxt0-p.mg/2;

% GUI
x = p.mg/2;
y = pospan(4)-p.mgpan-hpop0+(hpop0-hedit0)/2;

h.checkbox_int_ps = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str0,'callback',...
    {@checkbox_int_ps_Callback,h_fig},'tooltipstring',ttstr0);

y = y+(hedit0-htxt0)/2;
x = x+wcb0+p.mg;

h.text_VP_cmap = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str1);

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

h.popupmenu_colorMap = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str2,'callback',...
    {@popupmenu_colorMap_Callback,h_fig},'tooltipstring',ttstr1);


