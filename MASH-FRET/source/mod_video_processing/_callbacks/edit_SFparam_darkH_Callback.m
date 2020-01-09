function edit_SFparam_darkH_Callback(obj, evd, h_fig)
h = guidata(h_fig);
meth = h.param.movPr.SF_method;
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if meth~=4 && ~(~isempty(val) && numel(val)==1 && ~isnan(val) && ...
        mod(val,2) && val>0) % not Schmied
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Dark area height must be an odd integer > 0.', ...
        h_fig, 'error');
elseif meth==4 && ~(~isempty(val) && numel(val)==1 && ~isnan(val) && ...
        val>=0) % Schmied
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Distance from edge must be a positive integer.', ...
        h_fig, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_darkH(channel) = val;
    guidata(h_fig, h);
    ud_SFpanel(h_fig);
end