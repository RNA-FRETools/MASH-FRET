function edit_betaCorr_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
if isempty(p.proj)
    return
end
    
proj = p.curr_proj;
mol = p.curr_mol(proj);
chan = p.proj{proj}.fix{3}(8);
if chan>0
    val = str2num(get(obj, 'String'));
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Beta correction factor must be >= 0',h_fig,'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        p.proj{proj}.curr{mol}{6}{1}(2,chan) = val;
        h.param.ttPr = p;
        guidata(h_fig, h);
        ud_factors(h_fig)
    end
end