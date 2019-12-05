function h = buildPanelTPfactorCorrections(h,p)
% h = buildPanelTPfactorCorrections(h,p);
%
% Builds panel "Factor corrections" in module "Trace processing"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_factorCorrections: handle to panel "Factor corrections"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wttsr: pixel width of tooltip box
%   p.fntclr2: text color in special pushbuttons
%   p.tbl: reference table listing character's pixel dimensions
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
wedit0 = 40;
fact = 5;
str0 = 'Cross-talks:';
str1 = 'emitter';
str2 = 'bt into';
str3 = 'bt';
str4 = 'dE at';
str5 = 'dE';
str6 = {'Select a channel'};
str7 = {'Select a laser'};
str8 = 'Gamma factor:';
str9 = 'data';
str10 = 'method';
str11 = 'gamma';
str12 = {'Select a FRET pair'};
str13 = {'Manual','From acceptor photobleaching'};
str14 = 'Load';
str15 = 'all';
ttstr0 = wrapStrToWidth('Select the <b>emitter</b> to configure the cross-talks for.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr1 = wrapStrToWidth('Select a <b>non-specific channel</b> to set the selected emitter''s bleedthrough coefficient for.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr2 = wrapStrToWidth('<b>Bleedthrough coefficient:</b> amount of emitter''s signal detected in the non-specific channel relative to the specific emission channel.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr3 = wrapStrToWidth('Select a <b>non-specific laser</b> to set the selected emitter''s direct excitation coefficient for.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr4 = wrapStrToWidth('<b>Direct excitation coefficient:</b> amount of emitter''s signal detected upon non-specific laser illumination relative to specific illumination.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr5 = wrapStrToWidth('Select a <b>FRET pair</b> to configure the gamma correction for.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr6 = wrapStrToWidth('Select a <b>gamma factor estimation method:</b> estimation via acceptor photobleaching requires the acceptor intensity-time trace to be discretized.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr7 = wrapStrToWidth('<b>Gamma factor</b> for the selected FRET pair.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);
ttstr8 = wrapStrToWidth('Apply current factor corrections settings to all molecules.',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_factorCorrections;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = pospan(3)-2*p.mg;
wbut0 = getUItextWidth(str14,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut1 = getUItextWidth(str15,p.fntun,p.fntsz1,'bold',p.tbl)+p.wbrd;
wpop0 = (pospan(3)-3*p.mg-2*p.mg/fact-2*wedit0)/3;
wpop1 = (pospan(3)-2*p.mg-4*p.mg/fact-wbut0-wbut1-wedit0)/2;

x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TP_cross_crosstalks = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontangle',...
    'italic','position',[x,y,wtxt0,htxt0],'string',str0,...
    'horizontalalignment','left');

y = y-p.mg/fact-htxt0;

h.text_TP_cross_of = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str1);

x = x+wpop0+p.mg/2;

h.text_TP_cross_into = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str2);

x = x+wpop0+p.mg/fact;

h.text_TP_cross_bt = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = x+wedit0+p.mg/2;

h.text_TP_cross_by = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str4);

x = x+wpop0+p.mg/fact;

h.text_TP_cross_de = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str5);

x = p.mg;
y = y-hpop0;

h.popupmenu_corr_chan = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str6,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_corr_chan_Callback,h_fig});

x = x+wpop0+p.mg/2;

h.popupmenu_bt = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str6,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_bt_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_bt = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_bt_Callback,h_fig},'tooltipstring',ttstr2);

x = x+wedit0+p.mg/2;
y = y-(hpop0-hedit0)/2;

h.popupmenu_corr_exc = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str7,'tooltipstring',ttstr3,'callback',...
    {@popupmenu_corr_exc_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_dirExc = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_dirExc_Callback,h_fig},'tooltipstring',ttstr4);

x = p.mg;
y = y-(hpop0-hedit0)/2-p.mg/2-htxt0;

h.text_TP_cross_gammafactor = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontangle',...
    'italic','position',[x,y,wtxt0,htxt0],'string',str8,...
    'horizontalalignment','left');

y = y-p.mg/fact-htxt0;

h.text_TP_factors_data = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str9);

x = x+wpop1+p.mg/fact;

h.text_TP_factors_method = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str10);

x = x+wpop1+p.mg/fact;

h.text_TP_factors_gamma = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str11);

x = p.mg;
y = y-hpop0;

h.popupmenu_gammaFRET = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,hpop0],'string',str12,'tooltipstring',ttstr5,'callback',...
    {@popupmenu_gammaFRET_Callback,h_fig});

x = x+wpop1+p.mg/fact;

h.popupmenu_TP_factors_method = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,hpop0],'string',str13,'tooltipstring',ttstr6,'callback',...
    {@popupmenu_TP_factors_method_Callback,h_fig});

x = x+wpop1+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_gammaCorr = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'callback',{@edit_gammaCorr_Callback,h_fig},'tooltipstring',ttstr7);

x = x+wedit0+p.mg/fact;

h.pushbutton_optGamma = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str14,'callback',...
    {@pushbutton_optGamma_Callback,h_fig});

x = pospan(3)-p.mg-wbut1;

h.pushbutton_applyAll_corr = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hedit0],'string',str15,'callback',...
    {@pushbutton_applyAll_corr_Callback,h_fig},'tooltipstring',ttstr8,...
    'foregroundcolor',p.fntclr2);


