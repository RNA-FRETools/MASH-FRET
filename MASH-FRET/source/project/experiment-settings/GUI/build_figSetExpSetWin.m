function h_fig = build_figSetExpSetWin(proj,dat2import,h_fig0)
% h_fig = build_figSetExpSetWin(proj,dat2import,h_fig0)
%
% Builds Experiment settings window and returns associated handle.
%
% h_fig0: handle to main figure
% proj: project's structure
% dat2import: data to import from file ('video' or 'trajectories')
% h_fig: handle to Experiment settings figure

% default
wfig = 600;
hfig = 400;
un = 'pixels';
fun = 'points';
mg = 10;
mgtab = 10;
mgpan = 20;
wbrd = 10;
wbox = 15;
wpad = 25;
warr = 20;
fsz = 8;
htxt = 14;
hedit = 20;
hpop = 22;
wedit0 = 40;
bgclr = [0,0,0];
fgclr = [1,1,1];
wintitle = 'Experiment settings';
ttl0 = 'Import';
ttl1 = 'Channels';
ttl2 = 'Lasers';
ttl3 = 'Calculations';
ttl4 = 'File structure';
ttl5 = 'Divers';

% get initial guidata
h0 = guidata(h_fig0);

% control existing figure
if isfield(h0,'figure_setExpSet') && ishandle(h0.figure_setExpSet)
    return
end

% get table of character pixel widths
tbl = h0.charDimTable;

% store defaults in h structure
h = struct('un',un,'fun',fun,'mg',mg,'mgtab',mgtab,'mgpan',mgpan,'wbrd',...
    wbrd,'wpad',wpad,'wbox',wbox,'fsz',fsz,'htxt',htxt,'hedit',hedit,...
    'hpop',hpop,'wedit0',wedit0,'warr',warr);
h.tbl = tbl;
h.bgclr = bgclr;
h.fgclr = fgclr;
h.figure_MASH = h_fig0;

% dimensions
wtab = wfig-2*mg;
htab = hfig-2*mg;

% build figure
pos0 = getPixPos(h_fig0);
x = pos0(1)+(pos0(3)-wfig)/2;
y = pos0(2)+(pos0(4)-hfig)/2;
h_fig = figure('units',un,'numbertitle','off','menubar','none','name',...
    wintitle,'position',[x,y,wfig,hfig],'userdata',proj);
h.figure = h_fig;
h0.figure_setExpSet = h_fig;
guidata(h_fig0,h0);
h_fig.CloseRequestFcn = ...
    {@figure_setExpSet_CloseRequestFcn,h_fig,h_fig0,h0,0};

x = mg;
y = hfig-mg-htab;

h.tabg = uitabgroup('parent',h_fig,'units',un,'position',[x,y,wtab,htab]);
if ~strcmp(dat2import,'sim')
    if ~isempty(dat2import)
        h.tab_imp = uitab('parent',h.tabg,'units',un,'title',ttl0);
        h.tab_chan = uitab('parent',h.tabg,'units',un,'title',ttl1);
        h.tab_exc = uitab('parent',h.tabg,'units',un,'title',ttl2);
    end
    h.tab_calc = uitab('parent',h.tabg,'units',un,'title',ttl3);
    if strcmp(dat2import,'trajectories')
        h.tab_fstrct = uitab('parent',h.tabg,'units',un,'title',ttl4);
    end
end
h.tab_div = uitab('parent',h.tabg,'units',un,'title',ttl5);

if ~strcmp(dat2import,'sim')
    if ~isempty(dat2import)
        h = build_setExpSetTabImport(h,dat2import,h_fig0);
        h = build_setExpSetTabChan(h,proj.nb_channel);
        h = build_setExpSetTabExc(h,proj.nb_excitations,h_fig0);
    end
    if strcmp(dat2import,'trajectories')
        h = build_setExpSetTabFstrct(h,proj.excitations);
    end
    h = build_setExpSetTabCalc(h);
end
h = build_setExpSetTabDiv(h,dat2import,h_fig0);

guidata(h_fig,h);

setProp([h_fig,h_fig.Children],'units','normalized');

ud_expSetWin(h_fig);

