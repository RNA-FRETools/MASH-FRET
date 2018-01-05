function pushbutton_TDPremProj_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    slct_proj = get(h.listbox_TDPprojList, 'Value');
    str_proj = ['"' p.proj{slct_proj(1)}.exp_parameters{1,2} '"'];
    for pj = 2:numel(slct_proj)
        str_proj = [str_proj ', "' ...
            p.proj{slct_proj(pj)}.exp_parameters{1,2} '"'];
    end
    del = questdlg(['Remove project ' str_proj ' from the list?'], ...
        'Remove project', 'Yes', 'No', 'No');
    if strcmp(del, 'Yes')
        projLst = {}; curr_type = [];
        for i = 1:size(p.proj,2)
            if prod(double(i ~= slct_proj))
                projLst{size(projLst,2)+1} = p.proj{i};
                curr_type(size(curr_type,2)+1) = p.curr_type(i);
            end
        end
        if size(projLst,2) <= 1
            p.curr_proj = 1;
        elseif slct_proj(end) < size(p.proj,2)
            p.curr_proj = slct_proj(end)-numel(slct_proj) + 1;
        else
            p.curr_proj = slct_proj(end)-numel(slct_proj);
        end
        p.proj = projLst;
        p.curr_type = curr_type;

        p = ud_projLst(p, h.listbox_TDPprojList);
        
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        
        cla(h.axes_TDPplot1);
        updateFields(h.figure_MASH, 'TDP');
    end
end