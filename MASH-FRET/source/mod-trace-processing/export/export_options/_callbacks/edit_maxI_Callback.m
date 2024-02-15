function edit_maxI_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
expT = p.proj{p.curr_proj}.resampling_time;
perSec = p.proj{p.curr_proj}.cnt_p_sec;
min = p.proj{p.curr_proj}.TP.exp.hist{2}(1,2);

val = str2num(get(obj, 'String'));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > min)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. value must be > min. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);

if perSec
    val = val*expT;
end

p.proj{p.curr_proj}.exp.hist{2}(1,4) = val;

h.param = p;
guidata(h_fig, h);

ud_optExpTr('hist', h_fig);


