function edit_camNoise_01_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

h = guidata(h_fig);
ind = get(h.popupmenu_noiseType, 'Value');

% Dark counts or camera offset
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Dark counts or camera offset must be >= 0', 'error', ...
        h_fig);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.camNoise(ind,1) = val;
    guidata(h_fig, h);
    updateFields(h_fig, 'sim');
end