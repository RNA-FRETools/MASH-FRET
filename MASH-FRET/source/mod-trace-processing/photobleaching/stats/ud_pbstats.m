function ud_pbstats(~,~,fig,varargin)
% ud_pbstats(~,~,fig)
% ud_pbstats(~,~,fig,'all') (default)
% ud_pbstats(~,~,fig,'bleach')
% ud_pbstats(~,~,fig,'blink')
%
% Update plot in Photobleaching/blinking stats. If not specified, all plots
% are refreshed.
%
% fig: handle to Photobleaching/blinking stats figure

% defaults
nbins = 100;
nSpl = 100;
xlbl0 = 'survival times';
xlbl1 = 'blink-off times';

% determine which plot to update
if ~isempty(varargin)
    dattype = varargin{1};
else
    dattype = 'all';
end

% retrieve project data
h = guidata(fig);
h0 = guidata(h.fig_MASH);
p = h0.param;
proj = p.curr_proj;
incl = p.proj{proj}.bool_intensities';
nExc = p.proj{proj}.nb_excitations;
insec = p.proj{proj}.time_in_sec;
expt = p.proj{proj}.resampling_time;
if ~insec
    expt = 1;
end

% collect dwell times
survt = [];
offt = [];
[N,L] = size(incl);
trajlen = L*nExc;
for n = 1:N
    if ~(numel(p.proj{proj}.TP.prm)>=n && ...
            numel(p.proj{proj}.TP.prm{n})>=2 && ...
            numel(p.proj{proj}.TP.prm{n}{2})>=1 && ...
            numel(p.proj{proj}.TP.prm{n}{2}{1})>=6)
        continue
    end
    meth = p.proj{proj}.TP.prm{n}{2}{1}(2);
    start = p.proj{proj}.TP.prm{n}{2}{1}(4);
    cutoff = p.proj{proj}.TP.prm{n}{2}{1}(4+meth);
    if cutoff<trajlen
        survt = cat(2,survt,[cutoff;n]);
    end

    if meth~=2
        continue
    end
    dt = getDtFromDiscr(double(incl(n,start:cutoff))',1);
    offt = cat(2,offt,[dt(dt(:,2)==0,1)';repmat(n,1,nnz(dt(:,2)==0))]);
end

% plot survival time histogram
if any(strcmp(dattype,{'bleach','all'}))
    h.axes_bleachstats.UserData = plotbleachnblinkstats(h.axes_bleachstats,...
        h.popup_bleachscale.Value,survt,nbins,expt,xlbl0,nSpl);
end

% plot blink-off time histogram
if any(strcmp(dattype,{'blink','all'}))
    h.axes_blinkstats.UserData = plotbleachnblinkstats(h.axes_blinkstats,...
        h.popup_blinkscale.Value,offt,nbins,expt,xlbl1,nSpl);
end


function res = plotbleachnblinkstats(ax,sc,dt,nbins,expt,xlbl,nSpl)
% init output
res = struct('bincenter',[],'binedges',[],'cnt',[],'cmplP',[],'fit',[],...
    'lowfit',[],'upfit',[],'A',[],'dA',[],'tau',[],'dtau',[]);

for c = ax.Children
    delete(c); 
end
if size(dt,2)>1
    % collect data and fit results
    if isstruct(ax.UserData) && isfield(ax.UserData,'cnt') && ...
            ~isempty(ax.UserData.cnt)
        res = ax.UserData;
        cnt = res.cnt;
        y = res.cmplP;
        x = res.bincenter;
        yfit = res.fit;
        yfit_low = res.lowfit;
        yfit_up = res.upfit;
        amp = res.A;
        damp = res.dA;
        tau = res.tau;
        dtau = res.dtau;
    else
        [cnt,edg,x,y,yfit,yfit_low,yfit_up,amp,damp,tau,dtau] = ...
            calcandfit(dt,nbins,expt,nSpl);

        % store results in output
        res.cnt = cnt;
        res.cmplP = y;
        res.bincenter = x;
        res.binedges = edg;
        res.fit = yfit;
        res.lowfit = yfit_low;
        res.upfit = yfit_up;
        res.A = amp;
        res.dA = damp;
        res.tau = tau;
        res.dtau = dtau;
    end

    % plot ref hist
    scatter(ax,x(cnt>0),y(cnt>0));
    setaxisscale(ax,sc);

    % plot fit
    ax.NextPlot = 'add';
    plot(ax,x(cnt>0),yfit(cnt>0),'linewidth',2,'color','r');
    plot(ax,x(cnt>0),yfit_low(cnt>0),'linestyle','--','linewidth',2,...
        'color','r');
    plot(ax,x(cnt>0),yfit_up(cnt>0),'linestyle','--','linewidth',2,...
        'color','r');

    % show fit results
    if strcmp(ax.XScale,'log')
        xtxt = 10^(mean(log10(ax.XLim)));
    else
        xtxt = mean(ax.XLim);
    end
    if strcmp(ax.YScale,'log')
        ytxt = 10^(mean(log10(ax.YLim)));
    else
        ytxt = mean(ax.YLim);
    end
    if expt~=1
        tau_str = ' seconds';
        xlbl = [xlbl, ' in seconds'];
    else
        tau_str = ' time steps';
        xlbl = [xlbl, ' in time steps'];
    end
    text(ax,xtxt,ytxt,sprintf(['A=(%.2f',char(177),'%.2f)\ntau=(%.2f',...
        char(177),'%.2f)',tau_str],amp,damp,tau,dtau),'color','red',...
        'horizontalalignment','left','verticalalignment','middle');
    ax.NextPlot = 'replacechildren';
    xlabel(ax,xlbl);

else
    xlim(ax,[-1,1]);
    ylim(ax,[-1,1]);
    setaxisscale(ax,1);
    text(ax,0,0,'Not enough data','horizontalalignment','center');
end


function [cnt,edg,x,y,yfit,ylow,yup,A,dA,tau,dtau] = calcandfit(dt,nbins,...
    expt,nSpl)

% calc hist ref
[cnt,edg] = histcounts(dt(1,:),linspace(1,max(dt(1,:)),nbins));
y = cumsum(cnt);
y = 1-y/sum(cnt);
x = mean([edg(1:end-1);edg(2:end)])*expt;

% bootstrap fit data
disp('Perform bootstrap fit...');
amp_spl = [];
tau_spl = [];
dtcell = dtarr2cell(dt);
N = numel(dtcell);
for spl = 1:nSpl
    dtspl = dtcell2arr(dtcell(randsample(1:N,N,true)));
    [cntspl,edgspl] = ...
        histcounts(dtspl(1,:),linspace(1,max(dtspl(1,:)),nbins));
    yspl = cumsum(cntspl);
    yspl = 1-yspl/sum(cntspl);
    xspl = mean([edgspl(1:end-1);edgspl(2:end)])*expt;
    fitres = fit(xspl(cntspl>0)', yspl(cntspl>0)', 'exp1');
    amp_spl = cat(1,amp_spl,fitres.a);
    tau_spl = cat(1,tau_spl,-1/fitres.b);
end
A = mean(amp_spl);
dA = std(amp_spl);
tau = mean(tau_spl);
dtau = std(tau_spl);

yfit = A*exp(-x/tau);
ylow = (A-dA)*exp(-x/(tau-dtau));
yup = (A+dA)*exp(-x/(tau+dtau));


function dtcell = dtarr2cell(dt)
nid = unique(dt(2,:));
N = numel(nid);
dtcell = cell(1,N);
for n = 1:N
    dtcell{n} = dt(:,dt(2,:)==nid(n));
end


function dt = dtcell2arr(dtcell)
N = numel(dtcell);
dt = [];
for n = 1:N
    dt = cat(2,dt,dtcell{n});
end


function setaxisscale(ax,sc)
if any(sc==[1,2])
    set(ax,'xscale','linear');
end
if any(sc==[1,3])
    set(ax,'yscale','linear');
end
if any(sc==[3,4])
    set(ax,'xscale','log');
end
if any(sc==[2,4])
    set(ax,'yscale','log');
end