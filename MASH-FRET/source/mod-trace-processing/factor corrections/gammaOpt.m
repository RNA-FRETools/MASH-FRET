% options for photobleaching based gamma correction
% last updated: FS, 12.1.2018
% last updated: MH, 15.1.2020 (separate process from MASH's main plot, add axes for traces and data list for photoblaching detection)

function gammaOpt(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end

% build figure
h_fig2 = buildGammaOpt(h_fig);

% set defaults option parameters
setDefPrm_gammaOpt(h_fig,h_fig2);

% update calculations and panel
ud_pbGamma(h_fig,h_fig2);


function h_fig2 = buildGammaOpt(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;

% defaults
file_check = 'check.png';
file_notdef = 'notdefined.png';
posun = 'pixels';
fntun = 'points';
fntsz = 8;
mg = 10;
mgpan = 20;
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
ttl1 = 'Photobleaching parameters';
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
wpan0 = mg+waxes0+mg;
hpan0 = mgpan+hedit0+mg+haxes0+mg+htxt0+hpop0+mg+wpic0+mg;
wfig = mg+wpan0+mg;
hfig = mg+hpan0+mg;

% lists
proj = p.curr_proj;
mol = p.curr_mol(proj);
exc = p.proj{proj}.excitations;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
clr = p.proj{proj}.colours;
labels = p.proj{proj}.labels;
fret = p.proj{proj}.fix{3}(8);
str_dat = removeHtml(get(h.popupmenu_gammaFRET,'string'));
bgcol = clr{2}(fret,1:3);
fntcol = ones(1,3)*(sum(clr{2}(fret,1:3))<=1.5);
showCutoff = p.proj{proj}.curr{mol}{6}{3}(fret,1);
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
y = hfig-mg-hpan0;

% photobleaching panel
q.uipanel_photobleach = uipanel('Parent', h_fig2, 'Units', posun, ...
    'FontUnits', fntun, 'FontSize', fntsz, ...
    'Position', [x y wpan0 hpan0], ...
    'Title', ttl1);
h_pan = q.uipanel_photobleach;

x = mg;
y = hpan0-mgpan-hedit0;

% FRET pair tag
q.edit_pair = uicontrol('Style', 'edit', 'Parent', h_pan, 'Units', posun,...
    'Position', [x y wedit0 hedit0], ...
    'String', str_dat{fret+1}, ...
    'BackgroundColor', bgcol, ...
    'ForegroundColor', fntcol, ...
    'Enable','inactive');

y = y-mg-haxes0;

q.axes_traces = axes('Parent', h_pan, 'Units', posun, 'FontUnits', fntun, ...
    'FontSize', fntsz, 'Xlim', xlim0, 'Ylim', ylim0, 'NextPlot', ...
    'replacechildren');
h_axes = q.axes_traces;
pos = getRealPosAxes([x y waxes0 haxes0],get(h_axes,'TightInset'),'traces');
set(h_axes, 'Position', pos);

y = y-mg-htxt0;

% text data
q.text_data = uicontrol('Style', 'text', 'Parent', h_pan, 'Units', posun, ...
    'FontUnits', fntun,...
    'Position', [x y wpop0 htxt0], ...
    'String', str0);

y = y-hpop0;

% data popupmenu
q.popupmenu_data = uicontrol('Style', 'popupmenu', 'Parent', h_pan, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wpop0 hpop0], ...
    'String', str_acc, ...
    'TooltipString', ttstr0,...
    'Callback', {@popupmenu_data_pbGamma_Callback, h_fig, h_fig2});

x = x+wpop0+mg/fact;
y = y+(hpop0-hedit0)/2;

% edit stop
q.edit_stop = uicontrol('Style', 'edit', 'Parent', h_pan, ...
    'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'Enable', 'inactive');

y = y-(hpop0-hedit0)/2+hpop0;

% text stop
q.text_stop = uicontrol('Style', 'text', 'Parent', h_pan, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str1);

x = x+wedit1+mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

% edit threshold
q.edit_threshold = uicontrol('Style', 'edit', 'Parent', h_pan, ...
    'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'TooltipString', ttstr1, ...
    'Callback', {@edit_pbGamma_threshold_Callback, h_fig, h_fig2});

y = y-(hpop0-hedit0)/2+hpop0;

% text threshold
q.text_threshold = uicontrol('Style', 'text', 'Parent', h_pan, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str2);

x = x+wedit1+mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

% edit extra subtract
q.edit_extraSubstract = uicontrol('Style', 'edit', 'Parent', ...
    h_pan, 'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'Callback', {@edit_pbGamma_extraSubstract_Callback, h_fig, h_fig2});

y = y-(hpop0-hedit0)/2+hpop0;

% text extra subtract
q.text_extraSubstract = uicontrol('Style', 'text', 'Parent', ...
    h_pan, 'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str3);

x = x+wedit1+mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

% edit min cutoff
q.edit_minCutoff = uicontrol('Style', 'edit', 'Parent', h_pan, ...
    'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'Callback', {@edit_pbGamma_minCutoff_Callback, h_fig, h_fig2});

y = y-(hpop0-hedit0)/2+hpop0;

% text min. cutoff
q.text_pbGamma_minCutoff = uicontrol('Style', 'text', 'Parent', h_pan, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 htxt0], ...
    'String', str4);

x = x+wedit1+mg/fact;
y = y-hpop0+(hpop0-hedit0)/2;

% edit tolerance
q.edit_tol = uicontrol('Style', 'edit', 'Parent', h_pan, 'Units', posun, ...
    'Position', [x y wedit1 hedit0], ...
    'TooltipString', ttstr2, ...
    'Callback', {@edit_pbGamma_tol_Callback, h_fig, h_fig2});

y = y-(hpop0-hedit0)/2+hpop0;

% text min. cutoff
q.text_tol = uicontrol('Style', 'text', 'Parent', h_pan, 'Units', posun, ...
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
q.text_gamma = uicontrol('Style', 'text', 'Parent', h_pan, 'Units', posun, ...
    'FontUnits', fntun,...
    'Position', [x y wtxt0 htxt0], ...
    'String', str6, ...
    'HorizontalAlignment', 'left');

x = x+wtxt0;
y = y-(hedit0-htxt0)/2;

% edit gamma
q.edit_gamma = uicontrol('Style', 'edit', 'Parent', h_pan, ...
    'Units', posun, 'FontUnits', fntun,...
    'Position', [x y wedit1 hedit0], ...
    'Callback', {@edit_pbGamma_gamma_Callback, h_fig2});

x = x+wedit1+mg;
y = y-(wpic0-hedit0)/2;

% check icon axis
q.axes_pbGamma = axes('Parent', h_pan, 'Units', posun, ...
    'Position', [x y wpic0 wpic0], ...
    'UserData', icons, ...
    'Visible', 'off');

x = wpan0-mg-wbut0;
y = y+(wpic0-hbut0)/2;

% pushbutton compute gamma factor
q.pushbutton_save = uicontrol('Style', 'pushbutton', 'Parent', ...
    h_pan, 'Units', posun, 'FontUnits', fntun,...
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


function setDefPrm_gammaOpt(h_fig,h_fig2)

q = guidata(h_fig2);
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
fret = p.proj{proj}.fix{3}(8);

q.prm = cell(1,2);
q.prm{1} = NaN; % gamma
q.prm{2} = p.proj{proj}.curr{mol}{6}{3}(fret,:);
q.prm{3} = []; % state sequences

guidata(h_fig2,q);


% update photobleaching based gamma correction
% adapted from ud_bleach.m
% last updated: FS, 12.1.2018
function ud_pbGamma(h_fig,h_fig2)

% update calculations
udCalc_pbGamma(h_fig,h_fig2);

% collect project parameters
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
perSec = p.proj{proj}.fix{2}(4);
perPix = p.proj{proj}.fix{2}(5);
inSec = p.proj{proj}.fix{2}(7);
rate = p.proj{proj}.frame_rate;

% collect option parameters
q = guidata(h_fig2);
prm = q.prm{2}(1:6);
cutOff = q.prm{2}(7);

% convert to proper units
if inSec
    cutOff = cutOff*rate;
    prm(3:4) = prm(3:4)*rate;
end
if perSec
    prm(2) = prm(2)/rate;
end
if perPix
    nPix = p.proj{proj}.pix_intgr(2);
    prm(2) = prm(2)/nPix;
end

% update GUI
set(q.popupmenu_data, 'Value', prm(1));
set([q.edit_stop,q.edit_threshold,q.edit_extraSubstract,q.edit_minCutoff], ...
    'BackgroundColor', [1,1,1]);
set(q.edit_stop, 'String', num2str(cutOff));
set(q.edit_threshold, 'String', num2str(prm(2)));
set(q.edit_extraSubstract, 'String', num2str(prm(3)));
set(q.edit_minCutoff, 'String', num2str(prm(4)));
set(q.edit_tol, 'String', num2str(prm(6)));
set(q.edit_gamma, 'String', num2str(q.prm{1}));

% update the toolstrings depending on the x-axis unit (frames/s)
if inSec
    set(q.edit_extraSubstract, 'TooltipString', ...
        'Extra time to subtract (s)');
    set(q.edit_minCutoff, 'TooltipString', ...
        'Min. cutoff time (s)');
else
    set(q.edit_extraSubstract, 'TooltipString', ...
        'Extra frames to subtract');
    set(q.edit_minCutoff, 'TooltipString', 'Min. cutoff frame');
end

% update cross
drawCheck(h_fig2);

% plot traces and cutoff
nC = p.proj{proj}.nb_channel;
m = p.curr_mol(proj);
fret = p.proj{proj}.fix{3}(8);
don = p.proj{proj}.FRET(fret,1);
acc = p.proj{proj}.FRET(fret,2);
I_a = p.proj{proj}.intensities_denoise(:,(m-1)*nC+acc,prm(1));
clr0 = p.proj{proj}.colours{1};
nExc = p.proj{proj}.nb_excitations;
ldon = find(p.proj{proj}.excitations==p.proj{proj}.chanExc(don));
L = size(I_a,1)*nExc;

x_axis = [(prm(1):nExc:L); (ldon:nExc:L)];
if inSec
    x_axis = x_axis*rate;
    prm(6) = prm(6)*rate;
end
clr{1} = clr0{prm(1),acc};
clr{2} = clr0{ldon,don};
clr{3} = clr0{ldon,acc};

if ~isfield(q,'area_slct')
    q.area_slct = [];
end
q.area_slct = plot_pbGamma(q.axes_traces, x_axis, I_a, q.prm{3}, clr, ...
    cutOff, prm(6), q.area_slct);
guidata(h_fig2, q);


function udCalc_pbGamma(h_fig,h_fig2)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
m = p.curr_mol(proj);
fret = p.proj{proj}.fix{3}(8);

q = guidata(h_fig2);
prm = q.prm{2}(1:6);

% collect molecule traces
incl = p.proj{proj}.bool_intensities(:,m);
I_den = p.proj{proj}.intensities_denoise(incl,((m-1)*nChan+1):m*nChan,:);
prm_dta = p.proj{proj}.curr{m}{4};

[I_dta,cutOff,gamma,ok,str] = gammaCorr_pb(fret,I_den,prm,prm_dta,...
    p.proj{proj},h_fig);
if ~ok
    setContPan(str,'warning',h_fig);
end
cutOff = cutOff*nExc;

q.prm{3} = I_dta;
q.prm{2}(8) = ok;
q.prm{2}(7) = cutOff;
q.prm{1} = round(gamma,2);

% save curr parameters
guidata(h_fig2,q);


% draws a checkmark or a cross depending if a cutoff is found within the
% trace (i.e intensity of the donor prior to and after the presumed cutoff 
% is different)
function drawCheck(h_fig2)

q = guidata(h_fig2);
icons = get(q.axes_pbGamma,'UserData');

if q.prm{2}(8)==1
    icon = icons{1,1};
    alpha = icons{1,2};
%     set(q.checkbox_showCutoff, 'Enable', 'on')
    set([q.pushbutton_save,q.text_gamma,q.edit_gamma], 'Enable', 'on')
else
    icon = icons{2,1};
    alpha = icons{2,2};
%     set(q.checkbox_showCutoff, 'Enable', 'off')
    set([q.pushbutton_save,q.text_gamma,q.edit_gamma], 'Enable', 'off')
end

% cancelled by MH
%     drawCutoff(h_fig,p.proj{proj}.curr{mol}{6}{3}(fret,7) & ...
%         p.proj{proj}.curr{mol}{6}{3}(fret,1));

image(q.axes_pbGamma, icon, 'alphaData', alpha);
set(q.axes_pbGamma, 'Visible', 'off', 'UserData', icons);

% cancelled by MH, 15.1.2020
% % draw the cutoff line; added by FS, 26.4.2018
% function drawCutoff(h_fig, drawIt)
% h = guidata(h_fig);
% p = h.param.ttPr;
% proj = p.curr_proj;
% mol = p.curr_mol(proj);
% fret = p.proj{proj}.fix{3}(8);
% p.proj{proj}.curr{mol}{6}{3}(fret,1) = drawIt;
% set(q.checkbox_showCutoff, 'Value', drawIt)
% h.param.ttPr = p;
% guidata(h_fig, h)
% % updateFields(h_fig, 'ttPr');
% 
% axes.axes_traceTop = h.axes_top;
% axes.axes_histTop = h.axes_topRight;
% axes.axes_traceBottom = h.axes_bottom;
% axes.axes_histBottom = h.axes_bottomRight;
% if p.proj{proj}.is_movie && p.proj{proj}.is_coord
%     axes.axes_molImg = h.axes_subImg;
% end
% plotData(mol, p, axes, p.proj{proj}.curr{mol}, 1);


function area_slct = plot_pbGamma(h_axes, x_axis, I_a, I_dta, clr, cutOff, ...
    tol, area_slct)

% default
decr = 0.1;
clr_cut = [0,0,1];
alpha_tol = 0.2;

if isequal(clr{3},clr{1})
    clr{3} = clr{3}-decr;
    clr{3}(clr{3}<0) = 0;
end

plot(h_axes, x_axis(1,:), I_a, 'Color', clr{1});

set(h_axes, 'NextPlot', 'add');

plot(h_axes, x_axis(2,:), I_dta(:,1), 'Color', clr{2}, 'LineWidth', 2);
plot(h_axes, x_axis(2,:), I_dta(:,2), 'Color', clr{3}, 'LineWidth', 2);

xlim(h_axes,[min(x_axis(:,1)),max(x_axis(:,end))]);
ylim(h_axes,'auto');

lim_y = get(h_axes,'ylim');

plot(h_axes, [cutOff,cutOff], lim_y, 'Color', clr_cut);

xdata = [x_axis(1)-1 cutOff-tol cutOff-tol cutOff+tol cutOff+tol x_axis(end)+1];
ydata = [lim_y(1)-1 lim_y(1)-1 lim_y(2)+1 lim_y(2)+1 lim_y(1)-1 lim_y(1)-1];

if ~isempty(area_slct) && ishandle(area_slct)
    set(area_slct,'xdata',xdata,'ydata',ydata,'basevalue',lim_y(1)-1);
else
    area_slct = area(h_axes,xdata,ydata,'linestyle','none','facecolor',...
        clr_cut,'facealpha',alpha_tol,'basevalue',lim_y(1)-1);
end

ylim(h_axes,lim_y);

set(h_axes, 'NextPlot', 'replacechildren');



function popupmenu_data_pbGamma_Callback(obj, ~, h_fig, h_fig2)

q = guidata(h_fig2);
q.prm{2}(1) = get(obj, 'Value');
guidata(h_fig2,q);

ud_pbGamma(h_fig,h_fig2)


function edit_pbGamma_gamma_Callback(obj, ~, h_fig2)

q = guidata(h_fig2);
set(obj,' String', num2str(q.prm{1}));


% cancelled by MH, 15.1.2020
% % show or hide the pb cutoff
% function checkbox_showCutoff(obj, ~, h_fig, h_fig2)
% 
% q = guidata(h_fig2);
% q.prm{2}(1) = get(obj, 'Value');
% guidata(h_fig2,q);
% 
% ud_pbGamma(h_fig,h_fig2)


% threshold (adapted from edit_photoblParam_01_Callback in MASH.m)
function edit_pbGamma_threshold_Callback(obj, ~, h_fig, h_fig2)

val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));

if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Data threshold must be a number.', h_fig, 'error');
    return
end

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
perSec = p.proj{proj}.fix{2}(4);
perPix = p.proj{proj}.fix{2}(5);
if perSec
    rate = p.proj{proj}.frame_rate;
    val = val*rate;
end
if perPix
    nPix = p.proj{proj}.pix_intgr(2);
    val = val*nPix;
end

q = guidata(h_fig2);
q.prm{2}(2) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2)


% extra frames/s to substract (adapted from edit_photoblParam_02_Callback in MASH.m)
function edit_pbGamma_extraSubstract_Callback(obj, ~, h_fig, h_fig2)
    
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
inSec = p.proj{proj}.fix{2}(7);
nExc = p.proj{proj}.nb_excitations;
len = nExc*size(p.proj{proj}.intensities,1);
rate = p.proj{proj}.frame_rate;

val = str2double(get(obj, 'String'));
if inSec
    val = rate*round(val/rate);
    maxVal = rate*len;
else
    val = round(val);
    maxVal = len;
end
set(obj, 'String', num2str(val));

if ~(numel(val)==1 && ~isnan(val) && val>=0 && val<=maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Extra cutoff must be >= 0 and <= ' num2str(maxVal)], ...
        h_fig, 'error');
    return
end

if inSec
    val = val/rate;
end

q = guidata(h_fig2);
q.prm{2}(3) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2)


% minimum cutoff (adapted from edit_photoblParam_03_Callback in MASH.m)
function edit_pbGamma_minCutoff_Callback(obj, ~, h_fig, h_fig2)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
inSec = p.proj{proj}.fix{2}(7);
nExc = p.proj{proj}.nb_excitations;
len = nExc*size(p.proj{proj}.intensities,1);
rate = p.proj{proj}.frame_rate;

q = guidata(h_fig2);
start = q.prm{2}(5);

val = str2double(get(obj, 'String'));
if inSec
    val = rate*round(val/rate);
    minVal = rate*start;
    maxVal = rate*len;
else
    val = round(val);
    minVal = start;
    maxVal = len;
end
set(obj, 'String', num2str(val));

if ~(numel(val)==1 && ~isnan(val) && val>=minVal && val<=maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Minimum cutoff must be >= ' num2str(minVal) ' and <= ' ...
        num2str(maxVal)], h_fig, 'error');
end

if inSec
    val = val/rate;
end

q.prm{2}(4) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2);


function edit_pbGamma_tol_Callback(obj, ~, h_fig, h_fig2)

val = str2double(get(obj, 'String'));

if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Tolerance must be >= 0 ', h_fig, 'error');
end

q = guidata(h_fig2);
q.prm{2}(6) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2);


% compute the gamma factor; added by FS, 26.4.2018
function pushbutton_computeGamma_Callback(~, ~, h_fig, h_fig2)

h = guidata(h_fig);
q = guidata(h_fig2);

p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
fret = p.proj{proj}.fix{3}(8);

p.proj{proj}.curr{mol}{6}{1}(1,fret) = q.prm{1}; % gamma factor
p.proj{proj}.curr{mol}{6}{3}(fret,:) = q.prm{2}; % method parameters

% save results
h.param.ttPr = p;
guidata(h_fig,h);

close(h_fig2);

ud_factors(h_fig);


function figure_gammaOpt_ResizeFcn(obj, ~)

% default
mg = 10;

q = guidata(obj);
if ~isstruct(q)
    return
end

h_axes = q.axes_traces;
pospan = getPixPos(q.uipanel_photobleach);
posed = getPixPos(q.edit_pair);
postxt = getPixPos(q.text_data);

y = postxt(2)+postxt(4)+mg;
x = mg;
waxes = pospan(3)-2*mg;
haxes = posed(2)-mg-y;

un = get(h_axes, 'Units');
set(h_axes,'Units','pixels');

pos = getRealPosAxes([x,y,waxes,haxes],get(h_axes,'TightInset'),'traces');

set(h_axes,'Position',pos);
set(h_axes,'Units',un);


function figure_gammaOpt_CloseRequestFcn(obj, ~, h_fig)

h = guidata(h_fig);
h = rmfield(h,'figure_gammaOpt');
guidata(h_fig,h);

delete(obj);

