function edit_bgParam_01_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
method = h.param.movPr.movBg_method;
if sum(method==[12 13])
    val = round(val);
end
set(obj, 'String', val);

if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be a number.'], ...
        h_fig, 'error');

elseif method<18 && val<0
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be > 0.'], ...
        h_fig, 'error');

elseif method==9 && val>1
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be in the range ' ...
        '[0,1].'], h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_bgChanel, 'Value');
    h.param.movPr.movBg_p{method,channel}(1) = val;
    guidata(h_fig, h);
end