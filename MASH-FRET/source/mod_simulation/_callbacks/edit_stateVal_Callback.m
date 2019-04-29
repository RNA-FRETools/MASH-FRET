function edit_stateVal_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0 && ...
        val <= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('FRET values must be >= 0 and <= 1', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    state = get(h.popupmenu_states, 'Value');
    h.param.sim.stateVal(state) = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end