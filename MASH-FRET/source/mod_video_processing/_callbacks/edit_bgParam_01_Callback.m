function edit_bgParam_01_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
method = h.param.movPr.movBg_method;
if sum(method==[12 13])
    val = round(val);
end
set(obj, 'String', val);

if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be a number.'], ...
        h.figure_MASH, 'error');

elseif method<18 && val<0
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be > 0.'], ...
        h.figure_MASH, 'error');

elseif method==9 && val>1
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be in the range ' ...
        '[0,1].'], h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_bgChanel, 'Value');
    h.param.movPr.movBg_p{method,channel}(1) = val;
    guidata(h.figure_MASH, h);
end