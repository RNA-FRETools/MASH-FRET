function h = buildPanelScrollHA(h,p)

% default
hpop0 = 22;
hedit0 = 20;
htxt0 = 14;
wedit0 = 40;
fact = 5;
fntsz2 = 10;
str5 = 'Gaussian fitting';
str6 = 'relative pop.:';
ttl0 = 'Histogram and plot';
ttl1 = 'State configuration';
ttl2 = 'State populations';

% parents
h_pan = h.uipanel_HA_scroll;

% dimensions
pospan = get(h_pan,'position');
wcb0 = getUItextWidth(str5,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbox;
wtxt0 = getUItextWidth(str6,p.fntun,p.fntsz1,'normal',p.tbl);
htxt1 = (fntsz2/p.fntsz1)*htxt0;
hpan0 = p.mgpan+htxt0+hedit0+p.mg/2+hedit0+p.mg;
hpan1 = p.mgpan+hedit0+p.mg+htxt0+(hpop0-hedit0)/2+hedit0+p.mg/fact+hedit0+p.mg+...
    htxt1+p.mg/2+htxt0+hpop0+p.mg;
hpan2_1 = p.mgpan+p.mg+p.mg/2+4*p.mg/fact+6*hedit0;
hpan2_2 = 2*p.mgpan+2*p.mg+3*p.mg/2+2*p.mg/fact+5*hedit0+hpop0+htxt0;
hpan2 = p.mgpan+p.mg+p.mg/2+hpan2_1+hpan2_2;
wpan0_1 = wcb0+2*p.mg;
wpan0_2 = 2*p.mg+2*p.mg/fact+2*wedit0+wtxt0;
wpan0 = 3*p.mg+wpan0_1+wpan0_2;

% GUI
x = 0;
y = pospan(4)-p.mg-hpan0;

h.uipanel_HA_histogramAndPlot = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelHAhistogramAndPlot(h,p);

y = y-p.mg-hpan1;

h.uipanel_HA_stateConfiguration = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelHAstateConfiguration(h,p);

y = y-p.mg-hpan2;

h.uipanel_HA_statePopulations = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan2],'title',ttl2);
h = buildPanelHAstatePopulations(h,p);

