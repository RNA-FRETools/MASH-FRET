function popupmenu_TDPdataType_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    
    if val ~= p.curr_type(proj)
        
        str_tpe = get(obj,'String');
        setContPan(cat(2,'Data "',str_tpe{val},'" selected.'),...
            'success',h.figure_MASH);
        
        p.curr_type(proj) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        
        cla(h.axes_TDPplot1);
        updateFields(h.figure_MASH, 'TDP');
    end
end