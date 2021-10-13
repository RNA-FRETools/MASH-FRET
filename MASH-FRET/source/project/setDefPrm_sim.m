function defprm = setDefPrm_sim(p)
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

% retrieve existing default parameters
if ~isfield(p.sim, 'defProjPrm')
    p.sim.defProjPrm = [];
end
defprm = p.sim.defProjPrm;

% plot parameters
def{1} = 1; % colormap

% video parameters
def{2}{1} = [L,rate,br,pixsz]; % [video length,frame rate(s-1),bit rate,pixel size(um)]
def{2}{2} = viddim;
def{2}{3} = {camNoise,noisePrm};

% molecule parameters
def{3}{1} = {N,true,[],[]}; % {nb. of molecules,random coordinates,coordinates file,coordinates}
def{3}{2} = {false,[],[]}; % {import presets from file,presets file,presets}
def{3}{3} = [false,L/rate]; % [photobleaching,bleaching time constant(s)]
def{3}{4} = {J,kx,wx,...
    [round(10*linspace(0,1,def.nbStates))/10;zeros(1,J)]}; % {nb. of states,transition rate constants(s-1),transition prob.,FRET values,FRET broadening}
def{3}{5} = [1,0]; % gamma factor and broadening
def{3}{6} = {Itot,0,inun}; % total emitted intensity(PC),broadening(PC),input units
def{3}{7} = [BtD,0;0,DEA];  % default bleedthrough and direct excitation coefficients

% setup parameters
def{4}{1} = {1,... % BG type (1:constant, 2:TIRF profile, 3:patterned)
    [0,0],... % don and acc BG intensities
    [floor(viddim(1)/4),viddim(2)/2],... TIRF profile x- and y-dimensions
    [0,L*rate/10,1]}; % exp. decaying BG, decay constant(s),amplitude
def{4}{2} = {isPSF,... % PSF convolution
    PSFw,... % don and acc PSF widths
    cell(1,4)}; % convolution factor matrix
def{4}{3} = [0,0]; % defocusing, lateral chromatic aberration

% export parameters
def{5}{1} = [0,0,0,0,0,0,0]; % exported files
def{5}{2} = outun; % exported intensity units

% check and correct inconsistensies in structure
defprm = adjustVal(defprm,def);

