function pushbutton_remLabel_Callback(obj,evd,h_fig,i)
% Pushbutton removes tag selected in molecule-specific listbox

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% get tag to remove
molTagNames = removeHtml(get(h.tm.listbox_molLabel(i),'string'));
tag = get(h.tm.listbox_molLabel(i),'value');
if strcmp(molTagNames{tag},'no tag')
    return;
end

% update and save molecule tags
mol = str2num(get(h.tm.checkbox_molNb(i),'String'));
tagId = find(h.tm.molTag(mol,:));
h.tm.molTag(mol,tagId(tag)) = false;
guidata(h_fig,h);

% update molecule tag lists
nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
update_taglist_OV(h_fig,nb_mol_disp)
