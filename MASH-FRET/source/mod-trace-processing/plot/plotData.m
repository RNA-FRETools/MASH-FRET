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
trajid = 1:2:6;
histid = 2:2:6;
topid0 = [1,2];
topid = [3,4];
botid = [5,6];
topyLab =  'counts';
botyLab = 'FRET / S';
timeLab = 'time (s)';
frameLab = 'frame';
xLab2 = 'norm. freq.';
nbins = 100; % nb of histogram bins

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
frames = find(incl);
x_lim = [((frames(1)-1)*nExc+1) frames(end)*nExc];
if ~isempty(prm)
    cutIt = prm{2}{1}(1);
    method = prm{2}{1}(2);
    cutOff = prm{2}{1}(4+method);
else
    cutIt = 0;
    cutOff = x_lim(2);
end
x_axis = x_lim(1):x_lim(2);
if inSec
    cutOff = cutOff*expT;
    x_axis = x_axis*expT;
end

% determine which data to plot
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

% clear and prep axes
A = numel(axnm);
exclax = false(1,A);
axhdl = repmat(gca,1,A);
if curr_chan_top<=0
    exclax([3,4]) = true;
end
if ~((nFRET>0 || nS>0) && (numel(curr_chan_bottom)>1 ||curr_chan_bottom>0))
    exclax([5,6]) = true;
end
for a = 1:A
    if isfield(ax, axnm{a})
        axhdl(a) = ax.(axnm{a});
        cla(ax.(axnm{a}));
    end
end
setPropIfField(ax,axnm(exclax),'Visible','off');
if all(exclax)
    return
end
setPropIfField(ax, axnm(~exclax), 'NextPlot', 'add', 'Visible', 'on', ...
    'YLimMode', 'auto', 'XLimMode', 'auto');

% identify trajectory and histogram axes to plot on
ishist = getaxbool(exclax,histid);
istraj = getaxbool(exclax,trajid);
istop0 = getaxbool(exclax,topid0);
istop = getaxbool(exclax,topid);
isbot = getaxbool(exclax,botid);

% define axis labels
if perSec
    topyLab = [topyLab ' per s.'];
end
if inSec
    xLab1 = timeLab;
else
    xLab1 = frameLab;
end

% plot total intensity trajectories and histogram
for c = 1:nChan
    l = find(exc==chanExc(c));
    if isempty(l)
        continue
    end

    plotData_traj(ax, 'axes_traceTop0', x_axis(l:nExc:end)',...
        sum(I(:,:,l),2), clr{1}{l,c}, plotDscr, sum(discrI(:,:,l),2), 'k');

    plotData_hist(ax, 'axes_histTop0', sum(I(:,:,l),2), [], nbins, ...
        clr{1}{l,c});
end

% plot intensity trajectories and histogram
if curr_chan_top > 0
    for l = curr_exc
        for c = curr_chan_top
            plotData_traj(ax, 'axes_traceTop', x_axis(l:nExc:end)',...
                I(:,c,l), clr{1}{l,c}, plotDscr, discrI(:,c,l), 'k');

            plotData_hist(ax, 'axes_histTop', I(:,c,l), [], nbins, ...
                clr{1}{l,c});
        end
    end
end

% plot intensity-ratio trajectories and histogram
if (nFRET>0 || nS>0) && (numel(curr_chan_bottom)>1 ||curr_chan_bottom>0)    
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
            [~,l,~] = find(exc==chanExc(FRET(c,1)));
            plotData_traj(ax, 'axes_traceBottom', x_axis(l:nExc:end)',...
                f_tr(:,c), clr{2}(c,:), plotDscr, discrFRET(:,c), 'r');

            plotData_hist(ax, 'axes_histBottom', f_tr(:,c), FRETlim, nbins, ...
                clr{2}(c,:));
            
        else
            i_s = c-nFRET;
            s = p.proj{proj}.S(i_s,1);
            [~,l,~] = find(exc==chanExc(s),1);

            plotData_traj(ax, 'axes_traceBottom', x_axis(l:nExc:end)',...
                s_tr(:,i_s), clr{3}(i_s,:), plotDscr, discrS(:,i_s), 'r');

            plotData_hist(ax, 'axes_histBottom', s_tr(:,i_s), FRETlim, nbins, ...
                clr{3}(i_s,:));
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

% show time cutoff on trajectory axes
if any(istraj) && (~cutIt && cutOff<numel(incl)*nExc)
    for hdl = axhdl(istraj)
        ylim_top = hdl.YLim;
        plot(hdl,[cutOff cutOff],ylim_top,'-c');
        set(hdl, 'YLim', ylim_top);
    end
end

% finalize all axes
if ~valid(mol)
    shad = [0.85 0.85 0.85];
else
    shad = [1 1 1];
end
grid(axhdl(~exclax),'on');
set(axhdl(~exclax),'NextPlot','replace','Color',shad);

% set axis limits and labels
if any(istraj)
    xlim(axhdl(istraj),x_axis([1,end]));  
    xlabel(axhdl(istraj),xLab1);
    if any(istraj&(istop|istop0))
        if ~isempty(Ilim)
            ylim(axhdl(istraj&(istop|istop0)), Ilim);
        end
        ylabel(axhdl(istraj&(istop|istop0)), topyLab);
    end
    if any(istraj&isbot)
        ylim(axhdl(istraj&isbot), FRETlim);
        ylabel(axhdl(istraj&isbot), botyLab);
    end
end

% finalize histogram axes
if any(ishist)
    set(axhdl(ishist),'YAxisLocation','right');
    xlabel(axhdl(ishist),xLab2);
end


function plotData_traj(ax,axnm,x,y1,clr1,is2,y2,clr2)
% plotData_traj(ax,axnm,x,y1,clr1,is2,y2,clr2)

if ~isfield(ax,axnm)
    return
end

plot(ax.(axnm), x(~isnan(y1)), y1(~isnan(y1)), 'Color', clr1);
if ~is2
    return
end
plot(ax.(axnm), x(~isnan(y2)), y2(~isnan(y2)), 'Color',clr2);


function plotData_hist(ax,axnm,dat,lim,nbins,clr)
% plotData_hist(ax,axnm,dat,lim,nbins,clr)

if ~isfield(ax,axnm)
    return
end
if ~isempty(lim)
    [cnts,edg] = histcounts(dat, linspace(lim(1),lim(2),nbins+1));
else
    [cnts,edg] = histcounts(dat, nbins);
end
cnts = cnts/sum(cnts);

histogram(ax.(axnm),'binedges',edg,'bincounts',cnts, 'FaceColor',...
    clr,'EdgeColor',clr,'orientation','horizontal');


function isid = getaxbool(excl,id)
% isid = getaxbool(excl,id)

isid = false(size(excl));
isid(id) = true;
isid(excl) = false;




