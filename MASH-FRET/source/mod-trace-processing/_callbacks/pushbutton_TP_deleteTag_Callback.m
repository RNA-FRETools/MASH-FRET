function pushbutton_TP_deleteTag_Callback(obj, evd, h_fig)
h = guidata(h_fig);
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
        
        % added by MH, 13.1.2020: reset ES histograms
        p.proj{proj}.ES = cell(1,size(p.proj{proj}.FRET,1));
        
        h.param.ttPr = p;
        guidata(h_fig,h);
        
        ud_trSetTbl(h_fig);
    end
end