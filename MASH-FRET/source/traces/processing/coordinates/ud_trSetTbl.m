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
    
    incl = p.proj{proj}.coord_incl;
    molTag = p.proj{proj}.molTag;
    tagsName = p.proj{proj}.molTagNames;
    currMol = p.curr_mol(proj);
    
    set(h.checkbox_TP_selectMol,'string',cat(2,'include (',...
        num2str(sum(incl)),' included)'),'value',incl(currMol));
    
    if incl(currMol)
        colorlist = {'transparent','#4298B5','#DD5F32','#92B06A','#ADC4CC',...
            '#E19D29'};
        str_lst = cell(1,length(tagsName));
        str_lst{1} = tagsName{1};

        for k = 2:length(tagsName)
            str_lst{k} = ['<html><body  bgcolor="' colorlist{k} '">' ...
                '<font color="white">' tagsName{k} '</font></body></html>'];
        end
        set(h.popupmenu_TP_molLabel,'enable','on','string',str_lst,...
            'value',molTag(currMol));
        
    else
        set(h.popupmenu_TP_molLabel,'enable','off','value',1);
    end
    
end
 
ud_lstMolStr(p, h.listbox_molNb);

