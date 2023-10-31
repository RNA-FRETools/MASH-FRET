function h = buildPanelScrollTP(h,p)

% defaults
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
fact = 5;
ttl1 = 'Plot';
ttl2 = 'Sub-images';
ttl3 = 'Background correction';
ttl4 = 'Cross-talks';
ttl5 = 'Factor corrections';
ttl6 = 'Denoising';
ttl7 = 'Photobleaching';
ttl8 = 'Find states';

% parents
h_pan = h.uipanel_TP_scroll;

% dimensions
pospan = get(h_pan,'position');
wpan0 = pospan(3);
hpan1 = p.mgpan+htxt0+hpop0+p.mg/fact+htxt0+hpop0+p.mg/fact+htxt0+hedit0+...
    p.mg+hedit0+p.mg;
hpan2 = p.mgpan+3*htxt0+p.mg/fact+htxt0+p.mg/fact+htxt0+hpop0+p.mg;
hpan3 = p.mgpan+htxt0+hpop0+p.mg/fact+htxt0+hedit0+p.mg/fact+hedit0+...
    p.mg/fact+hedit0+p.mg;
hpan4 = p.mgpan+hpop0+p.mg/2+2*(htxt0+hpop0+p.mg/2)+p.mg/2;
hpan5 = p.mgpan+p.mg+p.mg/fact+hpop0+hedit0;
hpan6 = p.mgpan+p.mg+p.mg/fact+2*hpop0+2*htxt0;
hpan7 = p.mgpan+htxt0+hpop0+p.mg/fact+htxt0+hedit0+p.mg+p.mg/2;
hpan8 = p.mgpan+3*(htxt0+hpop0+p.mg)+htxt0+hedit0+p.mg/fact+hedit0+p.mg+...
    htxt0+hpop0+p.mg;

% GUI
x = 0;
y = pospan(4)-hpan1;

h.uipanel_TP_plot = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan1],'title',ttl1);
h = buildPanelTPplot(h,p);

y = y-p.mg-hpan2;

h.uipanel_TP_subImages = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan2],'title',ttl2);
h = buildPanelTPsubImages(h,p);

y = y-p.mg-hpan3;

h.uipanel_TP_backgroundCorrection = uipanel('parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold',...
    'position',[x,y,wpan0,hpan3],'title',ttl3);
h = buildPanelTPbackgroundCorrection(h,p);

y = y-p.mg-hpan4;

h.uipanel_TP_crossTalks = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan4],'title',ttl4);
h = buildPanelTPcrossTalks(h,p);

y = y-p.mg-hpan5;

h.uipanel_TP_denoising = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan5],'title',ttl6);
h = buildPanelTPdenoising(h,p);

y = y-p.mg-hpan6;

h.uipanel_TP_photobleaching = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan6],'title',ttl7);
h = buildPanelTPphotobleaching(h,p);

y = y-p.mg-hpan7;

h.uipanel_TP_factorCorrections = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan7],'title',ttl5);
h = buildPanelTPfactorCorrections(h,p);

y = y-p.mg-hpan8;

h.uipanel_TP_findStates = uipanel('parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight','bold','position',...
    [x,y,wpan0,hpan8],'title',ttl8);
h = buildPanelTPfindStates(h,p);
