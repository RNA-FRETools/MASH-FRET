function p = discrTraces(h_fig, m, p)

% Last update: MH, 3.4.2019
% >> correct source parameter for tolerance window used to identify common
%    transitions in top traces
%
% Last update: MH, 30.3.2019
% >> comment and reorganize code (no modification)

% collect interface parameters
h = guidata(h_fig);
mute = h.mute_actions;

% collect project parameters
proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
FRET = p.proj{proj}.FRET;   nF = size(FRET,1);
S = p.proj{proj}.S;         nS = size(S,1);

% check for already-discretized top traces
isDiscrTop = ~isempty(p.proj{proj}.intensities_DTA) && ~all(isnan(sum(sum(...
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:),3),2)));

% check for already-discretized bottom traces
isDiscrBot = ~isempty(p.proj{proj}.FRET_DTA) && ...
    ~all(isnan(sum(p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF),2))) && ...
    ~isempty(p.proj{proj}.S_DTA) && ...
    ~all(isnan(sum(p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS),2)));

% collect processing parameters
prm_DTA = p.proj{proj}.prm{m}{4};
method = prm_DTA{1}(1);
toBottom = prm_DTA{1}(2); % discretize bottom(1)/top->bottom(0)/top+bottom(2)
calc = prm_DTA{1}(3);
if nF>0
    gamma = p.proj{proj}.prm{m}{6}{1}(1,:);
    if nS>0
        beta = p.proj{proj}.prm{m}{6}{1}(2,:);
    end
end
    
if ~((toBottom && ~isDiscrBot) || ((~toBottom || toBottom == 2) && ...
        ~isDiscrTop))
    return
end
    
% collect corrected,smoothed and cut intensity-time traces
incl = p.proj{proj}.bool_intensities(:,m);
I_den = p.proj{proj}.intensities_denoise(incl,((m-1)*nC+1):m*nC,:);

% initialize results
top_DTA = nan(size(I_den));
bot_DTA = nan(size(I_den,1),nF+nS);
states = nan(nF+nS+nExc*nC,6);

% discretize bottom traces
if toBottom

    % calculate FRET-time traces
    FRET_tr = [];
    if nF > 0
        FRET_tr = calcFRET(nC, nExc, exc, chanExc, FRET, I_den, gamma);
    end
    FRET_tr = FRET_tr';

    % calculate stoichiometry-time traces
    S_tr = [];
    if nS>0
        S_tr = calcS(exc, chanExc, S, FRET, I_den, gamma, beta);
    end
    S_tr = S_tr';

    % ignore ratio data out-of-range
    incl_fret = FRET_tr>=-0.2 & FRET_tr<=1.2;
    incl_s = S_tr>=-0.2 & S_tr<=1.2;
%         incl_fret = true(size(FRET_tr));
%         incl_s = true(size(S_tr));
    incl_bot = [incl_fret;incl_s];

    % discretize traces
    prm = permute(prm_DTA{2}(method,:,1:nF+nS),[3,2,1]); % [m-by-6] matrix
    thresh = prm_DTA{4}(:,:,1:nF+nS); % [3-by-t-by-m] matrix
    if mute
        actstr = 0;
    else
        actstr = 'Discretisation of bottom traces...';
    end
    bot_DTA = (getDiscr(method, [FRET_tr; S_tr], incl_bot, prm, thresh, ...
        calc, actstr, h_fig))';

    % identify and sort resulting states
    for n = 1:(nF+nS)
        states_i = (sort(unique(bot_DTA(:,n)), 'descend'))';
        J = numel(states_i);
        states(n,1:J) = states_i;
    end
end

% discretize top traces
if toBottom == 2 || ~toBottom

    % format intensity-time traces
    I_tr = [];
    for l = 1:nExc
        for c = 1:nC
            I_tr = [I_tr; I_den(:,c,l)'];
        end
    end

    % discretize intensity-time traces
    prm = permute(prm_DTA{2}(method,:,nF+nS+1:end),[3,2,1]);

    thresh = prm_DTA{4}(:,:,nF+nS+1:end);
    if mute
        actstr = 0;
    else
        actstr = 'Discretisation of top traces...';
    end
    top = (getDiscr(method, I_tr, [], prm, thresh, calc, actstr, h_fig))';

    % format resulting discretized traces
    for l = 1:nExc
        top_DTA(:,:,l) = top(:,((l-1)*nC+1):l*nC);
    end

    % identify and sort resulting states
    for l = 1:nExc
        for c = 1:nC
            states_i = (sort(unique(top_DTA(:,c,l)), 'descend'))';
            J = numel(states_i);
            states((nF+nS+(l-1)*nC+c),1:J) = states_i;
        end
    end

    % build bottom discretized traces
    if ~toBottom

        if nF > 0
            % calculate FRET-time traces
            f_tr = calcFRET(nC,nExc,exc,chanExc,FRET,I_den,gamma);

            % calculate discretized FRET-time traces from discretized
            % intensity-time traces
            f_st = calcFRET(nC,nExc,exc,chanExc,FRET,top_DTA,gamma);
        end

        % build discretized FRET-time traces
        for n = 1:nF

            % identify donor and acceptor discretized intensity-time 
            % traces
            don = FRET(n,1); acc = FRET(n,2);
            [o,l_f,o] = find(exc==chanExc(FRET(n,1)));
            Idon = top_DTA(:,don,l_f);
            Iacc = top_DTA(:,acc,l_f);

            % get changing points common to both discretized intensity-
            % time traces

            % corrected by MH, 3.4.2019
            tol = prm_DTA{2}(method,4,n);

            cp = get_cpFromDiscr([Idon Iacc]);
            cp = correl_cp(cp, tol);

            % modify discretized FRET-time trace preserving only those 
            % common changing points
            FRET_tr = f_tr(:,n);
            FRET_st{1} = f_st(:,n);
            bot_DTA(:,n) = get_discrFromCp(cp, FRET_tr, FRET_st);

            % identify and sort resulting states
            states_i = (sort(unique(bot_DTA(:,n)), 'descend'))';
            J = numel(states_i);
            states(n,1:J) = states_i;
        end

        if nS>0
            % calculate S-time traces
            s_tr = calcS(exc,chanExc,S,FRET,I_den,gamma,beta);

            % calculate discretized S-time traces from discretized
            % intensity-time traces
            s_st = calcS(exc,chanExc,S,FRET,top_DTA,gamma,beta);
        end

        % build discretized stoichiometry-time traces
        for n = (nF+1):(nF+nS)

            % calculate summed intensity-time traces at emitter-
            % specific illumination (num) and all illuminations (den)
            [o,ldon,o] = find(exc==chanExc(S(n-nF,1)));
            [o,lacc,o] = find(exc==chanExc(S(n-nF,2)));
            exc_num = sum(top_DTA(:,:,ldon),2);
            exc_den = sum(sum(top_DTA(:,:,[ldon,lacc]),2),3);

            % get changing points common to both discretized intensity-
            % time traces
            cp = get_cpFromDiscr([exc_num exc_den]);
            cp = correl_cp(cp, tol);

            % modify discretized stoichiometry-time trace preserving 
            % only  those common changing points
            S_tr = s_tr(:,n-nF);
            S_st{1} = s_st(:,n-nF);
            bot_DTA(:,n) = get_discrFromCp(cp, S_tr, S_st);

            % identify and sort resulting states
            states_i = (sort(unique(bot_DTA(:,n)), 'descend'))';
            J = numel(states_i);
            states(n,1:J) = states_i;
        end
    end
end

% save discretized intensity-time traces
p.proj{proj}.intensities_DTA(incl,((m-1)*nC+1):m*nC,:) = top_DTA;
p.proj{proj}.intensities_DTA(~incl,((m-1)*nC+1):m*nC,:) = NaN;

% save discretized FRET-time traces
if ~isempty(FRET)
    p.proj{proj}.FRET_DTA(incl,((m-1)*nF+1):m*nF,:) = bot_DTA(:,1:nF);
    p.proj{proj}.FRET_DTA(~incl,((m-1)*nF+1):m*nF,:) = NaN;
end

% save discretized stoichiometry-time traces
if ~isempty(S)
    p.proj{proj}.S_DTA(incl,((m-1)*nS+1):m*nS,:) = ...
        bot_DTA(:,(nF+1):(nF+nS));
    p.proj{proj}.S_DTA(~incl,((m-1)*nS+1):m*nS,:) = NaN;
end

% save resulting states
p.proj{proj}.prm{m}{4}{3} = states;


