function str_lst = getStrPopTags(tagNames,colorlist)
% Build cell array containg html-formatted and colored molecule tags 

% created the by MH, 7.1.2020

str_lst = cell(1,length(tagNames));

nTag = size(tagNames,2);
for t = 1:nTag
    if sum(double((hex2rgb(colorlist{t})/255)>0.5))==3
        fntClr = 'black';
    else
        fntClr = 'white';
    end
    str_lst{t} = ['<html><body  bgcolor="' colorlist{t} '">' ...
        '<font color=',fntClr,'>' tagNames{t} ...
        '</font></body></html>'];
end
if isempty(str_lst)
    str_lst = {'no default tag'};
end