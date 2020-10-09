function edit_simBitPix_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Number of Bit per pixel should be an integer > 0', 'error', ...
        h_fig);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.param.sim.bitnr = val;
    guidata(h_fig, h);
    updateFields(h_fig, 'sim');
end