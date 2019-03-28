function popupmenu_TP_molLabel_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    if p.proj{proj}.coord_incl(mol)
        p.proj{proj}.molTag(mol) = get(obj, 'Value');
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'ttPr');
    end
end