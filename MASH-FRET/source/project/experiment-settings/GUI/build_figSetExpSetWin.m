function h_fig = build_figSetExpSetWin(proj,h_fig0)
% h_fig = build_figSetExpSetWin(proj,h_fig0)
%
% Builds Experiment settings window and returns associated handle.
%
% h_fig0: handle to main figure
% proj: project's structure
% h_fig: handle to Experiment settings figure

% default
wfig = 600;
hfig = 400;
un = 'pixels';
fun = 'points';
mg = 10;
mgtab = 30;
mgpan = 20;
wbrd = 10;
wpad = 25;
fsz = 9;
htxt = 14;
hedit = 20;
hpop = 22;
wedit0 = 40;
bgclr = [0,0,0];
fgclr = [1,1,1];
wintitle = 'Experiment settings';
ttl0 = 'Channels';
ttl1 = 'Lasers';
ttl2 = 'Calculations';
ttl3 = 'Divers';
nChan = 3;
nExc = 3;

% get table of character pixel widths
h0 = guidata(h_fig0);
tbl = h0.charDimTable;

% store defaults in h structure
h = struct('un',un,'fun',fun,'mg',mg,'mgtab',mgtab,'mgpan',mgpan,'wbrd',...
    wbrd,'wpad',wpad,'fsz',fsz,'htxt',htxt,'hedit',hedit,'hpop',hpop,...
    'wedit0',wedit0);
h.tbl = tbl;
h.bgclr = bgclr;
h.fgclr = fgclr;

% dimensions
wtab = wfig-2*mg;
htab = hfig-2*mg;

% build figure
pos0 = getPixPos(h_fig0);
x = pos0(1)+(pos0(3)-wfig)/2;
y = pos0(2)+(pos0(4)-hfig)/2;
h_fig = figure('units',un,'numbertitle','off','menubar','none','name',...
    wintitle,'position',[x,y,wfig,hfig],'userdata',proj);
h_fig.CloseRequestFcn = {@figure_setExpSet_CloseRequestFcn,h_fig,h_fig0,0};
h.figure = h_fig;

x = mg;
y = hfig-mg-htab;

h.tabg = uitabgroup('parent',h_fig,'units',un,'position',[x,y,wtab,htab]);
h.tab_chan = uitab('parent',h.tabg,'units',un,'title',ttl0);
h.tab_exc = uitab('parent',h.tabg,'units',un,'title',ttl1);
h.tab_calc = uitab('parent',h.tabg,'units',un,'title',ttl2);
h.tab_div = uitab('parent',h.tabg,'units',un,'title',ttl3);

h = build_setExpSetTabChan(h,nChan);

h = build_setExpSetTabExc(h,nExc);

h = build_setExpSetTabCalc(h);

h = build_setExpSetTabDiv(h);

guidata(h_fig,h);

ud_setExpSet_tabChan(h_fig)

