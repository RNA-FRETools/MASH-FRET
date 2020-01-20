function axes_histSort_ButtonDownFcn(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

h_edit_x = [h.tm.edit_xrangeLow,h.tm.edit_xrangeUp];
h_edit_y = [h.tm.edit_yrangeLow,h.tm.edit_yrangeUp];

pos = get(h.tm.axes_histSort,'currentpoint');
ind = get(h.tm.popupmenu_selectData,'value');
xrange = [str2num(get(h_edit_x(1),'string')) ...
    str2num(get(h_edit_x(2),'string'))];
yrange = [str2num(get(h_edit_y(1),'string')) ...
    str2num(get(h_edit_y(2),'string'))];
xlim = get(h.tm.axes_histSort,'xlim');
ylim = get(h.tm.axes_histSort,'ylim');

if ind<=(nChan*nExc+nFRET+nS) % 1D histograms
    x = xrange;
    if x(2)>xlim(2)
        x(2) = xlim(2);
    end
    if x(2)<xlim(1)
        x(2) = xlim(1);
    end
    if x(1)<xlim(1)
        x(1) = xlim(1);
    end
    if x(1)>xlim(2)
        x(1) = xlim(2);
    end
    if x(1)==x(2) && pos(1,1)>x(1)
        id = 2;
    else
        [o,id] = min(abs(x-pos(1,1)));
    end
    
    set(h_edit_x(id),'string',num2str(pos(1,1)));
    fcn = get(h_edit_x(id),'callback');
    feval(fcn{1},h_edit_x(id),[],h_fig);
    
else % E-S histograms
    x = xrange;
    y = yrange;
    if x(2)>xlim(2)
        x(2) = xlim(2);
    end
    if x(2)<xlim(1)
        x(2) = xlim(1);
    end
    if x(1)<xlim(1)
        x(1) = xlim(1);
    end
    if x(1)>xlim(2)
        x(1) = xlim(2);
    end
    if x(1)==x(2) && pos(1,1)>x(1)
        idx = 2;
    else
        [o,idx] = min(abs(x-pos(1,1)));
    end
    
    set(h_edit_x(idx),'string',num2str(pos(1,1)));
    fcn = get(h_edit_x(idx),'callback');
    feval(fcn{1},h_edit_x(idx),[],h_fig);
    
    if y(2)>ylim(2)
        y(2) = ylim(2);
    end
    if y(2)<ylim(1)
        y(2) = ylim(1);
    end
    if y(1)<ylim(1)
        y(1) = ylim(1);
    end
    if y(1)>ylim(2)
        y(1) = ylim(2);
    end
    if y(1)==y(2) && pos(1,2)>y(1)
        idy = 2;
    else
        [o,idy] = min(abs(y-pos(1,2)));
    end
    
    set(h_edit_y(idy),'string',num2str(pos(1,2)));
    fcn = get(h_edit_y(idy),'callback');
    feval(fcn{1},h_edit_y(idy),[],h_fig);
end

