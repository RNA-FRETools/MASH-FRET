function traceManager(h_fig)
% traceManager(h_fig)
%
% Enables trace selection upon visual inspection or defined criteria 
% "h_fig" >> handle to the main figure

% Last update by MH, 25.4.2019
% >> move molecule selection here
%
% update: by MH, 24.4.2019
% >> add tag colors
%
% update: by FS, 24.4.2018
% >> add molecule tags
   
    h = guidata(h_fig);
    h.tm.ud = false;
    guidata(h_fig,h);
    
    p = h.param.ttPr;
    proj = p.curr_proj;
    
    % molecule tags, added by FS, 24.4.2018
    h.tm.molTagNames = p.proj{proj}.molTagNames;
    h.tm.molTag = p.proj{proj}.molTag;
    
    % added by MH, 24.4.2019
    h.tm.molTagClr = p.proj{proj}.molTagClr;
    
    % added by MH, 25.4.2019
    h.tm.molValid = p.proj{proj}.coord_incl;
    
    % added byMH, 26.4.2019
    h.tm.rangeTag = [];
    
    guidata(h_fig, h);
    
    if ~(isfield(h.tm, 'figure_traceMngr') && ...
            ishandle(h.tm.figure_traceMngr))
        ok = loadData2Mngr(h_fig);
        if ~ok
            h = guidata(h_fig);
            close(h.tm.figure_traceMngr);
            return;
        end
    end
    
end

%% data handling for first use

function ok = loadData2Mngr(h_fig)

    % build GUI
    openMngrTool(h_fig);

    % load data from MASH
    ok = loadDataFromMASH(h_fig);
    if ~ok
        return;
    end
    
    % assign data-specific plot colors and axis labels
    setDataPlotPrm(h_fig);
    
    % concatenate data and assign axis limits
    ok = concatenateData(h_fig);
    if ~ok
        return;
    end
    
    % plot data in panel "Overall plot" and "Molecule selection"
    plotData_overall(h_fig)
    plotDataTm(h_fig);
    
    % plot data in panel "Auto sorting"
    plotData_autoSort(h_fig);
    
    % plot data in panel "Video view"
    plotData_videoView(h_fig);
    
end


function ok = loadDataFromMASH(h_fig)

ok = true;

h = guidata(h_fig);
m = h.param.ttPr;
proj = m.curr_proj;
nMol = numel(h.tm.molValid);
nChan = m.proj{proj}.nb_channel;

% loading bar parameters-----------------------------------------------
err = loading_bar('init',h_fig ,nMol,'Collecting data from MASH ...');
if err
    ok = false;
    return;
end
h = guidata(h_fig); % update:  get current guidata 
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h); % update: set current guidata 
% ---------------------------------------------------------------------

for i = 1:nMol
    dtaCurr = m.proj{proj}.curr{i}{4};
    if ~isempty(m.proj{proj}.prm{i})
        dtaPrm = m.proj{proj}.prm{i}{4};
    else
        dtaPrm = [];
    end

    [m,opt] = resetMol(i, m);

    m = plotSubImg(i, m, []);

    isBgCorr = ~isempty(m.proj{proj}.intensities_bgCorr) && ...
        sum(~prod(prod(double(~isnan(m.proj{proj}.intensities_bgCorr(:, ...
        ((i-1)*nChan+1):i*nChan,:))),3),2),1)~= ...
        size(m.proj{proj}.intensities_bgCorr,1);

    if ~isBgCorr
        opt = 'ttBg';
    end

    if strcmp(opt, 'ttBg') || strcmp(opt, 'ttPr')
        m = bgCorr(i, m);
    end
    if strcmp(opt, 'corr') || strcmp(opt, 'ttBg') || ...
            strcmp(opt, 'ttPr')
        m = crossCorr(i, m);
    end
    if strcmp(opt, 'denoise') || strcmp(opt, 'corr') || ...
            strcmp(opt, 'ttBg') || strcmp(opt, 'ttPr')
        m = denoiseTraces(i, m);
    end
    if strcmp(opt, 'debleach') || strcmp(opt, 'denoise') || ...
            strcmp(opt, 'corr') || strcmp(opt, 'ttBg') || ...
            strcmp(opt, 'ttPr')
        m = calcCutoff(i, m);
    end
    m.proj{proj}.curr{i} = m.proj{proj}.prm{i};
    m.proj{proj}.prm{i}{4} = dtaPrm;
    m.proj{proj}.curr{i}{4} = dtaCurr;

    % loading bar update-----------------------------------
    err = loading_bar('update', h_fig);
    % -----------------------------------------------------

    if err
        ok = false;
        return;
    end
end
loading_bar('close', h_fig);

h.param.ttPr = m;
guidata(h_fig,h);
    
end


function setDataPlotPrm(h_fig)
% Assign data-specific plot colors and axis labels

% defaults
def_niv = 200;

% get project parameters
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = numel(p.proj{proj}.S);
clr = p.proj{proj}.colours;
perSec = p.proj{proj}.fix{2}(4);
perPix = p.proj{proj}.fix{2}(5);
inSec = p.proj{proj}.fix{2}(7);

% get existing plot data
dat1 = get(h.tm.axes_ovrAll_1,'UserData');
dat2 = get(h.tm.axes_ovrAll_2,'UserData');
dat3 = get(h.tm.axes_histSort,'UserData');

% initializes interval number
nCalc = numel(get(h.tm.popupmenu_selectCalc,'string'))-1;
dat1.niv = repmat(def_niv,nChan*nExc+nFRET+nS+nFRET*nS,2);
dat3.niv = repmat(def_niv,nChan*nExc+nFRET+nS+nFRET*nS,2,nCalc);

% initializes plot parameters
dat1.color = cell(1,nChan*nExc+nFRET+nS);
dat1.ylabel = cell(1,nChan*nExc+nFRET+nS+4);
if inSec
    dat1.xlabel = 'time (s)';
else
    dat1.xlabel = 'frame number';
end

% define y-axis labels
str_extra = [];
if perSec
    str_extra = [str_extra ' per s.'];
end
if perPix
    str_extra = [str_extra ' per pix.'];
end

% set plot colors and axis labels
i = 0;
for l = 1:nExc % number of excitation channels
    for c = 1:nChan % number of emission channels
        i = i + 1;
        dat1.ylabel{i} = ['counts' str_extra];
        dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
        dat2.xlabel{i} = ['counts' str_extra]; % RB 2018-01-04
        dat1.color{i} = clr{1}{l,c};
    end
end
for n = 1:nFRET
    i = i + 1;
    dat1.ylabel{i} = 'FRET';
    dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
    dat2.xlabel{i} = 'FRET'; % RB 2018-01-04
    dat1.color{i} = clr{2}(n,:);
end
for n = 1:nS
    i = i + 1;
    dat1.ylabel{i} = 'S';
    dat2.ylabel{i} = 'freq. counts'; % RB 2018-01-04
    dat2.xlabel{i} = 'S'; % RB 2018-01-04
    dat1.color{i} = clr{3}(n,:);
end
if nChan > 1 || nExc > 1
    i = i + 1;
    dat1.ylabel{i} = ['counts' str_extra];
    % no dat2.xlabel{size(str_plot,2)} = ['counts' str_extra]; % RB 2018-01-04
end
if nFRET > 1
    i = i + 1;
    dat1.ylabel{i} = 'FRET';
    % no dat2.xlabel{size(str_plot,2)} = 'FRET'; % RB 2018-01-04
end
% String for all Stoichiometry Channels in popup menu
if nS > 1
    i = i + 1;
    dat1.ylabel{i} = 'S';
    % no dat2.xlabel{size(str_plot,2)} = 'S'; % RB 2018-01-04
end
% String for all FRET and Stoichiometry Channels in popup menu
if nFRET > 0 && nS > 0
    i = i + 1;
    dat1.ylabel{i} = 'FRET or S';
    % no dat2.xlabel{size(str_plot,2)} = 'FRET or S'; % RB 2018-01-04
end
i = 0;
for fret = 1:nFRET
    for s = 1:nS
        i = i + 1;
        % no dat1.ylabel{nChan*nExc+nFRET+nS+n} = 'FRET or S'; % RB 2018-01-04
        dat2.ylabel{nChan*nExc+nFRET+nS+i} = 'S'; % RB 2018-01-04: change index as str_plot and str_plot2 are different
        dat2.xlabel{nChan*nExc+nFRET+nS+i} = 'E'; % RB 2018-01-04: change index as str_plot and str_plot2 are different
    end
end

set(h.tm.axes_ovrAll_1,'UserData',dat1);
set(h.tm.axes_ovrAll_2,'UserData',dat2);
set(h.tm.axes_histSort,'UserData',dat3);
    
end


%% data handling for selection update

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
        gamma = p.proj{proj}.curr{i}{5}{3};
        fret = calcFRET(nChan, nExc, exc, chanExc, FRET, I, gamma);
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
            [o,l_s,o] = find(exc==chanExc(S(n)));
            Inum = sum(intensities(incl, ...
                (nChan*(i-1)+1):nChan*i,l_s),2);
            Iden = sum(sum(intensities(incl, ...
                (nChan*(i-1)+1):nChan*i,:),2),3);
            S_tr = Inum./Iden;
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
        dat2.hist{ind}([1 end]) = [];
        dat2.iv{ind}([1 end]) = [];

        % build histogram with mean,max,min,median and states
        for j = 1:nCalc
            dat3.lim{ind,j} = [min(dat3.val{ind,j}) max(dat3.val{ind,j})];
            [dat3.hist{ind,j},dat3.iv{ind,j}] = getHistTM(dat3.val{ind,j},...
                dat3.lim{ind,j},dat3.niv(ind,1,j));
            
            % overflow first & last bins
            if ~isempty(dat3.hist{ind,j})
                dat3.hist{ind,j}([1,end]) = [];
                dat3.iv{ind,j}([1,end]) = [];
            end
        end


    elseif ind <= (nChan*nExc + nFRET + nS) % FRET and S histogram 1D
        dat1.lim{ind} = [defMin defMax];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
        
        % overflow first & last bins
        dat2.hist{ind}([1 end]) = [];
        dat2.iv{ind}([1 end]) = [];

        % build histogram with mean,max,min,median and states
        for j = 1:nCalc
            dat3.lim{ind,j} = [defMin defMax];
            [dat3.hist{ind,j},dat3.iv{ind,j}] = getHistTM(dat3.val{ind,j},...
                dat3.lim{ind,j},dat3.niv(ind,1,j));
            
            % overflow first & last bins
            if ~isempty(dat3.hist{ind,j})
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
end


%% data handling for building histograms

function [P,iv] = getHistTM(trace,lim,niv)
% Build and return 1D or 2D histogram depending on the second dimension of
% input data

% Last update by MH, 24.4.2019
% >> isolate here the code to calculate 1D & 2D histogram to allow easier 
%    function call and avoid extensive repetitions
%
% RB 2018-01-04: adapted for FRET-S-Histogram, hist2 is rather slow
% RB 2018-01-05: hist2 replaced by hist2D
% RB 2018-01-04: adapted for FRET-S-Histogram

if sum(sum(isnan(trace),2),1)
    P = [];
    iv = [];
    return;
end

if size(trace,2)==1 % 1D histogram
    bin = (lim(2)-lim(1))/niv;
    iv = (lim(1)-bin):bin:(lim(2)+bin);
    [P,iv] = hist(trace,iv); % RB: HISTOGRAM replaces hist since 2015! 

else % 2D histogram
    if sum(sum(isnan(trace)))
        P = [];
        iv = [];
        return;
    end
    prm = [lim(1,:),niv(1);lim(2,:),niv(2)];
    [P,iv{1},iv{2}] = hist2D(trace,prm); % RB: hist2D by tudima at zahoo dot com, inlcuded in \traces\processing\management
end
end


function openMngrTool(h_fig)

% Last update by MH, 24.4.2019
% >> add toolbar and empty tools "Auto sorting" and "View of video"
% >> rename "Overview" panel in "Molecule selection"
%
% update: by FS, 24.4.2018
% >> add debugging mode where all other windows are not deactivated
% >> add edit box to define a molecule tag
% >> add popup menu to select molecule tag
% >> add popup menu to select molecule tag
%
% update: by RB, 5.1.2018
% >> new pushbutton to inverse the selection of individual molecules
% >> add "to do" section: include y-axes control for FRET-S-Histogram
%
% update: by RB, 3.1.2018
% >> adapt width of popupmenu for FRET-S-Histogram 
%
% update: by RB, 15.12.2017
% >> update popupmenu_axes1 and popupmenu_axes2 string
%
%

%% build figure and toolbar

% defaults
defNperPage = 3; % molecules/ page
wFig = 900; hFig = 800; % figure dimensions
mg = 10; % margin
fntS = 10.6666666; % font size
fntS_big = 12; % font size
h_edit = 20; w_edit = 40; % edit field dimensions
h_but_big = 30; w_but_big = 120; % large pushbutton dimension
w_sld = 20; % slider bar x-dimension
w_cb = 200;
w_cb2 = 60;
h_cb = 20;
h_txt = 14; % text y-dimension
w_txt1 = 65; % medium text x-dimension
w_txt2 = 105; % large text x-dimension
w_txt3 = 32; % small text x-dimension

% pushbutton cdata
arrow_up = [0.92 0.92 0.92 0.92 0.92 0.92 0 0.92 0.92 0.92 0.92 0.92;
            0.92 0.92 0.92 1    1    0    0 0    0.92 0.92 0.92 0.92;
            0.92 0.92 1    1    0    0    0 0    0    0.92 0.92 0.92;
            0.92 1    1    0    0    0    0 0    0    0    0.92 0.92;
            1    1    0    0    0    0    0 0    0    0    0    0.85;
            1    0    0    0    0    0    0 0    0    0    0    0;
            1    1    1    1    1    1    1 1    1    1    1    0.85];

% get MASH figure dimensions
prev_u = get(h_fig, 'Units');
set(h_fig, 'Units', 'pixels');
posFig = get(h_fig, 'Position');
set(h_fig, 'Units', prev_u);
prev_u = get(0, 'Units');
set(0, 'Units', 'pixels');
pos_scr = get(0, 'ScreenSize');
set(0, 'Units', prev_u);

% set TM figure dimensions
xFig = posFig(1) + (posFig(3) - wFig)/2;
yFig = min([hFig pos_scr(4)]) - hFig;
pos_fig = [xFig yFig wFig hFig];

% set margins
mg_big = 2*mg;

% set UI control dimensions
h_pop = h_edit;
w_pop = 3*w_edit+2*mg/2;
h_but = h_edit;
w_but = (w_pop+w_txt3)/2;
w_edit2 = w_cb-w_cb2;

% set panels dimensions
w_pan = wFig - 2*mg;
h_pan_all = 5*mg + 2*h_pop + 2*h_edit + mg_big + h_but;
h_toolbar = h_but_big + 2*mg;
h_pan_sgl = hFig - 2*mg - h_pan_all - h_toolbar;
h_pan_tool = hFig - h_toolbar + mg;

% set axes dimensions
h_axes_all = h_pan_all - 2.5*mg;
w_axes_all = w_pan - w_txt3 - w_pop - 3*mg;
w_axes1 = (w_axes_all-2*mg)*0.75;
w_axes2 = w_axes_all - 2*mg - w_axes1;
w_axes4 = w_pan - w_cb - 3*mg;
h_axes4 = h_pan_tool -h_pop - 5*mg;

% adjust sliding bar dimensions
h_sld = h_pan_sgl - 3*mg - mg - h_but;

% fetch main figure's handles
h = guidata(h_fig);

% create TM figure
h.tm.figure_traceMngr = figure('Visible','on','Units','pixels','Position',...
    pos_fig,'Color',[0.94 0.94 0.94],'CloseRequestFcn',...
    {@figure_traceMngr, h_fig},'NumberTitle','off','Name',...
    ['Trace manager - ' get(h_fig, 'Name')],'MenuBar','none');

% add debugging mode where all other windows are not deactivated
% added by FS, 24.4.2018
debugMode = 1;
if ~debugMode
    set(h.tm.figure_traceMngr, 'WindowStyle', 'modal')
end

x_0 = mg;
y_0 = hFig;

xNext = x_0;
yNext = y_0 - mg - h_but_big;

h.tm.togglebutton_overview = uicontrol('style','togglebutton','parent',...
    h.tm.figure_traceMngr,'units','pixels','position',...
    [xNext,yNext,w_but_big,h_but_big],'string','Overview','fontweight',...
    'bold','fontunits','pixels','fontsize',fntS_big,'callback',...
    {@switchPan_TM,h_fig});

xNext = xNext + w_but_big + mg;

h.tm.togglebutton_autoSorting = uicontrol('style','togglebutton',...
    'parent',h.tm.figure_traceMngr,'units','pixels','position',...
    [xNext,yNext,w_but_big,h_but_big],'string','Auto sorting',...
    'fontweight','bold','fontunits','pixels','fontsize',fntS_big,...
    'callback',{@switchPan_TM,h_fig});

xNext = xNext + w_but_big + mg;

h.tm.togglebutton_videoView = uicontrol('style','togglebutton','parent',...
    h.tm.figure_traceMngr,'units','pixels','position',...
    [xNext,yNext,w_but_big,h_but_big],'string','View on video',...
    'fontweight','bold','fontunits','pixels','fontsize',fntS_big,...
    'callback',{@switchPan_TM,h_fig});

%% build main panels

xNext = mg;
yNext = yNext - mg - h_pan_all;

h.tm.uipanel_overall = uipanel('Parent', h.tm.figure_traceMngr, ...
    'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_all], ...
    'Title', 'Overall plots', 'FontUnits', 'pixels', 'FontSize', fntS);

yNext = yNext - mg - h_pan_sgl;

h.tm.uipanel_overview = uipanel('Parent', h.tm.figure_traceMngr, ...
    'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_sgl], ...
    'Title','Molecule selection','FontUnits','pixels','FontSize',fntS);

xNext = -mg;
yNext = y_0 - mg - h_but_big - mg - h_pan_tool;

h.tm.uipanel_autoSorting = uipanel('Parent', h.tm.figure_traceMngr, ...
    'Units', 'pixels', 'Position', [xNext yNext wFig+2*mg h_pan_tool], ...
    'Title', '', 'FontUnits', 'pixels', ...
    'FontSize', fntS, 'Visible', 'off');

h.tm.uipanel_videoView = uipanel('Parent', h.tm.figure_traceMngr, ...
    'Units', 'pixels', 'Position', [xNext yNext wFig+2*mg h_pan_tool], ...
    'Title', '', 'FontUnits', 'pixels', ...
    'FontSize', fntS, 'Visible', 'off');


%% build panel overall plots

xNext = mg;
yNext = h_pan_all - 1.5*mg - h_pop;

h.tm.text1 = uicontrol('Style','text','Parent',h.tm.uipanel_overall,...
    'Units','pixels','String','plot1:','HorizontalAlignment','center',...
    'Position',[xNext yNext w_txt3 h_txt],'FontUnits','pixels','FontSize',...
    fntS,'FontWeight','bold');

xNext = xNext + w_txt3 + mg;

% RB 2017-12-15: update str_plot
str_plot = getStrPlot_overall(h_fig); % added by MH, 25.4.2019
h.tm.popupmenu_axes1 = uicontrol('Style','popupmenu','Parent', ...
    h.tm.uipanel_overall,'String',str_plot{1},'Units','pixels','Position',...
    [xNext yNext w_pop h_pop],'BackgroundColor',[1 1 1],'Callback',...
    {@popupmenu_axes_Callback, h_fig},'FontUnits','pixels','FontSize',...
    fntS);

xNext = mg;
yNext = yNext - mg - h_pop;

h.tm.text2 = uicontrol('Style','text','Parent',h.tm.uipanel_overall,...
    'Units','pixels','String','plot2:','HorizontalAlignment','center',...
    'Position',[xNext yNext w_txt3 h_txt],'FontUnits','pixels',...
    'FontSize',fntS,'FontWeight','bold');

xNext = xNext + w_txt3 + mg;

% RB 2017-12-15: update str_plot 
h.tm.popupmenu_axes2 = uicontrol('Style', 'popupmenu', 'Parent', ...
    h.tm.uipanel_overall, 'Units', 'pixels', 'String', str_plot{2}, ...
    'Position', [xNext yNext w_pop h_pop], 'BackgroundColor', ...
    [1 1 1], 'Callback', {@popupmenu_axes_Callback, h_fig}, ...
    'FontUnits', 'pixels', 'FontSize', fntS);

xNext = mg;
yNext = yNext - mg - h_edit;

h.tm.text3 = uicontrol('Style','text','Parent',h.tm.uipanel_overall,...
    'Units','pixels','String','xbins:','HorizontalAlignment','center',...
    'Position',[xNext yNext w_txt3 h_txt],'FontUnits','pixels','FontSize',...
    fntS);

xNext = xNext + w_txt3 + mg;

h.tm.edit_xlim_low = uicontrol('Style', 'edit', 'Parent', ...
    h.tm.uipanel_overall, 'Position', [xNext yNext w_edit h_edit], ...
    'Callback', {@edit_lim_low_Callback,h_fig,1}, 'String', '0', ...
    'BackgroundColor', [1 1 1], 'TooltipString', ...
    'lower interval value');

xNext = xNext + mg/2 + w_edit;

h.tm.edit_xnbiv = uicontrol('Style', 'edit', 'Parent', ...
    h.tm.uipanel_overall, 'Position', [xNext yNext w_edit h_edit], ...
    'Callback', {@edit_nbiv_Callback, h_fig,1}, 'String', '200', ...
    'BackgroundColor', [1 1 1], 'TooltipString', 'number of interval');

xNext = xNext + mg/2 + w_edit;

h.tm.edit_xlim_up = uicontrol('Style','edit','Parent',h.tm.uipanel_overall,...
    'Position', [xNext yNext w_edit h_edit],'Callback',...
    {@edit_lim_up_Callback,h_fig,1},'String','1','BackgroundColor',[1 1 1],...
    'TooltipString','upper interval value');

xNext = mg;
yNext = yNext - mg/2 - h_edit;

h.tm.text4 = uicontrol('Style','text','Parent',h.tm.uipanel_overall,...
    'Units','pixels','String','ybins:','HorizontalAlignment','center',...
    'Position',[xNext yNext w_txt3 h_txt],'FontUnits','pixels','FontSize',...
    fntS,'Enable','off');

xNext = xNext + w_txt3 + mg;

h.tm.edit_ylim_low = uicontrol('Style','edit','Parent',...
    h.tm.uipanel_overall,'Position',[xNext yNext w_edit h_edit],'Callback',...
    {@edit_lim_low_Callback,h_fig,2},'String','','BackgroundColor',[1 1 1],...
    'TooltipString','lower interval value','Enable','off');

xNext = xNext + mg/2 + w_edit;

h.tm.edit_ynbiv = uicontrol('Style','edit','Parent',h.tm.uipanel_overall,...
    'Position',[xNext yNext w_edit h_edit],'Callback',...
    {@edit_nbiv_Callback,h_fig,2},'String','','BackgroundColor',[1 1 1],...
    'TooltipString','number of interval','Enable','off');

xNext = xNext + mg/2 + w_edit;

h.tm.edit_ylim_up = uicontrol('Style','edit','Parent',h.tm.uipanel_overall,...
    'Position',[xNext yNext w_edit h_edit],'Callback',...
    {@edit_lim_up_Callback,h_fig,2},'String','','BackgroundColor',[1 1 1],...
    'TooltipString','upper interval value','Enable','off');

xNext = mg;
yNext = yNext - mg_big - h_but;

h.tm.pushbutton_update = uicontrol('Style', 'pushbutton', 'Parent', ...
    h.tm.uipanel_overall, 'Units', 'pixels', 'Position', ...
    [xNext yNext w_but h_but], 'String', 'UPDATE', 'TooltipString', ...
    'Update the graphs with new parameters', 'Callback', ...
    {@pushbutton_update_Callback, h_fig}, 'FontUnits', 'pixels', ...
    'FontSize', fntS);

xNext = xNext + mg + w_but;

h.tm.pushbutton_export = uicontrol('Style', 'pushbutton', 'Parent', ...
    h.tm.uipanel_overall, 'Units', 'pixels','FontWeight', 'bold', ...
    'String', 'TO MASH', 'Position', [xNext yNext w_but h_but], ...
    'TooltipString', 'Export selection to MASH', 'Callback', ...
    {@menu_export_Callback, h_fig}, 'FontUnits', 'pixels', ...
    'FontSize', fntS);

xNext = mg + w_txt3 + mg + w_pop + mg;
yNext = mg;

h.tm.axes_ovrAll_1 = axes('Parent', h.tm.uipanel_overall, 'Units', ...
    'pixels', 'FontUnits', 'pixels', 'FontSize', fntS, ...
    'ActivePositionProperty', 'OuterPosition', 'GridLineStyle', ':',...
    'NextPlot', 'replacechildren');
ylim(h.tm.axes_ovrAll_1,[0 10000]);
pos = getRealPosAxes([xNext yNext w_axes1 h_axes_all], ...
    get(h.tm.axes_ovrAll_1, 'TightInset'), 'traces');
pos(3:4) = pos(3:4) - fntS;
pos(1:2) = pos(1:2) + fntS;
set(h.tm.axes_ovrAll_1, 'Position', pos);

xNext = xNext + mg + w_axes1;
yNext = mg;

h.tm.axes_ovrAll_2 = axes('Parent', h.tm.uipanel_overall, 'Units', ...
    'pixels', 'FontUnits', 'pixels', 'FontSize', fntS, ...
    'ActivePositionProperty', 'OuterPosition', 'GridLineStyle', ':',...
    'NextPlot', 'replacechildren');
ylim(h.tm.axes_ovrAll_2,[0 10000]);
pos1 = pos;
pos = getRealPosAxes([xNext yNext w_axes2 h_axes_all], ...
    get(h.tm.axes_ovrAll_2, 'TightInset'), 'traces'); 
pos([2 4]) = pos1([2 4]);
pos(3) = pos(3) - fntS;
pos(1) = pos(1) + fntS;
set(h.tm.axes_ovrAll_2, 'Position', pos);


%% build panel molecule selection

xNext = mg;
yNext = h_pan_sgl - mg - mg - h_but + (h_but-h_txt)/2;
    
% added by MH, 24.4.2019
h.tm.text_selection = uicontrol('style','text','parent',...
    h.tm.uipanel_overview,'units','pixels','string','Selection:',...
    'position',[xNext,yNext,0.5*w_pop,h_txt],'fontunits','pixels', ...
    'fontsize', fntS,'fontweight','bold');

xNext = xNext + 0.5*w_pop + mg/2 ;
yNext = yNext - (h_but-h_txt)/2;

% added by MH, 24.4.2019
str_pop = getStrPop_select(h_fig);
h.tm.popupmenu_selection = uicontrol('style','popupmenu','parent',...
    h.tm.uipanel_overview,'units','pixels','string',str_pop,'value',1,...
    'position',[xNext,yNext,4/5*w_pop,h_but],'fontunits','pixels', ...
    'fontsize', fntS,'callback',{@popupmenu_selection_Callback,h_fig});

xNext = xNext + 4/5*w_pop + 2*mg;

h.tm.pushbutton_untagAll = uicontrol('style','pushbutton','parent', ...
    h.tm.uipanel_overview,'units','pixels','string','Untag all', ...
    'position',[xNext yNext 0.5*w_pop h_but],'tooltipString',...
    'Remove tags to all molecules','fontunits','pixels','fontsize',fntS,...
    'callback',{@pushbutton_untagAll_Callback,h_fig});

xNext = xNext + 0.5*w_pop + mg;

% edit box to define a molecule tag, added by FS, 24.4.2018
h.tm.edit_molTag = uicontrol('Style','edit','Parent',h.tm.uipanel_overview,...
    'Units','pixels','String','Define a new default tag','Position',...
    [xNext yNext w_pop h_but],'Callback',{@edit_addMolTag_Callback, h_fig}, ...
    'FontUnits','pixels','FontSize',fntS);

xNext = xNext + w_pop + mg;

% popup menu to select molecule tag, added by FS, 24.4.2018
% add callback, MH 24.4.2019
str_lst = colorTagNames(h_fig);
h.tm.popup_molTag = uicontrol('Style', 'popup', 'Parent', ...
    h.tm.uipanel_overview, 'Units', 'pixels', ...
    'String', str_lst, ...
    'Position', [xNext yNext w_pop h_but], ...
    'TooltipString', 'select a molecule tag', ...
    'FontUnits', 'pixels', ...
    'FontSize', fntS, 'Callback', {@popup_molTag_Callback,h_fig});

xNext = xNext + w_pop + mg;

% added by MH, 24.4.2019
hexclr = h.tm.molTagClr{get(h.tm.popup_molTag,'value')}(2:end);
h.tm.edit_tagClr = uicontrol('Style','edit','Parent', ...
    h.tm.uipanel_overview,'Units','pixels','String',num2str(hexclr), ...
    'Position',[xNext yNext w_edit h_but],'TooltipString', ...
    'define the tag color','FontUnits','pixels','FontSize',fntS, ...
    'Backgroundcolor',hex2rgb(hexclr)/255,'callback',...
    {@edit_tagClr_Callback,h_fig});

xNext = xNext + w_edit + mg;

% popup menu to select molecule tag, added by FS, 24.4.2018
h.tm.pushbutton_deleteMolTag = uicontrol('Style', 'pushbutton', 'Parent', ...
    h.tm.uipanel_overview, 'Units', 'pixels', ...
    'String', 'Delete tag', ...
    'Position', [xNext yNext 1/2*w_pop h_but], ...
    'TooltipString', 'Delete a default tag', ...
    'Callback', {@pushbutton_deleteMolTag_Callback, h_fig}, ...    
    'FontUnits', 'pixels', ...
    'FontSize', fntS);

xNext = w_pan - mg - w_but;

arrow_up = cat(3,arrow_up,arrow_up,arrow_up);
h.tm.pushbutton_reduce = uicontrol('Style', 'pushbutton', 'Parent', ...
    h.tm.uipanel_overview, 'Units', 'pixels', 'Position', ...
    [xNext yNext w_but h_but], 'CData', arrow_up, 'TooltipString', ...
    'Hide overall panel', 'Callback', ...
    {@pushbutton_reduce_Callback, h_fig});

xNext = xNext - mg_big - w_edit;

h.tm.edit_nbTotMol = uicontrol('Style','edit','Parent',...
    h.tm.uipanel_overview,'Units','pixels','Position',...
    [xNext yNext w_edit h_edit],'String',num2str(defNperPage),...
    'TooltipString','Number of molecule per view','BackgroundColor',...
    [1 1 1],'Callback',{@edit_nbTotMol_Callback, h_fig});

xNext = xNext - mg - w_edit;
yNext = yNext + (h_edit-h_txt)/2;

h.tm.textNmol = uicontrol('Style','text','Parent',h.tm.uipanel_overview,...
    'Units','pixels','String','disp:','HorizontalAlignment','right',...
    'Position',[xNext yNext w_edit h_txt],'FontUnits','pixels','FontSize',...
    fntS);

xNext = w_pan - mg - w_sld;
yNext = mg;

% define the number of molecule displayed per page
nb_mol = numel(h.tm.molValid);
if nb_mol < defNperPage
    nb_mol_disp = nb_mol;
else
    nb_mol_disp = defNperPage;
end
% adjust sliding parameters and visibility
if nb_mol <= nb_mol_disp || nb_mol_disp == 0
    min_step = 1;
    maj_step = 1;
    min_val = 0;
    max_val = 1;
    vis = 'off';
else
    vis = 'on';
    min_val = 1;
    max_val = nb_mol-nb_mol_disp+1;
    min_step = 1/(nb_mol-nb_mol_disp);
    maj_step = nb_mol_disp/(nb_mol-nb_mol_disp);
end
h.tm.slider = uicontrol('Style', 'slider', 'Parent', ...
    h.tm.uipanel_overview, 'Units', 'pixels', 'Position', ...
    [xNext yNext w_sld h_sld], 'Value', max_val, 'Max', max_val, ...
    'Min', min_val, 'Callback', {@slider_Callback, h_fig}, ...
    'SliderStep', [min_step maj_step], 'Visible', vis);

% save controls
guidata(h_fig, h);

% build controls and axes in panel "Molecule selection"
updatePanel_single(h_fig, nb_mol_disp);

% recover new controls
h = guidata(h_fig);
    
    
%% build panel auto-sorting
   
w_pan_slct = 0.5*w_pop + 2*w_edit + w_txt3 + 2.5*mg;
h_pan_slct = h_pan_tool-h_pop-h_txt-4*mg;
w_axes3 = wFig - w_pan_slct - 3*mg;
h_axes3 = h_pan_slct;
w_lst = w_pan_slct-2*mg;
h_lst = 3*h_txt + 2*h_edit + 1.5*mg;

xNext = 2*mg;
yNext = 2*mg;

h.tm.uipanel_range = uipanel('parent',h.tm.uipanel_autoSorting, ...
    'units','pixels','position',[xNext yNext w_pan_slct h_pan_slct], ...
    'title','Ranges','fontunits','pixels','fontsize',fntS);

xNext = xNext + w_pan_slct + mg;

h.tm.axes_histSort = axes('parent',h.tm.uipanel_autoSorting,...
    'units','pixels','fontunits','pixels','fontsize',fntS,...
    'activepositionproperty','outerposition','gridlineStyle',':',...
    'nextPlot','replacechildren','buttondownfcn',...
    {@axes_histSort_ButtonDownFcn,h_fig});
ylim(h.tm.axes_histSort,[0 10000]);
ylabel(h.tm.axes_histSort,'freq. counts');
xlabel(h.tm.axes_histSort,'counts per s. per pix.');
title(h.tm.axes_histSort,...
    '1D-histogram for molecule selection at last update');
pos = getRealPosAxes([xNext,yNext,w_axes3,h_axes3], ...
get(h.tm.axes_histSort,'TightInset'),'traces'); 
pos(3) = pos(3) - fntS;
pos(1) = pos(1) + fntS;
set(h.tm.axes_histSort,'Position',pos);

xNext = 2*mg;
yNext = yNext + h_axes3 + mg;

h.tm.text_selectData = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','Select data:','position',...
    [xNext,yNext,w_txt1,h_txt],'fontunits','pixels','fontsize',fntS,...
    'fontweight','bold','horizontalalignment','left');

xNext = xNext + w_txt1 + mg;

str_pop = getStrPlot_overall(h_fig);
h.tm.popupmenu_selectData = uicontrol('style','popupmenu','parent',...
    h.tm.uipanel_autoSorting,'string',str_pop{2},'tooltipstring',...
    'Select the data to histogram','position',[xNext,yNext,w_pop,h_pop],...
    'fontunits','pixels','fontsize',fntS,'callback',...
    {@popupmenu_selectData_Callback,h_fig});
 
xNext = xNext + w_pop + 2*mg;

h.tm.text_selectCalc = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','Select calculation:','position',...
    [xNext,yNext,w_txt2,h_txt],'fontunits','pixels','fontsize',fntS,...
    'fontweight','bold','horizontalalignment','left');
 
xNext = xNext + w_txt2 + mg;
 
str_pop = {'original time traces','means','minima','maxima','medians',...
    'state trajectories'};
h.tm.popupmenu_selectCalc = uicontrol('style','popupmenu','parent',...
    h.tm.uipanel_autoSorting,'string',str_pop,'tooltipstring',...
    'Select the calculated value to histogram','position',...
    [xNext,yNext,w_pop,h_pop],'fontunits','pixels','fontsize',fntS,...
    'callback',{@popupmenu_selectData_Callback,h_fig},'userdata',1);

xNext = xNext + w_pop + 2*mg;

h.tm.text_histogram = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','Histogram:','position',...
    [xNext,yNext,w_txt1,h_txt],'fontunits','pixels','fontsize',fntS,...
    'fontweight','bold','horizontalalignment','left');

xNext = xNext + w_txt1 + mg;

h.tm.edit_xlow = uicontrol('style','edit','parent',...
    h.tm.uipanel_autoSorting,'string','','tooltipstring',...
    'Lower bound of x-axis','position',[xNext,yNext,w_edit,h_edit],...
    'fontunits','pixels','fontsize',fntS,'callback',...
    {@edit_xlow_Callback,h_fig});

yNext = yNext + h_edit;

h.tm.text_xlow = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','x min','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center');

xNext = xNext + w_edit + mg/5;
yNext = yNext - h_edit;

h.tm.edit_xup = uicontrol('style','edit','parent',...
    h.tm.uipanel_autoSorting,'string','','tooltipstring',...
    'Upper bound of x-axis','position',[xNext,yNext,w_edit,h_edit],...
    'fontunits','pixels','fontsize',fntS,'callback',...
    {@edit_xup_Callback,h_fig});

yNext = yNext + h_edit;

h.tm.text_xup = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','x max','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center');

xNext = xNext + w_edit + mg/5;
yNext = yNext - h_edit;

h.tm.edit_xniv = uicontrol('style','edit','parent',...
    h.tm.uipanel_autoSorting,'string','','tooltipstring',...
    'Number of binning intervals in x-axis','position',...
    [xNext,yNext,w_edit,h_edit],'fontunits','pixels','fontsize',fntS,...
    'callback',{@edit_xniv_Callback,h_fig});

yNext = yNext + h_edit;

h.tm.text_xniv = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','nbins','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center');

xNext = xNext + w_edit + mg;
yNext = yNext - h_edit;

h.tm.edit_ylow = uicontrol('style','edit','parent',...
    h.tm.uipanel_autoSorting,'string','','tooltipstring',...
    'Lower bound of y-axis','position',[xNext,yNext,w_edit,h_edit],...
    'fontunits','pixels','fontsize',fntS,'callback',...
    {@edit_ylow_Callback,h_fig},'enable','off');

yNext = yNext + h_edit;

h.tm.text_ylow = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','y min','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center','enable','off');

xNext = xNext + w_edit + mg/5;
yNext = yNext - h_edit;

h.tm.edit_yup = uicontrol('style','edit','parent',...
    h.tm.uipanel_autoSorting,'string','','tooltipstring',...
    'Upper bound of y-axis','position',[xNext,yNext,w_edit,h_edit],...
    'fontunits','pixels','fontsize',fntS,'callback',...
    {@edit_yup_Callback,h_fig},'enable','off');

yNext = yNext + h_edit;

h.tm.text_yup = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','y max','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center','enable','off');

xNext = xNext + w_edit + mg/5;
yNext = yNext - h_edit;

h.tm.edit_yniv = uicontrol('style','edit','parent',...
    h.tm.uipanel_autoSorting,'string','','tooltipstring',...
    'Number of binning intervals in y-axis','position',...
    [xNext,yNext,w_edit,h_edit],'fontunits','pixels','fontsize',fntS,...
    'callback',{@edit_yniv_Callback,h_fig},'enable','off');

yNext = yNext + h_edit;

h.tm.text_yniv = uicontrol('style','text','parent',...
    h.tm.uipanel_autoSorting,'string','nbins','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center','enable','off');

    
%% build panel ranges

xNext = mg;
yNext = h_pan_slct - 1.5*mg - h_txt;

h.tm.text5 = uicontrol('style','text','parent',h.tm.uipanel_range,...
    'string','Range bounds:','position',[xNext,yNext,2*w_edit+mg/2,h_txt],...
    'fontunits','pixels','fontsize',fntS,'horizontalalignment','left',...
    'fontweight','bold');

yNext = yNext - mg - h_txt - h_edit;

h.tm.edit_xrangeLow = uicontrol('style','edit','parent',...
    h.tm.uipanel_range,'string','0','position',...
    [xNext,yNext,w_edit,h_edit],'fontunits','pixels','fontsize',fntS,...
    'callback',{@edit_xrangeLow_Callback,h_fig});

yNext = yNext + h_edit;

h.tm.text_xrangeLow = uicontrol('style','text','parent',...
    h.tm.uipanel_range,'string','xlow','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center');

yNext = yNext - h_edit;
xNext = xNext + w_edit + mg/2;

h.tm.edit_xrangeUp = uicontrol('style','edit','parent',...
    h.tm.uipanel_range,'string','1','position',...
    [xNext,yNext,w_edit,h_edit],'fontunits','pixels','fontsize',fntS,...
    'callback',{@edit_xrangeUp_Callback,h_fig});

yNext = yNext + h_edit;

h.tm.text_xrangeUp = uicontrol('style','text','parent',...
    h.tm.uipanel_range,'string','xup','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center');

yNext = yNext - h_edit;
xNext = xNext + w_edit + mg;

h.tm.edit_yrangeLow = uicontrol('style','edit','parent',...
    h.tm.uipanel_range,'string','0','position',...
    [xNext,yNext,w_edit,h_edit],'fontunits','pixels','fontsize',fntS,...
    'callback',{@edit_yrangeLow_Callback,h_fig},'enable','off');

yNext = yNext + h_edit;

h.tm.text_yrangeLow = uicontrol('style','text','parent',...
    h.tm.uipanel_range,'string','ylow','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center','enable','off');

yNext = yNext - h_edit;
xNext = xNext + w_edit + mg/2;

h.tm.edit_yrangeUp = uicontrol('style','edit','parent',...
    h.tm.uipanel_range,'string','1','position',...
    [xNext,yNext,w_edit,h_edit],'fontunits','pixels','fontsize',fntS,...
    'callback',{@edit_yrangeUp_Callback,h_fig},'enable','off');

yNext = yNext + h_edit;

h.tm.text_yrangeUp = uicontrol('style','text','parent',...
    h.tm.uipanel_range,'string','yup','position',...
    [xNext,yNext,w_edit,h_txt],'fontunits','pixels','fontsize',fntS,...
    'horizontalalignment','center','enable','off');

xNext = mg;
yNext = yNext - h_edit - mg - h_txt;

h.tm.text_conf1 = uicontrol('style','text','parent',h.tm.uipanel_range,...
    'string','Confidence:','position',...
    [xNext,yNext,w_pan_slct-2*mg,h_txt],'fontunits','pixels','fontsize',...
    fntS,'horizontalalignment','left','fontweight','bold');

yNext = yNext - h_txt;

h.tm.text_conf2 = uicontrol('style','text','parent',h.tm.uipanel_range,...
    'string','(for trajectories only)','position',...
    [xNext,yNext,w_pan_slct-2*mg,h_txt],'fontunits','pixels','fontsize',...
    fntS,'horizontalalignment','left','fontangle','italic');

yNext = yNext - mg - h_pop;

str_pop = {'confidence in percent','confidence in data points'};
h.tm.popupmenu_units = uicontrol('style','popupmenu','parent',...
    h.tm.uipanel_range,'string',str_pop,'tooltipstring',...
    'Select a condition','position',[xNext,yNext,w_pan_slct-2*mg,h_pop],...
    'fontunits','pixels','fontsize',fntS,'callback',...
    {@popupmenu_units_Callback,h_fig});

yNext = yNext - mg - h_pop;

str_pop = {'at least','at most','between'};
h.tm.popupmenu_cond = uicontrol('style','popupmenu','parent',...
    h.tm.uipanel_range,'string',str_pop,'tooltipstring',...
    'Select a condition','position',[xNext,yNext,0.5*w_pop,h_pop],...
    'fontunits','pixels','fontsize',fntS,'callback',...
    {@popupmenu_cond_Callback,h_fig});

xNext = xNext + 0.5*w_pop + mg/2;

h.tm.edit_conf1 = uicontrol('style','edit','parent',h.tm.uipanel_range,...
    'string','50','position',[xNext,yNext,w_edit,h_edit],'fontunits',...
    'pixels','fontsize',fntS,'callback',{@edit_conf_Callback,h_fig});

xNext = xNext + w_edit;
yNext = yNext + (h_edit-h_txt)/2;

h.tm.text_and = uicontrol('style','text','parent',h.tm.uipanel_range,...
    'string','and','position',[xNext,yNext,w_txt3,h_txt],'fontunits',...
    'pixels','fontsize',fntS,'horizontalalignment','center','enable',...
    'off');

xNext = xNext + w_txt3;
yNext = yNext - (h_edit-h_txt)/2;

h.tm.edit_conf2 = uicontrol('style','edit','parent',h.tm.uipanel_range,...
    'string','100','position',[xNext,yNext,w_edit,h_edit],'fontunits',...
    'pixels','fontsize',fntS,'callback',{@edit_conf_Callback,h_fig},...
    'enable','off');

xNext = mg;
yNext = yNext - mg - h_txt;

h.tm.text_Npop = uicontrol('style','text','parent',h.tm.uipanel_range,...
    'string','subgroup size: 0 molecule','position',...
    [xNext,yNext,w_pan_slct-2*mg,h_txt],'fontunits','pixels','fontsize',...
    fntS,'horizontalalignment','left');

yNext = yNext - mg - h_but;

h.tm.pushbutton_saveRange = uicontrol('style','pushbutton','parent',...
    h.tm.uipanel_range,'string','Save subgroup','tooltipstring',...
    'Save the range to tag the corresponding molecule subgroup','position',...
    [xNext,yNext,w_lst,h_but],'fontunits','pixels','fontsize',...
    fntS,'callback',{@pushbutton_saveRange_Callback,h_fig},'enable','off');

yNext = yNext - mg_big - h_edit;

h.tm.text_pop = uicontrol('style','text','parent',h.tm.uipanel_range,...
    'string','Molecule subgroups:','position',...
    [xNext,yNext,w_pan_slct-2*mg,h_txt],'fontunits','pixels','fontsize',...
    fntS,'horizontalalignment','left','fontweight','bold','enable','off');

xNext = mg;
yNext = yNext - mg - h_lst;

h.tm.listbox_ranges = uicontrol('style','listbox','parent',...
    h.tm.uipanel_range,'string',{'no range'},'tooltipstring',...
    'Select a range','position',[xNext,yNext,w_lst,h_lst],'fontunits',...
    'pixels','fontsize',fntS,'callback',{@listbox_ranges_Callback,h_fig},...
    'enable','off');

yNext = yNext - mg - h_but;

h.tm.pushbutton_dismissRange = uicontrol('style','pushbutton','parent',...
    h.tm.uipanel_range,'string','Dismiss subgroup','tooltipstring',...
    'Delete selected subgroup','position',[xNext,yNext,w_lst,h_but],...
    'fontunits','pixels','fontsize',fntS,'callback',...
    {@pushbutton_dismissRange_Callback,h_fig},'enable','off');

yNext = yNext - mg_big - h_edit;

h.tm.text_tag = uicontrol('style','text','parent',h.tm.uipanel_range,...
    'string','Subgroup tags:','position',...
    [xNext,yNext,w_pan_slct-2*mg,h_txt],'fontunits','pixels','fontsize',...
    fntS,'horizontalalignment','left','fontweight','bold','enable','off');

yNext = yNext - mg - h_but;

h.tm.pushbutton_addTag2pop = uicontrol('style','pushbutton', ...
    'Parent',h.tm.uipanel_range,'units','pixel','position', ...
    [xNext yNext w_edit h_but],'string','Tag','callback', ...
    {@pushbutton_addTag2pop_Callback,h_fig},'enable','off');

xNext = xNext + w_edit + mg;

str_pop = colorTagNames(h_fig);
h.tm.popupmenu_defTagPop = uicontrol('style','popup','parent',...
    h.tm.uipanel_range,'units','pixel','enable','off','position',...
    [xNext yNext w_pan_slct-3*mg-w_edit h_pop],'string',str_pop,'value',1);

xNext = mg;
yNext = yNext - mg - h_lst;

str_lst = {'no tag'};
h.tm.listbox_popTag = uicontrol('style','listbox','parent',...
    h.tm.uipanel_range,'units','pixel','enable','off','position',...
    [xNext yNext w_pan_slct-2*mg h_lst],'string',str_lst);

yNext = yNext - mg - h_but;

h.tm.pushbutton_remPopTag = uicontrol('style','pushbutton','parent',...
    h.tm.uipanel_range,'units','pixel','enable','off','position',...
    [xNext yNext w_pan_slct-2*mg h_but],'string','Untag','callback',...
    {@pushbutton_remPopTag_Callback,h_fig});

h.tm.pushbutton_applyTag = uicontrol('style','pushbutton','parent',...
    h.tm.uipanel_range,'units','pixel','enable','off','position',...
    [xNext mg w_pan_slct-2*mg yNext-2*mg],'string',...
    'APPLY TAG TO MOLECULES','callback',...
    {@pushbutton_applyTag_Callback,h_fig},'fontweight','bold');


%% build panel video view

xNext = 2*mg;
yNext = h_pan_tool - 2*mg - h_pop + (h_pop-h_txt)/2;

h.tm.text_exc = uicontrol('style','text','parent',h.tm.uipanel_videoView,...
    'units','pixels','position',[xNext,yNext,0.7*w_cb,h_txt],'fontunits',...
    'pixels','fontsize',fntS,'string','Select laser wavelength:',...
    'fontweight','bold','horizontalalignment','left');

xNext = xNext + 0.7*w_cb + mg;
yNext = yNext - (h_pop-h_txt)/2;

str_pop = [getStrPop('exc',...
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.excitations),'all'];
h.tm.popupmenu_VV_exc = uicontrol('style','popup','parent',...
    h.tm.uipanel_videoView,'units','pixel','position',...
    [xNext,yNext,0.3*w_cb,h_pop],'string',str_pop,'value',3,'callback',...
    {@popupmenu_VV_exc_Callback,h_fig});

xNext = 2*mg;
yNext = yNext - mg_big - h_pop + (h_pop-h_txt)/2;

h.tm.text_VV_mol = uicontrol('style','text','parent',...
    h.tm.uipanel_videoView,'units','pixels','position',...
    [xNext,yNext,0.5*w_cb,h_txt],'fontunits','pixels','fontsize',fntS,...
    'string','Show molecules:','fontweight','bold','horizontalalignment',...
    'left');

xNext = xNext + 0.5*w_cb + mg;
yNext = yNext - (h_pop-h_txt)/2;

str_pop = {'selected','unselected','all'};
h.tm.popupmenu_VV_mol = uicontrol('style','popup','parent',...
    h.tm.uipanel_videoView,'units','pixel','value',3,'position',...
    [xNext,yNext,0.5*w_cb,h_pop],'string',str_pop,'callback',...
    {@popupmenu_VV_mol_Callback,h_fig});

xNext = 2*mg;
yNext = yNext - mg_big - h_pop;

h.tm.checkbox_VV_tag0 = uicontrol('style','checkbox','parent',...
    h.tm.uipanel_videoView,'units','pixels','fontunits','pixels',...
    'fontsize',fntS,'position',[xNext,yNext,w_cb2,h_cb],'string',...
    'show','callback',{@checkbox_VV_tag0_Callback,h_fig});

xNext = xNext + w_cb2 + mg;

h.tm.edit_VV_tag0 = uicontrol('style','edit','parent',...
    h.tm.uipanel_videoView,'units','pixels','fontunits','pixels',...
    'fontsize',fntS,'position',[xNext,yNext,w_edit2,h_cb],'string',...
    'not labelled','enable','off');

xNext = w_cb + 3*mg;
yNext = h_pan_tool - h_pop - mg - h_axes4;

h.tm.axes_videoView = axes('parent',h.tm.uipanel_videoView,'units',...
    'pixels','fontunits','pixels','fontsize',fntS,'activepositionproperty',...
    'outerposition','gridlineStyle',':','nextPlot','replacechildren');
ylim(h.tm.axes_videoView,[0 10000]);
ylabel(h.tm.axes_videoView,'x-position (pixel)');
xlabel(h.tm.axes_videoView,'y-position (pixel)');
title(h.tm.axes_videoView,'Average video frame');
pos = getRealPosAxes([xNext,yNext,w_axes4,h_axes4],...
    get(h.tm.axes_videoView,'tightinset'),'traces'); 
pos(3) = pos(3) - fntS;
pos(1) = pos(1) + fntS;
set(h.tm.axes_videoView,'Position',pos);

guidata(h_fig,h);
updatePanel_VV(h_fig);
h = guidata(h_fig);

    
%% save and finalize figure
    
% save controls
guidata(h_fig, h);

% set all positions and dimensions to normalized 
setProp(get(h.tm.figure_traceMngr, 'Children'), 'Units', 'normalized');

% set all font units to pixels
setProp(get(h.tm.figure_traceMngr, 'Children'), 'FontUnits', 'pixels');

% store relevant parameters to used when reducing panel "Overall plot"
pos_button = get(h.tm.pushbutton_reduce, 'Position');
pos_panelAll_open = get(h.tm.uipanel_overall, 'Position');
pos_panelSingle_open = get(h.tm.uipanel_overview, 'Position');
dat.arrow = flipdim(arrow_up,1);% close
dat.open = 1;
h_panelAll_close = pos_button(4);
dat.pos_all = [pos_panelAll_open(1) ...
    pos_panelAll_open(2)+pos_panelAll_open(4)-h_panelAll_close ...
    pos_panelAll_open(3) h_panelAll_close];% close
dat.pos_single = [pos_panelSingle_open(1) pos_panelSingle_open(2) ...
    pos_panelAll_open(3) (pos_panelSingle_open(4)+ ...
    pos_panelAll_open(4)-h_panelAll_close)];% close
dat.tooltip = 'Show overall panel';% close
dat.visible = 'off';
set(h.tm.pushbutton_reduce, 'UserData', dat);

% make figure visible
set(h.tm.figure_traceMngr, 'Visible', 'on');

% set jet colormap
colormap(h.tm.figure_traceMngr,'jet');

% switch to default tool interface
switchPan_TM(h.tm.togglebutton_overview,[],h_fig);
    
end


function updatePanel_VV(h_fig)

% defaults
fntS = 10.666666;
w_cb = 200;
w_edit = 60;
w_txt = w_cb - w_edit;
h_cb = 20;
mg = 10;

h = guidata(h_fig);
tagNames = h.tm.molTagNames;
nTag = numel(tagNames);

% reset old controls
if isfield(h.tm, 'checkbox_VV_tag')
    for t = 1:size(h.tm.checkbox_VV_tag,2)
        if ishandle(h.tm.checkbox_VV_tag(t))
            delete([h.tm.checkbox_VV_tag(t),h.tm.edit_VV_tag(t)]);
        end
    end
    h.tm = rmfield(h.tm,{'checkbox_VV_tag','edit_VV_tag'});
end

edit_units = get(h.tm.edit_VV_tag0,'units');
set(h.tm.edit_VV_tag0,'units','pixels');
pos_edit = get(h.tm.edit_VV_tag0,'position');
set(h.tm.edit_VV_tag0,'units',edit_units);

xNext = 2*mg;
yNext = pos_edit(2) - mg - h_cb;

str_tag = colorTagNames(h_fig);
for t = 1:nTag
    h.tm.checkbox_VV_tag(t) = uicontrol('style','checkbox','parent',...
        h.tm.uipanel_videoView,'units','pixels','fontunits','pixels',...
        'fontsize',fntS,'position',[xNext,yNext,w_edit,h_cb],'string',...
        'show','callback',{@checkbox_VV_tag_Callback,h_fig,t});
    
    xNext = xNext + w_edit + mg;
    
    h.tm.edit_VV_tag(t) = uicontrol('style','edit','parent',...
        h.tm.uipanel_videoView,'units','pixels','fontunits','pixels',...
        'fontsize',fntS,'position',[xNext,yNext,w_txt,h_cb],'string',...
        removeHtml(str_tag{t}),'enable','off');
    
    xNext = 2*mg;
    yNext = yNext - mg - h_cb;
end

setProp(get(h.tm.uipanel_videoView, 'children'),'units','normalized');

guidata(h_fig,h);

end


function updatePanel_single(h_fig, nb_mol_disp)

% Last update by MH, 24.4.2019
% >> allow molecule tagging even if the molecule unselected
% >> review positionning of existing uicontrol
% >> add listboxes as well as "Tag" and "Untag" pushbuttons to allow 
%    mutiple tags
%
% update: by FS, 24.4.2018
% >> add popupmenu for molecule label and deactivate it if the molecule is 
%    not selected
%
%
    
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;

nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
isBot = double(nS | nFRET);

% get panel pixel dimensions
pan_units = get(h.tm.uipanel_overview,'units');
set(h.tm.uipanel_overview,'units','pixels');
pos_pan = get(h.tm.uipanel_overview,'position');
set(h.tm.uipanel_overview,'units',pan_units);
w_pan = pos_pan(3);
h_pan = pos_pan(4);

% get button pixel dimensions
but_units = get(h.tm.pushbutton_reduce,'units');
set(h.tm.pushbutton_reduce,'units','pixels');
pos_pan = get(h.tm.pushbutton_reduce,'position');
set(h.tm.pushbutton_reduce,'units',but_units);
y_but = pos_pan(2);

% get slide bar pixel dimensions
sb_units = get(h.tm.slider,'units');
set(h.tm.slider,'units','pixels');
pos_sb = get(h.tm.slider,'position');
set(h.tm.slider,'units',sb_units);
w_sb = pos_sb(3);

% calculate control and axes dimensions
mg = 10;
mg_top = h_pan-y_but;
h_line = (h_pan-mg_top-2*mg)/nb_mol_disp;
w_line = w_pan-w_sb-2*mg;
w_cb = 40;
w_pop = 60; 
h_pop = 20;
w_but = 40; 
h_but = h_pop;
w_col = w_cb+w_pop+w_but+4*mg;
w_lst = w_col-w_cb-3*mg; 
h_lst = h_line-h_pop-h_but-4*mg;
h_lst(h_lst<h_pop) = h_pop;
w_axes_tt = (5/6)*(w_line-w_col);
w_axes_hist = (1/6)*(w_line-w_col);
h_axes = h_line/(1+isBot);

fntS = get(h.tm.axes_ovrAll_1, 'FontSize');

% modified by MH, 24.4.2019
% update field reset with new controls
if isfield(h.tm, 'checkbox_molNb')
    for i = 1:size(h.tm.checkbox_molNb,2)
        if ishandle(h.tm.checkbox_molNb(i))
            delete([h.tm.checkbox_molNb(i),h.tm.axes_itt(i),...
                h.tm.axes_itt_hist(i),h.tm.pushbutton_remLabel(i),...
                h.tm.listbox_molLabel(i),h.tm.popup_molNb(i),...
                h.tm.pushbutton_addTag2mol(i)]);
            if isBot
                delete([h.tm.axes_frettt(i),h.tm.axes_hist(i)]);
            end
        end
    end
    h.tm = rmfield(h.tm,{'checkbox_molNb','axes_itt','axes_itt_hist',...
        'pushbutton_remLabel','listbox_molLabel','popup_molNb',...
        'pushbutton_addTag2mol'});
    if isBot
        h.tm = rmfield(h.tm,{'axes_frettt','axes_hist'});
    end
end

for i = nb_mol_disp:-1:1

    y_0 = mg + (nb_mol_disp-i)*h_line;
    x_0 = mg;

    x_next = x_0;
    y_next = y_0;

    h.tm.checkbox_molNb(i) = uicontrol('Style','checkbox','Parent',...
        h.tm.uipanel_overview,'Units','pixel','Position',...
        [x_next y_next w_col-mg h_line],'String',num2str(i),'Value', ...
        h.tm.molValid(i),'Callback',{@checkbox_molNb_Callback,h_fig},...
        'FontSize',12,'BackgroundColor', ...
        0.05*[mod(i,2) mod(i,2) mod(i,2)]+0.85);

    x_next = x_next + w_cb + mg;
    y_next = y_next + mg;

    h.tm.pushbutton_remLabel(i) = uicontrol('Style', 'pushbutton', ...
        'Parent', h.tm.uipanel_overview, 'Units', 'pixel', ...
        'Position', [x_next y_next w_lst h_but], 'Callback', ...
        {@pushbutton_remLabel_Callback,h_fig,i}, 'String', ...
        'Untag');

    y_next = y_next + h_but + mg;

    str_lst = colorTagLists_OV(h_fig,i);

    h.tm.listbox_molLabel(i) = uicontrol('Style', 'listbox', ...
        'Parent', h.tm.uipanel_overview, 'Units', 'pixel', ...
        'Position', [x_next y_next w_lst h_lst],'string',str_lst);

    x_next = x_0 + w_cb + mg;
    y_next = y_next + h_lst + mg;

    % added by FS, 24.4.2018
    str_pop = colorTagNames(h_fig);

    % modified by MH, 24.4.2019
    % adjust popupmenu to first label in default list and remove 
    % callback
%         if h.tm.molTag(i) > length(str_pop)
%             val = 1;
%         else
%             val = h.tm.molTag(i);
%         end
    h.tm.popup_molNb(i) = uicontrol('Style', 'popup', ...
        'Parent', h.tm.uipanel_overview, 'Units', 'pixel', ...
        'Position', [x_next y_next w_pop h_pop], 'String',  str_pop, ...
        'Value', 1);

    % deactivate the popupmenu if the molecule is not selected
    % added by FS, 24.4.2018
    % cancelled by MH, 24.4.2019: allow labelling even if not selected
%         if h.tm.molValid(i) == 0
%             set(h.tm.popup_molNb(i), 'Enable', 'off')
%         else
%             set(h.tm.popup_molNb(i), 'Enable', 'on')
%         end

    x_next = x_next + w_pop + mg;

    h.tm.pushbutton_addTag2mol(i) = uicontrol('Style','pushbutton', ...
        'Parent',h.tm.uipanel_overview,'Units','pixel','Position', ...
        [x_next y_next w_but h_but],'String','Tag','Callback', ...
        {@pushbutton_addTag2mol_Callback,h_fig,i});

    y_next = y_0;
    x_next = w_col;

    h.tm.axes_itt(i) = axes('Parent', h.tm.uipanel_overview, ...
        'Units', 'pixel', 'Position', [x_next y_next w_axes_tt h_axes], ...
        'YAxisLocation', 'right', 'NextPlot', 'replacechildren', ...
        'GridLineStyle', ':', 'FontUnits', 'pixels', 'FontSize', fntS);

    x_next = x_next + w_axes_tt;

    h.tm.axes_itt_hist(i) = axes('Parent', h.tm.uipanel_overview, ...
        'Units','pixel','Position',[x_next y_next w_axes_hist h_axes], ...
        'YAxisLocation','right','GridLineStyle',':','FontUnits', ...
        'pixels','FontSize',fntS);

    if isBot
        x_next = w_col;
        y_next = y_next + h_axes;

        h.tm.axes_frettt(i) = axes('Parent', h.tm.uipanel_overview, ...
            'Units', 'pixel', 'Position', ...
            [x_next y_next w_axes_tt h_line/2], 'YAxisLocation', ...
            'right', 'NextPlot', 'replacechildren', 'GridLineStyle',...
            ':', 'FontUnits', 'pixels', 'FontSize', fntS);

        x_next = x_next + w_axes_tt;

        h.tm.axes_hist(i) = axes('Parent', h.tm.uipanel_overview, ...
            'Units', 'pixel', 'Position', ...
            [x_next y_next w_axes_hist h_line/2], 'YAxisLocation',...
            'right', 'GridLineStyle', ':', 'FontUnits', 'pixels', ...
            'FontSize', fntS);
    end
end

setProp(get(h.tm.uipanel_overview, 'children'),'units','normalized');

guidata(h_fig, h);

end


%% update main GUI

function switchPan_TM(obj,evd,h_fig)
% Render the selected tool visible and other tools invisible

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

green = [0.76 0.87 0.78];
grey = [240/255 240/255 240/255];

set(obj,'Value',1,'BackgroundColor',green);

switch obj
    case h.tm.togglebutton_overview
        set([h.tm.togglebutton_autoSorting,h.tm.togglebutton_videoView],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_autoSorting,h.tm.uipanel_videoView],'Visible',...
            'off');
        set([h.tm.uipanel_overall,h.tm.uipanel_overview], 'Visible', 'on');
        
    case h.tm.togglebutton_autoSorting
        set([h.tm.togglebutton_overview,h.tm.togglebutton_videoView],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_overall,h.tm.uipanel_overview,...
            h.tm.uipanel_videoView],'Visible','off');
        set(h.tm.uipanel_autoSorting, 'Visible', 'on');
        
    case h.tm.togglebutton_videoView
        set([h.tm.togglebutton_overview,h.tm.togglebutton_autoSorting],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_overall,h.tm.uipanel_overview,...
            h.tm.uipanel_autoSorting],'Visible','off');
        set(h.tm.uipanel_videoView, 'Visible', 'on');
end
end


%% plots in tool "Overview"

function plotDataTm(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
isBot = nFRET | nS;

mol = p.curr_mol(proj);
prm = p.proj{proj}.prm{mol};

for i = 1:size(h.tm.checkbox_molNb,2)
    mol_nb = str2num(get(h.tm.checkbox_molNb(i), 'String'));

    axes.axes_traceTop = h.tm.axes_itt(i);
    axes.axes_histTop = h.tm.axes_itt_hist(i);
    if isBot
        axes.axes_traceBottom = h.tm.axes_frettt(i);
        axes.axes_histBottom = h.tm.axes_hist(i);
    end

    plotData(mol_nb, p, axes, prm, 0);

    if h.tm.molValid(mol_nb)
        shad = [1 1 1];
    else
        shad = get(h.tm.checkbox_molNb(i), 'BackgroundColor');
    end
    set([h.tm.axes_itt(i) h.tm.axes_itt_hist(i)], 'Color', shad);
    if isBot
        set([h.tm.axes_frettt(i), h.tm.axes_hist(i)], 'Color', shad);
        if i ~= size(h.tm.checkbox_molNb,2)
            set(get(h.tm.axes_frettt(i), 'Xlabel'), 'String', '');
            set(get(h.tm.axes_itt_hist(i), 'Xlabel'), 'String', '');
        end
    elseif i ~= size(h.tm.checkbox_molNb,2)
        set(get(h.tm.axes_itt(i), 'Xlabel'), 'String', '');
        set(get(axes.axes_histTop, 'Xlabel'), 'String', '');
    end
    set(h.tm.checkbox_molNb(i), 'Value', h.tm.molValid(mol_nb));
end
end


function plotData_overall(h_fig)

% Last update by MH, 24.4.2019
% >> correct plot clearing before plotting multiple traces on the same 
%    graph
% 
% update: by RB, 3.1.2018
% >> indizes/colour bug solved
%
% update: by RB, 15.12.2017
% >> implement FRET-S-histograms in plot2
%
%

warning('off','MATLAB:hg:EraseModeIgnored');

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
inSec = p.proj{proj}.fix{2}(7);

plot1 = get(h.tm.popupmenu_axes1, 'Value');
plot2 = get(h.tm.popupmenu_axes2, 'Value');

dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
dat2 = get(h.tm.axes_ovrAll_2, 'UserData');

disp('plot data ...');

if plot1 <= nChan*nExc+nFRET+nS % single channel/FRET/S
    x_axis = 1:size(dat1.trace{plot1},1);
    if inSec
        rate = p.proj{proj}.frame_rate;
        x_axis = x_axis*rate;
    end
    plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{plot1}, 'Color', ...
        dat1.color{plot1});
    xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
    if plot1 <= nChan*nExc
        ylim(h.tm.axes_ovrAll_1, [min(dat1.trace{plot1}) ...
            max(dat1.trace{plot1})]);
    else
        ylim(h.tm.axes_ovrAll_1, [-0.2 1.2]);
    end
    xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
    ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});


elseif plot1 == nChan*nExc+nFRET+nS+1 && nChan > 1% all intensities
    x_axis = 1:size(dat1.trace{1},1);
    if inSec
        rate = p.proj{proj}.frame_rate;
        x_axis = x_axis*rate;
    end
    min_y = Inf;
    max_y = -Inf;
    for l = 1:nExc
        for c = 1:nChan
            %ind = (l-1)+c; % RB 2018-01-03: indizes/colour bug solved
            ind = 2*(l-1)+c;
            plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{ind}, ...
                'Color', dat1.color{ind});
            min_y = min([min_y min(dat1.trace{ind})]);
            max_y = max([max_y max(dat1.trace{ind})]);

            % added by MH, 24.4.2019
            if l==1 && c==1
                set(h.tm.axes_ovrAll_1, 'NextPlot', 'add');
            end
        end
    end
    set(h.tm.axes_ovrAll_1, 'NextPlot', 'replacechildren');
    xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
    ylim(h.tm.axes_ovrAll_1, [min_y max_y]);
    xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
    ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});

elseif plot1 == nChan*nExc+nFRET+nS+2 && nFRET > 1% all FRET
    x_axis = 1:size(dat1.trace{nChan*nExc+1},1);
    if inSec
        rate = p.proj{proj}.frame_rate;
        x_axis = x_axis*rate;
    end
    for n = 1:nFRET
        ind = nChan*nExc+n;
        plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{ind}, ...
            'Color', dat1.color{ind});
        % added by MH, 24.4.2019
        if n==1
            set(h.tm.axes_ovrAll_1, 'NextPlot', 'add');
        end
    end
    set(h.tm.axes_ovrAll_1, 'NextPlot', 'replacechildren');
    xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
    ylim(h.tm.axes_ovrAll_1, [-0.2 1.2]);
    xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
    ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});

elseif (plot1 == nChan*nExc+nFRET+nS+2 && nFRET == 1 && nS > 1) || ...
        (plot1 == nChan*nExc+nFRET+nS+3 && nFRET > 1 && nS > 1)% all S
    x_axis = 1:size(dat1.trace{nChan*nExc+nFRET+1},1);
    if inSec
        rate = p.proj{proj}.frame_rate;
        x_axis = x_axis*rate;
    end
    for n = 1:nS
        ind = nChan*nExc+nFRET+n;
        plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{ind}, ...
            'Color', dat1.color{ind});
        if n==1
            set(h.tm.axes_ovrAll_1, 'NextPlot', 'add');
        end
    end
    set(h.tm.axes_ovrAll_1, 'NextPlot', 'replacechildren');
    xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
    ylim(h.tm.axes_ovrAll_1, [-0.2 1.2]);
    xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
    ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});

elseif (plot1 == nChan*nExc+nFRET+nS+2 && nFRET == 1 && nS == 1) || ...
        (plot1 == nChan*nExc+nFRET+nS+3 && ((nFRET > 1 && nS == 1) ...
        || (nFRET == 1 && nS > 1))) || (plot1 == ...
        nChan*nExc+nFRET+nS+4 && nFRET > 1 && nS > 1) % all FRET & S
    x_axis = 1:size(dat1.trace{nChan*nExc+1},1);
    if inSec
        rate = p.proj{proj}.frame_rate;
        x_axis = x_axis*rate;
    end
    for n = 1:(nFRET+nS)
        ind = nChan*nExc+n;
        plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{ind}, ...
            'Color', dat1.color{ind});
        if n==1
            set(h.tm.axes_ovrAll_1, 'NextPlot', 'add');
        end
    end
    set(h.tm.axes_ovrAll_1, 'NextPlot', 'replacechildren');
    xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
    ylim(h.tm.axes_ovrAll_1, [-0.2 1.2]);
    xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
    ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});
end

% RB 2017-12-15: implement FRET-S-histograms in plot2
if plot2 <= nChan*nExc+nFRET+nS
    bar(h.tm.axes_ovrAll_2, dat2.iv{plot2}, dat2.hist{plot2}, ...
        'FaceColor', dat1.color{plot2}, 'EdgeColor', ...
    dat1.color{plot2});

    xlabel(h.tm.axes_ovrAll_2, dat2.xlabel{plot2});
    ylabel(h.tm.axes_ovrAll_2, dat2.ylabel{plot2}); % RB 2018-01-04:

    xlim(h.tm.axes_ovrAll_2, [dat1.lim{plot2}(1),dat1.lim{plot2}(2)]);
    ylim(h.tm.axes_ovrAll_2, 'auto');
    
else  % draw FRET-S histogram
    cla(h.tm.axes_ovrAll_2);
    %lim = [-0.2 1.2; -0.2,1.2];
    imagesc(dat1.lim{plot2}(1,:),dat1.lim{plot2}(2,:),dat2.hist{plot2},...
        'Parent', h.tm.axes_ovrAll_2);
    if sum(sum(dat2.hist{plot2}))
        set(h.tm.axes_ovrAll_2,'CLim',[min(min(dat2.hist{plot2})) ...
            max(max(dat2.hist{plot2}))]);
    else
        set(h.tm.axes_ovrAll_2,'CLim',[0 1]);
    end

    xlabel(h.tm.axes_ovrAll_2, dat2.xlabel{plot2});
    ylabel(h.tm.axes_ovrAll_2, dat2.ylabel{plot2});

    xlim(h.tm.axes_ovrAll_2, dat1.lim{plot2}(1,:));
    ylim(h.tm.axes_ovrAll_2, dat1.lim{plot2}(2,:));
end

% display histogram parameters
set(h.tm.edit_xlim_low,'string',num2str(dat1.lim{plot2}(1,1)));
set(h.tm.edit_xlim_up,'string',num2str(dat1.lim{plot2}(1,2)));
set(h.tm.edit_xnbiv,'string',num2str(dat1.niv(plot2,1)));
if plot2 > nChan*nExc+nFRET+nS
    set(h.tm.edit_ylim_low,'string',num2str(dat1.lim{plot2}(2,1)),'enable',...
        'on');
    set(h.tm.edit_ylim_up,'string',num2str(dat1.lim{plot2}(2,2)),'enable',...
        'on');
    set(h.tm.edit_ynbiv,'string',num2str(dat1.niv(plot2,2)),'enable','on');
    set(h.tm.text4,'enable','on');
else
    set(h.tm.edit_ylim_low,'string','','enable','off');
    set(h.tm.edit_ylim_up,'string','','enable','off');
    set(h.tm.edit_ynbiv,'string','','enable','off');
    set(h.tm.text4,'enable','off');
end

end


%% plots in tool "Auto sorting"

function plotData_autoSort(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);


dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

if ind<=(nChan*nExc+nFRET+nS) % 1D histograms
    if j==1 % original data
        P = dat2.hist{ind};
        iv = dat2.iv{ind};
        
    else % calculated/discretized data
        if isempty(dat3.hist{ind,j-1})
            setContPan(cat(2,'No calculated data available: start ',...
                'calculation or select another type of calculation.'),...
                'error',h_fig);
            return;
        end
        P = dat3.hist{ind,j-1};
        iv = dat3.iv{ind,j-1};
    end
    
    % plot histogram
    bar(h.tm.axes_histSort,iv,P,'edgecolor',dat1.color{ind},'facecolor',...
        dat1.color{ind});
    
    % set axis labels as in overall plot
    xlabel(h.tm.axes_histSort, dat2.xlabel{ind});
    ylabel(h.tm.axes_histSort, dat2.ylabel{ind});
    
    % set axis limits
    xlim(h.tm.axes_histSort, [iv(1),iv(end)]);
    ylim(h.tm.axes_histSort, 'auto');

    % add mask
    yaxis = get(h.tm.axes_histSort,'ylim');
    drawMask(h_fig,[iv(1) iv(end)],yaxis,1);
    
    str_d = '1D';
    
else % E-S histograms
    
    if j==1 % original data
        P2D = dat2.hist{ind};
        ivx = dat2.iv{ind}{1};
        ivy = dat2.iv{ind}{2};
        
    else % calculated/discretized data
        if isempty(dat3.hist{ind,j-1})
            setContPan(cat(2,'No calculated data available: start ',...
                'calculation or select another type of calculation.'),...
                'error',h_fig);
            return;
        end
        P2D = dat3.hist{ind,j-1};
        ivx = dat3.iv{ind,j-1}{1};
        ivy = dat3.iv{ind,j-1}{2};
    end
       
    imagesc([ivx(1),ivx(end)],[ivy(1),ivy(end)],P2D,'parent',...
        h.tm.axes_histSort,'ButtonDownFcn',...
        {@axes_histSort_ButtonDownFcn,h_fig});
    
    % plot range
    drawMask(h_fig,[ivx(1) ivx(end)],[ivy(1) ivy(end)],2);
    
    if sum(sum(P2D))
        set(h.tm.axes_histSort,'CLim',[0,max(max(P2D))]);
    else
        set(h.tm.axes_histSort,'CLim',[0,1]);
    end

    xlabel(h.tm.axes_histSort,dat2.xlabel{ind});
    ylabel(h.tm.axes_histSort,dat2.ylabel{ind});

    xlim(h.tm.axes_histSort,[ivx(1),ivx(end)]);
    ylim(h.tm.axes_histSort,[ivy(1),ivy(end)]);
    
    str_d = '2D';
end

% display histogram parameters
if j==1
    lim = dat1.lim{ind};
    niv = dat1.niv(ind,:);
else
    lim = dat3.lim{ind,j-1};
    niv = dat3.niv(ind,:,j-1);
end
set(h.tm.edit_xlow,'string',num2str(lim(1,1)));
set(h.tm.edit_xup,'string',num2str(lim(1,2)));
set(h.tm.edit_xniv,'string',num2str(niv(1)));
if ind>(nChan*nExc+nFRET+nS)
    set(h.tm.edit_ylow,'string',num2str(lim(2,1)));
    set(h.tm.edit_yup,'string',num2str(lim(2,2)));
    set(h.tm.edit_yniv,'string',num2str(niv(2)));
    set([h.tm.text_ylow,h.tm.edit_ylow,h.tm.text_yup,h.tm.edit_yup,...
        h.tm.text_yniv,h.tm.edit_yniv],'enable','on');
else
    set([h.tm.edit_ylow,h.tm.edit_yup,h.tm.edit_yniv],'string','');
    set([h.tm.text_ylow,h.tm.edit_ylow,h.tm.text_yup,h.tm.edit_yup,...
        h.tm.text_yniv,h.tm.edit_yniv],'enable','off');
end

title(h.tm.axes_histSort,cat(2,str_d,...
    '-histogram for molecule selection at last update'));

end

function drawMask(h_fig,x,y,D)

% defaults
clr = [0.5,0.5,0.5];
a = 0.5;
width = 2;
fcn = {@axes_histSort_ButtonDownFcn,h_fig};

h = guidata(h_fig);

xrange = [str2num(get(h.tm.edit_xrangeLow,'string')) ...
    str2num(get(h.tm.edit_xrangeUp,'string'))];
yrange = [str2num(get(h.tm.edit_yrangeLow,'string')) ...
    str2num(get(h.tm.edit_yrangeUp,'string'))];

xrange(xrange==-Inf) = x(1)-1;
yrange(yrange==-Inf) = y(1)-1;
xrange(xrange==Inf) = x(2)+1;
yrange(yrange==Inf) = y(2)+1;

set(h.tm.axes_histSort,'nextplot','add');

switch D
    case 1 %1D mask
        xdata = [x(1)-1,xrange(1),xrange(1),xrange(2),xrange(2),x(2)+1];
        ydata = [y(2)+1,y(2)+1,-1,-1,y(2)+1,y(2)+1];
        area(h.tm.axes_histSort,xdata,ydata,'edgecolor',clr,'facecolor',...
            clr,'facealpha',a,'linewidth',width,'buttondownfcn',fcn);
        set(h.tm.axes_histSort,'ylim',[0,y(2)]);
    
    case 2 % 2D mask
        area(h.tm.axes_histSort,[x(1),xrange(1)],[y(2),y(2)],'facecolor',clr,...
            'facealpha',a,'linestyle','none','basevalue',y(1),...
            'buttondownfcn',fcn);

        area(h.tm.axes_histSort,[xrange(1),xrange(2)],[yrange(1),yrange(1)],'facecolor',...
            [0.5,0.5,0.5],'facealpha',a,'linestyle','none','basevalue',...
            y(1),'ButtonDownFcn',{@axes_histSort_ButtonDownFcn,h_fig});

        area(h.tm.axes_histSort,[xrange(2),x(2)],[y(2),y(2)],'facecolor',clr,...
            'facealpha',a,'linestyle','none','basevalue',y(1),...
            'buttondownfcn',fcn);

        % draw upper area: only patch allows transparency AND different baseline
        patch(h.tm.axes_histSort,'xdata',[xrange(1),xrange(2),xrange(2),xrange(1)],'ydata',...
            [y(2),y(2),yrange(2),yrange(2)],'facecolor',clr,'facealpha',a,'linestyle',...
            'none','buttondownfcn',fcn);

        % draw recatngle around the target
        pos = [xrange(1),yrange(1),(xrange(2)-xrange(1)),(yrange(2)-yrange(1))];
        pos(pos==Inf) = max([x(2) y(2)]);
        pos(pos==-Inf) = min([x(1) y(1)]);

        rectangle(h.tm.axes_histSort,'position',pos,'edgecolor',clr,...
            'linewidth',width,'buttondownfcn',fcn);
end

set(h.tm.axes_histSort,'nextplot','replacechildren');

end


%% plots in tool "Video view"

function plotData_videoView(h_fig)

% defaults 
width = 2;
a = 0.8;

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
clr = h.tm.molTagClr;
coord = p.proj{proj}.coord;
molTags = h.tm.molTag;

% abort if no average image is available in project
if ~(isfield(p.proj{proj},'aveImg') && size(p.proj{proj}.aveImg,2)==nExc)
    return;
end

% get proper average image
exc = get(h.tm.popupmenu_VV_exc,'value');
if exc>nExc
    img = p.proj{proj}.aveImg{1}/nExc;
    for l = 2:nExc
        img = img + p.proj{proj}.aveImg{l}/nExc;
    end
else
    img = p.proj{proj}.aveImg{exc};
end

% get image size
[h_vid,w_vid] = size(img);

% get image limits in y-direction
y_data = [0.5,h_vid-0.5];

% plot image
imagesc(h.tm.axes_videoView,[0.5,w_vid-0.5],y_data,img);

% plot channel bounds
set(h.tm.axes_videoView,'nextplot','add');
for c = 1:nChan
    x_data = repmat(c*(w_vid/nChan),1,2);
    plot(h.tm.axes_videoView,x_data,y_data,'--w');
end

% get proper coordinates selection to plot
meth = get(h.tm.popupmenu_VV_mol,'value');
switch meth
    case 1 % selected molecules
        incl = h.tm.molValid;
    case 2 % unselected molecules
        incl = ~h.tm.molValid;
    case 3 % all molecules
        incl = true(size(h.tm.molValid));
end

% plot untagged coordinates
if get(h.tm.checkbox_VV_tag0,'value')
    mols = ~sum(molTags,2)' & incl;
    x_coord = coord(mols,1:2:end);
    y_coord = coord(mols,2:2:end);
    scatter(h.tm.axes_videoView,x_coord(:),y_coord(:),'marker','o',...
        'markeredgecolor','white','linewidth',width,'markeredgealpha',a);
end

% plot tagged coordinates
if isfield(h.tm,'checkbox_VV_tag') && ishandle(h.tm.checkbox_VV_tag(1)) && ...
        ~isempty(coord)
    nTag = numel(h.tm.checkbox_VV_tag);
    for t = 1:nTag
        if get(h.tm.checkbox_VV_tag(t),'value')
            mols = molTags(:,t)' & incl;
            x_coord = coord(mols,1:2:end);
            y_coord = coord(mols,2:2:end);
            scatter(h.tm.axes_videoView,x_coord(:),y_coord(:),'marker','o',...
                'markeredgecolor',hex2rgb(clr{t})/255,'linewidth',width,...
                'markeredgealpha',a);
        end
    end
end
set(h.tm.axes_videoView,'nextplot','replacechildren');

% set image limits
xlim(h.tm.axes_videoView,[0,size(img,2)+1]);
ylim(h.tm.axes_videoView,[0,size(img,1)+1]);



end


%% popup & list strings for tool "Overview"

function update_taglist_OV(h_fig, nb_mol_disp)

% Last update by MH, 24.4.2019
% >> add colors to tag lists
%
% update by FS, 25.4.2018
% >> add colors to tag popupmenu
%

h = guidata(h_fig);
    
for i = nb_mol_disp:-1:1
    % added by FS, 25.4.2018
    str_lst = colorTagNames(h_fig);
    nTag = numel(str_lst);
    currTag = get(h.tm.popup_molNb(i),'value');
    if currTag>nTag
        currTag = nTag;
    end
    set(h.tm.popup_molNb(i), 'String', str_lst, 'Value', currTag);
    
    mol = str2num(get(h.tm.checkbox_molNb(i), 'String'));
    str_lst = colorTagLists_OV(h_fig,mol);
    nTag = numel(str_lst);
    currTag = get(h.tm.listbox_molLabel(i),'value');
    if currTag>nTag
        currTag = nTag;
    end
    set(h.tm.listbox_molLabel(i), 'String', str_lst, 'Value', currTag)
    
end
end

function str_lst = colorTagLists_OV(h_fig,i)
% Defines colored strings for listboxes listing tag names in tool
% "Overview"

h = guidata(h_fig);
molTag = h.tm.molTag;
tagNames = h.tm.molTagNames;
tagClr = h.tm.molTagClr;
nTag = numel(tagNames);

str_lst = {};
for t = 1:nTag
    if molTag(i,t)
        str_lst = [str_lst cat(2,'<html><span bgcolor=',tagClr{t},'>',...
            '<font color="white">',tagNames{t},'</font></body></html>')];
    end
end
if ~sum(molTag(i,:))
    str_lst = {'no tag'};
end

end

function str_lst = colorTagNames(h_fig)
% Defines colored strings for popupmenus listing tag names

% Last update by MH, 24.4.2019
% >> fetch tag colors in project parameters
% >> remove "unlabelled" tag
%
% Created by FS, 24.4.2018
%
%

h = guidata(h_fig);

% modified by MH, 24.4.2019
% colorlist = {'transparent', '#4298B5', '#DD5F32', '#92B06A', '#ADC4CC', '#E19D29'};
colorlist = h.tm.molTagClr;

% added by MH, 24.4.2019
nTag = numel(h.tm.molTagNames);

str_lst = cell(1,nTag);

% cancelled by MH, 24.4.2019
% str_lst{1} = h.tm.molTagNames{1};

% modified by MH, 24.4.2019
% for k = 2:length(h.tm.molTagNames)
for k = 1:nTag
    
    str_lst{k} = ['<html><body  bgcolor="' colorlist{k} '">' ...
        '<font color="white">' h.tm.molTagNames{k} '</font></body></html>'];
end

% added by MH, 24.4.2019
if isempty(str_lst)
    str_lst = {'no default tag'};
end
end


function str_lst = getStrPop_select(h_fig)
% Defines string in automatic molecule selection popupmenu

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);
tagNames = h.tm.molTagNames;
tagClr = h.tm.molTagClr;
nTag = numel(tagNames);

str_lst = {'current','all','none','inverse'};
for t = 1:nTag
    str_lst = [str_lst cat(2,'<html>add <span bgcolor=',tagClr{t},'>',...
            '<font color="white">',tagNames{t},'</font></body></html>')];
end
for t = 1:nTag
    str_lst = [str_lst cat(2,'<html>remove <span bgcolor=',tagClr{t},'>',...
            '<font color="white">',tagNames{t},'</font></body></html>')];
end
end


function str_out = getStrPlot_overall(h_fig)
% Return popupmenu string for overall plot in str_out{1} for axes1 and
% str_out{2} for axes2

% update: by RB, 3.1.2018
% >> new variable to expand popupmenu entries
%
% update: by RB, 15.12.2017 
% >> review string in popupmenu of axes 2 for ES hitograms

% get guidata
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;

% get variables from the indiviudal project `proj`
nChan = p.proj{proj}.nb_channel;
exc = p.proj{proj}.excitations;
labels = p.proj{proj}.labels;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
clr = p.proj{proj}.colours;

str_plot = {}; % string for popup menu

% String for Intensity Channels in popup menu
for l = 1:nExc % number of excitation channels
    for c = 1:nChan % number of emission channels
        clr_bg_c = sprintf('rgb(%i,%i,%i)', ...
            round(clr{1}{l,c}(1:3)*255));
        clr_fbt_c = sprintf('rgb(%i,%i,%i)', ...
            [255 255 255]*sum(double( ...
            clr{1}{l,c}(1:3) <= 0.5)));
        str_plot = [str_plot ...
            ['<html><span style= "background-color: ' ...
            clr_bg_c ';color: ' clr_fbt_c ';"> ' labels{c} ...
            ' at ' num2str(exc(l)) 'nm</span></html>']];
    end
end

% String for FRET Channels in popup menu
for n = 1:nFRET
    clr_bg_f = sprintf('rgb(%i,%i,%i)', ...
        round(clr{2}(n,1:3)*255));
    clr_fbt_f = sprintf('rgb(%i,%i,%i)', ...
        [255 255 255]*sum(double( ...
        clr{2}(n,1:3) <= 0.5)));
    str_plot = [str_plot ['<html><span style= "background-color: '...
        clr_bg_f ';color: ' clr_fbt_f ';">FRET ' labels{FRET(n,1)} ...
        '>' labels{FRET(n,2)} '</span></html>']];
end
% String for Stoichiometry Channels in popup menu
for n = 1:nS
    clr_bg_s = sprintf('rgb(%i,%i,%i)', ...
        round(clr{3}(n,1:3)*255));
    clr_fbt_s = sprintf('rgb(%i,%i,%i)', ...
        [255 255 255]*sum(double( ...
        clr{3}(n,1:3) <= 0.5)));
    str_plot = [str_plot ['<html><span style= "background-color: '...
        clr_bg_s ';color: ' clr_fbt_s ';">S ' labels{S(n)} ...
        '</span></html>']];
end
% String for all Intensity Channels in popup menu 
if nChan > 1 || nExc > 1
    str_plot = [str_plot 'all intensity traces'];
end
% String for all FRET Channels in popup menu
if nFRET > 1
    str_plot = [str_plot 'all FRET traces'];
    dat1.ylabel{size(str_plot,2)} = 'FRET';
    % no dat2.xlabel{size(str_plot,2)} = 'FRET'; % RB 2018-01-04
end
% String for all Stoichiometry Channels in popup menu
if nS > 1
    str_plot = [str_plot 'all S traces'];
    dat1.ylabel{size(str_plot,2)} = 'S';
    % no dat2.xlabel{size(str_plot,2)} = 'S'; % RB 2018-01-04
end
% String for all FRET and Stoichiometry Channels in popup menu
if nFRET > 0 && nS > 0
    str_plot = [str_plot 'all FRET & S traces'];
    dat1.ylabel{size(str_plot,2)} = 'FRET or S';
    % no dat2.xlabel{size(str_plot,2)} = 'FRET or S'; % RB 2018-01-04
end
% String for Stoichiometry-FRET Channels in popup menu
% RB 2017-12-15: str_plot including FRET-S-histograms in popupmenu (only corresponding SToichiometry FRET values e.g. FRET:Cy3->Cy5 and S:Cy3->Cy5 not FRET:Cy3->Cy5 and S:Cy3->Cy7 etc.)   )

% corrected by MH, 27.3.2019
%     for s = 1:nS
for fret = 1:nFRET
    for s = 1:nS
        clr_bg_s = sprintf('rgb(%i,%i,%i)', ...
            round(clr{3}(s,1:3)*255));
        clr_bg_e = sprintf('rgb(%i,%i,%i)', ...
            round(clr{2}(fret,1:3)*255));
        clr_fbt_s = sprintf('rgb(%i,%i,%i)', ...
            [255 255 255]*sum(double( ...
            clr{3}(s,1:3) <= 0.5)));
        clr_fbt_e = sprintf('rgb(%i,%i,%i)', ...
            [255 255 255]*sum(double( ...
            clr{2}(fret,1:3) <= 0.5)));
        str_plot =  [str_plot ['<html><span style= "background-color: '...
            clr_bg_e ';color: ' clr_fbt_e ';">FRET ' labels{FRET(fret,1)} ...
            '>' labels{FRET(fret,2)} '</span>-<span style= "background-color: '...
            clr_bg_s ';color: ' clr_fbt_s ';">S ' labels{S(s)} ...
            '</span></html>']];
    end
end

str_out{1} = str_plot(1:(size(str_plot,2)-nFRET*nS));
str_out{2} = [str_plot(1:(nChan*nExc+nFRET+nS)) ...
    str_plot((size(str_plot,2)-nFRET*nS+1):size(str_plot,2))];

end

%% popup & list strings for tool "Auto sorting"

function update_taglist_AS(h_fig)

h = guidata(h_fig);

str_lst = colorRangeList(h_fig);
R = numel(str_lst);
range = get(h.tm.listbox_ranges,'value');
if range>R
    range = R;
end
set(h.tm.listbox_ranges,'string',str_lst,'value',range);

str_lst = colorTagNames(h_fig);
nTag = numel(str_lst);
currTag = get(h.tm.popupmenu_defTagPop,'value');
if currTag>nTag
    currTag = nTag;
end
set(h.tm.popupmenu_defTagPop, 'String', str_lst, 'Value', currTag);

str_lst = colorTagLists_AS(h_fig,range);
nTag = numel(str_lst);
currTag = get(h.tm.listbox_popTag,'value');
if currTag>nTag
    currTag = nTag;
end
set(h.tm.listbox_popTag,'string',str_lst,'value',currTag);


end

function str_lst = colorTagLists_AS(h_fig,i)
% Defines colored strings for listboxes listing tag names in tool
% "Auto sorting"

h = guidata(h_fig);
dat3 = get(h.tm.axes_histSort,'userdata');
rangeTag = dat3.rangeTags;
tagNames = h.tm.molTagNames;
tagClr = h.tm.molTagClr;
nTag = numel(tagNames);

if size(rangeTag,1)<i
    str_lst = {'no tag'};
    return;
end

str_lst = {};
for t = 1:nTag
    if rangeTag(i,t)
        str_lst = [str_lst cat(2,'<html><span bgcolor=',tagClr{t},'>',...
            '<font color="white">',tagNames{t},'</font></body></html>')];
    end
end
if ~sum(rangeTag(i,:))
    str_lst = {'no tag'};
end
end


function str_lst = colorRangeList(h_fig)
% Defines colored strings for listboxes listing ranges in tool
% "Auto sorting"

h = guidata(h_fig);
dat3 = get(h.tm.axes_histSort,'userdata');
rangeTag = dat3.rangeTags;
tagClr = h.tm.molTagClr;
R = size(rangeTag,1);

if R==0
    str_lst = {'no range'};
    return;
end

str_lst = {};
for r = 1:R
    tags = find(rangeTag(r,:));
    nTag = numel(tags);
    if nTag>0
        str_r = cat(2,'<html><font color="white"><span bgcolor=',...
            tagClr{tags(1)},'>',num2str(r),'</span></font>');
        for t = 2:nTag
            str_r = cat(2,str_r,'<span bgcolor=',tagClr{tags(t)},...
                '>&#160;&#160;</span>');
        end
        str_r = cat(2,str_r,'</html>');
    else
        str_r = num2str(r);
    end
    
    str_lst = [str_lst str_r];
end
end


%% update tag lists in panel "Video view"
function update_taglist_VV(h_fig)

h = guidata(h_fig);

nTag = numel(h.tm.molTagNames);
for t = 1:nTag
    checkbox_VV_tag_Callback(h.tm.checkbox_VV_tag(t),[],h_fig,t);
end

end


%% callbaks for panel "Overall plot"

function pushbutton_update_Callback(obj, evd, h_fig)

% Last update: MH, 24.4.2019
% >> shorten callback by moving content in specific functions 
%    concatenateData, setDataPlotPrm and getStrPlot_overall: this also 
%    avoid re-defining popupmenu string, axis labels and colors everytime 
%    updating the data set
    
    % refresh data set
    ok = concatenateData(h_fig);
    if ~ok
        return;
    end
    
    % plot new data set in "Plot overall"
    plotData_overall(h_fig);
    
    % update panel and plot in "Automatic sorting"
    ud_panRanges(h_fig);
    plotData_autoSort(h_fig);

    % display new histogram limits and bins
    h = guidata(h_fig);
    dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
    plot2 = get(h.tm.popupmenu_axes2, 'Value');
    
    set(h.tm.edit_xlim_low, 'String', dat1.lim{plot2}(1));
    set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(2));
    set(h.tm.edit_xnbiv, 'String', dat1.niv(plot2));
    
end


function popupmenu_axes_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    FRET = p.proj{proj}.FRET;
    nFRET = size(FRET,1);
    S = p.proj{proj}.S;
    nS = size(S,1);
    
    if obj == h.tm.popupmenu_axes2
        plot2 = get(obj, 'Value');
        if plot2 <= nChan*nExc+nFRET+nS
            dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
            set(h.tm.edit_xlim_low, 'String', dat1.lim{plot2}(1));
            set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(2));
            set(h.tm.edit_xnbiv, 'String', dat1.niv(plot2));
        else % double check RB 2018-01-04
            dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
            set(h.tm.edit_xlim_low, 'String',  dat1.lim{plot2}(1,1));
            set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(1,2));
            set(h.tm.edit_xnbiv, 'String', dat1.niv(plot2));
        end
    end
    
    plotData_overall(h_fig);
    
end


function menu_export_Callback(obj, evd, h_fig)

% Last update: by MH, 24.4.2019
% >> save tag colors
%
% update by FS, 24.4.2018
% >> save molecule tags and tag names
%
%

saveNclose = questdlg(['Do you want to export the traces to ' ...
    'MASH and close the trace manager?'], ...
    'Close and export to MASH-FRET', 'Yes', 'No', 'No');

if strcmp(saveNclose, 'Yes')
    h = guidata(h_fig);
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.coord_incl = ...
        h.tm.molValid;
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.molTag = ...
        h.tm.molTag; % added by FS, 24.4.2018
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.molTagNames = ...
        h.tm.molTagNames; % added by FS, 24.4.2018

    % added by MH, 24.4.2019
    h.param.ttPr.proj{h.param.ttPr.curr_proj}.molTagClr = ...
        h.tm.molTagClr;

    h.tm.ud = true;
    guidata(h_fig,h);
    
    updateFields(h.figure_MASH, 'ttPr');
    
    close(h.tm.figure_traceMngr);
end

end


function edit_lim_low_Callback(obj,evd,h_fig,row)

% Last update: by RB, 4.1.2018
% >> adapted for FRET-S-histograms
% >> hist2 rather slow replaced by hist2D
%
%

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
plot2 = get(h.tm.popupmenu_axes2, 'Value');
xlim_low = str2num(get(obj,'String'));

if xlim_low >= dat1.lim{plot2}(row,2)
    setContPan('Lower bound must be lower than higher bound.','error',...
        h_fig);
    return;
end

dat1.lim{plot2}(row,1) = xlim_low;

if plot2 <= nChan*nExc+nFRET+nS
    [dat2.hist{plot2},dat2.iv{plot2}] = getHistTM(dat1.trace{plot2},...
        dat1.lim{plot2},dat1.niv(plot2,1));
    
else%% double check RB 2018-01-04
    ES = [dat1.trace{plot2-nFRET-nS},dat1.trace{plot2-nS}];
    [dat2.hist{plot2},dat2.iv{plot2}] = getHistTM(ES,...
        dat1.lim{plot2},dat1.niv(plot2,[1,2]));
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
plotData_overall(h_fig);
    
end

function edit_lim_up_Callback(obj,evd,h_fig,row)

% Last update: by RB, 4.1.2018
% >> adapted for FRET-S-histograms
% >> hist2 rather slow replaced by hist2D
%
%

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
plot2 = get(h.tm.popupmenu_axes2, 'Value');
lim_up = str2num(get(obj,'String'));

if lim_up <= dat1.lim{plot2}(row,1)
    setContPan('Higher bound must be higher than lower bound.','error',...
        h_fig);
    return;
end

dat1.lim{plot2}(row,2) = lim_up;

if plot2 <= nChan*nExc+nFRET+nS
    [dat2.hist{plot2},dat2.iv{plot2}] = getHistTM(dat1.trace{plot2},...
        dat1.lim{plot2},dat1.niv(plot2,1));
    
else%% double check RB 2018-01-04
    ES = [dat1.trace{plot2-nFRET-nS},dat1.trace{plot2-nS}];
    [dat2.hist{plot2},dat2.iv{plot2}] = getHistTM(ES,...
        dat1.lim{plot2},dat1.niv(plot2,[1,2]));
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
plotData_overall(h_fig);
    
end


function edit_nbiv_Callback(obj,evd,h_fig,col)

% Last update: by RB 5.1.2018
% >> adapted for FRET-S-histograms
% >> hist2 rather slow replaced by hist2D
%
%
    
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
plot2 = get(h.tm.popupmenu_axes2, 'Value');
nbiv = round(str2num(get(obj, 'String')));

if ~isnumeric(nbiv) || nbiv < 1
    setContPan('Number of binning interval must be a number.','error',...
        h_fig);
    return;
end

dat1.niv(plot2,col) = nbiv;

if plot2 <= nChan*nExc+nFRET+nS
    [dat2.hist{plot2},dat2.iv{plot2}] = getHistTM(dat1.trace{plot2},...
        dat1.lim{plot2},dat1.niv(plot2,1));
    
else%% double check RB 2018-01-05
    ES = [dat1.trace{plot2-nFRET-nS},dat1.trace{plot2-nS}];
    [dat2.hist{plot2},dat2.iv{plot2}] = getHistTM(ES,dat1.lim{plot2},...
        dat1.niv(plot2,:));

end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);

plotData_overall(h_fig);

end


%% callbacks for panel "Molecule selection"

function pushbutton_untagAll_Callback(obj, evd, h_fig)

h = guidata(h_fig);

% abort if no molecule tag is defined
if ~sum(sum(h.tm.molTag))
    return;
end

% ask confirmation to user
choice = questdlg({cat(2,'All molecule-specific tags will be lost after ',...
    'completion.'),'',cat(2,'Do you want to continue and remove tags to ',...
    'all molecules?')},'Remove molecule tags','Yes, remove all tags',...
    'Cancel','Cancel');
if ~strcmp(choice,'Yes, remove all tags')
    return;
end

% set all molecule tags to false
h.tm.molTag = false(size(h.tm.molTag));
guidata(h_fig,h);

% update molecule tag lists
nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
update_taglist_OV(h_fig,nb_mol_disp);

% update viveo view plot
plotData_videoView(h_fig);

end


function checkbox_molNb_Callback(obj, evd, h_fig)

% Last update by MH, 24.4.2019
% >> allow molecule tagging even if the molecule unselected
%
% update: FS, 24.4.2018
% >> deactivate the label popupmenu if the molecule is not selected
%
%

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
isBot = nFRET | nS;

mol = str2num(get(obj, 'String'));
[o,ind_h,o] = find(h.tm.checkbox_molNb == obj);
h.tm.molValid(mol) = logical(get(obj, 'Value'));
guidata(h_fig, h);

if get(obj, 'Value')
    shad = [1 1 1];
else
    shad = get(h.tm.checkbox_molNb(ind_h), 'BackgroundColor');
end
set([h.tm.axes_itt(ind_h), h.tm.axes_itt_hist(ind_h)], 'Color', shad);
if isBot
    set([h.tm.axes_frettt(ind_h), h.tm.axes_hist(ind_h)], 'Color', ...
        shad);
end
    
    % deactivate the popupmenu if the molecule is not selected
    % added by FS, 24.4.2018
    % cancelled by MH, 24.4.2019: allow labelling even if not selected
%     if h.tm.molValid(mol) == 0
%         set(h.tm.popup_molNb(ind_h), 'Enable', 'off', 'Value', 1)
%         h.tm.molTag(mol) = 1;
%         guidata(h_fig, h)
%     else
%         set(h.tm.popup_molNb(ind_h), 'Enable', 'on')
%     end

end


function pushbutton_addTag2mol_Callback(obj,evd,h_fig,i)
% Pushbutton adds tag selected in popupmenu to current molecule 

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% get tag to add
tagNames = get(h.tm.popup_molNb(i),'string');
tag = get(h.tm.popup_molNb(i),'value');
if strcmp(tagNames{tag},'no default tag')
    return;
end

% update and save molecule tags
mol = str2num(get(h.tm.checkbox_molNb(i),'String'));
h.tm.molTag(mol,tag) = true;
guidata(h_fig,h);

% update molecule tag lists
nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
update_taglist_OV(h_fig,nb_mol_disp);

% update viveo view plot
plotData_videoView(h_fig);

end


function pushbutton_remLabel_Callback(obj,evd,h_fig,i)
% Pushbutton removes tag selected in molecule-specific listbox

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% get tag to remove
molTagNames = removeHtml(get(h.tm.listbox_molLabel(i),'string'));
tag = get(h.tm.listbox_molLabel(i),'value');
if strcmp(molTagNames{tag},'no tag')
    return;
end

% update and save molecule tags
mol = str2num(get(h.tm.checkbox_molNb(i),'String'));
tagId = find(h.tm.molTag(mol,:));
h.tm.molTag(mol,tagId(tag)) = false;
guidata(h_fig,h);

% update molecule tag lists
nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
update_taglist_OV(h_fig,nb_mol_disp)
end


% cancelled by MH, 24.4.2019: popupmenu is no longer used to set molecule
% tag
% function popup_molTag_Callback(obj, evd, h_fig, ~)
% 
% % Last update: FS, 25.4.2019
% % >> the molecule is passed directly to the callback, since the string 
% %    variable is already occupied with the molecule tags
% %
% % Created by FS, 24.4.2018
% %
% 
%     % the molecule is passed directly to the callback, since the string
%     % variable is already occupied with the molecule tags
%     h = guidata(h_fig);
%     pos_slider = round(get(h.tm.slider, 'Value'));
%     max_slider = get(h.tm.slider, 'Max');
%     cb = get(obj, 'Callback');
%     mol = max_slider-pos_slider+cb{3};
%     h.tm.molTag(mol) = get(obj, 'Value');
%     guidata(h_fig, h);
% end


function pushbutton_reduce_Callback(obj, evd, h_fig)

    h = guidata(h_fig);

    dat = get(obj, 'UserData');

    dat_next.arrow = flipdim(dat.arrow,1);
    dat_next.pos_all = get(h.tm.uipanel_overall, 'Position');
    dat_next.pos_single = get(h.tm.uipanel_overview, 'Position');
    dat_next.tooltip = get(h.tm.pushbutton_reduce, 'TooltipString');
    dat_next.open = abs(dat.open - 1);
    dat_next.visible = get(h.tm.popupmenu_axes1, 'Visible');

    set(obj, 'CData', dat.arrow, 'TooltipString', dat.tooltip, ...
        'UserData', dat_next);
    set(get(h.tm.uipanel_overall, 'Children'), 'Visible', dat.visible);
    set(h.tm.uipanel_overall, 'Position', dat.pos_all);
    set(h.tm.uipanel_overview, 'Position', dat.pos_single);
    
    if dat_next.open
        plotData_overall(h_fig);
        
    else
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
        cla(h.tm.axes_ovrAll_1);
        cla(h.tm.axes_ovrAll_2);
        set(h.tm.axes_ovrAll_1, 'UserData', dat1, 'GridLineStyle', ':');
        set(h.tm.axes_ovrAll_2, 'UserData', dat2, 'GridLineStyle', ':');
    end
    
end


function slider_Callback(obj, evd, h_fig)

% Last update by MH, 24.4.2019
% >> cancel change in popupmenu's background color: no need as width and 
%    height were downscaled to regular dimensions and the line color is
%    given by the checkbox
% >> allow molecule tagging even if the molecule unselected
%
% Last update: by FS, 24.4.2018
% >> deactivate the label popupmenu if the molecule is not selected
%
%

    h = guidata(h_fig);
    nMol = numel(h.tm.molValid);
    
    pos_slider = round(get(obj, 'Value'));
    max_slider = get(obj, 'Max');
    
    nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
    if nb_mol_disp > nMol
        nb_mol_disp = nMol;
    end
    
    for i = 1:nb_mol_disp
        set(h.tm.checkbox_molNb(i), 'String', ...
            num2str(max_slider-pos_slider+i), 'Value', ...
            h.tm.molValid(max_slider-pos_slider+i), 'BackgroundColor', ...
            0.05*[mod(max_slider-pos_slider+i,2) ...
            mod(max_slider-pos_slider+i,2) ...
            mod(max_slider-pos_slider+i,2)]+0.85);
        
        
        % added by FS, 24.4.2018
        % cancelled by MH, 24.4.2019
%         str_lst = colorTagNames(h_fig);
%         if h.tm.molTag(max_slider-pos_slider+i) > length(str_lst)
%             val = 1;
%         else
%             val = h.tm.molTag(max_slider-pos_slider+i);
%         end
%         set(h.tm.popup_molNb(i), 'String', ...
%             str_lst, 'Value', ...
%             val, 'BackgroundColor', ...
%             0.05*[mod(max_slider-pos_slider+i,2) ...
%             mod(max_slider-pos_slider+i,2) ...
%             mod(max_slider-pos_slider+i,2)]+0.85);
        
        % deactivate the popupmenu if the molecule is not selected
        % added by FS, 24.4.2018
        % cancelled by MH, 24.4.2019: allow labelling even if not selected
%         if h.tm.molValid(max_slider-pos_slider+i) == 0
%             set(h.tm.popup_molNb(i), 'Enable', 'off')
%         else
%             set(h.tm.popup_molNb(i), 'Enable', 'on')
%         end
    end
   
    update_taglist_OV(h_fig,nb_mol_disp);
    plotDataTm(h_fig);

end


function edit_nbTotMol_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    nb_mol = numel(h.tm.molValid);

    nb_mol_disp = str2num(get(obj, 'String'));
    if nb_mol_disp > nb_mol
        nb_mol_disp = nb_mol;
    end
    updatePanel_single(h_fig, nb_mol_disp);
    
    nb_mol_page = str2num(get(h.tm.edit_nbTotMol, 'String'));
    if nb_mol <= nb_mol_page || nb_mol_page == 0
        min_step = 1;
        maj_step = 1;
        min_val = 0;
        max_val = 1;
        set(h.tm.slider, 'Visible', 'off');
    else
        set(h.tm.slider, 'Visible', 'on');
        min_val = 1;
        max_val = nb_mol-nb_mol_page+1;
        min_step = 1/(max_val-min_val);
        maj_step = nb_mol_page/(max_val-min_val);
    end
    
    set(h.tm.slider, 'Value', max_val, 'Max', max_val, 'Min', min_val, ...
        'SliderStep', [min_step maj_step]);
    
    plotDataTm(h_fig);

end


function popupmenu_selection_Callback(obj, evd, h_fig)
% Change the current selection according to selected menu

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

meth = get(obj,'value');

if meth>1
    choice = questdlg({cat(2,'After applying the automatic selection mode, ',...
        'the current selection will be lost'),'',cat(2,'Do you want to ',...
        'continue and overwrite the current selection?')},...
        'Change molecule selection','Yes, modify the current selection',...
        'Cancel','Cancel');
    if ~strcmp(choice,'Yes, modify the current selection')
        return;
    end
else
    return;
end

switch meth
    case 2 % all
        h.tm.molValid(1:end) = true;
    case 3 % none
        h.tm.molValid(1:end) = false;
    case 4 % inverse
        h.tm.molValid = ~h.tm.molValid; 
end

if meth>4
    nTag = numel(h.tm.molTagNames);
    
    if meth<=4+nTag % add tag-based selection
        tag = meth - 4;
        h.tm.molValid(h.tm.molTag(:,tag)') = true;
        
    else % remove tag-based selection
        tag = meth - 4 - nTag;
        h.tm.molValid(h.tm.molTag(:,tag)') = false;
    end
end

set(obj,'value',1);

guidata(h_fig,h);
plotDataTm(h_fig);

end

% cancelled by MH, 24.4.2019: replace "all" checkbox and "inverse
% selection" pushbutton by a popupmenu
% function checkbox_all_Callback(obj, evd, h_fig)
% 
% % Last update by MH, 24.4.2019
% % >> allow molecule tagging even if the molecule unselected
% %
% % Last update: by FS 25.4.2018
% % >> deactivate the label popupmenu if the molecule is not selected
% %
% %
% 
%     h = guidata(h_fig);
%     if get(obj, 'Value')
%         h.tm.molValid = true(size(h.tm.molValid));
%     else
%         h.tm.molValid = false(size(h.tm.molValid));
%     end
%     
%     % deactivate the popupmenu if the molecule is not selected
%     % added by FS, 25.4.2018
%     % cancelled by MH, 24.4.2019: allow labelling even if not selected
% %     pos_slider = round(get(h.tm.slider, 'Value'));
% %     max_slider = get(h.tm.slider, 'Max');
% %     nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
% %     for i = nb_mol_disp:-1:1
% %         if h.tm.molValid(max_slider-pos_slider+i) == 0
% %             set(h.tm.popup_molNb(i), 'Enable', 'off', 'Value', 1)
% %             h.tm.molTag(max_slider-pos_slider+i) = 1;
% %         else
% %             set(h.tm.popup_molNb(i), 'Enable', 'on')
% %         end
% %     end
%     
%     guidata(h_fig, h);
%     plotDataTm(h_fig);
% 
% end

% cancelled by MH, 24.4.2019: replace "all" checkbox and "inverse
% selection" pushbutton by a popupmenu
% function pushbutton_all_inverse_Callback(obj, evd, h_fig)
% % Pushbutton to invert the selection of individual molecules
% 
% % Last update by MH, 24.4.2019
% % >> allow molecule tagging even if the molecule unselected
% %
% % update: by FS, 25.4.2018
% % >> deactivate the label popupmenu if the molecule is not selected
% %
% % Created by RB, 5.1.2018
% %
% %
%     
%     h = guidata(h_fig);
%     
%     h.tm.molValid = ~h.tm.molValid;
%     
%     % deactivate the popupmenu if the molecule is not selected
%     % added by FS, 25.4.2018
%     % cancelled by MH, 24.4.2019: allow labelling even if not selected
% %     pos_slider = round(get(h.tm.slider, 'Value'));
% %     max_slider = get(h.tm.slider, 'Max');
% %     nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
% %     for i = nb_mol_disp:-1:1
% %         if h.tm.molValid(max_slider-pos_slider+i) == 0
% %             set(h.tm.popup_molNb(i), 'Enable', 'off', 'Value', 1)
% %             h.tm.molTag(max_slider-pos_slider+i) = 1;
% %         else
% %             set(h.tm.popup_molNb(i), 'Enable', 'on')
% %         end
% %     end
%     
%     guidata(h_fig, h);
%     plotDataTm(h_fig);
% end 


function edit_addMolTag_Callback(obj, evd, h_fig)

% Last update by MH, 24.4.2019
% >> add random colors for tags that exceed tag list
% >> upscale molecule tag structure after adding new tag name
% >> reset edit string to "define a new tag" after adding new tag name
% >> update color field after adding
%
% Created by FS, 25.4.2018
%
%

h = guidata(h_fig);
if ~strcmp(obj.String, 'define a new tag') && ...
        ~ismember(obj.String, h.tm.molTagNames)
    
    % added by MH, 27.4.2019
    if strcmp(obj.String, 'no tag') || strcmp(obj.String, 'no default tag')
        msgbox('Simply, no.');
        set(obj,'string','define a new tag');
        return
    end
    
    h.tm.molTagNames{end+1} = obj.String;

    % added by MH, 24.4.2019
    % add random colors
    nTag = numel(h.tm.molTagNames);
    if numel(h.tm.molTagClr)<nTag
        clr = round(255*rand(1,3));
        h.tm.molTagClr = [h.tm.molTagClr cat(2,'#',...
            num2str(dec2hex(clr(1))),num2str(dec2hex(clr(2))),...
            num2str(dec2hex(clr(3))))];
    end

    % added by MH, 24.4.2019
    % adjust molecule tag structure
    h.tm.molTag = [h.tm.molTag, false(size(h.tm.molTag,1),1)];

    % adjust range tag structure
    dat3 = get(h.tm.axes_histSort,'userdata');
    dat3.rangeTags = [dat3.rangeTags false(size(dat3.rangeTags,1),1)];
    set(h.tm.axes_histSort,'userdata',dat3);

    % added by MH, 24.4.2019
    set(obj,'string','define a new tag');

    guidata(h_fig, h);
    str_lst = colorTagNames(h_fig);
    set(h.tm.popup_molTag,'String',str_lst,'value',numel(str_lst));
    nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
    guidata(h_fig, h);

    update_taglist_OV(h_fig, nb_mol_disp);
    update_taglist_AS(h_fig);
    updatePanel_VV(h_fig);
    update_taglist_VV(h_fig);

    % added by MH, 24.4.2019
    % update color edit field with new current tag
    popup_molTag_Callback(h.tm.popup_molTag,[],h_fig);
    % update string of selection popupmenu
    str_pop = getStrPop_select(h_fig);
    curr_slct = get(h.tm.popupmenu_selection,'value');
    if curr_slct>numel(str_pop)
        curr_slct = numel(str_pop);
    end
    set(h.tm.popupmenu_selection,'value',curr_slct,'string',str_pop);
end
end


function popup_molTag_Callback(obj,evd,h_fig)
% Updates the tag color in corresponding edit field

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% control empty tag
tag = get(obj,'value');
str_pop = get(obj, 'string');
if strcmp(str_pop{tag},'no default tag')
    set(h.tm.edit_tagClr,'string','','enable','off');
    return;
end

% update edit field background color
clr_hex = h.tm.molTagClr{tag}(2:end);
set(h.tm.edit_tagClr,'string',clr_hex,'enable','on','backgroundcolor',...
    hex2rgb(clr_hex)/255,'foregroundcolor','white');

end


function edit_tagClr_Callback(obj,evd,h_fig)
% Defines the tag color with hexadecimal input

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

% control empty tag
tag = get(h.tm.popup_molTag,'value');
str_pop = get(h.tm.popup_molTag, 'string');
if strcmp(str_pop{tag},'no default tag')
    return;
end

% control color value
clr_str = get(obj,'string');
if ~ishexclr(clr_str)
    setContPan(cat(2,'Tag color must be a RGB value in the hexadecimal ',...
        'format (ex:92B06A)'),'error',h_fig);
    return;
end

% save color
h.tm.molTagClr{tag} = cat(2,'#',clr_str);
guidata(h_fig,h);

% update edit field background color
popup_molTag_Callback(h.tm.popup_molTag,[],h_fig);

% update color in default tag popup
str_lst = colorTagNames(h_fig);
set(h.tm.popup_molTag,'String',str_lst);

% update color in molecule tag listboxes and popups
n_mol_disp = str2num(get(h.tm.edit_nbTotMol,'string'));

update_taglist_OV(h_fig,n_mol_disp);
update_taglist_AS(h_fig);
update_taglist_VV(h_fig);

% update color in string of selection popupmenu
str_pop = getStrPop_select(h_fig);
curr_slct = get(h.tm.popupmenu_selection,'value');
if curr_slct>numel(str_pop)
    curr_slct = numel(str_pop);
end
set(h.tm.popupmenu_selection,'value',curr_slct,'string',str_pop);

end


function pushbutton_deleteMolTag_Callback(obj, evd, h_fig)

% Last update by MH, 24.4.2019
% >> downscale molecule tag structure after deleting a tag name
% >> warn and ask user confirmation to delete tag name
% >> allow the absence of default tag in list
% >> update color field after deleting
%
% Created by FS, 25.4.2018
%
%

    h = guidata(h_fig);
    selectMolTag = get(h.tm.popup_molTag, 'Value');
    
    % added by MH, 24.4.2019
    str_pop = get(h.tm.popup_molTag, 'string');
    if strcmp(str_pop{selectMolTag},'no default tag')
        return;
    end
    choice = questdlg({cat(2,'After deleting the molecule tag, the ',...
        'corresponding molecule sorting will be lost.'),'',cat(2,'Do you ',...
        'want to delete tag "',removeHtml(str_pop{selectMolTag}),'" and ',...
        'forget the corresponding molecule sorting?')},'Delete tag',...
        'Yes, forget sorting','Cancel','Cancel');
    if ~strcmp(choice,'Yes, forget sorting')
        return;
    end
    
    % cancelled by MH, 24.4.2019
%     if selectMolTag ~= 1

    h.tm.molTagNames(selectMolTag) = [];
    
    % added by MH, 24.4.2019
    h.tm.molTag(:,selectMolTag) = [];
    h.tm.molTagClr = [h.tm.molTagClr h.tm.molTagClr(selectMolTag)];
    h.tm.molTagClr(selectMolTag) = [];
    % added by MH, 26.4.2019
    dat3 = get(h.tm.axes_histSort,'userdata');
    if size(dat3.rangeTags,2)>=selectMolTag
        dat3.rangeTags(:,selectMolTag) = [];
        set(h.tm.axes_histSort,'userdata',dat3);
    end
    
    guidata(h_fig, h);
    str_lst = colorTagNames(h_fig);
    set(h.tm.popup_molTag, 'Value', 1);
    set(h.tm.popup_molTag, 'String', str_lst);
    nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
    guidata(h_fig, h);
    
    update_taglist_OV(h_fig, nb_mol_disp);
    update_taglist_AS(h_fig);
    updatePanel_VV(h_fig);
    update_taglist_VV(h_fig);
    plotData_videoView(h_fig);
    
    % added by MH, 24.4.2019
    % update color edit field with new current tag
    popup_molTag_Callback(h.tm.popup_molTag,[],h_fig);
    % update string of selection popupmenu
    str_pop = getStrPop_select(h_fig);
    curr_slct = get(h.tm.popupmenu_selection,'value');
    if curr_slct>numel(str_pop)
        curr_slct = numel(str_pop);
    end
    set(h.tm.popupmenu_selection,'value',curr_slct,'string',str_pop);
    
    % cancelled by MH, 24.4.2019
%     end

end


%% callbacks for panel "Auto sorting"


function popupmenu_selectData_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

ind = get(h.tm.popupmenu_selectData,'Value');
j = get(h.tm.popupmenu_selectCalc,'value');

% control the presence of discretized data
if j==6
    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    
    str_axes = 'bottom';
    
    n = 0;
    if ind<=nChan*nExc
        for l = 1:nExc
            for c = 1:nChan
                n = n+1;
                if n==ind
                    break;
                end
            end
        end
        discr = p.proj{proj}.intensities_DTA(:,c:nChan:end,l);
        
        str_axes = 'top';
        
    elseif ind<=(nChan*nExc+nFRET)
        n = ind-nChan*nExc;
        discr = p.proj{proj}.FRET_DTA(:,n:nFRET:end);
        
    elseif ind<=(nChan*nExc+nFRET+nS)
        n = ind-(nChan*nExc+nFRET);
        discr = p.proj{proj}.S_DTA(:,n:nS:end);
        
    else
        n = 0;
        for fret = 1:nFRET
            for s = 1:nS
                n = n+1;
                if n==(ind+nChan*nExc+nFRET+nS)
                    break;
                end
            end
        end
        discr = cat(3,p.proj{proj}.FRET_DTA(:,fret:nFRET:end),...
            p.proj{proj}.S_DTA(:,s:nS:end));
    end
    
    isdiscr = ~all(isnan(sum(sum(discr,3),2)));
    if ~isdiscr
        msgbox({cat(2,'This method requires the individual time-traces ',...
            'in ',str_axes,' axes to be discretized.'),'',cat(2,'Please ',...
            'return to Trace processing and infer the corresponding state',...
            ' trajectories.')},'Missing states trajectories');
        set(obj,'value',get(obj,'userdata'));
            return;
    end
end

set(obj,'userdata',get(obj,'value'));

plotData_autoSort(h_fig);
ud_panRanges(h_fig);

end


function edit_xlow_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

if j==1
    xlim_sup = dat1.lim{ind}(1,2);
else
    xlim_sup = dat3.lim{ind,j-1}(1,2);
end

xlim_low = str2num(get(obj,'String'));

if xlim_low >= xlim_sup
    setContPan('Lower bound must be lower than higher bound.','error',...
        h_fig);
    return;
end

if j==1
    dat1.lim{ind}(1,1) = xlim_low;
else
    dat3.lim{ind,j-1}(1,1) = xlim_low;
end

if ind <= nChan*nExc+nFRET+nS
    if j==1
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
    else
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(...
            dat3.val{ind,j-1},dat3.lim{ind,j-1},dat3.niv(ind,1,j-1));
    end
    
else
    if j==1
        ES = [dat1.trace{ind-nFRET-nS},dat1.trace{ind-nS}];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(ES,dat1.lim{ind},...
            dat1.niv(ind,[1,2]));
    else
        ES = [dat3.val{ind-nFRET-nS,j-1},dat3.val{ind-nS,j-1}];
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(ES,...
            dat3.lim{ind,j-1},dat3.niv(ind,[1,2],j-1));
    end
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

end


function edit_xup_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

if j==1
    xlim_low = dat1.lim{ind}(1,1);
else
    xlim_low = dat3.lim{ind,j-1}(1,1);
end

xlim_sup = str2num(get(obj,'String'));

if xlim_sup<=xlim_low
    setContPan('Higher bound must be higher than lower bound.','error',...
        h_fig);
    return;
end

if j==1
    dat1.lim{ind}(1,2) = xlim_sup;
else
    dat3.lim{ind,j-1}(1,2) = xlim_sup;
end

if ind <= nChan*nExc+nFRET+nS
    if j==1
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
    else
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(...
            dat3.val{ind,j-1},dat3.lim{ind,j-1},dat3.niv(ind,1,j-1));
    end
    
else
    if j==1
        ES = [dat1.trace{ind-nFRET-nS},dat1.trace{ind-nS}];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(ES,dat1.lim{ind},...
            dat1.niv(ind,[1,2]));
    else
        ES = [dat3.val{ind-nFRET-nS,j-1},dat3.val{ind-nS,j-1}];
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(ES,...
            dat3.lim{ind,j-1},dat3.niv(ind,[1,2],j-1));
    end
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

end

function edit_xniv_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

niv = str2num(get(obj,'string'));

if ~(isnumeric(niv) && ~isempty(niv))
    setContPan('Number of bins must be a numeric.','error',h_fig);
    return;
end

if j==1
    dat1.niv(ind,1) = niv;
else
    dat3.niv(ind,1,j-1) = niv;
end

if ind <= nChan*nExc+nFRET+nS
    if j==1
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
    else
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(...
            dat3.val{ind,j-1},dat3.lim{ind,j-1},dat3.niv(ind,1,j-1));
    end
    
else
    if j==1
        ES = [dat1.trace{ind-nFRET-nS},dat1.trace{ind-nS}];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(ES,dat1.lim{ind},...
            dat1.niv(ind,[1,2]));
    else
        ES = [dat3.val{ind-nFRET-nS,j-1},dat3.val{ind-nS,j-1}];
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(ES,...
            dat3.lim{ind,j-1},dat3.niv(ind,[1,2],j-1));
    end
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

end


function edit_ylow_Callback(obj,evd,h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

if j==1
    ylim_sup = dat1.lim{ind}(2,2);
else
    ylim_sup = dat3.lim{ind,j-1}(2,2);
end

ylim_low = str2num(get(obj,'String'));

if ylim_low >= ylim_sup
    setContPan('Lower bound must be lower than higher bound.','error',...
        h_fig);
    return;
end

if j==1
    dat1.lim{ind}(2,1) = ylim_low;
else
    dat3.lim{ind,j-1}(2,1) = ylim_low;
end

if ind <= nChan*nExc+nFRET+nS
    if j==1
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
    else
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(...
            dat3.val{ind,j-1},dat3.lim{ind,j-1},dat3.niv(ind,1,j-1));
    end
    
else
    if j==1
        ES = [dat1.trace{ind-nFRET-nS},dat1.trace{ind-nS}];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(ES,dat1.lim{ind},...
            dat1.niv(ind,[1,2]));
    else
        ES = [dat3.val{ind-nFRET-nS,j-1},dat3.val{ind-nS,j-1}];
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(ES,...
            dat3.lim{ind,j-1},dat3.niv(ind,[1,2],j-1));
    end
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);
end


function edit_yup_Callback(obj,evd,h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

if j==1
    ylim_low = dat1.lim{ind}(2,1);
else
    ylim_low = dat3.lim{ind,j-1}(2,1);
end

ylim_sup = str2num(get(obj,'String'));

if ylim_sup<=ylim_low
    setContPan('Higher bound must be higher than lower bound.','error',...
        h_fig);
    return;
end

if j==1
    dat1.lim{ind}(2,2) = ylim_sup;
else
    dat3.lim{ind,j-1}(2,2) = ylim_sup;
end

if ind <= nChan*nExc+nFRET+nS
    if j==1
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
    else
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(...
            dat3.val{ind,j-1},dat3.lim{ind,j-1},dat3.niv(ind,1,j-1));
    end
    
else
    if j==1
        ES = [dat1.trace{ind-nFRET-nS},dat1.trace{ind-nS}];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(ES,dat1.lim{ind},...
            dat1.niv(ind,[1,2]));
    else
        ES = [dat3.val{ind-nFRET-nS,j-1},dat3.val{ind-nS,j-1}];
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(ES,...
            dat3.lim{ind,j-1},dat3.niv(ind,[1,2],j-1));
    end
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);
end


function edit_yniv_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

niv = str2num(get(obj,'string'));

if ~(isnumeric(niv) && ~isempty(niv))
    setContPan('Number of bins must be a numeric.','error',h_fig);
    return;
end

if j==1
    dat1.niv(ind,2) = niv;
else
    dat3.niv(ind,2,j-1) = niv;
end

if ind <= nChan*nExc+nFRET+nS
    if j==1
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
    else
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(...
            dat3.val{ind,j-1},dat3.lim{ind,j-1},dat3.niv(ind,1,j-1));
    end
    
else
    if j==1
        ES = [dat1.trace{ind-nFRET-nS},dat1.trace{ind-nS}];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(ES,dat1.lim{ind},...
            dat1.niv(ind,[1,2]));
    else
        ES = [dat3.val{ind-nFRET-nS,j-1},dat3.val{ind-nS,j-1}];
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(ES,...
            dat3.lim{ind,j-1},dat3.niv(ind,[1,2],j-1));
    end
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);

end


%% callbacks for panel "Ranges"

function ud_panRanges(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = numel(p.proj{proj}.S);

dat3 = get(h.tm.axes_histSort,'userdata');
data = get(h.tm.popupmenu_selectData,'value');
calc = get(h.tm.popupmenu_selectCalc,'value');

prm = dat3.range;
if isempty(prm)
    R = 0;
else
    R = size(prm,1);
end

if data>(nChan*nExc+nFRET+nS) % 2D histogram
    set([h.tm.text_yrangeLow,h.tm.edit_yrangeLow,h.tm.text_yrangeUp,...
        h.tm.edit_yrangeUp],'enable','on');
else
    set([h.tm.text_yrangeLow,h.tm.edit_yrangeLow,h.tm.text_yrangeUp,...
        h.tm.edit_yrangeUp],'enable','off');
end

if calc==1 || calc==6 % trajectories
    set([h.tm.text_conf1,h.tm.text_conf2,h.tm.popupmenu_units,...
        h.tm.popupmenu_cond,h.tm.edit_conf1,h.tm.text_and,...
        h.tm.edit_conf2],'enable','on');

    cond = get(h.tm.popupmenu_cond,'value');
    if cond==3 % between
        set([h.tm.text_and,h.tm.edit_conf2],'enable','on');
    else
        set([h.tm.text_and,h.tm.edit_conf2],'enable','off');
    end

else
    set([h.tm.text_conf1,h.tm.text_conf2,h.tm.popupmenu_units,...
        h.tm.popupmenu_cond,h.tm.edit_conf1,h.tm.text_and,...
        h.tm.edit_conf2],'enable','off');
end

disp('sort molecules...');
molIncl = ud_popCalc(h_fig);
disp('sorting complete!');

nMol = sum(molIncl);
str_mol = cat(2,'subgroup size: ',num2str(nMol),' molecule');
if nMol>1
    str_mol = cat(2,str_mol,'s');
end
set(h.tm.text_Npop,'string',str_mol);

if nMol==0
    set(h.tm.pushbutton_saveRange,'enable','off');

else
    set(h.tm.pushbutton_saveRange,'enable','on');
end

update_taglist_AS(h_fig);

if R==0
    set([h.tm.pushbutton_dismissRange,h.tm.listbox_ranges,h.tm.text_pop,...
        h.tm.text_tag,h.tm.pushbutton_addTag2pop,h.tm.popupmenu_defTagPop,...
        h.tm.listbox_popTag,h.tm.pushbutton_remPopTag,...
        h.tm.pushbutton_applyTag],'enable','off');

else
    set([h.tm.pushbutton_dismissRange,h.tm.listbox_ranges,h.tm.text_pop,...
        h.tm.text_tag,h.tm.pushbutton_addTag2pop,h.tm.popupmenu_defTagPop,...
        h.tm.listbox_popTag,h.tm.pushbutton_remPopTag,...
        h.tm.pushbutton_applyTag],'enable','on');
end
   
end


function molIncl = ud_popCalc(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
exc = p.proj{proj}.excitations;
nExc = numel(exc);
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = numel(S);

% get stored data
dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

% get method settings
data = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

prm = [str2num(get(h.tm.edit_xrangeLow,'string')), ...
    str2num(get(h.tm.edit_xrangeUp,'string'));...
    str2num(get(h.tm.edit_yrangeLow,'string')), ...
    str2num(get(h.tm.edit_yrangeUp,'string'));...
    get(h.tm.popupmenu_units,'value')...
    get(h.tm.popupmenu_cond,'value');...
    str2num(get(h.tm.edit_conf1,'string')), ...
    str2num(get(h.tm.edit_conf2,'string'))];

% molecule selection at last update
slct = dat3.slct;
incl =  p.proj{proj}.bool_intensities(:,slct);

if j==1 % original time traces
    if data<=(nChan*nExc+nFRET+nS) % 1D
        trace = dat1.trace{data};
        
    else % 2D
        ind = data-nChan*nExc-nFRET-nS;
        data_e = ceil(ind/nS)+nChan*nExc;
        data_s = ind-(ceil(ind/nS)-1)*nS+nChan*nExc+nFRET;
        trace = [dat1.trace{data_e} dat1.trace{data_s}];
    end
    molIncl = molsWithConf(trace,'trace',prm,incl);
    
elseif j==6 % state trajectories
    if data<=(nChan*nExc+nFRET+nS) % 1D
        trace = dat3.val{data,j-1};
    else % 2D
        ind = data-nChan*nExc-nFRET-nS;
        data_e = ceil(ind/nS)+nChan*nExc;
        data_s = ind-(ceil(ind/nS)-1)*nS+nChan*nExc+nFRET;
        trace = [dat3.val{data_e,j-1} dat3.val{data_s,j-1}];
    end
    molIncl = molsWithConf(trace,'trace',prm,incl);
    
else % calculated values
    if data<=(nChan*nExc+nFRET+nS) % 1D
        values = dat3.val{data,j-1};
    else
        ind = data-nChan*nExc-nFRET-nS;
        data_e = ceil(ind/nS) + nChan*nExc;
        data_s = ind - (ceil(ind/nS)-1)*nS + nChan*nExc+nFRET;
        values = [dat3.val{data_e,j-1} dat3.val{data_s,j-1}] ;
    end
    molIncl = molsWithConf(values,'value',prm);
end

end


function molIncl = molsWithConf(dat,dat_type,prm,varargin)

units = prm(3,1);
meth = prm(3,2);

switch dat_type
    
    case 'trace'
        incl = varargin{1};
        M = size(incl,2);
        molIncl = false(1,M);
        
        id_end = 0;
        for m = 1:M
            id_start = id_end + 1;
            id_end = id_start + sum(incl(:,m)) - 1;
            N0 = numel(id_start:id_end);
            
            if size(dat,2)==1 % 1D
                N = sum(dat(id_start:id_end,1)>=prm(1,1) & ...
                    dat(id_start:id_end,1)<=prm(1,2));
            else % 2D
                N = sum(dat(id_start:id_end,1)>=prm(1,1) & ...
                    dat(id_start:id_end,1)<=prm(1,2) & ...
                    dat(id_start:id_end,2)>=prm(2,1) & ...
                    dat(id_start:id_end,2)<=prm(2,2));
            end
                
            switch meth
                case 1 % at least
                    if units==1 && 100*(N/N0)>=prm(4,1) % percent
                        molIncl(m) = true;
                    elseif units==2 && N>=prm(4,1) % absolute count
                        molIncl(m) = true;
                    end

                case 2 % at most
                    if units==1 && 100*(N/N0)<=prm(4,1) % percent
                        molIncl(m) = true;
                    elseif units==2 && N<=prm(4,1) % absolute count
                        molIncl(m) = true;
                    end

                case 3 % between
                    if units==1 && 100*(N/N0)>=prm(4,1) && ...
                            100*(N/N0)<=prm(4,2) % percent
                        molIncl(m) = true;
                    elseif units==2 && N>=prm(4,1) && ...
                            N<=prm(4,2) % absolute count
                        molIncl(m) = true;
                    end
            end
        end
        
    case 'value'
        if size(dat,2)==1 % 1D
            molIncl = dat'>=prm(1,1) & dat'<=prm(1,2);
        else % 2D
            molIncl = dat(:,1)'>=prm(1,1) & dat(:,1)'<=prm(1,2) & ...
                dat(:,2)'>=prm(2,1) & dat(:,2)'<=prm(2,2);
        end
        
end

end


function pushbutton_saveRange_Callback(obj,evd,h_fig)

h = guidata(h_fig);
dat3 = get(h.tm.axes_histSort,'userdata');
data = get(h.tm.popupmenu_selectData,'value');
calc = get(h.tm.popupmenu_selectCalc,'value');
nTag = numel(h.tm.molTagNames);

dat3.range = [dat3.range;cell(1,2)];
dat3.range{end,1} = [str2num(get(h.tm.edit_xrangeLow,'string')), ...
    str2num(get(h.tm.edit_xrangeUp,'string'));...
    str2num(get(h.tm.edit_yrangeLow,'string')), ...
    str2num(get(h.tm.edit_yrangeUp,'string'));...
    get(h.tm.popupmenu_units,'value')...
    get(h.tm.popupmenu_cond,'value');...
    str2num(get(h.tm.edit_conf1,'string')), ...
    str2num(get(h.tm.edit_conf2,'string'))];
dat3.range{end,2} = [data,calc];
dat3.rangeTags = [dat3.rangeTags;false(1,nTag)];

set(h.tm.axes_histSort,'userdata',dat3);

R = size(dat3.range,1);
set(h.tm.listbox_ranges,'string',cellstr(num2str((1:R)'))','value',R);
ud_panRanges(h_fig);

end


function pushbutton_dismissRange_Callback(obj,evd,h_fig)

h = guidata(h_fig);

range = get(h.tm.listbox_ranges,'value');
str_range = get(h.tm.listbox_ranges,'string');
if strcmp(str_range{range},'no range')
    return;
end

dat3 = get(h.tm.axes_histSort,'userdata');

dat3.range(range,:) = [];
dat3.rangeTags(range,:) = [];

set(h.tm.axes_histSort,'userdata',dat3);

ud_panRanges(h_fig);
plotData_autoSort(h_fig);

end


function listbox_ranges_Callback(obj,evd,h_fig)

h = guidata(h_fig);

range = get(obj,'value');
str = get(obj,'string');
if strcmp(str{range},'no range')
    return;
end

dat3 = get(h.tm.axes_histSort,'userdata');
prm = dat3.range(range,:);

set(h.tm.edit_xrangeLow,'string',num2str(prm{1}(1,1)));
set(h.tm.edit_xrangeUp,'string',num2str(prm{1}(1,2)));
set(h.tm.edit_yrangeLow,'string',num2str(prm{1}(2,1)));
set(h.tm.edit_yrangeUp,'string',num2str(prm{1}(2,2)));
set(h.tm.popupmenu_units,'value',prm{1}(3,1));
set(h.tm.popupmenu_cond,'value',prm{1}(3,2));
set(h.tm.edit_conf1,'string',num2str(prm{1}(4,1)));
set(h.tm.edit_conf2,'string',num2str(prm{1}(4,2)));

set(h.tm.popupmenu_selectData,'value',prm{2}(1));
set(h.tm.popupmenu_selectCalc,'value',prm{2}(2));

popupmenu_selectData_Callback(h.tm.popupmenu_selectData,[],h_fig);

end


function edit_xrangeLow_Callback(obj,evd,h_fig)
h = guidata(h_fig);
lowval = str2num(get(obj,'string'));
upval = str2num(get(h.tm.edit_xrangeUp,'string'));

if lowval>upval
    lowval = upval;
    disp('The lower bound can not be higher than the upper bound.');
end

set(obj,'string',num2str(lowval));

ud_panRanges(h_fig);
plotData_autoSort(h_fig);
end


function edit_xrangeUp_Callback(obj,evd,h_fig)
h = guidata(h_fig);
upval = str2num(get(obj,'string'));
lowval = str2num(get(h.tm.edit_xrangeLow,'string'));

if upval<lowval
    upval = lowval;
    disp('The upper bound can not be smaller than the lower bound.');
end

set(obj,'string',num2str(upval));

ud_panRanges(h_fig);
plotData_autoSort(h_fig);
end


function edit_yrangeLow_Callback(obj,evd,h_fig)
h = guidata(h_fig);
lowval = str2num(get(obj,'string'));
upval = str2num(get(h.tm.edit_yrangeUp,'string'));

if lowval>upval
    lowval = upval;
    disp('The lower bound can not be higher than the upper bound.');
end

set(obj,'string',num2str(lowval));

ud_panRanges(h_fig);
plotData_autoSort(h_fig);
end


function edit_yrangeUp_Callback(obj,evd,h_fig)
h = guidata(h_fig);
upval = str2num(get(obj,'string'));
lowval = str2num(get(h.tm.edit_yrangeLow,'string'));

if upval<lowval
    upval = lowval;
    disp('The upper bound can not be smaller than the lower bound.');
end

set(obj,'string',num2str(upval));

ud_panRanges(h_fig);
plotData_autoSort(h_fig);
end


function popupmenu_cond_Callback(obj,evd,h_fig)
ud_panRanges(h_fig);
end


function edit_conf_Callback(obj,evd,h_fig)
h = guidata(h_fig);
conf = str2num(get(obj,'string'));
units = get(h.tm.popupmenu_units,'value');
if units==1 % percentage
    if conf>100
        disp('warning: confidence level 1 is greater than 100%');
    end
    if conf>100
        disp('warning: confidence level 2 is greater than 100%');
    end
end

ud_panRanges(h_fig);
end


function popupmenu_units_Callback(obj,evd,h_fig)
h = guidata(h_fig);
conf1 = str2num(get(h.tm.edit_conf1,'string'));
conf2 = str2num(get(h.tm.edit_conf2,'string'));
units = get(obj,'value');
if units==1 % percentage
    if conf1>100
        disp('warning: confidence level 1 is greater than 100%');
    end
    if conf2>100
        disp('warning: confidence level 2 is greater than 100%');
    end
end

ud_panRanges(h_fig);
end


function pushbutton_addTag2pop_Callback(obj,evd,h_fig)
h = guidata(h_fig);
range = get(h.tm.listbox_ranges,'value');
str_range = get(h.tm.listbox_ranges,'string');
if strcmp(str_range{range},'no range')
    return;
end

tag = get(h.tm.popupmenu_defTagPop,'value');
str_tag = get(h.tm.popupmenu_defTagPop,'string');
if strcmp(str_tag{tag},'no default tag')
    return;
end

dat3 = get(h.tm.axes_histSort,'userdata');
dat3.rangeTags(range,tag) = true;
set(h.tm.axes_histSort,'userdata',dat3);

update_taglist_AS(h_fig);

end


function pushbutton_remPopTag_Callback(obj,evd,h_fig)
h = guidata(h_fig);
range = get(h.tm.listbox_ranges,'value');
str_range = get(h.tm.listbox_ranges,'string');
if strcmp(str_range{range},'no range')
    return;
end

tag = get(h.tm.listbox_popTag,'value');
str_tag = get(h.tm.listbox_popTag,'string');
if strcmp(str_tag{tag},'no tag')
    return;
end

dat3 = get(h.tm.axes_histSort,'userdata');
tagid = find(dat3.rangeTags(range,:));
dat3.rangeTags(range,tagid(tag)) = false;
set(h.tm.axes_histSort,'userdata',dat3);

update_taglist_AS(h_fig);

end


function pushbutton_applyTag_Callback(obj,evd,h_fig)

choice = questdlg({cat(2,'Applying tags to moelcules belonging to this ',...
    'subgroup not reversible automatically.'),'',...
    'Do you wish to continue?'},'Apply molecule tag',...
    'Yes tag molecule subgroup','Cancel','Cancel');

if ~strcmp(choice,'Yes tag molecule subgroup')
    return;
end

h = guidata(h_fig);

listbox_ranges_Callback(h.tm.listbox_ranges,[],h_fig);
h = guidata(h_fig);

dat3 = get(h.tm.axes_histSort,'userdata');
range = get(h.tm.listbox_ranges,'value');

disp('sort molecules...');
molIncl_slct = ud_popCalc(h_fig);
disp('sorting complete!');

if ~sum(molIncl_slct) || ~sum(dat3.rangeTags(range,:))
    return;
end

% molecule selection at last update
molId = find(dat3.slct);
h.tm.molTag(molId(molIncl_slct),~~dat3.rangeTags(range,:)) = true;

guidata(h_fig,h);

% update molecule tag lists
update_taglist_OV(h_fig,str2num(get(h.tm.edit_nbTotMol,'string')));

% update plot in VV
plotData_videoView(h_fig);

end


%% callbacks for panel "Viveo view"

function popupmenu_VV_mol_Callback(obj,evd,h_fig)
plotData_videoView(h_fig);
end


function checkbox_VV_tag0_Callback(obj,evd,h_fig)

h = guidata(h_fig);

switch get(obj,'value')
    case 1
        set(obj,'fontweight','bold');
        set(h.tm.edit_VV_tag0,'enable','inactive');
    case 0
        set(obj,'fontweight','normal');
        set(h.tm.edit_VV_tag0,'enable','off');
end

plotData_videoView(h_fig);

end


function checkbox_VV_tag_Callback(obj,evd,h_fig,t)

h = guidata(h_fig);
tagClr =  h.tm.molTagClr;

switch get(obj,'value')
    case 1
        set(obj,'fontweight','bold');
        set(h.tm.edit_VV_tag(t),'enable','inactive','backgroundcolor',...
        hex2rgb(tagClr{t})/255,'foregroundcolor','white');
    case 0
        set(obj,'fontweight','normal');
        set(h.tm.edit_VV_tag(t),'enable','off','foregroundcolor','black',...
            'backgroundcolor','white');
end

plotData_videoView(h_fig);
end


function popupmenu_VV_exc_Callback(obj,evd,h_fig)
plotData_videoView(h_fig);
end


%% buttondown function

function axes_histSort_ButtonDownFcn(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

h_edit_x = [h.tm.edit_xrangeLow,h.tm.edit_xrangeUp];
h_edit_y = [h.tm.edit_yrangeLow,h.tm.edit_yrangeUp];

pos = get(h.tm.axes_histSort,'currentpoint');
ind = get(h.tm.popupmenu_selectData,'value');
xrange = [str2num(get(h_edit_x(1),'string')) ...
    str2num(get(h_edit_x(2),'string'))];
yrange = [str2num(get(h_edit_y(1),'string')) ...
    str2num(get(h_edit_y(2),'string'))];
xlim = get(h.tm.axes_histSort,'xlim');
ylim = get(h.tm.axes_histSort,'ylim');

if ind<=(nChan*nExc+nFRET+nS) % 1D histograms
    x = xrange;
    if x(2)>xlim(2)
        x(2) = xlim(2);
    end
    if x(2)<xlim(1)
        x(2) = xlim(1);
    end
    if x(1)<xlim(1)
        x(1) = xlim(1);
    end
    if x(1)>xlim(2)
        x(1) = xlim(2);
    end
    if x(1)==x(2) && pos(1,1)>x(1)
        id = 2;
    else
        [o,id] = min(abs(x-pos(1,1)));
    end
    
    set(h_edit_x(id),'string',num2str(pos(1,1)));
    fcn = get(h_edit_x(id),'callback');
    feval(fcn{1},h_edit_x(id),[],h_fig);
    
else % E-S histograms
    x = xrange;
    y = yrange;
    if x(2)>xlim(2)
        x(2) = xlim(2);
    end
    if x(2)<xlim(1)
        x(2) = xlim(1);
    end
    if x(1)<xlim(1)
        x(1) = xlim(1);
    end
    if x(1)>xlim(2)
        x(1) = xlim(2);
    end
    if x(1)==x(2) && pos(1,1)>x(1)
        idx = 2;
    else
        [o,idx] = min(abs(x-pos(1,1)));
    end
    
    set(h_edit_x(idx),'string',num2str(pos(1,1)));
    fcn = get(h_edit_x(idx),'callback');
    feval(fcn{1},h_edit_x(idx),[],h_fig);
    
    if y(2)>ylim(2)
        y(2) = ylim(2);
    end
    if y(2)<ylim(1)
        y(2) = ylim(1);
    end
    if y(1)<ylim(1)
        y(1) = ylim(1);
    end
    if y(1)>ylim(2)
        y(1) = ylim(2);
    end
    if y(1)==y(2) && pos(1,2)>y(1)
        idy = 2;
    else
        [o,idy] = min(abs(y-pos(1,2)));
    end
    
    set(h_edit_y(idy),'string',num2str(pos(1,2)));
    fcn = get(h_edit_y(idy),'callback');
    feval(fcn{1},h_edit_y(idy),[],h_fig);
end

end


%% closerequest function

function figure_traceMngr(obj, evd, h_fig)

    h = guidata(h_fig);
    h = rmfield(h, 'tm');
    guidata(h_fig, h);
    delete(obj);

end

