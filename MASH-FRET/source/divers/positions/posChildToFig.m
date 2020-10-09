function pos = posChildToFig(pos,h_fig,h_pan,units)

% convert to figure-referenced pixel position
h_p = h_pan;
while h_p~=h_fig && isprop(h_p,'parent')
    posparent = getPixPos(h_p);
    pos(1) = pos(1)+posparent(1);
    pos(2) = pos(2)+posparent(2);
    h_p = get(h_p,'parent');
end

% convert to input units
if strcmp(units,'normalized')
    posfig = getPixPos(h_fig);
    pos(1) = pos(1)/posfig(3);
    pos(2) = pos(2)/posfig(4);
end