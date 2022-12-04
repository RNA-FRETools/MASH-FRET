function buildMappingTool(img, lim, h_fig)

% collect interface parameters
h = guidata(h_fig);

multichanvid = numel(img)==1 & ~isempty(lim);

% Size parameters
hWin = 0.75;
wWin = 0.75;
xWin = (1-wWin)/2;
yWin = (1-hWin)/2;
w_sld = 0.015;

if multichanvid
    nChan = size(lim,2) - 1;
else
    nChan = numel(img);
end
subImg = cell(1,nChan);
A_w = zeros(1,nChan);
for c = 1:nChan
    if multichanvid
        subImg{c} = img{1}(:,lim(c)+1:lim(c+1));
        A_w(c) = lim(c+1) - lim(c);
    else
        subImg{c} = img{c};
        A_w(c) = size(img{c},2);
    end
end
A_w = A_w/sum(A_w);
subA_w = A_w*(1 - nChan*w_sld);
A_h = 0.5;

if multichanvid
    res_y = repmat(size(img{1},1),[1,nChan]);
else
    res_y = zeros(1,nChan);
    for c =1:nChan
        res_y(c) = size(img{c},1);
    end
end
    
% create figure
h.figure_map = figure('Units', 'normalized', 'Name', 'Mapping tool', ...
    'Position', [xWin yWin wWin hWin], 'Toolbar', 'none', 'MenuBar', ...
    'none', 'NumberTitle', 'off', 'Pointer', 'crosshair');
h_fig2 = h.figure_map;
set(h_fig2,'ResizeFcn',{@figure_map_ResizeFcn, subImg, h_fig},...
    'CloseRequestFcn',{@figure_map_CloseRequestFcn,h_fig});

% initialize mapping tool's structure
q = struct;
    
% build menus
q.menu = uimenu('Label','Menu');
q.menuDelLast = uimenu(q.menu, 'Label', 'Delete last point', 'Callback', ...
    {@deletePnt, 'last', h_fig});
q.menuDelSet = uimenu(q.menu, 'Label', 'Delete last set', 'Callback', ...
    {@deletePnt, 'set', h_fig});
q.menuExport = uimenu(q.menu, 'Label', 'Export to file...', 'Callback', ...
    {@menu_map_export, h_fig});
q.menuClose = uimenu(q.menu, 'Label', 'Close and Save', 'Callback', ...
    {@figure_map_CloseRequestFcn, h_fig});
q.menu_help = uimenu('Label', 'Help', 'Callback',...
    {@pushbutton_help_Callback,getDocLink('mapping tool')});

% build GUI
yNext = 0;
xNext = 0;
for c = 1:nChan
    q.axes_bottom(c) = axes('Units', 'normalized', 'Position', ...
        [xNext yNext A_w(c) A_h]);
    
    xNext = xNext + A_w(c);
end

yNext = A_h;
xNext = 0;

for c = 1:nChan
    q.axes_top(c) = axes('Units', 'normalized', 'Position', ...
        [xNext yNext subA_w(c) A_h]);
    
    xNext = xNext + subA_w(c);
    
    q.slider(c) = uicontrol('Style','slider','Units','normalized',...
        'Position',[xNext yNext w_sld A_h],'Min',0,'Max',1,'Value',0,...
        'SliderStep',[1/res_y(c) 0.25],'Callback',...
        {@slider_map_Callback,h_fig,c});
    
    xNext = xNext + w_sld;
end
    
% Draw pictures in axes
for c = 1:nChan
    imagesc(subImg{c}, 'Parent', q.axes_bottom(c));
    set(q.axes_bottom(c), 'UserData', subImg{c});
    axis(q.axes_bottom(c), 'image');

    q.img(c) = imagesc(0.5:size(subImg,2)-0.5, 0.5:size(subImg,1)-0.5, ...
        subImg{c}, 'Parent', q.axes_top(c));
    set(q.img(c), 'ButtonDownFcn', {@axes_map_ButtonDownFcn, h_fig, c});
    pos_closeUp = get(q.axes_top(c), 'Position');
    pos_full = get(q.axes_bottom(c), 'Position');
    W = pos_full(3);
    H = pos_full(4);
    w = pos_closeUp(3);
    hg = 0.5*(H/W)*w;
    xlim(q.axes_top(c), [0 size(subImg,2)]);
    ylim(q.axes_top(c), [(1-hg)*size(subImg{c},1) size(subImg{c},1)]);

    q.rect(c) = rectangle('Parent', q.axes_bottom(c), 'Position', ...
        [2, (1-hg)*size(subImg{c},1)+2, size(subImg{c},2)-2, ...
        hg*size(subImg{c},1)-2], 'LineWidth', 2, 'EdgeColor', 'r');
    
    set(q.slider(c), 'SliderStep', [0.1 0.25]);
end

colormap(h_fig2,'turbo');

h.map = q;
guidata(h_fig2,q);
guidata(h_fig,h);
