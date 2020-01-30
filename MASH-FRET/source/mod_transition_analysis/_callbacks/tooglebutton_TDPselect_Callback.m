function tooglebutton_TDPselect_Callback(obj,evd,h_fig,ind)

h = guidata(h_fig);

tool = get(h.tooglebutton_TDPmanStart,'userdata');

if sum((1:3)==ind) % selection tool
    if tool==ind
        tool = 0;
        ud_zoom([],[],'zoom',h_fig);
    else
        tool = ind;
        set(h.TTzoom,'enable','off');
        set(h.TTpan,'enable','off');
        set([h.zMenu_zoom,h.zMenu_pan],'checked','off');
    end
    
    p = h.param.TDP;
    if tool>0 && ~isempty(p.proj)
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        tag = p.curr_tag(proj);
        p.proj{proj}.curr{tag,tpe}.clst_start{1}(2) = tool;
        h.param.TDP = p;
        guidata(h_fig,h);
        
        updateFields(h_fig,'TDP');
    end
    
elseif ind==5 % reset tool
    tool = 0;
    ud_zoom([],[],'zoom',h_fig);
end

set(h.tooglebutton_TDPmanStart,'userdata',tool);

ud_TDPmdlSlct(h_fig);
