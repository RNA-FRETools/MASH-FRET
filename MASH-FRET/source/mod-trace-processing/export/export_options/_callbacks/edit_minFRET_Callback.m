function edit_minFRET_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2,4);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. value must be < max. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(2,2) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


