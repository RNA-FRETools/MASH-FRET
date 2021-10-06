function h = build_setExpSetTabCalc(h)
% h = build_setExpSetTabCalc(h)
%
% Builds third tabbed panel "Calculations" of "Experiment settings" window.
%
% h: structure containing handles to all figure's children

% defaults
str0 = 'FRET from:';
str1 = 'don';
str2 = 'acc';
str3 = 'to:';
str4 = 'Add';
str5 = 'Remove';
str6 = 'Stoichiometry of:';
str7 = 'FRET pair';
str8 = ['Next ',char(9658)];

% parents
h_fig = h.figure;
h_tab = h.tab_calc;

% dimensions
postab = h_tab.Position;
wtxt0 = getUItextWidth(str0,h.fun,h.fsz,'normal',h.tbl);
wtxt1 = getUItextWidth(str3,h.fun,h.fsz,'normal',h.tbl);
wtxt2 = getUItextWidth(str6,h.fun,h.fsz,'normal',h.tbl)+h.wpad;
wbut0 = getUItextWidth(str5,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wbut1 = getUItextWidth(str8,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
hlst = postab(4)-h.mgtab-h.htxt-h.hpop-2*h.mg-h.hedit-h.mg;
wlst = (postab(3)-5*h.mg-2*wbut0)/2;
wpop0 = (wlst-3*h.mg-wtxt0-wtxt1)/2;
wpop1 = wlst-h.mg-wtxt2;

% GUI
x = h.mg;
y = postab(4)-h.mgtab-h.htxt-h.hpop+(h.hpop-h.htxt)/2;

h.text_from = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str0,'position',...
    [x,y,wtxt0,h.htxt],'horizontalalignment','left');

x = x+wtxt0+h.mg;
y = y-(h.hpop-h.htxt)/2+h.hpop;

h.text_don = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str1,'position',...
    [x,y,wpop0,h.htxt]);

y = y-h.hpop;

h.popup_don = uicontrol('parent',h_tab,'style','popup','units',h.un,...
    'string',{'Select an emitter'},'value',1,'position',...
    [x,y,wpop0,h.hpop]);

x = x+wpop0+h.mg;
y = y+(h.hpop-h.htxt)/2;

h.text_to = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str3,'position',...
    [x,y,wtxt1,h.htxt]);

x = x+wtxt1+h.mg;
y = y-(h.hpop-h.htxt)/2+h.hpop;

h.text_acc = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str2,'position',...
    [x,y,wpop0,h.htxt]);

y = y-h.hpop;

h.popup_acc = uicontrol('parent',h_tab,'style','popup','units',h.un,...
    'string',{'Select an emitter'},'value',1,'position',...
    [x,y,wpop0,h.hpop]);

x = h.mg;
y = y-h.mg-hlst;

h.list_FRET = uicontrol('parent',h_tab,'style','listbox','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wlst,hlst]);

x = x+wlst+h.mg;
y = y+hlst-h.hedit;

h.push_addFRET = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str4,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_addFRET,h_fig});

y = y-h.mg-h.hedit;

h.push_remFRET = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str5,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_remFRET,h_fig});

x = x+wbut0+h.mg;
y = postab(4)-h.mgtab-h.htxt-h.hpop+(h.hpop-h.htxt)/2;

h.text_stoich = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str6,'position',...
    [x,y,wtxt2,h.htxt],'horizontalalignment','left');

x = x+wtxt2+h.mg;
y = y-(h.hpop-h.htxt)/2+h.hpop;

h.text_pair = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str7,'position',...
    [x,y,wpop1,h.htxt]);

y = y-h.hpop;

h.popup_S = uicontrol('parent',h_tab,'style','popup','units',h.un,'string',...
    {'Select a FRET pair'},'value',1,'position',[x,y,wpop1,h.hpop],...
    'callback',{@popup_setExpSet_S,h_fig});

x = x-wtxt2-h.mg;
y = y-h.mg-hlst;

h.list_S = uicontrol('parent',h_tab,'style','listbox','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wlst,hlst]);

x = x+wlst+h.mg;
y = y+hlst-h.hedit;

h.push_addS = uicontrol('parent',h_tab,'style','pushbutton','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str4,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_addS,h_fig});

y = y-h.mg-h.hedit;

h.push_remS = uicontrol('parent',h_tab,'style','pushbutton','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str5,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_remS,h_fig});

y = y+h.hedit+h.mg+h.hedit-hlst-h.mg-h.hedit;
x = postab(3)-h.mg-wbut1;

h.push_nextCalc = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str8,'position',...
    [x,y,wbut1,h.hedit],'callback',{@push_setExpSet_next,h_fig,3});

