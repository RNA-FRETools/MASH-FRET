function axes_TDPplot1_traverseFcn(h_fig,pos)

h = guidata(h_fig);

set(h_fig,'pointer','crosshair');

% convert to pixels
posfig = getPixPos(h_fig);
pos(1) = pos(1)*posfig(3);
pos(2) = pos(2)*posfig(4);

% % recenter cursor on position
% [hp,wp] = size(get(h_fig,'pointershapecdata'));
% pos(1) = pos(1)+round(wp/2);
% pos(2) = pos(2)+round(hp/2);

% convert to axes-referenced position
h_axes = h.axes_TDPplot1;
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
x = lim_x(1)+(lim_x(2)-lim_x(1))*pos(1)/posaxes(3);
y = lim_y(1)+(lim_y(2)-lim_y(1))*pos(2)/posaxes(4);
    
set(h.text_TA_tdpCoord,'string',cat(2,'x=',num2str(x),' y=',num2str(y)));
