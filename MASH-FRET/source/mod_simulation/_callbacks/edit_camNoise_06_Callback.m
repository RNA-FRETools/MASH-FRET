function edit_camNoise_06_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

h = guidata(h_fig);
ind = get(h.popupmenu_noiseType, 'Value');

switch ind
    case 1 % Poissonian, none

    case 2 % Gaussian, pixel saturation

    case 3  % User defined, exponential decay constant
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Exponential tail decay constant must be >= 0', ...
                'error', h_fig);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,6) = val;
            guidata(h_fig, h);
        end

    case 4 % None, none

    case 5 % Hirsch or PGN-model, analog-to-digital factor
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Analog-to-Digital factor must be > 0', ...
                'error', h_fig);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,6)= val;
            guidata(h_fig, h);
        end
end

ud_S_vidParamPan(h_fig);
