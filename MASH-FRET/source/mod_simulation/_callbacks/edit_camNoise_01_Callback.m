function edit_camNoise_01_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

% Dark counts or camera offset
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Dark counts or camera offset must be >= 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.camNoise(ind,1) = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end