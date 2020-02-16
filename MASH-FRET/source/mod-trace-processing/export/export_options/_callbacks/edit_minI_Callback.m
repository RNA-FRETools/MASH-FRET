function edit_minI_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
max = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1,4);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val < max)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. value must be < max. value.', h_fig, 'error');
    return;
end
set(obj, 'BackgroundColor', [1 1 1]);
perSec = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(4);
perPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.fix{2}(5);
if perSec
    rate = h.param.ttPr.proj{h.param.ttPr.curr_proj}.frame_rate;
    val = val*rate;
end
if perPix
    nPix = h.param.ttPr.proj{h.param.ttPr.curr_proj}.pix_intgr(2);
    val = val*nPix;
end
h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.hist{2}(1,2) = val;
guidata(h_fig, h);
ud_optExpTr('hist', h_fig);


