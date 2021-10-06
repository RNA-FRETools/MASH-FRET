function def = setDefPrm_sim(p)
% def = setDefPrm_sim(p)
%
% Set new or adjust project's simulation default parameters to current
% standard.
%
% p: simulation interface's defaults
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
  
if ~isfield(p, 'defProjPrm')
    p.defProjPrm = [];
end
def = p.defProjPrm;

% video parameters
def.nbFrames = adjustParam('nbFrames', L, def); % nb of video frames
def.rate = adjustParam('rate', rate, def); % frame rate (s-1)
def.bitnr = adjustParam('bitnr', br, def); % bit rate
def.noiseType = adjustParam('noiseType', camNoise, def);
def.movDim = adjustParam('movDim', viddim, def);
def.pixDim = adjustParam('pixDim', pixsz, def);
def.camNoise = adjustParam('camNoise', noisePrm, def);

% molecule parameters
def.genCoord = adjustParam('genCoord', 1, def);
def.coordFile = adjustParam('coordFile', [], def);
def.impPrm = adjustParam('impPrm', 0, def);
def.prmFile = adjustParam('prmFile', [], def);
def.molPrm = adjustParam('molPrm', [], def);
def.bleach = adjustParam('bleach', 0, def); % fluorophore bleaching (0/1)
def.bleach_t = adjustParam('bleach_t', def.nbFrames/def.rate, def); % bleaching decay time (s-1)
def.nbStates = adjustParam('nbStates', J, def); % nb of FRET states
def.molNb = adjustParam('molNb', N, def); % nb of simulated molecules 
def.kx = adjustParam('kx', kx, def);
def.wx = adjustParam('kx', wx, def);
def.stateVal = adjustParam('stateVal', ...
    round(10*linspace(0,1,def.nbStates))/10, def);
def.FRETw = adjustParam('FRETw', zeros(1,def.nbStates), def); % FRET width for heterogenous broadening
def.gamma = adjustParam('gamma', 1, def); % gamma factor (correction for different quantum yields and detection efficiencies of the fluorophors)
def.gammaW = adjustParam('gammaW', 0, def); % gamma width for molecule variations
def.totInt = adjustParam('totInt', Itot, def); % total emitted intennsity 
def.totInt_width = adjustParam('totInt_width', 0, def); % total emitted Intensity width for heterogenous broadening
def.coord = adjustParam('coord', [], def); % only allocation of sm coordinates
def.molPrm = adjustParam('molPrm', [], def); % only allocation of sm parameters
def.btD = adjustParam('btD', BtD, def);  % default bleedthrough D excitation D emmission in A channel
def.btA = adjustParam('btA', 0, def);     % default bleedthrough A excitation A emmission in D channel
def.deD = adjustParam('deD', 0, def);     % default direct excitation of D after A excitation
def.deA = adjustParam('deA', DEA, def);  % default direct excitation of A after D excitation
def.intUnits = adjustParam('intUnits',inun, def);

% setup parameters
def.bgInt_don = adjustParam('bgInt_don', 0, def);
def.bgInt_acc = adjustParam('bgInt_acc', 0, def);
def.bgType = adjustParam('bgType', 1, def); % 1: constant, 2: TIRF profile, 3: patterned 
def.TIRFdim = adjustParam('TIRFdim', [floor(def.movDim(1)/4) ...
    def.movDim(2)/2], def);
def.bgDec = adjustParam('bgDec', 0, def);
def.cstDec = adjustParam('cstDec', def.nbFrames*def.rate/10, def);
def.ampDec = adjustParam('ampDec', 1, def);
def.PSF = adjustParam('PSF', isPSF, def);
def.PSFw = adjustParam('PSFw', PSFw, def);
def.zDec = adjustParam('zDec', 0, def); % defocusing
def.z0Dec = adjustParam('z0Dec', 0, def); % lateral chromatic aberration
def.matGauss = cell(1,4);

% other parameters
def.export_traces = adjustParam('export_traces', 0, def);
def.export_movie = adjustParam('export_movie', 0, def);
def.export_avi = adjustParam('export_avi', 0, def);
def.export_procTraces = adjustParam('export_procTraces', 0, def);
def.export_dt = adjustParam('export_dt', 0, def);
def.export_coord = adjustParam('export_coord', 0, def);
def.export_param = adjustParam('export_param', 0, def);
def.intOpUnits = adjustParam('intOpUnits', outun, def);
def.cmap = adjustParam('cmap', 1, def);

