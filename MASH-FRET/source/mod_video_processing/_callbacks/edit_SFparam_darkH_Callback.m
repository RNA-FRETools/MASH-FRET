function edit_SFparam_darkH_Callback(obj, evd, h_fig)

% collect interface parameters
val = round(str2double(get(obj, 'String')));
h = guidata(h_fig);
chan = get(h.popupmenu_SFchannel, 'Value');
p = h.param.movPr;

% collect processing parameters
meth = p.SF_method;

set(obj, 'String', num2str(val));
if meth~=4 && ~(numel(val)==1 && ~isnan(val) && mod(val,2) && val>0) % not Schmied
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Dark area height must be an odd integer > 0.', h_fig, ...
        'error');
    return
elseif meth==4 && ~(numel(val)==1 && ~isnan(val) && val>=0) % Schmied
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Distance from edge must be a positive integer.', h_fig, ...
        'error');
    return
end

p.SF_darkH(chan) = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);
