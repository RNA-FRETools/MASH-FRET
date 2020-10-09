function edit_gammaCorr_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    
    clr = get(obj, 'String');
    if strcmp(clr, 'pink') || strcmp(clr, 'yellow') || ...
            strcmp(clr, 'blue') || strcmp(clr, 'green') || ...
            strcmp(clr, 'gray') || strcmp(clr, 'danny')
        setBgClr(h_fig, clr);
        ud_cross(h_fig);
        return;
    end
    
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    chan = p.proj{proj}.fix{3}(8);
    if chan>0
        val = str2num(get(obj, 'String'));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Gamma correction factor must be >= 0', ...
                h_fig, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.proj{proj}.curr{mol}{5}{3}(chan) = val;
            h.param.ttPr = p;
            guidata(h_fig, h);
            ud_cross(h_fig);
        end
    end
end