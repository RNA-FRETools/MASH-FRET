% minimum cutoff (adapted from edit_photoblParam_03_Callback in MASH.m)
function edit_pbGamma_minCutoff_Callback(obj, ~, h_fig, h_fig2)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
inSec = p.proj{proj}.fix{2}(7);
nExc = p.proj{proj}.nb_excitations;
len = nExc*size(p.proj{proj}.intensities,1);
rate = p.proj{proj}.frame_rate;

q = guidata(h_fig2);
start = q.prm{2}(5);

val = str2double(get(obj, 'String'));
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

if ~(numel(val)==1 && ~isnan(val) && val>=minVal && val<=maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Minimum cutoff must be >= ' num2str(minVal) ' and <= ' ...
        num2str(maxVal)], h_fig, 'error');
end

if inSec
    val = val/rate;
end

q.prm{2}(4) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2);


