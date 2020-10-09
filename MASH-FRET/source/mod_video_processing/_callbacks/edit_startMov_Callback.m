function edit_startMov_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
h = guidata(h_fig);
stop = h.param.movPr.mov_end;
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val <= stop && ...
        val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Starting frame must be <= ending frame and >= 1.', ...
        h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.mov_start = val;
    guidata(h_fig, h);
end