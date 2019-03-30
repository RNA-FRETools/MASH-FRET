function p = discrTraces(h_fig, mol, p)

% Last update: MH, 30.3.2019
% >> comment and reorganize code (no modification)

% collect project parameters
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
FRET = p.proj{proj}.FRET;   nFRET = size(FRET,1);
S = p.proj{proj}.S;         nS = size(S,1);

% check for already-discretized top traces
isDiscrTop = ~isempty(p.proj{proj}.intensities_DTA) && ...
    sum(sum(sum(double(~isnan(p.proj{proj}.intensities_DTA(:, ...
    ((mol-1)*nChan+1):mol*nChan,:))),1),2),3);

% check for already-discretized bottom traces
isDiscrBot = (~isempty(p.proj{proj}.FRET_DTA) && ...
    sum(sum(double(~isnan(p.proj{proj}.FRET_DTA(:, ...
    ((mol-1)*nFRET+1):mol*nFRET))),1),2)) || ...
    (~isempty(p.proj{proj}.S_DTA) && ...
    sum(sum(double(~isnan(p.proj{proj}.S_DTA(:, ...
    ((mol-1)*nS+1):mol*nS))),1),2));

% collect processing parameters
prm_DTA = p.proj{proj}.prm{mol}{4};
method = prm_DTA{1}(1);
toBottom = prm_DTA{1}(2); % discretize bottom(1)/top->bottom(0)/top+bottom(2)
calc = prm_DTA{1}(3);
gamma = p.proj{proj}.prm{mol}{5}{3};
    
if (toBottom && ~isDiscrBot) || ((~toBottom || toBottom == 2) && ...
        ~isDiscrTop)
    
    % collect corrected,smoothed and cut intensity-time traces
    incl = p.proj{proj}.bool_intensities(:,mol);
    I_den = p.proj{proj}.intensities_denoise(incl, ...
        ((mol-1)*nChan+1):mol*nChan,:);
    
    % initialize results
    top_dscrTr = nan(size(I_den));
    bot_dscrTr = nan(size(I_den,1),nFRET+nS);
    stateVal = nan(nFRET+nS+nExc*nChan,6);
    
    % discretize bottom traces
    if toBottom
        
        % calculate FRET-time traces
        FRET_tr = [];
        if nFRET > 0
            f_tr = calcFRET(nChan, nExc, exc, chanExc, FRET, I_den, gamma);
        end
        for f = 1:nFRET
            FRET_tr(f,:) = f_tr(:,f)';
        end
        
        % calculate stoichiometry-time traces
        S_tr = [];
        for s = 1:nS
            [o,exc_num,o] = find(exc==chanExc(S(s,1)));
            S_tr(s,:) = (sum(I_den(:,:,exc_num),2)./ ...
                sum((sum(I_den,2)),3))';
        end

        % ignore ratio data out-of-range
        incl_fret = FRET_tr>=-0.2 & FRET_tr<=1.2;
        incl_s = S_tr>=-0.2 & S_tr<=1.2;
%         incl_fret = true(size(FRET_tr));
%         incl_s = true(size(S_tr));
        incl_bot = [incl_fret;incl_s];
        
        % discretize traces
        prm = permute(prm_DTA{2}(method,:,1:nFRET+nS),[3,2,1]); % [m-by-6] matrix
        thresh = prm_DTA{4}(:,:,1:nFRET+nS); % [3-by-t-by-m] matrix
        bot_dscrTr = (getDiscr(method, [FRET_tr; S_tr], incl_bot, prm, thresh, ...
            calc, 'Discretisation of bottom traces...', h_fig))';
        
        % identify and sort resulting states
        for n = 1:(nFRET+nS)
            discrVal = (sort(unique(bot_dscrTr(:,n)), 'descend'))';
            n_state = numel(discrVal);
            stateVal(n,1:n_state) = discrVal;
        end
    end
    
    % discretize top traces
    if toBottom == 2 || ~toBottom
        
        % format intensity-time traces
        I_tr = [];
        for l = 1:nExc
            for c = 1:nChan
                I_tr = [I_tr; I_den(:,c,l)'];
            end
        end
        
        % discretize intensity-time traces
        prm = permute(prm_DTA{2}(method,:,nFRET+nS+1:end),[3,2,1]);
        tol = prm(1,4);
        thresh = prm_DTA{4}(:,:,nFRET+nS+1:end);
        top = (getDiscr(method, I_tr, [], prm, thresh, calc, ...
            'Discretisation of top traces...', h_fig))';
        
        % format resulting discretized traces
        for l = 1:nExc
            top_dscrTr(:,:,l) = top(:,((l-1)*nChan+1):l*nChan);
        end
        
        % identify and sort resulting states
        for l = 1:nExc
            for c = 1:nChan
                discrVal = (sort(unique(top_dscrTr(:,c,l)), 'descend'))';
                n_state = numel(discrVal);
                stateVal((nFRET+nS+(l-1)*nChan+c),1:n_state) = discrVal;
            end
        end
        
        % build bottom discretized traces
        if ~toBottom

            if nFRET > 0
                % calculate FRET-time traces
                f_tr = calcFRET(nChan, nExc, exc, chanExc, FRET, ...
                    I_den, gamma);
                
                % calculate discretized FRET-time traces from discretized
                % intensity-time traces
                f_st = calcFRET(nChan, nExc, exc, chanExc, FRET, ...
                    top_dscrTr, gamma);
            end
            
            % build discretized FRET-time traces
            for n = 1:nFRET
                
                % identify donor and acceptor discretized intensity-time 
                % traces
                don = FRET(n,1); acc = FRET(n,2);
                [o,l_f,o] = find(exc==chanExc(FRET(n,1)));
                Idon = top_dscrTr(:,don,l_f);
                Iacc = top_dscrTr(:,acc,l_f);
                
                % get changing points common to both discretized intensity-
                % time traces
                cp = get_cpFromDiscr([Idon Iacc]);
                cp = correl_cp(cp, tol);
                
                % modify discretized FRET-time trace preserving only those 
                % common changing points
                FRET_tr = f_tr(:,n);
                FRET_st{1} = f_st(:,n);
                bot_dscrTr(:,n) = get_discrFromCp(cp, FRET_tr, FRET_st);
                
                % identify and sort resulting states
                discrVal = (sort(unique(bot_dscrTr(:,n)), 'descend'))';
                n_state = numel(discrVal);
                stateVal(n,1:n_state) = discrVal;
            end
            
            % build discretized stoichiometry-time traces
            for n = (nFRET+1):(nFRET+nS)
                
                % calculate summed intensity-time traces at emitter-
                % specific illumination (num) and all illuminations (den)
                [o,num,o] = find(exc==chanExc(S(n-nFRET,1)));
                exc_num = sum(top_dscrTr(:,:,num),2);
                exc_den = sum(sum(top_dscrTr,2),3);
                
                % calculate stoichiometry-time traces
                S_tr = sum(I_den(:,:,num),2)./sum(sum(I_den,2),3);
                
                % calculate discretized stoichiometry-time traces from 
                % discretized intensity-time traces
                S_st{1} = exc_num./exc_den;
                
                % get changing points common to both discretized intensity-
                % time traces
                cp = get_cpFromDiscr([exc_num exc_den]);
                cp = correl_cp(cp, tol);

                % modify discretized stoichiometry-time trace preserving 
                % only  those common changing points
                bot_dscrTr(:,n) = get_discrFromCp(cp, S_tr, S_st);
                
                % identify and sort resulting states
                discrVal = (sort(unique(bot_dscrTr(:,n)), 'descend'))';
                n_state = numel(discrVal);
                stateVal(n,1:n_state) = discrVal;
            end
        end
    end

    % save discretized intensity-time traces
    p.proj{proj}.intensities_DTA(incl,((mol-1)*nChan+1):mol*nChan,:) = ...
        top_dscrTr;
    p.proj{proj}.intensities_DTA(~incl,((mol-1)*nChan+1):mol*nChan,:) = NaN;
    
    % save discretized FRET-time traces
    if ~isempty(FRET)
        p.proj{proj}.FRET_DTA(incl,((mol-1)*nFRET+1):mol*nFRET,:) = ...
            bot_dscrTr(:,1:nFRET);
        p.proj{proj}.FRET_DTA(~incl,((mol-1)*nFRET+1):mol*nFRET,:) = NaN;
    end
    
    % save discretized stoichiometry-time traces
    if ~isempty(S)
        p.proj{proj}.S_DTA(incl,((mol-1)*nS+1):mol*nS,:) = ...
            bot_dscrTr(:,(nFRET+1):(nFRET+nS));
        p.proj{proj}.S_DTA(~incl,((mol-1)*nS+1):mol*nS,:) = NaN;
    end
    
    % save resulting states
    p.proj{proj}.prm{mol}{4}{3} = stateVal;
end


