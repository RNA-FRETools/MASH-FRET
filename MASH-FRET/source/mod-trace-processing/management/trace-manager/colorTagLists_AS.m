function str_lst = colorTagLists_AS(h_fig,i)
% Defines colored strings for listboxes listing tag names in tool
% "Auto sorting"

h = guidata(h_fig);
dat3 = get(h.tm.axes_histSort,'userdata');
rangeTag = dat3.rangeTags;
tagNames = h.tm.molTagNames;
tagClr = h.tm.molTagClr;
nTag = numel(tagNames);

if size(rangeTag,1)<i
    str_lst = {'no tag'};
    return;
end

str_lst = {};
for t = 1:nTag
    if rangeTag(i,t)
        if sum(double((hex2rgb(tagClr{t})/255)>0.5))==3
            fntClr = 'black';
        else
            fntClr = 'white';
        end
        str_lst = [str_lst cat(2,'<html><span bgcolor=',tagClr{t},'>',...
            '<font color="',fntClr,'">',tagNames{t},...
            '</font></body></html>')];
    end
end
if ~sum(rangeTag(i,:))
    str_lst = {'no tag'};
end
