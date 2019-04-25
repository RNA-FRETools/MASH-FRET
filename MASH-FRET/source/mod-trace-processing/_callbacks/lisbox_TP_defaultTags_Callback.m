function lisbox_TP_defaultTags_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tag = get(obj,'value');
    str_tag = get(obj,'string');
    if ~strcmp(str_tag{tag},'no default tag')
        mol = p.curr_mol(proj);
        p.proj{proj}.molTag(mol,tag) = true;
        h.param.ttPr = p;
        guidata(h.figure_MASH,h);
        
        set(h.pushbutton_TP_addTag,'value',0);
        set(obj,'visible','off');
        
        ud_trSetTbl(h.figure_MASH);
    end
end