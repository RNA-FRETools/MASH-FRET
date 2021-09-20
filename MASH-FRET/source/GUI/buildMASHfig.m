function h_fig = buildMASHfig(varargin)
% h_fig = buildMASHfig
% h_fig = buildMASHfig(figureName)
%
% Creates GUI of MASH including modules "Simulation", "Video processing", "Trace processing", "Histogram analysis" and "Transition analysis"
%
% figureName: figure's title
% h_fig: handle to main figure

% Last update by MH, 19.3.2020: increase speed by replacing wrapStrToWidth by wrapHtmlTooltipString

% default
fname_ref = 'charDimTable.mat'; % reference file containing character pixel dimensions
fname_boba = 'boba.png'; % image file containing BOBA FRET icon
field_name = 'tbl'; % file's field containing character pixel dimensions
posun = 'pixels'; % position and dimension units
fntun = 'points'; % font units
fntsz1 = 8; % common font size
mg = 10; % common margin
mgpan = 20; % top margin inside a panel (includes title)
mgtab = 15; % top margin inside a tabbed panel (includes header)
wbox = 15; % box width in checkboxes
wbrd = 4; % width of pushbutton borders
warr = 20; % width of downwards arrow in popupmenu
fntclr1 = 'blue'; % text color in file/folder fields
fntclr2 = 'blue'; % text color in special pushbuttons
wbuth = 25;
hfig = 622;
wfig = 1024;
wlst_norm = 0.1530; % width of project list (normalized units)
hlst_norm = 0.1693; % height of project list (normalized units)
fact = 5;
fntsz0 = 9;
hedit0 = 20;
hbut0 = 30;
hbut1 = 25;
wbut1 = 25;
file_icon0 = 'new_file.png';
file_icon1 = 'open_file.png';
file_icon2 = 'close_file.png';
file_icon3 = 'save_file.png';
file_icon4 = 'edit_file.png';
lbl1 = 'Routines';
lbl2 = 'Options';
lbl3 = 'Tools';
str0 = 'Simulation';
str1 = 'Video processing';
str2 = 'Trace processing';
str3 = 'Histogram analysis';
str4 = 'Transition analysis';
str6 = '...';
ttstr0 = wrapHtmlTooltipString('<b>Root directory:</b> default destination to export files to');
ttstr1 = wrapHtmlTooltipString('Browse directories...');
ttstr2 = wrapHtmlTooltipString('<b>New</b> project');
ttstr3 = wrapHtmlTooltipString('<b>Open</b> project...');
ttstr4 = wrapHtmlTooltipString('<b>Close</b> project');
ttstr5 = wrapHtmlTooltipString('<b>Edit</b> project settings');
ttstr6 = wrapHtmlTooltipString('<b>Save</b> project as...');

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
    mgpan,'wbrd',wbrd,'wbox',wbox,'warr',warr,'fntclr1',fntclr1,'fntclr2',...
    fntclr2,'wbuth',wbuth,'fname_boba',fname_boba,'mgtab',mgtab);
p.tbl = h.charDimTable; % table listing character pixel dimensions

% dimensions
set(0,'units','pixels');
pos0 = get(0,'monitorpositions');
xfig = (pos0(1,3)-wfig)/2;
yfig = (pos0(1,4)-hfig)/2;
wlst = wfig*wlst_norm;
hlst = hfig*hlst_norm;
hedit1 = hfig-mg-hbut1-mg/fact-hlst-mg-hedit0-5*(mg+hbut0)-2*mg;
wpan0 = wfig-2*mg-wlst;
mgbut = (wlst-wbuth-mg-5*wbut1)/5;
wbut0 = getUItextWidth(str6,fntun,fntsz1,'normal',p.tbl)+wbrd;
wedit = wlst-wbut0;

% images
pname = [fileparts(mfilename('fullpath')),filesep];
img0 = imread([pname,file_icon0]);
img1 = imread([pname,file_icon1]);
img2 = imread([pname,file_icon2]);
img3 = imread([pname,file_icon3]);
img4 = imread([pname,file_icon4]);

% GUI
%% main figure

h_fig = figure('units','pixels','numbertitle','off','menubar','none',...
    'position',[xfig,yfig,wfig,hfig],'visible','on');
set(h_fig,'closerequestfcn',@figure_MASH_CloseRequestFcn,...
    'sizechangedfcn',@figure_MASH_SizeChangedFcn,'windowbuttonupfcn',...
    @figure_MASH_WindowButtonUpFcn);
if ~isempty(varargin)
    set(h_fig, 'Name', varargin{1});
end
h.figure_MASH = h_fig;


%% menus
h.menu_routine = uimenu(h_fig,'label',lbl1);
h = buildMenuRoutine(h);

h.menu_options = uimenu(h_fig,'label',lbl2);
h = buildMenuOptions(h);

h.menu_tools = uimenu(h_fig,'label',lbl3);
h = buildMenuTools(h);


%% side bar
x = mg;
y = hfig-mg-hbut1;

h.pushbutton_newProj = uicontrol('style','pushbutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hbut1],'string','','callback',...
    {@pushbutton_newProj_Callback,h_fig},'tooltipstring',ttstr2,...
    'cdata',img0);

x = x+wbut1+mgbut;

h.pushbutton_openProj = uicontrol('style','pushbutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hbut1],'string','','callback',...
    {@pushbutton_openProj_Callback,h_fig},'tooltipstring',ttstr3,...
    'cdata',img1);

x = x+wbut1+mgbut;

h.pushbutton_closeProj = uicontrol('style','pushbutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wbut1,hbut1],'string','','tooltipstring',ttstr4,'callback',...
    {@pushbutton_closeProj_Callback,h_fig},'cdata',img2);

x = x+wbut1+mgbut;

h.pushbutton_editProj = uicontrol('style','pushbutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wbut1,hbut1],'string','','tooltipstring',ttstr5,'callback',...
    {@pushbutton_editParam_Callback,h_fig},'cdata',img4);

x = x+wbut1+mgbut;

h.pushbutton_saveProj = uicontrol('style','pushbutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'fontweight',...
    'bold','position',[x,y,wbut1,hbut1],'string','','callback',...
    {@pushbutton_saveProj_Callback,h_fig},'tooltipstring',ttstr6,'cdata',...
    img3);

x = p.mg;
y = y-p.mg/fact-hlst;

h.listbox_proj = uicontrol('style','listbox','parent',h_fig,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz1,'position',[x,y,wlst,hlst],...
    'string',{''},'callback',{@listbox_projLst_Callback,h_fig},...
    'min',0,'max',2);

y = y-mg-hedit0;

h.edit_rootFolder = uicontrol('style','edit','parent',h_fig,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz1,'position',[x,y,wedit,hedit0],...
    'callback',{@pushbutton_rootFolder_Callback,h_fig},'tooltipstring',...
    ttstr0,'foregroundcolor',p.fntclr1,'horizontalalignment','right',...
    'callback',{@edit_rootFolder_Callback,h_fig});

x = x + wedit;

h.pushbutton_rootFolder = uicontrol('style','pushbutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz1,'position',...
    [x,y,wbut0,hedit0],'string',str6,'callback',...
    {@pushbutton_rootFolder_Callback,h_fig},'tooltipstring',ttstr1);

x = mg;
y = y-p.mg-hbut0;

h.togglebutton_S = uicontrol('style','togglebutton','parent',h_fig,'units',...
    posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wlst,hbut0],'string',str0,'callback',...
    {@switchPan,h_fig});

y = y-p.mg-hbut0;

h.togglebutton_VP = uicontrol('style','togglebutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wlst,hbut0],'string',str1,'callback',...
    {@switchPan,h_fig});

y = y-p.mg-hbut0;

h.togglebutton_TP = uicontrol('style','togglebutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wlst,hbut0],'string',str2,'callback',...
    {@switchPan,h_fig});

y = y-p.mg-hbut0;

h.togglebutton_HA = uicontrol('style','togglebutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wlst,hbut0],'string',str3,'callback',...
    {@switchPan,h_fig});

y = y-p.mg-hbut0;

h.togglebutton_TA = uicontrol('style','togglebutton','parent',h_fig,...
    'units',posun,'fontunits',fntun,'fontsize',fntsz0,'fontweight','bold',...
    'position',[x,y,wlst,hbut0],'string',str4,'callback',...
    {@switchPan,h_fig});

y = y-p.mg-hedit1;

h.edit_actPan = uicontrol('style','edit','parent',h_fig,'units',posun,...
    'fontunits',fntun,'fontsize',fntsz1,'max',2,'position',...
    [x,y,wlst,hedit1],'enable','inactive','horizontalalignment','left',...
    'fontname','FixedWidth');

x = mg+wlst+mg;
y = 0;

h.uipanel_S = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wpan0,hfig]);
h = buildPanelS(h,p);

h.uipanel_VP = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wpan0,hfig]);
h = buildPanelVP(h,p);

h.uipanel_TP = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wpan0,hfig]);
h = buildPanelTP(h,p);

h.uipanel_HA = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wpan0,hfig]);
h = buildPanelHA(h,p);

h.uipanel_TA = uipanel('parent',h_fig,'title','','units',posun,'position',...
    [x,y,wpan0,hfig]);
h = buildPanelTA(h,p);

% save dummy figure and text
h.figure_dummy = figure('name','dummy','visible','off');
h.text_dummy = uicontrol('style','text','parent',h.figure_dummy);

guidata(h_fig,h);

