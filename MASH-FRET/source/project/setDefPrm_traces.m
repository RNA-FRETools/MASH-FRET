function def = setDefPrm_traces(p, proj)
% Set default parameters for one molecule regarding project parameters.
% "p" >> structure containing TTanalysis panel parameters
% "proj" >> project number in the list
% "def" >> 1-by-n cell array containing molecule parameters for each of ...
%          the n panels
%
% Last update: the 28th of April 2014 by Mélodie C.A.S. Hadzic



if ~isfield(p, 'defProjPrm')
    p.defProjPrm = [];
end
if ~isfield(p.defProjPrm, 'general')
    p.defProjPrm.general = cell(1,3);
end
if ~isfield(p.defProjPrm, 'mol')
    p.defProjPrm.mol = cell(1,5);
end

def = p.defProjPrm;

nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
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
gen{1}(5) = 0; % refocus

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

if nFRET > 1 && nS >1
    gen{2}(3) = nFRET + nS + 4; % + none + all FRET + all S + all
    
elseif nS > 1 || nFRET > 1
    gen{2}(3) = nFRET + nS + 3; % + none + all FRET/all S + all
    
elseif nFRET == 1 && nS == 1
    gen{2}(3) = nFRET + nS + 2; % + none + all 
    
else
    gen{2}(3) = 2;
end

gen{2}(4) = p.proj{proj}.cnt_p_sec; % plot in intensity units per second
gen{2}(5) = p.proj{proj}.cnt_p_pix; % plot in intensity units per pixels
gen{2}(6) = 0; % fix first frame for all molecules
gen{2}(7) = 1; % x-axis in second

% Main popupmenu values
gen{3}(1) = 1; % correction excitation
gen{3}(2) = 1; % correction channel
gen{3}(3) = 1; % Bleedthrough channel
gen{3}(4) = 1; % DTA channel
gen{3}(5) = 0; % nothing (old background excitation)
gen{3}(6) = 1; % data for background correction
gen{3}(7) = 1; % Direct excitation coefficient excitation
gen{3}(8) = 1; % FRET correction channel

def.general = adjustVal(def.general, gen);

if def.general{1}(1) > nExc
    def.general{1}(1) = 1;
end
def.general{2}(1:3) = gen{2}(1:3);
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
for c = 1:nChan
    for l = 1:nExc
        mol{3}{1}(l,c) = 1; % apply correction
        if isCoord && isMov
            mol{3}{2}(l,c) = 2; % method
            mol{3}{3}{l,c} = [0   20 0  0  0 0  % Manual
                              0   20 0  0  0 0  % 20 darkest
                              0   20 0  0  0 0  % Mean value
                              100 20 0  0  0 0  % Most frequent value
                              0.5 20 0  0  0 0  % Histotresh
                              10  20 0  1  1 1  % Dark trace
                              2   20 0  0  0 0];% Median
                          
        else
            mol{3}{2}(l,c) = 1; % method
            mol{3}{3}{l,c} = zeros(1,6);  % Manual
            mol{3}{3}{l,c}(3) = 20;
        end
    end
end
% mol{3}{4} = 20; % window dimensions

% DTA
if nFRET > 0 || nS > 0
    mol{4}{1} = [1 1 0]; % method/apply to FRET/recalc states;
else
    mol{4}{1} = [1 0 0];
end

for i = 1:nFRET

    mol{4}{2}(:,:,i) = ...
        [2  0  0 2 0 0 %   Thresholds J   ,none,none,tol ,refine,bin
         1  2  5 2 0 0 %   vbFRET     minJ,maxJ,prm1,tol ,refine,bin
         1  0  0 0 0 0 %   One state  none,none,none,none,none  ,none
         50 90 2 2 0 0 %   CPA        prm1,prm2,prm3,tol ,refine,bin 
         2  0  0 2 0 0]; % STaSI      maxJ,none,none,tol ,refine,bin

    mol{4}{4}(:,:,i) = ...
        [1    0.8  0.6  0.4  0.2   0   
         0.85 0.65 0.45 0.25 0.05 -Inf
         Inf  0.95 0.75 0.55 0.35  0.15];
end

for i = 1:nS
    
    mol{4}{2}(:,:,nFRET+i) = ...
        [2  0  0 2 0 0 %   Thresholds J   ,none,none,tol ,refine,bin
         1  2  5 2 0 0 %   vbFRET     minJ,maxJ,prm1,tol ,refine,bin
         1  0  0 0 0 0 %   One state  none,none,none,none,none  ,none
         50 90 2 2 0 0 %   CPA        prm1,prm2,prm3,tol ,refine,bin 
         2  0  0 2 0 0]; % STaSI      maxJ,none,none,tol ,refine,bin

    mol{4}{4}(:,:,nFRET+i) = ...
        [1    0.8  0.6  0.4  0.2   0   
         0.85 0.65 0.45 0.25 0.05 -Inf
         Inf  0.95 0.75 0.55 0.35  0.15];
end

meanI = mean(mean(mean(p.proj{proj}.intensities,3),2),1);

for j = 1:nExc
    for i = 1:nChan
        mol{4}{2}(:,:,nFRET+nS+(j-1)*nChan+i) = ...
            [2  0  0 2 0 0 %   Thresholds J   ,none,none,tol ,refine,bin
             1  2  5 2 0 0 %   vbFRET     minJ,maxJ,prm1,tol ,refine,bin
             1  0  0 0 0 0 %   One state  none,none,none,none,none  ,none
             50 90 2 2 0 0 %   CPA        prm1,prm2,prm3,tol ,refine,bin 
             2  0  0 2 0 0]; % STaSI      maxJ,none,none,tol ,refine,bin

        mol{4}{4}(:,:,nFRET+nS+(j-1)*nChan+i) = ...
            round(meanI*[1    0.8  0.6  0.4  0.2   0   
                         0.85 0.65 0.45 0.25 0.05 -Inf
                         Inf  0.95 0.75 0.55 0.35  0.15]);
    end
end
mol{4}{3} = nan(nFRET+nS+nExc*nChan,6);  % States values
             
% Cross talk and filter corrections
for l = 1:nExc
    for c = 1:nChan
        % bleedthrough
        mol{5}{1}{l,c} = zeros(1,nChan-1);
        % direct excitation
        mol{5}{2}{l,c} = zeros(1,nExc-1);
    end
end

% gamma
mol{5}{3} = [];
for i = 1:nFRET
    mol{5}{3} = [mol{5}{3} 1];
end

% gamma correction via photobleaching, added by FS, 9.1.2018; 
% last updated on 10.1.3018
mol{5}{4}(1) = 0;  % photobleaching based gamma correction checkbox
mol{5}{4}(2) = 1;  % current acceptor

% gamma correction via photobleaching, added by FS, 9.1.2018
% nFRET x 4 matrix; columns are 'pbGamma checkbox', 'threshold', 
% 'extra substract', 'min. cutoff frame', 'start frame', 'stop frame'
% and 'prepostdiff' (i.e is there a difference in the intensity of the donor before and after the cutoff)
mol{5}{5} = [zeros(nFRET,1), 1000*ones(nFRET,1) ...
    zeros(nFRET,1), 100*ones(nFRET,1), ones(nFRET,1), nFrames*ones(nFRET,1), zeros(nFRET,1)];

def.mol = adjustVal(def.mol, mol);

% set quantum yield & additional factors to 1
if size(mol{5},2)>=3
    def.mol{5}{3}(def.mol{5}{3}==0) = 1;
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

% apply discretisation to top traces only if no bottom traces
if (nFRET + nS) == 0
    def.mol{4}{1}(2) = 0;
end

% adjust the cutoff frame if higher than the total number of frames
if def.mol{2}{1}(5) > nFrames
    def.mol{2}{1}(5) = nFrames;
end
if def.mol{2}{1}(6) > nFrames
    def.mol{2}{1}(6) = nFrames;
end

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




