function ud_denoising(h_fig)
h = guidata(h_fig);
p = h.param.ttPr.proj;
if ~isempty(p)
    proj = h.param.ttPr.curr_proj;
    mol = h.param.ttPr.curr_mol(proj);
    p_panel = p{proj}.curr{mol}{1};
    
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
            set(h.edit_denoiseParam_02, 'Enable', 'on', ...
                'TooltipString', 'Running average window size (frames)');
            set(h.edit_denoiseParam_03, 'Enable', 'on', ...
                'TooltipString', ['Factor for predictor average window' ...
                ' sizes (frames)']);
            
        case 3 % Wavelet analysis
            set(h.edit_denoiseParam_01, 'TooltipString', ...
                'Shrink strength (1, 2 or 3 >> firm, hard or soft)');
            set(h.edit_denoiseParam_02, 'Enable', 'on', ...
                'TooltipString', 'Time (1 or 2 >> local or universal)');
            set(h.edit_denoiseParam_03, 'Enable', 'on', ...
                'TooltipString', 'Cycle spin (1 or 2 >> on or off)');
    end
    
    set(h.edit_denoiseParam_01, 'String', num2str(prm(1)), ...
            'BackgroundColor', [1 1 1]);
    set(h.edit_denoiseParam_02, 'String', num2str(prm(2)), ...
            'BackgroundColor', [1 1 1]);
    set(h.edit_denoiseParam_03, 'String', num2str(prm(3)), ...
            'BackgroundColor', [1 1 1]);
end