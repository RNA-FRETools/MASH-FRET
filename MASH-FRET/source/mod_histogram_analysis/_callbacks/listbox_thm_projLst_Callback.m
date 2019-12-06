function listbox_thm_projLst_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.thm;
if size(p.proj,2)>1
    val = get(obj, 'Value');
    if numel(val)==1 && val ~= p.curr_proj
        p.curr_proj = val;
        h.param.thm = p;
        guidata(h_fig, h);
        
        proj_name = get(obj,'string');
        str_proj = cat(2,'Project selected: "',proj_name{val},'" (',...
            p.proj{val}.proj_file,')');
        setContPan(str_proj,'none',h_fig);

        cla(h.axes_hist1);
        cla(h.axes_hist2);

        updateFields(h_fig, 'thm');
    end
end