function h = build_TPexport_panelFigures(h,q)

% defaults
str0 = 'Export figures';
str1 = 'Export format:';
str3 = {'Portable Document Format(.pdf)',...
    'Portable Network Graphics(.png)',...
    'Joint Photo. Experts Group(.jpeg)'};
str4 = {'All pages in on file.', ...
    'One file per page.', ...
    'One file per page.'};
str5 = 'molecules per page:';
str6 = 'molecule sub-images';
str7 = 'intensity trajectories:';
str10 = 'ratio trajectories:';
str12 = 'histogram axes';
str13 = 'include disctretised traces';
str14 = 'Preview';
str15 = 'No figure file';

% collect project parameters
p = h.param;
proj = p.curr_proj;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
exc = p.proj{proj}.excitations;
labels = p.proj{proj}.labels;
clr = p.proj{proj}.colours;
plotchan = p.proj{proj}.TP.fix{1}(1);

% get colored channel/laser/ratio popup strings
str8 = getStrPop('plot_exc', exc);
str9 = getStrPop('plot_topChan',{labels plotchan clr{1}});
str11 = getStrPop('plot_botChan',{FRET S exc clr labels});

% parents
fig0 = h.figure_MASH;
pan = h.optExpTr.uipanel_fig;

% dimensions
wrb0 = getUItextWidth(str0,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wrb1 = getUItextWidth(str15,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wtxt0 = getUItextWidth(str1,q.fntun,q.fntsz1,'normal',q.tbl);
wtxt1 = getUItextWidth(maxlengthstr(str4),q.fntun,q.fntsz1,'normal',q.tbl);
wtxt2 = getUItextWidth(str5,q.fntun,q.fntsz1,'normal',q.tbl);
wcb0 = getUItextWidth(str6,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wcb1 = getUItextWidth(maxlengthstr({str7,str10}),q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wpop1 = getUItextWidth(maxlengthstr(str8),q.fntun,q.fntsz1,'normal',q.tbl)+q.warr;
wpop2 = getUItextWidth(maxlengthstr(removeHtml(str9)),q.fntun,q.fntsz1,'normal',q.tbl)+q.warr;
wpop3 = max([getUItextWidth(maxlengthstr(removeHtml(str11)),q.fntun,...
    q.fntsz1,'normal',q.tbl)+q.warr,wpop1+q.mg/2+wpop2]);
wpop1 = (wpop3-q.mg/2)*wpop1/(wpop1+wpop2);
wpop2 = wpop3-wpop1-q.mg/2;
wpop0 = wcb1+wpop3-wtxt0;
wcb2 = getUItextWidth(str12,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wcb3 = getUItextWidth(str13,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wbut0 = getUItextWidth(str14,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbrd;

wpan = 2*q.mg+max([wrb0,wrb1,wtxt0+wpop0,wtxt1,wtxt2+q.wedit0,wcb0,...
    wcb1+wpop3,q.mg+wcb2,q.mg+wcb3,wbut0]);
hpan = q.mg+4*(q.mg+q.hedit0)+q.mg/2+q.htxt0+4*(q.mg/2+q.hedit0)+q.mg+...
    q.hbut0+q.mg;

pan.Position([3,4]) = [wpan,hpan];

% GUI
x = q.mg;
y = hpan - 2*q.mg - q.hedit0;

h.optExpTr.radiobutton_saveFig = uicontrol('Style', 'radiobutton', ...
    'Parent', pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', ...
    q.fntsz1, 'String', str0, 'Position', [x y wrb0 q.hedit0], 'Callback', ...
    {@radiobutton_saveFig_Callback, fig0});

x = q.mg;
y = y - q.mg - q.hedit0;

h.optExpTr.text_figFmt = uicontrol('Style', 'text', 'Parent', pan, 'Units', ...
    q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', str1, ...
    'Position', [x y wtxt0 q.htxt0], 'HorizontalAlignment', 'left');

x = x + wtxt0;

h.optExpTr.popupmenu_figFmt = uicontrol('Style', 'popupmenu', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str3, 'Position', [x y wpop0 q.hedit0], 'Callback', ...
    {@popupmenu_figFmt_Callback, fig0});

x = q.mg;
y = y - q.mg/2 - q.htxt0;

h.optExpTr.text_figInfos = uicontrol('Style', 'text', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'UserData', str4, 'Position', [x y wtxt1 q.htxt0], 'ForegroundColor', ...
    [0 0 1], 'HorizontalAlignment', 'left');

y = y - q.mg - q.hedit0;

h.optExpTr.text_nMol = uicontrol('Style', 'text', 'Parent', pan, 'Units', ...
    q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', str5, ...
    'Position', [x y wtxt2 q.htxt0], 'HorizontalAlignment', 'left');

x = x + wtxt2;

h.optExpTr.edit_nMol = uicontrol('Style', 'edit', 'Parent', pan, 'Units', ...
    q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'Position', ...
    [x y q.wedit0 q.hedit0], 'Callback', {@edit_nMol_Callback, fig0});

x = q.mg;
y = y - q.mg - q.hedit0;

h.optExpTr.checkbox_subImg = uicontrol('Style', 'checkbox', 'Parent', pan, ...
    'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', ...
    str6, 'Position', [x y wcb0 q.hedit0], 'Callback', ...
    {@checkbox_subImg_Callback, fig0});

y = y - q.mg/2 - q.hedit0;

h.optExpTr.checkbox_top = uicontrol('Style', 'checkbox', 'Parent', pan, ...
    'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', ...
    str7, 'Callback', {@checkbox_top_Callback, fig0}, 'Position', ...
    [x y wcb1 q.hedit0]);

x = x + wcb1;

h.optExpTr.popupmenu_topExc = uicontrol('Style', 'popupmenu', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str8, 'Position', [x y wpop1 q.hedit0], 'Callback', ...
    {@popupmenu_topExc_Callback, fig0});

x = x + q.mg/2 + wpop1;

h.optExpTr.popupmenu_topChan = uicontrol('Style', 'popupmenu', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str9, 'Position', [x y wpop2 q.hedit0], 'Callback', ...
    {@popupmenu_topChan_Callback, fig0});

x = q.mg;
y = y - q.mg/2 - q.hedit0;

h.optExpTr.checkbox_bottom = uicontrol('Style', 'checkbox', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str10, 'Callback', {@checkbox_bottom_Callback, fig0}, ...
    'Position', [x y wcb1 q.hedit0]);

x = x + wcb1;

h.optExpTr.popupmenu_botChan = uicontrol('Style', 'popupmenu', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str11, 'Position', [x y wpop3 q.hedit0], 'Callback', ...
    {@popupmenu_botChan_Callback, fig0});

x = 2*q.mg;
y = y - q.mg/2 - q.hedit0;

h.optExpTr.checkbox_figHist = uicontrol('Style', 'checkbox', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str12, 'Callback', {@checkbox_figHist_Callback, fig0}, ...
    'Position', [x y wcb2 q.hedit0]);

y = y - q.mg/2 - q.hedit0;

h.optExpTr.checkbox_figDiscr = uicontrol('Style', 'checkbox', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str13, 'Position', [x y wcb3 q.hedit0], 'Callback', ...
    {@checkbox_figDiscr_Callback, fig0});

x = wpan - q.mg - wbut0;
y = y - q.mg - q.hbut0;

h.optExpTr.pushbutton_preview = uicontrol('Style', 'pushbutton', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'Position', [x y wbut0 q.hbut0], 'String', str14, 'Callback', ...
    {@pushbutton_preview_Callback, fig0});

x = q.mg;
y = q.mg;

h.optExpTr.radiobutton_noFig = uicontrol('Style', 'radiobutton', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str15, 'Position', [x y wrb1 q.hedit0], 'Callback', ...
    {@radiobutton_noFig_Callback, fig0});