function edit_addMolTag_Callback(obj, evd, h_fig)

% Last update by MH, 24.4.2019
% >> add random colors for tags that exceed tag list
% >> upscale molecule tag structure after adding new tag name
% >> reset edit string to "define a new tag" after adding new tag name
% >> update color field after adding
%
% Created by FS, 25.4.2018
%
%

h = guidata(h_fig);
if strcmp(obj.String, 'define a new tag') || ...
        ismember(obj.String, h.tm.molTagNames)
    return
end
    
% added by MH, 27.4.2019
if strcmp(obj.String, 'no tag') || strcmp(obj.String, 'no default tag') ....
        || strcmp(obj.String, 'select tag')
    msgbox('Simply, no.');
    set(obj,'string','define a new tag');
    return
end

h.tm.molTagNames{end+1} = obj.String;

% added by MH, 24.4.2019
% add random colors
nTag = numel(h.tm.molTagNames);
if numel(h.tm.molTagClr)<nTag
    h.tm.molTagClr = [h.tm.molTagClr cat(2,'#',randHexRgb())];
end

% added by MH, 24.4.2019
% adjust molecule tag structure
h.tm.molTag = [h.tm.molTag, false(size(h.tm.molTag,1),1)];

% adjust range tag structure
dat3 = get(h.tm.axes_histSort,'userdata');
dat3.rangeTags = [dat3.rangeTags false(size(dat3.rangeTags,1),1)];
set(h.tm.axes_histSort,'userdata',dat3);

% added by MH, 24.4.2019
set(obj,'string','define a new tag');

guidata(h_fig, h);
str_lst = colorTagNames(h_fig);
set(h.tm.popup_molTag,'String',str_lst,'value',numel(str_lst));
nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
guidata(h_fig, h);

update_taglist_OV(h_fig, nb_mol_disp);
update_taglist_AS(h_fig);
updatePanel_VV(h_fig);
update_taglist_VV(h_fig);

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

