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

% delete existing tags
nChan = size(q.axes_bottom,2);
for c = 1:nChan
    if isfield(q, 'txt') && size(q.txt,2)>=c && size(q.txt{c},1)>0
        delete(q.txt{c});
    end
    if isfield(q, 'txtFull') && size(q.txtFull,2)>=c && ...
            size(q.txtFull{c},1)>0
       delete(q.txtFull{c});
    end
end

% draw crosses on closeup images
img = cell(1,nChan);
cursx = zeros(1,nChan);
cursy = zeros(1,nChan);
for c = 1:nChan
    img{c} = get(q.axes_bottom(c), 'UserData');
    cursx(c) = get(q.slider_x(c), 'Value');
    cursy(c) = get(q.slider_y(c), 'Value');
    for n = 1:size(pntCoord{c},1)
        for y = -hlfy:hlfy
            for x = -hlfx:hlfx
                if (crossDat(y+hlfy+1,x+hlfx+1) == 1 && ...
                        (pntCoord{c}(n,2)+y+0.5)>0 && ...
                        (pntCoord{c}(n,2)+y+0.5)<=size(img{c},1) && ...
                        (pntCoord{c}(n,1)+x+0.5)>0 && ...
                        (pntCoord{c}(n,1)+x+0.5)<=size(img{c},2))
                    img{c}(pntCoord{c}(n,2)+y+0.5,pntCoord{c}(n,1)+x+0.5) ...
                        = 0.99*max(max(img{c}));
                end
            end
        end
    end
end

% set top axes limits and plot rectangle
q = plot_mappingtool(q,img,cursx,cursy,q.slider_zoom.Value,h_fig);

% add tags to closeup and full images
for c = 1:nChan
    q.txt{c} = [];
    q.txtFull{c} = [];
    y_lim = get(q.axes_top(c), 'YLim');
    for n = 1:size(pntCoord{c},1)
        if pntCoord{c}(n,2)>y_lim(1) && pntCoord{c}(n,2)<y_lim(2)
            q.txt{c}(size(q.txt{c},1)+1,1) = text('Parent', ...
                q.axes_top(c), 'String', num2str(pntCoord{c}(n,3)), ...
                'FontUnits', 'points', 'FontSize', 7, 'FontWeight', ...
                'bold', 'BackgroundColor', 'w', 'Position', ...
                [(pntCoord{c}(n,1)+3),(pntCoord{c}(n,2)+3)]);
        end
        q.txtFull{c}(n,1) = text('Parent', q.axes_bottom(c), 'String', ...
            num2str(pntCoord{c}(n,3)), 'FontUnits', 'points', ...
            'FontSize', 7, 'FontWeight', 'bold', 'BackgroundColor', ...
            'w', 'Position', [(pntCoord{c}(n,1)+3), (pntCoord{c}(n,2)+3)]);
    end
end

h.map = q;
guidata(h_fig,h);
