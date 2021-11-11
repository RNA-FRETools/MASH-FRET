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

% update by MH, 19.12.2019: remove control of coordinates and PSF factorization matrix (done upstream at import or when video dimensions change) 
% update by MH, 17.12.2019: (1) check for sufficient number of data points in state sequences, (2) return success/failure variable and potential error message, (3) correct how coordinates are collected genCoord=1 --> randomly generated only, genCoord=0 --> imported from coordinates or presets file, (4) remove control of sample size when coordinates are imported from file (controlled upstream at import), (5) remove dependency on plotExample.m and setSimCoordTable.m (called from the pushbutton callback function)
% update by MH, 6.12.2019: (1) reset PSF factorisation matrix (matGauss) when coordinates are imported from a pre-set file and some are excluded along the way: size conflict was happenning after two successive "generate" runs, (2) modify first input argument of setSimCoordTable to display coordinates imported from preset files
% update by RB, 7.3.2018: (1) comments adapted for Boerner et al 2017
% created by MH, 23.4.2014

% defaults
ok = 1;
str = {}; % action string

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
curr = p.proj{proj}.sim.curr;
prm = p.proj{proj}.sim.prm;

% collect simulated state sequences
if ~(isfield(prm,'res_dt') && ~isempty(prm.res_dt{1}))
    setContPan({'Error: State sequences have to be generated first.',...
        'Push the "Generate" button to do so.'},'error',h_fig);
    ok = 0;
    return
end

% re-generate state sequences to match the current parameter set
if ~isequal(prm.gen_dt,curr.gen_dt)
    pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);
    return
end

% apply current parameter set to project
prm.gen_dat = curr.gen_dat;

% collect simulation parameters
mix = prm.res_dt{1};
seq = prm.res_dt{2};
N = prm.gen_dt{1}(1);
L = prm.gen_dt{1}(2);
J = prm.gen_dt{1}(3);
isPresets = prm.gen_dt{3}{1};
presets = prm.gen_dt{3}{2};
res_x = prm.gen_dat{1}{2}{1}(1);
res_y = prm.gen_dat{1}{2}{1}(2);
coord = prm.gen_dat{1}{1}{2};
stateVal = prm.gen_dat{2}(1,1:J);
FRETw = prm.gen_dat{2}(2,1:J);
totInt = prm.gen_dat{3}{1}(1);
Itot_w = prm.gen_dat{3}{1}(2);
gamma = prm.gen_dat{4}(1);
gammaW = prm.gen_dat{4}(2);

% display action
setContPan('Updating intensity data...', 'process', h_fig);

% initialize results
genNewCoord = isempty(coord);
if genNewCoord
    coord = zeros(N,4);
end
Iacc = zeros(L,N);
Iacc_id = Iacc;
Idon = Iacc;
Idon_id = Iacc;
discr = Iacc;
discr_blurr = Iacc;
discr_seq = Iacc;

% calculate trajectories
splt = round(res_x/2);
for n = 1:N
    if genNewCoord
        coord(n,1:2) = [rand(1)*splt rand(1)*res_y];
        coord(n,3:4) = [(coord(n,1)+splt) coord(n,2)];
    end
    
    if isPresets && isfield(presets, 'stateVal')
        fretVal = random('norm',presets.stateVal(n,:),presets.FRETw(n,:));
    else
        fretVal = random('norm',stateVal,FRETw);
    end
    fretVal(fretVal<0) = 0;
    fretVal(fretVal>1) = 1;
    
    discr_seq(:,n) = seq(1:L,n);
    
    discr(:,n) = discr_seq(:,n);
    posid = discr(:,n)>=0;
    discr(posid,n) = fretVal(discr_seq(posid,n));
    
    discr_blurr(:,n) = sum(repmat(fretVal',[1,L]).*mix(:,1:L,n),1)';
    discr_blurr(discr_blurr(:,n)<0 | isnan(discr_blurr(:,n)),n) = -1;

    if isPresets && isfield(presets,'totInt')
        I_sum = random('norm',presets.totInt(n),presets.totInt_width(n));
    else
        I_sum = random('norm',totInt,Itot_w);
    end
    I_sum(I_sum<0) = 0;

    if isPresets && isfield(presets,'gamma')
        g_mol = random('norm',presets.gamma(n),presets.gammaW(n));
    else
        g_mol = random('norm',gamma,gammaW);
    end
    g_mol(g_mol<0) = 0;

    Iacc_id(:,n) = discr_blurr(:,n)*I_sum;
    Iacc_id(Iacc_id(:,n)==-I_sum,n) = 0;
    
    Iacc(:,n) = Iacc_id(:,n);

    Idon_id(:,n) = (1-discr_blurr(:,n))*I_sum;
    Idon_id(Idon_id(:,n)==(2*I_sum),n) = 0;

    % inversed gamma correction for the different quantum and detection efficiencies of donor and acceptor 
    % Idon_exp = Idon_id/gamma
    Idon(:,n) = Idon_id(:,n)/g_mol;
end

Idon = permute(Idon,[1,3,2]);
Iacc = permute(Iacc,[1,3,2]);
Idon_id = permute(Idon_id,[1,3,2]);
Iacc_id = permute(Iacc_id,[1,3,2]);
discr = permute(discr(:,1:N),[1,3,2]);
discr_seq = permute(discr_seq(:,1:N),[1,3,2]);
discr_blurr = permute(discr_blurr(:,1:N),[1,3,2]);

% save results in project parameters
prm.gen_dat{1}{1}{2} = coord;
prm.res_dat{1} = cat(2,Idon,Iacc,Idon_id,Iacc_id);
prm.res_dat{2} = cat(2,discr_blurr,discr,discr_seq);
curr.res_dat = prm.res_dat;
curr.gen_dat = prm.gen_dat;

% h.results.sim.dat = {Idon Iacc coord};
% h.results.sim.dat_id = {Idon_id Iacc_id discr_blurr discr discr_seq};

% save modifications
p.proj{proj}.sim.prm = prm;
p.proj{proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);

