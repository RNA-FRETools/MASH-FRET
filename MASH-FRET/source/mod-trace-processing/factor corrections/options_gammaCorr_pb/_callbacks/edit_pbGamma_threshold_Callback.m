% threshold (adapted from edit_photoblParam_01_Callback in MASH.m)
function edit_pbGamma_threshold_Callback(obj, ~, h_fig, h_fig2)

val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));

if ~(isscalar(val) && ~isnan(val) && val<=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Relative data threshold must be <=1.', h_fig, 'error');
    return
end

q = guidata(h_fig2);
q.prm{2}(2) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2)


