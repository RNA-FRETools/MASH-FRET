function edit_aveImg_end_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
start = h.param.movPr.ave_start;
tot = h.movie.framesTot;
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= start && ...
        val <= tot)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Ending frame must be >= starting frame and <= ' ...
        'frame length.'], h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.ave_stop = val;
    guidata(h.figure_MASH, h);
end