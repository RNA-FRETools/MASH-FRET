function pushbutton_thm_rmProj_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    
    % collect selected project
    slct = get(h.listbox_thm_projLst, 'Value');
    
    % build confirmation message box
    str_proj = ['"' p.proj{slct(1)}.exp_parameters{1,2} '"'];
    for pj = 2:numel(slct)
        str_proj = [str_proj ', "' p.proj{slct(pj)}.exp_parameters{1,2} ...
            '"'];
    end
    del = questdlg(['Remove project ' str_proj ' from the list?'], ...
        'Remove project', 'Yes', 'No', 'No');

    if strcmp(del, 'Yes')
        
        % build action
        list_str = get(h.listbox_thm_projLst, 'String');
        str_act = '';
        for i = slct
            str_act = cat(2,str_act,'"',list_str{i},'" (',...
                p.proj{i}.proj_file,')\n');
        end
        str_act = str_act(1:end-2);
        
        % delete projects and reorganize project and current data 
        % structures
        proj = {};
        curr_tpe = [];
        for i = 1:size(p.proj,2)
            if prod(double(i ~= slct))
                proj{size(proj,2)+1} = p.proj{i};
                curr_tpe(size(curr_tpe,2)+1) = p.curr_tpe(i);
            end
        end
        p.proj = proj;
        p.curr_tpe = curr_tpe;
        
        % set new current project
        if size(p.proj,2) <= 1
            p.curr_proj = 1;
        elseif slct(end) < size(p.proj,2)
            p.curr_proj = slct(end)-numel(slct) + 1;
        else
            p.curr_proj = slct(end)-numel(slct);
        end
        
        % update project list
        p = ud_projLst(p, h.listbox_thm_projLst);
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        
        % clear axes
        cla(h.axes_hist1);
        cla(h.axes_hist2);
        
        % update calculations and GUI
        updateFields(h.figure_MASH, 'thm');
        
        % display action
        if numel(slct)>1
            str_act = cat(2,'Project has been sucessfully removed form ',...
                'the list: ',str_act);
        else
            str_act = cat(2,'Projects have been sucessfully removed form ',...
                'the list:\n',str_act);
        end
        setContPan(str_act,'none',h.figure_MASH);
    end
end
