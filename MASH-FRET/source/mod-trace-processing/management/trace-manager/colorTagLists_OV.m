function str_lst = colorTagLists_OV(h_fig,i)
% Defines colored strings for listboxes listing tag names in tool
% "Overview"

h = guidata(h_fig);
molTag = h.tm.molTag;
tagNames = h.tm.molTagNames;
tagClr = h.tm.molTagClr;
nTag = numel(tagNames);

str_lst = {};
for t = 1:nTag
    if molTag(i,t)
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
if ~sum(molTag(i,:))
    str_lst = {'no tag'};
end

