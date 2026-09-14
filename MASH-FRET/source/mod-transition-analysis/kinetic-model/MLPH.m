function [opt,mdl,reftp,refcan] = MLPH(dt,PHtype,T,dlmin,dpmin,mmax,Dmin,...
    Dmax,calc,applyrules,reftp,refcan,verbose)
% [opt,mdl,reftp,refcan] = MLPH(dt,PHtype,T,dlmin,Dmin,Dmax,calc,applyrules,reftp,refcan)
%
% Perform ML-PH analysis.
%
% dt: [nDat-by-2] dwell times, count
% PHtype: 1 for discrete distribution, 2 for continuous
% T: number of ML-PH restarts (random model initializations).
% dlmin: convergence criterion on log-likelihood ratio
% dpmin: convergence criterion on parameters
% mmax: maximum nb of EM iterations
% Dmin: minimum number of degenerate states (aggregate sample size).
% Dmax: maximum number of degenerate states (aggregate sample size).
% calc: 0: test canonical connectivities (+10 for searching for min. 
%          complexity),
%       1: test all connectivities (+10 for searching for min. complexity),
%       2: test "uncoupled" and "irreversible loop" connectivities (+10 for
%          searching for min. complexity),
%       3: test "uncoupled" connectivity (+10 for searching for min. 
%          complexity)
%       4: test "coupled"  (+10 for searching for min. complexity),
%       5: test "uncoupled" and "generalized coxian" connectivity  (+10 for
%          searching for min. complexity).
%       6: test "acyclic" connectivity  (+10 for searching for min. 
%          complexity).
%       7: test "acyclic" connectivity with different state initiations.
% applyrules: apply additional selection rules on inferred model 
%             (distribution validity and state doublons)
% reftp: {1-by-Dbig}{1-by-nbig}[D+2-by-D+2-by-Stp] already calculated 
%        transition schemes for transition probabilities only
% refcan: {1-by-D_big}[D+2-by-D+2-by-Scan] already-calculated canonical 
%         schemes.
% verbose: true to show logs, false to mute
% opt: {1-by-S}[Ds+2-by-Ds+2] transition schemes ordered by ascendent BIC 
%      where 0 and 1 stand for forbidden and allowed transitions 
%      respectively, and where first and last rows/columns are transitions 
%      from/to absorbing states.
% mdl: [S-by-1] structure containing PH fit parameters for all tested 
%       transition schemes ordered by ascendent BIC
%   mdl(s).cvg: 1 if ML-PH converged to a coherent model, 0 otherwise
%   mdl(s).pi_fit: [1-by-Ds] starting probabilities in the absorbing
%                  Markov chain
%   mdl(s).tp_fit: [Ds-by-Ds+1] transition probabilities in the absorbing
%                  Markov chain, where the last column contains absorbing
%                  probabilities.
%   mdl(s).logL: log likelihood
%   mdl(s).BIC: Bayesian information cirterion
%   mdl(s).N: number of dwell times
%   mdl(s).schm: [Ds+2-by-Ds+2] transition scheme that was fit, where 0 
%               and 1 stand for forbidden and allowed transitions  
%               respectively, and where first and last rows/columns are  
%               transitions from/to absorbing states.
%   mdl(s).PHtype: 1 for discrete distribution, 2 for continuous

% defaults
tpmin = 1E-5;
schmstr{1} = [];
schmstr{2} = {'uncoupled','irreversible loop'};
schmstr{3} = {'uncoupled'};
schmstr{4} = {'coupled'};
schmstr{5} = {'generalized coxian'};
schmstr{6} = {'acyclic'};
schmstr{7} = [];

% init output
mdl = [];
opt = {};

% ML-PH inference
BIC_all = [];
nb = zeros(1,3);
for D = Dmin:Dmax
    if isequal(mmax,'auto')
        mmax_D = 10^(D+1);
    else
        mmax_D = mmax;
    end
    if verbose
        nb(1) = dispProgress(sprintf('for D %i/%i',D,Dmax),sum(nb));
    end

    % collects uncouple dand irreversible loop transition schemes
    switch calc
        case {0,10} % canoncial schemes
            [MD,refcan,reftp] = PHschm_canon(D,PHtype,refcan,reftp);
        case {1,11} % all connectivities
            MD = [];
            for nfp = D:(D*(D+1)-1)
                [Mnfp,reftp] = PHschm_nfp(nfp,false,D,D,reftp);
                for s = 1:numel(Mnfp)
                    MD = cat(3,MD,Mnfp{s});
                end
            end
        case {2,12} % "uncoupled" and "irrloop"
            MD = buildstransscheme(D,'uncoupled');
            if D>1
                MD = cat(3,MD,buildstransscheme(D,'irrloop'));
            end
        case {3,13} % "uncoupled"
            MD = buildstransscheme(D,'uncoupled');
        case {4,14} % "coupled"
            MD = buildstransscheme(D,'coupled');
        case {5,15} % "generalized coxian"
            MD = buildstransscheme(D,'generalized coxian');
        case {6,16} % "acyclic"
            MD = buildstransscheme(D,'acyclic');
        case 7 % "acyclic" with different state initiation
            MD = buildstransscheme(D,'acyclic initiation');
        otherwise
            if verbose
                disp(['MLPH: Process aborted >> input 4 must be an integer',...
                    ' between 0 and 7 or between 10 and 16.']);
            end
            return
    end

    % test schemes one after the other
    S = size(MD,3);
    nb([2,3]) = 0;
    for s = 1:S
        if any(calc==[0,1,7,10,11]) && verbose
            nb(2) = dispProgress(sprintf(', scheme %i/%i:',s,S),...
                sum(nb(2:3)));
        else
            strid = calc;
            if strid>=10
                strid = calc-10;
            end
            if verbose
                nb(2) = dispProgress(...
                    sprintf([', scheme ',schmstr{strid}{s},':']),sum(nb(2:3)));
            end
        end
        
        nb(3) = 0;
        if calc>=10
            % iteratively search for minimal transition scheme
            M = MD(:,:,s);
            iter = 1;
            prob = ones(D+2,D+2);
            while iter==1 || any(prob(M)<tpmin)
                % define new constraints on reaction scheme
                M = M & prob>=tpmin;
                
                % check for kinetic trap
                if any(all(~M(1:end-1,2:end),2))
                    break
                end
                
                % run MLPH
                if verbose
                    nb(3) = ...
                        dispProgress(sprintf(' search iter %i:',iter),nb(3));
                end
                [mdl_s,nb4] = script_inferPH(dt,PHtype,T,dlmin,dpmin,...
                    mmax_D,M,'',verbose);
                nb(3) = nb(3)+nb4;
                prob = [[0,mdl_s.pi_fit,0];[zeros(D,1),mdl_s.tp_fit];...
                    zeros(1,D+2)];

                % check for model divergence
                if applyrules
                    mdl_s.cvg = ...
                        isphvalid(mdl_s.tp_fit,mdl_s.pi_fit,PHtype) & ...
                        ~isdoublon(mdl_s.tp_fit);
                end
                iter = iter+1;
            end
        else
            [mdl_s,nb(3)] = script_inferPH(dt,PHtype,T,dlmin,dpmin,mmax_D,...
                MD(:,:,s),'',verbose);
        end

        % calculate BIC
        mdl_s.BIC = calcBIC(mdl_s);
        
        % check model divergence
        if applyrules
            mdl_s.cvg = isphvalid(mdl_s.tp_fit,mdl_s.pi_fit,mdl_s.PHtype) ...
                & ~isdoublon(mdl_s.tp_fit);
        end

        % append results
        mdl = cat(1,mdl,mdl_s);
        BIC_all = cat(2,BIC_all,mdl_s.BIC);
    end
end

% model selection
[~,ord] = sort(BIC_all);
mdl = mdl(ord,1);
for j = 1:size(mdl,1)
    if mdl(j).BIC<Inf
        opt = cat(2,opt,mdl(j).schm);
    end
end

% terminate action
if verbose
    fprintf('\n');
end

