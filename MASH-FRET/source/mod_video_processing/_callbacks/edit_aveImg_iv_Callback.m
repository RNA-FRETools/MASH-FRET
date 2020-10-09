function edit_aveImg_iv_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Frame interval must be >= 1.', h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.param.movPr.ave_iv = val;
    guidata(h_fig, h);
end