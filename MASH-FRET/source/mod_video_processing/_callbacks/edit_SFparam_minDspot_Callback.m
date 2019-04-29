function edit_SFparam_minDspot_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj,'String',num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. peak-peak distance must be >= 0.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_minDspot(channel) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end