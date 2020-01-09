function edit_SFparam_h_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 && ...
        mod(val,2))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Spot height must be an odd number > 0.', ...
        h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_h(channel) = val;
    guidata(h_fig, h);
    ud_SFpanel(h_fig);
end