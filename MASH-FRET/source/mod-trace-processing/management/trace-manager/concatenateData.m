function ok = concatenateData(h_fig)
% ok = concatenateData(h_fig)
%
% Concatenates individual molecule data and calculate new axis limits if 
% necessary.
%
% h_fig: handle to figure "Trace manager"
% ok: logical 1 for success, 0 for failure

% Last update by MH, 21.1.2020
% >> change data organization by not storing histogram anymore (calculation
%  on spot)
%
% update by MH, 25.4.2019
% >> isolate code to calculate 1D & 2D histogram to separate function
%    getHistTm
% >> concatenate mean, maxima, minima, medians and state trajectories for
%    automatic sorting
%
% update by MH, 27.3.2019
% >> correct update for ES histograms for multiple FRET and stoichiometries
%
% Last update: by RB, 4.1.2018
% >> hist2 rather slow replaced by hist2D
%
% update: by RB, 4.1.2018
% >> include FRET-S-Histogram
% >> restructured dat2.hist, dat2.iv and dat1.lim

% defaults
defMin = -0.2;
defMax = 1.2;
ok = true;

% collect project parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nMol = numel(h.tm.molValid);
nChan = p.proj{proj}.nb_channel;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
nI0 = sum(chanExc>0);
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
perSec = p.proj{proj}.cnt_p_sec;
expt = p.proj{proj}.resampling_time;

% get time traces
intensities = p.proj{proj}.intensities_denoise;
intensities_DTA = p.proj{proj}.intensities_DTA;
FRET_DTA = p.proj{proj}.FRET_DTA;
S_DTA = p.proj{proj}.S_DTA;

% get existing plot data
dat1 = get(h.tm.axes_ovrAll_1,'UserData');
dat3 = get(h.tm.axes_histSort,'UserData');

% allocate cells
dat1.trace = cell(1,nChan*nExc+nI0+nFRET+nS);
dat1.lim = NaN(nChan*nExc+nI0+nFRET+nS,2);

% added by MH, 25.4.2019
nCalc = numel(get(h.tm.popupmenu_selectXval,'string'))-1;
dat3.val = cell(nChan*nExc+nI0+nFRET+nS,nCalc);
dat3.lim = NaN(nChan*nExc+nI0+nFRET+nS,2,nCalc);

% added by MH, 27.4.2019 to remember molecule selection at last update
% (used when applying tags in AS)
dat3.slct = h.tm.molValid;

% added by MH, 26.4.2019
if ~isfield(dat3,'range')
    dat3.range = {};
    dat3.rangeTags = [];
end

if ~sum(h.tm.molValid)
    % store data in axes
    set(h.tm.axes_ovrAll_1, 'UserData', dat1);
    set(h.tm.axes_histSort, 'UserData', dat3);
    return
end

% loading bar parameters-----------------------------------------------
err = loading_bar('init',h_fig,nMol,'Concatenate and calculate data ...');
if err
    ok = false;
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% ---------------------------------------------------------------------

for i = 1:nMol
    if h.tm.molValid(i)
        for l = 1:nExc
            for c = 1:nChan
                ind = (l-1)*nChan+c;
                incl = p.proj{proj}.bool_intensities(:,i);
                I = intensities(incl,nChan*(i-1)+c,l);
                I_DTA = intensities_DTA(incl,nChan*(i-1)+c,l);
                dt = getDtFromDiscr(I_DTA,nExc*expt);
                lt = calcStateLifetimes(dt,nExc*expt);
                if perSec
                    I = I/expt;
                    I_DTA = I_DTA/expt;
                end

                % concatenate traces
                dat1.trace{ind} = ...
                    [dat1.trace{ind};I,repmat(i,size(I,1),1)]; % intensity-time trace
                calcdat = calcASdata(i,I,I_DTA,dt,lt);
                for j = 1:nCalc
                    dat3.val{ind,j} = [dat3.val{ind,j};calcdat{j}];
                end
            end
        end
        
        if nI0>0
            for c = 1:nChan
                if chanExc(c)==0
                    continue
                end
                ind = ind+1;
                incl = p.proj{proj}.bool_intensities(:,i);
                l = find(exc==chanExc(c),1);
                I0 = sum(intensities(incl,(nChan*(i-1)+1):nChan*i,l),2);
                I0_DTA = sum(...
                    intensities_DTA(incl,(nChan*(i-1)+1):nChan*i,l),2);
                dt = getDtFromDiscr(I0_DTA,nExc*expt);
                lt = calcStateLifetimes(dt,nExc*expt);
                if perSec
                    I0 = I0/expt;
                    I0_DTA = I0_DTA/expt;
                end

                % concatenate traces
                dat1.trace{ind} = ...
                    [dat1.trace{ind};I0,repmat(i,size(I0,1),1)]; % intensits-time trace
                calcdat = calcASdata(i,I0,I0_DTA,dt,lt);
                for j = 1:nCalc
                    dat3.val{ind,j} = [dat3.val{ind,j};calcdat{j}];
                end
            end
        end
        
        if nFRET==0
            continue
        end
        
        I = intensities(incl,(nChan*(i-1)+1):nChan*i,:);
        gamma = p.proj{proj}.TP.curr{i}{6}{1}(1,:);
        fret = calcFRET(nChan, nExc, exc, chanExc, FRET, I, gamma);
        for n = 1:nFRET
            ind = ind + 1;
            FRET_tr = fret(:,n);
            FRET_tr(FRET_tr == Inf) = 1000000;
            FRET_tr(FRET_tr == -Inf) = -1000000;
            
            fret_DTA =  FRET_DTA(incl,nFRET*(i-1)+n);
            dt = getDtFromDiscr(fret_DTA,nExc*expt);
            lt = calcStateLifetimes(dt,nExc*expt);

            % concatenate traces
            dat1.trace{ind} = ...
                [dat1.trace{ind};FRET_tr,repmat(i,[size(FRET_tr,1),1])];
                calcdat = calcASdata(i,FRET_tr,fret_DTA,dt,lt);
            for j = 1:nCalc
                dat3.val{ind,j} = [dat3.val{ind,j};calcdat{j}];
            end
        end
        if nS==0
            continue
        end
        beta = p.proj{proj}.TP.curr{i}{6}{1}(2,:);
        s = calcS(exc, chanExc, S, FRET, I, gamma, beta);
        for n = 1:nS
            ind = ind + 1;
            S_tr = s(:,n);
            S_tr(S_tr == Inf) = 1000000; % prevent for Inf
            S_tr(S_tr == -Inf) = -1000000; % prevent for Inf
            s_DTA = S_DTA(incl,nS*(i-1)+n);
            dt = getDtFromDiscr(s_DTA,nExc*expt);
            lt = calcStateLifetimes(dt,nExc*expt);

            % concatenate traces
            dat1.trace{ind} = ...
                [dat1.trace{ind};S_tr,repmat(i,[size(S_tr,1),1])];
            calcdat = calcASdata(i,S_tr,s_DTA,dt,lt);
            for j = 1:nCalc
                dat3.val{ind,j} = [dat3.val{ind,j};calcdat{j}];
            end
        end
    end

    % loading bar update-----------------------------------
    err = loading_bar('update', h_fig);
    % -----------------------------------------------------

    if err
        ok = false;
        return;
    end
end
disp('data successfully concatenated !');
loading_bar('close', h_fig);

% RB 2018-01-04: adapted for FRET-S-Histogram, hist2 is rather slow
% RB 2018-01-05: hist2 replaced by hist2D
% loading bar parameters-----------------------------------------------
err = loading_bar('init', h_fig , (nChan*nExc+nI0+nFRET+nS),...
    'Store data limits ...');

if err
    ok = false;
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% ---------------------------------------------------------------------

for ind = 1:(nChan*nExc+nI0+nFRET+nS)

    if ind<=(nChan*nExc+nI0) % intensity
        minI = min([min(dat1.trace{ind}(:,1)),0]);
        maxI = max(dat1.trace{ind}(:,1));
        if minI==maxI
            minI = minI-1;
            maxI = maxI+1;
        end
        dat1.lim(ind,:) = [minI,maxI];
    else % ratio
        dat1.lim(ind,:) = [defMin defMax];
    end
    
    for j = 1:nCalc
        if ind>(nChan*nExc+nI0) && j<=5 % FRET/S values
            dat3.lim(ind,:,j) = [defMin defMax];
        else
            minval = min(dat3.val{ind,j}(:,1));
            maxval = max(dat3.val{ind,j}(:,1));
            if minval==maxval
                minval = minval-1;
                maxval = maxval+1;
            end
            dat3.lim(ind,:,j) = [minval maxval];
        end
    end
        
    % loading bar update-----------------------------------
    err = loading_bar('update', h_fig);
    % -----------------------------------------------------

    if err
        ok = false;
        return;
    end
end
disp('data successfully histogrammed !');
loading_bar('close', h_fig);

% store data in axes
set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_histSort, 'UserData', dat3);
