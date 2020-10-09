function checkbox_TP_selectMol_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p.proj{proj}.coord_incl(mol) = get(obj,'value');
    h.param.ttPr = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'ttPr');
end