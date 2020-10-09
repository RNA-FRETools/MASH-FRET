function pos = posFigToAxes(pos,h_fig,h_axes,units)

% convert to pixels
if strcmp(units,'normalized')
    posfig = getPixPos(h_fig);
    pos(1) = pos(1)*posfig(3);
    pos(2) = pos(2)*posfig(4);
end

% convert to axes-referenced position and units
h_p = h_axes;
while h_p~=h_fig && isprop(h_p,'parent')
    posparent = getPixPos(h_p);
    pos(1) = pos(1)-posparent(1);
    pos(2) = pos(2)-posparent(2);
    h_p = get(h_p,'parent');
end

% convert in axis units
posaxes = getPixPos(h_axes);
lim_x = get(h_axes,'xlim');
lim_y = get(h_axes,'ylim');
pos(1) = lim_x(1)+(lim_x(2)-lim_x(1))*pos(1)/posaxes(3);
pos(2) = lim_y(1)+(lim_y(2)-lim_y(1))*pos(2)/posaxes(4);
