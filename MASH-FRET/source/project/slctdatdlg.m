function dat = slctdatdlg(h_fig0)

% default
htxt = 20;
mg = 20;
wbut = 100;
hbut = 150;
un = 'pixels';
fntun = 'points';
fntsz = 11;
str0 = 'How to start the new project?';
dlgtitle = 'New project';
img0 = 'logo-simdat.png';
img1 = 'logo-impvid.png';
img2 = 'logo-imptraj.png';

% control existing figure
h = guidata(h_fig0);
if isfield(h,'figure_datSlc') && ishandle(h.figure_datSlct)
    return
end

% dimensions
wfig = 4*mg+3*wbut;
hfig = 3*mg+htxt+hbut;
wtxt0 = wfig-2*mg;

% images
pname = [fileparts(mfilename('fullpath')),filesep];
cdat0 = imread([pname,img0]);
cdat1 = imread([pname,img1]);
cdat2 = imread([pname,img2]);

% build dialog box
pos0 = getPixPos(h_fig0);
x = pos0(1)+(pos0(3)-wfig)/2;
y = pos0(2)+(pos0(4)-hfig)/2;
h_fig = figure('name',dlgtitle,'menubar','none','numbertitle','off',...
    'units',un,'position',[x,y,wfig,hfig],'windowstyle','modal','userdata',...
    0);
set(h_fig,'closerequestfcn',...
    {@figure_slctdatdlg_CloseRequestFcn,h_fig,h_fig0,0});

x = mg;
y = hfig-mg-htxt;

uicontrol('parent',h_fig,'style','text','units',un,'fontunits',fntun,...
    'fontsize',fntsz,'position',[x,y,wtxt0,htxt],'string',str0);

y = y-mg-hbut;

uicontrol('parent',h_fig,'style','pushbutton','units',un,'position',...
    [x,y,wbut,hbut],'cdata',cdat0,'callback',...
    {@figure_slctdatdlg_CloseRequestFcn,h_fig,h_fig0,1});

x = x+wbut+mg;

uicontrol('parent',h_fig,'style','pushbutton','units',un,'position',...
    [x,y,wbut,hbut],'cdata',cdat1,'callback',...
    {@figure_slctdatdlg_CloseRequestFcn,h_fig,h_fig0,2});

x = x+wbut+mg;

uicontrol('parent',h_fig,'style','pushbutton','units',un,'position',...
    [x,y,wbut,hbut],'cdata',cdat2,'callback',...
    {@figure_slctdatdlg_CloseRequestFcn,h_fig,h_fig0,3});

% save figure handle
h.figure_datSlct = h_fig;
guidata(h_fig0,h);

% wait for figure to close
uiwait(h_fig);

% return selected data
dat = h_fig0.UserData;

% reset modifications
h = guidata(h_fig0);
h = rmfield(h,'figure_datSlct');
guidata(h_fig0,h);
h_fig0.UserData = [];


function figure_slctdatdlg_CloseRequestFcn(obj,evd,h_fig,h_fig0,dat)
h_fig0.UserData = dat;
delete(h_fig);



