function pushbutton_deleteMolTag_Callback(obj, evd, h_fig)

% Last update by MH, 24.4.2019
% >> downscale molecule tag structure after deleting a tag name
% >> warn and ask user confirmation to delete tag name
% >> allow the absence of default tag in list
% >> update color field after deleting
%
% Created by FS, 25.4.2018
%
%

    h = guidata(h_fig);
    selectMolTag = get(h.tm.popup_molTag, 'Value');
    
    % added by MH, 24.4.2019
    str_pop = get(h.tm.popup_molTag, 'string');
    if strcmp(str_pop{selectMolTag},'no default tag') || ...
            strcmp(str_pop{selectMolTag},'select tag')
        return;
    else
        selectMolTag = selectMolTag-1;
    end
    if sum(h.tm.molTag(:,selectMolTag))
        choice = questdlg({cat(2,'After deleting the molecule tag, the ',...
            'corresponding molecule sorting will be lost.'),'',...
            cat(2,'Do you want to delete tag "',...
            removeHtml(str_pop{selectMolTag}),'" and forget the ',...
            'corresponding molecule sorting?')},'Delete tag',...
            'Yes, forget sorting','Cancel','Cancel');
        if ~strcmp(choice,'Yes, forget sorting')
            return;
        end
    end
    
    % cancelled by MH, 24.4.2019
%     if selectMolTag ~= 1

    h.tm.molTagNames(selectMolTag) = [];
    
    % added by MH, 24.4.2019
    h.tm.molTag(:,selectMolTag) = [];
    h.tm.molTagClr = [h.tm.molTagClr h.tm.molTagClr(selectMolTag)];
    h.tm.molTagClr(selectMolTag) = [];
    % added by MH, 26.4.2019
    dat3 = get(h.tm.axes_histSort,'userdata');
    if size(dat3.rangeTags,2)>=selectMolTag
        dat3.rangeTags(:,selectMolTag) = [];
        set(h.tm.axes_histSort,'userdata',dat3);
    end
    
    guidata(h_fig, h);
    str_lst = colorTagNames(h_fig);
    set(h.tm.popup_molTag, 'Value', 1);
    set(h.tm.popup_molTag, 'String', str_lst);
    nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
    guidata(h_fig, h);
    
    update_taglist_OV(h_fig, nb_mol_disp);
    update_taglist_AS(h_fig);
    updatePanel_VV(h_fig);
    update_taglist_VV(h_fig);
    plotData_videoView(h_fig);
    
    % added by MH, 24.4.2019
    % update color edit field with new current tag
    popup_molTag_Callback(h.tm.popup_molTag,[],h_fig);
    % update string of selection popupmenu
    str_pop = getStrPop_select(h_fig);
    curr_slct = get(h.tm.popupmenu_selection,'value');
    if curr_slct>numel(str_pop)
        curr_slct = numel(str_pop);
    end
    set(h.tm.popupmenu_selection,'value',curr_slct,'string',str_pop);
    
    % cancelled by MH, 24.4.2019
%     end

end