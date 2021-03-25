function h = buildPanelSimExportOptions(h,p)
% h = buildPanelSimExportOptions(h,p);
%
% Builds "Export options" panel of module "Simulation"
% 
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_S_exportOptions: handle to the panel "Export options"
% p: structure containing default and often-used parameters (dimensions, margin etc.) with fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
htxt0 = 14;
hedit0 = 20;
hpop0 = 22;
str0 = 'Traces (*.mat)';
str1 = 'Video (*.sira)';
str2 = 'Video (*.avi)';
str3 = 'Ideal traces (ASCII)';
str4 = 'Dwell-times (ASCII)';
str5 = 'Simulation parameters';
str6 = 'Coordinates';
str7 = 'Exported intensity units';
str8 = {'photon counts','image counts'};
str9 = 'Update';
str10 = 'Export files';
ttstr0 = wrapHtmlTooltipString('Export one MATLAB binary file (.mat) that contains <b>intensity-time traces</b> and <b>coordinates</b> of all molecules.');
ttstr1 = wrapHtmlTooltipString('Export simulated <b>single molecule video</b> written in one binary MASH-FRET file.');
ttstr2 = wrapHtmlTooltipString('Export simulated <b>single molecule video</b> written in one uncompressed AVI file with RGB24 video.');
ttstr3 = wrapHtmlTooltipString('Export ASCII files that contain <b>intensity-time traces</b>, <b>coordinates</b>, <b>ideal photon count-time traces</b>, <b>calculated FRET-time traces</b>, <b>ideal FRET-time traces</b> and <b>state sequences</b> of individual molecules.');
ttstr4 = wrapHtmlTooltipString('Export ASCII files that contain the list of <b>dwell times</b> in individual FRET-time traces.');
ttstr5 = wrapHtmlTooltipString('Export one ASCII file containing the list of <b>parameters used in the simulation</b>.');
ttstr6 = wrapHtmlTooltipString('Export one ASCII file containing all <b>single molecule coordinates</b> used in the simulation.');
ttstr7 = wrapHtmlTooltipString('Select <b>intensity units</b> to export.');
ttstr8 = wrapHtmlTooltipString('<b>Refresh calculations</b> of intensities in traces and single molecule images.');
ttstr9 = wrapHtmlTooltipString('<b>Export simulated data</b> to selected files.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_S_exportOptions;

% dimensions
pospan = get(h_pan,'position');
wcb0 = pospan(3)-2*p.mg;
wbut0 = getUItextWidth(str9,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str10,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hedit0;

h.checkbox_traces = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str0,'callback',...
    {@checkbox_traces_Callback,h_fig},'tooltipstring',ttstr0);

y = y-hedit0;

h.checkbox_movie = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str1,'callback',...
    {@checkbox_movie_Callback,h_fig},'tooltipstring',ttstr1);

y = y-hedit0;

h.checkbox_avi = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str2,'callback',...
    {@checkbox_avi_Callback,h_fig},'tooltipstring',ttstr2);

y = y-hedit0;

h.checkbox_procTraces = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str3,'callback',...
    {@checkbox_procTraces_Callback,h_fig},'tooltipstring',ttstr3);

y = y-hedit0;

h.checkbox_dt = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str4,'callback',...
    {@checkbox_dt_Callback,h_fig},'tooltipstring',ttstr4);

y = y-hedit0;

h.checkbox_simParam = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str5,'callback',...
    {@checkbox_simParam_Callback,h_fig},'tooltipstring',ttstr5);

y = y-hedit0;

h.checkbox_expCoord = uicontrol('style','checkbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str6,'callback',...
    {@checkbox_expCoord_Callback,h_fig},'tooltipstring',ttstr6);

y = y-p.mg/2-htxt0;

h.text_simExpUnits = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,htxt0],'string',str7,'horizontalalignment','left');

y = y-hpop0;

h.popupmenu_opUnits = uicontrol('style','popupmenu','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hpop0],'string',str8,'callback',...
    {@popupmenu_opUnits_Callback,h_fig},'tooltipstring',ttstr7);

y = p.mg/2;

h.pushbutton_updateSim = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str9,'callback',...
    {@pushbutton_updateSim_Callback,h_fig},'tooltipstring',ttstr8);

x = pospan(3)-p.mg/2-wbut1;

h.pushbutton_exportSim = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hedit0],'string',str10,'callback',...
    {@pushbutton_exportSim_Callback,h_fig},'tooltipstring',ttstr9);

