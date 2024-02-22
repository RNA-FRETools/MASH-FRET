% extra frames/s to substract (adapted from edit_photoblParam_02_Callback in MASH.m)
function edit_pbGamma_extraSubstract_Callback(obj, ~, h_fig, h_fig2)
    
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
inSec = p.proj{proj}.TP.fix{2}(7);
nExc = p.proj{proj}.nb_excitations;
len = nExc*size(p.proj{proj}.intensities_denoise,1);
splt = p.proj{proj}.resampling_time;

val = str2double(get(obj, 'String'));
if inSec
    val = splt*round(val/splt);
    maxVal = splt*len;
else
    val = round(val);
    maxVal = len;
end
set(obj, 'String', num2str(val));

if ~(numel(val)==1 && ~isnan(val) && val>=0 && val<=maxVal)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Extra cutoff must be >= 0 and <= ' num2str(maxVal)], ...
        h_fig, 'error');
    return
end

if inSec
    val = val/splt;
end

q = guidata(h_fig2);
q.prm{2}(3) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2)


