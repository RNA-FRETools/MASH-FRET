function edit_SFparam_darkW_Callback(obj, evd, h_fig)

% collect interface parameters
val = round(str2double(get(obj, 'String')));
h = guidata(h_fig);
channel = get(h.popupmenu_SFchannel, 'Value');
p = h.param.movPr;

set(obj, 'String', num2str(val));
if ~(numel(val) == 1 && ~isnan(val) && val > 0 && mod(val,2))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Dark area width must be an odd number > 0.', h_fig, ...
        'error');
    return
end
    
p.SF_darkW(channel) = val;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_sfPan(h_fig);
