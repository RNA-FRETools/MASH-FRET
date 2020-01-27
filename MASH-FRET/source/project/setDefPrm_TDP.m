function def = setDefPrm_TDP(p, proj)
% prm = setDefparam_TDP(prm_in, trace)
%
% Set project parameters for TDP analysis if not existing
% "prm_in" >> TDP parameters loaded from project file and for the data type
% "trace" >> discretised traces of all molecules and from data type
% "isRatio" >> data in trace are intensity ratio (between 0 and 1)
% "N" >> number of molecules
%
% Requires external function: adjustParam.

% Create the 29th of April 2014 by Mélodie C.A.S. Hadzic
%
% Last update: 23rd of February 2019 by Mélodie Hadzic
% --> Initialize number of replicates with number of molecules in the
%     sample.
% --> Increase initial TDP binning to 0.01
% --> Activate Gaussian convolution and normalized units on intial TDP
% --> Increase initial max. number of states from 4 to 8

% defaults
J = 5;
nExp = 1;
method = 2;
ratioAxis = [0.01 -0.2 1.2];
nbins = 150;
gconv = true;
norm = true;
sglcnt = false;
rearr = false;
inclDiag = true;
shape = 1;
dep = true;
nspl_clst = 20;
niter = 10;
boba_clst = false;

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

% collect interface parameters
def = cell(nTag+1,nTpe);

% set default processing parameters
for tpe = 1:nTpe
    for tag = 1:nTag+1
        
        def{tag,tpe}.plot = adjustParam('plot', cell(1,3), def{tag,tpe});
        def{tag,tpe}.clst_start = adjustParam('clst_start', cell(1,3), def{tag,tpe});
        def{tag,tpe}.clst_res = adjustParam('clst_res', cell(1,4), def{tag,tpe});
        def{tag,tpe}.kin_def = adjustParam('kin_def', cell(1,2), def{tag,tpe});
        def{tag,tpe}.kin_start = adjustParam('kin_start', cell(1,2), def{tag,tpe});
        def{tag,tpe}.kin_res = adjustParam('kin_res', cell(1,4), def{tag,tpe});
        
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
        pplot{1} = [xy_axis; [0,0,0]; [0,gconv,norm]; ...
            [sglcnt,rearr,inclDiag]];
        
        % TDP matrix
        pplot{2} = [];
        
        % dwells, ini. val., fin. val., molecule
        pplot{3} = [];

        def{tag,tpe}.plot = adjustVal(def{tag,tpe}.plot,pplot);

        %% Clustering parameters
        % method, shape, max. nb. of states, state-dependant, restart nb., 
        % BOBA FRET, sample nb., replicate nb.
        clst_start{1} = [method shape J dep niter boba_clst nspl_clst N];
        % state value, tol. radius
        clst_start{2} = [];
        % cluster colors
        clst_start{3} = [];

        def{tag,tpe}.clst_start = adjustVal(def{tag,tpe}.clst_start,clst_start);

        %% Clustering results
        % struct.mu, struct.a, struct.o, struct.BIC, struct.clusters, 
        % struct.fract
        clst_res{1} = [];

        % Jopt mean, Jopt deviation
        clst_res{2} = [];

        % nb of states in plot
        clst_res{3} = 1;

        % dwells, occ., norm. occ(1)., cum. occ, 1-cum(P)
        clst_res{4} = [];

        def{tag,tpe}.clst_res = adjustVal(def{tag,tpe}.clst_res,clst_res);

        %% Default fitting parameters
        % stretch, exp nb, curr exp, apply BOBA, repl nb, smple nb, 
        % weigthing, excl
        kin_def{1} = [0 nExp 1 1 20 100 0 0];
        
        % low A, start A, up A, low tau, start tau, up tau, low beta, 
        % start beta, up beta]
        kin_def{2} = repmat([0 0.8 Inf 0 10 Inf 0 0.5 2],nExp,1);
        
        def{tag,tpe}.kin_def = adjustVal(def{tag,tpe}.kin_def,kin_def);
        
        %% Actual fitting parameters (depends on J and nb. of exponentials)
        kin_start{1} = cell(1,2);
        % model used in kinetic analysis, current transition
        kin_start{2} = [1,1]; 
        
        def{tag,tpe}.kin_start = adjustVal(def{tag,tpe}.kin_start,kin_start);

        %% Fitting results
        % boba fit: amp, sig_amp, dec, sig_dec, beta, sig_beta
        kin_res{1} = [];
        
        % reference fit: amp, dec, beta
        kin_res{2} = [];
        
        % lowest boba fit: amp, dec, beta
        kin_res{3} = [];
        
        % highest boba fit: amp, dec, beta
        kin_res{4} = [];
        
        def{tag,tpe}.kin_res = adjustVal(def{tag,tpe}.kin_res,kin_res);
    end
end


