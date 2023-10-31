function h = buildPanelScrollSim(h,p)

% default
fact = 5;
htxt0 = 14;
hedit0 = 20;
hpop0 = 22;
wedit0 = 40;
str0 = 'nb. of states (J)';
ttl0 = 'Video parameters';
ttl1 = 'Molecules';
ttl2 = 'Experimental setup';
ttl3 = 'Export options';

% parents
h_pan = h.uipanel_S_scroll;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wspan0 = p.mg+wtxt0+wedit0+p.mg/2+wedit0+p.mg/fact+wedit0+p.mg/fact+wedit0+...
    p.mg;
wpan0 = 2*p.mg+wspan0;
hspan0 = p.mgpan+hpop0+p.mg/2+hedit0+p.mg/fact+hedit0+p.mg/fact+hedit0+...
    p.mg/2;
hpan0 = p.mgpan+htxt0+hedit0+p.mg/2+htxt0+hedit0+p.mg/2+hspan0+p.mg/2;
hspan1 = p.mgpan+htxt0+hpop0+p.mg/2+htxt0+5*(1+hedit0)+htxt0+p.mg/2;
hspan2 = p.mgpan+htxt0+hedit0+p.mg/fact+hedit0+p.mg/2+htxt0+hedit0+p.mg/2+...
    hedit0+p.mg/2;
hpan1 = p.mgpan+hedit0+p.mg/fact+hedit0+p.mg+hedit0+p.mg/2+hspan1+p.mg/2+...
    hspan2+p.mg/2;
hspan3 = p.mgpan+hpop0+p.mg/2+htxt0+hedit0+p.mg/2+htxt0+hedit0+p.mg/2;
hpan2 = p.mgpan+htxt0+hedit0+p.mg/2+htxt0+hedit0+p.mg/2+hspan3+p.mg;
hpan3 = p.mgpan+7*hedit0+p.mg/2+hedit0+hpop0+p.mg/2;

% builds GUI
x = 0;
y = pospan(4)-p.mg/2-hpan0;

h.uipanel_S_videoParameters = uipanel('parent',h_pan,'title',ttl0,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan0,hpan0]);
h = buildPanelSimVideoParametes(h,p);

y = y-p.mg-hpan1;

h.uipanel_S_molecules = uipanel('parent',h_pan,'title',ttl1,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan0,hpan1]);
h = buildPanelSimMolecules(h,p);

y = y-p.mg-hpan2;

h.uipanel_S_experimentalSetup = uipanel('parent',h_pan,'title',ttl2,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wpan0,hpan2]);
h = buildPanelSimExperimentalSetup(h,p);

y = y-p.mg-hpan3;

h.uipanel_S_exportOptions = uipanel('parent',h_pan,'title',ttl3,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan0,hpan3]);
h = buildPanelSimExportOptions(h,p);
