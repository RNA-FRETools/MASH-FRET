function updatePnts(h_fig)

global pntCoord;
h = guidata(h_fig);
q = h.map;

crossDat = [0 0 1 0 0
            0 0 1 0 0
            1 1 0 1 1
            0 0 1 0 0
            0 0 1 0 0];
hlfy = floor(size(crossDat,1)/2);
hlfx = floor(size(crossDat,2)/2);

nChan = size(q.axes_bottom,2);

for i = 1:nChan
    if isfield(q, 'txt') && size(q.txt,2)>=i && size(q.txt{i},1)>0
        delete(q.txt{i});
    end

    if isfield(q, 'txtFull') && size(q.txtFull,2)>=i && ...
            size(q.txtFull{i},1)>0
       delete(q.txtFull{i});
    end

    img_raw = get(q.axes_bottom(i), 'UserData');
    img = img_raw;
    for n = 1:size(pntCoord{i},1)
        for y = -hlfy:hlfy
            for x = -hlfx:hlfx
                if (crossDat(y+hlfy+1,x+hlfx+1) == 1 && ...
                        (pntCoord{i}(n,2)+y+0.5)>0 && ...
                        (pntCoord{i}(n,2)+y+0.5)<=size(img,1) && ...
                        (pntCoord{i}(n,1)+x+0.5)>0 && ...
                        (pntCoord{i}(n,1)+x+0.5)<=size(img,2))
                    img(pntCoord{i}(n,2)+y+0.5,pntCoord{i}(n,1)+x+0.5) ...
                        = 0.8*max(max(img));
                end
            end
        end
    end

    q.img(i) = imagesc(0.5:size(img,2)-0.5, 0.5:size(img,1)-0.5, img, ...
        'Parent', q.axes_top(i),q.axes_top(i).CLim);
    set(q.img(i),'ButtonDownFcn',{@axes_map_ButtonDownFcn,h_fig,i});
    posCurs = 1 - get(q.slider(i), 'Value');
    pos_closeUp = get(q.axes_top(i), 'Position');
    pos_full = get(q.axes_bottom(i), 'Position');
    x = pos_full(3);
    y = pos_full(4);
    X = pos_closeUp(3);
    fract = 0.5*y*X/x;
    ylim(q.axes_top(i), ...
        [0 fract*size(img,1)] + posCurs*(1-fract)*size(img,1));
    
    q.txt{i} = [];
    q.txtFull{i} = [];
    y_lim = get(q.axes_top(i), 'YLim');
    for n = 1:size(pntCoord{i},1)
        if pntCoord{i}(n,2)>y_lim(1) && pntCoord{i}(n,2)<y_lim(2)
            q.txt{i}(size(q.txt{i},1)+1,1) = text('Parent', ...
                q.axes_top(i), 'String', num2str(pntCoord{i}(n,3)), ...
                'FontUnits', 'points', 'FontSize', 7, 'FontWeight', ...
                'bold', 'BackgroundColor', 'w', 'Position', ...
                [(pntCoord{i}(n,1)+3),(pntCoord{i}(n,2)+3)]);
        end
        q.txtFull{i}(n,1) = text('Parent', q.axes_bottom(i), 'String', ...
            num2str(pntCoord{i}(n,3)), 'FontUnits', 'points', ...
            'FontSize', 7, 'FontWeight', 'bold', 'BackgroundColor', ...
            'w', 'Position', [(pntCoord{i}(n,1)+3), (pntCoord{i}(n,2)+3)]);
    end
end

h.map = q;
guidata(h_fig,h);
