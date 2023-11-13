function p = discrTraces(h_fig, m, p)
% p = discrTraces(h_fig, m, p)
%
% Calculates state trajectories.
%
% h_fig: handle to main figure
% m: molecule index
% p: structure containing interface parameters with fields:
%   p.curr_proj: index of current project
%   p.proj: {1-by-nProj} project parameters

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
isfretimp = isfield(p.proj{proj},'FRET_DTA_import') & ...
    ~isempty(p.proj{proj}.FRET_DTA_import);

% check for already-discretized top traces
isDiscrTop = ~isempty(p.proj{proj}.intensities_DTA) && ~all(all(all(isnan(...
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:)))));

% check for already-discretized bottom traces
isDiscrBot = ~isempty(p.proj{proj}.FRET_DTA) && ...
    ~all(all(isnan(p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF))));
if nS>0
	isDiscrBot = isDiscrBot && ~isempty(p.proj{proj}.S_DTA) && ...
        ~all(all(isnan(p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS))));
end

% collect processing parameters
prm_DTA = p.proj{proj}.TP.prm{m}{4};
meth = prm_DTA{1}(1);
toBottom = prm_DTA{1}(2); % discretize bottom(1)/top->bottom(0)/top+bottom(2)
calc = prm_DTA{1}(3);
is2D = meth==3;
if is2D
    toBottom = 1;
end
if nF>0
    gamma = p.proj{proj}.TP.prm{m}{6}{1}(1,:);
    if nS>0
        beta = p.proj{proj}.TP.prm{m}{6}{1}(2,:);
    end
end
if isfretimp
    fret_DTA_imp = p.proj{proj}.FRET_DTA_import(:,((m-1)*nF+1):m*nF)';
else
    fret_DTA_imp = NaN(size(p.proj{proj}.FRET_DTA(((m-1)*nF+1):m*nF)))';
end
    
if ~((toBottom && ~isDiscrBot) || ((~toBottom || toBottom==2) && ...
        ~isDiscrTop))
    return
end
    
% collect corrected,smoothed and cut intensity-time traces
incl = p.proj{proj}.bool_intensities(:,m);
L = size(incl,1);
I_den = p.proj{proj}.intensities_denoise(incl,((m-1)*nC+1):m*nC,:);

% initialize results
top_DTA = nan(size(I_den));
bot_DTA = nan(size(I_den,1),nF+nS);
states = nan(nF+nS+nExc*nC,6);
    
% calculates FRET- and stoichiometry-time traces
f_tr = [];
if nF > 0
    f_tr = calcFRET([],[],exc,chanExc,FRET,I_den,gamma);
    f_tr = f_tr';
end
s_tr = [];
if nS>0
    s_tr = calcS(exc, chanExc, S, FRET, I_den, gamma, beta);
    s_tr = s_tr';
end

% discretize bottom traces
if toBottom
    if mute
        actstr = 0;
    else
        actstr = 'Discretisation of bottom traces...';
    end
    
    if meth==7 % import FRET discr and calculates S discr
        incl_imp = false(size(fret_DTA_imp));
        incl_imp(1:L) = true;
        prm = permute(prm_DTA{2}(meth,:,1:nF),[3,2,1]);
        fret_DTA = (getDiscr(meth,cat(3,f_tr,fret_DTA_imp(incl_imp)),...
            true(nF,L),prm,[],calc,actstr,h_fig))';
        bot_DTA = fret_DTA;
        for s = 1:nS
            pair = FRET(:,1)==S(s,1) & FRET(:,2)==S(s,2);
            bot_DTA = cat(2,bot_DTA,...
                trajkernel(s_tr(s,:)',incl_imp,fret_DTA(:,pair)'));
        end

    else
        % ignore ratio data out-of-range
        incl_fret = f_tr>=-0.2 & f_tr<=1.2;
        incl_s = s_tr>=-0.2 & s_tr<=1.2;
        incl_bot = [incl_fret;incl_s];

        % collects processing parameters
        prm = permute(prm_DTA{2}(meth,:,1:nF+nS),[3,2,1]); % [m-by-6] matrix
        thresh = prm_DTA{4}(:,:,1:nF+nS); % [3-by-t-by-m] matrix

        if is2D % vbFRET 2D
            % 2D-discretization
            I_tr = collectintfor2Ddiscr(FRET,S,exc,chanExc,I_den);
            res2d = (getDiscr(meth,I_tr,[],prm,thresh,calc,actstr,h_fig));

            % converts to 1D discr. traces and post-processes
            bot_DTA = zeros(numel(res2d{numel(res2d)}(1,:)),nF+nS);
            bot_tr = [f_tr; s_tr];
            incl_bot = [incl_fret;incl_s];
            for n = 1:nF+nS
                bot_DTA(:,n) = trajkernel(bot_tr(n,:)',incl_bot(n,:),...
                    res2d{n}(1,:));
                bot_DTA(:,n) = postprocessdiscrtraj(bot_DTA(:,n),...
                    [prm(n,[7,6,5]),calc],bot_tr(n,:)');
            end
            
        else
            bot_DTA = (getDiscr(meth,[f_tr; s_tr],incl_bot,prm,thresh, ...
                calc,actstr,h_fig))';
        end
    end
    
    % identify and sort resulting states
    for n = 1:(nF+nS)
        states_i = (sort(unique(bot_DTA(:,n)), 'descend'))';
        J = numel(states_i);
        states(n,1:J) = states_i;
    end
end

% discretize top traces
if toBottom==2 || ~toBottom

    % format intensity-time traces
    I_tr = [];
    for l = 1:nExc
        for c = 1:nC
            I_tr = cat(1,I_tr,I_den(:,c,l)');
        end
    end

    % discretize intensity-time traces
    prm = permute(prm_DTA{2}(meth,:,nF+nS+1:end),[3,2,1]);
    thresh = prm_DTA{4}(:,:,nF+nS+1:end);
    if mute
        actstr = 0;
    else
        actstr = 'Discretisation of top traces...';
    end
    top = (getDiscr(meth, I_tr, [], prm, thresh, calc, actstr, h_fig))';

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
end

% derives bottom discr from common change points in intensity discr
if ~toBottom
    
    % collects bottom traj and calculates bottom discr
    bot_tr = [];
    bot_st = [];
    if nF>0
        % props up FRET-time traces
        f_tr = f_tr';
        bot_tr = cat(2,bot_tr,f_tr);

        % calculates discretized FRET from discretized intensities
        f_st = calcFRET(nC,nExc,exc,chanExc,FRET,top_DTA,gamma);
        bot_st = cat(2,bot_st,f_st);
    end
    if nS>0
        % props up S-time traces
        s_tr = s_tr';
        bot_tr = cat(2,bot_tr,s_tr);

        % calculates discretized S from discretized intensities
        s_st = calcS(exc,chanExc,S,FRET,top_DTA,gamma,beta);
        bot_st = cat(2,bot_st,s_st);
    end
    
    % collects top discr corresponding to each bottom data
    I2D = collectintfor2Ddiscr(FRET,S,exc,chanExc,top_DTA);
    
    % cleans bottom discr from disparat change points
    for n = 1:nF+nS
        % finds common changing points in top discr
        tol = prm_DTA{2}(meth,4,n);
        cp = get_cpFromDiscr(I2D{n}');
        cp = correl_cp(cp,tol);

        % ignore disparat changing points in bottom discr
        bot_DTA(:,n) = get_discrFromCp(cp,bot_tr(:,n),{bot_st(:,n)});

        % identify and sort resulting states
        states_i = (sort(unique(bot_DTA(:,n)), 'descend'))';
        J = numel(states_i);
        states(n,1:J) = states_i;
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
p.proj{proj}.TP.prm{m}{4}{3} = states;


