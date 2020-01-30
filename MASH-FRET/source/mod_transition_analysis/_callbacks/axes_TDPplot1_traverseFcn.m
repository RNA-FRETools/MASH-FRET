function axes_TDPplot1_traverseFcn(h_fig,pos)

h = guidata(h_fig);

set(h_fig,'pointer','crosshair');

pos = posFigToAxes(pos,h_fig,h.axes_TDPplot1,'normalized');
x = pos(1);
y = pos(2);

set(h.text_TA_tdpCoord,'string',cat(2,'x=',num2str(x),' y=',num2str(y)));

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

    J = p.proj{proj}.curr{tag,tpe}.clst_start{1}(3);
    mat = p.proj{proj}.curr{tag,tpe}.clst_start{1}(4);
    clstDiag = p.proj{proj}.curr{tag,tpe}.clst_start{1}(9);
    
    % get cluster shape
    tool = get(h.tooglebutton_TDPmanStart,'userdata');
    tool(tool==0) = 1;
    p.proj{proj}.curr{tag,tpe}.clst_start{1}(2) = tool;
    
    wslct = abs(pos0(1)-x);
    hslct = abs(pos0(2)-y);
    if tool==3
        largeside = sqrt((wslct^2)+(hslct^2))/2;
        smallside = cos(pi/4)*largeside;
        if (x>pos0(1) && y>pos0(2)) || (x<pos0(1) && y<pos0(2))
            halfw = largeside;
            halfh = smallside;
        else
            halfw = smallside;
            halfh = largeside;
        end
    else
        halfw = wslct/2;
        halfh = hslct/2;
    end

    % get cluster index(es)
    if mat
        state = get(h.popupmenu_TDPstate, 'Value');
        nTrs = getClusterNb(J,mat,clstDiag);
        [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
        kx = j1==state;
        ky = j2==state;
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(kx,1) = pos0(1)+(x-pos0(1))/2;
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(ky,2) = pos0(1)+(x-pos0(1))/2;
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(kx,3) = halfw;
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(ky,4) = halfw;
    else
        k = get(h.popupmenu_TDPstate, 'Value');
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(k,1) = pos0(1)+(x-pos0(1))/2;
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(k,2) = pos0(2)+(y-pos0(2))/2;
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(k,3) = halfw;
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(k,4) = halfh;
    end

    h.param.TDP = p;
    guidata(h_fig, h);
    updateFields(h_fig, 'TDP');
    
elseif isDown
    set(h.axes_TDPplot1,'userdata',[isDown,x,y]);
end
