function edit_simAmpBG_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Relative initial BG amplitude must be a number >= 1', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.ampDec = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end