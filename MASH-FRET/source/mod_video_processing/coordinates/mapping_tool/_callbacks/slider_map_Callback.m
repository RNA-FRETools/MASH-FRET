function slider_map_Callback(obj, evd, h_fig, chan)

h = guidata(h_fig);
q = h.map;

posCurs = 1 - get(obj, 'Value');

img = get(q.axes_bottom(chan), 'UserData');
pos_closeUp = get(q.axes_top(chan), 'Position');
pos_full = get(q.axes_bottom(chan), 'Position');
x = pos_full(3);
y = pos_full(4);
X = pos_closeUp(3);
fract = 0.5*y*X/x;

posRect = get(q.rect(chan), 'Position');
posRect(2) = posCurs*(1-fract)*size(img,1)+2;
set(q.rect(chan), 'Position', posRect);

updatePnts(h_fig)