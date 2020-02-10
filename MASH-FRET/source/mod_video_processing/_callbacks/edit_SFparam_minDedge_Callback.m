function edit_SFparam_minDedge_Callback(obj, evd, h_fig)

% collect interface parameters
val = round(str2double(get(obj, 'String')));
h = guidata(h_fig);
chan = get(h.popupmenu_SFchannel, 'Value');
p = h.param.movPr;

set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. image edge-peak distance must be >= 0.', h_fig, ...
        'error');
    return
end

p.SF_minDedge(chan) = val;
    
% reset spot selection
if ~isempty(p.SFres)
    p.SFres(2,:) = [];
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% refresh calculations, plot and set GUI to proper values
updateFields(h_fig,'imgAxes');
