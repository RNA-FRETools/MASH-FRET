function h_fig2 = buildGammaOpt(h_fig)

h = guidata(h_fig);
p = h.param;

% defaults
file_check = 'check.png';
file_notdef = 'notdefined.png';
posun = 'pixels';
fntun = 'points';
fntsz = 8;
mg = 10;
fact = 5;
wbrd = 4; % width of pushbutton borders
hedit0 = 20; 
hbut0 = 22;
htxt0 = 14;
hpop0 = 22;
wpic0 = 25;
haxes0 = 100;
figcol = [0.94 0.94 0.94];
str0 = 'data';
str1 = 'stop';
str2 = 'threshold';
str3 = 'subtract';
str4 = 'min. cutoff';
str5 = 'tolerance';
str6 = cat(2,char(947),' =');
str7 = 'Save and close';
ttl0 = 'Gamma factor options';
ttstr0 = 'Select the trace to detect photobleaching in';
ttstr1 = 'Threshold for photobleaching cutoff';
ttstr2 = 'Tolerance window around cutoff to observe intensity states before and after photobleaching';
ttstr3 = 'Save settings and export gamma factor to MASH';

% dimensions
posfig = getPixPos(h_fig);
pos0 = getPixPos(0);
wbut0 = getUItextWidth(str7,fntun,fntsz,'normal',h.charDimTable)+wbrd;
wedit1 = max([getUItextWidth(str1,fntun,fntsz,'normal',h.charDimTable),...
    getUItextWidth(str2,fntun,fntsz,'normal',h.charDimTable),...
    getUItextWidth(str3,fntun,fntsz,'normal',h.charDimTable),...
    getUItextWidth(str4,fntun,fntsz,'normal',h.charDimTable)]);
wtxt0 = getUItextWidth(str6,fntun,fntsz,'normal',h.charDimTable);
wpop0 = wtxt0+wedit1;
waxes0 = wpop0+5*(mg/fact+wedit1);
wedit0 = waxes0;
wfig = mg+waxes0+mg;
hfig = mg+hedit0+mg+haxes0+mg+htxt0+hpop0+mg+wpic0+mg;

% lists
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
exc = p.proj{proj}.excitations;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
clr = p.proj{proj}.colours;
labels = p.proj{proj}.labels;
fret = p.proj{proj}.TP.fix{3}(8);
str_dat = removeHtml(get(h.popupmenu_gammaFRET,'string'));
bgcol = clr{2}(fret,1:3);
fntcol = ones(1,3)*(sum(clr{2}(fret,1:3))<=1.5);
showCutoff = p.proj{proj}.TP.curr{mol}{6}{3}(fret,1);
c = p.proj{proj}.FRET(fret,2);
str_acc = getStrPop('bg_corr',{labels,exc,clr});
str_acc = str_acc(((1:nExc)-1)*nChan+c);

% axes
xlim0 = get(h.axes_top, 'Xlim');
ylim0 = get(h.axes_top, 'Ylim');

% get image and alpha data of icons
icons = cell(2,2);
[icons{1,1}, ~, icons{1,2}] = imread(file_check);
[icons{2,1}, ~, icons{2,2}] = imread(file_notdef);

q = struct();

x = posfig(1)+(posfig(3)-wfig)/2;
y = min([hfig pos0(4)]);

% Gamma factor options - subfigure
h.figure_gammaOpt = figure('Units', posun, ...
    'Position', [x y wfig hfig], ...
    'Color', figcol, ...
    'NumberTitle', 'off', ...
    'Menubar', 'none', ...
    'Name', ttl0, ...
    'Visible', 'on', ...
    'CloseRequestFcn', {@figure_gammaOpt_CloseRequestFcn,h_fig}, ...
    'ResizeFcn', @figure_gammaOpt_ResizeFcn); 
h_fig2 = h.figure_gammaOpt;

% add debugging mode where all other windows are not deactivated
% added by FS, 24.7.2018
debugMode = 1;
if ~debugMode
    set(h_fig2, 'WindowStyle', 'modal')
end

x = mg;
y = hfig-mg-hedit0;

% FRET pair tag
q.edit_pair = uicontrol('Style', 'edit', 'Parent', h_fig2, 'Units', posun,...
    'Position', [x y wedit0 hedit0], ...
    'String', str_dat{fret+1}, ...
    'BackgroundColor', bgcol, ...
    'ForegroundColor', fntcol, ...
    'Enable','inactive');

y = y-mg-haxes0;

q.axes_traces = axes('Parent', h_fig2, 'Units', posun, 'FontUnits', fntun, ...
    'FontSize', fntsz, 'Xlim', xlim0, 'Ylim', ylim0, 'NextPlot', ...
    'replacechildren');
h_axes = q.axes_traces;
pos = getRealPosAxes([x y waxes0 haxes0],get(h_axes,'TightInset'),'traces');
set(h_axes, 'Position', pos);

y = y-mg-htxt0;

% text data
q.text_data = uicontrol('Style', 'text', 'Parent', h_fig2, 'Units', posun, ...
    'FontUnits', fntun,...
    'Position', [x y wpop0 htxt0], ...
    'String', str0);

y = y-hpop0;

% data popupmenu
q.popupmenu_data = uicontrol('Style', 'popupmenu', 'Parent', h_fig2, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wpop0 hpop0], ...
    'String', str_acc, ...
    'TooltipString', ttstr0,...
    'Callback', {@popupmenu_data_pbGamma_Callback, h_fig, h_fig2});

x = x+wpop0+mg/fact;
y = y+(hpop0-hedit0)/2;

% edit stop
q.edit_stop = uicontrol('Style', 'edit', 'Parent', h_fig2, ...
    'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'Enable', 'inactive');

y = y-(hpop0-hedit0)/2+hpop0;

% text stop
q.text_stop = uicontrol('Style', 'text', 'Parent', h_fig2, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str1);

x = x+wedit1+mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

% edit threshold
q.edit_threshold = uicontrol('Style', 'edit', 'Parent', h_fig2, ...
    'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'TooltipString', ttstr1, ...
    'Callback', {@edit_pbGamma_threshold_Callback, h_fig, h_fig2});

y = y-(hpop0-hedit0)/2+hpop0;

% text threshold
q.text_threshold = uicontrol('Style', 'text', 'Parent', h_fig2, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str2);

x = x+wedit1+mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

% edit extra subtract
q.edit_extraSubstract = uicontrol('Style', 'edit', 'Parent', ...
    h_fig2, 'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'Callback', {@edit_pbGamma_extraSubstract_Callback, h_fig, h_fig2});

y = y-(hpop0-hedit0)/2+hpop0;

% text extra subtract
q.text_extraSubstract = uicontrol('Style', 'text', 'Parent', ...
    h_fig2, 'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str3);

x = x+wedit1+mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

% edit min cutoff
q.edit_minCutoff = uicontrol('Style', 'edit', 'Parent', h_fig2, ...
    'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'Callback', {@edit_pbGamma_minCutoff_Callback, h_fig, h_fig2});

y = y-(hpop0-hedit0)/2+hpop0;

% text min. cutoff
q.text_pbGamma_minCutoff = uicontrol('Style', 'text', 'Parent', h_fig2, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str4);

x = x+wedit1+mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

% edit tolerance
q.edit_tol = uicontrol('Style', 'edit', 'Parent', h_fig2, 'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'TooltipString', ttstr2, ...
    'Callback', {@edit_pbGamma_tol_Callback, h_fig, h_fig2});

y = y-(hpop0-hedit0)/2+hpop0;

% text min. cutoff
q.text_tol = uicontrol('Style', 'text', 'Parent', h_fig2, 'Units', posun, ...
    'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str5);

% cancelled by MH, 15.1.2020
% x = mg;
% y = y-hedit0-(wpic0-hedit0)/2-mg/2-hbut0+(hbut0-hedit0)/2;
% 
% % checkbox
% q.checkbox_showCutoff = uicontrol('Style', 'checkbox', 'Parent', h_pan, ...
%     'Units', posun, 'FontUnits', fntun,...
%     'Position', [x y wcb0 hedit0], ...
%     'String', str4,...
%     'Value', showCutoff,...
%     'TooltipString', ttstr0,...
%     'Callback', {@checkbox_showCutoff, h_fig, h_fig2});

x = mg;
y = y-hpop0-mg-wpic0+(wpic0-htxt0)/2;

% text gamma = 
q.text_gamma = uicontrol('Style', 'text', 'Parent', h_fig2, 'Units', posun, ...
    'FontUnits', fntun,...
    'Position', [x y wtxt0 htxt0], ...
    'String', str6, ...
    'HorizontalAlignment', 'left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

% edit gamma
q.edit_gamma = uicontrol('Style', 'edit', 'Parent', h_fig2, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 hedit0], ...
    'Callback', {@edit_pbGamma_gamma_Callback, h_fig2});

x = x+wedit1+mg;
y = y-(wpic0-hedit0)/2;

% check icon axis
q.axes_pbGamma = axes('Parent', h_fig2, 'Units', posun, ...
    'Position', [x y wpic0 wpic0], ...
    'UserData', icons, ...
    'Visible', 'off');

x = wfig-mg-wbut0;
y = y+(wpic0-hbut0)/2;

% pushbutton compute gamma factor
q.pushbutton_save = uicontrol('Style', 'pushbutton', 'Parent', ...
    h_fig2, 'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wbut0 hbut0], ...
    'String', str7,...
    'Value', showCutoff,...
    'TooltipString', ttstr3,...
    'Callback', {@pushbutton_computeGamma_Callback, h_fig, h_fig2});

% cancelled by MH, 15.1.2020
% x = x-mg/2-wbut0;
% 
% % pushbutton load gamma factors
% q.pushbutton_loadGamma = uicontrol('Style', 'pushbutton', 'Parent', ...
%     h_pan, 'Units', posun,...
%     'Position', [x y wbut0 hbut0], ...
%     'String', 'load gamma',...
%     'Value', showCutoff,...
%     'TooltipString', 'load gamma factor file',...
%     'Callback', {@pushbutton_loadGamma_Callback, h_fig});

setProp(h_fig2, 'Units', 'normalized');

zoom(h_fig2,'on');

guidata(h_fig2,q);
guidata(h_fig,h);

