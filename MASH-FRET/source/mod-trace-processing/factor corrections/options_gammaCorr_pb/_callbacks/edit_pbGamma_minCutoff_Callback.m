% minimum cutoff (adapted from edit_photoblParam_03_Callback in MASH.m)
function edit_pbGamma_minCutoff_Callback(obj, ~, h_fig, h_fig2)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
inSec = p.proj{proj}.time_in_sec;
splt = p.proj{proj}.resampling_time;

q = guidata(h_fig2);

val = str2double(get(obj, 'String'));
if inSec
    val = splt*round(val/splt);
else
    val = round(val);
end
set(obj, 'String', num2str(val));

if ~(isscalar(val) && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Minimum cutoff must be >= 0', h_fig, 'error');
end

if inSec
    val = val/splt;
end

q.prm{2}(4) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2);


