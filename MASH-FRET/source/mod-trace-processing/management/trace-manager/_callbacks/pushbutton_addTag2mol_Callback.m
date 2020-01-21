function pushbutton_addTag2mol_Callback(obj,evd,h_fig,i)
% Pushbutton adds tag selected in popupmenu to current molecule 

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% get tag to add
tagNames = get(h.tm.popup_molNb(i),'string');
tag = get(h.tm.popup_molNb(i),'value');
if strcmp(tagNames{tag},'no default tag') || ...
        strcmp(tagNames{tag},'select tag')
    return;
else
    tag = tag-1;
end

% update and save molecule tags
mol = str2num(get(h.tm.checkbox_molNb(i),'String'));
h.tm.molTag(mol,tag) = true;
guidata(h_fig,h);

% update molecule tag lists
nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
update_taglist_OV(h_fig,nb_mol_disp);

set(h.tm.popup_molNb(i),'value',1);

% update viveo view plot
plotData_videoView(h_fig);

