function pushbutton_thm_rmProj_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    slct_proj = get(h.listbox_thm_projLst, 'Value');
    str_proj = ['"' p.proj{slct_proj(1)}.exp_parameters{1,2} '"'];
    for pj = 2:numel(slct_proj)
        str_proj = [str_proj ', "' ...
            p.proj{slct_proj(pj)}.exp_parameters{1,2} '"'];
    end
    del = questdlg(['Remove project ' str_proj ' from the list?'], ...
        'Remove project', 'Yes', 'No', 'No');
    
    if strcmp(del, 'Yes')
        proj = {};
        curr_tpe = [];
        for i = 1:size(p.proj,2)
            if prod(double(i ~= slct_proj))
                proj{size(proj,2)+1} = p.proj{i};
                curr_tpe(size(curr_tpe,2)+1) = p.curr_tpe(i);
            end
        end
        if size(proj,2) <= 1
            p.curr_proj = 1;
        elseif slct_proj(end) < size(p.proj,2)
            p.curr_proj = slct_proj(end)-numel(slct_proj) + 1;
        else
            p.curr_proj = slct_proj(end)-numel(slct_proj);
        end
        p.proj = proj;
        p.curr_tpe = curr_tpe;

        p = ud_projLst(p, h.listbox_thm_projLst);
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        
        cla(h.axes_hist1);
        cla(h.axes_hist2);
        updateFields(h.figure_MASH, 'thm');
    end
end
