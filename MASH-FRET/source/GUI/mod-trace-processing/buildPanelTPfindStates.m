function h = buildPanelTPfindStates(h,p)
% h = buildPanelTPfindStates(h,p);
%
% Builds panel "Find states" in "Trace processing" module.
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TP_findStates: handle to panel "Find states"
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

% Last update by MH, 22.12.2020: add vFRET 2D
% update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString
% created by MH, 19.10.2019

% default
hedit0 = 20;
htxt0 = 13;
hpop0 = 22;
wedit0 = 40;
fact = 5;
str0 = 'method';
str1 = 'apply to';
str2 = 'data';
str3 = 'param';
str4 = 'tol';
str5 = 'refine';
str6 = 'binning';
str7 = 'deblurr';
str8 = {'Thresholds','vbFRET-1D','vbFRET-2D','One state','CPA','STaSI',...
    'STaSI+vbFRET-1D','Imported'};
str9 = {'bottom','top','all'};
str10 = {'Select a trace'};
str11 = 'Results (19 states):';
str12 = {'Select a state'};
str19 = 'state';
str13 = 'value';
str14 = 'threshold';
str15 = 'low';
str16 = 'high';
str17 = 'Adjust to data';
str18 = 'all';
ttstr0 = wrapHtmlTooltipString('Select a <b>state-finding algorithm</b> to discretize time-traces.');
ttstr1 = wrapHtmlTooltipString('Select the <b>axes</b> to apply the state-finding algorithm to: traces in bottom axes, traces in top axes (use shared state transitions in top axes for bottom axes), or traces in both top and bottom axes');
ttstr2 = wrapHtmlTooltipString('Select the <b>data-time trace</b> to configure the state-finding algorithm for.');
ttstr3 = wrapHtmlTooltipString('Post-processing parameter <b>tolerance window size:</b> the parameter is used to identify a state transition as "shared" among top-axes time traces in order to deduce transitions in bottom-axes time traces (only when apply to top axes).');
ttstr4 = wrapHtmlTooltipString('Post-processing parameter <b>number of refinement cycles:</b> each step in the state sequence is iteratively reassigned to the state having the closest value to the averaged data behind the step.');
ttstr5 = wrapHtmlTooltipString('Post-processing parameter <b>state bin size</b>: states close in value within a bin size are binned together in one averaged state.');
ttstr6 = wrapHtmlTooltipString('Post-processing method <b>remove blurr states</b>: states dwelling one time bin are ignored.');
ttstr7 = wrapHtmlTooltipString('Select a <b>state</b> to show the corresponding final value: found states are numbered from the lowest to the greatest value.');
ttstr8 = wrapHtmlTooltipString('<b>Final sate value</b> (after post-processing) corresponding to the selected state.');
ttstr9 = wrapHtmlTooltipString('Select an <b>initial state</b> to set the corresponding thresholds: states are numbered from the lowest to the greatest value.');
ttstr10 = wrapHtmlTooltipString('<b>Lower threshold:</b> when the trajectory goes below this threshold, the state sequence transits to the next lower state value.');
ttstr11 = wrapHtmlTooltipString('<b>State value:</b> when the original trajectory remains between the low and high thresholds, the state sequence dwells at this value.');
ttstr12 = wrapHtmlTooltipString('<b>Higher threshold:</b> when the trajectory goes above this threshold, the state sequence transits to the next higher state value.');
ttstr13 = wrapHtmlTooltipString('Post processing action <b>adjust state value</b> to data: positions of state transitions are preserved but state values are recalculated by averaging the data points behind.');
ttstr14 = wrapHtmlTooltipString('Apply current state-finding method settings to all molecules.');

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TP_findStates;

% dimensions
pospan = get(h_pan,'position');
wtxt0 = getUItextWidth(str11,p.fntun,p.fntsz1,'normal',p.tbl);
wbut0 = getUItextWidth(str18,p.fntun,p.fntsz1,'normal',p.tbl)+p.wbrd;
wpop0 = (pospan(3)-p.mg-p.mg/fact-p.mg)/2;
wpop1 = 2*wedit0+p.mg/fact;
wpop2 = pospan(3)-p.mg-3*(p.mg/fact+wedit0)-p.mg;
wedit1 = (pospan(3)-p.mg-3*p.mg/fact-p.mg)/4;
wcb0 = 3*wedit0+2*p.mg/fact;
wedit2 = (pospan(3)-p.mg-wtxt0-2*p.mg/fact-wbut0-p.mg)/2;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-htxt0;

h.text_TP_states_method = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str0);

x = x+wpop0+p.mg/fact;

h.text_TP_states_applyTo = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,htxt0],'string',str1);

x = p.mg;
y = y-hpop0;

h.popupmenu_TP_states_method = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop0,hpop0],'string',str8,'tooltipstring',ttstr0,...
    'callback',{@popupmenu_TP_states_method_Callback,h_fig});

x = x+wpop0+p.mg/fact;

h.popupmenu_TP_states_applyTo = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop0,hpop0],'string',str9,'tooltipstring',ttstr1,...
    'callback',{@popupmenu_TP_states_applyTo_Callback,h_fig});

x = p.mg;
y = y-p.mg-htxt0;

h.text_TP_states_data = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop2,htxt0],'string',str2);

x = x+wpop2+p.mg/fact;

h.text_TP_states_param1 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = x+wedit0+p.mg/fact;

h.text_TP_states_param2 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = x+wedit0+p.mg/fact;

h.text_TP_states_param3 = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str3);

x = p.mg;
y = y-hpop0;

h.popupmenu_TP_states_data = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop2,hpop0],'string',str10,'tooltipstring',ttstr2,...
    'callback',{@popupmenu_TP_states_data_Callback,h_fig});

x = x+wpop2+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TP_states_param1 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TP_states_param1_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TP_states_param2 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TP_states_param2_Callback,h_fig});

x = x+wedit0+p.mg/fact;

h.edit_TP_states_param3 = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'callback',{@edit_TP_states_param3_Callback,h_fig});

x = p.mg;
y = y-p.mg-htxt0;

h.text_TP_states_thresholds = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontangle',...
    'italic','position',[x,y,wpop2,htxt0],'string',str14);

y = y-hpop0;

h.popupmenu_TP_states_indexThresh = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wpop2,hpop0],'string',str12,'tooltipstring',ttstr9,...
    'callback',{@popupmenu_TP_states_indexThresh_Callback,h_fig});

x = x+wpop2+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TP_states_lowThresh = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr10,'callback',...
    {@edit_TP_states_lowThresh_Callback,h_fig});

y = y+hedit0;

h.text_TP_states_lowThresh = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str15);

x = x+wedit0+p.mg/fact;
y = y-hedit0;

h.edit_TP_states_state = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr11,'callback',...
    {@edit_TP_states_state_Callback,h_fig});

y = y+hedit0;

h.text_TP_states_state = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str13);

x = x+wedit0+p.mg/fact;
y = y-hedit0;

h.edit_TP_states_highThresh = uicontrol('style','edit','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,hedit0],'tooltipstring',ttstr12,'callback',...
    {@edit_TP_states_highThresh_Callback,h_fig});

y = y+hedit0;

h.text_TP_states_highThresh = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit0,htxt0],'string',str16);

x = p.mg;
y = y-hedit0-(hpop0-hedit0)/2-p.mg-htxt0;

h.text_states_paramTol = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,htxt0],'string',str4);

x = x+wedit1+p.mg/fact;

h.text_TP_states_paramRefine = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,htxt0],'string',str5);

x = x+wedit1+p.mg/fact;

h.text_TP_states_paramBin = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,htxt0],'string',str6);

x = x+wedit1+p.mg/fact;

h.text_TP_states_deblurr = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,htxt0],'string',str7);

x = p.mg;
y = y-hedit0;

h.edit_TP_states_paramTol = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'tooltipstring',ttstr3,'callback',...
    {@edit_TP_states_paramTol_Callback,h_fig});

x = x+wedit1+p.mg/fact;

h.edit_TP_states_paramRefine = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'tooltipstring',ttstr4,'callback',...
    {@edit_TP_states_paramRefine_Callback,h_fig});

x = x+wedit1+p.mg/fact;

h.edit_TP_states_paramBin = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'tooltipstring',ttstr5,'callback',...
    {@edit_TP_states_paramBin_Callback,h_fig});

x = x+wedit1+p.mg/fact;

h.edit_TP_states_deblurr = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit1,hedit0],'tooltipstring',ttstr6,'callback',...
    {@edit_TP_states_deblurr_Callback,h_fig});

x = p.mg;
y = y-p.mg/fact-hedit0;

h.checkbox_recalcStates = uicontrol('style','checkbox','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wcb0,hedit0],'string',str17,'tooltipstring',ttstr13,...
    'callback',{@checkbox_recalcStates_Callback,h_fig});

x = p.mg;
y = y-p.mg-htxt0-hpop0+(hpop0-htxt0)/2;

h.text_TP_states_resultsStates = uicontrol('style','text','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wtxt0,htxt0],'string',str11,'horizontalalignment','left');

x = x+wtxt0;
y = y-(hpop0-htxt0)/2;

h.popupmenu_TP_states_index = uicontrol('style','popupmenu','parent',...
    h_pan,'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,...
    'position',[x,y,wedit2,hpop0],'string',str12,'tooltipstring',ttstr7,...
    'callback',{@popupmenu_TP_states_index_Callback,h_fig});

y = y+hpop0;

h.text_TP_states_index = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit2,htxt0],'string',str19);

x = x+wedit2+p.mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

h.edit_TP_states_result = uicontrol('style','edit','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit2,hedit0],'tooltipstring',ttstr8);

y = y+hedit0;

h.text_TP_states_result = uicontrol('style','text','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wedit2,htxt0],'string',str13);

x = x+wedit2+p.mg/fact;
y = y-hedit0;

h.pushbutton_applyAll_DTA = uicontrol('style','pushbutton','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'fontweight',...
    'bold','position',[x,y,wbut0,hedit0],'string',str18,'tooltipstring',...
    ttstr14,'callback',{@pushbutton_applyAll_DTA_Callback,h_fig},...
    'foregroundcolor',p.fntclr2);

