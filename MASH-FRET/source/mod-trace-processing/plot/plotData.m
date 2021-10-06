function plotData(mol, p, axes, prm, plotDscr)

% update 29.11.2019 by MH: remove double axis labels when both axes (intensity & ratio) are used
% update 3.4.2019 by MH: correct data selection for plotting in bottom axes (curr_chan_bottom)

% collect experiment settings and processing parameters
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
exc = p.proj{proj}.excitations;
nExc = p.proj{proj}.nb_excitations;
chanExc = p.proj{proj}.chanExc;
valid = p.proj{proj}.coord_incl;
incl = p.proj{proj}.bool_intensities;
int_den = p.proj{proj}.intensities_denoise;
int_dta = p.proj{proj}.intensities_DTA;
FRET_dta = p.proj{proj}.FRET_DTA;
S_dta = p.proj{proj}.S_DTA;
rate = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
clr = p.proj{proj}.colours;
fix = p.proj{proj}.TP.fix;

nFRET = size(FRET,1);
nS = size(S,1);
incl = ~~incl(:,mol)';
I = int_den(incl,((mol-1)*nChan+1):mol*nChan,:);
if plotDscr
    discrI = int_dta(incl,((mol-1)*nChan+1):mol*nChan,:);
    if nFRET > 0
        discrFRET = FRET_dta(incl,((mol-1)*nFRET+1):mol*nFRET,:);
    end
    if nS > 0
        discrS = S_dta(incl,((mol-1)*nS+1):mol*nS,:);
    end
end
frames = find(incl);
x_lim = [((frames(1)-1)*nExc+1) frames(end)*nExc];
FRETlim = [-0.2 1.2];

curr_exc = fix{2}(1);
if curr_exc > nExc
    curr_exc = 1:nExc;
end
curr_chan_top = fix{2}(2) - 1; % "none" in first position
if curr_chan_top > nChan
    curr_chan_top = 1:nChan;
end
curr_chan_bottom = fix{2}(3) - 1; % "none" in first position
is_allfret = double(nFRET>1);
is_alls = double(nS>1);
is_all = double(nFRET>0 & nS>0);
if is_allfret && curr_chan_bottom==(nFRET+nS+is_allfret)
    curr_chan_bottom = 1:nFRET;
elseif is_alls && curr_chan_bottom==(nFRET+nS+is_allfret+is_alls)
    curr_chan_bottom = nFRET+1:nFRET+nS;
elseif is_all && curr_chan_bottom==(nFRET+nS+is_allfret+is_alls+is_all) % all
    curr_chan_bottom = 1:(nFRET+nS);
end

perSec = fix{2}(4);
perPix = fix{2}(5);
x_inSec = fix{2}(7);
if perSec
    I = I/rate;
    if plotDscr
        discrI = discrI/rate;
    end
end
if perPix
    I = I/nPix;
    if plotDscr
        discrI = discrI/nPix;
    end
end

if ~isempty(prm)
    cutIt = prm{2}{1}(1);
    method = prm{2}{1}(2);
    cutOff = prm{2}{1}(4+method);
else
    cutIt = 0;
    cutOff = x_lim(2);
end

x_axis = x_lim(1):x_lim(2);
if x_inSec
    cutOff = cutOff*rate;
    x_axis = x_axis*rate;
end

if isfield(axes, 'axes_traceTop')
    cla(axes.axes_traceTop);
    ylim(axes.axes_traceTop, 'auto');
end
if isfield(axes, 'axes_histTop')
    cla(axes.axes_histTop);
    ylim(axes.axes_histTop, 'auto');
end
if curr_chan_top > 0
    if isfield(axes, 'axes_traceTop')
        set(axes.axes_traceTop, 'NextPlot', 'add');
    end
    if isfield(axes, 'axes_histTop')
        set(axes.axes_histTop, 'NextPlot', 'add');
    end

    for l = curr_exc
        x = x_axis(l:nExc:end)';
        for c = curr_chan_top
            colr = clr{1}{l,c};
            if isfield(axes, 'axes_traceTop')
                plot(axes.axes_traceTop, x, I(:,c,l), 'Color', colr);
                if plotDscr
                    plot(axes.axes_traceTop, x(~isnan(discrI(:,c,l))), ...
                        discrI(~isnan(discrI(:,c,l)),c,l), '-k');
                end
            end
            if isfield(axes, 'axes_histTop')
                [histI x_I] = hist(I(:,c,l),100);
                histI = histI/sum(histI);
                barh(axes.axes_histTop,x_I,histI,'FaceColor',colr,...
                    'EdgeColor',colr);
            end
        end
    end
    if isfield(axes, 'axes_traceTop')
        set(axes.axes_traceTop, 'NextPlot', 'replace', 'Visible', 'on');
    end
    if isfield(axes, 'axes_histTop')
        set(axes.axes_histTop, 'NextPlot', 'replace', 'Visible', 'on', ...
            'YAxisLocation', 'right');
    end
    
    if isfield(axes, 'axes_traceTop')
        xlim(axes.axes_traceTop, [x_axis(1) x_axis(end)]);
        ylim(axes.axes_traceTop, 'auto');
    end

    yLab =  'counts';
    if perSec
        yLab = [yLab ' per s.'];
        
    end
    if perPix
        yLab = [yLab ' per pixel'];
    end
    if isfield(axes, 'axes_traceTop')
        ylabel(axes.axes_traceTop, yLab);
        if x_inSec
            xlabel(axes.axes_traceTop, 'time (s)');
        else
            xlabel(axes.axes_traceTop, 'frames');
        end
        grid(axes.axes_traceTop, 'on');
    end
    
    if isfield(axes, 'axes_histTop')
        xlim(axes.axes_histTop, 'auto');
        ylim(axes.axes_histTop, get(axes.axes_traceTop, 'YLim'));
        xlabel(axes.axes_histTop, 'norm. freq.');
        grid(axes.axes_histTop, 'on');
    end
end

if isfield(axes, 'axes_traceBottom')
    cla(axes.axes_traceBottom);
    ylim(axes.axes_traceBottom, 'auto');
end
if isfield(axes, 'axes_histBottom')
    cla(axes.axes_histBottom);
    ylim(axes.axes_histBottom, 'auto');
end

% modified by MH, 3.4.2019
% if curr_chan_bottom > 0
if (nFRET>0 || nS>0) && (numel(curr_chan_bottom)>1 ||curr_chan_bottom>0)
    if isfield(axes, 'axes_traceBottom')
        set(axes.axes_traceBottom, 'NextPlot', 'add');
    end
    if isfield(axes, 'axes_histBottom')
        set(axes.axes_histBottom, 'NextPlot', 'add');
    end
    
    if nFRET > 0
        gamma = prm{6}{1}(1,:);
        f_tr = calcFRET(nChan, nExc, exc, chanExc, FRET, I, gamma);
    end
    if nS > 0
        gamma = prm{6}{1}(1,:);
        beta = prm{6}{1}(2,:);
        s_tr = calcS(exc, chanExc, S, FRET, I, gamma, beta);
    end

    for c = curr_chan_bottom
        if c <= nFRET
            FRET_tr = f_tr(:,c);
            [o,l,o] = find(exc==chanExc(FRET(c,1)));
            [histF,x_F] = hist(FRET_tr, linspace(-0.3,1.3,160));
            histF = histF(x_F>=FRETlim(1) & x_F<=FRETlim(2))/sum(histF);
            x_F = x_F(x_F>=FRETlim(1) & x_F<=FRETlim(2));
            x = (x_axis(l:nExc:end))';
            colr = clr{2}(c,:);
            if isfield(axes, 'axes_traceBottom')
                plot(axes.axes_traceBottom, x, FRET_tr, 'Color', colr);
                if plotDscr
                    FRET_dr = discrFRET(:,c);
                    plot(axes.axes_traceBottom, x(~isnan(FRET_dr)), ...
                        FRET_dr(~isnan(FRET_dr)), '-r');
                end
            end
            if isfield(axes, 'axes_histBottom')
                barh(axes.axes_histBottom, x_F, histF, 'FaceColor', ...
                    colr, 'EdgeColor', colr);
            end
            
        else
            i_s = c-nFRET;
            S_tr = s_tr(:,i_s);
            s = p.proj{proj}.S(i_s,1);
            [o,l,o] = find(exc==chanExc(s),1);
            [histS,x_S] = hist(S_tr, linspace(-0.3,1.3,160));
            histS = histS(x_S>=FRETlim(1) & x_S<=FRETlim(2))/sum(histS);
            x_S = x_S(x_S>=FRETlim(1) & x_S<=FRETlim(2));
            colr = clr{3}(i_s,:);
            x = (x_axis(l:nExc:end))';
            if isfield(axes, 'axes_traceBottom')
                plot(axes.axes_traceBottom, x, S_tr, 'Color', colr);
                if plotDscr
                    S_dr = discrS(:,i_s);
                    plot(axes.axes_traceBottom, x(~isnan(S_dr)), ...
                        S_dr(~isnan(S_dr)), '-r');
                end
            end
            if isfield(axes, 'axes_histBottom')
                barh(axes.axes_histBottom, x_S, histS, 'FaceColor', colr, ...
                    'EdgeColor', colr);
            end
        end
    end
    
    if isfield(axes, 'axes_traceBottom')
        set(axes.axes_traceBottom, 'NextPlot', 'replace', 'Visible', 'on');
    end
    if isfield(axes, 'axes_histBottom')
        set(axes.axes_histBottom, 'NextPlot', 'replace', 'Visible', 'on', ...
            'YAxisLocation', 'right');
    end
    
    if isfield(axes, 'axes_traceBottom')
        ylim(axes.axes_traceBottom, FRETlim);
    end
    if isfield(axes, 'axes_traceBottom') && isfield(axes, 'axes_traceTop')
        xlim(axes.axes_traceBottom, get(axes.axes_traceTop, 'XLim'));
    elseif isfield(axes, 'axes_traceBottom')
        xlim(axes.axes_traceBottom, [x_axis(1) x_axis(end)]);
    end
    
    if isfield(axes,'axes_histBottom') && isfield(axes,'axes_traceBottom')
        ylim(axes.axes_histBottom, get(axes.axes_traceBottom, 'YLim'));
    elseif isfield(axes,'axes_histBottom')
        ylim(axes.axes_histBottom, 'auto');
    end
    if isfield(axes,'axes_histBottom')
        xlim(axes.axes_histBottom, 'auto');
        xlabel(axes.axes_histBottom, 'norm. freq.');
        grid(axes.axes_histBottom, 'on');
        
        % added by MH, 3.4.2019
        if isfield(axes,'axes_histTop')
            xlabel(axes.axes_histTop, '');
        end
    end
    if isfield(axes,'axes_traceBottom')
        if x_inSec
            xlabel(axes.axes_traceBottom, 'time (s)');
        else
            xlabel(axes.axes_traceBottom, 'frames');
        end
        ylabel(axes.axes_traceBottom, 'FRET / S');
        grid(axes.axes_traceBottom, 'on');
        
        % added by MH, 3.4.2019
        if isfield(axes, 'axes_traceTop')
            xlabel(axes.axes_traceTop, '');
        end
    end

    if isfield(axes,'axes_histTop') && isfield(axes,'axes_histBottom')
        xlim_bot = get(axes.axes_histBottom, 'XLim');
        xlim_top = get(axes.axes_histTop, 'XLim');
        xlim_all(1) = min([xlim_bot(1) xlim_top(1)]);
        xlim_all(2) = max([xlim_bot(2) xlim_top(2)]);
        xlim(axes.axes_histTop, xlim_all);
        xlim(axes.axes_histBottom, xlim_all);
    end

    if ~cutIt && cutOff < numel(incl)*nExc
        if isfield(axes,'axes_traceTop')
            set(axes.axes_traceTop, 'NextPlot', 'add');
            plot(axes.axes_traceTop, [cutOff cutOff], ...
                get(axes.axes_traceTop, 'YLim'), '-c');
            set(axes.axes_traceTop, 'NextPlot', 'replace');
        end
        if isfield(axes,'axes_traceBottom')
            set(axes.axes_traceBottom, 'NextPlot', 'add');
            plot(axes.axes_traceBottom, [cutOff cutOff], ...
                get(axes.axes_traceBottom, 'YLim'), '-c');
            set(axes.axes_traceBottom, 'NextPlot', 'replace');
        end
    end
end

if ~valid(mol)
    shad = [0.85 0.85 0.85];
else
    shad = [1 1 1];
end
if isfield(axes,'axes_traceTop')
    set(axes.axes_traceTop, 'Color', shad);
end
if isfield(axes,'axes_traceBottom')
    set(axes.axes_traceBottom, 'Color', shad);
end
if isfield(axes,'axes_histTop')
    set(axes.axes_histTop, 'Color', shad);
end
if isfield(axes,'axes_histBottom')
    set(axes.axes_histBottom, 'Color', shad);
end



