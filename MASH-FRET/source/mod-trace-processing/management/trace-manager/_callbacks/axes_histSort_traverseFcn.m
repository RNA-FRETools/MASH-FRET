function axes_histSort_traverseFcn(h_fig,pos)

q = guidata(h_fig);

set(h_fig,'pointer','crosshair');

if q.isDown
    h_axes = q.axes_histSort;
    posaxes = getPixPos(h_axes);
    lim_x = get(h_axes,'xlim');
    lim_y = get(h_axes,'ylim');

    % recenter cursor on position
    [h,w] = size(get(h_fig,'pointershapecdata'));
    pos(1) = pos(1)+round(w/2)+2;
    pos(2) = pos(2)+round(h/2)+2;
    
    pos(1) = lim_x(1)+(lim_x(2)-lim_x(1))*(pos(1)-posaxes(1))/posaxes(3);
    pos(2) = lim_y(1)+(lim_y(2)-lim_y(1))*(pos(2)-posaxes(2))/posaxes(4);
    adjustMaskPos_AS(q,pos);
    refresh(h_fig);
end
