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
p = h.param;
proj = p.curr_proj;
perSec = p.proj{proj}.cnt_p_sec;
if perSec
    rate = p.proj{proj}.resampling_time;
    val = val*rate;
end

q = guidata(h_fig2);
q.prm{2}(2) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2)


