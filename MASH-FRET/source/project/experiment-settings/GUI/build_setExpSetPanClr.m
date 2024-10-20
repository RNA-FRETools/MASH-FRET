function h = build_setExpSetPanClr(h)
% h = build_setExpSetPanClr(h)
%
% Builds panel "Plot color" in "Experiment settings" window.
%
% h: structure containing handles to all figure's children

% defaults
str0 = 'data:';
str1 = {'Select data'};
str2 = 'Set color';
str3 = 'Apply default colors';

% parents
h_fig = h.figure;
h_pan = h.panel_clr;

% dimensions
pospan = h_pan.Position;
wbut0 = getUItextWidth(str2,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wpop = pospan(3)-3*h.mg-wbut0;
wbut1 = pospan(3)-2*h.mg;

% GUI
x = h.mg;
y = pospan(4)-h.mgpan-h.htxt;

h.text_chanClr = uicontrol('parent',h_pan,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str0,'position',...
    [x,y,wpop,h.htxt]);

y = y-h.hpop;

h.popup_chanClr = uicontrol('parent',h_pan,'style','popup','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str1,'position',...
    [x,y,wpop,h.hpop],'callback',{@popup_setExpSet_chanClr,h_fig});

x = x+wpop+h.mg;
y = y+(h.hpop-h.hedit)/2;

h.push_clr = uicontrol('parent',h_pan,'style','pushbutton','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str2,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_clr,h_fig});

x = h.mg;
y = y-h.mg-h.hedit;

h.push_defclr = uicontrol('parent',h_pan,'style','pushbutton','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str3,'position',...
    [x,y,wbut1,h.hedit],'callback',{@push_setExpSet_defclr,h_fig});

