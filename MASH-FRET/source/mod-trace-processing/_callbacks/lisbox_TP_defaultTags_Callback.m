function lisbox_TP_defaultTags_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tag = get(obj,'value');
    str_tag = get(obj,'string');
    if ~strcmp(str_tag{tag},'no default tag')
        mol = p.curr_mol(proj);
        p.proj{proj}.molTag(mol,tag) = true;
        
        % added by MH, 13.1.2020: reset ES histograms
        p.proj{proj}.ES = cell(1,size(p.proj{proj}.FRET,1));
        
        h.param.ttPr = p;
        guidata(h_fig,h);
        
        grey = [240/255 240/255 240/255];
        set(h.pushbutton_TP_addTag,'value',0,'backgroundColor',grey);
        set(obj,'visible','off');
        
        ud_trSetTbl(h_fig);
    end
end