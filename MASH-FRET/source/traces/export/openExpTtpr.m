function openExpTtpr(h_fig)

% Last update by MH, 10.4.2019
% >> link the "infos" button to online documentation
% >> set edit fields with empty strings and checkboxes unchecked when 
%    main export options are deactivated
% >> improve trace section:
%    - change "ASCII(*.txt)" trace file format to "customed format(*.txt)",
%      and "VbFRET" to "vbFRET"
%    - improve informative text about the number of trace file per 
%      molecules and which traces are exported
%    - set checkboxes for trace options to unchecked when formats 
%      other than "custommed format" are used and prevent the
%      selection of the option "external file(.log)" for processing
%      parameters export
% >> improve figure section:
%    - add informative text about the number of pages exported in one 
%      figure file depending on the chosen format
%    - display processing action when creating figure preview (slow 
%      process)
%    - correct panel title's font weight to bold
%    - correct extra space in GUI


h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
exc = p.proj{proj}.excitations;

% modified by MH, 10.4.2019
% str_trFmt = {'ASCII(*.txt)', 'HaMMy-compatible(*.dat)', ...
%    'VbFRET-compatible(*.mat)', 'SMART-compatible(*.traces)', ...
str_trFmt = {'customed format(*.txt)', 'HaMMy-compatible(*.dat)', ...
    'vbFRET-compatible(*.mat)', 'SMART-compatible(*.traces)', ...
    'QUB-compatible(*.txt)', 'ebFRET-compatible(*.dat)', 'All formats'};

% modified by MH, 10.4.2019
% str_trInfos = {'---', ...
%     'Donor and acceptor traces only.', ...
%     'All in one file: donor and acc. traces only.', ...
%     'All in one file: donor and acc. traces only.', ...
%     'Donor and acceptor traces only.', ...
%     'All in one file: donor and acc. traces only.', ...
%     '---'};
str_trInfos = {'(individual files)', ...
    '(individual files) Donor and acceptor traces only.', ...
    '(one file) Donor and acceptor traces only.', ...
    '(one file) Donor and acceptor traces only.', ...
    '(individual files) Donor and acceptor traces only.', ...
    '(one file) Donor and acceptor traces only.', ...
    'Options set for customed format only.'};

str_prm = {'external file(*.log)', 'ASCII file headers', 'none'};
str_figFmt = {'Portable document format(*.pdf)', ...
    'Portable network graphics(*.png)', ...
    'Joint Photographic Experts Group(*.jpeg)'};

% added by MH, 10.4.2019
str_figInfos = {'All pages in on file.', ...
    'One file per page.', ...
    'One file per page.'};

str_figTopExc = getStrPop('plot_exc', exc);
str_figTopChan = getStrPop('plot_topChan', ...
    {p.proj{proj}.labels p.proj{proj}.fix{1}(1) p.proj{proj}.colours{1}});
str_figBotChan = getStrPop('plot_botChan', ...
    {FRET S exc p.proj{proj}.colours p.proj{proj}.labels});

wPan = 235;
mg = 10;
w_full_pan = wPan - 2*mg;
w_full_sub = wPan - 3*mg;

w_but = 60; h_but = 22;
w_edit = 35; h_edit = 20; 
w_med_big = 95;
w_pop = 125;
w_med = 90;
w_big = 110;
h_txt = 14;

hPan_tr =   9*h_edit + 2*h_txt + 9*mg + 3*mg/2;
hPan_hist = 6*h_edit + 2*h_txt + 6*mg + 3*mg/2;
hPan_dt =   6*h_edit +   h_txt + 7*mg + 2*mg/2;

% modified by MH, 10.4.2019
% hPan_fig =  10*h_edit +   h_but + 8*mg + 4*mg/2;
hPan_fig =  9*h_edit + h_txt +  h_but + 8*mg + 4*mg/2;

hFig = h_txt + h_but + max([(hPan_tr+hPan_hist),(hPan_dt+hPan_fig)]) + ...
    5*mg;
wFig = 2*wPan + 3*mg;
w_full_fig = wFig - 2*mg;

pos_0 = get(0, 'ScreenSize');
xFig = pos_0(1) + (pos_0(3) - wFig)/2;
yFig = pos_0(2) + (pos_0(4) - hFig)/2;
if hFig > pos_0(4)
    yFig = pos_0(4) - 30;
end
        
h.optExpTr.figure_optExpTr = figure('Color', [0.94 0.94 0.94], ...
    'Resize', 'off', 'NumberTitle', 'off', 'MenuBar', 'none', 'Name', ...
    'Export options', 'Visible', 'off', 'Units', 'pixels', 'Position', ...
    [xFig yFig wFig hFig], 'CloseRequestFcn', ...
    {@figure_optExpTr_CloseRequestFcn, h_fig});

xNext = mg;
yNext = hFig - mg - h_txt;

uicontrol('Style', 'text', 'Parent', h.optExpTr.figure_optExpTr, ...
    'String', ['If no other mention, one set of file is exported for ' ...
    'each molecule'], 'ForegroundColor', [0 0 1], 'Position', ...
    [xNext yNext w_full_fig h_txt], 'HorizontalAlignment', 'left', ...
    'FontSize', 10);

%% panel export traces

xNext = mg;
yNext = hFig - 2*mg - h_txt - hPan_tr;

h.optExpTr.uipanel_traces = uipanel('Units', 'pixels', 'Parent', ...
    h.optExpTr.figure_optExpTr, 'Title', 'Time traces', 'Position', ...
    [xNext yNext wPan hPan_tr], 'FontWeight', 'bold');

xNext = mg;
yNext = hPan_tr - 2*mg - h_edit;

h.optExpTr.radiobutton_saveTr = uicontrol('Style', 'radiobutton', ...
    'Units', 'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', ...
    'Export time traces', 'Position', [xNext yNext w_full_pan h_edit], ...
    'Callback', {@radiobutton_saveTr_Callback, h_fig});

xNext = mg;
yNext = yNext - mg - h_edit;

h.optExpTr.text_trFmt = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_traces, 'String', 'Export format:', ...
    'Position', [xNext yNext w_med h_txt], 'HorizontalAlignment', 'left');

xNext = xNext + w_med;

h.optExpTr.popupmenu_trFmt = uicontrol('Style', 'popupmenu', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', str_trFmt, ...
    'Position', [xNext yNext w_pop h_edit], 'Callback', ...
    {@popupmenu_trFmt_Callback, h_fig}, 'BackgroundColor', [1 1 1]);

xNext = mg;
yNext = yNext - mg/2 - h_txt;

h.optExpTr.text_trInfos = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_traces, 'UserData', str_trInfos, ...
    'Position', [xNext yNext w_full_pan h_txt], 'HorizontalAlignment', ...
    'left', 'ForegroundColor', [0 0 1]);

xNext = mg;
yNext = yNext - mg - h_txt;

h.optExpTr.text_tr2exp = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_traces, 'String', 'Traces to export:', ...
    'Position', [xNext yNext w_full_pan h_txt], 'HorizontalAlignment', ...
    'left');

xNext = 2*mg;
yNext = yNext - mg - h_edit;

h.optExpTr.checkbox_trI = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', ...
    'intensity-time traces', 'Callback', ...
    {@checkbox_trI_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);

yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_trFRET = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', ...
    'FRET-time traces', 'Position', [xNext yNext w_full_sub h_edit], ...
    'Callback', {@checkbox_trFRET_Callback, h_fig});

yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_trS = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', ...
    'stoichiometry-time traces', 'Callback', ...
    {@checkbox_trS_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);

yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_trAll = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', ...
    'all traces in one file', 'Callback', ...
    {@checkbox_trAll_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);

% added by FS, 19.3.2018
yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_gam = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', ...
    'gamma factors', 'Callback', ...
    {@checkbox_gam_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);


xNext = mg;
yNext = yNext - mg - h_edit;

h.optExpTr.text_trPrm = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_traces, 'String', 'Parameters:', ...
    'Position', [xNext yNext w_med h_txt], 'HorizontalAlignment', 'left');

xNext = xNext + w_med;

h.optExpTr.popupmenu_trPrm = uicontrol('Style', 'popupmenu', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', str_prm, ...
    'Position', [xNext yNext w_pop h_edit], 'Callback', ...
    {@popupmenu_trPrm_Callback, h_fig}, 'BackgroundColor', [1 1 1]);

xNext = mg;
yNext = yNext - mg - h_edit;

h.optExpTr.radiobutton_noTr = uicontrol('Style', 'radiobutton', ...
    'Units', 'pixels', 'Parent', h.optExpTr.uipanel_traces, 'String', ...
    'No trace file', 'Position', [xNext yNext w_full_pan h_edit], ...
    'Callback', {@radiobutton_noTr_Callback, h_fig});


%% panel export histograms

xNext = mg;
yNext = hFig - 3*mg - h_txt - hPan_tr - hPan_hist;

h.optExpTr.uipanel_hist = uipanel('Parent', h.optExpTr.figure_optExpTr, ...
    'Units', 'pixels', 'Title', 'Histograms', 'Position', ...
    [xNext yNext wPan hPan_hist], 'FontWeight', 'bold');

xNext = mg;
yNext = hPan_hist - 2*mg - h_edit;

h.optExpTr.radiobutton_saveHist = uicontrol('Style', 'radiobutton', ...
    'Units', 'pixels', 'Parent', h.optExpTr.uipanel_hist, 'String', ...
    'Export histograms', 'Position', ...
    [xNext yNext w_full_pan h_edit], 'Callback', ...
    {@radiobutton_saveHist_Callback, h_fig});

xNext = mg;
yNext = yNext - mg - h_txt;

h.optExpTr.text_hist2exp = uicontrol('Style', 'text', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_hist, 'String', ...
    'Histograms to export:', 'Position', ...
    [xNext yNext w_full_pan h_txt], 'HorizontalAlignment', 'left');

xNext = mg + w_med_big;
yNext = yNext - mg/2 - h_txt;

h.optExpTr.text_min = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'String', 'min', 'Position', ...
    [xNext yNext w_edit h_txt], 'HorizontalAlignment', 'center');

xNext = xNext + mg/2 + w_edit;

h.optExpTr.text_bin = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'String', 'bin', 'Position', ...
    [xNext yNext w_edit h_txt], 'HorizontalAlignment', 'center');

xNext = xNext + mg/2 + w_edit;

h.optExpTr.text_max = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'String', 'max', 'Position', ...
    [xNext yNext w_edit h_txt], 'HorizontalAlignment', 'center');

xNext = mg;
yNext = yNext - h_edit;

h.optExpTr.checkbox_histI = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_hist, 'String', ...
    'intensities', 'Callback', {@checkbox_histI_Callback, h_fig}, ...
    'Position', [xNext yNext w_med_big h_edit]);

xNext = xNext + w_med_big;

perSec = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(4);
perPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(5);
tooltip = 'counts';
if perSec
    tooltip = [tooltip ' per sec'];
end
if perPix
    tooltip = [tooltip ' per pixel'];
end

h.optExpTr.edit_minI = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_minI_Callback, h_fig}, 'TooltipString', tooltip);

xNext = xNext + mg/2 + w_edit;

h.optExpTr.edit_binI = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_binI_Callback, h_fig}, 'TooltipString', tooltip);

xNext = xNext + mg/2 + w_edit;

h.optExpTr.edit_maxI = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_maxI_Callback, h_fig}, 'TooltipString', tooltip);

xNext = mg;
yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_histFRET = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_hist, 'String', ...
    'FRET', 'Callback', {@checkbox_histFRET_Callback, h_fig}, ...
    'Position', [xNext yNext w_med_big h_edit]);

xNext = xNext + w_med_big;

h.optExpTr.edit_minFRET = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_minFRET_Callback, h_fig});

xNext = xNext + mg/2 + w_edit;

h.optExpTr.edit_binFRET = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_binFRET_Callback, h_fig});

xNext = xNext + mg/2 + w_edit;

h.optExpTr.edit_maxFRET = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_maxFRET_Callback, h_fig});

xNext = mg;
yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_histS = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_hist, 'String', ...
    'stoichiometries', 'Callback', {@checkbox_histS_Callback, h_fig}, ...
    'Position', [xNext yNext w_med_big h_edit]);

xNext = xNext + w_med_big;

h.optExpTr.edit_minS = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_minS_Callback, h_fig});

xNext = xNext + mg/2 + w_edit;

h.optExpTr.edit_binS = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_binS_Callback, h_fig});

xNext = xNext + mg/2 + w_edit;

h.optExpTr.edit_maxS = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_hist, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_maxS_Callback, h_fig});

xNext = mg;
yNext = yNext - mg - h_edit;

h.optExpTr.checkbox_histDiscr = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_hist, 'String', ...
    'save discretised histograms', 'Callback', ...
    {@checkbox_histDiscr_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);

xNext = mg;
yNext = yNext - mg - h_edit;

h.optExpTr.radiobutton_noHist = uicontrol('Style', 'radiobutton', ...
    'Units', 'pixels', 'Parent', h.optExpTr.uipanel_hist, 'String', ...
    'No histogram file', 'Position', ...
    [xNext yNext w_full_pan h_edit], 'Callback', ...
    {@radiobutton_noHist_Callback, h_fig});



%% panel export dwell-times

xNext = wPan + 2*mg;
yNext = hFig - 2*mg - h_txt - hPan_dt;

h.optExpTr.uipanel_dt = uipanel('Parent', h.optExpTr.figure_optExpTr, ...
    'Units', 'pixels', 'Title', 'Dwell-time files', 'Position', ...
    [xNext yNext wPan hPan_dt], 'FontWeight', 'bold');

xNext = mg;
yNext = hPan_dt - 2*mg - h_edit;

h.optExpTr.radiobutton_saveDt = uicontrol('Style', 'radiobutton', ...
    'Units', 'pixels', 'Parent', h.optExpTr.uipanel_dt, 'String', ...
    'Export dwell-times', 'Position', [xNext yNext w_full_pan h_edit], ...
    'Callback', {@radiobutton_saveDt_Callback, h_fig});

yNext = yNext - mg - h_txt;

h.optExpTr.text_dt2exp = uicontrol('Style', 'text', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_dt, 'String', ...
    'Dwell-times to export:', 'Position', ...
    [xNext yNext w_full_pan h_txt], 'HorizontalAlignment', 'left');

xNext = 2*mg;
yNext = yNext - mg - h_edit;

h.optExpTr.checkbox_dtI = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_dt, 'String', ...
    'intensities (*_I.dt)', 'Callback', ...
    {@checkbox_dtI_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);

yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_dtFRET = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_dt, 'String', ...
    'FRET (*_FRET.dt)', 'Callback', ...
    {@checkbox_dtFRET_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);

yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_dtS = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_dt, 'String', ...
    'stoichiometries (*_S.dt)', 'Callback', ...
    {@checkbox_dtS_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);

yNext = yNext - mg - h_edit;

h.optExpTr.checkbox_kin = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_dt, 'String', ...
    'generate kinetic data (*.kin)', 'Callback', ...
    {@checkbox_kin_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_sub h_edit]);

xNext = mg;
yNext = yNext - mg - h_edit;

h.optExpTr.radiobutton_noDt = uicontrol('Style', 'radiobutton', ...
    'Units', 'pixels', 'Parent', h.optExpTr.uipanel_dt, 'String', ...
    'No dwell-time file', 'Position', [xNext yNext w_full_pan h_edit], ...
    'Callback', {@radiobutton_noDt_Callback, h_fig});


%% panel export figures

xNext = wPan + 2*mg;
yNext = hFig - 3*mg - h_txt - hPan_dt - hPan_fig;

% modified by MH, 10.4.2019
h.optExpTr.uipanel_fig = uipanel('Parent', h.optExpTr.figure_optExpTr, ...
    'Units', 'pixels', 'Title','Figures', 'Position', ...
    [xNext yNext wPan hPan_fig], 'FontWeight','bold');
%     [xNext yNext wPan hPan_fig]);

xNext = mg;

% modified by MH, 10.4.2019
% yNext = hPan_tr - 3*mg - h_edit;
yNext = hPan_tr - 2*mg - h_edit;

h.optExpTr.radiobutton_saveFig = uicontrol('Style', 'radiobutton', ...
    'Units', 'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    'Export figures', 'Position', [xNext yNext w_full_pan h_edit], ...
    'Callback', {@radiobutton_saveFig_Callback, h_fig});

xNext = mg;
yNext = yNext - mg - h_edit;

h.optExpTr.text_figFmt = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_fig, 'String', 'Export format:', ...
    'Position', [xNext yNext w_med h_txt], 'HorizontalAlignment', 'left');

xNext = xNext + w_med;

h.optExpTr.popupmenu_figFmt = uicontrol('Style', 'popupmenu', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', str_figFmt, ...
    'Position', [xNext yNext w_pop h_edit], 'Callback', ...
    {@popupmenu_figFmt_Callback, h_fig}, 'BackgroundColor', [1 1 1]);

xNext = mg;

% added by MH, 10.4.2019
yNext = yNext - mg/2 - h_txt;
h.optExpTr.text_figInfos = uicontrol('Style', 'text', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_fig, 'UserData', str_figInfos, ...
    'Position', [xNext yNext w_full_pan h_txt], 'HorizontalAlignment', ...
    'left', 'ForegroundColor', [0 0 1]);

yNext = yNext - mg - h_edit;

h.optExpTr.text_nMol = uicontrol('Style', 'text', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    'molecules per page:', 'Position', [xNext yNext w_big h_txt], ...
    'HorizontalAlignment', 'left');

xNext = xNext + w_big;

h.optExpTr.edit_nMol = uicontrol('Style', 'edit', 'Units', 'pixels', ...
    'Parent', h.optExpTr.uipanel_fig, 'BackgroundColor', [1 1 1], ...
    'Position', [xNext yNext w_edit h_edit], 'Callback', ...
    {@edit_nMol_Callback, h_fig});

xNext = mg;
yNext = yNext - mg - h_edit;

h.optExpTr.checkbox_subImg = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    'molecule sub-images', 'Position', [xNext yNext w_full_pan h_edit], ...
    'Callback', {@checkbox_subImg_Callback, h_fig});

yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_top = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', 'top axes:', ...
    'Callback', {@checkbox_top_Callback, h_fig}, 'Position', ...
    [xNext yNext w_med h_edit]);

xNext = xNext + w_med;

h.optExpTr.popupmenu_topExc = uicontrol('Style', 'popupmenu', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    str_figTopExc, 'Position', [xNext yNext w_but h_edit], 'Callback', ...
    {@popupmenu_topExc_Callback, h_fig}, 'BackgroundColor', [1 1 1]);

xNext = xNext + mg/2 + w_but;

h.optExpTr.popupmenu_topChan = uicontrol('Style', 'popupmenu', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    str_figTopChan, 'Position', [xNext yNext w_but h_edit], 'Callback', ...
    {@popupmenu_topChan_Callback, h_fig}, 'BackgroundColor', [1 1 1]);

xNext = mg;
yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_bottom = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    'bottom axes:', 'Callback', {@checkbox_bottom_Callback, h_fig}, ...
    'Position', [xNext yNext w_med h_edit]);

xNext = xNext + w_med;

h.optExpTr.popupmenu_botChan = uicontrol('Style', 'popupmenu', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    str_figBotChan, 'Position', [xNext yNext w_pop h_edit], 'Callback', ...
    {@popupmenu_botChan_Callback, h_fig}, 'BackgroundColor', [1 1 1]);

xNext = 2*mg;
yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_figHist = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    'histogram axes', 'Callback', {@checkbox_figHist_Callback, h_fig}, ...
    'Position', [xNext yNext w_full_sub h_edit]);

xNext = 2*mg;
yNext = yNext - mg/2 - h_edit;

h.optExpTr.checkbox_figDiscr = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    'include disctretised traces', 'Position', [xNext yNext w_full_sub ...
    h_edit], 'Callback', {@checkbox_figDiscr_Callback, h_fig});

xNext = wPan - mg - w_but;
yNext = yNext - mg - h_but;

h.optExpTr.pushbutton_preview = uicontrol('Style', 'pushbutton', ...
    'Parent', h.optExpTr.uipanel_fig, 'Units', 'pixels', ...
    'Position', [xNext yNext w_but h_but], 'String', 'Preview', ...
    'Callback', {@pushbutton_preview_Callback, h_fig});

xNext = mg;
yNext = mg;

h.optExpTr.radiobutton_noFig = uicontrol('Style', 'radiobutton', ...
    'Units', 'pixels', 'Parent', h.optExpTr.uipanel_fig, 'String', ...
    'No figure file', 'Position', [xNext yNext w_full_pan h_edit], ...
    'Callback', {@radiobutton_noFig_Callback, h_fig});


%% Pushbuttons

xNext = 2*mg;
yNext = mg;

h.optExpTr.checkbox_molValid = uicontrol('Style', 'checkbox', 'Units', ...
    'pixels', 'Parent', h.optExpTr.figure_optExpTr, 'String', ...
    'save sel. mol. only', 'FontSize', 8, 'Callback', ...
    {@checkbox_molValid_Callback, h_fig}, 'Position', ...
    [xNext yNext w_full_pan h_but]);

% popup for exporting tagged molecules individually; 
% added by FS, 24.4.2018
xNext = mg + 2/3*w_full_pan;
str_lst = colorTagNames(h_fig);
molTagStr = [str_lst, 'all selected'];
h.optExpTr.popup_molTagged = uicontrol('Style', 'popup', 'Units', ...
    'pixels', 'Parent', h.optExpTr.figure_optExpTr, 'String', molTagStr,...
    'Value', length(molTagStr), 'Callback', ...
    {@popup_molTagged_Callback, h_fig}, 'Position', ...
    [xNext yNext 1/2*w_full_pan h_but]);

% update parameter with current value
% added by MH, 08.02.2019
guidata(h_fig,h);
popup_molTagged_Callback(h.optExpTr.popup_molTagged, [], h_fig);
h = guidata(h_fig);

xNext = wFig - 3*w_but - 3*mg;
yNext = mg;

h.optExpTr.pushbutton_infos = uicontrol('Style', 'pushbutton', ...
    'Parent', h.optExpTr.figure_optExpTr, 'Units', 'pixels', ...
    'Position', [xNext yNext w_but h_but], 'String', 'Infos', ...
    'Callback', {@pushbutton_infos_Callback, h_fig});

xNext = xNext + w_but + mg;

h.optExpTr.pushbutton_cancel = uicontrol('Style', 'pushbutton', ...
    'Parent', h.optExpTr.figure_optExpTr, 'Units', 'pixels', ...
    'Position', [xNext yNext w_but h_but], 'String', 'Cancel', ...
    'Callback', {@pushbutton_cancel_Callback, h_fig});

xNext = xNext + w_but + mg;

h.optExpTr.pushbutton_next = uicontrol('Style', 'pushbutton', ...
    'Parent', h.optExpTr.figure_optExpTr, 'Units', 'pixels', ...
    'Position', [xNext yNext w_but h_but], 'String', 'Next >>', ...
    'Callback', {@pushbutton_next_Callback, h_fig});

set(h.optExpTr.figure_optExpTr, 'Visible', 'on');

guidata(h_fig, h);
ud_optExpTr('all', h_fig);


% define colors for tag names; added by FS, 24.4.2018
function str_lst = colorTagNames(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
colorlist = {'transparent', '#4298B5', '#DD5F32', '#92B06A', '#ADC4CC', '#E19D29'};
str_lst = cell(1,length(p.proj{proj}.molTagNames));
str_lst{1} = p.proj{proj}.molTagNames{1};
 
for k = 2:length(p.proj{proj}.molTagNames)
    str_lst{k} = ['<html><body  bgcolor="' colorlist{k} '">' ...
        '<font color="white">' p.proj{proj}.molTagNames{k} '</font></body></html>'];
end


function radiobutton_saveFig_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{1}(1) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function popupmenu_figFmt_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{1}(2) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function edit_nMol_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = 20;
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 && ...
        val <= max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Number of molecules per figure must be > 0 and <= 8.',...
        h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{1}(3) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function checkbox_subImg_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{1}(4) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function checkbox_top_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{2}{1}(1) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function popupmenu_topExc_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{2}{1}(2) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function popupmenu_topChan_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{2}{1}(3) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function checkbox_bottom_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{2}{2}(1) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function popupmenu_botChan_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{2}{2}(2) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function checkbox_figHist_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{1}(5) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function checkbox_figDiscr_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{1}(6) = val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function pushbutton_preview_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
incl = p.proj{proj}.coord_incl;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
[o,m_valid,o] = find(incl);

prm = p.proj{proj}.exp.fig;
molPerFig = prm{1}(3);
min_end = min([molPerFig numel(m_valid)]);
p_fig.isSubimg = prm{1}(4);
p_fig.isHist = prm{1}(5);
p_fig.isDiscr = prm{1}(6);
p_fig.isTop = prm{2}{1}(1);
p_fig.topExc = prm{2}{1}(2);
p_fig.topChan = prm{2}{1}(3);
if nFRET > 0 || nS > 0
    p_fig.isBot = prm{2}{2}(1);
    p_fig.botChan = prm{2}{2}(2);
else
    p_fig.isBot = 0;
    p_fig.botChan = 0;
end

% added by MH, 10.4.2019
disp('building figure preview in process ...');

h_fig_mol = [];
m_i = 0;
for m = m_valid(1:min_end)
    m_i = m_i + 1;
    h_fig_mol = buildFig(p, m, m_i, molPerFig, p_fig, h_fig_mol);
end
set(h_fig_mol, 'Visible', 'on');

% added by MH, 10.4.2019
disp('figure preview successfully built.');


function radiobutton_noFig_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.fig{1}(1) = ~val;
guidata(h_fig, h);
ud_optExpTr('fig', h_fig);


function radiobutton_saveDt_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.dt{1} = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


function checkbox_dtI_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.dt{2}(1) = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


function checkbox_dtFRET_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.dt{2}(2) = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


function checkbox_dtS_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.dt{2}(3) = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


function checkbox_kin_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.dt{2}(4) = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


function radiobutton_noDt_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.dt{1} = ~val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


function radiobutton_saveHist_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{1}(1) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function radiobutton_noHist_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{1}(1) = ~val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function checkbox_histI_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1,1) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_minI_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1,4);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. value must be < max. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
perSec = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(4);
perPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(5);
if perSec
    rate = h.param.ttPr.proj{h.param.ttPr.curr_proj}.frame_rate;
    val = val*rate;
end
if perPix
    nPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.pix_intgr(2);
    val = val*nPix;
end
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1,2) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_binI_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = abs(diff(h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1, ...
    [2 4])));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Bin value must be < interval size', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
perSec = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(4);
perPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(5);
if perSec
    rate = h.param.ttPr.proj{h.param.ttPr.curr_proj}.frame_rate;
    val = val*rate;
end
if perPix
    nPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.pix_intgr(2);
    val = val*nPix;
end
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1,3) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_maxI_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
min = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1,2);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > min)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. value must be > min. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
perSec = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(4);
perPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(5);
if perSec
    rate = h.param.ttPr.proj{h.param.ttPr.curr_proj}.frame_rate;
    val = val*rate;
end
if perPix
    nPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.pix_intgr(2);
    val = val*nPix;
end
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1,4) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function checkbox_histFRET_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2,1) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_minFRET_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2,4);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. value must be < max. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2,2) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_binFRET_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = abs(diff(h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2, ...
    [2 4])));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Bin value must be < interval size', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2,3) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_maxFRET_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
min = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2,2);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > min)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. value must be > min. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2,4) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function checkbox_histS_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(3,1) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_minS_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(3,4);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. value must be < max. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(3,2) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_binS_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = abs(diff(h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(3, ...
    [2 4])));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Bin value must be < interval size', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(3,3) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function edit_maxS_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
min = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(3,2);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > min)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. value must be > min. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(3,4) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function checkbox_histDiscr_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{1}(2) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


function radiobutton_saveTr_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{1}(1) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


function popupmenu_trFmt_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{1}(2) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


function checkbox_trI_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{2}(1) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


function checkbox_trFRET_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{2}(2) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


function checkbox_trS_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{2}(3) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


function checkbox_trAll_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{2}(4) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


% added by FS, 17.3.2018
function checkbox_gam_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{2}(6) = val;
guidata(h_fig, h);
ud_optExpTr('dt', h_fig);


function popupmenu_trPrm_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);

% added by MH, 10.4.2019
trFmt = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{1}(2);
if val==2 && sum(trFmt==[2,3,4,5,6])
    trFmt_txt = get(h.optExpTr.popupmenu_trFmt,'String');
    setContPan(cat(2,'Processing parameters can not be written in headers',...
        ' of files with format:',trFmt_txt{trFmt}),'error',h_fig);
    set(obj, 'Value', 1);
    return;
end

h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{2}(5) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


function radiobutton_noTr_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{1}(1) = ~val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


function checkbox_molValid_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.mol_valid = val;
guidata(h_fig, h);
ud_optExpTr('all', h_fig);


% added by FS, 24.4.2018
function popup_molTagged_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.mol_TagVal = val;
guidata(h_fig, h);
ud_optExpTr('all', h_fig);



function pushbutton_infos_Callback(obj, evd, h_fig)

% modified by MH, 10.4.2019
% msgbox('Soon avaiblable');
disp('open MASH online documentation, please wait...');
web(cat(2,'https://rna-fretools.github.io/MASH-FRET/trace-processing/',...
    'functionalities/set-export-options.html'));


function pushbutton_cancel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
close(h.optExpTr.figure_optExpTr);


function pushbutton_next_Callback(obj, evd, h_fig)
h = guidata(h_fig);
choice = questdlg('Automatically process molecules unprocessed? ', ...
    'Processing before saving', 'Yes', 'No', 'Cancel', 'Yes');
if strcmp(choice, 'Yes')
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.process = 1;
elseif strcmp(choice, 'No')
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.process = 0;
else
    return;
end
guidata(h_fig, h);
p = h.param.ttPr;
proj = p.curr_proj;
name_proj = p.proj{proj}.proj_file;
if ~isempty(name_proj)
    [o,name_proj,o] = fileparts(name_proj);
end
defname = [setCorrectPath('traces_processing', h_fig) name_proj];

[fname,pname,o] = uiputfile({'*.*', 'All files(*.*)'}, ...
    'Save processed data', defname);
if ~isempty(fname) && sum(fname)
    [o,fname_proc,o] = fileparts(fname);
    close(h.optExpTr.figure_optExpTr);
    saveProcAscii(h_fig, h.param.ttPr, h.param.ttPr.proj{proj}.exp, ...
        pname, fname_proc);
end


function figure_optExpTr_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'optExpTr');
    h = rmfield(h, 'optExpTr');
    guidata(h_fig, h);
end

delete(obj);


function ud_optExpTr(opt, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
prm = p.proj{proj}.exp;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

set(h.optExpTr.checkbox_molValid, 'Value', prm.mol_valid);
if prm.mol_valid
    set(h.optExpTr.checkbox_molValid, 'ForegroundColor', [0 0 1]);
else
    set(h.optExpTr.checkbox_molValid, 'ForegroundColor', [0 0 0]);
end

if strcmp(opt, 'tr') || strcmp(opt, 'all')
    
    set(h.optExpTr.radiobutton_saveTr, 'Value', prm.traces{1}(1));
    set(h.optExpTr.radiobutton_noTr, 'Value', ~prm.traces{1}(1));
    
    % cancelled by MH, 10.4.2019
%     set(h.optExpTr.popupmenu_trFmt, 'Value', prm.traces{1}(2));
%     dat_txt = get(h.optExpTr.text_trInfos, 'UserData');
%     set(h.optExpTr.text_trInfos, 'String', dat_txt(prm.traces{1}(2)));
%     set(h.optExpTr.checkbox_trI, 'Value', prm.traces{2}(1));
%     set(h.optExpTr.checkbox_trFRET, 'Value', prm.traces{2}(2));
%     set(h.optExpTr.checkbox_trS, 'Value', prm.traces{2}(3));
%     set(h.optExpTr.checkbox_trAll, 'Value', prm.traces{2}(4));
%     set(h.optExpTr.popupmenu_trPrm, 'Value', prm.traces{2}(5));
%     set(h.optExpTr.checkbox_gam, 'Value', prm.traces{2}(6));  % added by FS, 4.4.2017
    
    if prm.traces{1}(1)
        
        % moved here by MH, 10.4.2019
        set(h.optExpTr.popupmenu_trFmt, 'Value', prm.traces{1}(2));
        dat_txt = get(h.optExpTr.text_trInfos, 'UserData');
        set(h.optExpTr.text_trInfos, 'String', dat_txt(prm.traces{1}(2)));
        set(h.optExpTr.checkbox_trI, 'Value', prm.traces{2}(1));
        set(h.optExpTr.checkbox_trFRET, 'Value', prm.traces{2}(2));
        set(h.optExpTr.checkbox_trS, 'Value', prm.traces{2}(3));
        set(h.optExpTr.checkbox_trAll, 'Value', prm.traces{2}(4));
        set(h.optExpTr.popupmenu_trPrm, 'Value', prm.traces{2}(5));
        set(h.optExpTr.checkbox_gam, 'Value', prm.traces{2}(6));  % added by FS, 4.4.2017
        
        set(h.optExpTr.radiobutton_saveTr, 'FontWeight', 'bold');
        set(h.optExpTr.radiobutton_noTr, 'FontWeight', 'normal');
        set([h.optExpTr.text_trFmt h.optExpTr.popupmenu_trFmt ...
            h.optExpTr.text_tr2exp h.optExpTr.text_trInfos ...
            h.optExpTr.checkbox_gam h.optExpTr.text_trPrm ...
            h.optExpTr.popupmenu_trPrm],'Enable', 'on');
        if sum(double(prm.traces{1}(2) == [1 7])) % ASCII or all
            set([h.optExpTr.checkbox_trI h.optExpTr.checkbox_trFRET ...
                h.optExpTr.checkbox_trS h.optExpTr.checkbox_trAll], ...
                'Enable', 'on');
        else
            % modified by MH, 10.4.2019
%             set([h.optExpTr.checkbox_trI h.optExpTr.checkbox_trFRET ...
%                 h.optExpTr.checkbox_trS h.optExpTr.checkbox_trAll], ...
%                 'Enable', 'off');
            set(h.optExpTr.checkbox_trI,'Value',1,'Enable','off');
            set([h.optExpTr.checkbox_trFRET h.optExpTr.checkbox_trS ...
                h.optExpTr.checkbox_trAll],'Value', 0, 'Enable', 'off');
        end

    else
        set(h.optExpTr.radiobutton_saveTr, 'FontWeight', 'normal');
        set(h.optExpTr.radiobutton_noTr, 'FontWeight', 'bold');
        set([h.optExpTr.text_trFmt h.optExpTr.popupmenu_trFmt ...
            h.optExpTr.text_tr2exp h.optExpTr.text_trInfos ...
            h.optExpTr.checkbox_trI h.optExpTr.checkbox_trFRET ...
            h.optExpTr.checkbox_trS h.optExpTr.checkbox_trAll ...
            h.optExpTr.checkbox_gam h.optExpTr.text_trPrm ...
            h.optExpTr.popupmenu_trPrm],'Enable', 'off');
        
        % added by MH, 10.4.2019
        set([h.optExpTr.checkbox_trI h.optExpTr.checkbox_trFRET ...
            h.optExpTr.checkbox_trS h.optExpTr.checkbox_trAll ...
            h.optExpTr.checkbox_gam], 'Value', 0);
    end
    if ~nFRET
        set([h.optExpTr.checkbox_trFRET h.optExpTr.checkbox_gam], ...
            'Enable','off');
    end
    if ~nS
        set(h.optExpTr.checkbox_trS, 'Enable', 'off');
    end
    if nS + nFRET == 0
        set(h.optExpTr.checkbox_trAll, 'Enable', 'off');
    end
end

if strcmp(opt, 'hist') || strcmp(opt, 'all')
    set(h.optExpTr.radiobutton_saveHist, 'Value', prm.hist{1}(1));
    set(h.optExpTr.radiobutton_noHist, 'Value', ~prm.hist{1}(1));
    
    % cancel by MH, 10.4.2019
%     set(h.optExpTr.checkbox_histDiscr, 'Value', prm.hist{1}(2));
%     set(h.optExpTr.checkbox_histI, 'Value', prm.hist{2}(1,1));
%     perSec = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(4);
%     perPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(5);
%     if perSec
%         rate = h.param.ttPr.proj{h.param.ttPr.curr_proj}.frame_rate;
%         prm.hist{2}(1,2:4) = prm.hist{2}(1,2:4)/rate;
%     end
%     if perPix
%         nPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.pix_intgr(2);
%         prm.hist{2}(1,2:4) = prm.hist{2}(1,2:4)/nPix;
%     end
%     set(h.optExpTr.edit_minI, 'String', num2str(prm.hist{2}(1,2)));
%     set(h.optExpTr.edit_binI, 'String', num2str(prm.hist{2}(1,3)));
%     set(h.optExpTr.edit_maxI, 'String', num2str(prm.hist{2}(1,4)));
%     set(h.optExpTr.checkbox_histFRET, 'Value', prm.hist{2}(2,1));
%     set(h.optExpTr.edit_minFRET, 'String', num2str(prm.hist{2}(2,2)));
%     set(h.optExpTr.edit_binFRET, 'String', num2str(prm.hist{2}(2,3)));
%     set(h.optExpTr.edit_maxFRET, 'String', num2str(prm.hist{2}(2,4)));
%     set(h.optExpTr.checkbox_histS, 'Value', prm.hist{2}(3,1));
%     set(h.optExpTr.edit_minS, 'String', num2str(prm.hist{2}(3,2)));
%     set(h.optExpTr.edit_binS, 'String', num2str(prm.hist{2}(3,3)));
%     set(h.optExpTr.edit_maxS, 'String', num2str(prm.hist{2}(3,4)));
    
    
    if prm.hist{1}(1)
        
        set(h.optExpTr.radiobutton_saveHist, 'FontWeight', 'bold');
        set(h.optExpTr.radiobutton_noHist, 'FontWeight', 'normal');
        
        % moved here by MH, 10.4.2019
        set(h.optExpTr.checkbox_histDiscr, 'Value', prm.hist{1}(2));
        set(h.optExpTr.checkbox_histI, 'Value', prm.hist{2}(1,1));
        perSec = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(4);
        perPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(5);
        if perSec
            rate = h.param.ttPr.proj{h.param.ttPr.curr_proj}.frame_rate;
            prm.hist{2}(1,2:4) = prm.hist{2}(1,2:4)/rate;
        end
        if perPix
            nPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.pix_intgr(2);
            prm.hist{2}(1,2:4) = prm.hist{2}(1,2:4)/nPix;
        end
        set(h.optExpTr.edit_minI, 'String', num2str(prm.hist{2}(1,2)));
        set(h.optExpTr.edit_binI, 'String', num2str(prm.hist{2}(1,3)));
        set(h.optExpTr.edit_maxI, 'String', num2str(prm.hist{2}(1,4)));
        set(h.optExpTr.checkbox_histFRET, 'Value', prm.hist{2}(2,1));
        set(h.optExpTr.edit_minFRET, 'String', num2str(prm.hist{2}(2,2)));
        set(h.optExpTr.edit_binFRET, 'String', num2str(prm.hist{2}(2,3)));
        set(h.optExpTr.edit_maxFRET, 'String', num2str(prm.hist{2}(2,4)));
        set(h.optExpTr.checkbox_histS, 'Value', prm.hist{2}(3,1));
        set(h.optExpTr.edit_minS, 'String', num2str(prm.hist{2}(3,2)));
        set(h.optExpTr.edit_binS, 'String', num2str(prm.hist{2}(3,3)));
        set(h.optExpTr.edit_maxS, 'String', num2str(prm.hist{2}(3,4)));

        set([h.optExpTr.text_hist2exp h.optExpTr.text_min ...
            h.optExpTr.text_bin h.optExpTr.text_max ...
            h.optExpTr.checkbox_histDiscr h.optExpTr.checkbox_histI ...
            h.optExpTr.checkbox_histFRET h.optExpTr.checkbox_histS], ...
            'Enable', 'on');
        if prm.hist{2}(1,1) % intensities
            set([h.optExpTr.edit_minI h.optExpTr.edit_binI ...
                h.optExpTr.edit_maxI], 'Enable', 'on');
        else
            set([h.optExpTr.edit_minI h.optExpTr.edit_binI ...
                h.optExpTr.edit_maxI], 'Enable', 'off');
        end
        if prm.hist{2}(2,1) % FRET
            set([h.optExpTr.edit_minFRET h.optExpTr.edit_binFRET ...
                h.optExpTr.edit_maxFRET], 'Enable', 'on');
        else
            set([h.optExpTr.edit_minFRET h.optExpTr.edit_binFRET ...
                h.optExpTr.edit_maxFRET], 'Enable', 'off');
        end
        if prm.hist{2}(3,1) % S
            set([h.optExpTr.edit_minS h.optExpTr.edit_binS ...
                h.optExpTr.edit_maxS], 'Enable', 'on');
        else
            set([h.optExpTr.edit_minS h.optExpTr.edit_binS ...
                h.optExpTr.edit_maxS], 'Enable', 'off');
        end

    else
        set(h.optExpTr.radiobutton_saveHist, 'FontWeight', 'normal');
        set(h.optExpTr.radiobutton_noHist, 'FontWeight', 'bold');
        set([h.optExpTr.text_hist2exp h.optExpTr.text_min ...
            h.optExpTr.text_bin h.optExpTr.text_max ...
            h.optExpTr.checkbox_histDiscr h.optExpTr.checkbox_histI ...
            h.optExpTr.checkbox_histFRET h.optExpTr.checkbox_histS ...
            h.optExpTr.edit_minI h.optExpTr.edit_binI ...
            h.optExpTr.edit_maxI h.optExpTr.edit_minFRET ...
            h.optExpTr.edit_binFRET h.optExpTr.edit_maxFRET ...
            h.optExpTr.edit_minS h.optExpTr.edit_binS ...
            h.optExpTr.edit_maxS], 'Enable', 'off');
        
        % added by MH, 10.4.2019
        set([h.optExpTr.checkbox_histDiscr h.optExpTr.checkbox_histI ...
            h.optExpTr.checkbox_histFRET h.optExpTr.checkbox_histS],...
            'Value',0);
        set([h.optExpTr.edit_minI h.optExpTr.edit_binI ...
            h.optExpTr.edit_maxI h.optExpTr.edit_minFRET ...
            h.optExpTr.edit_binFRET h.optExpTr.edit_maxFRET ...
            h.optExpTr.edit_minS h.optExpTr.edit_binS ...
            h.optExpTr.edit_maxS],'String','');
    end
    if ~nFRET
        set([h.optExpTr.checkbox_histFRET h.optExpTr.edit_minFRET ...
            h.optExpTr.edit_binFRET h.optExpTr.edit_maxFRET], 'Enable', ...
            'off');
    end
    if ~nS
        set([h.optExpTr.checkbox_histS h.optExpTr.edit_minS ...
            h.optExpTr.edit_binS h.optExpTr.edit_maxS], 'Enable', 'off');
    end
end

if strcmp(opt, 'dt') || strcmp(opt, 'all')
    set(h.optExpTr.radiobutton_saveDt, 'Value', prm.dt{1});
    set(h.optExpTr.radiobutton_noDt, 'Value', ~prm.dt{1});
    
    % cancelled by MH, 10.4.2019
%     set(h.optExpTr.checkbox_dtI, 'Value', prm.dt{2}(1));
%     set(h.optExpTr.checkbox_dtFRET, 'Value', prm.dt{2}(2));
%     set(h.optExpTr.checkbox_dtS, 'Value', prm.dt{2}(3));
%     set(h.optExpTr.checkbox_kin, 'Value', prm.dt{2}(4));
    
    if prm.dt{1}
        
        % moved here by MH, 10.4.2019
        set(h.optExpTr.checkbox_dtI, 'Value', prm.dt{2}(1));
        set(h.optExpTr.checkbox_dtFRET, 'Value', prm.dt{2}(2));
        set(h.optExpTr.checkbox_dtS, 'Value', prm.dt{2}(3));
        set(h.optExpTr.checkbox_kin, 'Value', prm.dt{2}(4));
    
        set(h.optExpTr.radiobutton_saveDt, 'FontWeight', 'bold');
        set(h.optExpTr.radiobutton_noDt, 'FontWeight', 'normal');
        set([h.optExpTr.text_dt2exp h.optExpTr.checkbox_dtI ...
            h.optExpTr.checkbox_dtFRET h.optExpTr.checkbox_dtS ...
            h.optExpTr.checkbox_kin], 'Enable', 'on');

    else
        set(h.optExpTr.radiobutton_saveDt, 'FontWeight', 'normal');
        set(h.optExpTr.radiobutton_noDt, 'FontWeight', 'bold');
        set([h.optExpTr.text_dt2exp h.optExpTr.checkbox_dtI ...
            h.optExpTr.checkbox_dtFRET h.optExpTr.checkbox_dtS ...
            h.optExpTr.checkbox_kin], 'Enable', 'off');
        
        % added by MH, 10.4.2019
        set([h.optExpTr.checkbox_dtI h.optExpTr.checkbox_dtFRET ...
            h.optExpTr.checkbox_dtS h.optExpTr.checkbox_kin],'Value',0);
    end
    if ~nFRET
        set(h.optExpTr.checkbox_dtFRET, 'Enable', 'off');
    end
    if ~nS
        set(h.optExpTr.checkbox_dtS, 'Enable', 'off');
    end
end

if strcmp(opt, 'fig') || strcmp(opt, 'all')
    set(h.optExpTr.radiobutton_saveFig, 'Value', prm.fig{1}(1));
    set(h.optExpTr.radiobutton_noFig, 'Value', ~prm.fig{1}(1));
    
    % cancelled by MH, 10.4.2019
%     set(h.optExpTr.popupmenu_figFmt, 'Value', prm.fig{1}(2));
%     set(h.optExpTr.edit_nMol, 'String', num2str(prm.fig{1}(3)));
%     set(h.optExpTr.checkbox_subImg, 'Value', prm.fig{1}(4));
%     set(h.optExpTr.checkbox_figHist, 'Value', prm.fig{1}(5));
%     set(h.optExpTr.checkbox_figDiscr, 'Value', prm.fig{1}(6));
%     set(h.optExpTr.checkbox_top, 'Value', prm.fig{2}{1}(1));
%     set(h.optExpTr.popupmenu_topExc, 'Value', prm.fig{2}{1}(2));
%     set(h.optExpTr.popupmenu_topChan, 'Value', prm.fig{2}{1}(3));
%     set(h.optExpTr.checkbox_bottom, 'Value', prm.fig{2}{2}(1));
    
    if prm.fig{1}(1)
        set(h.optExpTr.radiobutton_saveFig, 'FontWeight', 'bold');
        set(h.optExpTr.radiobutton_noFig, 'FontWeight', 'normal');
        
        % moved here by MH, 10.4.2019
        set(h.optExpTr.popupmenu_figFmt, 'Value', prm.fig{1}(2));
        set(h.optExpTr.edit_nMol, 'String', num2str(prm.fig{1}(3)));
        set(h.optExpTr.checkbox_subImg, 'Value', prm.fig{1}(4));
        set(h.optExpTr.checkbox_figHist, 'Value', prm.fig{1}(5));
        set(h.optExpTr.checkbox_figDiscr, 'Value', prm.fig{1}(6));
        set(h.optExpTr.checkbox_top, 'Value', prm.fig{2}{1}(1));
        set(h.optExpTr.popupmenu_topExc, 'Value', prm.fig{2}{1}(2));
        set(h.optExpTr.popupmenu_topChan, 'Value', prm.fig{2}{1}(3));
        set(h.optExpTr.checkbox_bottom, 'Value', prm.fig{2}{2}(1));
        
        % added by MH, 10.4.2019
        dat_txt = get(h.optExpTr.text_figInfos, 'UserData');
        set(h.optExpTr.text_figInfos, 'String', dat_txt(prm.fig{1}(2)));
        
        set([h.optExpTr.text_figFmt h.optExpTr.popupmenu_figFmt ...
            h.optExpTr.text_nMol h.optExpTr.edit_nMol ...
            h.optExpTr.checkbox_subImg h.optExpTr.checkbox_top ...
            h.optExpTr.checkbox_bottom h.optExpTr.checkbox_figHist ...
            h.optExpTr.checkbox_figDiscr h.optExpTr.pushbutton_preview],...
            'Enable', 'on');
        
        if prm.fig{2}{1}(1) % top axes
            set([h.optExpTr.popupmenu_topExc ...
                h.optExpTr.popupmenu_topChan] , 'Enable', 'on');
        else
            set([h.optExpTr.popupmenu_topExc ...
                h.optExpTr.popupmenu_topChan] , 'Enable', 'off');
        end
        if prm.fig{2}{2}(1) % bottom axes
            set(h.optExpTr.popupmenu_botChan, 'Enable', 'on', 'Value', ...
                prm.fig{2}{2}(2));
        else
            set(h.optExpTr.popupmenu_botChan, 'Enable', 'off');
        end
        if ~prm.fig{2}{1}(1) && ~prm.fig{2}{2}(1)
            set([h.optExpTr.checkbox_figHist ...
                h.optExpTr.checkbox_figDiscr], 'Enable', 'off');
        end
        
        % moved here by MH, 10.4.2019
        if ~nFRET && ~nS
            set([h.optExpTr.checkbox_bottom h.optExpTr.popupmenu_botChan], ...
                'Enable', 'off');
        end

    else
        set(h.optExpTr.radiobutton_saveFig, 'FontWeight', 'normal');
        set(h.optExpTr.radiobutton_noFig, 'FontWeight', 'bold');
        set([h.optExpTr.text_figFmt h.optExpTr.popupmenu_figFmt ...
            h.optExpTr.text_nMol h.optExpTr.edit_nMol ...
            h.optExpTr.checkbox_subImg h.optExpTr.checkbox_top ...
            h.optExpTr.popupmenu_topExc h.optExpTr.popupmenu_topChan ...
            h.optExpTr.checkbox_bottom h.optExpTr.popupmenu_botChan ...
            h.optExpTr.checkbox_figHist h.optExpTr.checkbox_figDiscr ...
            h.optExpTr.pushbutton_preview], 'Enable', 'off');
        
        % added by MH, 10.4.2019
        set([h.optExpTr.checkbox_subImg h.optExpTr.checkbox_top ...
            h.optExpTr.checkbox_bottom h.optExpTr.checkbox_figHist ...
            h.optExpTr.checkbox_figDiscr],'Value',0);
    end
    
    % cancelled by MH, 10.4.2019
%     if ~nFRET && ~nS
%         set([h.optExpTr.checkbox_bottom h.optExpTr.popupmenu_botChan], ...
%             'Enable', 'off');
%     end
end



