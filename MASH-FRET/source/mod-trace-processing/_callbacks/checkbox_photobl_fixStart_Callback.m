function checkbox_photobl_fixStart_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    nMol = size(p.proj{proj}.coord_incl,2);
    if val
        for m = 1:nMol
             p.proj{proj}.curr{m}{2}{1}(4) = ...
                 p.proj{proj}.curr{mol}{2}{1}(4);
        end
    else
        for m = 1:nMol
            if ~isempty(p.proj{proj}.prm{m})
                p.proj{proj}.curr{m}{2}{1}(4) = ...
                    p.proj{proj}.prm{m}{2}{1}(4);
            else
                p.proj{proj}.curr{m}{2}{1}(4) = ...
                    p.proj{proj}.curr{mol}{2}{1}(4);
            end
        end
    end
    p.proj{proj}.fix{2}(6) = val;
    h.param.ttPr = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'ttPr');
end