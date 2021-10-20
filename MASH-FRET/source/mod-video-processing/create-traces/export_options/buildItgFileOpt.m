function buildItgFileOpt(h_fig)

h = guidata(h_fig);
p = h.param;
expprm = p.proj{p.curr_proj}.VP.curr.gen_int{4};

mg = 10;
h_txt = 14;
h_edit = 20;
h_but = 22;

w_but = 53;

h_pan_files = mg + 8*(h_edit + mg);

w_pan = mg + 230 + mg;
wFig = mg + w_pan + mg;
hFig = mg + h_but + mg + h_pan_files + mg;

fig_name = 'Export options';

pos_0 = get(0, 'ScreenSize');
xFig = pos_0(1) + (pos_0(3) - wFig)/2;
yFig = pos_0(2) + (pos_0(4) - hFig)/2;
if hFig > pos_0(4)
    yFig = pos_0(4) - 30;
end

if ~(isfield(h, 'figure_itgFileOpt') && ishandle(h.figure_itgFileOpt))

    h.figure_itgFileOpt = figure('Color', [0.94 0.94 0.94], 'Resize', ...
        'off', 'NumberTitle', 'off', 'MenuBar', 'none', 'Name', ...
        fig_name, 'Visible', 'off', 'Units', 'pixels', ...
        'Position', [xFig yFig wFig hFig], 'CloseRequestFcn', ...
        {@figure_itgFileOpt_CloseRequestFcn, h_fig}, 'WindowStyle', ...
        'Modal');
    guidata(h.figure_itgFileOpt, expprm);

else
    posCurr = get(h.figure_itgFileOpt, 'Position');
    set(h.figure_itgFileOpt, 'Position', [posCurr(1) yFig wFig hFig]);
    figChild = get(h.figure_itgFileOpt, 'Children');
    for i = 1:numel(figChild)
        delete(figChild(i));
    end
    h = rmfield(h, 'itgFileOpt');
end

bgCol = get(h.figure_itgFileOpt, 'Color');

yNext = mg;
xNext = wFig - mg - w_but;

h.itgFileOpt.pushbutton_itgFileOpt_ok = uicontrol('Style', ...
    'pushbutton', 'Parent', h.figure_itgFileOpt, 'String', 'Next>>', ...
    'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_but h_but], 'Callback', ...
    {@pushbutton_itgFileOpt_ok_Callback, h_fig});

xNext = xNext - w_but - mg;

h.itgFileOpt.pushbutton_itgFileOpt_cancel = uicontrol('Style', ...
    'pushbutton', 'Parent', h.figure_itgFileOpt, 'String', 'Cancel', ...
    'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_but h_but], 'Callback', ...
    {@pushbutton_itgFileOpt_cancel_Callback, h_fig});

guidata(h_fig,h);
h.itgFileOpt.pushbutton_help = setInfoIcons(...
    h.itgFileOpt.pushbutton_itgFileOpt_cancel,h_fig,p.infos_icon_file);

yNext = yNext + h_but + mg;
xNext = mg;

h.itgFileOpt.uipanel_files = uipanel('Units', 'pixels', 'Parent', ...
    h.figure_itgFileOpt, 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_pan h_pan_files]);


%% Panel output files

switch expprm(1)
    case 1
        enbl = 'on';
    case 0
        enbl = 'off';
end

xNext = mg;
yNext = mg;

h.itgFileOpt.checkbox_ebFRET = uicontrol('Style', 'checkbox', ...
    'Parent', h.itgFileOpt.uipanel_files, 'String', ...
    'ebFRET compatible', 'Value', expprm(8), 'Position', ...
    [xNext yNext w_pan h_edit]);

yNext = yNext + h_edit + mg;

h.itgFileOpt.checkbox_SMART = uicontrol('Style', 'checkbox', ...
    'Parent', h.itgFileOpt.uipanel_files, 'String', ...
    'SMART compatible', 'Value', expprm(7), 'Position', ...
    [xNext yNext w_pan h_edit]);

yNext = yNext + h_edit + mg;

h.itgFileOpt.checkbox_QUB = uicontrol('Style', 'checkbox', ...
    'Parent', h.itgFileOpt.uipanel_files, 'String', ...
    'QUB compatible', 'Value', expprm(6), 'Position', ...
    [xNext yNext w_pan h_edit]);

yNext = yNext + h_edit + mg;

h.itgFileOpt.checkbox_vbFRET = uicontrol('Style', 'checkbox', ...
    'Parent', h.itgFileOpt.uipanel_files, 'String', ...
    'vbFRET compatible', 'Value', expprm(5), 'Position', ...
    [xNext yNext w_pan h_edit]);

yNext = yNext + h_edit + mg;

h.itgFileOpt.checkbox_HaMMy = uicontrol('Style', 'checkbox', ...
    'Parent', h.itgFileOpt.uipanel_files, 'String', ...
    'HaMMy compatible', 'Value', expprm(4), 'Position', ...
    [xNext yNext w_pan h_edit]);

yNext = yNext + h_edit + mg;
xNext = 2*mg;

h.itgFileOpt.checkbox_oneMol = uicontrol('Style', 'checkbox', ...
    'Parent', h.itgFileOpt.uipanel_files, 'String', ...
    'One file per molecule', 'Value', expprm(3), 'Position', ...
    [xNext yNext w_pan - mg h_edit], 'Enable', enbl);

yNext = yNext + h_edit + mg;

h.itgFileOpt.checkbox_allMol = uicontrol('Style', 'checkbox', ...
    'Parent', h.itgFileOpt.uipanel_files, 'String', ...
    'All molecules in one file', 'Value', expprm(2), 'Position', ...
    [xNext yNext w_pan - mg h_edit], 'Enable', enbl);

xNext = mg;
yNext = yNext + h_edit + mg;

h.itgFileOpt.checkbox_ASCII = uicontrol('Style', 'checkbox', ...
    'Parent', h.itgFileOpt.uipanel_files, 'String', 'ASCII traces', ...
    'Value', expprm(1), 'Position', [xNext yNext w_pan h_edit], ...
    'Callback', {@checkbox_FileASCII_Callback, h_fig});


guidata(h_fig, h);

uistack(h.itgFileOpt.pushbutton_itgFileOpt_ok, 'bottom');
uistack(h.itgFileOpt.pushbutton_itgFileOpt_cancel, 'bottom');

uistack(h.itgFileOpt.checkbox_ebFRET, 'bottom');
uistack(h.itgFileOpt.checkbox_SMART, 'bottom');
uistack(h.itgFileOpt.checkbox_QUB, 'bottom');
uistack(h.itgFileOpt.checkbox_vbFRET, 'bottom');
uistack(h.itgFileOpt.checkbox_HaMMy, 'bottom');
uistack(h.itgFileOpt.checkbox_oneMol, 'bottom');
uistack(h.itgFileOpt.checkbox_allMol, 'bottom');
uistack(h.itgFileOpt.checkbox_ASCII, 'bottom');

set(h.figure_itgFileOpt, 'Visible', 'on');
