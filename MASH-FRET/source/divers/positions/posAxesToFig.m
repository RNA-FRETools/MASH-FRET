function pos_un = posAxesToFig(pos,h_fig,h_axes,units)

% convert in axis axes-referenced pixel position
posaxes = getPixPos(h_axes);
lim_x = get(h_axes,'xlim');
lim_y = get(h_axes,'ylim');
pos_un(1) = (pos(1)-lim_x(1))*posaxes(3)/(lim_x(2)-lim_x(1));
pos_un(2) = (pos(2)-lim_y(1))*posaxes(4)/(lim_y(2)-lim_y(1));

% convert to figure-referenced pixel position and input units
pos_un = posChildToFig(pos_un,h_fig,h_axes,units);



