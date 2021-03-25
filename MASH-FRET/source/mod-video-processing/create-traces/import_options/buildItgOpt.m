function buildItgOpt(p,but_obj,h_fig)
% buildItgOpt(p,but_obj,h_fig)
%
% Build window for co-localized coordinates import options
%
% p: {1-by-2} import settings with:
%  p{1}: [nChan-by-2] columns index in file where x- and y-coordinates are written for each channel
%  p{2}: number of file header lines
% but_obj: handle to pushbutton that was pressed to open window
% h_fig: handle to main figure

h = guidata(h_fig);

nChan = size(p{1,1},1);

mg = 10;
dim_but = [50 22];
dim_edit = [40 20];
dim_txt_short = [40 14];
dim_txt_chan = [52 14];
dim_txt_long = [120 14];
h_pan_mol = 10 + 2*mg + dim_txt_short(2) + dim_edit(2) + ...
    nChan*(dim_edit(2) + mg);
w_pan = 3*mg + dim_txt_long(1) + dim_edit(1);
hFig = h_pan_mol + 3*mg + dim_but(2);
wFig = w_pan + 2*mg;

prev_u = get(h_fig, 'Units');
set(h_fig, 'Units', 'pixels');
posFig = get(h_fig, 'Position');
set(h_fig, 'Units', prev_u);
xFig = posFig(1) + (posFig(3) - wFig)/2;
yFig = posFig(2) + (posFig(4) - hFig)/2;

h.figure_itgOpt = figure('Color', [0.94 0.94 0.94], 'Resize', ...
    'off', 'NumberTitle', 'off', 'MenuBar', 'none', 'Name', ...
    'Import options', 'Visible', 'off', 'Units', 'pixels', ...
    'Position', [xFig yFig wFig hFig], 'CloseRequestFcn', ...
    {@figure_itgOpt_CloseRequestFcn, h_fig}, 'WindowStyle', 'Modal');

bgCol = get(h.figure_itgOpt, 'Color');

yNext = mg;
xNext = mg;

h.itgOpt.pushbutton_itgOpt_ok = uicontrol('Style', 'pushbutton', ...
    'String', 'Ok', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
    'Position', [xNext yNext dim_but], 'Callback', ...
    {@pushbutton_itgOpt_ok_Callback, h_fig, but_obj});

xNext = xNext + dim_but(1) + mg;

h.itgOpt.pushbutton_itgOpt_cancel = uicontrol('Style', ...
    'pushbutton', 'String', 'Cancel', 'Units', 'pixels', ...
    'BackgroundColor', bgCol, 'Position', [xNext yNext dim_but], ...
    'Callback', {@pushbutton_itgOpt_cancel_Callback, h_fig});

yNext = yNext + dim_but(2) + mg;
xNext = mg;

h.itgOpt.uipanel_molCoord = uipanel('Title', ...
    'Molecule coordinates', 'Units', 'pixels', 'BackgroundColor', ...
    bgCol, 'Position', [xNext yNext w_pan h_pan_mol]);

% Panel molecule coordinates

yNext = 0;

for i = nChan:-1:1

    yNext = yNext + mg;
    xNext = mg;

    h.itgOpt.text_cChan(i) = uicontrol('Style', 'text', 'Parent', ...
        h.itgOpt.uipanel_molCoord, 'String', ['channel ' ...
        num2str(i) ':'], 'Units', 'pixels', 'BackgroundColor', ...
        bgCol, 'HorizontalAlignment', 'center', 'Position', ...
        [xNext yNext dim_txt_chan]);

    xNext = xNext + dim_txt_chan(1) + mg;

    h.itgOpt.edit_cColX(i) = uicontrol('Style', 'edit', 'Parent', ...
        h.itgOpt.uipanel_molCoord, 'String', ...
        num2str(p{1,1}(i,1)), 'Units', 'pixels', ...
        'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext dim_edit]);

    xNext = xNext + dim_edit(1) + mg;

    h.itgOpt.edit_cColY(i) = uicontrol('Style', 'edit', 'Parent', ...
        h.itgOpt.uipanel_molCoord, 'String', ...
        num2str(p{1,1}(i,2)), 'Units', 'pixels', ...
        'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext dim_edit]);

    yNext = yNext + dim_edit(2);

end

xNext = 2*mg + dim_txt_chan(1);

h.itgOpt.text_cColX = uicontrol('Style', 'text', 'Parent', ...
    h.itgOpt.uipanel_molCoord, 'String', 'x-col', 'Units', ...
    'pixels', 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext dim_txt_short]);

xNext = xNext + dim_edit(1) + mg;

h.itgOpt.text_cColY = uicontrol('Style', 'text', 'Parent', ...
    h.itgOpt.uipanel_molCoord, 'String', 'y-col', 'Units', ...
    'pixels', 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext dim_txt_short]);

yNext = yNext + dim_txt_short(2) + mg;
xNext = mg;

h.itgOpt.text_nHead = uicontrol('Style', 'text', 'Parent', ...
    h.itgOpt.uipanel_molCoord, 'String', ...
    'number of header lines:', 'Units', 'pixels', ...
    'BackgroundColor', bgCol, 'HorizontalAlignment', 'left', ...
    'Position', [xNext yNext dim_txt_long]);

xNext = xNext + dim_txt_long(1) + mg;

h.itgOpt.edit_nHead = uicontrol('Style', 'edit', 'Parent', ...
    h.itgOpt.uipanel_molCoord, 'String', ...
    num2str(p{1,2}), 'Units', 'pixels', ...
    'BackgroundColor', [1 1 1], 'Position', ...
    [xNext yNext dim_edit]);

guidata(h_fig, h);

set(h.figure_itgOpt, 'Visible', 'on');
    