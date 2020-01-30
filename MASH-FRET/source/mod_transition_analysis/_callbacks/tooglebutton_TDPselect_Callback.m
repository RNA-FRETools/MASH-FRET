function tooglebutton_TDPselect_Callback(obj,evd,h_fig,ind)

h = guidata(h_fig);

tool = get(h.tooglebutton_TDPmanStart,'userdata');

switch ind
    case 1 % reset tool
        ud_zoom([],[],'zoom',h_fig);
        tool = 1;
    
    case 2 % selection tool
        set(h.TTzoom,'enable','off');
        set(h.TTpan,'enable','off');
        set([h.zMenu_zoom,h.zMenu_pan],'checked','off');
        tool = 2;
        
    case 3 % reset selection
        p = h.param.TDP;
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        tag = p.curr_tag(proj);

        p.proj{proj}.curr{tag,tpe}.clst_start{2}(:,[1,2]) = 0;
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(:,[3,4]) = Inf;
        
        h.param.TDP = p;
        guidata(h_fig,h);
end

set(h.tooglebutton_TDPmanStart,'userdata',tool);

updateFields(h_fig,'TDP');
