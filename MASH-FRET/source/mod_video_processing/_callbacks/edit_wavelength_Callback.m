function edit_wavelength_Callback(obj, evd, h_fig)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Wavelengths must be > 0', h_fig, 'error');
else
    h = guidata(h_fig);
    set(obj, 'BackgroundColor', [1 1 1]);
    laser = get(h.popupmenu_TTgen_lasers, 'Value');
    p = h.param.movPr;
    p.itg_wl(laser) = val;
    p.itg_expMolPrm(4+laser,1) = {['Power(' num2str(val) 'nm)']};

    clr_ref = getDefTrClr(numel(p.itg_wl), p.itg_wl, p.nChan, ...
        size(p.itg_expFRET,1), size(p.itg_expS,1));
    p.itg_clr{1} = clr_ref{1}(1:numel(p.itg_wl),:);

    h.param.movPr = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'movPr');
end