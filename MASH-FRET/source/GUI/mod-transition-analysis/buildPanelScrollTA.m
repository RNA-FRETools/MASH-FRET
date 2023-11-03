function h = buildPanelScrollTA(h,p)

% default
hpop0 = 22;
hbut0 = 20;
hedit0 = 20;
htxt0 = 14;
wedit0 = 40;
fact = 5;
str4 = 'diagonal';
ttl0 = 'Transition density plot';
ttl1 = 'State configuration';
ttl2 = 'Dwell time histograms';
ttl3 = 'Kinetic model';

% parents
h_pan = h.uipanel_TA_scroll;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wpan0a = p.mg+wcb0+p.mg/fact+wcb0+p.mg;
wpan0 = p.mg+wedit0+p.mg/2+wedit0+p.mg+wpan0a+p.mg;
hpan0 = p.mgpan+htxt0+hedit0+p.mg/2+5*hedit0+p.mg/2+hpop0+p.mg/2;
hpan1a = p.mgpan+hpop0+p.mg/2+htxt0+hpop0+p.mg/fact+hedit0+p.mg/2+...
    hedit0+p.mg/2+hedit0+p.mg;
hpan1b = p.mgpan+htxt0+hpop0+p.mg/2+hbut0+p.mg;
hpan1 = p.mgpan+hpan1a+p.mg+hpan1b+p.mg;
hpan2a = p.mgpan+htxt0+hpop0+p.mg/2+htxt0+hpop0+p.mg;
hpan2 = p.mgpan+htxt0+hedit0+hedit0/2+p.mg/2+htxt0+hpop0+p.mg/2+hbut0+...
    p.mg/2+hpan2a+p.mg;
hpan3a = p.mgpan+htxt0+hpop0+p.mg/2+hbut0+p.mg+htxt0+hpop0+p.mg/2+htxt0+...
    hpop0+p.mg/2+htxt0+hpop0+p.mg;
hpan3b = p.mgpan+htxt0+hedit0+(hbut0-hedit0)/2+p.mg;
hpan3 = p.mgpan+hpan3a+p.mg/2+hpan3b+p.mg;

% GUI
x = 0;
y = pospan(4)-p.mg-hpan0;

h.uipanel_TA_transitionDensityPlot = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelTAtransitionDensityPlot(h,p);

y = y-p.mg-hpan1;

h.uipanel_TA_stateConfiguration = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelTAstateConfiguration(h,p);

y = y-p.mg-hpan2;

h.uipanel_TA_dtHistograms = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan2],'title',ttl2);
h = buildPanelTAdtHistograms(h,p);

y = y-p.mg-hpan3;

h.uipanel_TA_kineticModel = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan3],'title',ttl3);
h = buildPanelTAkineticModel(h,p);

