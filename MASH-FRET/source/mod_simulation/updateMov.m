function [ok,str] = updateMov(h_fig)
% updateMov create intensity state sequences from simulated indexed state 
% sequences: assign coordinates to molecules, assign FRET values and gamma-
% biased donor and acceptor photon emission intensities to states.
%
% h_fig: handle to main MASH-FRET figure.
% ok: execution success (1) / failure (0)
% str: cell array containing action strings to display after execution
%
% Requires external files: setContPan.m

% Last update by MH, 17.12.2019
% >> check for sufficient number of data points in state sequences
% >> return success/failure variable and potential error message
% >> correct how coordinates are collected genCoord=1 --> randomly
%  generated only, genCoord=0 --> imported from coordinates or presets file
% >> remove control of sample size when coordinates are imported from file 
%  (controlled upstream at import)
% >> remove dependency on plotExample.m and setSimCoordTable.m (called from 
%  the pushbutton callback function)
%
% update by MH, 6.12.2019
% >> reset PSF factorisation matrix (matGauss) when coordinates are 
%  imported from a pre-set file and some are excluded along the way: size 
%  conflict was happenning after two successive "generate" runs
% >> modify first input argument of setSimCoordTable to display coordinates 
%  imported from preset files
%
% update: 7th of March 2018 by Richard Börner
% >> Comments adapted for Boerner et al 2017
%
% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);
p = h.param.sim;
ok = 1;
str = {}; % action string

% collect sample size and video length
N = p.molNb;
L = p.nbFrames;

% collect simulated state sequences
if isfield(h,'results') && isfield(h.results,'sim') && ...
        isfield(h.results.sim,'mix') && ~isempty(h.results.sim.mix)
    mix = h.results.sim.mix;
    discr_seq = h.results.sim.discr_seq;
else
    setContPan({'Error: State sequences have to be generated first.',...
        'Push the "Generate" button to do so.'},'error',h_fig);
    ok = 0;
    return
end

% check for a sufficient number of simulated state sequences
if size(mix,2)<N
    setContPan({['Error: Not enough state sequences were simulated to ',...
        'satisfy the sample size N.'],['Push the "Generate" button',...
        ' to re-simulate state sequences.']},'error',h_fig);
    ok = 0;
    return
end

% check for a sufficient number of data points in simulated state sequences
if size(mix{1},2)<L
    setContPan({['Error: Simulated state sequences have to few data points',...
        ' to satisfy the length parameter.'],['Push the "Generate" button',...
        ' to re-simulate state sequences.']},'error',h_fig);
    ok = 0;
    return
end

% display action
setContPan('Updating intensity data...', 'process', h_fig);

% collect simulation parameters
totInt = p.totInt;
Itot_w = p.totInt_width;
stateVal = p.stateVal;
FRETw = p.FRETw;
gamma = p.gamma;
gammaW = p.gammaW;
genCoord = p.genCoord;
coord = p.coord;
impPrm = p.impPrm;
molPrm = p.molPrm;
matGauss = p.matGauss;
res_x = p.movDim(1);
res_y = p.movDim(2);
splt = round(res_x/2);

% initialize results
Iacc = {};
Iacc_id = {};
Idon = {};
Idon_id = {};
discr = cell(1,N);

if genCoord % randomly generated coordinates
    if size(coord,1)~=N
        % sample size has changed: generate new coordinates
        coord = zeros(N,4);
        matGauss = cell(1,4);
        newCoord = 1; 
    else
        % keep previous coordinates
        newCoord = 0; 
    end
else % imported coordinates (N set at import and unchangeable)
    if impPrm && isfield(molPrm, 'coord')
        % from pre-set file
        coord = molPrm.coord;
    end
end

excl = []; % excluded coordinates

for n = 1:N
    % excludes sequences corresponding to (imported) out-of-range coordinates
    if ~genCoord && ~iswithinbounds(res_x,res_y,coord(n,:))
        excl = [excl n];
        str = [str cat(2,'coordinates ',num2str(coord(n,:)),...
            ' excluded (out-of-range)')];
        continue
    
    % generates new random coordinates
    elseif genCoord && newCoord 
        coord(n,1:2) = [rand(1)*splt rand(1)*res_y];
        coord(n,3:4) = [(coord(n,1)+splt) coord(n,2)];
    end

    mix{n} = mix{n}(:,1:L);
    discr_seq{n} = discr_seq{n}(1:L,:);

    if impPrm && isfield(molPrm, 'stateVal')
        fretVal = molPrm.stateVal(n,:);
    else
        fretVal = random('norm',stateVal,FRETw);
    end
    fretVal(fretVal<0) = 0;
    fretVal(fretVal>1) = 1;

    discr{n} = sum(repmat(fretVal',[1 size(mix{n},2)]).*mix{n},1)';
    discr{n}(discr{n}<0 | isnan(discr{n})) = -1;

    if impPrm && isfield(molPrm,'totInt');
        I_sum = random('norm',molPrm.totInt(n),molPrm.totInt_width(n));
    else
        I_sum = random('norm',totInt,Itot_w);
    end
    I_sum(I_sum<0) = 0;

    if impPrm && isfield(molPrm,'gamma');
        g_mol = random('norm',molPrm.gamma(n),molPrm.gammaW(n));
    else
        g_mol = random('norm',gamma,gammaW);
    end
    g_mol(g_mol<0) = 0;

    Iacc_id{size(Iacc_id,2)+1} = discr{n}*I_sum;
    Iacc_id{size(Iacc_id,2)}(Iacc_id{size(Iacc_id,2)}==-I_sum) = 0;
    Iacc{size(Iacc,2)+1} = Iacc_id{size(Iacc_id,2)};

    Idon_id{size(Idon_id,2)+1} = (1-discr{n})*I_sum;
    Idon_id{size(Idon_id,2)}(Idon_id{size(Idon_id,2)}==2*I_sum) = 0;

    % inversed gamma correction for the different quantum and detection efficiencies of donor and acceptor 
    % Idon_exp = Idon_id/gamma
    Idon{size(Idon,2)+1} = Idon_id{size(Idon_id,2)}/g_mol;
end

% discard data corresponding to out-of-range (imported) coordinates
discr_seq(excl) = [];
discr(excl) = [];
coord(excl,:) = [];
% added by MH, 6.12.2019
if sum(excl) && impPrm && isfield(molPrm, 'coord') 
    matGauss = cell(2,1);
else
    if ~isempty(matGauss{1})
        matGauss{1}(excl) = [];
    end
    if ~isempty(matGauss{2})
        matGauss{2}(excl) = [];
    end
end

% save results
h.results.sim.dat = {Idon Iacc coord};
h.results.sim.dat_id = {Idon_id Iacc_id discr discr_seq};
h.param.sim.coord = coord;
h.param.sim.matGauss = matGauss;
guidata(h_fig, h);

