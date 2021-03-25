function figure_map_ResizeFcn(obj, evd, subImg, h_fig)

h = guidata(h_fig);
q = h.map;

nChan = size(q.axes_top,2);
% Draw pictures in axes
for i = 1:nChan
    pos_closeUp = get(q.axes_top(i), 'Position');
    pos_full = get(q.axes_bottom(i), 'Position');
    x = pos_full(3);
    y = pos_full(4);
    X = pos_closeUp(3);
    fract = 0.5*y*X/x;
    ylim(q.axes_top(i), [(1-fract)*size(subImg{i},1) size(subImg{i},1)]);
end