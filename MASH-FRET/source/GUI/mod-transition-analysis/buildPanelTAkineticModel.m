function h = buildPanelTAkineticModel(h,p)
% h = buildPanelTAkineticModel(h,p)
%
% Builds panel "Kinetic model" in "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_kineticModel: handle to panel "Kinetic model"

% defaults
htxt0 = 14;
hbut0 = 20;
hpop0 = 22;
hedit0 = 20;
ttl0 = 'State degeneracy';
ttl1 = 'Transition rate constants';

% parent
h_pan = h.uipanel_TA_kineticModel;

% dimensions
pospan = get(h_pan,'position');
hpan0 = p.mgpan+htxt0+hpop0+p.mg/2+hbut0+p.mg+htxt0+hpop0+p.mg/2+htxt0+...
    hpop0+p.mg/2+htxt0+hpop0+p.mg;
hpan1 = p.mgpan+htxt0+hedit0+(hbut0-hedit0)/2+p.mg;
wpan0 = pospan(3)-2*p.mg;

x = p.mg;
y = pospan(4)-p.mgpan-hpan0;

h.uipanel_TA_stateDegeneracy = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelTAstateDegeneracy(h,p);

y = y-p.mg/2-hpan1;

h.uipanel_TA_transitionRateConstants = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelTAtransitionRateConstants(h,p);

