function edit_SFparam_maxN_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj,'String',num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. number of peak must be >= 0.', h_fig, ...
        'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_maxN(channel) = val;
    guidata(h_fig, h);
    ud_SFspots(h_fig);
    ud_SFpanel(h_fig);
end