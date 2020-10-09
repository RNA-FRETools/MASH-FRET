function edit_SFparam_maxHWHM_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. spot width must be a number.', h_fig, ...
        'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_maxHWHM(channel) = val;
    guidata(h_fig, h);
    ud_SFspots(h_fig);
    ud_SFpanel(h_fig);
end