function [x_res,bestOut,x_hat,z_hat,maxLP] = discr_vbFRET(Kmin,Kmax,nRS,...
    data,fig,islb,mute,D,varargin)
% [x_res,bestOut] = discr_vbFRET(Kmin,K,nRS,data,h_fig,lb,mute,D)
% [x_res,bestOut] = discr_vbFRET(Kmin,K,nRS,data,h_fig,lb,mute,D,initprm)
%
% This is a command line version of vbFRET which will anlayze the raw
% donor / acceptor data as a 2-dimensional gaussian. This script is very
% much still in the testing phase!
%
% The data must be raw 2-channel and stored in a cell array
% called 'data'. I would recommend scaling each trace to be mean 0,
% variance 1.
%
% Posterior parameters are stored in an NxK array called 'bestOut'
%
% Idealized trajectories are stored in an NxK array called 'x_hat'
%
% Idealized hidden state trajectories are stored in an NxK array called 
% 'z_hat' 
%
% Please direct any questions or comments to Jonathan Bronson
% (jeb2126@columbia.edu).
%
% May 2010 [1] 
%
% literature: J. E. Bronson, J. Fei, J. M. Hofman, R. L. Gonzalez Jr., 
% C. H. Wiggins, „Learning Rates and States from Biophysical Time Series: 
% A Bayesian Approach to Model Selection and Single-Molecule FRET Data“, 
% Biophysical Journal, Bd. 97, Nr. 12, S. 3196-3205, Dez. 2009.

% init output
x_res = {};
bestOut = [];

% collects starting guess for GMM parameters
startguess = ~isempty(varargin);
if startguess
    gmmprm0 = varargin{1};
end

% analyzeFRET program settings
PriorPar.upi = 1;
PriorPar.mu = 0*ones(D,1);
PriorPar.beta = 0.25;
PriorPar.W = 25*eye(D); % identity matrix * 25
PriorPar.v = 5.0;
PriorPar.ua = 1.0;
PriorPar.uad = 0;
% PriorPar.Wa_init = true;

% set the VBEM options
vb_opts.maxIter = 100; % max. nb. of VBEM iterations
vb_opts.threshold = 1e-5; % VBEM convergence threshold (should this be a function of the size of the data set??)
vb_opts.displayFig = 0; % display graphical analysis
vb_opts.displayNrg = 0; % display nrg after each iteration of forward-back
vb_opts.displayIter = 0; % display iteration number after each round of forward-back
vb_opts.DisplayItersToConverge = 0; % display number of steped needed for convergance
if startguess
    vb_opts.fixcenters = true;
else
    vb_opts.fixcenters = false;
end

% init best measures
N = numel(data);
% bestMix = cell(N,K);
bestOut = cell(N,Kmax); % posterior parameters of best restart
outF = -Inf*ones(N,Kmax); % GOF of best restart
best_idx = zeros(N,Kmax); % index of best restart

% run the VBEM algorithm
for n = 1:N 
    % make sure the data is in the right orientation
    if size(data{n},1)>size(data{n},2)
        trace = data{n}';
    else
        trace = data{n};
    end
    
    % init GOF to minimum
    maxLP = -Inf(1,Kmax);
    
    % init nb. of characters to erase from command window 
    nb = 0;
    
    % iterates through numbers of states
    for k = Kmin:Kmax
        ncentres = k;
        
        % iterates through restarts
        rs = 1;
        while rs<=nRS
            
            % quits after 3 restarts for 1 state
            if k==1 && rs>3
                break
            end

            % comment out the line below if you don't want to know what
            % trace vbFRET is currently working on
            if ~mute
                fprintf(['vbFRET: Working on inference',...
                    ' for restart %d, k%d of molecule %d...\n'],rs,k,n);
            end
            
            % initialize gaussian centers to be random between -1 and 1
            % in each dimension
            init_mu = 2*rand(ncentres,D)-1;
            
            % Initialize gaussians
            % Note: x and mix can be saved at this point andused for 
            % future experiments or for troubleshooting. try-catch 
            % needed because sometimes the K-means algorithm doesn't 
            % initialze and the program crashes otherwise when this 
            % happens.
            try
                mix = get_mix(trace',init_mu);
                if startguess
                    mix.priors = gmmprm0{k}.pop; % [1-by-k]
                    mix.centres = gmmprm0{k}.states'; % [1-by-k]
                end
                out = vbFRET_VBEM(trace,mix,PriorPar,vb_opts);
            catch err
                rs = rs+1;
                continue
            end

            % Only save the iterations with the best out.F
            if out.F(end)>maxLP(k)
                maxLP(k) = out.F(end);
                % bestMix{n,k} = mix;
                bestOut{n,k} = out;
                outF(n,k) = out.F(end);
                best_idx(n,k) = rs;
            end
            rs = rs+1;
            
            % update loading bar in MASH-FRET
            if ~isempty(fig) && islb &&  loading_bar('update',fig)
                return
            end
        end
    end
end

% analyze accuracy and get idealized data fits
if ~mute
    fprintf('vbFRET: Analyzing results...\n');
end
z_hat = cell(N,Kmax);
x_hat = cell(N,Kmax);
x_res = cell(size(data));
for n = 1:N
    for k = Kmin:Kmax
        if ~isempty(bestOut{n,k})
            [z_hat{n,k},x_hat{n,k}] = chmmViterbi(bestOut{n,k},trace);
        end
    end
    [~,best] = max(maxLP);
    if ~isempty(x_hat{n,best})
        x_res{n} = x_hat{n,best};
    else
        sz = size(data{n},2);
        x_res{n} = repmat(mean(data{n},2),sz,1);
    end
end
if ~mute
    fprintf('vbFRET: ...done w/ analysis\n');
end

