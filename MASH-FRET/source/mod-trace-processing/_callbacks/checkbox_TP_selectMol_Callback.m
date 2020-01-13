function checkbox_TP_selectMol_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p.proj{proj}.coord_incl(mol) = get(obj,'value');
    
    % added by MH, 13.1.2020: reset ES histograms
    p.proj{proj}.ES = cell(1,size(p.proj{proj}.FRET,1));
    
    h.param.ttPr = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'ttPr');
end