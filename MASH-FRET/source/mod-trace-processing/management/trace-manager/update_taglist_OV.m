function update_taglist_OV(h_fig, nb_mol_disp)

% Last update by MH, 24.4.2019
% >> add colors to tag lists
%
% update by FS, 25.4.2018
% >> add colors to tag popupmenu
%

h = guidata(h_fig);

% added by FS, 25.4.2018
str_lst = colorTagNames(h_fig);
nTag = numel(str_lst);

curr = get(h.tm.popupmenu_selectTags,'value');
if curr>nTag
    curr = nTag;
end
set(h.tm.popupmenu_selectTags, 'String', str_lst, 'Value', curr);

curr = get(h.tm.popupmenu_addSelectTag,'value');
if curr>nTag
    curr = nTag;
end
set(h.tm.popupmenu_addSelectTag, 'String', str_lst, 'Value', curr);

curr = get(h.tm.popup_molTag,'value');
if curr>nTag
    curr = nTag;
end
set(h.tm.popup_molTag, 'String', str_lst, 'Value', curr);

for i = nb_mol_disp:-1:1
    curr = get(h.tm.popup_molNb(i),'value');
    if curr>nTag
        curr = nTag;
    end
    set(h.tm.popup_molNb(i), 'String', str_lst, 'Value', curr);
    
    mol = str2num(get(h.tm.checkbox_molNb(i), 'String'));
    str_lst_mol = colorTagLists_OV(h_fig,mol);
    nTag_mol = numel(str_lst_mol);
    
    curr = get(h.tm.listbox_molLabel(i),'value');
    if curr>nTag_mol
        curr = nTag_mol;
    end
    set(h.tm.listbox_molLabel(i), 'String', str_lst_mol, 'Value', curr);
end
