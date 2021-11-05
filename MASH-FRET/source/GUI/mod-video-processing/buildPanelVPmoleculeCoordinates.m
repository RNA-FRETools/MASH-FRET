function h = buildPanelVPmoleculeCoordinates(h,p)
% h = buildPanelVPmoleculeCoordinates(h,p);
%
% Builds "Molecule coordinates" panel in module "Video processing" including panels "Average image", "Spotfinder" and "Coordinates transformation"
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
htxt0 = 14;
hpop0 = 20;
hedit0 = 20;
ttl2 = 'Average image:';
ttl0 = 'Spotfinder';
ttl1 = 'Coordinates transformation';

% parents
h_pan = h.uipanel_VP_moleculeCoordinates;

% dimensions
pospan = get(h_pan,'position');
wpan0 = pospan(3)-2*p.mg;
hpan0 = p.mgpan+htxt0+hedit0+p.mg;
hpan1 = p.mgpan+hpop0+p.mg/2+hpop0+p.mg/2+hedit0+p.mg/2+hedit0+p.mg;
hpan2 = p.mgpan+3*hedit0+3*p.mg/2+hedit0+p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hpan0;

h.uipanel_VP_averageImage = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],...
    'title',ttl2);
h = buildPanelVPaverageImage(h,p);

y = y-p.mg/2-hpan1;

h.uipanel_VP_spotfinder = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan1],...
    'title',ttl0);
h = buildPanelVPspotfinder(h,p);

y = y-p.mg/2-hpan2;

h.uipanel_VP_coordinatesTransformation = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpan0,hpan2],'title',ttl1);
h = buildPanelVPcoordinatesTransformation(h,p);
