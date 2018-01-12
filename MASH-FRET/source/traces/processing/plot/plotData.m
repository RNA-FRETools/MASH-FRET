function plotData(mol, p, axes, prm, plotDscr)

proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
allExc = p.proj{proj}.excitations;
nExc = p.proj{proj}.nb_excitations;
chanExc = p.proj{proj}.chanExc;

incl = p.proj{proj}.bool_intensities(:,mol);
I = p.proj{proj}.intensities_denoise(incl,((mol-1)*nChan+1):mol*nChan,:);
if plotDscr
    discrI = p.proj{proj}.intensities_DTA(incl, ...
        ((mol-1)*nChan+1):mol*nChan,:);
    if nFRET > 0
        discrFRET = p.proj{proj}.FRET_DTA(incl, ...
            ((mol-1)*nFRET+1):mol*nFRET,:);
    end
    if nS > 0
        discrS = p.proj{proj}.S_DTA(incl,((mol-1)*nS+1):mol*nS,:);
    end
end
frames = find(incl);
x_lim = [((frames(1)-1)*nExc+1) frames(end)*nExc];
FRETlim = [-0.2 1.2];

curr_exc = p.proj{proj}.fix{2}(1);
nExc = p.proj{proj}.nb_excitations;
if curr_exc > nExc
    curr_exc = 1:nExc;
end

curr_chan_top = p.proj{proj}.fix{2}(2) - 1; % "none" in first position
nChan = p.proj{proj}.nb_channel;
if curr_chan_top > nChan
    curr_chan_top = 1:nChan;
end

curr_chan_bottom = p.proj{proj}.fix{2}(3) - 1; % "none" in first position
if curr_chan_bottom > nFRET + nS
    if nFRET > 1 && curr_chan_bottom == nFRET + nS + 1 % "all FRET"
        curr_chan_bottom = 1:nFRET;
    elseif nS > 1 && curr_chan_bottom == nFRET + nS + 1 % "all S"
        curr_chan_bottom = nFRET+1:nFRET+nS;
    else % "all"
        curr_chan_bottom = 1:(nFRET+nS);
    end
end

rate = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
perSec = p.proj{proj}.fix{2}(4);
perPix = p.proj{proj}.fix{2}(5);
x_inSec = p.proj{proj}.fix{2}(7);

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
    acc = prm{5}{4}(2);                % added by FS, 12.1.18
    pbGammaIt = prm{5}{5}(acc,1);      % added by FS, 12.1.18
    pbGammaOff = prm{5}{5}(acc,6);     % added by FS, 12.1.18
else
    cutIt = 0;
    cutOff = x_lim(2);
end

x_axis = x_lim(1):x_lim(2);
if x_inSec
    cutOff = cutOff*rate;
    pbGammaOff = pbGammaOff*rate;      % added by FS, 12.1.18
    x_axis = x_axis*rate;
end

clr = p.proj{proj}.colours;

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

    for exc = curr_exc
        for c = curr_chan_top
            colr = clr{1}{exc,c};
            x = x_axis(exc:nExc:end)';
            if isfield(axes, 'axes_traceTop')
                plot(axes.axes_traceTop, x, I(:,c,exc), 'Color', colr);
                if plotDscr
                    plot(axes.axes_traceTop, ...
                        x(~isnan(discrI(:,c,exc))), ...
                        discrI(~isnan(discrI(:,c,exc)),c,exc), '-k');
                end
            end
            if isfield(axes, 'axes_histTop')
                [histI x_I] = hist(I(:,c,exc),100);
                histI = histI/sum(histI);
                barh(axes.axes_histTop, ...
                    x_I, histI, 'FaceColor', colr, 'EdgeColor', colr);
            end
        end
    end
    if isfield(axes, 'axes_traceTop')
        set(axes.axes_traceTop, 'NextPlot', 'replace', ...
            'Visible', 'on');
    end
    if isfield(axes, 'axes_histTop')
        set(axes.axes_histTop, 'NextPlot', 'replace', ...
            'Visible', 'on', 'YAxisLocation', 'right');
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
if curr_chan_bottom > 0
    if isfield(axes, 'axes_traceBottom')
        set(axes.axes_traceBottom, 'NextPlot', 'add');
    end
    if isfield(axes, 'axes_histBottom')
        set(axes.axes_histBottom, 'NextPlot', 'add');
    end
    
    if nFRET > 0
        trs = p.proj{proj}.FRET;
        gamma = p.proj{proj}.curr{mol}{5}{3};
        f_tr = calcFRET(nChan, nExc, allExc, chanExc, trs, I, gamma);
    end

    for c = curr_chan_bottom
        if c <= nFRET
            FRET_tr = f_tr(:,c);
            [o,l,o] = find(allExc==chanExc(trs(c,1)));
            [histF,x_F] = hist(FRET_tr, linspace(-0.3,1.3,160));
            histF = ...
                histF(x_F >= FRETlim(1) & x_F <= FRETlim(2))/sum(histF);
            x_F = x_F(x_F >= FRETlim(1) & x_F <= FRETlim(2));
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
            s = p.proj{proj}.S(i_s,:);
            [o,l_s,o] = find(chanExc(s)==allExc);
            S_tr = sum(I(:,:,l_s),2)./sum(sum(I(:,:,:),2),3);
            [histS,x_S] = hist(S_tr, linspace(-0.3,1.3,160));
            histS = histS(x_S>=FRETlim(1) & x_S<=FRETlim(2))/sum(histS);
            x_S = x_S(x_S>=FRETlim(1) & x_S<=FRETlim(2));
            colr = clr{3}(i_s,:);
            x = mean([(x_axis(s(1):nExc:end))', ...
                (x_axis(s(1):nExc:end))'],2);
            if isfield(axes, 'axes_traceBottom')
                plot(axes.axes_traceBottom, x, S_tr, 'Color', colr);
                if plotDscr
                    S_dr = discrS(:,i_s);
                    plot(axes.axes_traceBottom, x(~isnan(S_dr)), ...
                        S_dr(~isnan(S_dr)), '-r');
                end
            end
            if isfield(axes, 'axes_histBottom')
                barh(axes.axes_histBottom, x_S, histS, 'FaceColor', ...
                    colr, 'EdgeColor', colr);
            end
        end
    end
    
    if isfield(axes, 'axes_traceBottom')
        set(axes.axes_traceBottom, 'NextPlot', 'replace', ...
            'Visible', 'on');
    end
    if isfield(axes, 'axes_histBottom')
        set(axes.axes_histBottom, 'NextPlot', 'replace', ...
            'Visible', 'on', 'YAxisLocation', 'right');
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
    end
    if isfield(axes,'axes_traceBottom')
        if x_inSec
            xlabel(axes.axes_traceBottom, 'time (s)');
        else
            xlabel(axes.axes_traceBottom, 'frames');
        end
        ylabel(axes.axes_traceBottom, 'FRET / S');
        grid(axes.axes_traceBottom, 'on');
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
    
    % added by FS, 12.1.18
    % draws the cutoff for the pb based gamma correction
    if pbGammaIt 
        if isfield(axes,'axes_traceTop')
            set(axes.axes_traceTop, 'NextPlot', 'add');
            plot(axes.axes_traceTop, [pbGammaOff pbGammaOff], ...
                get(axes.axes_traceTop, 'YLim'), '-r');
            set(axes.axes_traceTop, 'NextPlot', 'replace');
        end
        if isfield(axes,'axes_traceBottom')
            set(axes.axes_traceBottom, 'NextPlot', 'add');
            plot(axes.axes_traceBottom, [pbGammaOff pbGammaOff], ...
                get(axes.axes_traceBottom, 'YLim'), '-r');
            set(axes.axes_traceBottom, 'NextPlot', 'replace');
        end
    end
    
end

valid = p.proj{proj}.coord_incl;
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



