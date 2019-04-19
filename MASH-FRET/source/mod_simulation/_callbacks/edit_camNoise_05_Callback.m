function edit_camNoise_05_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

if ind==5 % Hirsch or PGN-model, EM register gain
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('EM register gain must be >= 0', ...
            'error', h.figure_MASH);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        h.param.sim.camNoise(ind,5) = val;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'sim');
    end
    
else % overall gain
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Overall system gain must be >= 0', ...
            'error', h.figure_MASH);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        h.param.sim.camNoise(ind,5) = val;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'sim');
    end
end
