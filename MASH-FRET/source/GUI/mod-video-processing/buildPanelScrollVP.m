function h = buildPanelScrollVP(h,p)

% default
hedit0 = 20;
htxt0 = 14;
hpop0 = 22;
hsld0 = 20;
fact = 5;
ttl0 = 'Plot';
ttl1 = 'Edit and export video';
ttl2 = 'Molecule coordinates';
ttl3 = 'Intensity integration';

% parents
h_pan = h.uipanel_VP_scroll;
h_pan0 = h_pan.Parent;

% dimensions
pospan = get(h_pan,'position');
pospan0 = get(h_pan0,'position');
htab0 = pospan0(4)-3*p.mg-hedit0;
wtab0 = htab0-hedit0-2*p.mg-hsld0-p.mg-htxt0;
wpan0 = pospan0(3)-3*p.mg-wtab0;
hpan0 = p.mgpan+hpop0+p.mg;
hpan1 = p.mgpan+hpop0+hedit0+p.mg/2+hpop0+p.mg/fact+hedit0+p.mg/2+hedit0+...
    p.mg;
hpan2a = p.mgpan+htxt0+hedit0+p.mg;
hpan2b = p.mgpan+hpop0+p.mg/2+hpop0+p.mg/2+hedit0+p.mg/2+hedit0+p.mg;
hpan2c = p.mgpan+3*hedit0+3*p.mg/2+hedit0+p.mg;
hpan2 = p.mgpan+hpan2a+p.mg/2+hpan2b+p.mg/2+hpan2c+p.mg/2;
hpan3 = p.mgpan+hedit0+p.mg/2+hedit0+p.mg;

% GUI
x = 0;
y = pospan(4)-p.mg/2-hpan0;

h.uipanel_VP_plot = uipanel('parent',h_pan,'units',p.posun,'fontunits',...
    p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan0],'title',ttl0);
h = buildPanelVPplot(h,p);

y = y-p.mg/2-hpan1;

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