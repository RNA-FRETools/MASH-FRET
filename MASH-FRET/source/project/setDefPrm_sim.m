function def = setDefPrm_sim(p)
% def = setDefPrm_sim(p)
%
% Set new or adjust project's simulation default parameters to current
% standard.
%
% p: structure containing interface content
% def: adjusted project's defaults

% defaults
L = 4000; % video length
rate = 10; % frame rate (s-1)
br = 14; % bit rate (bit/s)
viddim = [256 256]; % video pixel dimensions
pixsz = 0.53; % pixel size (um)
camNoise = 'none'; % camera noise model
noisePrm = [ % camera noise model parameters
    113   0     0.95 0    1    0       % mu.d /     eta /     1 /       % default P- or Poisson Model
    113   0.067 0.95 0    57.8 0       % mu.d s_d   eta s_q   K mr.s    % default N- or Gaussian Model
    106.9 0.02  0.95 2    57.7 20.5    % mu.d A_CIC eta sig_d K tau_CIC % default NexpN or Exp.-CIC Model
    113   0     1    0    1    0       % mu.d /     1   /     1 /       % default no noise but camera offset
    113   0.067 0.95 0.02 300  5.199   % mu.d s_d   eta CIC   g s       % default PGN- or Hirsch Model  
    ]; 
N = 100; % number of molecules
J = 2; % number of states
kx = [ % transition rates (s-1), for up to 5 states
    0   0.1   0.1   0.1   0.1
    0.1     0   0.1   0.1   0.1
    0.1   0.1     0   0.1   0.1
    0.1   0.1   0.1     0   0.1
    0.1   0.1   0.1   0.1     0
    ];
wx = [ % transition probabilities, for up to 5 states
    0   0.25   0.25   0.25   0.25 
    0.25     0   0.25   0.25   0.25
    0.25   0.25     0   0.25   0.25
    0.25   0.25   0.25     0   0.25
    0.25   0.25   0.25   0.25     0];
Itot = 36; % total donor intensity (PC)
BtD = 0.07;
DEA = 0.02;
inun = 'electron'; % input intensity units
isPSF = true;
PSFw = [0.35260 0.38306]; % PSF width (um)
outun = 'electron';

% initializes fields
p.sim.defProjPrm = adjustParam('defProjPrm',[],p.sim);
p.sim.defProjPrm = initDefPrmFields_sim(p.sim.defProjPrm);
def = p.sim.defProjPrm;

% parameters for plot
plotprm{1} = 2;
def.plot = adjustVal(def.plot,plotprm);

% parameters for dwell time generation
gen_dt{1} = [N,L,J,rate,false,L/rate]; % sample size,video length,nb. of states,frame rate(s-1),bleaching,bleaching time constant(s)
gen_dt{2} = cat(3,kx,wx); % transition rate constants,transition prob.
gen_dt{3} = {false,[],''}; % is presets,presets file, presets
def.gen_dt = adjustVal(def.gen_dt,gen_dt);
def.gen_dt{3} = gen_dt{3}; % reset presets
J = def.gen_dt{1}(3);

% parameters to calculate coordinates,intensities,FRET and video frame
gen_dat{1} = {{true,[],[]},... % rand. coord, coord, coord file
    {viddim,br,pixsz,camNoise,noisePrm}}; % video dimensions(px),bit rate,pixel size(um),camera noise,noise param.
gen_dat{2} = [round(10*linspace(0,1,J))/10;zeros(1,J)]; % FRET values and broadening
gen_dat{3} = {[Itot,0],inun}; % total intensity, broadening and input units
gen_dat{4} = [1,0]; % gamma factor and broadening
gen_dat{5} = [BtD,0;0,DEA]; % bleedthrough and direct excitation coefficients
gen_dat{6} = {isPSF,... % PSF convolution
    PSFw,... % don and acc PSF widths
    cell(1,2)}; % convolution factor matrix
gen_dat{7} = [0,0,0]; % defocusing, lateral chromatic aberration, amplitude
gen_dat{8} = {1,... % BG type (1:constant, 2:TIRF profile, 3:patterned)
    [0,0],... % don and acc BG intensities
    [floor(viddim(1)/4),viddim(2)/2],... TIRF profile x- and y-dimensions
    {[],''},... % background image, imported file
    [0,L*rate/10,1]}; % exp. decaying BG, decay constant(s),amplitude
def.gen_dat = adjustVal(def.gen_dat,gen_dat);

% parameters for export
expprm{1} = [0,0,0,0,0,0,0]; % exported files
expprm{2} = outun; % exported intensity units
def.exp = adjustVal(def.exp,expprm);

% state sequences
%  res_dt{1}: [J-by-L-by-N] state occupancy trajectories
%  res_dt{2}: [L-by-N] trajectories of state indexes
%  res_dt{3}: {1-by-N}[nDt-by-3] dwell times

% coordinates, intensity and FRET trajectories
%  res_dat{1}: [N-by-4] molecule coordinates
%  res_dat{2}: [L-by-4-by-N] donor and acceptor intensity-time traces and state sequences
%  res_dat{3}: [L-by-3-by-N] blurr FRET state sequences, max. prob. FRET state sequences, state index sequences

% data to plot
%  res_plot{1}: first video frame
%  res_plot{2}: first intensity trajectory



