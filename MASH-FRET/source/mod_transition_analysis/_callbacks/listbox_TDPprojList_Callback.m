function listbox_TDPprojList_Callback(obj, evd, h)
p = h.param.TDP;
if size(p.proj,2) > 1
    val = get(obj, 'Value');
    if numel(val)==1 && val ~= p.curr_proj
        p.curr_proj = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        
        proj_name = get(obj,'string');
        str_proj = cat(2,'Project selected: "',proj_name{val},'" (',...
            p.proj{val}.proj_file,')');

        setContPan(str_proj,'none',h.figure_MASH);
        
        cla(h.axes_TDPplot1);
        updateFields(h.figure_MASH, 'TDP');
    end
end