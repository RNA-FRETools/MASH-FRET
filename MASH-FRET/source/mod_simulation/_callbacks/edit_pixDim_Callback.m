function edit_pixDim_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Pixel dimension must be > 0', 'error', h_fig);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    h.param.sim.pixDim = val;
    h.param.sim.matGauss = cell(1,4);
    guidata(h_fig, h);
    ud_S_vidParamPan(h_fig);
end