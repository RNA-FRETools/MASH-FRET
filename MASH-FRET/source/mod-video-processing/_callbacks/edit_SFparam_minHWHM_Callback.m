function edit_SFparam_minHWHM_Callback(obj, evd, h_fig)

% collect interface parameters
val = str2double(get(obj, 'String'));
h = guidata(h_fig);
chan = get(h.popupmenu_SFchannel, 'Value');
p = h.param.movPr;

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. spot width must be a number.', h_fig, 'error');
    return
end

p.SF_minHWHM(chan) = val;
    
% reset spot selection
if size(p.SFres,1)>=2
    p.SFres(2,:) = [];
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig,'imgAxes');