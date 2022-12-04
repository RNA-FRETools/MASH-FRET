function h = buildPanelTPsampleManagement(h,p)
% h = buildPanelTPsampleManagement(h,p);
%
% Builds "Sample management" panel in "Trace processing" module
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_sampleManagement: handle to panel "Sample management"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wbrd: cumulated pixel width of pushbutton's border
%   p.wbox: box's pixel width in checkboxes
%   p.fntclr2: text color in special pushbuttons
%   p.tbl: reference table listing character's pixel dimensions

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
fact = 5;
str3 = 'Trace manager';
str4 = 'Clear selection';
str5 = 'include (0 included)';
str6 = 'label';
str7 = {'Selecte a label'};
str8 = 'Del.';
str9 = '<Add';
ttstr6 = wrapHtmlTooltipString('Open the <b>Trace manager</b> to visualize the ensemble and sort single molecules.');
ttstr7 = wrapHtmlTooltipString('<b>Clear excluded molecules</b> off the list: excluded molecules appear in black in the list.');
ttstr8 = wrapHtmlTooltipString('<b>Molecule selection</b>: when activated, the current molecule is included in the refined sample, otherwise, molecule is considered excluded and appear in black in the list.');
ttstr9 = wrapHtmlTooltipString('<b>Molecule labels</b>: lists the labels given to the current molecule.');
ttstr10 = wrapHtmlTooltipString('<b>Unlabel molecule</b>: remove the selected label from the list.');
ttstr11 = wrapHtmlTooltipString('<b>Add label</b> to the current molecule''s labels list.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_sampleManagement;

% dimensions
pospan = get(h_pan,'position');
wbut2 = getUItextWidth(str4,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut4 = getUItextWidth(str8,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wbut5 = getUItextWidth(str9,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wlst0 = pospan(3)-2*p.mg-p.mg/fact-wbut2;
hlst0 = 5*p.mg/fact+5*hedit0+htxt0;
wcb0 = pospan(3)-2*p.mg;
wpop0 = pospan(3)-2*p.mg-2*p.mg/fact-wbut4-wbut5;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hlst0;

h.listbox_molNb = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wlst0,hlst0],'string',{''},'callback',...
    {@listbox_molNb_Callback,h_fig});

x = x+wlst0+p.mg/fact;
y = pospan(4)-p.mgpan-hedit0;

h.pushbutton_TM = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'string',str3,'tooltipstring',ttstr6,'callback',...
    {@pushbutton_TM_Callback,h_fig});

y = y-p.mg/2-hedit0;

h.pushbutton_TTrem = uicontrol('style','pushbutton','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut2,hedit0],'string',str4,'tooltipstring',ttstr7,'callback',...
    {@pushbutton_TTrem_Callback,h_fig});

x = p.mg;
y = pospan(4)-p.mgpan-hlst0-p.mg-hedit0;

h.checkbox_TP_selectMol = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str5,'tooltipstring',ttstr8,'callback',...
    {@checkbox_TP_selectMol_Callback,h_fig});

y = y-p.mg/fact-htxt0;

h.text_TP_molLabel = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str6);

x = p.mg;
y = y-hpop0+(hpop0-hedit0)/2;

h.togglebutton_TP_addTag = uicontrol('style','togglebutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut5,hedit0],'string',str9,'tooltipstring',ttstr11,'callback',...
    {@togglebutton_TP_addTag_Callback,h_fig});

x = x+wbut5+p.mg/fact;

h.pushbutton_TP_deleteTag = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wbut4,hedit0],'string',str8,'tooltipstring',ttstr10,'callback',...
    {@pushbutton_TP_deleteTag_Callback,h_fig});

x = x+wbut4+p.mg/fact;
y = y-(hpop0-hedit0)/2;

h.popupmenu_TP_molLabel = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str7,'tooltipstring',ttstr9);

