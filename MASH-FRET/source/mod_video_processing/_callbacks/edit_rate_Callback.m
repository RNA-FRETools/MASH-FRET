function edit_rate_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', val);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Frame rate must be > 0.', ...
        h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.movie.cyctime = val;
    h.param.movPr.rate = val;
    guidata(h_fig, h);
    updateFields(h_fig, 'imgAxes');
end