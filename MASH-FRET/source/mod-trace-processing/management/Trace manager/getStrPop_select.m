function str_lst = getStrPop_select(h_fig)
% Defines string in automatic molecule selection popupmenu

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);
tagNames = h.tm.molTagNames;
tagClr = h.tm.molTagClr;
nTag = numel(tagNames);

str_lst = {'current','all','none','inverse'};
for t = 1:nTag
    str_lst = [str_lst cat(2,'<html>add <span bgcolor=',tagClr{t},'>',...
            '<font color="white">',tagNames{t},'</font></body></html>')];
end
for t = 1:nTag
    str_lst = [str_lst cat(2,'<html>remove <span bgcolor=',tagClr{t},'>',...
            '<font color="white">',tagNames{t},'</font></body></html>')];
end
