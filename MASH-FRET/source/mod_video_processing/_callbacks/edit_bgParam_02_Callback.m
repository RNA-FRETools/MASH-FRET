function edit_bgParam_02_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', val);
method = h.param.movPr.movBg_method;
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Background correction parameter must be >= 0.', ...
        h.figure_MASH, 'error');
elseif method==8 && val>1
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Background correction must be in the range [0,1].', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_bgChanel, 'Value');
    h.param.movPr.movBg_p{method,channel}(2) = val;
    guidata(h.figure_MASH, h);
end