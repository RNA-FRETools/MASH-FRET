function plotData(mol, p, ax, prm, plotDscr)
% plotData(mol, p, ax, prm, plotDscr)
%
% Plot intensity and intensity ratio trajectories and histograms for
% specified molecule.
%
% mol: molecule index
% p: main data structure containing experiment parameters and trajectory 
%    data.
% ax: structure containing optional fields:
%  ax.axes_traceTop0: handle to total intensity trajectory axes
%  ax.axes_histTop0: handle to total intensity histogram axes
%  ax.axes_traceTop: handle to intensity trajectory axes
%  ax.axes_histTop: handle to intensity histogram axes
%  ax.axes_traceBottom: handle to intensity ratio trajectory axes
%  ax.axes_histBottom: handle to intensity ratio histogram axes
% prm: cell array containing trace processing parameters
% plotDscr: logical 1 to plot discretized traces, 0 not to.

% defaults
axnm = {'axes_traceTop0','axes_histTop0','axes_traceTop','axes_histTop',...
    'axes_traceBottom','axes_histBottom'};
trajid = 1:2:6; % indexes in ax structure of trajectory axes
histid = 2:2:6; % indexes in ax structure of histogram axes
topid = [1,2]; % indexes in ax structure of top-most axes
midid = [3,4]; % indexes in ax structure of middle axes
botid = [5,6]; % indexes in ax structure of bottom axes
intyLab =  'counts';
ratyLab = 'FRET / S';
timeLab = 'time (s)';
frameLab = 'frame';
histxLab = 'norm. freq.';
nbins = 100; % nb of histogram bins
alphaval = 0.85; % transparency value for off-state
brightoffset = -0.15; % brightness offset for trajectory plot 
clr_cutoff = [0.3,0.3,0.3]; % color of cutoff bar

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
expT = p.proj{proj}.resampling_time;
perSec = p.proj{proj}.cnt_p_sec;
inSec = p.proj{proj}.time_in_sec;
clr = p.proj{proj}.colours;
fix = p.proj{proj}.TP.fix;

% collect y-data for current molecule
nFRET = size(FRET,1);
nS = size(S,1);
nandat = any(isnan(int_den(:,((mol-1)*nChan+1):mol*nChan,:)),[2,3])';
incl = ~~incl(:,mol)';
I = int_den(~nandat,((mol-1)*nChan+1):mol*nChan,:);
if plotDscr
    discrI = int_dta(~nandat,((mol-1)*nChan+1):mol*nChan,:);
    if nFRET > 0
        discrFRET = FRET_dta(~nandat,((mol-1)*nFRET+1):mol*nFRET,:);
    end
    if nS > 0
        discrS = S_dta(~nandat,((mol-1)*nS+1):mol*nS,:);
    end
end
if perSec
    I = I/expT;
    if plotDscr
        discrI = discrI/expT;
    end
end

% get y-axis limits
if fix{2}(7)
    Ilim = fix{2}([4,5]);
    if perSec
        Ilim = Ilim/expT;
    end
else
    Ilim = [];
end
FRETlim = [-0.2 1.2];

% get time data and x-axis limits
x_lim = [1 size(int_den,1)*nExc];
clipit = fix{2}(8);
if ~isempty(prm) && size(prm,2)>=2
    pbmethod = prm{2}{1}(2);
    cutOff = prm{2}{1}(4+pbmethod);
    start = prm{2}{1}(4);
else
    pbmethod = 1;
    cutOff = x_lim(2);
    start = x_lim(1);
end
x_axis = x_lim(1):x_lim(2);
if inSec
    start = start*expT;
    cutOff = cutOff*expT;
    x_axis = x_axis*expT;
end
firstnandat = find(~nandat,1,'last')*nExc;

% determine which data to plot
wl2plot = fix{2}(1);
if wl2plot > nExc
    wl2plot = 1:nExc;
end
chan2plot = fix{2}(2) - 1; % "none" in first position
if chan2plot > nChan
    chan2plot = 1:nChan;
end
rat2plot = fix{2}(3) - 1; % "none" in first position
is_allfret = double(nFRET>1);
is_alls = double(nS>1);
is_all = double(nFRET>0 & nS>0);
if is_allfret && rat2plot==(nFRET+nS+is_allfret)
    rat2plot = 1:nFRET;
elseif is_alls && rat2plot==(nFRET+nS+is_allfret+is_alls)
    rat2plot = nFRET+1:nFRET+nS;
elseif is_all && rat2plot==(nFRET+nS+is_allfret+is_alls+is_all) % all
    rat2plot = 1:(nFRET+nS);
end

% clear and prep axes
A = numel(axnm);
exclax = false(1,A);
axhdl = repmat(gca,1,A);
if chan2plot<=0
    exclax([3,4]) = true;
end
if ~((nFRET>0 || nS>0) && (numel(rat2plot)>1 || rat2plot>0))
    exclax([5,6]) = true;
end
for a = 1:A
    if isfield(ax, axnm{a})
        axhdl(a) = ax.(axnm{a});
        cla(ax.(axnm{a}));
    else
        exclax(a) = true;
    end
end
setPropIfField(ax,axnm(exclax),'Visible','off');
if all(exclax)
    return
end
setPropIfField(ax, axnm(~exclax), 'NextPlot', 'replace', 'Visible', 'on');

% set axis limits free
ylim(axhdl(~exclax),'auto');
xlim(axhdl(~exclax),'auto');

% identify trajectory and histogram axes to plot on
ishist = getaxbool(exclax,histid);
istraj = getaxbool(exclax,trajid);
istop = getaxbool(exclax,topid);
ismid = getaxbool(exclax,midid);
isbot = getaxbool(exclax,botid);

% define axis labels
if perSec
    intyLab = [intyLab ' per s.'];
end
if inSec
    trajxLab = timeLab;
else
    trajxLab = frameLab;
end

% plot total intensity trajectories and histogram
if nFRET>0
    gamma = prm{6}{1}(1,:);
end
gammamat = ones(size(I,1),nChan,nChan);
for pair = 1:nFRET
    gammamat(:,FRET(pair,1),FRET(pair,2)) = gamma(pair);
    gammamat(:,FRET(pair,2),FRET(pair,1)) = 1/gamma(pair);
end
for c = 1:nChan
    l = find(exc==chanExc(c));
    if isempty(l)
        continue
    end
    
    I0 = calccorrtotalint(c,chanExc,exc,I,gammamat);
    discrI0 = calccorrtotalint(c,chanExc,exc,discrI,gammamat);

    plotData_traj(ax,axnm{istop&istraj},x_axis(l:nExc:end)',I0,...
        clr{1}{l,c}',plotDscr,discrI0,brightoffset);

    plotData_hist(ax,axnm{istop&ishist},I0(incl),[],nbins,clr{1}{l,c}');
end

% plot intensity trajectories and histogram
if chan2plot > 0
    for l = wl2plot
        for c = chan2plot
            Ipl = I(:,c,l);
            discrIpl = discrI(:,c,l);
            Ipl(~incl) = NaN;
            discrIpl(~incl) = NaN;
            plotData_traj(ax,axnm{ismid&istraj}, x_axis(l:nExc:end)',...
                Ipl, clr{1}{l,c}', plotDscr, discrIpl, brightoffset);

            plotData_hist(ax,axnm{ismid&ishist}, I(incl,c,l), [], nbins, ...
                clr{1}{l,c}');
        end
    end
end

% plot intensity-ratio trajectories and histogram
if (nFRET>0 || nS>0) && (numel(rat2plot)>1 ||rat2plot>0)    
    if nFRET > 0
        gamma = prm{6}{1}(1,:);
        f_tr = calcFRET(nChan, nExc, exc, chanExc, FRET, I, gamma);
    end
    if nS > 0
        gamma = prm{6}{1}(1,:);
        beta = prm{6}{1}(2,:);
        s_tr = calcS(exc, chanExc, S, FRET, I, gamma, beta);
    end

    for c = rat2plot
        if c <= nFRET
            [~,l,~] = find(exc==chanExc(FRET(c,1)));
            Epl = f_tr(:,c);
            discrEpl = discrFRET(:,c);
            Epl(~incl) = NaN;
            discrEpl(~incl) = NaN;

            plotData_traj(ax,axnm{isbot&istraj}, x_axis(l:nExc:end)',...
                Epl,clr{2}(c,:),plotDscr,discrEpl,brightoffset);

            plotData_hist(ax,axnm{isbot&ishist},f_tr(incl,c),FRETlim,nbins, ...
                clr{2}(c,:));
            
        else
            i_s = c-nFRET;
            s = p.proj{proj}.S(i_s,1);
            [~,l,~] = find(exc==chanExc(s),1);
            Spl = s_tr(:,i_s);
            discrSpl = discrS(:,i_s);
            Spl(~incl) = NaN;
            discrSpl(~incl) = NaN;

            plotData_traj(ax,axnm{isbot&istraj},x_axis(l:nExc:end)',...
                Spl,clr{3}(i_s,:),plotDscr,discrSpl,brightoffset);

            plotData_hist(ax,axnm{isbot&ishist},s_tr(incl,i_s),FRETlim, ...
                nbins,clr{3}(i_s,:));
        end
    end
end
    
% use same scale for histogram counts
if any(ishist)
    xlim_hist = [];
    for hdl = axhdl(ishist)
        xlim_hist = cat(1,xlim_hist,hdl.XLim);
    end
    xlim_all = [min(xlim_hist(:,1)),max(xlim_hist(:,2))];
    xlim(axhdl(ishist),xlim_all);
end

% background-colored outlier portions of trajectories
if any(istraj)
    for hdl = axhdl(istraj)
        yaxis = [-1000,1000]*max(abs(hdl.YLim));
        xdata = x_axis(1:nExc:end);
        ydata = ones(size(xdata))*yaxis(2);
        ydata(incl) = yaxis(1);

        ylim_top = hdl.YLim;
        area(hdl,xdata,ydata,'linestyle','none','facecolor',[0,0,0],...
            'facealpha',1-alphaval,'basevalue',yaxis(1));
        set(hdl, 'YLim', ylim_top);
    end
end

% show time cutoff on trajectory axes
if any(istraj) 
    for hdl = axhdl(istraj)
        if (~clipit && (cutOff+1)<firstnandat)
            drawcutoff(hdl,cutOff,'-',clr_cutoff);
        end
        if pbmethod==2
            for em = 1:size(prm{2}{2},1)
                if (clipit && (prm{2}{2}(em,3)+1)>=firstnandat)
                    continue
                end
                drawcutoff(hdl,prm{2}{2}(em,3),'--',clr_cutoff);
            end
        end
    end
end

% finalize all axes
if ~valid(mol)
    for a = axhdl(~exclax)
        alpha(a,0);
    end
    bg = repmat(alphaval,1,3);
else
    bg = [1 1 1];
end
grid(axhdl(~exclax),'on');
set(axhdl(~exclax),'NextPlot','replace','Color',bg);

% set axis limits and labels
if any(istraj)
    if clipit
        xlim(axhdl(istraj),[start,cutOff]);  
    else
        xlim(axhdl(istraj),x_axis([1,firstnandat]));  
    end
    xlabel(axhdl(istraj),trajxLab);
    if any(istraj&(ismid|istop))
        if ~isempty(Ilim)
            ylim(axhdl(istraj&(ismid|istop)), Ilim);
        end
        ylabel(axhdl(istraj&(ismid|istop)), intyLab);
    end
    if any(istraj&isbot)
        ylim(axhdl(istraj&isbot), FRETlim);
        ylabel(axhdl(istraj&isbot), ratyLab);
    end
end

% finalize histogram axes
if any(ishist)
    for a = find(ishist)
        if istraj(a-1)
            axhdl(a).YLim = axhdl(a-1).YLim;
        end
    end
    set(axhdl(ishist),'YAxisLocation','right');
    xlabel(axhdl(ishist),histxLab);
end


function plotData_traj(ax,axnm,x,y1,clr,is2,y2,brightoffset)
% plotData_traj(ax,axnm,x,y1,clr1,is2,y2,brightoffset)

if ~isfield(ax,axnm)
    return
end
plot(ax.(axnm), x, y1, 'Color', clr);
if ~strcmp(ax.(axnm).NextPlot,'add')
    ax.(axnm).NextPlot = 'add';
end

if ~is2
    return
end
plot(ax.(axnm),x,y2,'Color',shiftbright(clr,brightoffset),'linewidth',2);


function plotData_hist(ax,axnm,dat,lim,nbins,clr)
% plotData_hist(ax,axnm,dat,lim,nbins,clr)

if ~isfield(ax,axnm) || isempty(dat)
    return
end
if ~isempty(lim)
    [cnts,edg] = histcounts(dat, linspace(lim(1),lim(2),nbins+1));
else
    [cnts,edg] = histcounts(dat, nbins);
end
if sum(cnts)==0
    return
end
cnts = cnts/sum(cnts);

histogram(ax.(axnm),'binedges',edg,'bincounts',cnts, 'FaceColor',...
    clr,'EdgeColor',clr,'orientation','horizontal');
if ~strcmp(ax.(axnm).NextPlot,'add')
    ax.(axnm).NextPlot = 'add';
end


function drawcutoff(hdl,cutOff,ls,clr)
ylim_top = hdl.YLim;
plot(hdl,[cutOff cutOff],[-1000,1000]*max(abs(ylim_top)),'color',...
    clr,'linewidth',2,'linestyle',ls);
set(hdl, 'YLim', ylim_top);


function isid = getaxbool(excl,id)
% isid = getaxbool(excl,id)

isid = false(size(excl));
isid(id) = true;
isid(excl) = false;




