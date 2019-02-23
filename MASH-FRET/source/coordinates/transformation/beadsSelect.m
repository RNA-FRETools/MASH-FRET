function pnt = beadsSelect(img, lim_x, pnt_start)
% Open a tool window similar to matlab tool cpselect, but for 3 images.
% Return coordinates of selected points in the three images.

pnt = [];

if size(img,3) > 1
    img = img(:,:,1);
end
nChan = size(lim_x,2) - 1;

global pntCoord;
if ~isempty(pnt_start) && size(pnt_start,2) == 2*nChan
    for i = 1:nChan
        pntCoord{i}(:,1) = pnt_start(:,2*i-1) - lim_x(i);
        pntCoord{i}(:,2) = pnt_start(:,2*i);
    end
else
    pntCoord = cell(1,nChan);
end

h = initFig(img, lim_x);

updatePnts(h.fig);

uiwait(h.fig);

minN = size(pntCoord{1},1);
for i = 2:nChan
    minN = min([minN size(pntCoord{i},1)]);
end

if minN > 0
    for i = 1:nChan
        pnt(1:minN,2*i-1) = pntCoord{i}(1:minN,1) + lim_x(i);
        pnt(1:minN,2*i) = pntCoord{i}(1:minN,2);
    end
end

pouet = 0;
    

function h = initFig(img, lim)

% Size parameters
hWin = 0.75;
wWin = 0.75;
xWin = (1-wWin)/2;
yWin = (1-hWin)/2;
w_sld = 0.015;

nChan = size(lim,2) - 1;
for i = 1:nChan
    subImg{i} = img(:,lim(i)+1:lim(i+1));
    A_w(i) = lim(i+1) - lim(i);
end
A_w = A_w/sum(A_w);
subA_w = A_w*(1 - nChan*w_sld);
A_h = 0.5;

res_y = size(img,1);
    
% Create and place all elements of the window

h.fig = figure('Units', 'normalized', 'Name', 'Mapping tool', ...
    'Position', [xWin yWin wWin hWin], 'Toolbar', 'none', 'MenuBar', ...
    'none', 'NumberTitle', 'off', 'Pointer', 'crosshair');

set(h.fig, 'ResizeFcn', {@fig_ResizeFcn, subImg}, 'CloseRequestFcn', ...
    {@fig_CloseRequestFcn, h.fig});
    
h.menu = uimenu('Label','Menu');
h.menuDelLast = uimenu(h.menu, 'Label', 'Delete last point', ...
    'Callback', {@deletePnt, 'last', h.fig});
h.menuDelSet = uimenu(h.menu, 'Label', 'Delete last set', ...
    'Callback', {@deletePnt, 'set', h.fig});
h.menuClose = uimenu(h.menu, 'Label', 'Close and Save', ...
    'Callback', {@fig_CloseRequestFcn, h.fig});

yNext = 0;
xNext = 0;

for i = 1:nChan
    h.axes_bottom(i) = axes('Units', 'normalized', 'Position', ...
        [xNext yNext A_w(i) A_h]);
    
    xNext = xNext + A_w(i);
end

yNext = A_h;
xNext = 0;

for i = 1:nChan
    h.axes_top(i) = axes('Units', 'normalized', 'Position', ...
        [xNext yNext subA_w(i) A_h]);
    
    xNext = xNext + subA_w(i);
    
    h.slider(i) = uicontrol('Style', 'slider', 'Units', 'normalized', ...
        'Position', [xNext yNext w_sld A_h], 'Min', 0, 'Max', 1, ...
        'Value', 0, 'SliderStep', [1/res_y 0.25], 'Callback', ...
        {@slider_Callback, h.fig, i});
    
    xNext = xNext + w_sld;
end
    
% Draw pictures in axes
for i = 1:nChan
    imagesc(subImg{i}, 'Parent', h.axes_bottom(i));
    axis(h.axes_bottom(i), 'image');
    pos_closeUp = get(h.axes_top(i), 'Position');
    h.img(i) = imagesc(0.5:size(subImg,2)-0.5, 0.5:size(subImg,1)-0.5, ...
        subImg{i}, 'Parent', h.axes_top(i));
    set(h.img(i), 'ButtonDownFcn', {@axes_ButtonDownFcn, h.fig, i});
    xlim(h.axes_top(i), [0 size(subImg,2)]);
    pos_full = get(h.axes_bottom(i), 'Position');
    W = pos_full(3);
    H = pos_full(4);
    w = pos_closeUp(3);
    hg = 0.5*(H/W)*w;
    ylim(h.axes_top(i), [(1-hg)*size(subImg{i},1) size(subImg{i},1)]);

    h.rect(i) = rectangle('Parent', h.axes_bottom(i), 'Position', ...
        [2, (1-hg)*size(subImg{i},1)+2, size(subImg{i},2)-2, ...
        hg*size(subImg{i},1)-2], 'LineWidth', 2, 'EdgeColor', 'r');
    
    set(h.slider(i), 'SliderStep', [0.1 0.25]);
    
    set(h.axes_bottom(i), 'UserData', subImg{i});
end

guidata(h.fig, h);


function fig_ResizeFcn(obj, evd, subImg)
h = guidata(obj);
nChan = size(h.axes_top,2);
% Draw pictures in axes
for i = 1:nChan
    pos_closeUp = get(h.axes_top(i), 'Position');
    pos_full = get(h.axes_bottom(i), 'Position');
    x = pos_full(3);
    y = pos_full(4);
    X = pos_closeUp(3);
    fract = 0.5*y*X/x;
    ylim(h.axes_top(i), [(1-fract)*size(subImg{i},1) size(subImg{i},1)]);
end


function slider_Callback(obj, evd, h_fig, chan)

h = guidata(h_fig);

posCurs = 1 - get(obj, 'Value');

img = get(h.axes_bottom(chan), 'UserData');
pos_closeUp = get(h.axes_top(chan), 'Position');
pos_full = get(h.axes_bottom(chan), 'Position');
x = pos_full(3);
y = pos_full(4);
X = pos_closeUp(3);
fract = 0.5*y*X/x;

posRect = get(h.rect(chan), 'Position');
posRect(2) = posCurs*(1-fract)*size(img,1)+2;
set(h.rect(chan), 'Position', posRect);

updatePnts(h_fig)


function axes_ButtonDownFcn(obj, evd, h_fig, chan)

global pntCoord;
h = guidata(h_fig);
newPnt = get(h.axes_top(chan), 'CurrentPoint');
disp(newPnt);
newPnt = fix(newPnt(1,1:2))+0.5;
disp(newPnt);

n = size(pntCoord{chan},1);
n_tot = 0;
for i = 1:size(pntCoord,2)
    n_tot = n_tot + size(pntCoord{i},1);
end
pntCoord{chan}(n+1,1) = newPnt(1);
pntCoord{chan}(n+1,2) = newPnt(2);
pntCoord{chan}(n+1,3) = n_tot + 1;

updatePnts(h_fig);


function updatePnts(h_fig)

global pntCoord;
h = guidata(h_fig);

crossDat = [0 0 1 0 0
            0 0 1 0 0
            1 1 0 1 1
            0 0 1 0 0
            0 0 1 0 0];

nChan = size(h.axes_bottom,2);

for i = 1:nChan
    if isfield(h, 'txt') && size(h.txt,2)>=i && size(h.txt{i},1)>0
        delete(h.txt{i});
    end

    if isfield(h, 'txtFull') && size(h.txtFull,2)>=i && ...
            size(h.txtFull{i},1)>0
       delete(h.txtFull{i});
    end

    img_raw = get(h.axes_bottom(i), 'UserData');
    img = img_raw;
    for n = 1:size(pntCoord{i},1)
        for y = -2:2
            for x = -2:2
                if (crossDat(y+3,x+3) == 1 && ...
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

    h.img(i) = imagesc(0.5:size(img,2)-0.5, 0.5:size(img,1)-0.5, img, ...
        'Parent', h.axes_top(i));
    set(h.img(i), 'ButtonDownFcn', {@axes_ButtonDownFcn, h.fig, i});
    posCurs = 1 - get(h.slider(i), 'Value');
    pos_closeUp = get(h.axes_top(i), 'Position');
    pos_full = get(h.axes_bottom(i), 'Position');
    x = pos_full(3);
    y = pos_full(4);
    X = pos_closeUp(3);
    fract = 0.5*y*X/x;
    ylim(h.axes_top(i), ...
    [0 fract*size(img,1)] + posCurs*(1-fract)*size(img,1));
    
    h.txt{i} = [];
    h.txtFull{i} = [];
    y_lim = get(h.axes_top(i), 'YLim');
    for n = 1:size(pntCoord{i},1)
        if pntCoord{i}(n,2)>y_lim(1) && pntCoord{i}(n,2)<y_lim(2)
            h.txt{i}(size(h.txt{i},1)+1,1) = text('Parent', ...
                h.axes_top(i), 'String', num2str(pntCoord{i}(n,3)), ...
                'FontUnits', 'points', 'FontSize', 7, 'FontWeight', ...
                'bold', 'BackgroundColor', 'w', 'Position', ...
                [(pntCoord{i}(n,1)+3),(pntCoord{i}(n,2)+3)]);
        end
        h.txtFull{i}(n,1) = text('Parent', h.axes_bottom(i), 'String', ...
            num2str(pntCoord{i}(n,3)), 'FontUnits', 'points', ...
            'FontSize', 7, 'FontWeight', 'bold', 'BackgroundColor', ...
            'w', 'Position', [(pntCoord{i}(n,1)+3), (pntCoord{i}(n,2)+3)]);
    end
end

guidata(h.fig, h);


function deletePnt(obj, evd, who, h_fig)

global pntCoord;
nChan = size(pntCoord,2);
h = guidata(h_fig);

if strcmp(who, 'last')
    maxN = 0;
    for i = 1:nChan
        if ~isempty(pntCoord{i})
            if max(pntCoord{i}(:,3)) > maxN
                lastChan = i;
                maxN = max(pntCoord{i}(:,3));
            end
        end
    end
    
    if maxN > 0
        pntCoord{lastChan} = pntCoord{lastChan}(1:(end-1), :);
    end
    
elseif strcmp(who, 'set')

    for i = 1:nChan
        if ~isempty(pntCoord{i})
            pntCoord{i} = pntCoord{i}(1:(end-1), :);
        end
    end
end

updatePnts(h.fig);


function fig_CloseRequestFcn(hObj, evd, h_fig)

delete(h_fig);



