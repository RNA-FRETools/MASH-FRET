function str_lst = colorTagNames(h_fig)
% Defines colored strings for popupmenus listing tag names

% Last update, 16.2.2020 by MH: use function getStrPopTags
% update, 24.4.2019 by MH: (1) fetch tag colors in project parameters (2) remove "unlabelled" tag
% Created, 24.4.2018 by FS

h = guidata(h_fig);

str_lst = getStrPopTags(h.tm.molTagNames,h.tm.molTagClr);
if ~strcmp(str_lst{1},'no default tag')
    str_lst = cat(2,'select tag',str_lst);
end

