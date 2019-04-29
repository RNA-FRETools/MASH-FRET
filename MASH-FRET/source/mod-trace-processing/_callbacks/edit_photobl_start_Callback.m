function edit_photobl_start_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    inSec = p.proj{proj}.fix{2}(7);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if p.proj{proj}.curr{mol}{2}{1}(1)
        stop = p.proj{proj}.curr{mol}{2}{1}(4+method);
    else
        nExc = p.proj{proj}.nb_excitations;
        stop = nExc*size(p.proj{proj}.intensities,1);
    end
    rate = p.proj{proj}.frame_rate;
    if inSec
        val = rate*round(val/rate);
        minVal = rate;
        maxVal = rate*stop;
    else
        val = round(val);
        minVal = 1;
        maxVal = stop;
    end
    set(obj, 'String', num2str(val));

    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
            val >= minVal && val <= maxVal)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Data start must be >= ' num2str(minVal) ...
            ' and <= ' num2str(maxVal)], h.figure_MASH, 'error');

    else
        set(obj, 'BackgroundColor', [1 1 1]);
        if inSec
            val = val/rate;
        end
        p.proj{proj}.curr{mol}{2}{1}(4) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_bleach(h.figure_MASH);
        updateFields(h.figure_MASH, 'ttPr');
    end
end