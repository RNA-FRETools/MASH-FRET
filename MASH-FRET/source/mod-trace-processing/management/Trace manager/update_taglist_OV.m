function update_taglist_OV(h_fig, nb_mol_disp)

% Last update by MH, 24.4.2019
% >> add colors to tag lists
%
% update by FS, 25.4.2018
% >> add colors to tag popupmenu
%

h = guidata(h_fig);
    
for i = nb_mol_disp:-1:1
    % added by FS, 25.4.2018
    str_lst = colorTagNames(h_fig);
    nTag = numel(str_lst);
    currTag = get(h.tm.popup_molNb(i),'value');
    if currTag>nTag
        currTag = nTag;
    end
    set(h.tm.popup_molNb(i), 'String', str_lst, 'Value', currTag);
    
    mol = str2num(get(h.tm.checkbox_molNb(i), 'String'));
    str_lst = colorTagLists_OV(h_fig,mol);
    nTag = numel(str_lst);
    currTag = get(h.tm.listbox_molLabel(i),'value');
    if currTag>nTag
        currTag = nTag;
    end
    set(h.tm.listbox_molLabel(i), 'String', str_lst, 'Value', currTag)
    
end
