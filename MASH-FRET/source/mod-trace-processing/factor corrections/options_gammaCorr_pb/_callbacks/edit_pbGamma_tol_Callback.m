function edit_pbGamma_tol_Callback(obj, ~, h_fig, h_fig2)

val = str2double(get(obj, 'String'));

if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Tolerance must be >= 0 ', h_fig, 'error');
end

q = guidata(h_fig2);
q.prm{2}(6) = val;
guidata(h_fig2, q);

ud_pbGamma(h_fig,h_fig2);


