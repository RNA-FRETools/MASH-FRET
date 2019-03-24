function ud_trSetTbl(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    projPrm = p.proj{proj};
    mol = p.curr_mol(proj);
    nC = projPrm.nb_channel;

    p.defProjPrm.mol = p.proj{proj}.curr{mol};
    
    % reorder the cross talk coefficients as the wavelength
    [o,id] = sort(p.proj{proj}.excitations,'ascend'); % chronological index sorted as wl
    mol_prev = p.defProjPrm.mol{5};
    for c = 1:nC
        p.defProjPrm.mol{5}{1}(:,c) = mol_prev{1}(id,c);
        p.defProjPrm.mol{5}{2}(:,c) = mol_prev{2}(id,c);
    end
    
    p.defProjPrm.general = p.proj{proj}.fix;
    p.defProjPrm.exp = p.proj{proj}.exp;
    h.param.ttPr = p;
    guidata(h_fig, h);
    
    
    
end
 
ud_lstMolStr(p, h.listbox_molNb);

