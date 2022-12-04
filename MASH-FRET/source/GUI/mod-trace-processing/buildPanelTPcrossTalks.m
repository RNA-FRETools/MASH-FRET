function h = buildPanelTPcrossTalks(h,p)
% h = buildPanelTPcrossTalks(h,p);
%
% Builds panel "Cross-talks" in module "Trace processing"
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_crossTalks: handle to panel "Cross-talks"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.fntclr2: text color in special pushbuttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 10.01.2020

% default
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
fact = 5;
str0 = 'emitter:';
str1 = [char(8627),' bt into:'];
str2 = 'channel';
str3 = 'bt';
str4 = [char(8627),' dE at:'];
str5 = 'laser';
str6 = 'dE';
str7 = {'Select a channel'};
str8 = {'Select a laser'};
ttstr0 = wrapHtmlTooltipString('Select the <b>emitter</b> to configure the cross-talks for.');
ttstr1 = wrapHtmlTooltipString('Select a <b>non-specific channel</b> to set the selected emitter''s bleedthrough coefficient for.');
ttstr2 = wrapHtmlTooltipString('<b>Bleedthrough coefficient:</b> amount of emitter''s signal detected in the non-specific channel relative to the specific emission channel.');
ttstr3 = wrapHtmlTooltipString('Select a <b>non-specific laser</b> to set the selected emitter''s direct excitation coefficient for.');
ttstr4 = wrapHtmlTooltipString('<b>Direct excitation coefficient:</b> amount of emitter''s signal detected upon non-specific laser illumination relative to specific illumination.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_crossTalks;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt1 = max([getUItextWidth(str1,p.fntun,p.fntsz1,'normal',p.tbl),...
    getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)]);
wpop0 = pospan(3)-p.mg-wtxt0-p.mg;
wpop1 = (pospan(3)-p.mg-wtxt1-p.mg/fact-p.mg)/2;

x = p.mg;
y = pospan(4)-p.mgpan-hpop0+(hpop0-htxt0)/2;

h.text_TP_cross_of = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

h.popupmenu_corr_chan = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str7,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_corr_chan_Callback,h_fig});

x = p.mg;
y = y-p.mg/2-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_TP_cross_into = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt1,htxt0],'string',str1,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hpop0-htxt0)/2+hpop0;

h.text_TP_cross_channel = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str2);

y = y-hpop0;

h.popupmenu_bt = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,hpop0],'string',str7,'tooltipstring',ttstr1,'callback',...
    {@popupmenu_bt_Callback,h_fig});

x = x+wpop1+p.mg/fact;
y = y+hpop0;

h.text_TP_cross_bt = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str3);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_bt = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpop1,hedit0],...
    'callback',{@edit_bt_Callback,h_fig},'tooltipstring',ttstr2);

x = p.mg;
y = y-(hpop0-hedit0)/2-p.mg/2-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_TP_cross_by = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str4,'horizontalalignment','left');

x = x+wtxt1;
y = y-(hpop0-htxt0)/2+hpop0;

h.text_TP_cross_laser = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str5);

y = y-hpop0;

h.popupmenu_corr_exc = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,hpop0],'string',str8,'tooltipstring',ttstr3,'callback',...
    {@popupmenu_corr_exc_Callback,h_fig});

x = x+wpop1+p.mg/fact;
y = y+hpop0;

h.text_TP_cross_de = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop1,htxt0],'string',str6);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_dirExc = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wpop1,hedit0],...
    'callback',{@edit_dirExc_Callback,h_fig},'tooltipstring',ttstr4);

