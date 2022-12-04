function edit_maxS_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
min = h.param.proj{h.param.curr_proj}.TP.exp.hist{2}(3,2);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > min)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. value must be > min. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.proj{h.param.curr_proj}.TP.exp.hist{2}(3,4) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


