function axes_histSort_traverseFcn(h_fig,pos)

q = guidata(h_fig);

set(h_fig,'pointer','crosshair');

if q.isDown
    pos = posFigToAxes(pos,h_fig,q.axes_histSort,'pixels');
    adjustMaskPos_AS(q,pos);
    refresh(h_fig);
end
