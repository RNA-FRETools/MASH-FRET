function edit_denoiseParam_02_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
method = p.proj{proj}.TP.curr{mol}{1}{1}(1);

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Denoising parameters must be >= 0', h_fig, 'error');
    return
end

switch method

    case 2 % Haran filter: running average window size
        nmax = p.proj{proj}.nb_excitations * ...
            size(p.proj{proj}.intensities,1);
        if ~(val > 0 && val < nmax && mod(val,2))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Running average window size must be an odd ',...
                'integer > 0 and < ' num2str(nmax)], h_fig, 'error');
            return
        end

    case 3 % Wavelet analysis: time, local/universal
        if ~(sum(double(val == [1 2])))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Time must be 1 or 2 (local or universal)'],...
                h_fig, 'error');
            return
        end

    otherwise
        return
end

p.proj{proj}.TP.curr{mol}{1}{2}(method,2) = val;

h.param = p;
guidata(h_fig, h);

ud_denoising(h_fig);
