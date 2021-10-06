function ud_denoising(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_denoising,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
p_panel = p.proj{proj}.TP.curr{mol}{1};

method = p_panel{1}(1);
smoothIt = p_panel{1}(2);
prm = p_panel{2}(method,:);

set(h.popupmenu_denoising, 'Value', method);
set(h.checkbox_smoothIt, 'Value', smoothIt);

switch method
    case 1 % Running average
        set([h.edit_denoiseParam_02 h.edit_denoiseParam_03], ...
            'Enable', 'off', 'TooltipString', '');
        set(h.edit_denoiseParam_01, 'TooltipString', ...
            'Running averaging window size (frames)');

    case 2 % Haran filter
        set(h.edit_denoiseParam_01, 'TooltipString', ...
            'Exponent factor for predictor weight');
        set(h.edit_denoiseParam_02, 'TooltipString', ...
            'Running average window size (frames)');
        set(h.edit_denoiseParam_03, 'TooltipString', ...
            'Factor for predictor average window sizes (frames)');

    case 3 % Wavelet analysis
        set(h.edit_denoiseParam_01, 'TooltipString', ...
            'Shrink strength (1, 2 or 3 >> firm, hard or soft)');
        set(h.edit_denoiseParam_02, 'TooltipString', ...
            'Time (1 or 2 >> local or universal)');
        set(h.edit_denoiseParam_03, 'TooltipString', ...
            'Cycle spin (1 or 2 >> on or off)');
end

set(h.edit_denoiseParam_01, 'String', num2str(prm(1)), 'BackgroundColor', ...
    [1 1 1]);
set(h.edit_denoiseParam_02, 'String', num2str(prm(2)), 'BackgroundColor', ...
    [1 1 1]);
set(h.edit_denoiseParam_03, 'String', num2str(prm(3)), 'BackgroundColor', ...
    [1 1 1]);
