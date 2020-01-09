function edit_photobl_stop_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 1 % Manual
        val = str2num(get(obj, 'String'));
        inSec = p.proj{proj}.fix{2}(7);
        nExc = p.proj{proj}.nb_excitations;
        len = nExc*size(p.proj{proj}.intensities,1);
        start = p.proj{proj}.curr{mol}{2}{1}(4);
        rate = p.proj{proj}.frame_rate;
        if inSec
            val = rate*round(val/rate);
            minVal = rate*start;
            maxVal = rate*len;
        else
            val = round(val);
            minVal = start;
            maxVal = len;
        end
        set(obj, 'String', num2str(val));

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= minVal && val <= maxVal)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Data end must be >= ' num2str(minVal) ...
                ' and <= ' num2str(maxVal)], h_fig, 'error');

        else
            set(obj, 'BackgroundColor', [1 1 1]);
            if inSec
                val = val/rate;
            end
            p.proj{proj}.curr{mol}{2}{1}(4+method) = val;
            h.param.ttPr = p;
            guidata(h_fig, h);
            ud_bleach(h_fig);
        end
    end
end