function str_lst = getStrPopTags(tagNames,colorlist)
% Build cell array containg html-formatted and colored molecule tags 

% created the by MH, 7.1.2020

nTag = size(tagNames,2);

if nTag==0
    str_lst = {'no default tag'};
else
    if isMATLABReleaseOlderThan('R2025a') % colored list with html tags
        str_lst = cell(1,length(tagNames));
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

    else % plain list
        str_lst = tagNames;
    end
end
