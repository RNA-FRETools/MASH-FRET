function edit_photoblParam_02_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 2 % Threshold
        val = str2num(get(obj, 'String'));
        inSec = p.proj{proj}.fix{2}(7);
        nExc = p.proj{proj}.nb_excitations;
        len = nExc*size(p.proj{proj}.intensities,1);
        rate = p.proj{proj}.frame_rate;
        if inSec
            val = rate*round(val/rate);
            maxVal = rate*len;
        else
            val = round(val);
            maxVal = len;
        end
        set(obj, 'String', num2str(val));

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= maxVal)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Extra cutoff must be >= 0 and <= ' ...
                num2str(maxVal)], h_fig, 'error');

        else
            set(obj, 'BackgroundColor', [1 1 1]);
            if inSec
                val = val/rate;
            end
            chan = p.proj{proj}.curr{mol}{2}{1}(3);
            p.proj{proj}.curr{mol}{2}{2}(chan,2) = val;
            h.param.ttPr = p;
            guidata(h_fig, h);
            ud_bleach(h_fig);
        end
    end
end
