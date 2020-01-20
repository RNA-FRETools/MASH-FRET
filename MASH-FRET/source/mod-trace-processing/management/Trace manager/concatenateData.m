function ok = concatenateData(h_fig)
% Concatenates traces and calculate new axis limits if necessary

% Last update by MH, 25.4.2019
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
p = h.param.ttPr;
proj = p.curr_proj;
nMol = numel(h.tm.molValid);
nChan = p.proj{proj}.nb_channel;
exc = p.proj{proj}.excitations;
chanExc = p.proj{proj}.chanExc;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
perSec = p.proj{proj}.fix{2}(4);
perPix = p.proj{proj}.fix{2}(5);
rate = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);

% get time traces
intensities = p.proj{proj}.intensities_denoise;
intensities_DTA = p.proj{proj}.intensities_DTA;
FRET_DTA = p.proj{proj}.FRET_DTA;
S_DTA = p.proj{proj}.S_DTA;

% get existing plot data
dat1 = get(h.tm.axes_ovrAll_1,'UserData');
dat2 = get(h.tm.axes_ovrAll_2,'UserData');
dat3 = get(h.tm.axes_histSort,'UserData');

% allocate cells
dat1.trace = cell(1,nChan*nExc+nFRET+nS);
dat1.lim = dat1.trace;
%dat2.hist = dat1.trace; %old
%dat2.iv = dat1.trace; %old
dat2.hist = cell(1,nChan*nExc+nFRET+nS+nFRET*nS); % RB 2018-01-03:
dat2.iv = cell(1,nChan*nExc+nFRET+nS+nFRET*nS);

% added by MH, 25.4.2019
nCalc = numel(get(h.tm.popupmenu_selectCalc,'string'))-1;
dat3.val = cell(nChan*nExc+nFRET+nS,nCalc);
dat3.lim = cell(1,nChan*nExc+nFRET+nS);
dat3.iv =  cell(nChan*nExc+nFRET+nS+nFRET*nS,nCalc);
dat3.hist = cell(nChan*nExc+nFRET+nS+nFRET*nS,nCalc);

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
    set(h.tm.axes_ovrAll_2, 'UserData', dat2);
    set(h.tm.axes_histSort, 'UserData', dat3);
    return;
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
                if perSec
                    I = I/rate;
                    I_DTA = I_DTA/rate;
                end
                if perPix
                    I = I/nPix;
                    I_DTA = I_DTA/nPix;
                end

                % concatenate traces
                dat1.trace{ind} = [dat1.trace{ind};I];

                % concatenate mean, max, min, median and states
                dat3.val{ind,1} = [dat3.val{ind,1};mean(I)];
                dat3.val{ind,2} = [dat3.val{ind,2};min(I)];
                dat3.val{ind,3} = [dat3.val{ind,3};max(I)];
                dat3.val{ind,4} = [dat3.val{ind,4};median(I)];
                dat3.val{ind,5} = [dat3.val{ind,5};I_DTA];
            end
        end

        I = intensities(incl,(nChan*(i-1)+1):nChan*i,:);
        gamma = p.proj{proj}.curr{i}{6}{1}(1,:);
        beta = p.proj{proj}.curr{i}{6}{1}(2,:);
        fret = calcFRET(nChan, nExc, exc, chanExc, FRET, I, gamma);
        s = calcS(exc, chanExc, S, FRET, I, gamma, beta);
        for n = 1:nFRET
            ind = ind + 1;
            FRET_tr = fret(:,n);
            FRET_tr(FRET_tr == Inf) = 1000000;
            FRET_tr(FRET_tr == -Inf) = -1000000;

            % concatenate traces
            dat1.trace{ind} = [dat1.trace{ind};FRET_tr];

            % concatenate mean, max, min, median and states
            dat3.val{ind,1} = [dat3.val{ind,1};mean(FRET_tr)];
            dat3.val{ind,2} = [dat3.val{ind,2};min(FRET_tr)];
            dat3.val{ind,3} = [dat3.val{ind,3};max(FRET_tr)];
            dat3.val{ind,4} = [dat3.val{ind,4};median(FRET_tr)];
            dat3.val{ind,5} = [dat3.val{ind,5};...
                FRET_DTA(incl,nFRET*(i-1)+n)];
        end
        for n = 1:nS
            ind = ind + 1;
            S_tr = s(:,n);
            S_tr(S_tr == Inf) = 1000000; % prevent for Inf
            S_tr(S_tr == -Inf) = -1000000; % prevent for Inf

            % concatenate traces
            dat1.trace{ind} = [dat1.trace{ind};S_tr];

           % concatenate mean, max, min, median and states
            dat3.val{ind,1} = [dat3.val{ind,1};mean(S_tr)];
            dat3.val{ind,2} = [dat3.val{ind,2};min(S_tr)];
            dat3.val{ind,3} = [dat3.val{ind,3};max(S_tr)];
            dat3.val{ind,4} = [dat3.val{ind,4};median(S_tr)];
            dat3.val{ind,5} = [dat3.val{ind,5};S_DTA(incl,nS*(i-1)+n)];
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

% corrected by MH, 27.3.2019
%     err = loading_bar('init', h_fig , (nChan*nExc+nFRET+nS+nFRET), ...
err = loading_bar('init', h_fig , (nChan*nExc+nFRET+nS+nFRET*nS), ...
    'Histogram data ...');

if err
    ok = false;
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);
% ---------------------------------------------------------------------

% RB 2018-01-04: adapted for FRET-S-Histogram
% MH 2019-03-27: collect ES indexes
%     for ind = 1:(size(dat1.trace,2)+nS)
ind_es = [];
for fret = 1:nFRET
    for s = 1:nS
        ind_es = cat(1,ind_es,[fret,s]);
    end
end
for ind = 1:(size(dat1.trace,2)+nFRET*nS) % counts for nChan*nExc Intensity channels, nFRET channles, nS channels and nFRET ES histograms

    if ind <= nChan*nExc % intensity histogram 1D
        dat1.lim{ind} = [min(dat1.trace{ind}) max(dat1.trace{ind})];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
        
        % overflow first & last bins
        if  numel(dat2.hist{ind})>2
            dat2.hist{ind}([1 end]) = [];
            dat2.iv{ind}([1 end]) = [];
        end

        % build histogram with mean,max,min,median and states
        for j = 1:nCalc
            dat3.lim{ind,j} = [min(dat3.val{ind,j}) max(dat3.val{ind,j})];
            [dat3.hist{ind,j},dat3.iv{ind,j}] = getHistTM(dat3.val{ind,j},...
                dat3.lim{ind,j},dat3.niv(ind,1,j));
            
            % overflow first & last bins
            if ~isempty(dat3.hist{ind,j}) && numel(dat3.hist{ind,j})>2
                dat3.hist{ind,j}([1,end]) = [];
                dat3.iv{ind,j}([1,end]) = [];
            end
        end


    elseif ind <= (nChan*nExc + nFRET + nS) % FRET and S histogram 1D
        dat1.lim{ind} = [defMin defMax];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
        
        % overflow first & last bins
        if  numel(dat2.hist{ind})>2
            dat2.hist{ind}([1 end]) = [];
            dat2.iv{ind}([1 end]) = [];
        end

        % build histogram with mean,max,min,median and states
        for j = 1:nCalc
            dat3.lim{ind,j} = [defMin defMax];
            [dat3.hist{ind,j},dat3.iv{ind,j}] = getHistTM(dat3.val{ind,j},...
                dat3.lim{ind,j},dat3.niv(ind,1,j));
            
            % overflow first & last bins
            if ~isempty(dat3.hist{ind,j}) && numel(dat3.hist{ind,j})>2
                dat3.hist{ind,j}([1 end]) = [];
                dat3.iv{ind,j}([1 end]) = [];
            end
        end

    else  % FRET-S histogram 2D, adapted from getTDPmat.m
        ind_fret = ind_es(ind-nChan*nExc-nFRET-nS,1) + nChan*nExc;
        ind_s = ind_es(ind-nChan*nExc-nFRET-nS,2) + nChan*nExc + nFRET;
        
        dat1.lim{ind} = repmat([defMin defMax],[2,1]);
        ES = [dat1.trace{ind_fret},dat1.trace{ind_s}]; 
        [dat2.hist{ind},dat2.iv{ind}] = ...
            getHistTM(ES,dat1.lim{ind},dat1.niv(ind,:));

        % build ES histograms with mean,max,min and median values
        for j = 1:nCalc
            dat3.lim{ind,j} = repmat([defMin defMax],[2,1]);
            ES = [dat3.val{ind_fret,j},dat3.val{ind_s,j}]; 
            [dat3.hist{ind,j},dat3.iv{ind,j}] = getHistTM(ES,...
                dat3.lim{ind,j},dat3.niv(ind,[1 2],j));
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
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
set(h.tm.axes_histSort, 'UserData', dat3);
