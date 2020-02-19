function pos_un = posAxesToFig(pos,h_fig,h_axes,units)

% convert in axis axes-referenced pixel position
posaxes = getPixPos(h_axes);
lim_x = get(h_axes,'xlim');
lim_y = get(h_axes,'ylim');
pos_un(1) = (pos(1)-lim_x(1))*posaxes(3)/(lim_x(2)-lim_x(1));
pos_un(2) = (pos(2)-lim_y(1))*posaxes(4)/(lim_y(2)-lim_y(1));

% convert to figure-referenced pixel position
h_p = h_axes;
while h_p~=h_fig && isprop(h_p,'parent')
    posparent = getPixPos(h_p);
    pos_un(1) = pos_un(1)+posparent(1);
    pos_un(2) = pos_un(2)+posparent(2);
    h_p = get(h_p,'parent');
end

% convert to input units
if strcmp(units,'normalized')
    posfig = getPixPos(h_fig);
    pos_un(1) = pos_un(1)/posfig(3);
    pos_un(2) = pos_un(2)/posfig(4);
end


