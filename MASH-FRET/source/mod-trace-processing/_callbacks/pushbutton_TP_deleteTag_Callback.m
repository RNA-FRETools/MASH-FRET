function pushbutton_TP_deleteTag_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tag = get(h.popupmenu_TP_molLabel,'value');
    str_tag = get(h.popupmenu_TP_molLabel,'string');
    if ~strcmp(str_tag{tag},'no tag')
        mol = p.curr_mol(proj);
        
        choice = questdlg(cat(2,'Remove tag "',removeHtml(str_tag{tag}),...
            '" for molecule ',num2str(mol),' ?'),'Remove tag',...
            'Yes, remove','Cancel','Cancel');
        
        if ~strcmp(choice,'Yes, remove')
            return;
        end
        
        tagId = find(p.proj{proj}.molTag(mol,:));
        p.proj{proj}.molTag(mol,tagId(tag)) = false;
        h.param.ttPr = p;
        guidata(h.figure_MASH,h);
        
        ud_trSetTbl(h.figure_MASH);
    end
end