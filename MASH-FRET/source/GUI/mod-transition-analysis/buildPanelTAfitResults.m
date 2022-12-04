function h = buildPanelTAfitResults(h,p)
% h = buildPanelTAfitResults(h,p);
%
% Builds panel "Results" in panel "Dwell time histograms" of "Transition analysis" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_fitResults: handle to panel "Results"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.tbl: reference table listing character pixel dimensions

% Created by MH, 1.11.2021

htxt0 = 14;
hpop0 = 22;
hedit0 = 20;
wedit0 = 40;
fact = 5;
str0 = 'Lifetime:';
str1a = 'degen.';
str1 = {'Select a degenerated level'};
str2 = 'sigma';
str3 = [char(964),' (s)'];
str4 = 'Contrib. to hist.:';
str5 = 'trans.';
str6 = {'Select a tansition'};
str7 = 'contrib.';
ttstr0 = wrapHtmlTooltipString('Select a <b>degenerated level</b>');
ttstr1 = wrapHtmlTooltipString('Bootstap mean of <b>state lifetime</b> (in seconds)');
ttstr2 = wrapHtmlTooltipString('Bootstap mean of <b>relative contribution</b> of degenerated level to dwell time histogram');
ttstr3 = wrapHtmlTooltipString('Bootstap deiation of <b>state lifetime</b> (in seconds)');
ttstr4 = wrapHtmlTooltipString('Bootstap deviation of <b>relative contribution</b> of degenerated level to dwell time histogram');
ttstr5 = wrapHtmlTooltipString('Select a <b>state transition</b>');

% parent
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_fitResults;

% dimensions
pospan = get(h_pan,'position');
wtxt0a = getUItextWidth(str0,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt0b = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl);
wtxt0 = max([wtxt0a,wtxt0b]);
wpop0 = pospan(3)-p.mg-wtxt0-p.mg/fact-wedit0-p.mg/fact-wedit0-p.mg;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_TA_slLiftime = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str0,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2+hpop0;

h.text_TA_slDegen = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str1a);

y = y-hpop0;

h.popupmenu_TA_slDegen = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str1,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TA_slDegen_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+hpop0;

h.text_TA_slTau = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TA_slTauMean = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr1,'callback',...
    {@edit_TA_slTauMean_Callback,h_fig});

x = x+wedit0+p.mg/fact;
y = y-(hpop0-hedit0)/2+hpop0;

h.text_TA_slTauSig = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str2);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TA_slTauSig = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr3,'callback',...
    {@edit_TA_slTauSig_Callback,h_fig});

x = p.mg;
y = y-(hpop0-hedit0)/2-p.mg/2-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_TA_slContrib = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str4,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2+hpop0;

h.text_TA_slTrans = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str5);

y = y-hpop0;

h.popupmenu_TA_slTrans = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str6,'tooltipstring',ttstr5,'callback',...
    {@popupmenu_TA_slTrans_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+hpop0;

h.text_TA_slPop = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str7);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TA_slPopMean = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr2,'callback',...
    {@edit_TA_slPopMean_Callback,h_fig});

x = x+wedit0+p.mg/fact;
y = y-(hpop0-hedit0)/2+hpop0;

h.text_TA_slPopSig = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str2);

y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TA_slPopSig = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr4,'callback',...
    {@edit_TA_slPopSig_Callback,h_fig});

