function edit_gammaCorr_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
chan = p.proj{proj}.TP.fix{3}(8);

if chan<=0
    return
end

val = str2num(get(obj, 'String'));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Gamma correction factor must be >= 0', h_fig, 'error');
    return
end

p.proj{proj}.TP.curr{mol}{6}{1}(1,chan) = val;

h.param = p;
guidata(h_fig, h);

ud_factors(h_fig)
