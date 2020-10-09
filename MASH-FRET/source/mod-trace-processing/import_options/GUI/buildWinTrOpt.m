function buildWinTrOpt(opt,h_fig)
% buildWinTrOpt(opt,h_fig)
%
% buildWinTrOpt builds a figure that presents import settings for ASCII traces
%
% opt: {1-by-6} import settings with:
%  opt{1}: {1-by-2} intensity import options with:
%   opt{1}{1}: [1-by-10] parameters of file structure with:
%    opt{1}{1}(1): first line index in file where intensity data are written
%    opt{1}{1}(2): last line index in file where intensity data are written
%    opt{1}{1}(3): (1) to import time data from files, (0) otherwise
%    opt{1}{1}(4): column index in files where time data is written (0 for eof)
%    opt{1}{1}(5): first column index in files where intensity data are written
%    opt{1}{1}(6): last column index in files where intensity data are written (0 for eof)
%    opt{1}{1}(7): number of channels
%    opt{1}{1}(8): number of alternating lasers
%    opt{1}{1}(9): (1) to import FRET state sequences data from files, (0) otherwise
%    opt{1}{1}(10): first column index in files where FRET states data is written
%    opt{1}{1}(11): last column index in files where FRET states data is written
%    opt{1}{1}(12): number of columns in files between two FRET state sequences
%   opt{1}{2}: [1-by-nL] laser wavelength in a chronological order
%  opt{2}: {1-by-2} video import options with:
%   opt{2}{1}: (1) if video file is imported,(0) otherwise
%   opt{2}{2}: source video file
%  opt{3}: {1-by-4} coordinates import options with:
%   opt{3}{1}: (1) if coordinates are imported from separate file,(0) otherwise
%   opt{3}{2}: coordinates file
%   opt{3}{3}: [1-by-2] column index in coordinates file where x- and y- coordinates are written 
%   opt{3}{4}: video dimension in the x-direction
%  opt{4}: [1-by-2] coordinates are(1)/aren't(0) in intensity file and corresponding line index in intensity file
%  opt{5}: {nPrm-by-3} user-defined experimental conditions
%  opt{6}: {1-by-6} correction factor import options with:
%   opt{6}{1}: (1) if gamma factors are imported form files,(0) otherwise
%   opt{6}{2}: source directory for gamma factor files
%   opt{6}{3}: {1-by-nFiles} source gamma factor files
%   opt{6}{4}: (1) if beta factors are imported form files,(0) otherwise
%   opt{6}{5}: source directory for beta factor files
%   opt{6}{6}: {1-by-nFiles} source beta factor files
% h_fig: handle to main figure

% Last update, 28.3.2019 by MH: (1) Add "Gamma factor" panel (2) Add "State trajectories" panel (3) Change "Movie" to "Video" 

% defaults
posun = 'pixels';
fntun = 'points';
fntsz = 8;
fntclr2 = 'blue';
mg = 10;
mgpan = 20;
mged = 2;
htxt = 14;
hedit = 20; 
wedit = 40;
hbut = 22; 
hpop = 20; 
hcb = 20;
bgCol = [0.94 0.94 0.94];
wbox = 15; % box width in checkboxes
wbrd = 6; % width of pushbutton borders
warr = 20; % width of downwards arrow in popupmenu
ttl0 = 'Import ASCII options';
ttl1 = 'Intensity-time traces';
ttl2 = 'Single moelcule video';
ttl3 = 'Molecule coordinates';
ttl4 = 'State trajectories';
ttl5 = 'Correction factors';
str0 = 'Save';
str1 = 'Cancel';
str2 = 'nb. of excitations:';
str3 = '(column-wise)';
str4 = 'column:';
str5 = 'to';
str6 = 'skip:';

h = guidata(h_fig);

if isfield(h,'figure_trImpOpt') && ishandle(h.figure_trImpOpt)
    return
end

% store defaults
prm = struct('posun',posun,'fntun',fntun,'fntsz',fntsz,'fntclr2',fntclr2,...
    'mg',mg,'mgpan',mgpan,'htxt',htxt,'hedit',hedit,'hbut',hbut,'hcb',hcb,...
    'hpop',hpop,'wedit',wedit,'wbox',wbox,'wbrd',wbrd,'warr',warr,'mged',...
    mged);
prm.tbl = h.charDimTable;

% get dimensions
pos0 = get(0,'ScreenSize');
wmax1 = getUItextWidth(str2,fntun,fntsz,'normal',prm.tbl) + wedit + mged + ...
    getUItextWidth(str3,fntun,fntsz,'normal',prm.tbl);
wpan1 = wmax1 + 2*mg;
wmax2 = getUItextWidth(str4,fntun,fntsz,'normal',prm.tbl) + wedit + mged +...
    getUItextWidth(str5,fntun,fntsz,'normal',prm.tbl) + wedit + mged + ...
    getUItextWidth(str6,fntun,fntsz,'normal',prm.tbl) + wedit + mged;
wpan2 = wmax2 + 2*mg;
wbut0 = getUItextWidth(str0,fntun,fntsz,'normal',prm.tbl) + wbrd;
wbut1 = getUItextWidth(str1,fntun,fntsz,'normal',prm.tbl) + wbrd;
hpan_discr = mgpan + hcb + mg/2 + hedit + mg;
hpan_fact = mgpan + 2*(hcb + mg/2 + hbut + mg);
hpan_int = mgpan + htxt + mg/2 + hedit + mg/2 + hedit + mg + hcb + mg + ...
    hedit + mg/2 + hedit + mg/2 + hpop + mg;
hpan_mov = mgpan + hcb + mg/2 + hbut + mg;
hpan_coord = mgpan + hbut + mg/2 + hbut + mg/2 + hedit + mg + hedit + mg;
hFig = hpan_int + hpan_mov + hpan_coord + hbut + 5*mg;
wFig = mg + wpan1 + mg + wpan2 + mg;

x = pos0(1) + (pos0(3) - wFig)/2;
y = pos0(2) + (pos0(4) - hFig)/2;
if hFig > pos0(4)
    y = y - (hFig-pos0(4));
end

% build GUI
q = struct();

h.figure_trImpOpt = figure('Name',ttl0,'Units',posun,'NumberTitle','off',...
    'MenuBar','none','Position',[x y wFig hFig],'Color',bgCol,'Resize',...
    'off','CloseRequestFcn',{@figure_trImpOpt_CloseRequestFcn,h_fig},...
    'WindowStyle','Normal','Visible','off');
h_fig2 = h.figure_trImpOpt;

y = mg;
x = wFig - mg - wbut0;

q.pushbutton_trImpOpt_ok = uicontrol('Style','pushbutton','Parent',h_fig2,...
    'Units',posun,'Fontunits',fntun,'Fontsize',fntsz,'Position',...
    [x y wbut0 hbut],'String',str0,'Callback',...
    {@pushbutton_trImpOpt_ok_Callback,h_fig});

x = x - wbut1 - mg;

q.pushbutton_trImpOpt_cancel = uicontrol('Style','pushbutton','Parent',...
    h_fig2,'Units',posun,'Fontunits',fntun,'Fontsize',fntsz,'Position',...
    [x y wbut1 hbut],'String',str1,'Callback',...
    {@pushbutton_trImpOpt_cancel_Callback,h_fig});

y = y + hbut + mg;
x = mg;

q.uipanel_ITT = uipanel('Parent',h_fig2,'Title',ttl1,'Units',posun,...
    'Fontunits',fntun,'Fontsize',fntsz,'Position',[x y wpan1 hpan_int],...
    'FontWeight','bold');
q = build_trImpOpt_panelITT(q,prm,h_fig);

y = y + hpan_int + mg;

q.uipanel_mov = uipanel('Parent',h_fig2,'Title',ttl2,'Units',posun,...
    'Fontunits',fntun,'Fontsize',fntsz,'Position',[x y wpan1 hpan_mov],...
    'FontWeight','bold');
q = build_trImpOpt_panelMov(q,prm,h_fig);

y = y + hpan_mov + mg;

q.uipanel_coord = uipanel('Parent',h_fig2,'Title',ttl3,'Units',posun,...
    'Fontunits',fntun,'Fontsize',fntsz,'Position',[x y wpan1 hpan_coord],...
    'FontWeight','bold');
q = build_trImpOpt_panelCoord(q,prm,h_fig);

x = x + wpan1 + mg;
y = hFig - mg - hpan_fact - mg - hpan_discr;

q.uipanel_discr = uipanel('Parent',h_fig2,'Title',ttl4,'Units',posun,...
    'Fontunits',fntun,'Fontsize',fntsz,'Position',[x y wpan2 hpan_discr],...
    'FontWeight','bold');
q = build_trImpOpt_panelDiscr(q,prm,h_fig);

y = y + hpan_discr + mg;

q.uipanel_factors = uipanel('Parent',h_fig2,'Title',ttl5,'Units',posun,...
    'Fontunits',fntun,'Fontsize',fntsz,'Position',[x y wpan2 hpan_fact],...
    'FontWeight','bold');
q = build_trImpOpt_panelFactors(q,prm,h_fig);

% save figure
guidata(h_fig,h);

% add help button
q.pushbutton_help = setInfoIcons(q.pushbutton_trImpOpt_cancel,h_fig,...
    h.param.movPr.infos_icon_file);

% save modifications
h.trImpOpt = q;
guidata(h.figure_trImpOpt,opt);
guidata(h_fig,h);

% set GUI to proper values
ud_trImpOpt(h_fig);

set(h.figure_trImpOpt,'Visible','on');
    
    