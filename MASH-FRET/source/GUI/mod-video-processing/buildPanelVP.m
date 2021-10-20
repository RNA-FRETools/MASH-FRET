function h = buildPanelVP(h,p)
% h = buildPanelVP(h,p);
%
% Builds module "Video processing" including panels "Edit video", "Coordinates" and "Intensity integration".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_VP: handle to the panel containing "Video processing" module
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr1: text color in file/folder fields
%   p.wbuth: pixel width of help buttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
hsld0 = 20;
fact = 5;
ttl1 = 'Edit and export video';
ttl2 = 'Molecule coordinates';
ttl3 = 'Intensity integration';
tabttl0 = 'Video';
tabttl1 = 'Average image';

% parents
h_pan = h.uipanel_VP;

% dimensions
pospan = get(h_pan,'position');
htab = pospan(4)-2*p.mg;
wtab = htab-hedit0-2*p.mg-hsld0-p.mg-htxt0;
wpan0 = pospan(3)-3*p.mg-wtab;
hpan0 = p.mgpan+p.mg/2+p.mg/fact+hedit0+hpop0;
hpan1 = p.mgpan+hpop0+hedit0+p.mg/2+hpop0+p.mg/fact+hedit0+p.mg/2+hedit0+...
    p.mg/2;
hpan3 = p.mgpan+3*(p.mg/2+hedit0);
hpan2 = pospan(4)-2*p.mg-3*p.mg/2-hpan0-hpan1-hpan3;

% GUI
x = p.mg;
y = p.mg;

h.uitabgroup_VP_plot = uitabgroup('parent',h_pan,'units',p.posun,...
    'position',[x,y,wtab,htab]);
h_tabgrp = h.uitabgroup_VP_plot;

h.uitab_VP_plot_vid = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl0);
h = buildVPtabPlotVid(h,p);

h.uitab_VP_plot_avimg = uitab('parent',h_tabgrp,'units',p.posun,'title',...
    tabttl1);
h = buildVPtabPlotAvimg(h,p);

x = x+wtab+p.mg;
y = pospan(4)-p.mg-hpan1;

h.uipanel_VP_editAndExportVideo = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelVPeditAndExportVideo(h,p);

y = y-p.mg/2-hpan2;

h.uipanel_VP_moleculeCoordinates = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan2],'title',ttl2);
h = buildPanelVPmoleculeCoordinates(h,p);

y = y-p.mg/2-hpan3;

h.uipanel_VP_intensityIntegration = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan3],'title',ttl3);
h = buildPanelVPintensityIntegration(h,p);

