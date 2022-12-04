function tooglebutton_TDPselect_Callback(obj,evd,h_fig,ind)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

switch ind
    case 1 % reset tool
        ud_zoom([],[],'zoom',h_fig);
        set(h.tooglebutton_TDPmanStart,'userdata',1);
        ud_TDPmdlSlct(h_fig);
    
    case 2 % selection tool
        set(h.TTzoom,'enable','off');
        set(h.TTpan,'enable','off');
        set([h.zMenu_zoom,h.zMenu_pan],'checked','off');
        set(h.tooglebutton_TDPmanStart,'userdata',2);
        
        ud_TDPmdlSlct(h_fig);
        
    case 3 % reset selection

        proj = p.curr_proj;
        tpe = p.TDP.curr_type(proj);
        tag = p.TDP.curr_tag(proj);
        curr = p.proj{proj}.TA.curr{tag,tpe};

        curr.clst_start{2}(:,[1,2]) = 0;
        curr.clst_start{2}(:,[3,4]) = Inf;
        
        p.proj{proj}.TA.curr{tag,tpe} = curr;
        h.param = p;
        guidata(h_fig,h);
        
        updateFields(h_fig,'TDP');
end


