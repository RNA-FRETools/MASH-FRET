function axes_TDPplot1_traverseFcn(h_fig,pos)

h = guidata(h_fig);

set(h_fig,'pointer','crosshair');

pos = posFigToAxes(pos,h_fig,h.axes_TDPplot1,'normalized');

set(h.text_TA_tdpCoord,'string',cat(2,'x=',num2str(pos(1)),' y=',...
    num2str(pos(2))));

ud = get(h.axes_TDPplot1,'userdata');
if size(ud,2)==1
    isDown = ud;
    pos0 = [];
else
    isDown = ud(1,1);
    pos0 = ud(1,2:3);
end
if isDown && ~isempty(pos0)
    p = h.param.TDP;
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    tag = p.curr_tag(proj);
    state = get(h.popupmenu_TDPstate, 'Value');
    
    p.proj{proj}.prm{tag,tpe}.clst_start{2}(state,[1,2]) = ...
        [pos0(1)+(x-pos0(1))/2,abs(pos0(1)-x)/2];
    
    h.param.TDP = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'TDP');
    
elseif isDown
    set(h.axes_TDPplot1,'userdata',[isDown,x,y]);
end
