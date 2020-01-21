function pushbutton_tagClr_Callback(obj,evd,h_fig)
% Defines the tag color with hexadecimal input

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% control empty tag
tag = get(h.tm.popup_molTag,'value');
str_pop = get(h.tm.popup_molTag, 'string');
if strcmp(str_pop{tag},'no default tag') || ...
        strcmp(str_pop{tag},'select tag')
    return;
else
     tag = tag-1;
end

% control color value
rgb = uisetcolor('Select a tag color');
if numel(rgb)==1
    return;
end

rgb = round(255*rgb);
clr_str = rgb2hex(rgb);

% save color
h.tm.molTagClr{tag} = cat(2,'#',clr_str);
guidata(h_fig,h);

% update edit field background color
popup_molTag_Callback(h.tm.popup_molTag,[],h_fig);

% update color in default tag popup
str_lst = colorTagNames(h_fig);
set(h.tm.popup_molTag,'String',str_lst);

% update color in molecule tag listboxes and popups
n_mol_disp = str2num(get(h.tm.edit_nbTotMol,'string'));

update_taglist_OV(h_fig,n_mol_disp);
update_taglist_AS(h_fig);
update_taglist_VV(h_fig);

% update color in string of selection popupmenu
str_pop = getStrPop_select(h_fig);
curr_slct = get(h.tm.popupmenu_selection,'value');
if curr_slct>numel(str_pop)
    curr_slct = numel(str_pop);
end
set(h.tm.popupmenu_selection,'value',curr_slct,'string',str_pop);

