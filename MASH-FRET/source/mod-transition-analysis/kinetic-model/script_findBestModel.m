function [D,mdlopt,mdl,dthist] = script_findBestModel(dt,PHtype,Dmin,Dmax,...
    states,rate,bin,R,dlmin,dpmin,mmax,savecurve,calcmode,applyrules,...
    verbose)
% [D,mdlopt,mdl] = script_findBestModel(dt,PHtype,Dmin,Dmax,states,rate,bin,R,dlmin,savecurve,calcmode)
%
% Import dwell times from .clst file
% Find and return most sufficient model complexities (in terms of number of degenerated levels) for each state value
% Plot PH fits and BIC results
%
% dt: [nDt-by-(3 or 4)] dwell times (s), state values, counts
% PHtype: 1 for discrete distribution, 2 for continuous
% Dmin: [1-by-V] minimum number of degenerated levels
% Dmax: [1-by-V] maximum number of degenerated levels
% states: [1-by-V] state values in dt
% rate: time sampling rate (s-1)
% bin: binning factor for dwell times prior building histogram
% R: number of successful PH initializations
% dlmin: convergence criterion on log-likelihood ratio
% dpmin: convergence criterion on parameters
% mmax: maximum nb of EM iterations
% savecurve: empty or destination folder to save best fit curves
% calcmode: 0: test canonical connectivities (+10 for searching for min. 
%              complexity),
%           1: test all connectivities (+10 for searching for min. 
%              complexity),
%           2: test "uncoupled" and "irreversible loop" connectivities (+10
%              for searching for min. complexity),
%           3: test "uncoupled" connectivity (+10 for searching for min. 
%              complexity)
%           4: test "coupled"  (+10 for searching for min. complexity),
%           5: test "uncoupled" and "generalized coxian" connectivity  (+10
%              for searching for min. complexity).
%           6: test "acyclic" connectivity  (+10 for searching for min. 
%              complexity).
%           7: test "acyclic" connectivity with different state 
%              initiations.
% applyrules: apply additional selection rules on inferred model 
%             (distribution validity and state doublons)
% verbose: true to show logs, false to mute
% D: [1-by-V] most sufficient model complexity (number of degenerated 
%  levels per state value)
% mdlopt: [V-by-1] structure array containing best PH fit parameters for 
%         the most sufficient model
%   mdlopt.pi_fit: {1-by-V} starting probabilities
%   mdlopt.tp_fit: {1-by-V} transition probabilities among degenerated 
%                  states of a same state value
%   mdlopt.logL: {1-by-V} log likelihoods for best fits
%   mdlopt.N: [1-by-V] number of data
%   mdlopt.schm: {1-by-V} transition schemes
%   mdlopt.PHtype: 1 for discrete distribution, 2 for continuous
%   mdlopt.t_dphtest: computation time
% mdl: {V-by-1}[S-by-1] structure array containing PH fit parameters 
%      for model qualifications
% dthist: {1-by-V} dwell time histograms

% defaults
reffle = 'ref-table-schemes.mat'; % source file containing all transition schemes
logbin = false;

% initialize reference schemes
schmD = {};
schm_tp = {};
schm_can = {};
ref.schmD = {};
ref.schm_tp = {};
ref.schm_can = {};

% load already calculated transitions schemes
src = fileparts(mfilename('fullpath'));
reffle = [src,filesep,reffle];
if exist(reffle,'file')
    ref = load(reffle);
    if isfield(ref,'schmD')
        schmD = ref.schmD;
    end
    if isfield(ref,'schm_tp')
        schm_tp = ref.schm_tp;
    end
    if isfield(ref,'schm_can')
        schm_can = ref.schm_can;
    end
end

% initialize computation time
t_comp = tic;

% get dwell time histograms
V = numel(states);
dthist = cell(1,V);
dthist_bin = cell(1,V);
for v = 1:V
    dt_v = dt(dt(:,3)==v,:);
    if isempty(dt_v)
        continue
    end
    dt_v(:,1) = dt_v(:,1)*rate;

    if ~logbin % time, state1, state2, val1, val2
        edg = 0.5:(max(dt_v(:,1))+1.5); % [edg1,edg2[
        x = mean([edg(1:end-1);edg(2:end)]);
        if PHtype==1 % DPH
            x = floor(x);
        end
        P = histcounts(dt_v(:,1),edg);
        dthist{v} = [x',P'];

    else % time, state1, state2, val1, val2
        maxexponent = log10(max(dt_v(:,1))+1);
        exponent = 0:0.01:maxexponent;
        if exponent(end)<maxexponent
            exponent = cat(2,exponent,exponent(end)+0.2);
        end
        edg = 10.^exponent; % [edg1,edg2[
        if PHtype==1 % DPH
            edg = unique(floor(edg));
        end
        x1 = edg(1:end-1);
        x2 = edg(2:end);
        P = histcounts(dt_v(:,1),edg);
        dthist{v} = [x1',x2',P'];
    end
    
    % binned dwell time histogram
    if ~logbin && bin~=1
        edg = 0.5:bin:(max(dt_v(:,1))+bin+0.5);
        x = mean([edg(2:end)-1;edg(1:end-1)],1);
        if PHtype==1 % DPH
            x = floor(x);
        end
        P = histcounts(dt_v(:,1),edg);
        dthist_bin{v} = [x',P'];
    else
        dthist_bin{v} = dthist{v};
    end

    dthist{v} = dthist{v}(dthist{v}(:,end)>0,:);
    dthist_bin{v} = dthist_bin{v}(dthist_bin{v}(:,end)>0,:);
end

% Perorm ML-PH
if  verbose
    fprintf('Perform ML-PH on binned dwelltime histograms...\n');
end
mdl = cell(1,V);
schm_opt = cell(1,V);
for v = 1:V
    if verbose
        fprintf('>> for state %i/%i: ',v,V);
    end
    [schm_opt{v},mdl{v},schm_tp,schm_can] = MLPH(dthist_bin{v},PHtype,R,...
        dlmin,dpmin,mmax,Dmin(v),Dmax(v),calcmode,applyrules,schm_tp,...
        schm_can,verbose);
end

% append reference file
if ~isequal(schmD,ref.schmD) || ~isequal(schm_tp,ref.schm_tp) || ...
        ~isequal(schm_can,ref.schm_can)
    save(reffle,'schmD','schm_tp','schm_can','-mat');
end

% validate best fit
mdlopt.pi_fit = cell(1,V);
mdlopt.tp_fit = cell(1,V);
mdlopt.schm = cell(1,V);
mdlopt.logL = zeros(1,V);
mdlopt.N = zeros(1,V);
mdlopt.BIC = zeros(1,V);
if bin~=1 && verbose
    fprintf('Test best fit on authentic dwell time histograms...\n');
end
for v = 1:V
    cvg = false;
    best = 0;
    while best<numel(schm_opt{v}) && ~cvg
        best = best+1;
        D_v = size(schm_opt{v}{best},1)-2;
        if bin~=1
            if ~isempty(savecurve)
                ffile = [savecurve,...
                    sprintf('_ph_state%iD%i_phplot',v,D_v)];
            else
                ffile = [];
            end
            if isequal(mmax,'auto')
                mmax_v = 10^(D_v+1);
            else
                mmax_v = mmax;
            end
            mdl_v = script_inferPH(dthist{v},PHtype,R,dlmin,dpmin,mmax_v,...
                schm_opt{v}{best},ffile,false);
            if applyrules
                cvg = isphvalid(mdl_v.tp_fit,mdl_v.pi_fit,PHtype) && ...
                    ~isdoublon(mdl_v.tp_fit);
            else
                cvg = mdl_v.cvg;
            end
            if ~cvg
                if exist(ffile,'file')
                    delete(ffile);
                end
                mdl{v}(best).cvg = false;
%                 mdl{v}(best).BIC = Inf;
            end
        else
            mdl_v = mdl{v}(best);
            cvg = mdl{v}(best).cvg;
        end
    end
    if cvg
        mdlopt.pi_fit{v} = mdl_v.pi_fit;
        mdlopt.tp_fit{v} = mdl_v.tp_fit;
        mdlopt.schm{v} = mdl_v.schm;
        mdlopt.logL(v) = mdl_v.logL;
        mdlopt.N(v) = mdl_v.N;
        mdlopt.BIC(v) = calcBIC(mdl_v);
    end
end

% show most sufficient state configuration
id = [];
D = zeros(1,V);
for v = 1:V
    D(v) = size(mdlopt.schm{v},1)-2;
    id = cat(2,id,repmat(v,[1,D(v)]));
end
if verbose
    fprintf(['Most sufficient state configuration: [%0.2f',...
        repmat(',%0.2f',[1,numel(states(id))-1]),'] found in %0.0f seconds\n'],...
        states(id),toc(t_comp));
end

% save computation time
mdlopt.PHtype = PHtype;
mdlopt.t_dphtest = toc(t_comp);
