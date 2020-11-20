function res = plotKinMdlSim(degen,tp,ip,expPrm,varargin)
% res = plotKinMdlSim(degen,tp,ip,expPrm)
% res = plotKinMdlSim(degen,tp,ip,expPrm,h_fig)
%
% Simulates state sequences according to input model parameters
% Evenzually plots the dwell time histograms, state population and transition counts in comparison to experimental data.
% Returns transition probabilities and initial probabilities calculated from simulated data 
%
% degen: {1-by-V} column vectors grouping indexes of degenerated states
% tp: [J-by-J] transition probability matrix
% ip: [1-by-J] initial state probabitlities
% expPrm: structure containing experimental data and parameters, with fields:
% 	expPrm.dt: [nDt-by-3] dwell times (seconds) and state indexes before and after transition
% 	expPrm.Ls: [1-by-N] experimental trajectory lengths
% 	expPrm.expT: binning time
% 	expPrm.excl: (1) to exclude first and last dwell times of each sequence, (0) otherwise
% h_fig: handles to figure where to plot data to
% res: structure containing probabilities calculated from simulated data
%	res.ip: initial state probabilities
%	res.dt: dwell times
%   res.k_exp: transition rate coefficients
%   res.n_exp: number of transitions
%   res.w_exp: transition probabiltiies
%   res.tp_exp: transition matrix
%   res.cumdstrb: {1-by-V}[3-by-nDt] x-axis values, experimental and simulated cumulative dwell time distributions
%   res.pop: [2-by-V] experimental and simulated state value populations
%   res.ntrs: [2-by-V] experimental and simulated numbers of transitions between state values

% default
plotIt = false; % true to plot

if ~isempty(varargin)
    h_fig = varargin{1};
    if ~isempty(h_fig)
        plotIt = true;
    end
end
Ls = expPrm.Ls;
expT = expPrm.expT;
dt_exp0 = expPrm.dt;
excl = expPrm.excl;
V = numel(degen);

% re-arrange experimental dwell times & get state sequences
% mols = unique(dt_exp0(:,2));
dt_exp = dt_exp0;
% for m = 1:numel(mols)
%     dt_exp_m = adjustDt(dt_exp0(dt_exp0(:,2)==mols(m),:));
%     if excl
%         dt_exp_m([1,end],:) = [];
%     end
%     dt_exp = cat(1,dt_exp,dt_exp_m);
% end

% simulate state sequences with actual model parameters
res = simStateSequences(tp,ip,Ls);
dt_sim0 = res.dt;
if sum(sum(res.w_exp,1)==0) || sum(sum(res.w_exp,2)==0) || ...
        sum(sum(isnan(res.w_exp)))
    res = [];
    return
end

% fusion dwells from degenerated states
js = [];
for v = 1:V
    js = cat(2,js,degen{v}');
    for j_degen = degen{v}'
        dt_sim0(dt_sim0(:,3)==j_degen,3) = v;
        dt_sim0(dt_sim0(:,4)==j_degen,4) = v;
    end
end
mols_sim = unique(dt_sim0(:,2));
dt_sim = [];
for m = mols_sim'
    dt_sim_m = adjustDt(dt_sim0(dt_sim0(:,2)==m,:));
    if excl
        dt_sim_m([1,end],:) = [];
    end
    dt_sim = cat(1,dt_sim,dt_sim_m);
end
dt_sim(:,1) = dt_sim(:,1)*expT; % convert frame count to time
dt_sim = dt_sim(:,[1,3:end]); % remove molecule index

% count nb. of transitions
Nsim = [];
Nexp = [];
ylbl = {};
for v1 = 1:V
    for v2 = 1:V
        if v1==v2
            continue
        end
        Nsim = cat(2,Nsim,sum(dt_sim(:,2)==v1 & dt_sim(:,3)==v2));
        Nexp = cat(2,Nexp,sum(dt_exp(:,3)==v1 & dt_exp(:,4)==v2));
        ylbl = cat(2,ylbl,sprintf('%i%i',v1,v2));
    end
end

% build dwell time histgrams
sumExp = 0;
sumSim = 0;
cum_counts_exp = cell(1,V);
cum_counts_sim = cell(1,V);
bins = cell(1,V);
ndtExp = cell(1,V);
ndtSim = cell(1,V);
maxDt = zeros(1,V);
minDt = zeros(1,V);
popSim = zeros(1,V);
popExp = zeros(1,V);
for v = 1:V
    dt_sim_j1 = dt_sim(dt_sim(:,2)==v,1);
    dt_exp_j1 = dt_exp(dt_exp(:,3)==v,1);
    
    popSim(v) = sum(dt_sim_j1);
    popExp(v) = sum(dt_exp_j1);

    maxDt(v) = max([dt_sim_j1;dt_exp_j1]);
    minDt(v) = min([dt_sim_j1(dt_sim_j1>0);dt_exp_j1(dt_exp_j1>0)]);
    bins{v} = expT:expT:maxDt(v);

    cum_counts_exp{v} = cumsum(histcounts(dt_exp_j1,[bins{v},Inf])');
    cum_counts_sim{v} = cumsum(histcounts(dt_sim_j1,[bins{v},Inf])');
    
    ndtExp{v} = max(cum_counts_exp{v});
    ndtSim{v} = max(cum_counts_sim{v});
    
    sumExp = sumExp+ndtExp{v};
    sumSim = sumSim+ndtSim{v};
end
res.ntrs = [Nexp;Nsim];
res.pop = [popExp;popSim];

% plot data
cumdstrb = cell(1,V);
for v = 1:V
    cum_exp = cum_counts_exp{v};
    maxCumExp = max(cum_exp);
    cum_sim = cum_counts_sim{v};
    maxCumSim = max(cum_sim);
    cmpl_exp = 1-cum_exp/maxCumExp;
    cmpl_sim = 1-cum_sim/maxCumSim;
    
    cumdstrb{v} = [bins{v};cum_exp';cum_sim'];

    % plot histograms and fit functions
    if plotIt
        lim_y = [min([cum_exp(cum_exp>0)',...
            cum_sim(cum_sim>0)']),...
            max([cum_exp(cum_exp>0)',...
            cum_sim(cum_sim>0)'])];
        lim_x = [bins{v}(1),bins{v}(end)];
        
        h_a = subplot(2,V+1,v,'replace','parent',h_fig);
        plot(h_a,bins{v},cum_exp,'+b');
        hold(h_a,'on');
        plot(h_a,bins{v},cum_sim,'+r');
        hold(h_a,'off');
        ylim(h_a,lim_y);
        xlim(h_a,lim_x);

        lim_y = [min([cmpl_exp(cmpl_exp>0)',...
            cmpl_sim(cmpl_sim>0)']),...
            max([cmpl_exp(cmpl_exp>0)',...
            cmpl_sim(cmpl_sim>0)'])];

        h_a = subplot(2,V+1,V+1+v,'replace','parent',h_fig);
        plot(h_a,bins{v},cmpl_exp,'+b');
        hold(h_a,'on');
        plot(h_a,bins{v},cmpl_sim,'+r');
        hold(h_a,'off');
        set(h_a,'yscale','log');
        ylim(h_a,lim_y);
        xlim(h_a,lim_x);
        if v==1
            % plot relative FRET state populations
            h_a = subplot(2,V+1,V+1,'replace','parent',h_fig);
            b = bar(h_a,1:V,[popSim',popExp']);
            set(b(1),'facecolor','r');
            set(b(2),'facecolor','b');
            title(h_a,'state occupancy');
            
            % plot relative transition counts
            h_a = subplot(2,V+1,2*(V+1),'replace','parent',h_fig);
            b = bar(h_a,1:numel(Nsim),[Nsim',Nexp']);
            set(b(1),'facecolor','r');
            set(b(2),'facecolor','b');
            title(h_a,'transition count');
            set(h_a,'xticklabel',ylbl);
        end
        drawnow;
    end
end
res.cumdstrb = cumdstrb;
