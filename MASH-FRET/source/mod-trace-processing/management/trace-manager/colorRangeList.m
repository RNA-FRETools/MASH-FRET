function str_lst = colorRangeList(h_fig)
% Defines colored strings for listboxes listing ranges in tool
% "Auto sorting"

h = guidata(h_fig);
dat3 = get(h.tm.axes_histSort,'userdata');
rangeTag = dat3.rangeTags;
tagClr = h.tm.molTagClr;
R = size(rangeTag,1);

if R==0
    str_lst = {'no range'};
    return;
end

str_lst = {};
for r = 1:R
    tags = find(rangeTag(r,:));
    nTag = numel(tags);
    if nTag>0
        if sum(double((hex2rgb(tagClr{tags(1)})/255)>0.5))==3
            fntClr = 'black';
        else
            fntClr = 'white';
        end
        str_r = cat(2,'<html><font color="',fntClr,'"><span bgcolor=',...
            tagClr{tags(1)},'>',num2str(r),'</span></font>');
        for t = 2:nTag
            str_r = cat(2,str_r,'<span bgcolor=',tagClr{tags(t)},...
                '>&#160;&#160;</span>');
        end
        str_r = cat(2,str_r,'</html>');
    else
        str_r = num2str(r);
    end
    
    str_lst = [str_lst str_r];
end
