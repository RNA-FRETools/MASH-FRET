function edit_intNpix_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
h = guidata(h_fig);
nMax = prod(h.param.movPr.itg_dim^2);
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Number of integrated pixels must be an integer > 0.', ...
        h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    if val > nMax
        val = nMax;
        set(obj, 'String', num2str(val));
    end
    h.param.movPr.itg_n = val;
    guidata(h_fig, h);
    updateFields(h_fig, 'movPr');
end