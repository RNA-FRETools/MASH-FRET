function obj = buildActionPanel(h_fig)

% h_fig = buildActionPanel;
%
% Creates GUI of action panel
%
% h_fig: handle to action panel figure

% default
posun = 'normalized';
fntun = 'points';
fntsz = 8;
postxt = [0,0,1,1];
figname = 'History';
openmsg = {cat(2,'--- WELCOME ----------------------------------------',...
    '--------------------')};

% get main figure position
opos = get(h_fig,'outerposition');

% build action panel figure
obj = figure('units',posun,'numbertitle','off','menubar','none','name',...
    figname,'outerposition',[opos(1),0,opos(3),1-opos(4)]);
set(obj,'closerequestfcn',@figureActPan_CloseRequestFcn,'resizefcn',...
    @figureActPan_ResizeFcn);

% build action list
h.text_actions = uicontrol('style','listbox','units',posun,'fontunits',...
    fntun,'fontsize',fntsz,'position',postxt,'listboxtop',1,'max',2,'min',...
    0,'enable','inactive','string',openmsg);

% save figure handles
h.output = obj;
h.figure_MASH = h_fig;

guidata(obj, h);


