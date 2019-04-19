function edit_aveImg_start_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
stop = h.param.movPr.ave_stop;
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val <= stop && ...
        val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Starting frame must be <= ending frame and >= 1.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.ave_start = val;
    guidata(h.figure_MASH, h);
end