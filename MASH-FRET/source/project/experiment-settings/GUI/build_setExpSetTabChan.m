function h = build_setExpSetTabChan(h,nChan)
% h = build_setExpSetTabChan(h,nChan)
%
% Builds first tabbed panel "Channels" of "Experiment settings" window.
%
% h: structure containing handles to all figure's children
% nChan: number of channels

% defaults
str0 = 'Number of channels:';
str1 = ['Next ',char(9658)];

% parents
h_fig = h.figure;
h_tab = h.tab_chan;

% dimensions
postab = h_tab.Position;
hare = postab(4)-h.mgtab-h.hedit-2*h.mg-h.hedit-h.mg;
wtxt0 = getUItextWidth(str0,h.fun,h.fsz,'normal',h.tbl)+h.wpad;
wbut0 = getUItextWidth(str1,h.fun,h.fsz,'normal',h.tbl)+h.wbrd;

x = h.mg;
y = postab(4)-h.mgtab-h.hedit+(h.hedit-h.htxt)/2;

h.text_nChan = uicontrol('parent',h_tab,'style','text','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'string',str0,'horizontalalignment',...
    'left','position',[x,y,wtxt0,h.htxt]);

x = x+wtxt0;
y = y-(h.hedit-h.htxt)/2;

h.edit_nChan = uicontrol('parent',h_tab,'style','edit','units',h.un,...
    'fontunits',h.fun,'fontsize',h.fsz,'position',[x,y,h.wedit0,h.hedit],...
    'callback',{@edit_setExpSet_nChan,h_fig});

h = setExpSet_buildChanArea(h,nChan);

y = y-h.mg-hare-h.mg-h.hedit;
x = postab(3)-h.mg-wbut0;

h.push_nextChan = uicontrol('parent',h_tab,'style','pushbutton','units',...
    h.un,'fontunits',h.fun,'fontsize',h.fsz,'string',str1,'position',...
    [x,y,wbut0,h.hedit],'callback',{@push_setExpSet_next,h_fig,1});
