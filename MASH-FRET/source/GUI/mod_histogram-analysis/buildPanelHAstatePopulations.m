function h = buildPanelHAstatePopulations(h,p)
% h = buildPanelHAstatePopulations(h,p)
%
% Builds "State populations" panel in module "Histogram analysis" including panels "Method", "Thresholding" and "Gaussian fitting"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_HA_statePopulations: handle to panel "State populations"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.wttsr: pixel width of tooltip box
%   p.tbl: reference table listing character pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% Created by MH, 3.11.2019

% default
hedit0 = 20;
wedit0 = 40;
fact = 5;
str0 = 'Gaussian fitting';
str1 = 'relative pop.:';
ttl0 = 'Method';
ttl1 = 'Thresholding';
ttl2 = 'Gaussian fitting';

% parent
h_pan = h.uipanel_HA_statePopulations;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpan0 = wcb0+2*p.mg;
hpan0 = p.mgpan+p.mg+4*p.mg/fact+p.mg/2+6*hedit0;
wtxt0 = getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl);
wpan1 = 2*p.mg+2*p.mg/fact+2*wedit0+wtxt0;
wpan2 = wpan0+wpan1+p.mg;
hpan1 = pospan(4)-p.mgpan-p.mg-p.mg/2-hpan0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hpan0;

h.uipanel_HA_method = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelHAmethod(h,p);

x = x+wpan0+p.mg;

h.uipanel_HA_thresholding = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan1,hpan0],...
    'title',ttl1);
h = buildPanelHAthresholding(h,p);

x = p.mg;
y = p.mg;

h.uipanel_HA_gaussianFitting = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpan2,hpan1],...
    'title',ttl2);
h = buildPanelHAgaussianFitting(h,p);


