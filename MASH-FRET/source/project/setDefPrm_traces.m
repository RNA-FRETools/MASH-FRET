function def = setDefPrm_traces(p, proj)
% def = setDefPrm_traces(p, proj)
%
% Adjust default TP processing parameters according to project's experiment 
% settings.
%
% p: interface parameters structure
% proj: project index in list
% def: adjusted default TP processing parameters

% Last update 23.12.2020 by MH: add method vbFRET 2D
% update 15.01.2020 by MH: add parameter tolerance in photobleaching-based gamma calculation parameters
% update 14.01.2020 by MH: (1) make parameters for gamma/beta factor calculations dependent on the FRET pair (necessary for ES histograms)
% update 13.01.2020 by MH: (1) add beta factors (2) move bleethrough and direct excitation coefficients from molecule to general parameters
% update 10.01.2020 by MH: (1) separate parameters for factor corrections from cross-talks: store parameters for factor corrections in 6th cell
% update 03.04.2019 by MH: (1) correct default value for bottom axes plot (2) change default state finding algorithm to STaSI
% update 29.03.2019 by MH: (1) change bleedthrough coefficient (mol{5}{1}) structure: coefficients are independant of laser (2) change direct excitation coefficient (mol{5}{2}) structure: direct excitation possible by every laser but emitter-specific illumination (nExc-1) and is calculated only based on emitter intensities at emitter-specific laser (possibility to choose another laser was removed)
% update 28.04.2014 by MH

if ~isfield(p.ttPr, 'defProjPrm')
    p.ttPr.defProjPrm = [];
end
if ~isfield(p.ttPr.defProjPrm, 'general')
    p.ttPr.defProjPrm.general = cell(1,3);
end
if ~isfield(p.ttPr.defProjPrm, 'mol')
    p.ttPr.defProjPrm.mol = cell(1,6);
end

def = p.ttPr.defProjPrm;

nChan = p.proj{proj}.nb_channel;
exc = p.proj{proj}.excitations;
nExc = p.proj{proj}.nb_excitations;
chanExc = p.proj{proj}.chanExc;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
nS = size(p.proj{proj}.S,1);
nFrames = size(p.proj{proj}.intensities,1)*nExc;
isCoord = p.proj{proj}.is_coord;
isMov = p.proj{proj}.is_movie;

%% General parameters

% subimages calculation and plot
gen{1}(1) = 1; % excitation
gen{1}(2) = 0; % nothing (ex-subimage window size)
gen{1}(3) = 0; % brightness
gen{1}(4) = 0; % contrast
gen{1}(5) = 0; % nothing (ex-refocus)

% Trace calculation and plot
if nExc > 1 % excitation to plot
    gen{2}(1) = nExc + 1; % 'all'
else
    gen{2}(1) = nExc;
end

if nChan > 1
    gen{2}(2) = nChan + 2; % + none + all
else
    gen{2}(2) = nChan + 1; % + none
end

if nFRET>1 && nS>1
    gen{2}(3) = nFRET + nS + 4; % + none + all FRET + all S + all
    
elseif (nS>1 && nFRET==1) || (nFRET>1 && nS==1)
    gen{2}(3) = nFRET + nS + 3; % + none + all FRET/all S + all
    
elseif (nS>1 && nFRET==0) || (nFRET>1 && nS==0)
    gen{2}(3) = nFRET + nS + 2; % + none + all FRET/all S
    
elseif nFRET==1 && nS==1
    gen{2}(3) = nFRET + nS + 2; % + none + all 
    
elseif nFRET>0 || nS>0
    gen{2}(3) = 2;
    
else
    gen{2}(3) = 1;
end
Inan = isnan(p.proj{proj}.intensities(:));
Imean = mean(p.proj{proj}.intensities(~Inan));
Isig = std(p.proj{proj}.intensities(~Inan));
gen{2}(4) = Imean-Isig; % lower intensity (prev: intensity units per second)
gen{2}(5) = Imean+3*Isig; % upper intensity (prev: intensity units per pixel)
gen{2}(6) = 0; % fix first frame for all molecules
gen{2}(7) = 0; % fix intensity scale (prev: time units in second)

% Main popupmenu values
gen{3}(1) = 1; % laser for direct excitation
gen{3}(2) = 1; % emitter for cross-talk correction
gen{3}(3) = 1; % channel for bleedthrough
gen{3}(4) = 1; % data for DTA
gen{3}(5) = 0; % nothing (prev: laser for background)
gen{3}(6) = 1; % data for background correction
gen{3}(7) = 1; % nothing (prev: laser for DE)
gen{3}(8) = 1; % FRET pair for factor corrections

% Cross-talks coefficients
gen{4}{1} = zeros(nChan,nChan-1); % bleedthrough coefficients
gen{4}{2} = zeros(nExc-1,nChan); % direct excitation coefficients
if nChan==0
    gen{4}{1} = [];
    gen{4}{2} = [];
end
if nExc==0
    gen{4}{2} = [];
end

def.general = adjustVal(def.general, gen);

if def.general{1}(1) > nExc
    def.general{1}(1) = 1;
end
def.general{2}([1:5,7]) = gen{2}([1:5,7]);
def.general{3} = gen{3};

%% Molecule parameters

% Denoising
mol{1}{1}(1) = 2; % denoising method
mol{1}{1}(2) = 0; % apply denoising
mol{1}{2} = [3 0 0
             5 1 2
             3 2 1]; % denoising parameters
             
% Photobleaching
mol{2}{1}(1) = 0; % apply cutoff
mol{2}{1}(2) = 1; % method
mol{2}{1}(3) = 1; % channel
mol{2}{1}(4) = 1; % starting frame
mol{2}{1}(5:6) = [nFrames nFrames]; % cutoff frames

if nChan == 1
    % Threshold param for channel 1
    mol{2}{2} = [0 0 100];
else
    % Threshold param for the n FRET, all channels, sum channels and ...
    % the m channels
    mol{2}{2} = [[-0.2*ones(nFRET+nS,1); zeros(2+nExc*nChan,1)] ...
        zeros(2+nFRET+nS+nExc*nChan,1) 100*ones(2+nFRET+nS+nExc*nChan,1)];
end

% Background correction
mol{3}{1} = ones(nExc,nChan); % apply correction
mol{3}{1} = cat(3,mol{3}{1},zeros(nExc,nChan)); % dynamic background
mol{3}{3} = cell(nExc,nChan);
for c = 1:nChan
    for l = 1:nExc
        if isCoord && isMov
            mol{3}{2}(l,c) = 2; % method
            mol{3}{3}{l,c} = [0   20 0  0  0 0  % Manual
                              0   20 0  0  0 0  % 20 darkest
                              0   20 0  0  0 0  % Mean value
                              100 20 0  0  0 0  % Most frequent value
                              0.5 20 0  0  0 0  % Histotresh
                              10  20 0  1  1 1  % Dark coordinates
                              2   20 0  0  0 0];% Median
                          
        else
            mol{3}{2}(l,c) = 1; % method
            mol{3}{3}{l,c} = zeros(1,7);  % Manual
            mol{3}{3}{l,c}(3) = 20;
        end
    end
end

% DTA
if nFRET > 0 || nS > 0
    mol{4}{1} = [6 1 0]; % method/apply to FRET/recalc states;
else
    mol{4}{1} = [6 0 0];
end

for i = 1:nFRET

    mol{4}{2}(:,:,i) = ...
        [2  0  0 2 0 0 0 %   Thresholds	J,   none,none,tol, refine,bin, blurr
         1  2  5 2 0 0 1 %   vbFRET-1D	minJ,maxJ,prm1,tol, refine,bin, blurr
         1  2  5 2 0 0 1 %   vbFRET-2D	minJ,maxJ,prm1,tol, refine,bin, blurr
         1  0  0 0 0 0 0 %   One state  none,none,none,none,none,  none,none
         50 90 2 2 0 0 0 %   CPA        prm1,prm2,prm3,tol, refine,bin, blurr
         10 0  0 2 0 0 0 %   STaSI      maxJ,none,none,tol, refine,bin, blurr
         0  0  0 0 0 0 0]; % imported   none,none,none,none,refine,bin, blurr

    mol{4}{4}(:,:,i) = ...
        [1    0.8  0.6  0.4  0.2   0   
         0.85 0.65 0.45 0.25 0.05 -Inf
         Inf  0.95 0.75 0.55 0.35  0.15];
end

for i = 1:nS
    
    mol{4}{2}(:,:,nFRET+i) = ...
        [2  0  0 2 0 0 0 %   Thresholds J,   none,none,tol, refine,bin, blurr
         1  2  5 2 0 0 1 %   vbFRET-1D	minJ,maxJ,prm1,tol, refine,bin, blurr
         1  2  5 2 0 0 1 %   vbFRET-2D	minJ,maxJ,prm1,tol, refine,bin, blurr
         1  0  0 0 0 0 0 %   One state  none,none,none,none,none,  none,none
         50 90 2 2 0 0 0 %   CPA        prm1,prm2,prm3,tol, refine,bin, blurr
         10 0  0 2 0 0 0 %   STaSI      maxJ,none,none,tol, refine,bin, blurr
         0  0  0 0 0 0 0]; % imported   none,none,none,none,refine,bin, blurr

    mol{4}{4}(:,:,nFRET+i) = ...
        [1    0.8  0.6  0.4  0.2   0   
         0.85 0.65 0.45 0.25 0.05 -Inf
         Inf  0.95 0.75 0.55 0.35  0.15];
end

meanI = mean(mean(mean(p.proj{proj}.intensities,3),2),1);

for j = 1:nExc
    for i = 1:nChan
        mol{4}{2}(:,:,nFRET+nS+(j-1)*nChan+i) = ...
            [2  0  0 2 0 0 0 %   Thresholds J   ,none,none,tol ,refine,bin, blurr
             1  2  5 2 0 0 1 %   vbFRET-1D	minJ,maxJ,prm1,tol ,refine,bin, blurr
             1  2  5 2 0 0 1 %   vbFRET-2D	minJ,maxJ,prm1,tol ,refine,bin, blurr
             1  0  0 0 0 0 0 %   One state  none,none,none,none,none  ,none,none
             50 90 2 2 0 0 0 %   CPA        prm1,prm2,prm3,tol ,refine,bin, blurr
             2  0  0 2 0 0 0 %   STaSI      maxJ,none,none,tol ,refine,bin, blurr
             0  0  0 0 0 0 0]; % imported   none,none,none,none,refine,bin, blurr

        mol{4}{4}(:,:,nFRET+nS+(j-1)*nChan+i) = ...
            round(meanI*[1    0.8  0.6  0.4  0.2   0   
                         0.85 0.65 0.45 0.25 0.05 -Inf
                         Inf  0.95 0.75 0.55 0.35  0.15]);
    end
end
mol{4}{3} = nan(nFRET+nS+nExc*nChan,6);  % States values

% modified by MH, 13.1.2019
% % Cross talks
% % modified by MH 29.3.2019
% % bleedthrough
% mol{5}{1} = zeros(nChan,nChan-1);
% % direct excitation
% mol{5}{2} = zeros(nExc-1,nChan);
% % for l = 1:nExc
% %     for c = 1:nChan
% %         % bleedthrough
% %         mol{5}{1}{l,c} = zeros(1,nChan-1);
% %         % direct excitation
% %         mol{5}{2}{l,c} = zeros(1,nExc-1);
% %     end
% % end
mol{5} = []; % nothing (prev: cross-talks coefficients)

% gamma
% modified by MH, 13.1.2020
% % modified by MH, 10.1.2020
% % mol{5}{3} = [];
% % for i = 1:nFRET
% %     mol{5}{3} = [mol{5}{3} 1];
% % end
% mol{6}{1} = [];
% for i = 1:nFRET
%     mol{6}{1} = [mol{6}{1} 1];
% end
mol{6}{1} = ones(2,nFRET);

% modified by MH, 14.1.2020
% % modified by MH, 10.1.2020: store parameters in 6th cell
% % gamma correction via photobleaching, added by FS, 9.1.2018; 
% % last updated on 10.1.2018
% % mol{5}{4}(1) = 0;  % photobleaching based gamma correction checkbox
% % mol{5}{4}(2) = 1;  % current acceptor
% mol{6}{2}(1) = 0;  % method (0: manual, 1: photobleaching, 2: linear regression)
% mol{6}{2}(2) = 1;  % FRET pair index in photobleaching opt. window
mol{6}{2} = zeros(1,nFRET);  % method (0: manual, 1: photobleaching, 2: linear regression)

% modified by MH, 15.1.2020: insert default tolerance and change 'pbGamma checkbox' to laser used for photobleaching detection
% % modified by MH, 10.1.2020: store parameters in 6th cell
% % % gamma correction via photobleaching, added by FS, 9.1.2018
% % % nFRET x 7 matrix; columns are 'pbGamma checkbox', 'threshold', 
% % % 'extra substract', 'min. cutoff frame', 'start frame', 'stop frame'
% % % and 'prepostdiff' (i.e is there a difference in the intensity of the donor before and after the cutoff)
% % mol{5}{5} = [zeros(nFRET,1), 1000*ones(nFRET,1) ...
% %     zeros(nFRET,1), 100*ones(nFRET,1), ones(nFRET,1), nFrames*ones(nFRET,1), zeros(nFRET,1)];
% mol{6}{3} = repmat([1000,0,100,1,nFrames,0],nFRET,1);
ldon = ones(nFRET,1);
for i = 1:nFRET
    ldon(i,1) = find(exc==chanExc(FRET(i,1)));
end
mol{6}{3} = [ldon,repmat([1000,0,100,1,3,nFrames,0],nFRET,1)];

% added by MH, 10.1.2020: ES regression
% [nFRET-by-7] subgroup,E limits, E intervals, 1/S limits, 1/S intervals
mol{6}{4} = repmat([1,-0.2,1.2,50,1,3,50],nFRET,1);

def.mol = adjustVal(def.mol, mol);

% modified by MH, 10.1.2020: store parameters in 6th cell
% if size(mol{5},2)>=3
%     % set null gamma factors to 1
%     def.mol{5}{3}(def.mol{5}{3}==0) = 1;
%     % adjust channel for photobleaching cutoff calculation
%     if def.mol{2}{1}(3) > nFRET+nS*(1 + 2*double(nFRET>1|nS>1)) + ...
%             nExc*nChan*(1 + 2*double(nChan>1|nExc>1))
%         def.mol{2}{1}(3) = 1;
%     end
% end
if size(mol,2)>=6
    % set null gamma factors to 1
    def.mol{6}{1}(def.mol{6}{1}==0) = 1;
    % adjust channel for photobleaching cutoff calculation
    if def.mol{2}{1}(3) > nFRET+nS*(1 + 2*double(nFRET>1|nS>1)) + ...
            nExc*nChan*(1 + 2*double(nChan>1|nExc>1))
        def.mol{2}{1}(3) = 1;
    end
end

% if no movie, set BG corrections to manual
if ~(isCoord && isMov)
    for c = 1:nChan
        for l = 1:nExc
            def.mol{3}{2}(l,c) = 1;
            def.mol{3}{3}{l,c} = zeros(1,7);
            def.mol{3}{3}{l,c}(3) = 20;
        end
    end
end

% if methods <= 0
if def.mol{1}{1}(1) <= 0
    def.mol{1}{1}(1) = mol{1}{1}(1);
end
def.mol{3}{2}(def.mol{3}{2} <= 0) = mol{3}{2}(def.mol{3}{2} <= 0);
if def.mol{2}{1}(2) <= 0
    def.mol{2}{1}(2) = mol{2}{1}(2);
end

% apply discretisation to top traces only and forbid 2D-vbFRET if no bottom 
% traces
if (nFRET + nS) == 0
    def.mol{4}{1}(2) = 0;
    if def.mol{4}{1}(1)==3 % 2D-vbFRET
        def.mol{4}{1}(1) = 6; % STaSI
    end
end

% reset trace truncations
def.mol{2}{1}(1) = 0; % apply cutoff
def.mol{2}{1}(2) = 1; % method
def.mol{2}{1}(4) = 1; % starting frame
def.mol{2}{1}(5:6) = [nFrames nFrames]; % cutoff frames

% if photobleaching threshold is calculated a channel larger than the
% number of channel
if def.mol{2}{1}(3) > (2+nFRET+nS+nExc*nChan)
    def.mol{2}{1}(3) = 1;
end

% if the molecule parameter "window size" does not belong to the background
% correction parameters
for l = 1:nExc
    for c = 1:nChan
        if size(def.mol{3},2)>=4 && def.mol{3}(4)>0
            def.mol{3}{3}{l,c}(def.mol{3}{3}{l,c}(:,2)'==0,2) = ...
                def.mol{3}(4);
        elseif def.general{1}(2)>0
            def.mol{3}{3}{l,c}(def.mol{3}{3}{l,c}(:,2)'==0,2) = ...
                def.general{1}(2);
        else
            def.mol{3}{3}{l,c}(def.mol{3}{3}{l,c}(:,2)'==0,2) = 20;
        end
        
        % for histothresh, if the parameter is not the threshold
        if isMov && isCoord && def.mol{3}{3}{l,c}(5,1)>1
            def.mol{3}{3}{l,c}(5,1) = 0.5;
        end
    end
end
if size(def.mol{3},2)>=4
    def.mol{3}(4) = [];
end

% prevents ES linear regression by default (time consuming)
def.mol{6}{2}(def.mol{6}{2}==2) = 0;

% prevents use of "Imported" method when no discr. FRET are imported
if def.mol{4}{1}(1)==7 && ~(isfield(p.proj{proj},'FRET_DTA_import') && ...
        ~isempty(p.proj{proj}.FRET_DTA_import))
    def.mol{4}{1}(1) = 6; % STaSI
end
if isfield(p.proj{proj},'FRET_DTA_import') && ...
        ~isempty(p.proj{proj}.FRET_DTA_import)
    def.mol{4}{1}(1) = 7;
    def.mol{4}{1}(2) = 1;
end


