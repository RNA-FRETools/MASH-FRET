function edit_aveImg_iv_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Frame interval must be >= 1.', h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.ave_iv = val;
    guidata(h.figure_MASH, h);
end