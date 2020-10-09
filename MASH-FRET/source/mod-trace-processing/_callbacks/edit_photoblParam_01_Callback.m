function edit_photoblParam_01_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 2 % Threshold
        val = str2num(get(obj, 'String'));
        set(obj, 'String', num2str(val));

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Data threshold must be a number.', ...
                h_fig, 'error');

        else
            set(obj, 'BackgroundColor', [1 1 1]);
            chan = p.proj{proj}.curr{mol}{2}{1}(3);
            nFRET = size(p.proj{proj}.FRET,1);
            nS = size(p.proj{proj}.S,1);
            if chan > nFRET + nS % threshold for intensities
                perSec = p.proj{proj}.fix{2}(4);
                perPix = p.proj{proj}.fix{2}(5);
                if perSec
                    rate = p.proj{proj}.frame_rate;
                    val = val*rate;
                end
                if perPix
                    nPix = p.proj{proj}.pix_intgr(2);
                    val = val*nPix;
                end
            end
            p.proj{proj}.curr{mol}{2}{2}(chan,1) = val;
            h.param.ttPr = p;
            guidata(h_fig, h);
            ud_bleach(h_fig);
        end
    end
end