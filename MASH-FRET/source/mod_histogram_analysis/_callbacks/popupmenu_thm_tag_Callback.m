function popupmenu_thm_tag_Callback(obj,evd,h_fig)
h = guidata(h_fig);
p = h.param.thm;

if ~isempty(p.proj)
    val = get(obj,'value');
    proj = p.curr_proj;
    
    if val~=p.curr_tag(proj)
        tag_str = get(obj,'String');
        if val==1
            setContPan('Select all molecules','success',h_fig);
        else
            setContPan(cat(2,'Select molecule subgroup: ',...
                removeHtml(tag_str{val})),'success',h_fig);
        end
        
        p.curr_tag(proj) = val;
        h.param.thm = p;
        guidata(h_fig, h);
        
        cla(h.axes_hist1);
        cla(h.axes_hist2);

        updateFields(h_fig, 'thm');
    end
end