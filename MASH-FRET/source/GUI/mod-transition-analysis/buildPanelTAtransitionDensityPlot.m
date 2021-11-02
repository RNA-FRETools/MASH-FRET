function h = buildPanelTAtransitionDensityPlot(h,p)
% h = buildPanelTAtransitionDensityPlot(h,p);
%
% Builds panel "Transition density plot" in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_transitionDensityPlot: handle to panel "Transition density plot"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% Created by MH, 8.11.2019

% defaults
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
fact = 5;
str4 = 'min';
str5 = 'binning';
str6 = 'max';
str7 = 'Include statics';
str8 = 'Single count per mol.';
str9 = 'Re-arrange sequences';
str10 = 'Gaussian filter';
str11 = 'Norm.';
str12 = 'Update';
str13 = 'Colormap:';
str14 = {'parula','turbo','hsv','hot','cool','spring','summer','autumn',...
    'winter','gray','bone','copper','pink','jet','lines','colorcube',...
    'prism','flag','white'};
ttstr2 = wrapHtmlTooltipString('<b>TDP boundaries:</b> lower limit of TDP.');
ttstr3 = wrapHtmlTooltipString('<b>TDP binning:</b> bin size of TDP.');
ttstr4 = wrapHtmlTooltipString('<b>TDP boundaries:</b> upper limit of TDP.');
ttstr5 = wrapHtmlTooltipString('<b>Show last states:</b> last state of each sequence is sorted and included in diagonal TDP bins.');
ttstr6 = wrapHtmlTooltipString('<b>Transition count:</b> when activated, transitions appearing multiple times in the same trajectories are counted as a single count, otherwise each apperance in the trajectory counts as one; single transition count allows to scale equally the rapid and slow state interconversions in the TDP (modified TDP is used for clustering only).');
ttstr7 = wrapHtmlTooltipString('<b>Re-arrange sequences:</b> when activated, state sequences are re-built to contain transitions visible in the TDP only; out-of-TDP-range transitions are deleted from state sequences and durations of states prior these transitions are elongated (modified state sequences are used in dwell time histograms).');
ttstr8 = wrapHtmlTooltipString('<b>Gaussian filter:</b> when activated, the TDP is convoluted with a 2D Gaussian, otherwise the initial transition probability distribution is used; Gaussian convolution eases the identification of transition clusters (modified TDP is used for clustering only)');
ttstr9 = wrapHtmlTooltipString('<b>Normalized counts:</b> when activated, the TDP is displayed in counts normalized by the sum.');
ttstr10 = wrapHtmlTooltipString('<b>Refresh TDP:</b> the TDP is rebuilt according to current processing settings.');
ttstr11 = wrapHtmlTooltipString('<b>Select a colormap:</b> define the color scale that maps transition counts.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_transitionDensityPlot;

% dimensions
pospan = get(h_pan,'position');
wedit0 = (pospan(3)-2*p.mg-2*p.mg/fact)/3;
wcb0 = pospan(3)-2*p.mg;
wbut0 = getUItextWidth(str12,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wcb1 = pospan(3)-2*p.mg-p.mg/fact-wbut0;
wtxt0 = getUItextWidth(str13,p.fntun,p.fntsz1,'normal',p.tbl);
wpop0 = pospan(3)-p.mg-wtxt0-p.mg;

% GUI
y = pospan(4)-p.mgpan-htxt0;
x = p.mg;

h.text_TDPmin = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str4);

x = x+wedit0+p.mg/fact;

h.text_TDPbin = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str5);

x = x+wedit0+p.mg/fact;

h.text_TDPmax = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,htxt0],...
    'string',str6);

x = p.mg;
y = y-hedit0;

h.edit_TDPmin = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr2,'callback',{@edit_TDPmin_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TDPbin = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr3,'callback',{@edit_TDPbin_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TDPmax = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'tooltipstring',ttstr4,'callback',{@edit_TDPmax_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-hedit0;

h.checkbox_TDP_statics = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str7,'tooltipstring',ttstr5,'callback',...
    {@checkbox_TDP_statics_Callback,h_fig});

y = y-hedit0;

h.checkbox_TDP_onecount = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str8,'tooltipstring',ttstr6,'callback',...
    {@checkbox_TDP_onecount_Callback,h_fig});

y = y-hedit0;

h.checkbox_TDPignore = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str9,'tooltipstring',ttstr7,'callback',...
    {@checkbox_TDPignore_Callback,h_fig});

y = y-hedit0;

h.checkbox_TDPgconv = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str10,'tooltipstring',ttstr8,'callback',...
    {@checkbox_TDPgconv_Callback,h_fig});

y = y-hedit0;

h.checkbox_TDPnorm = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb1,hedit0],'string',str11,'tooltipstring',ttstr9,'callback',...
    {@checkbox_TDPnorm_Callback,h_fig});

x = x+wcb1+p.mg/fact;

h.pushbutton_TDPupdatePlot = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str12,'tooltipstring',ttstr10,'callback',...
    {@pushbutton_TDPupdatePlot_Callback,h_fig});

x = p.mg;
y = p.mg/2+(hpop0-htxt0)/2;

h.text_TDPcmap = uicontrol('style','text','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wtxt0,htxt0],...
    'string',str13,'horizontalalignment','left');

x = x+wtxt0+p.mg/fact;
y = y-(hpop0-htxt0)/2;

h.popupmenu_TDPcmap = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str14,'tooltipstring',ttstr11,'callback',...
    {@popupmenu_TDPcmap_Callback,h_fig});
