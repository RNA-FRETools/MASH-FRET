function edit_gamma_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Gamma factor must be > 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.gamma = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end