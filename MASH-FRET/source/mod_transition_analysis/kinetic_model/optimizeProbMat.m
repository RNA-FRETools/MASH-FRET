function [tp_iter,tp_err,ip,simdat] = optimizeProbMat(states,expPrm,tp0,T)
% [tp,tp_err,ip,simdat] = optimizeProbMat(states,expPrm,tp0,T)
%
% Find the probability matrix that describes the input dwell time set
%
% states: [1-by-J] state values
% expPrm: experimental parameters used in simulation with fields:
%   expPrm.dt: [nDt-by-3] dwell times (seconds) and state indexes before and after transition
%   expPrm.Ls: [1-by-N] experimental trajectory lengths
%   expPrm.expT: binning time
%   expPrm.excl: (1) to exclude first and last dwell times of each sequence, (0) otherwise
% tp0: [J-by-J] matrix starting guess
% T: number of restart
% tp_iter: [J-by-J] best inferrence matrix
% tp_err: [J-by-J-by-2] negative and positive absolute mean deviation
% ip: [1-by-J] initial state probabilities
% simdat: structure containing probabilities calculated from simulated data
%	simdat.ip initial state probabilities
%	simdat.dt dwell times
%   simdat.k_exp transition rate coefficients
%   simdat.n_exp number of transitions
%   simdat.w_exp transition probabiltiies
%   simdat.tp_exp transition matrix

% default
tpmin = 1E-5; % minimum transition probability
plotIt = false;

% create figure for plot
if plotIt
   h_fig1 = figure('windowstyle','docked');
else
    h_fig1 = [];
end

% identify degenerated states
vals = unique(states);
V = numel(vals);
degen = cell(1,V);
for v = 1:V
    degen{v} = find(states==vals(v));
end

% build starting guess for transition probabilities
J = size(tp0,2);
if isempty(tp0)
    tp0 = zeros(J);
    tp0(~eye(J)) = rand(J)/10;
    tp0(~~eye(J)) = 1-sum(tp0,2);
end

% measure computation time
t = tic;

% build event matrix used in Baum-Welch algorithm
B0 = zeros(V,J);
for v = 1:V
    B0(v,degen{v}') = 1;
end

disp('infer kinetic model...');

tp_all = NaN(J,J,T);
ip_all = NaN(T,J);
gof_all = -Inf(1,T);
for restart = 1:T
    
    fprintf('restart %i/%i:\n',restart,T);
    
    % generate new random matrix
    if restart>1
        tp0 = rand(J);
        tp0(~~eye(J)) = 100*rand(1,J);
        tp0 = tp0./repmat(sum(tp0,2),[1,J]);
    end
    tp_iter = tp0;
    
    % recover matrix calculated from simulated data
    if restart==1
        plotKinMdlSim(degen,tp_iter,ones(1,J)/J,expPrm,h_fig1);
    else
        plotKinMdlSim(degen,tp_iter,ones(1,J)/J,expPrm,[]);
    end

    [tp_iter,B,ip,bestgof] = ...
        baumwelch(tp_iter,B0,expPrm.seq,1:V,ones(1,J)/J);
    if isnan(bestgof)
        continue
    end
    
    disp(tp_iter)
    
    if plotIt
        tp_sim = tp_iter;
        tp_sim(tp_sim<tpmin) = 0;
        plotKinMdlSim(degen,tp_sim,ip,expPrm,h_fig1);
    end
    
    % store best restart
    tp_all(:,:,restart) = tp_iter;
    ip_all(restart,:) = ip;
    gof_all(restart) = bestgof;
end

% get best fit
[bestgof,bestrestart] = max(gof_all);
tp_iter = tp_all(:,:,bestrestart);
ip = ip_all(bestrestart,:);
tp_sim = tp_iter;
tp_sim(tp_sim<tpmin) = 0;
simdat = plotKinMdlSim(degen,tp_sim,ip,expPrm,h_fig1);
simdat.tpmin = tpmin;

% calculate confidence interval for each coefficient (SMACKS)
disp('calculate confidence intervals...');
tp_err = calcRateConfIv(tp_iter,expPrm.seq,B,1:V,ip,bestgof);

% display best fit
disp(['best fit: ',num2str(bestgof)]);
disp(tp_iter);
disp(tp_err);

% display processing time
t_toc = toc(t);
disp(['total processing time: ',num2str(t_toc)]);


