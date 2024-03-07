function buildMappingTool(img, lim, h_fig)
% buildMappingTool(img, lim, h_fig)
%
% Build "Mapping tool" window accessed by clicking "Map" in panel "Molecule
% coordinates" of Video processing.
%
% img: {1-by-1}[resy-by-resx] average image of a multi-channel video, or
%      {1-by-nChan}[resy_c-by-resx_c] average image of single-channel 
%      videos.
% lim: empty, or [1-by-(nChan+1)] pixel limits of channels on multi-channel
%      video.
% h_fig: handle to main figure

% defaults
un = 'pixels';
hsld = 20;
wsldy = 20;
htxt = 14;
winratio = 0.75;
zoomsldratio = 0.3;
zoomfactmax = 10;
figttl = 'Mapping tool';
menulbl0 = 'Delete last point';
menulbl1 = 'Delete last set';
menulbl2 = 'Export to file...';
menulbl3 = 'Close and Save';
menulbl4 = 'Help';
strzoom = 'Zoom: 100%';

% collect interface parameters
h = guidata(h_fig);

% determine number of channels
multichanvid = numel(img)==1 & ~isempty(lim);
if multichanvid
    nChan = size(lim,2) - 1;
else
    nChan = numel(img);
end

% size parameters
pos0 = get(0,'screensize');
hWin = pos0(4)*winratio;
wWin = pos0(3)*winratio;
xWin = (pos0(3)-wWin)/2;
yWin = (pos0(4)-hWin)/2;
wtxt = zoomsldratio*wWin;
hax = (hWin-htxt-2*hsld)/2;
wax = zeros(1,nChan);
for c = 1:nChan
    if multichanvid
        wax(c) = lim(c+1)-lim(c);
    else
        wax(c) = size(img{c},2);
    end
end
wax = (wWin-nChan*wsldy)*wax/sum(wax);

% collects channel average images and dimensions
img_c = cell(1,nChan);
res_y = zeros(1,nChan);
res_x = zeros(1,nChan);
stphor = zeros(nChan,2);
stpver = zeros(nChan,2);
for c = 1:nChan
    if multichanvid
        img_c{c} = img{1}(:,lim(c)+1:lim(c+1));
    else
        img_c{c} = img{c};
    end
    res_y(c) = size(img_c{c},1);
    res_x(c) = size(img_c{c},2);
    
    % calculates smallest slider step
    [wrect,hrect] = calcmaptoolrectdim(1,res_x(c),wax(c),hax);
    [stphor(c,:),stpver(c,:)] = ...
        calcmaptoolsldstep(wrect,hrect,res_x(c),res_y(c));
end
    
% create figure
h.figure_map = figure('Units', un, 'Name', figttl, 'Position', ...
    [xWin yWin wWin hWin], 'Toolbar', 'none', 'MenuBar', 'none', ...
    'NumberTitle', 'off', 'Pointer', 'crosshair');
h_fig2 = h.figure_map;
set(h_fig2,'CloseRequestFcn',{@figure_map_CloseRequestFcn,h_fig});

% initialize mapping tool's structure
q = struct;
    
% build menus
q.menu = uimenu('Label','Menu');
q.menuDelLast = uimenu(q.menu, 'Label', menulbl0, 'Callback', ...
    {@deletePnt, 'last', h_fig});
q.menuDelSet = uimenu(q.menu, 'Label', menulbl1, 'Callback', ...
    {@deletePnt, 'set', h_fig});
q.menuExport = uimenu(q.menu, 'Label', menulbl2, 'Callback', ...
    {@menu_map_export, h_fig});
q.menuClose = uimenu(q.menu, 'Label', menulbl3, 'Callback', ...
    {@figure_map_CloseRequestFcn, h_fig});
q.menu_help = uimenu('Label', menulbl4, 'Callback',...
    {@pushbutton_help_Callback,getDocLink('mapping tool')});

% build GUI
x = 0;
y = 0;
for c = 1:nChan
    q.axes_bottom(c) = axes('Units', un, 'Position', [x y wax(c) hax], ...
        'UserData', img_c{c}, 'NextPlot', 'replacechildren', 'YDir', ...
        'reverse');
    
    x = x + wax(c);
end

y = hax;
x = 0;
for c = 1:nChan
    q.axes_top(c) = axes('Units', un, 'Position', [x y wax(c) hax], ...
        'NextPlot', 'replacechildren', 'YDir', 'reverse');
    
    x = x + wax(c);
    q.slider_y(c) = uicontrol('Style', 'slider', 'Units', un, 'Position', ...
        [x y wsldy hax], 'Min', 0, 'Max', 1, 'Value', 0, 'SliderStep', ...
        stpver(c,:), 'Callback', {@slider_map_y_Callback, h_fig});
    
    x = x + wsldy;
end

y = 2*hax;
x = 0;
for c = 1:nChan
    q.slider_x(c) = uicontrol('Style', 'slider', 'Units', un, 'Position', ...
        [x y wax(c) hsld], 'Min', 0, 'Max', 1, 'Value', 0, 'SliderStep', ...
        stphor(c,:), 'Callback', {@slider_map_x_Callback, h_fig});
    
    x = x + wax(c) + wsldy;
end

y = y+hsld;
x = (wWin-wtxt)/2;
q.text_zoom = uicontrol('style', 'text', 'units', un, 'position', ...
    [x y wtxt htxt], 'string', strzoom, 'horizontalalignment', 'center');

y = y+htxt;
q.slider_zoom = uicontrol('Style', 'slider', 'Units', un, 'Position', ...
    [x y wtxt hsld], 'Min', 1, 'Max', zoomfactmax, 'Value', 1, ...
    'SliderStep', [1/(4*(zoomfactmax-1)) 1/(zoomfactmax-1)], 'Callback', ...
    {@slider_zoom_Callback, h_fig});


colormap(h_fig2,'turbo');

h.map = q;
guidata(h_fig2,q);
guidata(h_fig,h);

setProp(h_fig2,'units','normalized');
