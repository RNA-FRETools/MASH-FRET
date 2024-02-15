function edit_minI_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = h.param.proj{h.param.curr_proj}.TP.exp.hist{2}(1,4);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. value must be < max. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
perSec = h.param.proj{h.param.curr_proj}.cnt_p_sec;
if perSec
    rate = h.param.proj{h.param.curr_proj}.resampling_time;
    val = val*rate;
end
h.param.proj{h.param.curr_proj}.TP.exp.hist{2}(1,2) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


