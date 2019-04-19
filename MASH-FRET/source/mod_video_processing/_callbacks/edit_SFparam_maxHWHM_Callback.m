function edit_SFparam_maxHWHM_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. spot width must be a number.', h.figure_MASH, ...
        'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_maxHWHM(channel) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end