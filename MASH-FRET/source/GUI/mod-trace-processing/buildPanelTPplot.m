function h = buildPanelTPplot(h,p)
% h = buildPanelTPplot(h,p);
%
% Builds "Plot" panel in "Trace processing" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_plot: handle to the panel "Plot"
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
htxt0 = 13;
hpop0 = 22;
fact = 5;
str0 = 'top laser';
str1 = 'top data';
str2 = {'Select a laser'};
str3 = {'Select a channel'};
str4 = 'bottom data';
str5 = {'Select a trace'};
str9 = 'x-axis:';
str10 = 'hold start';
ttstr0 = wrapHtmlTooltipString('Select a <b>laser wavelength</b> to show intensity-time traces from, in the top plot.');
ttstr1 = wrapHtmlTooltipString('Select an <b>emission channel</b> to show ntensity-time traces from, in the top plot.');
ttstr2 = wrapHtmlTooltipString('Select the <b>ratio-time traces</b> to show in the bottom plot.');
ttstr5 = wrapHtmlTooltipString('<b>Clip</b> traces of <b>all molecules</b> to the defined starting point: data points below this frame will be ignored.');
ttstr7 = wrapHtmlTooltipString('<b>Starting point</b> in time traces: data points below this frame will be ignored.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_plot;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = (pospan(3)-2*p.mg-p.mg/fact)/2;
wtxt1 = pospan(3)-2*p.mg;
wtxt3 = getUItextWidth(str9,p.fntun,p.fntsz1,'bold',p.tbl);
wcb2 = getUItextWidth(str10,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wedit0 = pospan(3)-2*p.mg-2*p.mg/fact-wcb2-wtxt3;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TP_ttPlotExc = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0);

x = x+wtxt0+p.mg/fact;

h.text_topAxes = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str1);

x = p.mg;
y = y-hpop0;

h.popupmenu_ttPlotExc = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'string',str2,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_ttPlotExc_Callback,h_fig});

x = x+wtxt0+p.mg/fact;

h.popupmenu_plotTop = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,hpop0],'string',str3,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_plotTop_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-htxt0;

h.text_plotBottom = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt1,htxt0],...
    'string',str4);

y = y-hpop0;

h.popupmenu_plotBottom = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,hpop0],'string',str5,'tooltipstring',ttstr2,'callback',...
    {@popupmenu_plotBottom_Callback,h_fig});

x = p.mg;
y = y-p.mg-hedit0+(hedit0-htxt0)/2;

h.text_TP_xaxis = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wtxt3,htxt0],'string',str9,'horizontalalignment','left');

x = x+wtxt3+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.checkbox_photobl_fixStart = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb2,hedit0],'string',str10,'tooltipstring',ttstr5,'callback',...
    {@checkbox_photobl_fixStart_Callback,h_fig});

x = x+wcb2+p.mg/fact;

h.edit_photobl_start = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_photobl_start_Callback,h_fig},...
    'tooltipstring',ttstr7);

