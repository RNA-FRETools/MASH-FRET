function adjustMaskPos_AS(q,pos)

h_axes = q.axes_histSort;
lim_x = get(h_axes,'xlim');
lim_y = get(h_axes,'ylim');

h_edit_x = [q.edit_xrangeLow,q.edit_xrangeUp];
h_edit_y = [q.edit_yrangeLow,q.edit_yrangeUp];

indy = get(q.popupmenu_selectYdata,'value')-1;
is2D = indy>0;

xrange = [str2num(get(h_edit_x(1),'string')) ...
    str2num(get(h_edit_x(2),'string'))];
yrange = [str2num(get(h_edit_y(1),'string')) ...
    str2num(get(h_edit_y(2),'string'))];

if ~is2D % 1D histograms
    x = xrange;
    if x(2)>lim_x(2)
        x(2) = lim_x(2);
    end
    if x(2)<lim_x(1)
        x(2) = lim_x(1);
    end
    if x(1)<lim_x(1)
        x(1) = lim_x(1);
    end
    if x(1)>lim_x(2)
        x(1) = lim_x(2);
    end
    if x(1)==x(2) && pos(1)>x(1)
        id = 2;
    else
        [o,id] = min(abs(x-pos(1)));
    end

    set(h_edit_x(id),'string',num2str(pos(1)));
    fcn = get(h_edit_x(id),'callback');
    feval(fcn{1},h_edit_x(id),[],q.figure_MASH);

else % E-S histograms
    x = xrange;
    y = yrange;
    if x(2)>lim_x(2)
        x(2) = lim_x(2);
    end
    if x(2)<lim_x(1)
        x(2) = lim_x(1);
    end
    if x(1)<lim_x(1)
        x(1) = lim_x(1);
    end
    if x(1)>lim_x(2)
        x(1) = lim_x(2);
    end
    if x(1)==x(2) && pos(1)>x(1)
        idx = 2;
    else
        [o,idx] = min(abs(x-pos(1)));
    end

    set(h_edit_x(idx),'string',num2str(pos(1)));
    fcn = get(h_edit_x(idx),'callback');
    feval(fcn{1},h_edit_x(idx),[],q.figure_MASH);

    if y(2)>lim_y(2)
        y(2) = lim_y(2);
    end
    if y(2)<lim_y(1)
        y(2) = lim_y(1);
    end
    if y(1)<lim_y(1)
        y(1) = lim_y(1);
    end
    if y(1)>lim_y(2)
        y(1) = lim_y(2);
    end
    if y(1)==y(2) && pos(2)>y(1)
        idy = 2;
    else
        [o,idy] = min(abs(y-pos(2)));
    end

    set(h_edit_y(idy),'string',num2str(pos(2)));
    fcn = get(h_edit_y(idy),'callback');
    feval(fcn{1},h_edit_y(idy),[],q.figure_MASH);
end
    
    