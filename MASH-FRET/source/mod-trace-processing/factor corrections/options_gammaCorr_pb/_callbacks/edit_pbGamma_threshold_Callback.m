% threshold (adapted from edit_photoblParam_01_Callback in MASH.m)
function edit_pbGamma_threshold_Callback(obj, ~, h_fig, h_fig2)

val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));

if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Data threshold must be a number.', h_fig, 'error');
    return
end

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
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

q = guidata(h_fig2);
q.prm{2}(2) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2)


