function buildMappingTool(img, lim, h_fig)

% collect interface parameters
h = guidata(h_fig);

% Size parameters
hWin = 0.75;
wWin = 0.75;
xWin = (1-wWin)/2;
yWin = (1-hWin)/2;
w_sld = 0.015;

nChan = size(lim,2) - 1;
subImg = cell(1,nChan);
A_w = zeros(1,nChan);
for i = 1:nChan
    subImg{i} = img(:,lim(i)+1:lim(i+1));
    A_w(i) = lim(i+1) - lim(i);
end
A_w = A_w/sum(A_w);
subA_w = A_w*(1 - nChan*w_sld);
A_h = 0.5;

res_y = size(img,1);
    
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
for i = 1:nChan
    q.axes_bottom(i) = axes('Units', 'normalized', 'Position', ...
        [xNext yNext A_w(i) A_h]);
    
    xNext = xNext + A_w(i);
end

yNext = A_h;
xNext = 0;

for i = 1:nChan
    q.axes_top(i) = axes('Units', 'normalized', 'Position', ...
        [xNext yNext subA_w(i) A_h]);
    
    xNext = xNext + subA_w(i);
    
    q.slider(i) = uicontrol('Style','slider','Units','normalized',...
        'Position',[xNext yNext w_sld A_h],'Min',0,'Max',1,'Value',0,...
        'SliderStep',[1/res_y 0.25],'Callback',...
        {@slider_map_Callback,h_fig,i});
    
    xNext = xNext + w_sld;
end
    
% Draw pictures in axes
for i = 1:nChan
    imagesc(subImg{i}, 'Parent', q.axes_bottom(i));
    set(q.axes_bottom(i), 'UserData', subImg{i});
    axis(q.axes_bottom(i), 'image');

    q.img(i) = imagesc(0.5:size(subImg,2)-0.5, 0.5:size(subImg,1)-0.5, ...
        subImg{i}, 'Parent', q.axes_top(i));
    set(q.img(i), 'ButtonDownFcn', {@axes_map_ButtonDownFcn, h_fig, i});
    pos_closeUp = get(q.axes_top(i), 'Position');
    pos_full = get(q.axes_bottom(i), 'Position');
    W = pos_full(3);
    H = pos_full(4);
    w = pos_closeUp(3);
    hg = 0.5*(H/W)*w;
    xlim(q.axes_top(i), [0 size(subImg,2)]);
    ylim(q.axes_top(i), [(1-hg)*size(subImg{i},1) size(subImg{i},1)]);

    q.rect(i) = rectangle('Parent', q.axes_bottom(i), 'Position', ...
        [2, (1-hg)*size(subImg{i},1)+2, size(subImg{i},2)-2, ...
        hg*size(subImg{i},1)-2], 'LineWidth', 2, 'EdgeColor', 'r');
    
    set(q.slider(i), 'SliderStep', [0.1 0.25]);
end

colormap(h_fig2,'jet');

h.map = q;
guidata(h_fig2,q);
guidata(h_fig,h);
