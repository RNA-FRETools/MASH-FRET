function def = setDefPrm_TDP(p, proj)
% prm = setDefparam_TDP(prm_in, trace)
%
% Set project parameters for TDP analysis if not existing
%
% p: structure containing interface parameters
% proj: project index in TA's project list

% Last update, 25.4.2020 by MH: add field "sim_start" and "sim_res"
% update, 24.4.2020 by MH: rename fields "kin_def", "kin_start" and "kin_res" in "lft_def", "lft_start" and "lft_res" to identify projects prior new dwelltime analysis and adapt down-compatibility
% update, 23.2.2019 by MH: (1) Initialize number of replicates with number of molecules in the sample (2) Increase initial TDP binning to 0.01 (3) Activate Gaussian convolution and normalized units on intial TDP (4) Increase initial max. number of states from 4 to 8
% created 29.4.2014 by MH

% defaults
J = 5;
method = 2;
ratioAxis = [0.01 -0.2 1.2];
nbins = 150;
gconv = true;
norm = true;
sglcnt = false;
rearr_tdp = false;
inclDiag = true;
shape = 1;
mat = 1; % constraint on clusters
clstDiag = true; % add diagonal clusters
logl = 1; % 0: incomplete data, 1: complete data
nspl_clst = 20;
niter = 10;
boba_clst = false;
nExp = 1;
boba_lft = true;
nspl_lft = 100;
wght = false;
excl = false;
rearr_lft = false;
auto_lft = true;
bin_lft = 0.01;
niter_mdl = 5;
Jdeg_max = 4;

% collect project parameters
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
I_DTA = p.proj{proj}.intensities_DTA;
FRET_DTA = p.proj{proj}.FRET_DTA;
S_DTA = p.proj{proj}.S_DTA;
expT = p.proj{proj}.frame_rate;
perSec = p.proj{proj}.cnt_p_sec;
perPix = p.proj{proj}.cnt_p_pix;
nPix = p.proj{proj}.pix_intgr(2);
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
nTag = size(p.proj{proj}.molTagNames,2);
N = size(p.proj{proj}.coord_incl,2);
nTpe = nChan*nExc + nFRET + nS;

% initialize default processing parameters
def = cell(nTag+1,nTpe);

% set default processing parameters
for tpe = 1:nTpe
    for tag = 1:nTag+1
        
        def{tag,tpe}.plot = cell(1,3);
        def{tag,tpe}.clst_start = cell(1,3);
        def{tag,tpe}.clst_res = cell(1,4);
        def{tag,tpe}.lft_def = cell(1,2);
        def{tag,tpe}.lft_start = cell(1,2);
        def{tag,tpe}.lft_res = cell(1,4);
        def{tag,tpe}.mdl_res = cell(1,4);
        
        % get default TDP axis
        isRatio = 0;
        if tpe <= nChan*nExc % intensity
            i_c = mod(tpe,nChan); i_c(i_c==0) = nChan;
            i_l = ceil(tpe/nChan);
            trace = I_DTA(:,i_c:nChan:end,i_l);
            if perSec
                trace = trace/expT;
            end
            if perPix
                trace = trace/nPix;
            end

        elseif tpe <= nChan*nExc+nFRET % FRET
            i_f = tpe - nChan*nExc;
            trace = FRET_DTA(:,i_f:nFRET:end);
            isRatio = 1;

        elseif tpe <= nChan*nExc + nFRET + nS % Stoichiometry
            i_s = tpe - nChan*nExc - nFRET;
            trace = S_DTA(:,i_s:nS:end);
            isRatio = 1;
        end
        if ~isRatio
            tr_min = trace; tr_min(isnan(tr_min)) = Inf;
            tr_max = trace; tr_max(isnan(tr_max)) = -Inf;
            minVal = min(min(tr_min)); maxVal = max(max(tr_max));
            bin = (maxVal-minVal)/nbins;
            xy_axis = [bin (minVal-2*bin) (maxVal+2*bin)];
            xy_axis(~isfinite(xy_axis)) = 0;
        else
            xy_axis = ratioAxis;
        end
        
        %% TDP parameters
        % bin    min        max
        % empty  empty      empty
        % empt   gconv      norm 
        % count  re-arrange diag
        def{tag,tpe}.plot{1} = [xy_axis; [0,0,0]; [0,gconv,norm]; ...
            [sglcnt,rearr_tdp,inclDiag]];
        
        % TDP matrix
        def{tag,tpe}.plot{2} = [];
        
        % dwells, ini. val., fin. val., molecule
        def{tag,tpe}.plot{3} = [];

        %% Clustering parameters
        % method, shape, max. nb. of states, state-dependant, restart nb., 
        % BOBA FRET, sample nb., replicate nb., cluster diagonal
        % transitions
        def{tag,tpe}.clst_start{1} = [method shape J mat niter boba_clst ...
            nspl_clst N clstDiag logl];
        % state x, state y, tol. radius x, tol. radius y
        def{tag,tpe}.clst_start{2} = [];
        % cluster colors
        def{tag,tpe}.clst_start{3} = [];

        %% Clustering results
        % struct.mu, struct.a, struct.o, struct.BIC, struct.clusters, 
        % struct.fract, struct.pop
        def{tag,tpe}.clst_res{1} = [];

        % Jopt mean, Jopt deviation
        def{tag,tpe}.clst_res{2} = [];

        % nb of states in plot
        def{tag,tpe}.clst_res{3} = 1;

        % dwells, occ., norm. occ(1)., cum. occ, 1-cum(P)
        def{tag,tpe}.clst_res{4} = [];

        %% Default fitting parameters
        % stretch, exp nb, curr exp, apply BOBA, repl nb, smple nb,weigthing, excl, re-arrange
        % model selection,stretch,exp nb,curr exp,apply BOBA,repl nb,smple nb,weigthing
        def{tag,tpe}.lft_def{1} = ...
            [auto_lft 0 nExp 1 boba_lft 20 nspl_lft wght];
        
        % low A, start A, up A, low tau, start tau, up tau, low beta, 
        % start beta, up beta]
        def{tag,tpe}.lft_def{2} = ...
            repmat([0 0.8 Inf 0 10 Inf 0 0.5 2],nExp,1);

        
        %% Actual fitting parameters (depends on J and nb. of exponentials)
        def{tag,tpe}.lft_start{1} = cell(1,2);
        
        % used model,current state value,state binning,excl,re-arrange
        def{tag,tpe}.lft_start{2} = [1,1,bin_lft,excl,rearr_lft]; 

        %% Fitting results {v-by-5} 
        % [nDegen-by-6-by-nTrs] boba fit: amp, sig_amp, dec, sig_dec, beta, sig_beta
        def{tag,tpe}.lft_res{1} = [];
        
        % [nDegen-by-3-by-nTrs] reference fit: amp, dec, beta
        def{tag,tpe}.lft_res{2} = [];
        
        % [nDegen-by-3-by-nTrs] lowest boba fit: amp, dec, beta
        def{tag,tpe}.lft_res{3} = [];
        
        % [nDegen-by-3-by-nTrs] highest boba fit: amp, dec, beta
        def{tag,tpe}.lft_res{4} = [];
        
        % {1-by-2} {1-by-nSpl}[nDt-by-2] sample dwell time histograms and [nSpl-by-3 or -nDegen*2] sample fit results
        def{tag,tpe}.lft_res{5} = [];
        
        %% Kinetic model start parameters
        % starting guess, number of restart
        def{tag,tpe}.mdl_start = [1,niter_mdl,Jdeg_max];
        
        %% Kinetic model results
        % transition probabilities
        def{tag,tpe}.mdl_res{1} = []; 
        
        % transtion probability deviations
        def{tag,tpe}.mdl_res{2} = []; 
        
        % initial probabilities
        def{tag,tpe}.mdl_res{3} = []; 
        
        % simulated data
        def{tag,tpe}.mdl_res{4} = []; 
        
        % final state values (incl. degenerated levels)
        def{tag,tpe}.mdl_res{5} = []; 
        
        % [Dmax^V-by-V+1] nb. of degenerated states, BIC
        def{tag,tpe}.mdl_res{6} = []; 
        
    end
end


