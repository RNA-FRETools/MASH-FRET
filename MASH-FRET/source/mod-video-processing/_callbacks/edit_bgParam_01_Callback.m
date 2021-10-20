function edit_bgParam_01_Callback(obj, evd, h_fig)

% collect processing parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
meth = curr.edit{1}{1}(1);

% retrieve value from edit field
val = str2double(get(obj, 'String'));
if sum(meth==[12 13])
    val = round(val);
end
set(obj, 'String', val);
if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj,'TooltipString') ' must be a number.'],h_fig,...
        'error');
    return
elseif meth<18 && val<0
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj,'TooltipString') ' must be > 0.'],h_fig,'error');
    return
elseif meth==9 && val>1
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj,'TooltipString') ' must be in the range [0,1].'],...
        h_fig,'error');
    return
end

% save filter's parameter 1
chan = get(h.popupmenu_bgChanel, 'Value');
curr.edit{1}{2}{meth,chan}(1) = val;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% refresh panel
ud_VP_edExpVidPan(h_fig);
