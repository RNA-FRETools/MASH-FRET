function h = build_TPexport_panelDwelltimes(h,q)

% defaults
str0 = 'Export dwell-times';
str1 = 'Dwell-times to export:';
str2 = 'intensities (*_I.dt)';
str3 = 'FRET (*_FRET.dt)';
str4 = 'stoichiometries (*_S.dt)';
str5 = 'generate kinetic data (*.kin)';
str6 = 'No dwell-time file';

% parents
fig0 = h.figure_MASH;
pan = h.optExpTr.uipanel_dt;

% dimensions
wrb0 = getUItextWidth(str0,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wrb1 = getUItextWidth(str6,q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
wtxt0 = getUItextWidth(str1,q.fntun,q.fntsz1,'normal',q.tbl);
wcb0 = getUItextWidth(maxlengthstr({str2,str3,str4,str5}),...
    q.fntun,q.fntsz1,'normal',q.tbl)+q.wbox;
hpan = 2*q.mg+q.hedit0+q.mg+q.htxt0+2*(q.mg/2+q.hedit0)+3*(q.mg+q.hedit0)+...
    q.mg;
wpan = 2*q.mg+max([wrb0,wrb1,wtxt0,q.mg+wcb0]);

pan.Position([3,4]) = [wpan,hpan];

% GUI
x = q.mg;
y = hpan - 2*q.mg - q.hedit0;

h.optExpTr.radiobutton_saveDt = uicontrol('Style', 'radiobutton', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str0, 'Position', [x y wrb0 q.hedit0], 'Callback', ...
    {@radiobutton_saveDt_Callback, fig0});

y = y-q.mg-q.htxt0;

h.optExpTr.text_dt2exp = uicontrol('Style', 'text', 'Parent', pan, 'Units', ...
    q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', str1, ...
    'Position', [x y wtxt0 q.htxt0], 'HorizontalAlignment', 'left');

x = 2*q.mg;
y = y - q.mg - q.hedit0;

h.optExpTr.checkbox_dtI = uicontrol('Style', 'checkbox', 'Parent', pan, ...
    'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', ...
    str2, 'Callback', {@checkbox_dtI_Callback, fig0}, 'Position', ...
    [x y wcb0 q.hedit0]);

y = y - q.mg/2 - q.hedit0;

h.optExpTr.checkbox_dtFRET = uicontrol('Style', 'checkbox', 'Parent', pan, ...
    'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', ...
    str3, 'Callback', {@checkbox_dtFRET_Callback, fig0}, 'Position', ...
    [x y wcb0 q.hedit0]);

y = y - q.mg/2 - q.hedit0;

h.optExpTr.checkbox_dtS = uicontrol('Style', 'checkbox', 'Parent', pan, ...
    'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', ...
    str4, 'Callback', {@checkbox_dtS_Callback, fig0}, 'Position', ...
    [x y wcb0 q.hedit0]);

y = y - q.mg - q.hedit0;

h.optExpTr.checkbox_kin = uicontrol('Style', 'checkbox',  'Parent', pan, ...
    'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, 'String', ...
    str5, 'Callback', {@checkbox_kin_Callback, fig0}, 'Position', ...
    [x y wcb0 q.hedit0]);

x = q.mg;
y = y - q.mg - q.hedit0;

h.optExpTr.radiobutton_noDt = uicontrol('Style', 'radiobutton', 'Parent', ...
    pan, 'Units', q.posun, 'FontUnits', q.fntun, 'FontSize', q.fntsz1, ...
    'String', str6, 'Position', [x y wrb1 q.hedit0], 'Callback', ...
    {@radiobutton_noDt_Callback, fig0});