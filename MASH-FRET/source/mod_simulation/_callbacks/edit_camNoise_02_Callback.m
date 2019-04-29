function edit_camNoise_02_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

switch ind
    case 1 % Poissonian, none
        
    case 2 % Gaussian, s_d
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Read-out noise standard deviation must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,2) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end

    case 3 % User defined, A_CIC
        if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>=0 && ...
                val<=1)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['Exponential tail contribution must be >= 0 and ',...
                '<= 1'],'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,2) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end

    case 4 % None, none

    case 5 % Hirsch or PGN-model, s_d, read-out-noise
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Read-out-noise standard deviation must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,2) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
end