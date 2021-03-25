function edit_bgParam_01_Callback(obj, evd, h_fig)

% get interface parameters
val = str2num(get(obj, 'String'));
h = guidata(h_fig);
channel = get(h.popupmenu_bgChanel, 'Value');
p = h.param.movPr;

% get processing parameters
method = h.param.movPr.movBg_method;

if sum(method==[12 13])
    val = round(val);
end
set(obj, 'String', val);

if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be a number.'], ...
        h_fig, 'error');
    return
elseif method<18 && val<0
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be > 0.'], ...
        h_fig, 'error');
    return
elseif method==9 && val>1
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be in the range ' ...
        '[0,1].'], h_fig, 'error');
    return
end

p.movBg_p{method,channel}(1) = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

ud_VP_edExpVidPan(h_fig);
