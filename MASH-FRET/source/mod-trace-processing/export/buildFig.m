function h_fig = buildFig(p_mol, m, m_i, N, p_fig, h_fig)
% "p" >>
% "m" >> real molecule number
% "m_i" >> molecule number on the figure
% "n" >> molecule number exported
% "N" >> number of molecule per figure
% "h_fig" >> handle of already existing figure

%% Create figure

if isempty(h_fig)
    units_0 = get(0, 'Units');
    set(0, 'Units', 'pixels');
    pos_0 = get(0, 'ScreenSize');
    set(0, 'Units', units_0);
    hFig = pos_0(4); % A4 format
    wFig = hFig*21/29.7;
    xFig = (pos_0(3) - wFig)/2;
    yFig = (pos_0(4) - hFig)/2;

    h_fig = figure('Visible', 'off', 'Units', 'pixels', 'Position', ...
        [xFig yFig wFig hFig], 'Color', [1 1 1], 'Name', 'Preview', ...
        'NumberTitle', 'off', 'MenuBar', 'none', 'PaperOrientation', ...
        'portrait', 'PaperType', 'A4');
    drawnow;
end

posFig = get(h_fig, 'Position');
wFig = posFig(3);
hFig = posFig(4);

isSubImg = p_fig.isSubimg;
isHist = p_fig.isHist;
isDiscr = p_fig.isDiscr;
isTop = p_fig.isTop;
topExc = p_fig.topExc;
topChan = p_fig.topChan;
isBot = p_fig.isBot;
botChan = p_fig.botChan;

if ~isfield(p_mol.proj{p_mol.curr_proj}.TP,'fix')
    p_mol.proj{p_mol.curr_proj}.TP.fix = cell(1,2);
    p_mol.proj{p_mol.curr_proj}.TP.fix{2} = zeros(1,7);
    p_mol.proj{p_mol.curr_proj}.TP.fix{2}(4) = 0; % perSec
    p_mol.proj{p_mol.curr_proj}.TP.fix{2}(5) = 1; % perPix
    p_mol.proj{p_mol.curr_proj}.TP.fix{2}(7) = 0; % x_inSec
end
p_mol.proj{p_mol.curr_proj}.TP.fix{2}(1) = topExc;
p_mol.proj{p_mol.curr_proj}.TP.fix{2}(2) = topChan;
p_mol.proj{p_mol.curr_proj}.TP.fix{2}(3) = botChan;

if ~isfield(p_mol.proj{p_mol.curr_proj}.TP, 'curr')
    prm =  [];
else
    prm = p_mol.proj{p_mol.curr_proj}.TP.curr{m};
end

nAxes = isBot + isTop;
sup3 = N > 3;

h_txt = 14;
fntSize = 10.66666;
mg = 10;

hMol = hFig/ceil(N/(1+sup3));
h_axes = (hMol-h_txt)/(nAxes+isSubImg);
w_full = (wFig/(1+sup3));

if isTop || isBot
    w_axes_tr = (1-isHist/4)*(w_full-mg);
else
    w_axes_tr = 0;
end
if isHist
    w_axes_hist = (1-3*double(isTop|isBot)/4)*(w_full-mg);
else
    w_axes_hist = 0;
end

a = [];

if sup3 && ~mod(m_i,2)
    extr_w = w_full;
    yNext = hFig - ((m_i/2)-1)*hMol - h_txt;
    
elseif sup3 && mod(m_i,2)
    extr_w = 0;
    yNext = hFig - (((m_i+1)/2)-1)*hMol - h_txt;
    
else
    extr_w = 0;
    yNext = hFig - (m_i-1)*hMol - h_txt;
end




%% Add molecule axes

if isSubImg
    nChan = p_mol.proj{p_mol.curr_proj}.nb_channel;
    dimImg = (w_full-mg)/nChan;
    dimImg = min([dimImg h_axes]);
    
    yNext = yNext - dimImg;
    xNext = extr_w + mg;
    
    img = zeros(1,nChan);
    
    for c = 1:nChan
        img(c) = axes('Parent',h_fig,'Units','pixels','FontUnits', ...
            'pixels','FontSize',fntSize,'ActivePositionProperty', ...
            'OuterPosition');
        pos = getRealPosAxes([xNext yNext dimImg dimImg], ...
            get(img(c),'TightInset'), 'traces');
        set(img(c), 'Position', pos);
        xNext = xNext + dimImg;
    end
    p_mol = plotSubImg(m, p_mol, img);
end

if isTop
    xNext = extr_w + mg;
    yNext = yNext - h_axes;
    
    a.axes_traceTop = axes('Parent',h_fig,'Units','pixels', ...
        'FontUnits','pixels','FontSize',fntSize,'ActivePositionProperty', ...
        'OuterPosition');
    if isBot
        set(a.axes_traceTop,'XTickLabel',[]);
    end
    pos = getRealPosAxes([xNext yNext w_axes_tr h_axes], ...
        get(a.axes_traceTop,'TightInset'),'traces');
    set(a.axes_traceTop, 'Position', pos);
    
    if isHist
        xNext = xNext + w_axes_tr;
    
        a.axes_histTop = axes('Parent',h_fig,'Units','pixels', ...
            'FontUnits','pixels','FontSize',fntSize,'ActivePositionProperty', ...
            'OuterPosition','YTick',[]);
        if isBot
            set(a.axes_histTop,'XTickLabel',[]);
        end
        pos = getRealPosAxes([xNext yNext w_axes_hist h_axes], ...
            get(a.axes_histTop,'TightInset'), 'hist');
        posTop = get(a.axes_traceTop, 'Position');
        pos([2 4]) = posTop([2 4]);
        set(a.axes_histTop, 'Position', pos);
    end
end

if isBot
    xNext = extr_w + mg;
    yNext = yNext - h_axes;

    a.axes_traceBottom = axes('Parent',h_fig,'Units','pixels', ...
        'FontUnits','pixels','FontSize',fntSize,'ActivePositionProperty', ...
            'OuterPosition');
    pos = getRealPosAxes([xNext yNext w_axes_tr h_axes], ...
        get(a.axes_traceBottom,'TightInset'), 'traces');
    if isTop
        posTop = get(a.axes_traceTop, 'Position');
        pos(3) = min([pos(3) posTop(3)]);
        posTop(3) = pos(3);
        set(a.axes_traceTop, 'Position', posTop);
    end
    set(a.axes_traceBottom, 'Position', pos);
    
    if isHist
        xNext = xNext + w_axes_tr;
        
        a.axes_histBottom = axes('Parent',h_fig,'Units','pixels', ...
            'FontUnits','pixels','FontSize',fntSize,'ActivePositionProperty', ...
            'OuterPosition','YTick',[]);
        pos = getRealPosAxes([xNext yNext w_axes_hist h_axes], ...
            get(a.axes_histBottom,'TightInset'), 'hist');
        if isTop
            posTop = get(a.axes_histTop, 'Position');
            pos(3) = min([pos(3) posTop(3)]);
            posTop(3) = pos(3);
            set(a.axes_histTop, 'Position', posTop);
        end
        posBot = get(a.axes_traceBottom, 'Position');
        pos([2 4]) = posBot([2 4]);
        set(a.axes_histBottom, 'Position', pos);
    end
end

if ~isempty(a)
    plotData(m, p_mol, a, prm, isDiscr);
    
    if isTop
        set([get(a.axes_traceTop,'XLabel') get(a.axes_traceTop,'YLabel')], ...
            'String',[]);
        if isHist
            set([get(a.axes_histTop,'XLabel') get(a.axes_histTop, ...
                'YLabel')],'String',[]);
        end
    end
    if isBot
        set([get(a.axes_traceBottom,'XLabel') get(a.axes_traceBottom, ...
            'YLabel')],'String',[]);
        if isHist
            set([get(a.axes_histBottom,'XLabel') get(a.axes_histBottom, ...
                'YLabel')],'String',[]);
        end
    end
end

if isSubImg
    title(img(1), ['molecule n:°' num2str(m)]);
elseif isTop
    title(a.axes_traceTop, ['molecule n:°' num2str(m)]);
elseif isBot
    title(a.axes_traceBottom, ['molecule n:°' num2str(m)]);
end






