function h = buildPanelTAtransitions(h,p)
% h = buildPanelTAtransitions(h,p);
%
% Builds panel "Transitions" in "Transition analysis".
%
% h: structure to update with handles to new UI components and that must contain fields:
%   h.figure_MASH: handle to main figure
%   h.uipanel_TA_transitions: handle to panel "Transitions"
% p: structure containing default and often-used parameters which must contain fields:
%   p.posun: position units
%   p.fntun: font size units
%   p.fntsz1: regular font size
%   p.mg: margin
%   p.mgpan: top-margin in a titled panel
%   p.wttsr: pixel width of tooltip box
%   p.hndls: 1-by-2 array containing handles to one dummy figure and one text

% Created by MH, 9.11.2019

% defaults
hedit0 = 20;
hpop0 = 22;
fact = 5;
str0 = {'red','green','blue','yellow','cyan','magenta','olive','orange',...
    'wine','marine','kaki','turpuoise','purple','brown','pink','violet',...
    'grey','canary','pastel blue'};
ttstr0 = wrapStrToWidth('<b>Set plot color</b> of selected transition cluster',p.fntun,p.fntsz1,'normal',p.wttstr,'html',p.hndls);

% parents
h_fig = h.figure_MASH;
h_pan = h.uipanel_TA_transitions;

% dimensions
pospan = get(h_pan,'position');
wedit0 = hedit0;
wlst0 = pospan(3)-2*p.mg;
hlst0 = pospan(4)-p.mgpan-p.mg-p.mg/2-hpop0;
wpop0 = pospan(3)-2*p.mg-p.mg/fact-wedit0;

% GUI
x = p.mg;
y = pospan(4)-p.mgpan-hlst0;

h.listbox_TDPtrans = uicontrol('style','listbox','parent',h_pan,'units',...
    p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wlst0,hlst0],'string',{''},'callback',...
    {@listbox_TDPtrans_Callback,h_fig});

y = p.mg;

h.popupmenu_TDPcolour = uicontrol('style','popupmenu','parent',h_pan,...
    'units',p.posun,'fontunits',p.fntun,'fontsize',p.fntsz1,'position',...
    [x,y,wpop0,hpop0],'string',str0,'tooltipstring',ttstr0,'callback',...
    {@popupmenu_TDPcolour_Callback,h_fig});

x = x+wpop0+p.mg/fact;
y = y+(hpop0-hedit0)/2;

h.edit_TDPcolour = uicontrol('style','edit','parent',h_pan,'units',p.posun,...
    'fontunits',p.fntun,'fontsize',p.fntsz1,'position',[x,y,wedit0,hedit0],...
    'enable','inactive');

% store default color list
h.color_list = str0;


