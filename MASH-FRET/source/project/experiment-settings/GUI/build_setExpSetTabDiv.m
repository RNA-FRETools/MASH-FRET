function h = build_setExpSetTabDiv(h,h_fig0)
% h = build_setExpSetTabDiv(h,h_fig0)
%
% Builds fifth tabbed panel "Divers" of "Experiment settings" window.
%
% h: structure containing handles to all figure's children
% h_fig0: handle to main figure

% defaults
str0 = 'Project name:';
str1 = 'Video sampling time (s):';
str3 = 'Save';
ttl0 = 'Experimental conditions';
ttl1 = 'Plot colors';

% parents
h_fig = h.figure;
h_tab = h.tab_div;

% dimensions
postab = h_tab.Position;
wtxt0 = getUItextWidth(str0,h.fun,h.fsz,'normal',h.tbl)+h.wpad;
wtxt1 = getUItextWidth(str1,h.fun,h.fsz,'normal',h.tbl)+h.wpad;
wbut = getUItextWidth(str3,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;
wpan = (postab(3)-3*h.mg)/2;
wedit1 = wpan-wtxt0;
wedit2 = wpan-wtxt1;
hpan0 = postab(4)-h.mgtab-h.htxt-h.hedit-2*h.mg;
hpan1 = h.mgpan+h.htxt+h.hpop+h.mg+h.hedit+h.mg;

% GUI
x = h.mg;
y = postab(4)-h.mgtab-h.hedit+(h.hedit-h.htxt)/2;

h.text_projName = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str0,'position',...
    [x,y,wtxt0,h.htxt],'horizontalalignment','left');

x = x+wtxt0;
y = y-(h.hedit-h.htxt)/2;

h.edit_projName = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wedit1,h.hedit],...
    'callback',{@edit_setExpSet_projName,h_fig});

x = h.mg;
y = y-h.mg-hpan0;

h.panel_expCond = uipanel('parent',h_tab,'units',h.un,'position',...
    [x,y,wpan,hpan0],'title',ttl0);
h = build_setExpSetPanExpCond(h);

x = x+wpan+h.mg;
y = postab(4)-h.mgtab-h.hedit+(h.hedit-h.htxt)/2;

h.text_splTime = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str1,'position',...
    [x,y,wtxt1,h.htxt],'horizontalalignment','left');

x = x+wtxt1;
y = y-(h.hedit-h.htxt)/2;

h.edit_splTime = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,wedit2,h.hedit],...
    'callback',{@edit_setExpSet_splTime,h_fig});

x = x-wtxt1;
y = y-h.mg-hpan1;

h.panel_clr = uipanel('parent',h_tab,'units',h.un,'position',...
    [x,y,wpan,hpan1],'title',ttl1);
h = build_setExpSetPanClr(h);

x = postab(3)-h.mg-wbut;
y = h.mg;

h.push_save = uicontrol('parent',h_tab,'style','pushbutton','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str3,'position',...
    [x,y,wbut,h.hedit],'callback',{@push_setExpSet_save,h_fig,h_fig0});
