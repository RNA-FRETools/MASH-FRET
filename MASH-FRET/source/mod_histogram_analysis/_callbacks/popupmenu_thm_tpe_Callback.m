function popupmenu_thm_tpe_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    if val ~= p.curr_tpe(proj)
        
        tpe_str = get(obj,'String');
        setContPan(cat(2,'Select data: ',tpe_str{val}),'success', ...
            h.figure_MASH);
        
        p.curr_tpe(proj) = val;
        h.param.thm = p;
        guidata(h.figure_MASH, h);

        cla(h.axes_hist1);
        cla(h.axes_hist2);

        updateFields(h.figure_MASH, 'thm');
    end
end