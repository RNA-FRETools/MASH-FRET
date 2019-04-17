function openTrImpOpt(obj, evd, h)

% Last update: by MH, 5.4.2019
% --> saved empty file and directory for gamma import if the option is
%     unselected
%
% update: 28th of March 2019 by Melodie Hadzic
% --> Add "Gamma factor" panel in buildWinTrOpt (add functions
%     pushbutton_impGamFile_Callback and checkbox_impGam_Callback)
% --> Add "State trajectories" panel in buildWinTrOpt (recover UI controls
%     checkbox_dFRET, text_thcol, edit_thcol and text_every from panel 
%     "Intensity-time traces")
% --> Change "Movie" to "Video" in buildWinTrOpt
% --> Fix error when importing coordinates from file in 
%     pushbutton_impCoordFile_Callback

h_fig = h.figure_MASH;
p = h.param.ttPr.impPrm;
if size(p{1}{1},2) < 10
    p{1}{1} = [1 0 0 1 1 0 2 1 0 5];
    h.param.ttPr.impPrm = p;
    guidata(h.figure_MASH, h);
end

% adjust import parameters
nChan_imp = p{1}{1}(7);
for i = 1:nChan_imp
    if i > size(p{3}{3}{1},1)
        p{3}{3}{1}(i,1:2) = p{3}{3}{1}(i-1,1:2) + 2;
    end
end

buildWinTrOpt(p, h_fig);


function buildWinTrOpt(p, h_fig)

mg = 10;
h_txt = 14;
h_edit = 20; w_edit = 40;
h_but = 22; w_but_short = 22; w_but_med = 50; w_but_big = 98;
h_pop = 20; w_pop = 60;
h_cb = 20;
w_short = 30; w_med = 70; w_big = 90; w_full = 230;

h_pan_discr = 10 + h_cb + h_edit + 3*mg;
h_pan_gamma = 10 + h_cb + h_but + 3*mg;
h_pan_int = 10 + 5*h_edit + h_pop + h_txt + 8*mg;
h_pan_mov = 10 + h_cb + h_but + 3*mg;
h_pan_coord = 10 + 2*h_but + 2*h_edit + 5*mg;

w_pan = w_full + 2*mg;
hFig = h_pan_discr + h_pan_gamma + h_pan_int + h_pan_mov + h_pan_coord + ...
    h_but + 7*mg;
wFig = w_pan + 2*mg;

pos_0 = get(0, 'ScreenSize');
xFig = pos_0(1) + (pos_0(3) - wFig)/2;
yFig = pos_0(2) + (pos_0(4) - hFig)/2;
if hFig > pos_0(4)
    yFig = pos_0(4) - 30;
end

h = guidata(h_fig);

if ~(isfield(h, 'figure_trImpOpt') && ishandle(h.figure_trImpOpt))

    h.figure_trImpOpt = figure('Color', [0.94 0.94 0.94], 'Resize', ...
        'off', 'NumberTitle', 'off', 'MenuBar', 'none', 'Name', ...
        'Import ASCII options', 'Visible', 'off', 'Units', 'pixels', ...
        'Position', [xFig yFig wFig hFig], 'CloseRequestFcn', ...
        {@figure_trImpOpt_CloseRequestFcn, h_fig}, 'WindowStyle', 'Modal');
    guidata(h.figure_trImpOpt, p);

    
    bgCol = get(h.figure_trImpOpt, 'Color');

    yNext = mg;
    xNext = wFig - mg - w_but_med;

    h.trImpOpt.pushbutton_trImpOpt_ok = uicontrol('Style', ...
        'pushbutton', 'String', 'Save', 'Units', 'pixels', ...
        'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext w_but_med h_but], 'Callback', ...
        {@pushbutton_trImpOpt_ok_Callback, h_fig});

    xNext = xNext - w_but_med - mg;

    h.trImpOpt.pushbutton_trImpOpt_cancel = uicontrol('Style', ...
        'pushbutton', 'String', 'Cancel', 'Units', 'pixels', ...
        'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext w_but_med h_but], 'Callback', ...
        {@pushbutton_trImpOpt_cancel_Callback, h_fig});

    yNext = yNext + h_but + mg;
    xNext = mg;

    h.trImpOpt.uipanel_discr = uipanel('Title', 'State trajectories', ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'FontWeight', 'bold', ...
        'Position', [xNext yNext w_pan h_pan_discr]);
    
    yNext = yNext + h_pan_discr + mg;
    xNext = mg;
    
    h.trImpOpt.uipanel_gamma = uipanel('Title', 'Gamma factors', ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'FontWeight', 'bold', ...
        'Position', [xNext yNext w_pan h_pan_gamma]);
    
    yNext = yNext + h_pan_gamma + mg;
    xNext = mg;

    h.trImpOpt.uipanel_ITT = uipanel('Title', 'Intensity-time traces', ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'FontWeight', ...
        'bold', 'Position', [xNext yNext w_pan h_pan_int]);
    
    yNext = yNext + h_pan_int + mg;
    xNext = mg;
    
    h.trImpOpt.uipanel_mov = uipanel('Title', 'Single moelcule video', ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'FontWeight', 'bold', ...
        'Position', [xNext yNext w_pan h_pan_mov]);
     
    yNext = yNext + h_pan_mov + mg;
    xNext = mg;
    
    h.trImpOpt.uipanel_coord = uipanel('Title', 'Molecule coordinates', ...
        'Units', 'pixels', 'BackgroundColor', bgCol, 'FontWeight', ...
        'bold', 'Position', [xNext yNext w_pan h_pan_coord]);

   
    %% Coordinates panel
    
    if p{4}(1)
        enbl_ttfile = 'on';
    else
        enbl_ttfile = 'off';
    end
    if p{3}{1}
        enbl_extfile = 'on';
    else
        enbl_extfile = 'off';
    end
    
    if ~isempty(p{3}{2})
        [o,fname_coord,fext] = fileparts(p{3}{2});
        fname_coord = [fname_coord fext];
    else
        fname_coord = [];
    end

    yNext = mg;
    xNext = mg;
    
    h.trImpOpt.checkbox_inTTfile = uicontrol('Style', 'checkbox', ...
        'Parent', h.trImpOpt.uipanel_coord, 'String', ...
        'In traces file', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_big h_cb], 'Callback', ...
        {@checkbox_inTTfile_Callback, h_fig}, 'Value', p{4}(1));
    
    xNext = xNext + w_big + mg;
    
    h.trImpOpt.text_rowCoord = uicontrol('Style', 'text', 'Parent', ...
        h.trImpOpt.uipanel_coord, 'String', 'row:', 'Units', ...
        'pixels', 'BackgroundColor', bgCol, 'HorizontalAlignment', ...
        'left', 'Position', [xNext yNext w_short h_txt], 'Enable', ...
        enbl_ttfile);

    xNext = xNext + w_short;

    h.trImpOpt.edit_rowCoord = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_coord, 'String', num2str(p{4}(2)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', ...
        {@edit_rowCoord_Callback, h_fig}, 'Enable', enbl_ttfile);

    yNext = yNext + h_cb + mg;
    xNext = mg;
    
    h.trImpOpt.text_movWidth = uicontrol('Style', 'text', 'String', ...
        'Movie width:', 'HorizontalAlignment', 'left', 'Parent', ...
        h.trImpOpt.uipanel_coord, 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_med h_txt], 'Enable', enbl_extfile);
    
    xNext = xNext + w_med;
    
    h.trImpOpt.edit_movWidth = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_coord, 'String', num2str(p{3}{4}), ...
        'Callback', {@edit_movWidth_Callback, h_fig}, 'Position', ...
        [xNext yNext w_edit h_edit], 'BackgroundColor', [1 1 1], ...
        'Enable', enbl_extfile);
    
    yNext = yNext + h_edit + mg;
    xNext = mg;
    
    h.trImpOpt.pushbutton_impCoordFile = uicontrol('Style', ...
        'pushbutton', 'Parent', h.trImpOpt.uipanel_coord, ...
        'String', '...', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_but_short h_but], 'Enable', ...
        enbl_extfile, 'Callback', {@pushbutton_impCoordFile_Callback, ...
        h_fig});

    xNext = xNext + w_but_short + mg;

    h.trImpOpt.text_fnameCoord = uicontrol('Style', 'text', 'Parent', ...
        h.trImpOpt.uipanel_coord, 'String', fname_coord, 'Units', ...
        'pixels', 'BackgroundColor', [1 1 1], 'ForegroundColor', ...
        [0 0 1], 'HorizontalAlignment', 'left', 'Enable', enbl_extfile, ...
        'Position', [xNext yNext w_full-mg-w_but_short h_txt]);

    yNext = yNext + h_but + mg;
    xNext = mg;

    h.trImpOpt.checkbox_extFile = uicontrol('Style', 'checkbox', ...
        'Parent', h.trImpOpt.uipanel_coord, 'String', ...
        'External file', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_big h_cb], 'Callback', ...
        {@checkbox_extFile_Callback, h_fig}, 'Value', p{3}{1});

    xNext = xNext + w_big + mg;

    h.trImpOpt.pushbutton_impCoordOpt = uicontrol('Style', ...
        'pushbutton', 'Parent', h.trImpOpt.uipanel_coord, ...
        'String', 'Import options', 'Units', 'pixels', ...
        'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext w_but_big h_but], 'Enable', enbl_extfile, ...
        'Callback', {@pushbutton_impCoordOpt_Callback, h_fig});

    
    %% Video panel
    
    if p{2}{1}
        enbl_movfile = 'on';
    else
        enbl_movfile = 'off';
    end

    if ~isempty(p{2}{2})
        [o,fname_mov,fext] = fileparts(p{2}{2});
        fname_mov = [fname_mov fext];
    else
        fname_mov = [];
    end
    
    yNext = mg;
    xNext = mg;

    h.trImpOpt.pushbutton_impMovFile = uicontrol('Style', ...
        'pushbutton', 'Parent', h.trImpOpt.uipanel_mov, ...
        'String', '...', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_but_short h_but], 'Enable', ...
        enbl_movfile, 'Callback', {@pushbutton_impMovFile_Callback, ...
        h_fig});

    xNext = xNext + w_but_short + mg;

    h.trImpOpt.text_fnameMov = uicontrol('Style', 'text', 'Parent', ...
        h.trImpOpt.uipanel_mov, 'String', fname_mov, 'Units', ...
        'pixels', 'BackgroundColor', [1 1 1], 'ForegroundColor', ...
        [0 0 1], 'HorizontalAlignment', 'left', 'Enable', enbl_movfile, ...
        'Position', [xNext yNext w_full-mg-w_but_short h_txt]);
    
    yNext = yNext + h_but + mg;
    xNext = mg;
    
    h.trImpOpt.checkbox_impMov = uicontrol('Style', 'checkbox', ...
        'Parent', h.trImpOpt.uipanel_mov, 'String', ...
        'Video file', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_full h_cb], 'Callback', ...
        {@checkbox_impMov_Callback, h_fig}, 'Value', p{2}{1});
    
    
    %% Intensity-time traces panel
    
    if p{1}{1}(3)
        enbl_coltime = 'on';
    else
        enbl_coltime = 'off';
    end
    
    yNext = mg;
    xNext = mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'Wavelength:', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_med h_txt]);
    
    xNext = xNext + w_med;
    
    str_pop = {};
    for i = 1:p{1}{1}(8)
        if i > numel(p{1}{2})
            p{1}{2}(i) = round(p{1}{2}(1)*(1 + 0.2*(i-1)));
        end
        str_pop = {str_pop{:} ['exc. ' num2str(i)]};
    end
    
    h.trImpOpt.popupmenu_exc = uicontrol('Style', 'popupmenu', ...
        'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', str_pop, 'Position', [xNext yNext w_pop h_pop], ...
        'Callback', {@popupmenu_exc_Callback, h_fig}, 'Value', 1, ...
        'BackgroundColor', [1 1 1]);
    
    xNext = xNext + w_pop + mg;
    
    h.trImpOpt.edit_wl = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', num2str(p{1}{2}(1)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', {@edit_wl_Callback, ...
        h_fig});
    
    xNext = xNext + w_edit;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'nm', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_short h_txt]);
    
    yNext = yNext + h_pop + mg;
    xNext = mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'nb. of excitations:', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_big h_txt]);

    xNext = xNext + w_big;
    
    h.trImpOpt.edit_nbExc = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', num2str(p{1}{1}(8)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', {@edit_nbExc_Callback, ...
        h_fig});

    xNext = xNext + w_edit + mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', '(row-wise)', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_big h_txt]);

    yNext = yNext + h_edit + mg;
    xNext = mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'nb. of channels:', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_big h_txt]);

    xNext = xNext + w_big;
    
    h.trImpOpt.edit_nbChan = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', num2str(p{1}{1}(7)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', ...
        {@edit_nbChan_Callback, h_fig});
    
    xNext = xNext + w_edit + mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', '(column-wise)', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_big h_txt]);
    
    yNext = yNext + h_edit + mg;
    xNext = mg;

    h.trImpOpt.checkbox_timeCol = uicontrol('Style', 'checkbox', ...
        'Parent', h.trImpOpt.uipanel_ITT, 'String', ...
        'Time data', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_big h_cb], 'Callback', ...
        {@checkbox_timeCol_Callback, h_fig}, 'Value', p{1}{1}(3), ...
        'FontAngle', 'italic');
    
    xNext = xNext + w_big;
    
    h.trImpOpt.text_timeCol = uicontrol('Style', 'text', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', 'column:', ...
        'HorizontalAlignment', 'left', 'Position', ...
        [xNext yNext w_edit h_txt]);
    
    xNext = xNext + w_edit;
    
    h.trImpOpt.edit_timeCol = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', num2str(p{1}{1}(4)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', ...
        {@edit_timeCol_Callback, h_fig}, 'Enable', enbl_coltime);

    yNext = yNext + h_edit + mg;
    xNext = mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'column:', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_edit h_txt]);

    xNext = xNext + w_edit;
    
    h.trImpOpt.edit_startColI = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', num2str(p{1}{1}(5)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', ...
        {@edit_startColI_Callback, h_fig});
    
    xNext = xNext + w_edit;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'to', 'HorizontalAlignment', 'center', ...
        'Position', [xNext yNext w_short h_txt]);
    
    xNext = xNext + w_short;
    
    h.trImpOpt.edit_stopColI = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', num2str(p{1}{1}(6)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', ...
        {@edit_stopColI_Callback, h_fig});

    xNext = xNext + w_edit + mg;

    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', '(0 = end)', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_full-2*(w_short+mg+w_edit) h_txt]);
    
    yNext = yNext + h_edit + mg;
    xNext = mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'row:', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_edit h_txt]);
    
    xNext = xNext + w_edit;
    
    h.trImpOpt.edit_startRow = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', num2str(p{1}{1}(1)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', ...
        {@edit_startRow_Callback, h_fig});
    
    xNext = xNext + w_edit;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'to', 'HorizontalAlignment', 'center', ...
        'Position', [xNext yNext w_short h_txt]);
    
    xNext = xNext + w_short;
    
    h.trImpOpt.edit_stopRow = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_ITT, 'String', num2str(p{1}{1}(2)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', ...
        {@edit_stopRow_Callback, h_fig});
    
    xNext = xNext + w_edit + mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', '(0 = end)', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_med h_txt]);
    
    yNext = yNext + h_edit + mg;
    xNext = mg;
    
    uicontrol('Style', 'text', 'Parent', h.trImpOpt.uipanel_ITT, ...
        'String', 'Intensity data:', 'HorizontalAlignment', 'left', ...
        'Position', [xNext yNext w_full h_txt], 'FontAngle', 'italic');
    
    
    %% Gamma factors panel
    
    if p{6}{1}
        enbl_gamfile = 'on';
    else
        enbl_gamfile = 'off';
    end
    
    str_file = '';
    if ~isempty(p{6}{3})
        fname_gam = p{6}{3};
        for i = 1:numel(fname_gam)
            str_file = cat(2,str_file,fname_gam{i},'; ');
        end
        str_file = str_file(1:end-2);
    end
    
    yNext = mg;
    xNext = mg;

    h.trImpOpt.pushbutton_impGamFile = uicontrol('Style', ...
        'pushbutton', 'Parent', h.trImpOpt.uipanel_gamma, ...
        'String', '...', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_but_short h_but], 'Enable', ...
        enbl_gamfile, 'Callback', {@pushbutton_impGamFile_Callback, ...
        h_fig});

    xNext = xNext + w_but_short + mg;

    h.trImpOpt.text_fnameGam = uicontrol('Style', 'text', 'Parent', ...
        h.trImpOpt.uipanel_gamma, 'String', str_file, 'Units', ...
        'pixels', 'BackgroundColor', [1 1 1], 'ForegroundColor', ...
        [0 0 1], 'HorizontalAlignment', 'left', 'Enable', enbl_gamfile, ...
        'Position', [xNext yNext w_full-mg-w_but_short h_txt]);
    
    yNext = yNext + h_but + mg;
    xNext = mg;
    
    h.trImpOpt.checkbox_impGam = uicontrol('Style', 'checkbox', ...
        'Parent', h.trImpOpt.uipanel_gamma, 'String', ...
        'Gamma factors file', 'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_full h_cb], 'Callback', ...
        {@checkbox_impGam_Callback, h_fig}, 'Value', p{6}{1});
    
    
    %% State trajectories panel
    
    if p{1}{1}(9)
        enbl_colFRET = 'on';
    else
        enbl_colFRET = 'off';
    end
    
    yNext = mg;
    xNext = mg;
    
    h.trImpOpt.text_every = uicontrol('Style', 'text', 'Parent', ...
        h.trImpOpt.uipanel_discr, 'String', 'every', ...
        'HorizontalAlignment', 'left', 'Position', ...
        [xNext yNext w_edit h_txt], 'Enable', enbl_colFRET);
    
    xNext = xNext + w_edit;
    
    h.trImpOpt.edit_thcol = uicontrol('Style', 'edit', 'Parent', ...
        h.trImpOpt.uipanel_discr, 'String', num2str(p{1}{1}(10)), ...
        'Units', 'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
        [xNext yNext w_edit h_edit], 'Callback', {@edit_thcol_Callback, ...
        h_fig}, 'Enable', enbl_colFRET);
    
    xNext = xNext + w_edit;
    
    h.trImpOpt.text_thcol = uicontrol('Style', 'text', 'Parent', ...
        h.trImpOpt.uipanel_discr, 'String', 'th column.', ...
        'HorizontalAlignment', 'left', 'Position', ...
        [xNext yNext w_med h_txt], 'Enable', enbl_colFRET);

    yNext = yNext + h_edit + mg;
    xNext = mg;
    
    h.trImpOpt.checkbox_dFRET = uicontrol('Style', 'checkbox', 'Parent',...
        h.trImpOpt.uipanel_discr, 'String', 'discretised FRET data', ...
        'Units', 'pixels', 'BackgroundColor', bgCol, ...
        'Position', [xNext yNext w_full h_cb], 'Callback', ...
        {@checkbox_dFRET_Callback, h_fig}, 'Value', p{1}{1}(9), ...
        'FontAngle', 'italic');
    
    guidata(h_fig, h);

    set(h.figure_trImpOpt, 'Visible', 'on');
end


function figure_trImpOpt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'trImpOpt');
    h = rmfield(h, {'trImpOpt', 'figure_trImpOpt'});
    guidata(h_fig, h);
end

delete(obj);


function edit_rowCoord_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('First row numbers must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{4}(2) = val;
    guidata(h.figure_trImpOpt, m);
end


function checkbox_inTTfile_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

switch checked
    case 1
        set([h.trImpOpt.text_rowCoord h.trImpOpt.edit_rowCoord], ...
            'Enable', 'on');
        set([h.trImpOpt.pushbutton_impCoordFile  ...
            h.trImpOpt.text_fnameCoord ...
            h.trImpOpt.pushbutton_impCoordOpt, ...
            h.trImpOpt.edit_movWidth, h.trImpOpt.text_movWidth], ...
            'Enable', 'off');
        set(h.trImpOpt.checkbox_extFile, 'Value', 0);
    case 0
        set([h.trImpOpt.text_rowCoord h.trImpOpt.edit_rowCoord], ...
            'Enable', 'off');
end

m{4}(1) = checked;
m{3}{1} = get(h.trImpOpt.checkbox_extFile, 'Value');
guidata(h.figure_trImpOpt, m);


function pushbutton_impCoordFile_Callback(obj, evd, h_fig)
defPth = setCorrectPath('coordinates', h_fig);
[fname, pname, o] = uigetfile({...
    '*.coord;*.spots', 'Coordinates file(*.coord;*.spots)'; ...
    '*.*', 'All files(*.*)'}, 'Select a coordinates file:', defPth);
if ~isempty(fname) && sum(fname)
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{3}{2} = [pname fname];
    set(h.trImpOpt.text_fnameCoord, 'String', fname);
    guidata(h.figure_trImpOpt, m);
end


function checkbox_extFile_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

switch checked
    case 1
        set([h.trImpOpt.text_rowCoord h.trImpOpt.edit_rowCoord], ...
            'Enable', 'off');
        set([h.trImpOpt.pushbutton_impCoordFile  ...
            h.trImpOpt.text_fnameCoord ...
            h.trImpOpt.pushbutton_impCoordOpt, ...
            h.trImpOpt.edit_movWidth, h.trImpOpt.text_movWidth], ...
            'Enable', 'on');
        set(h.trImpOpt.checkbox_inTTfile, 'Value', 0);
    case 0
        set([h.trImpOpt.pushbutton_impCoordFile  ...
            h.trImpOpt.text_fnameCoord ...
            h.trImpOpt.pushbutton_impCoordOpt, ...
            h.trImpOpt.edit_movWidth, h.trImpOpt.text_movWidth], ...
            'Enable', 'off');
end

m{4}(1) = get(h.trImpOpt.checkbox_inTTfile, 'Value');
m{3}{1} = checked;
guidata(h.figure_trImpOpt, m);


function pushbutton_impCoordOpt_Callback(obj, evd, h_fig)
openItgOpt(obj, evd, guidata(h_fig));


function pushbutton_impMovFile_Callback(obj, evd, h_fig)
[fname, pname, o] = uigetfile({ ...
    '*.sif;*.sira;*.tif;*.gif;*.png;*.spe;*.pma', ...
    ['Supported Graphic File Format' ...
    '(*.sif,*.sira,*.tif,*.gif,*.png,*.spe,*.pma)']; ...
    '*.*', 'All File Format(*.*)'}, 'Select a graphic file:');
if ~isempty(fname) && sum(fname)
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{2}{2} = [pname fname];
    set(h.trImpOpt.text_fnameMov, 'String', fname);
    guidata(h.figure_trImpOpt, m);
end


function edit_movWidth_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Movie width must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{2}{3}(1) = val;
    guidata(h.figure_trImpOpt, m);
end


function checkbox_impMov_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{2}{1} = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_fnameMov h.trImpOpt.pushbutton_impMovFile],...
            'Enable', 'on');
    case 0
        set([h.trImpOpt.text_fnameMov h.trImpOpt.pushbutton_impMovFile],...
            'Enable', 'off');
end


function pushbutton_impGamFile_Callback(obj, evd, h_fig)
h = guidata(h_fig);
defPth = h.folderRoot;
[fname,pname,o] = uigetfile({'*.gam', 'Gamma factors (*.gam)'; '*.*', ...
    'All files(*.*)'},'Select gamma factor file',defPth,'MultiSelect','on');
if ~isempty(fname) && ~isempty(pname) && sum(pname)
    if ~iscell(fname)
        fname = {fname};
    end
    m = guidata(h.figure_trImpOpt);
    m{6}{2} = pname;
    m{6}{3} = fname;
    str_file = '';
    for i = 1:numel(fname)
        str_file = cat(2,str_file,fname{i},'; ');
    end
    str_file = str_file(1:end-2);
    set(h.trImpOpt.text_fnameGam, 'String', str_file);
    guidata(h.figure_trImpOpt, m);
end


function checkbox_impGam_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{6}{1} = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_fnameGam h.trImpOpt.pushbutton_impGamFile],...
            'Enable', 'on');
    case 0
        set([h.trImpOpt.text_fnameGam h.trImpOpt.pushbutton_impGamFile],...
            'Enable', 'off');
        
        % added by MH, 5.4.2019
        m{6}{2} = [];
        m{6}{3} = [];
        guidata(h.figure_trImpOpt, m);
end


function edit_thcol_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('discretised FRET column number must be > 0', h_fig, ...
        'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(10) = val;
    guidata(h.figure_trImpOpt, m);
end


function checkbox_dFRET_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{1}{1}(9) = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_every h.trImpOpt.edit_thcol ...
            h.trImpOpt.text_thcol], 'Enable', 'on');
    case 0
        set([h.trImpOpt.text_every h.trImpOpt.edit_thcol ...
            h.trImpOpt.text_thcol], 'Enable', 'off');
end


function popupmenu_exc_Callback(obj, evd, h_fig)
exc = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
set(h.trImpOpt.edit_wl, 'String', num2str(m{1}{2}(exc)));


function edit_wl_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Wavelengths must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    exc = get(h.trImpOpt.popupmenu_exc, 'Value');
    m{1}{2}(exc) = val;
    guidata(h.figure_trImpOpt, m);
end


function edit_nbExc_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Number of excitation must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(8) = val;
    str_pop = {};
    for i = 1:val
        if i > numel(m{1}{2})
            m{1}{2}(i) = round(m{1}{2}(1)*(1 + 0.2*(i-1)));
        end
        str_pop = {str_pop{:} ['exc. ' num2str(i)]};
    end
    guidata(h.figure_trImpOpt, m);
    set(h.trImpOpt.popupmenu_exc, 'Value', 1, 'String', str_pop);
end


function edit_nbChan_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Number of channel must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(7) = val;
    guidata(h.figure_trImpOpt, m);
end


function edit_startColI_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('First column number must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(5) = val;
    guidata(h.figure_trImpOpt, m);
end


function edit_stopColI_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    updateActPan('Last column number must be >= 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(6) = val;
    guidata(h.figure_trImpOpt, m);
end


function checkbox_timeCol_Callback(obj, evd, h_fig)
checked = get(obj, 'Value');
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);
m{1}{1}(3) = checked;
guidata(h.figure_trImpOpt, m);

switch checked
    case 1
        set([h.trImpOpt.text_timeCol h.trImpOpt.edit_timeCol], ...
            'Enable', 'on');
    case 0
        set([h.trImpOpt.text_timeCol h.trImpOpt.edit_timeCol], ...
            'Enable', 'off');
end


function edit_timeCol_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Column number must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(4) = val;
    guidata(h.figure_trImpOpt, m);
end


function edit_startRow_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('First row number must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(1) = val;
    guidata(h.figure_trImpOpt, m);
end


function edit_stopRow_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    updateActPan('Last row number must be >= 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(2) = val;
    guidata(h.figure_trImpOpt, m);
end


function pushbutton_trImpOpt_ok_Callback(obj, evd, h_fig)
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

% adjust import parameters
nChan_imp = m{1}{1}(7);
for i = 1:nChan_imp
    if i > size(m{3}{3}{1},1)
        m{3}{3}{1}(i,1:2) = ...
            m{3}{3}{1}(i-1,1:2) + 2;
    end
end
h.param.ttPr.impPrm = m;
guidata(h_fig, h);

close(h.figure_trImpOpt);


function pushbutton_trImpOpt_cancel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
close(h.figure_trImpOpt);


