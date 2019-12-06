function edit_simAmpBG_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Relative initial BG amplitude must be a number >= 1', ...
        'error', h_fig);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.param.sim.ampDec = val;
    guidata(h_fig, h);
    updateFields(h_fig, 'sim');
end