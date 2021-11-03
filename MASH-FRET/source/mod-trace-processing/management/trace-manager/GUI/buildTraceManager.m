function h_fig2 = buildTraceManager(h_fig)
% Build Trace manage figure

% Last update by MH, 24.8.2019
% >> solve issue in "View of video": video was shown upside down.
%
% update by MH, 24.4.2019
% >> add toolbar and empty tools "Auto sorting" and "View of video"
% >> rename "Overview" panel in "Molecule selection"
%
% update: by FS, 24.4.2018
% >> add debugging mode where all other windows are not deactivated
% >> add edit box to define a molecule tag
% >> add popup menu to select molecule tag
% >> add popup menu to select molecule tag
%
% update: by RB, 5.1.2018
% >> new pushbutton to inverse the selection of individual molecules
% >> add "to do" section: include y-axes control for FRET-S-Histogram
%
% update: by RB, 3.1.2018
% >> adapt width of popupmenu for FRET-S-Histogram 
%
% update: by RB, 15.12.2017
% >> update popupmenu_axes1 and popupmenu_axes2 string

% defaults
fact = 5;
defNperPage = 3;
debugMode = 1;
posun = 'pixels';
fntun = 'pixels';
bgcol = [0.94 0.94 0.94];
wfig = 900; 
hfig = 800; % figure dimensions
mg = 10; % margin
mgbig = 20;
fntsz = 10.6666666; % font size
fntsz2 = 12; % font size
hbut2 = 30; 
wbut2 = 120; % large pushbutton dimension
hpop = 22;
hbut = 22;
hcb = 20; 
wcb = 200; 
wcb2 = 60;
hedit = 20; 
wedit = 40; % edit field dimensions
htxt = 14; % text y-dimension
wtxt1 = 65; % medium text x-dimension
wtxt2 = 105; % large text x-dimension
wtxt3 = 32; % small text x-dimension
wbrd = 4;
warr = 20;
str0 = 'Overview';
str1 = 'Auto sorting';
str2 = 'View on video';
ttl0 = 'Trace manager - ';
ttl1 = 'Overall plots';
ttl2 = 'Molecule selection';

prm = struct('mg',mg,'mgbig',mgbig,'posun',posun,'fntun',fntun,'fntsz',...
    fntsz,'hpop',hpop,'hbut',hbut,'hbut2',hbut2,'hcb',hcb,'hedit',hedit,...
    'htxt',htxt,'wedit',wedit,'wcb',wcb,'wcb2',wcb2,'wtxt1',wtxt1,'wtxt2',...
    wtxt2,'wtxt3',wtxt3,'wbut2',wbut2,'defNperPage',defNperPage,'wbrd',...
    wbrd,'warr',warr);

% get reference table lisitng character widths 
h = guidata(h_fig);
prm.tbl = h.charDimTable;

% get MASH figure dimensions
posfig = getPixPos(h_fig);
posscr = getPixPos(0);

% set panels dimensions
wpan = wfig - 2*mg;
htool = hbut2 + 2*mg;
hpan1 = 1.5*mg + hpop + mg/2 + htxt + hpop + mg/2 + hedit + mg/fact + ...
    hedit + mg/2 + hbut + mg;
hpan2 = hfig - 2*mg - hpan1 - htool;
hpan3 = hfig - htool + mg;

% get the number of molecules displayed
N = numel(h.tm.molValid);
if N<defNperPage
    N_disp = N;
else
    N_disp = defNperPage;
end

x = posfig(1) + (posfig(3) - wfig)/2;
y = min([hfig posscr(4)]) - hfig;

% create TM figure
h.tm.figure_traceMngr = figure('Visible','off','Units',posun,'Position',...
    [x y wfig hfig],'Color',bgcol,'NumberTitle','off','MenuBar','none',...
    'CloseRequestFcn',{@figure_traceMngr_CloseRequestFcn,h_fig},'Name',...
    [ttl0,get(h_fig,'Name')],'WindowButtonUpFcn',...
    {@figure_traceMngr_WindowButtonUpFcn,h_fig});
h_fig2 = h.tm.figure_traceMngr;

% add debugging mode where all other windows are not deactivated
% added by FS, 24.4.2018
if ~debugMode
    set(h_fig2, 'WindowStyle', 'modal')
end

x = mg;
y = hfig - mg - hbut2;

h.tm.togglebutton_overview = uicontrol('style','togglebutton','parent',...
    h_fig2,'units',posun,'position',[x,y,wbut2,hbut2],'string',str0,...
    'fontweight','bold','fontunits',fntun,'fontsize',fntsz2,'callback',...
    {@switchPan_TM,h_fig});

x = x + wbut2 + mg;

h.tm.togglebutton_autoSorting = uicontrol('style','togglebutton','parent',...
    h_fig2,'units',posun,'position',[x,y,wbut2,hbut2],'string',str1,...
    'fontweight','bold','fontunits',fntun,'fontsize',fntsz2,'callback',...
    {@switchPan_TM,h_fig});

x = x + wbut2 + mg;

h.tm.togglebutton_videoView = uicontrol('style','togglebutton','parent',...
    h_fig2,'units',posun,'position',[x,y,wbut2,hbut2],'string',str2,...
    'fontweight','bold','fontunits',fntun,'fontsize',fntsz2,'callback',...
    {@switchPan_TM,h_fig});

guidata(h_fig,h);
h.tm.pushbutton_help = setInfoIcons(h.tm.togglebutton_videoView,h_fig,...
    h.param.infos_icon_file);


%% build main panels

x = mg;
y = y - mg - hpan1;

h.tm.uipanel_overall = uipanel('Parent',h_fig2,'Units',posun,'Position',...
    [x y wpan hpan1],'Title',ttl1,'FontUnits',fntun,'FontSize',fntsz);
h.tm = buildPanelOverAll(h.tm,prm,h_fig);

y = y - mg - hpan2;

h.tm.uipanel_overview = uipanel('Parent',h_fig2,'Units',posun,'Position',...
    [x y wpan hpan2],'Title',ttl2,'FontUnits',fntun,'FontSize',fntsz);
h.tm = buildPanelOverview(h.tm,prm,h_fig);

% save controls
guidata(h_fig, h);

% build controls and axes in panel "Molecule selection"
updatePanel_single(h_fig, N_disp);

% recover new controls
h = guidata(h_fig);

x = -mg;
y = hfig - mg - hbut2 - mg - hpan3;

h.tm.uipanel_autoSorting = uipanel('Parent',h_fig2,'Units',posun,...
    'Position', [x y wfig+2*mg hpan3],'Title','','FontUnits',fntun, ...
    'FontSize',fntsz,'Visible','off');
h.tm = buildPanelAutoSorting(h.tm,prm,h_fig);

h.tm.uipanel_videoView = uipanel('Parent',h_fig2,'Units',posun,'Position',...
    [x y wfig+2*mg hpan3],'Title','','FontUnits',fntun,'FontSize',...
    fntsz,'Visible','off');
h.tm = buildPanelVideoView(h.tm,prm,h_fig);

% save controls
guidata(h_fig,h);

% build controls and axes in panel "Video view"
updatePanel_VV(h_fig);

% recover new controls
h = guidata(h_fig);
    
    
%% save and finalize figure
    
% save controls
guidata(h_fig, h);

q = h.tm;
q.isDown = false;
q.figure_MASH = h_fig;
guidata(h_fig2,q);

% set all positions and dimensions to normalized 
setProp(get(h_fig2, 'Children'), 'Units', 'normalized');

% set all font units to pixels
setProp(get(h_fig2, 'Children'), 'FontUnits', fntun);

% store positions to used when reducing panel "Overall plot"
dat = get(h.tm.pushbutton_reduce, 'UserData');
pos_button = get(h.tm.pushbutton_reduce, 'Position');
pos_panelAll_open = get(h.tm.uipanel_overall, 'Position');
pos_panelSingle_open = get(h.tm.uipanel_overview, 'Position');
h_panelAll_close = pos_button(4);
dat.pos_all = [pos_panelAll_open(1) ...
    pos_panelAll_open(2)+pos_panelAll_open(4)-h_panelAll_close ...
    pos_panelAll_open(3) h_panelAll_close];% close
dat.pos_single = [pos_panelSingle_open(1) pos_panelSingle_open(2) ...
    pos_panelAll_open(3) (pos_panelSingle_open(4)+ ...
    pos_panelAll_open(4)-h_panelAll_close)];% close
set(h.tm.pushbutton_reduce, 'UserData', dat);

% build pointer manager
iptPointerManager(h_fig2,'enable');
pb.enterFcn = [];
pb.traverseFcn = @axes_histSort_traverseFcn;
pb.exitFcn = @axes_histSort_exitFcn;
iptSetPointerBehavior(h.tm.axes_histSort,pb);

% set jet colormap
colormap(h_fig2,'jet');

% switch to default tool interface
switchPan_TM(h.tm.togglebutton_overview,[],h_fig);
    
