function edit_bgInt_acc_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Intensities must be >= 0', 'error', h_fig);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    if strcmp(h.param.sim.intUnits, 'electron')
        [offset,K,eta] = getCamParam(h.param.sim.noiseType,...
            h.param.sim.camNoise);
        val = ele2phtn(val,K,eta);
    end
    h.param.sim.bgInt_acc = val;
    guidata(h_fig, h);
    updateFields(h_fig, 'sim');
end