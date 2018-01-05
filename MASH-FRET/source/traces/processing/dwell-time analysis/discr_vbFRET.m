function [x_res, bestOut] = discr_vbFRET(kmin, K, I, data, h_fig, lb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%
    % parameter settings
    %%%%%%%%%%%%%%%%%%%%%
    
    x_res = [];
    bestOut = [];

    % analyze data in 1D or 2D
    D = 1;
    
    for i = 1:size(data,2)
        if size(data{1},2) == 2
            data2{i} = data{i}(:,2) ./ (data{i}(:,2) + data{i}(:,1));
        else
            data2{i} = data{i};
        end
    end
    data = data2;
    
    % number of Donor + Aceptor traces in input
    N = length(data);

    % analyzeFRET program settings
      PriorPar.upi = 1;
      PriorPar.mu = 0*ones(D,1);
      PriorPar.beta = 0.25;
      PriorPar.W = 25*eye(D); % identity matrix * 25
      PriorPar.v = 5.0;
      PriorPar.ua = 1.0;
      PriorPar.uad = 0;
    %PriorPar.Wa_init = true;


    % set the vb_opts for VBEM
    % stop after vb_opts iterations if program has not yet converged
      vb_opts.maxIter = 100;
    % question: should this be a function of the size of the data set??
      vb_opts.threshold = 1e-5;
    % display graphical analysis
      vb_opts.displayFig = 0;
    % display nrg after each iteration of forward-back
      vb_opts.displayNrg = 0;
    % display iteration number after each round of forward-back
      vb_opts.displayIter = 0;
    % display number of steped needed for convergance
      vb_opts.DisplayItersToConverge = 0;


    % bestMix = cell(N,K);
      bestOut=cell(N,K);
      outF=-inf*ones(N,K);
      best_idx=zeros(N,K);

    %%%%%%%%%%%%%%%%%%%%%%%%
    %run the VBEM algorithm
    %%%%%%%%%%%%%%%%%%%%%%%%
    for n=1:N % --> for each FRET trace
        % make sure the data is in the right orientation
        if size(data{n},1) > size(data{n},2)
            trace = data{n}';
        else
            trace = data{n};
        end

        for k = kmin:K % for each FRET state
            ncentres = k;
            i = 1; % iteration number
            maxLP(k) = -Inf;
            while i < I+1
                if K == 1 && i > 3
                    break
                end
                % initialize gaussian centerest to be randomly between
                % -1 and 1 in each dimension
                init_mu = 2*rand(ncentres,D)-1;

                clear mix out;
                % comment out the line below if you don't want to know what
                % trace vbFRET is currently working on
                disp(sprintf( ...
                    ['Working on inference for restart %d, k%d of ' ...
                    'trace %d...'], i, k, n));
                % Initialize gaussians
                % Note: x and mix can be saved at this point andused for 
                % future experiments or for troubleshooting. try-catch 
                % needed because sometimes the K-means algorithm doesn't 
                % initialze and the program crashes otherwise when this 
                % happens.
                try
                    [mix] = get_mix(trace',init_mu);
                    [out] = vbFRET_VBEM(trace, mix, PriorPar, vb_opts);
                catch
                    disp('There was an error during, repeating restart.');
                    runError=lasterror;
                    disp(runError.message)
                    i = i+1;
                    continue
                end

                % Only save the iterations with the best out.F
                if out.F(end) > maxLP(k)
                    maxLP(k) = out.F(end);
                    % bestMix{n,k} = mix;
                    bestOut{n,k} = out;
                    outF(n,k)=out.F(end);
                    best_idx(n,k) = i;
                end
                i = i+1;
                
                if lb
                    intrpt = loading_bar('update', h_fig);
                    if intrpt
                        return;
                    end
                end
            end
        end
       % save results
       % save(save_name);           

    end % for n=1:N

    %%%%%%%%%%%%%%%%%%%%%%%% VBHMM postprocessing %%%%%%%%%%%%%%%%%%%%%%%%%

    % analyze accuracy and save analysis
    disp('Analyzing results...')

%    save(save_name);          

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get idealized data fits
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    z_hat=cell(N,K);
    x_hat=cell(N,K);
    for n = 1:N
        if size(data{n},1) > size(data{n},2)
            trace = data{n}';
        else
            trace = data{n};
        end

        for k = kmin:K
            if ~isempty(bestOut{n,k})
                [z_hat{n,k} x_hat{n,k}] = chmmViterbi(bestOut{n,k},trace);
            end
        end
        [o, best] = max(maxLP);
        if ~isempty(x_hat{n,best})
            x_res(n,:) = x_hat{n,best};
        else
            x_res(n,:) = ones(size(data{n}))*mean(data{n});
        end
    end

    disp('...done w/ analysis');

