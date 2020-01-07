function h_fig = buildMASHfig()
% h = buildMASHfig;
%
% Creates GUI of MASH including modules "Simulation", "Video processing", "Trace processing", "Histogram analysis" and "Transition analysis"
%
% h: structure containing handles to all UI components

% default
fname_ref = 'charDimTable.mat'; % reference file containing character pixel dimensions
fname_boba = 'boba.png'; % image file containing BOBA FRET icon
field_name = 'tbl'; % file's field containing character pixel dimensions
posun = 'pixels'; % position and dimension units
fntun = 'points'; % font units
fntsz1 = 8; % common font size
mg = 10; % common margin
mgpan = 20; % top margin inside a panel (includes title)
wbox = 15; % box width in checkboxes
wbrd = 4; % width of pushbutton borders
warr = 20; % width of downwards arrow in popupmenu
wttstr = 250; % width of tooltip box
fntclr1 = 'blue'; % text color in file/folder fields
fntclr2 = 'blue'; % text color in special pushbuttons
wbuth = 22;
hfig = 622;
wfig = 1024;
fntsz0 = 9;
hpan0 = 571;
hedit0 = 20;
hbut0 = 30;
wbut0 = 75;
wbut1 = 117;
wbut2 = 124;
wbut3 = 127;
lbl0 = 'View';
lbl1 = 'Routines';
lbl2 = 'Options';
lbl3 = 'Tools';
str0 = 'Simulation';
str1 = 'Video processing';
str2 = 'Trace processing';
str3 = 'Histogram analysis';
str4 = 'Transition analysis';
str5 = 'Destination:';
str6 = '...';
hndls = []; % handles to dummy figure and text: re-using the same figure/text control saves a considerable time
[ttstr0,hndls] = wrapStrToWidth('<b>Destination folder:</b> files will be automatically exported at this location.',fntun,fntsz1,'normal',wttstr,'html',hndls);
ttstr1 = wrapStrToWidth('<b>Open browser</b> to set the new location of the destination folder.',fntun,fntsz1,'normal',wttstr,'html',hndls);

% load reference table listing character widths
h.charDimTable = getfield(load(fname_ref),field_name);

% check if boba icon exists
[ico_pth,o,o] = fileparts(mfilename('fullpath'));
if exist([ico_pth,filesep,fname_boba],'file')
    fname_boba = [ico_pth,filesep,fname_boba];
else
    fname_boba = [];
end

% build often-used parameter structure
p = struct('posun',posun,'fntun',fntun,'fntsz1',fntsz1,'mg',mg,'mgpan',...
    mgpan,'wbrd',wbrd,'wbox',wbox,'warr',warr,'wttstr',wttstr,'fntclr1',...
    fntclr1,'fntclr2',fntclr2,'wbuth',wbuth,'hndls',hndls,'fname_boba',...
    fname_boba);
p.tbl = h.charDimTable; % table listing character pixel dimensions

% dimensions
set(0,'units','pixels');
pos0 = get(0,'monitorpositions');
xfig = (pos0(1,3)-wfig)/2;
yfig = (pos0(1,4)-hfig)/2;
[wtxt,htxt] = getUItextWidth(str5,fntun,fntsz1,'normal',p.tbl);
wbut4 = getUItextWidth(str6,fntun,fntsz1,'normal',p.tbl)+wbrd;
wedit = wfig-8*mg-wbut0-wbut1-2*wbut2-wbut3-wtxt-wbut4;

% GUI
%% main figure

h_fig = figure('units','pixels','numbertitle','off','menubar','none',...
    'position',[xfig,yfig,wfig,hfig],'visible','off');
set(h_fig,'closerequestfcn',@figure_MASH_CloseRequestFcn,...
    'sizechangedfcn',@figure_MASH_SizeChangedFcn);
h.figure_MASH = h_fig;


%% menus

h.menu_view = uimenu(h_fig,'label',lbl0);
h = buildMenuView(h);

h.menu_routine = uimenu(h_fig,'label',lbl1);
h = buildMenuRoutine(h);

h.menu_options = uimenu(h_fig,'label',lbl2);
h = buildMenuOptions(h);

h.menu_tools = uimenu(h_fig,'label',lbl3);
h = buildMenuTools(h);


%% tool bar
x = mg;
y = hpan0 + mg;

h.togglebutton_S = uicontrol('style','togglebutton','parent',h_fig,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wbut0,hbut0],'string',str0,'callback',...
    {@switchPan,h_fig});

x = x + wbut0 + mg;

h.togglebutton_VP = uicontrol('style','togglebutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wbut1,hbut0],'string',str1,'callback',...
    {@switchPan,h_fig});

x = x + wbut1 + mg;

h.togglebutton_TP = uicontrol('style','togglebutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wbut2,hbut0],'string',str2,'callback',...
    {@switchPan,h_fig});

x = x + wbut2 + mg;

h.togglebutton_HA = uicontrol('style','togglebutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wbut3,hbut0],'string',str3,'callback',...
    {@switchPan,h_fig});

x = x + wbut3 + mg;

h.togglebutton_TA = uicontrol('style','togglebutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wbut2,hbut0],'string',str4,'callback',...
    {@switchPan,h_fig});

x = x+wbut2+mg;
y = y+(hbut0-htxt)/2;

h.text_rootFOlder = uicontrol('style','text','parent',h_fig,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz1,'position',[x,y,wtxt,htxt],...
    'string',str5);

x = x + wtxt;
y = y-(hedit0-htxt)/2;

h.edit_rootFolder = uicontrol('style','edit','parent',h_fig,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz1,'position',[x,y,wedit,hedit0],...
    'callback',{@pushbutton_rootFolder_Callback,h_fig},'tooltipstring',...
    ttstr0,'foregroundcolor',p.fntclr1);

x = x + wedit + mg;

h.pushbutton_rootFolder = uicontrol('style','pushbutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wbut4,hedit0],'string',str6,'callback',...
    {@pushbutton_rootFolder_Callback,h_fig},'tooltipstring',ttstr1);

x = 0;
y = 0;

h.uipanel_S = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wfig,hpan0]);
h = buildPanelS(h,p);

h.uipanel_VP = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wfig,hpan0]);
h = buildPanelVP(h,p);

h.uipanel_TP = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wfig,hpan0]);
h = buildPanelTP(h,p);

h.uipanel_HA = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wfig,hpan0]);
h = buildPanelHA(h,p);

h.uipanel_TA = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wfig,hpan0]);
h = buildPanelTA(h,p);

% save dummy figure and text
h.figure_dummy = hndls(1);
h.text_dummy = hndls(2);

guidata(h_fig,h);

