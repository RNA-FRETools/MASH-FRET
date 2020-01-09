function pushbutton_TDPremProj_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    
    % collect selected projects
    slct = get(h.listbox_TDPprojList, 'Value');
    
    % build confirmation message box
    str_proj = ['"' p.proj{slct(1)}.exp_parameters{1,2} '"'];
    for pj = 2:numel(slct)
        str_proj = [str_proj ', "' p.proj{slct(pj)}.exp_parameters{1,2} ...
            '"'];
    end
    del = questdlg(['Remove project ' str_proj ' from the list?'], ...
        'Remove project', 'Yes', 'No', 'No');
    
    if strcmp(del, 'Yes')
        % delete projects and reorganize project and current data 
        % structures
        p.proj(slct) = [];
        p.curr_type(slct) = [];
        p.curr_tag(slct) = [];
        
        % set new current project
        if size(p.proj,2) <= 1
            p.curr_proj = 1;
        elseif slct(end)<size(p.proj,2)
            p.curr_proj = slct(end)-numel(slct) + 1;
        else
            p.curr_proj = slct(end)-numel(slct);
        end
        
        % update project list
        p = ud_projLst(p, h.listbox_TDPprojList);
        h.param.TDP = p;
        guidata(h_fig, h);
        
        % clear axes
        cla(h.axes_TDPplot1);
        
        % update calculations and GUI
        updateFields(h_fig, 'TDP');
    end
end