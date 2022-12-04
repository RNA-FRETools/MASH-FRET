function checkbox_TP_selectMol_Callback(obj, evd, h_fig)

% retrieve parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
p.proj{proj}.coord_incl(mol) = get(obj,'value');

% added by MH, 13.1.2020: reset ES histograms
for i = 1:size(p.proj{proj}.ES,2)
    if ~(numel(p.proj{proj}.ES{i})==1 && isnan(p.proj{proj}.ES{i}))
        p.proj{proj}.ES{i} = [];
    end
end

h.param = p;
guidata(h_fig, h);
updateFields(h_fig, 'ttPr');
