function edit_TTgen_dim_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Integration area dimensions must be an integer > 0.', ...
        h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.param.movPr.itg_dim = val;
    h.param.movPr.itg_n = val^2;
    guidata(h_fig, h);
    updateFields(h_fig, 'movPr');
end