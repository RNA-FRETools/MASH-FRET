function openExpTtpr(fig0)

% Last update, 16.2.2020 by MH: save callbacks to separate files
% update, 10.4.2019 by MH: (1) link the "infos" button to online documentation (2) improve trace section (change "ASCII(*.txt)" trace file format to "customed format(*.txt)" and "VbFRET" to "vbFRET", improve informative text about the number of trace file per molecules and which traces are exported) (3) improve figure section (add informative text about the number of pages exported in one figure file depending on the chosen format, correct panel title's font weight to bold, correct extra space in GUI)
% update, 24.4.2018 by FS: add popup for exporting tagged molecules individually

% defaults
fignm = 'Export options';
ttl0 = 'Time traces';
ttl1 = 'Histograms';
ttl2 = 'Dwell-time files';
ttl3 = 'Figures';
str0 = 'If no other mention, one set of file is exported for each molecule';
str1 = 'save sel. mol. only';
str2 = 'Cancel';
str3 = 'Next >>';

h = guidata(fig0);
p = h.param;
proj = p.curr_proj;
tagNames = p.proj{proj}.molTagNames;
tagClr = p.proj{proj}.molTagClr;
q = h.dimprm;
q.hbut0 = 22;

str4 = getStrPopTags(tagNames,tagClr);
str4 = [str4, 'all molecules'];

% dimensions
wtxt0 = getUItextWidth(str0,q.fntun,q.fntsz1,'normal',q.tbl);
wcb0 = getUItextWidth(str1,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wpop0 = getUItextWidth(maxlengthstr(removeHtml(str4)),q.fntun,q.fntsz1,...
    'normal',q.tbl)+q.warr;
wbut0 = getUItextWidth(str2,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbrd;
wbut1 = getUItextWidth(str3,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbrd;

% GUI
fig = figure('NumberTitle', 'off', 'MenuBar', 'none', 'Name', fignm, ...
    'Visible', 'off', 'Units', q.posun, 'CloseRequestFcn', ...
    {@figure_optExpTr_CloseRequestFcn, fig0}, 'resize','off');
h.optExpTr.figure_optExpTr = fig;

h.optExpTr.text_infos = uicontrol('Style', 'text', 'Parent', fig, 'Units', ...
    q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', str0, ...
    'ForegroundColor', [0 0 1], 'Position', [0,0,wtxt0,q.htxt0], ...
    'HorizontalAlignment', 'left');

pan0 = uipanel('Parent', fig, 'Units', q.posun, 'FontUnits', q.fntun, ...
    'FontSize', q.fntsz1, 'Title', ttl0, 'FontWeight', 'bold');
h.optExpTr.uipanel_traces = pan0;
h = build_TPexport_panelTimeTraces(h,q);

pan1 = uipanel('Parent', fig, 'Units', q.posun, 'FontUnits', q.fntun, ...
    'FontSize', q.fntsz1, 'Title', ttl1, 'FontWeight', 'bold');
h.optExpTr.uipanel_hist = pan1;
h = build_TPexport_panelHistogram(h,q);

pan2 = uipanel('Parent', fig, 'Units', q.posun, 'FontUnits', q.fntun, ...
    'FontSize', q.fntsz1, 'Title', ttl2, 'FontWeight', 'bold');
h.optExpTr.uipanel_dt = pan2;
h = build_TPexport_panelDwelltimes(h,q);

pan3 = uipanel('Parent', fig, 'Units', q.posun, 'FontUnits', q.fntun, ...
    'FontSize', q.fntsz1, 'Title', ttl3, 'FontWeight','bold');
h.optExpTr.uipanel_fig = pan3;
h = build_TPexport_panelFigures(h,q);

x = 2*q.mg;
y = q.mg;

h.optExpTr.checkbox_molValid = uicontrol('Style', 'checkbox', 'Parent', ...
    fig, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str1, 'Callback', {@checkbox_molValid_Callback, fig0}, ...
    'Position', [x,y,wcb0,q.hbut0]);

% popup for exporting tagged molecules individually; 
% added by FS, 24.4.2018
x = x+wcb0+q.mg;

h.optExpTr.popup_molTagged = uicontrol('Style', 'popup', 'Parent', ...
    fig, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str4, 'Value', length(str4), 'Callback', ...
    {@popup_molTagged_Callback, fig0}, 'Position', [x,y,wpop0,q.hbut0]);
guidata(fig0,h);
popup_molTagged_Callback(h.optExpTr.popup_molTagged, [], fig0);
h = guidata(fig0);

h.optExpTr.pushbutton_cancel = uicontrol('Style', 'pushbutton', 'Parent', ...
    fig, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'Position', [0,0,wbut0 q.hbut0], 'String', str2, 'Callback', ...
    {@pushbutton_cancel_Callback, fig0});

guidata(fig0,h);
h.optExpTr.pushbutton_help = setInfoIcons(h.optExpTr.pushbutton_cancel,...
    fig0,h.param.infos_icon_file);

h.optExpTr.pushbutton_next = uicontrol('Style', 'pushbutton', 'Parent', ...
    fig, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'Position', [0,0,wbut1,q.hbut0], 'String', str3, 'Callback', ...
    {@pushbutton_next_Callback, fig0});

% adjust positions and figure dimensions
wpanl = max([pan0.Position(3),pan1.Position(3)]);
wpanr = max([pan2.Position(3),pan3.Position(3)]);
wfig = max([wpanl+wpanr+3*q.mg,wtxt0+2*q.mg]);
hfig = q.htxt0+q.hbut0+max([(pan0.Position(4)+pan1.Position(4)),...
    (pan2.Position(4)+pan3.Position(4))])+5*q.mg;

pos0 = getPixPos(fig0);
xfig = pos0(1)+(pos0(3)-wfig)/2;
yfig = pos0(2)+(pos0(4)-hfig)/2;
if hfig > pos0(4)
    yfig = pos0(4)+(pos0(4)-hfig);
end
fig.Position = [xfig,yfig,wfig,hfig];

% position figure's children
x = q.mg;
y = hfig-q.mg-q.htxt0;
h.optExpTr.text_infos.Position([1,2]) = [x,y];

y = y-q.mg-pan0.Position(4);
pan0.Position([1,2,3]) = [q.mg,y,wpanl];

y = y-q.mg-pan1.Position(4);
pan1.Position([1,2,3]) = [x,y,wpanl];

x = 2*q.mg+wpanl;
y = hfig-2*q.mg-q.htxt0-pan2.Position(4);
pan2.Position([1,2,3]) = [x,y,wpanr];

y = y-q.mg-pan3.Position(4);
pan3.Position([1,2,3]) = [x,y,wpanr];

x = wfig-q.mg-wbut1-q.mg-wbut0;
y = q.mg;
h.optExpTr.pushbutton_cancel.Position([1,2]) = [x,y];

x = x+q.mg+wbut0;
h.optExpTr.pushbutton_next.Position([1,2]) = [x,y];

% save handles and update interface
guidata(fig0, h);
ud_optExpTr('all', fig0);


