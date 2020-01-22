function ok = concatenateData(h_fig)
% Concatenates traces and calculate new axis limits if necessary

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
p = h.param.ttPr;
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
                dt = getDtFromDiscr(I_DTA,nExc*rate);
                nTrs = size(dt,1);
                if perSec
                    I = I/rate;
                    I_DTA = I_DTA/rate;
                end
                if perPix
                    I = I/nPix;
                    I_DTA = I_DTA/nPix;
                end

                % concatenate traces
                dat1.trace{ind} = [dat1.trace{ind};I]; % intensits-time trace

                % concatenate mean, max, min, median and states
                dat3.val{ind,1} = [dat3.val{ind,1};I_DTA]; % state trajectories
                dat3.val{ind,2} = [dat3.val{ind,2};mean(I)]; % mean intensity
                dat3.val{ind,3} = [dat3.val{ind,3};min(I)]; % minimum intensity
                dat3.val{ind,4} = [dat3.val{ind,4};max(I)]; % maximum intensity
                dat3.val{ind,5} = [dat3.val{ind,5};median(I)]; % median intensity
                dat3.val{ind,6} = [dat3.val{ind,6};numel(unique(I_DTA))]; % number of states
                dat3.val{ind,7} = [dat3.val{ind,7};size(dt,1)]; % number of transitions
                dat3.val{ind,8} = [dat3.val{ind,8};mean(dt(:,1))]; % mean state dwell time
                dat3.val{ind,9} = [dat3.val{ind,9};...
                    dt(:,2),repmat(i,nTrs,1)]; % state values
                dat3.val{ind,10} = [dat3.val{ind,10};...
                    dt(:,1),repmat(i,nTrs,1)]; % state dwell times
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
                dt = getDtFromDiscr(I0_DTA,nExc*rate);
                nTrs = size(dt,1);
                if perSec
                    I0 = I0/rate;
                    I0_DTA = I0_DTA/rate;
                end
                if perPix
                    I0 = I0/nPix;
                    I0_DTA = I0_DTA/nPix;
                end

                % concatenate traces
                dat1.trace{ind} = [dat1.trace{ind};I0]; % intensits-time trace

                % concatenate mean, max, min, median and states
                dat3.val{ind,1} = [dat3.val{ind,1};I0_DTA]; % state trajectories
                dat3.val{ind,2} = [dat3.val{ind,2};mean(I0)]; % mean intensity
                dat3.val{ind,3} = [dat3.val{ind,3};min(I0)]; % minimum intensity
                dat3.val{ind,4} = [dat3.val{ind,4};max(I0)]; % maximum intensity
                dat3.val{ind,5} = [dat3.val{ind,5};median(I0)]; % median intensity
                dat3.val{ind,6} = [dat3.val{ind,6};numel(unique(I0_DTA))]; % number of states
                dat3.val{ind,7} = [dat3.val{ind,7};size(dt,1)]; % number of transitions
                dat3.val{ind,8} = [dat3.val{ind,8};mean(dt(:,1))]; % mean state dwell time
                dat3.val{ind,9} = [dat3.val{ind,9};...
                    dt(:,2),repmat(i,nTrs,1)]; % state values
                dat3.val{ind,10} = [dat3.val{ind,10};...
                    dt(:,1),repmat(i,nTrs,1)]; % state dwell times
            end
        end
        
        if nFRET==0
            continue
        end
        
        I = intensities(incl,(nChan*(i-1)+1):nChan*i,:);
        gamma = p.proj{proj}.curr{i}{6}{1}(1,:);
        fret = calcFRET(nChan, nExc, exc, chanExc, FRET, I, gamma);
        for n = 1:nFRET
            ind = ind + 1;
            FRET_tr = fret(:,n);
            FRET_tr(FRET_tr == Inf) = 1000000;
            FRET_tr(FRET_tr == -Inf) = -1000000;
            
            fret_DTA =  FRET_DTA(incl,nFRET*(i-1)+n);
            dt = getDtFromDiscr(fret_DTA,nExc*rate);
            nTrs = size(dt,1);

            % concatenate traces
            dat1.trace{ind} = [dat1.trace{ind};FRET_tr];

            % concatenate mean, max, min, median and states
            dat3.val{ind,1} = [dat3.val{ind,1};fret_DTA];
            dat3.val{ind,2} = [dat3.val{ind,2};mean(FRET_tr)];
            dat3.val{ind,3} = [dat3.val{ind,3};min(FRET_tr)];
            dat3.val{ind,4} = [dat3.val{ind,4};max(FRET_tr)];
            dat3.val{ind,5} = [dat3.val{ind,5};median(FRET_tr)];
            dat3.val{ind,6} = [dat3.val{ind,6};numel(unique(fret_DTA))]; % number of states
            dat3.val{ind,7} = [dat3.val{ind,7};size(dt,1)]; % number of transitions
            dat3.val{ind,8} = [dat3.val{ind,8};mean(dt(:,1))]; % mean state lifetime
            dat3.val{ind,9} = [dat3.val{ind,9};dt(:,2),repmat(i,nTrs,1)]; % state values
            dat3.val{ind,10} = [dat3.val{ind,10};dt(:,1),repmat(i,nTrs,1)]; % state dwell times
            
        end
        if nS==0
            continue
        end
        beta = p.proj{proj}.curr{i}{6}{1}(2,:);
        s = calcS(exc, chanExc, S, FRET, I, gamma, beta);
        for n = 1:nS
            ind = ind + 1;
            S_tr = s(:,n);
            S_tr(S_tr == Inf) = 1000000; % prevent for Inf
            S_tr(S_tr == -Inf) = -1000000; % prevent for Inf
            s_DTA = S_DTA(incl,nS*(i-1)+n);
            dt = getDtFromDiscr(s_DTA,nExc*rate);
            nTrs = size(dt,1);

            % concatenate traces
            dat1.trace{ind} = [dat1.trace{ind};S_tr];

           % concatenate mean, max, min, median and states
            dat3.val{ind,1} = [dat3.val{ind,1};s_DTA];
            dat3.val{ind,2} = [dat3.val{ind,2};mean(S_tr)];
            dat3.val{ind,3} = [dat3.val{ind,3};min(S_tr)];
            dat3.val{ind,4} = [dat3.val{ind,4};max(S_tr)];
            dat3.val{ind,5} = [dat3.val{ind,5};median(S_tr)];
            dat3.val{ind,6} = [dat3.val{ind,6};numel(unique(s_DTA))]; % number of states
            dat3.val{ind,7} = [dat3.val{ind,7};size(dt,1)]; % number of transitions
            dat3.val{ind,8} = [dat3.val{ind,8};mean(dt(:,1))]; % mean state lifetime
            dat3.val{ind,9} = [dat3.val{ind,9};dt(:,2),repmat(i,nTrs,1)]; % state values
            dat3.val{ind,10} = [dat3.val{ind,10};dt(:,1),repmat(i,nTrs,1)]; % state dwell times
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

% modified by MH, 21.1.2020
% % corrected by MH, 27.3.2019
% % % loading bar parameters-----------------------------------------------
% %     err = loading_bar('init', h_fig , (nChan*nExc+nFRET+nS+nFRET), ...
% % loading bar parameters-----------------------------------------------
% err = loading_bar('init', h_fig , (nChan*nExc+nFRET+nS+nFRET*nS), ...
%     'Histogram data ...');
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

% cancelled by MH, 21.1.2020
% % RB 2018-01-04: adapted for FRET-S-Histogram
% % MH 2019-03-27: collect ES indexes
% %     for ind = 1:(size(dat1.trace,2)+nS)
% ind_es = [];
% for fret = 1:nFRET
%     for s = 1:nS
%         ind_es = cat(1,ind_es,[fret,s]);
%     end
% end
for ind = 1:(nChan*nExc+nI0+nFRET+nS)

    if ind<=(nChan*nExc+nI0) % intensity
        dat1.lim(ind,:) = [min(dat1.trace{ind}) max(dat1.trace{ind})];
    else % ratio
        dat1.lim(ind,:) = [defMin defMax];
    end
    
    for j = 1:nCalc
        if j==9 || j==10 % state-wise data
            dat3.lim(ind,:,j) = [min(min(dat3.val{ind,j}(:,1))) ...
                max(max(dat3.val{ind,j}(:,1)))];
        elseif ind>(nChan*nExc) && j<=5 % FRET/S values
            dat3.lim(ind,:,j) = [defMin defMax];
        else
            dat3.lim(ind,:,j) = [min(dat3.val{ind,j}) ...
                max(dat3.val{ind,j})];
        end
    end
        
        % cancelled by MH, 21.1.2020
%         dat1.lim{ind} = [min(dat1.trace{ind}) max(dat1.trace{ind})];
%         [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
%             dat1.lim{ind},dat1.niv(ind,1));
%         
%         % overflow first & last bins
%         if  numel(dat2.hist{ind})>2
%             dat2.hist{ind}([1 end]) = [];
%             dat2.iv{ind}([1 end]) = [];
%         end
% 
%         % build histogram with mean,max,min,median and states
%         for j = 1:nCalc
%             dat3.lim{ind,j} = [min(dat3.val{ind,j}) max(dat3.val{ind,j})];
%             [dat3.hist{ind,j},dat3.iv{ind,j}] = getHistTM(dat3.val{ind,j},...
%                 dat3.lim{ind,j},dat3.niv(ind,1,j));
%             
%             % overflow first & last bins
%             if ~isempty(dat3.hist{ind,j}) && numel(dat3.hist{ind,j})>2
%                 dat3.hist{ind,j}([1,end]) = [];
%                 dat3.iv{ind,j}([1,end]) = [];
%             end
%         end
% 
%     else % FRET and S
%         dat1.lim{ind} = [defMin defMax];
%         [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
%             dat1.lim{ind},dat1.niv(ind,1));
%         
%         % overflow first & last bins
%         if  numel(dat2.hist{ind})>2
%             dat2.hist{ind}([1 end]) = [];
%             dat2.iv{ind}([1 end]) = [];
%         end
% 
%         for j = 1:nCalc
%             dat3.lim{ind,j} = [defMin defMax];
%             [dat3.hist{ind,j},dat3.iv{ind,j}] = getHistTM(dat3.val{ind,j},...
%                 dat3.lim{ind,j},dat3.niv(ind,1,j));
%             
%             % overflow first & last bins
%             if ~isempty(dat3.hist{ind,j}) && numel(dat3.hist{ind,j})>2
%                 dat3.hist{ind,j}([1 end]) = [];
%                 dat3.iv{ind,j}([1 end]) = [];
%             end
%         end
%     else  % FRET-S histogram 2D, adapted from getTDPmat.m
%         ind_fret = ind_es(ind-nChan*nExc-nFRET-nS,1) + nChan*nExc;
%         ind_s = ind_es(ind-nChan*nExc-nFRET-nS,2) + nChan*nExc + nFRET;
%         
%         dat1.lim{ind} = repmat([defMin defMax],[2,1]);
%         ES = [dat1.trace{ind_fret},dat1.trace{ind_s}]; 
%         [dat2.hist{ind},dat2.iv{ind}] = ...
%             getHistTM(ES,dat1.lim{ind},dat1.niv(ind,:));
% 
%         % build ES histograms with mean,max,min and median values
%         for j = 1:nCalc
%             dat3.lim{ind,j} = repmat([defMin defMax],[2,1]);
%             ES = [dat3.val{ind_fret,j},dat3.val{ind_s,j}]; 
%             [dat3.hist{ind,j},dat3.iv{ind,j}] = getHistTM(ES,...
%                 dat3.lim{ind,j},dat3.niv(ind,[1 2],j));
%         end
% 
%     end
    
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
