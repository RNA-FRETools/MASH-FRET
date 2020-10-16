function [mat_iter,mat_err,simdat] = optimizeProbMat(r,states,expPrm,opt,mat0)
% [mat,mat_err,simdat] = optimizeProbMat(r,states,expPrm,opt,mat0)
%
% Find the probability matrix that describes the input dwell time set
%
% r: [1-by-J] restricted rate matrix (second-1)
% states: [1-by-J] state values
% expPrm: experimental parameters used in simulation with fields:
%   expPrm.dt: [nDt-by-3] dwell times (seconds) and state indexes before and after transition
%   expPrm.A: [1-by-K] relative contributions of degenerated states in dwell time histograms
%   expPrm.Ls: [1-by-N] experimental trajectory lengths
%   expPrm.expT: binning time
%   expPrm.fitPrm: fitting parameters
%   expPrm.excl: (1) to exclude first and last dwell times of each sequence, (0) otherwise
%   expPrm.clstPop: [V-by-V] TDP cluster relative populations
% opt: 'n','w' or 'tp' to optimize the matrix of number of transitions (fixed restricted rates), the repartition probability matrix (fixed restricted rates) or the transition probability matrix respectively
% mat0: [J-by-J] matrix starting guess
% mat: [J-by-J] best inferrence matrix
% mat_err: [J-by-J-by-2] negative and positive absolute mean deviation
% simdat: structure containing simulated data with fields:
%  simdat.dt: [nDt-by-4] dwell times (molecule index, state durations (frames), state values before and after transition)
%  simdat.tp_exp: [J-by-J] transition probability matrix calculated from simulated data
%  simdat.r_exp: [J-by-J] restricted rate matrix calculated from simulated data
%  simdat.w_exp: [J-by-J] weighing factors calculated from simulated data

% default
T = 5; % number of matrix initialization
nSpl = 3; % number of simulated data set used in error calculation
varsteps = 1./logspace(0,2,5); % variation step (relative)
plotIt = true;

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
J = size(r,2);
if isempty(mat0)
    switch opt
        case 'w' % diagonal terms = 0
            mat0 = double(~eye(J));
            mat0 = mat0./repmat(sum(mat0,2),[1,J]);
        case 'tp' % diagonal terms > 0
            mat0 = zeros(J);
            mat0(~~eye(J)) = exp(-expPrm.expT*r);
            for j1 = 1:J
                j2s = true(1,J);
                j2s(j1) = false;
                mat0(j1,j2s) = (1-mat0(j1,j1))/(J-1);
            end
    end
end

if strcmp(opt,'n') || strcmp(opt,'k')
    % identify which number of transitions are fixed
    expPrm.isFixed = false(J);
    expPrm.isFixed(~~eye(J)) = true; % diagonal terms
    for j1 = 1:J
        if sum(states==states(j1))==1 % no degenerated states
            expPrm.isFixed(:,j1) = true;
            continue
        end
        v1 = find(vals==states(j1));
        for j2 = 1:J
            v2 = find(vals==states(j2));
            if expPrm.clstPop(v1,v2)==0 % no density in TDP
                expPrm.isFixed(v1,v2) = true;
            end
        end
    end

    % calculates and associates fixed sums
    expPrm.sumConstr = cell(J);
    degenTrans = false(J);
    for v = 1:V
        degenTrans(degen{v}(1):degen{v}(end),degen{v}(1):degen{v}(end)) = ...
            true;
    end
    for j1 = 1:J
        for j2 = 1:J
            expPrm.sumConstr{j1,j2} = zeros(J);
            if j1==j2
                continue
            end

            if states(j1)==states(j2) % transition between states of same value
                j_lvl = find(states==states(j1));
                j_lvl1 = min(j_lvl);
                j_lvl2 = max(j_lvl);
                nLvl = numel(j_lvl);
                sumDegen = Inf(nLvl); % no restriction on sum (=Inf)
                sumDegen(~~eye(nLvl)) = 0;
                expPrm.sumConstr{j1,j2}(j_lvl1:j_lvl2,j_lvl1:j_lvl2) = ...
                    sumDegen;
            else % transition between states of different values
                j_lvl = find(states==states(j2));
                j_lvl1 = min(j_lvl);
                j_lvl2 = max(j_lvl);
                expPrm.sumConstr{j1,j2}(j1,j_lvl1:j_lvl2) = ...
                    sum(mat0(j1,j_lvl1:j_lvl2));
                expPrm.sumConstr{j1,j2}(~degenTrans(:,j2),j2) = ...
                    sum(mat0(~degenTrans(:,j2),j2));
            end

            expPrm.sumConstr{j1,j2}(j1,j2) = 0;
        end
    end
    Ntot = sum(sum(mat0));
    
    if strcmp(opt,'n')
        % convert variation step into number of transitions
        varsteps = round([Ntot,varsteps*Ntot/10,1]);
    else
        varsteps = varsteps/100;
    end
elseif strcmp(opt,'tp')
    varsteps = varsteps/100;
end
varsteps(varsteps==0) = [];
varsteps = sort(unique(varsteps),'descend');

% start probability variation, data simulation and data comparison cycles
t = tic;

ncycle = size(varsteps,2);
mat_all = cell(1,T);
gof_all = -Inf(1,T);
nCycle = 0;
for restart = 1:T
    
    % generate new random matrix
    if restart>1
        if strcmp(opt,'w')
            mat0 = rand(J);
            mat0(~~eye(J)) = 0;
            mat0 = mat0./repmat(sum(mat0,2),[1,J]);
        elseif strcmp(opt,'tp')
            diagTerms = mat0(~~eye(size(mat0)));
            mat0 = rand(J);
            mat0(~~eye(J)) = 0;
            mat0 = repmat(...
                (1-diagTerms),[1,J]).*mat0./repmat(sum(mat0,2),[1,J]);
            mat0(~~eye(J)) = diagTerms;
        elseif strcmp(opt,'n') || strcmp(opt,'k')
            % generate random number of transitions between same state values
            for v = 1:V
                mat0(degen{v}(1):degen{v}(end),degen{v}(1):degen{v}(end)) = ...
                    rand(size(mat0(degen{v}(1):degen{v}(end),...
                    degen{v}(1):degen{v}(end))))*Ntot;
            end
            mat0(~~eye(J)) = 0;
            % generate random repartition for transition from a degenerated level
            for v1 = 1:V
                if numel(degen{v1})<=1
                    continue
                end
                for j1 = degen{v1}'
                    for v2 = 1:V
                        if v2==v1 || numel(degen{v2})<=1
                            continue
                        end
                        factrep = rand(1,numel(degen{v2}));
                        cnstr = ~~expPrm.sumConstr{j1,degen{v2}(1)}(j1,:);
                        rowSum = unique(...
                            expPrm.sumConstr{j1,degen{v2}(1)}(j1,cnstr));
                        mat0(j1,degen{v2}') = rowSum*factrep/sum(factrep);
                    end
                end
            end
        end
    end
    mat_iter = mat0;
    gof_prev = -Inf;
    bestgof = -Inf;
    bestgof_prev = -Inf;
    
    % recover matrix calculated from simulated data
    if restart==1
        [gof_iter,simdat] = kinMdlGOF(degen,mat_iter,r,expPrm,opt,h_fig1);
        disp(['>> start: ',num2str(gof_iter)]);
    else
        [gof_iter,simdat] = kinMdlGOF(degen,mat_iter,r,expPrm,opt,[]);
        disp(['>> restart: ',num2str(restart),' ...']);
    end
    switch opt
        case 'w'
            mat_iter = simdat.w_exp;
        case 'tp'
            mat_iter = simdat.tp_exp;
        case 'n'
            mat_iter = simdat.n_exp;
        case 'k'
            mat_iter = simdat.k_exp;
    end
    disp(mat_iter);

    % repeat all variation steps while GOF is increasing
    while isinf(bestgof) || bestgof>bestgof_prev
        
        nCycle = nCycle+1;

        mat = cell(1,ncycle);
        gof = -Inf(1,ncycle);

        bestgof_prev = bestgof;
        mat_iter_prev = mat_iter;

        % loop through variation steps
        for cycle = 1:ncycle
            
            disp(['variation step: ',num2str(varsteps(cycle))]);

            % increment matrix elements while GOF is increasing
            while isinf(gof_prev) || gof_iter>gof_prev

                gof_prev = gof_iter;
                mat_prev = mat_iter;

                % vary matrix elements one after the other
                [mat_iter,gof_iter] = varyTransMat(mat_iter,gof_iter,1:J,...
                    degen,varsteps(cycle),r,expPrm,opt,[]);

                if gof_iter>gof_prev
                    if gof_iter>=max(gof) && gof_iter>=bestgof && ...
                            gof_iter>=max(gof_all)
                        % display best fit's matrix
                        disp(['>> improvement: ',num2str(gof_iter)]);
                        disp(mat_iter);

                        % plot best fit's simlated data
                        if plotIt
                            kinMdlGOF(degen,mat_iter,r,expPrm,opt,h_fig1);
                        end
                    end
                else
                    if isinf(gof_iter) || isequal(mat_iter,mat_prev)
                        break
                    end
                    gof_iter = gof_prev;
                    mat_iter = mat_prev;
                end
            end
            
            % store best iteration for variation step
            gof(cycle) = gof_iter;
            mat{cycle} = mat_iter;
            gof_iter = -Inf;
            gof_prev = -Inf;
        end
        
        % store best variation step cycle
        [bestgof,bestcycle] = max(gof);
        mat_iter = mat{bestcycle};
        if bestgof<=bestgof_prev
            bestgof = bestgof_prev;
            mat_iter = mat_iter_prev;
        end
    end
    
    % store best restart
    mat_all{restart} = mat_iter;
    gof_all(restart) = bestgof;
end

% get best fit
[bestgof,bestrestart] = max(gof_all);
mat_iter = mat_all{bestrestart};

% calculate mean and deviation on 3 simulated data sets
mat_spl = zeros(J,J,nSpl);
s = 0;
while s<nSpl
    [gof,simdat] = kinMdlGOF(degen,mat_iter,r,expPrm,opt,[]);
    if ~isstruct(simdat)
        continue
    else
        s = s+1;
    end
    switch opt
        case 'w'
            mat_spl(:,:,s) = simdat.w_exp;
        case 'tp'
            mat_spl(:,:,s) = simdat.tp_exp;
        case 'n'
            mat_spl(:,:,s) = simdat.n_exp;
        case 'k'
            mat_spl(:,:,s) = simdat.k_exp;
    end
end
mat_iter = mean(mat_spl,3);
mat_err = std(mat_spl,[],3);

% display best fit
disp(['best fit: ',num2str(bestgof)]);
disp(mat_iter);
disp(mat_err);

% display processing time
t_toc = toc(t);
disp(['total processing time: ',num2str(t_toc)]);
disp(['number of iterations: ' num2str(nCycle)])
disp(['processing time per cycle: ',num2str(t_toc/nCycle)]);


