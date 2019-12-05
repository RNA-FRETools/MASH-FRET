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
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

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
str6 = 'int.units /';
str7 = 's';
str8 = 'pixel';
str9 = 'x-axis';
str10 = 'start';
str11 = 'in s.';
ttstr0 = wrapStrToWidth('Select a <b>laser wavelength</b> to show intensity-time traces from, in the top plot.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('Select an <b>emission channel</b> to show ntensity-time traces from, in the top plot.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('Select the <b>ratio-time traces</b> to show in the bottom plot.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('<b>Intensity units</b>: when activated, intensities are given in counts <b>per second</b>, otherwise in counts <b>per time bin (frame)</b>; this affects the top plot, background intensities and threshold intensities used in panels "Photobleaching" and "Find states".',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Intensity units</b>: when activated, pixel intensities are averaged over the number of integrated pixels and given in counts <b>per pixel</b>, otherwise pixel intensities are summed and given in simple counts; this affects the top plot, background intensities and threshold intensities used in panels "Photobleaching" and "Find states".',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('<b>Clip</b> traces of <b>all molecules</b> to the defined starting point: data points below this frame will be ignored.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('<b>Time units</b>: when activated, times are given in <b>seconds</b>, otherwise in <b>time bin (frames)</b>; this affects the starting point, the plots, and the cutoff values used in panels "Factor corrections" (gamma factor settings) and "Photobleaching".',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr7 = wrapStrToWidth('<b>Starting point</b> in time traces: data points below this frame will be ignored.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_plot;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = (pospan(3)-2*p.mg-p.mg/fact)/2;
wtxt1 = pospan(3)-2*p.mg;
wtxt2 = getUItextWidth(str6,p.fntun,p.fntsz1,'bold',p.tbl);
wtxt3 = getUItextWidth(str9,p.fntun,p.fntsz1,'bold',p.tbl);
wcb0 = getUItextWidth(str7,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wcb1 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
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

y = y-p.mg-hedit0+(hedit0-htxt0)/2;

h.text_TP_intUnits = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wtxt2,htxt0],'string',str6,'horizontalalignment',...
    'left');

x = x+wtxt2+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.checkbox_ttPerSec = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str7,'tooltipstring',ttstr3,'callback',...
    {@checkbox_ttPerSec_Callback,h_fig});

x = x+wcb0+p.mg/fact;

h.checkbox_ttAveInt = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb1,hedit0],'string',str8,'tooltipstring',ttstr4,'callback',...
    {@checkbox_ttAveInt_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-hedit0+(hedit0-htxt0)/2;

h.text_TP_xaxis = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wtxt3,htxt0],'string',str9,'horizontalalignment','left');

x = x+wtxt3+p.mg/fact;
y = y-(hedit0-htxt0)/2;

h.checkbox_photobl_fixStart = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb2,hedit0],'string',str10,'tooltipstring',ttstr5,'callback',...
    {@checkbox_photobl_fixStart_Callback,h_fig});

y = y-p.mg/fact-hedit0;

h.checkbox_photobl_insec = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb2,hedit0],'string',str11,'tooltipstring',ttstr6,'callback',...
    {@checkbox_photobl_insec_Callback,h_fig});

x = x+wcb2+p.mg/fact;
y = y+p.mg/fact+hedit0;

h.edit_photobl_start = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_photobl_start_Callback,h_fig},...
    'tooltipstring',ttstr7);

