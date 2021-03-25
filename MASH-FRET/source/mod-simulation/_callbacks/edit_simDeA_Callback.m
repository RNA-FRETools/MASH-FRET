function edit_simDeA_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0  && ...
        val <= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Direct excitation coefficient must be >= 0 and <= 1', ...
        'error', h_fig);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.param.sim.deA = val;
    guidata(h_fig, h);
    ud_S_moleculesPan(h_fig);
end