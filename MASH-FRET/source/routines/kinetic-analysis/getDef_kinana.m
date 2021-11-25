function p = getDef_kinana(pname,fnames)

% defaults
nChan_def = 2;
nL_def = 1;
deflbl = {'don','acc1'};
nMax = 3; % maximum number of exponential to fit
Vmax = 5; % maximum number of observable states to fit
T = 5; % number of restart in model optimization
Nhl = 0; % number of header lines in trajectory files
colT = 1; % time column in trajectory files
colInt = [2,3]; % donor and aceptor intensity columns in trajectory files

% general
p.dumpdir = cat(2,pname,'MASH-FRET-analysis');
if ~exist(p.dumpdir,'dir')
    mkdir(p.dumpdir);
end

% import parameters
p.nChan = nChan_def;
p.nL = nL_def;
p.wl = [];
while isempty(p.wl) || numel(unique(p.wl))~=p.nL
    p.wl = round(1000*sort(rand(1,p.nL))); % laser wavelengths
end

[~,projname,~] = fileparts(pname);

% set experiment settings
p.es = cell(p.nChan,p.nL);
p.es{p.nChan,p.nL}.imp.tdir = pname;
p.es{p.nChan,p.nL}.imp.tfiles = fnames;
p.es{p.nChan,p.nL}.chan.nchan = p.nChan;
p.es{p.nChan,p.nL}.chan.emlbl = deflbl(1:p.nChan);
p.es{p.nChan,p.nL}.las.nlas = p.nL;
p.es{p.nChan,p.nL}.las.laswl = p.wl(1:p.nL);
p.es{p.nChan,p.nL}.las.lasem = [1:min([p.nChan,p.nL]),...
    zeros(1,p.nL-min([p.nChan,p.nL]))];
FRET = [];
for don = 1:(p.nChan-1)
    if any(p.es{p.nChan,p.nL}.las.lasem==don)
        for acc = (don+1):p.nChan
            FRET = cat(1,FRET,[don,acc]);
        end
    end
end
p.es{p.nChan,p.nL}.calc.fret = FRET;
p.es{p.nChan,p.nL}.calc.s = [];
if ~isempty(FRET)
    for pair = 1:size(FRET,1)
        if any(p.es{p.nChan,p.nL}.las.lasem==FRET(pair,2))
            p.es{p.nChan,p.nL}.calc.s = cat(1,p.es{p.nChan,p.nL}.calc.s,...
                FRET(pair,:));
        end
    end
end
p.es{p.nChan,p.nL}.fstrct = {[Nhl 1 colT colInt 1 1 0 0 0 0],ones(1,p.nL),...
    zeros(p.nL,2)};
p.es{p.nChan,p.nL}.div.projttl = projname;

% axis units
p.perSec = true;
p.inSec = false;
p.fixX0 = false;
p.x0 = 1;

% default background parameters
p.bgMeth = 1;
p.bgPrm = [... % param1, param2, bg intensity, x-dark, y-dark, auto dark
    0   20 0 0  0  0 % Manual
    0   20 0   0  0  0 % 20 darkest
	0   20 0   0  0  0 % Mean value
	100 20 0   0  0  0 % Most frequent value
	0.5 20 0   0  0  0 % Histotresh
	10  20 0   10 10 1 % Dark trace
	2   20 0   0  0  0];% Median
p.bgApply = true;

% default cross-talks parameters
p.bt = [0,0
    0,0];
p.de = [0;0];

% default denoising parameters
p.denMeth = 1;
p.denApply = false;
p.denPrm = [3,0,0
    5 1 2
    3 2 1];

% default photobleaching parameters
p.pbMeth = 1;
p.pbApply = false;
p.pbDat = 1;
p.pbprm{1} = 7;
p.pbPrm{2} = [0 1 6 % FRET
    0 1 6 % S
    0 1 6 % I
    0 1 6 % I
    0 1 6 % I
    0 1 6 % I
    0 1 6 % all I
    0 1 6]; % summed I

% default factor corrections parameters
p.factMeth = 1;
p.fact = 1; % gamma factor
p.factPrm{1} = {}; % .gam and/or .bet files
p.factPrm{2} = repmat([0,2,1,10],p.nL,1);
p.factPrm{3} = [-0.2,50,1.2
    1,50,5];

% default find states parameters
nDat = p.nChan*p.nL+size(p.es{p.nChan,p.nL}.calc.fret,1)+...
    size(p.es{p.nChan,p.nL}.calc.s,1);
p.fsMeth = 6; % threshold, vbFRET, 2D-vbFRET, one state, CPA, STaSI
p.fsDat = 1; % bottom, top , all
p.fsPrm = [2  0  0 1 0 0 0 0
    1  2  1 1 0 0 0 0
    1  2  1 1 0 0 0 0
    0  0  0 0 0 0 0 0
    50 90 2 1 0 0 0 0
    2  0  0 1 0 0 0 0]; % method settings
p.fsPrm = repmat(p.fsPrm,[1,1,nDat]);
p.fsThresh = [-Inf,0,0.6
    0.7,1,Inf];
p.fsThresh = repmat(p.fsThresh,[1,1,nDat]);

% default TDP settings
p.tdpPrm = [-0.2,0.01,1.2,1,0,0,1,1];

% default state configuration
p.clstMeth = 2; % clustering method
p.clstMethPrm = [Vmax,50,false,100];
p.clstConfig = [1,1,1,1]; % constraint, diagonal clusters, likelihood, shape
p.clstStart = [linspace(0,1,Vmax)',repmat(0.1,[Vmax,1])];

% default export options
p.tdp_expOpt = [false,4,false,3,false,false,false,false,false,false,false,...
    false];

% default parameters for model optimization
p.nMax = nMax;
p.restartNb = T;

% defaults for simulation
p.L = 100; % video length (frames)
p.rate = 10; % frame acquisition rate (frame/s)
p.pixdim = 0.53; % pixel dimensions (um)
p.bitrate = 14; % bit rate (bit/s)
p.viddim = [256,256]; % video dimensions (pixels)
p.camnoise = 2; % Gaussian-type camera noise
p.camprm = [113,0,0.95,0,1,0; ...
    113,0.067,0.95,0,57.8,0; ...
    106.9,0.02,0.95,2,57.7,20.5; ...
    113,0,1,0,1,0; ...
    113,0.067,0.95,0.02,300,5.199]; % parameters of camera noise distributions

% defaults for Molecules
p.N = 12; % sample size
p.J = 2; % number of states
p.FRET = [0,0.25]; % FRET values
p.wFRET = [0,0]; % FRET deviations
p.k = [0,1,0;
    0.1,0,0.01;
    0.01,0.05,0]; % transition rates (s-1)
p.pc_in = true; % input intensity units in photon counts
p.Itot = 40; % total intensity
p.wItot = 0; % total intensity deviation
p.gamma = 1; % gamma factor
p.wGamma = 0; % gamma factor deviation
p.dE = [0,0]; % direct excitation coefficients
p.Bt = [0,0]; % bleedthrough coefficients
p.bleach = true; % apply photobleaching
p.t_bleach = p.L; % bleaching time constant

% defaults for Experimental setup
p.psf = false; % apply PSF convolution
p.psfW = [0.3526,0.38306];
p.defocus = false; % apply defocusing
p.defocus_prm = [0,0]; % defocusing exponential time constant and defocusing initial amplitude
p.bg = 1; % background spatial distribution
p.bgI = [0,0]; % background intensities
p.bgW = [127,256]; % backgoround Gaussian widths
p.bgImg = 'bgimg.png';
p.bgDec = true; % apply dynamic background
p.bgDec_prm = [p.L/(2*p.rate),1]; % background decay constant and multiplication factor for initial backgroudn amplitude
p.annexpth = '';

% default for Export options
p.mat = false; % export .mat trace file
p.sira = false; % export .sira video file
p.avi = false; % export .avi video file
p.txt = true; % export .txt trace file
p.dt = false; % export .dt dwell time file
p.log = true; % export .log simulation parameters file
p.coord = false; % export .coord coordinates file
p.un_out = 1; % exported intensities units

