function p = getDefault_S
% p = getDefault_S
%
% Generates default values for Simulation interface parameters
%
% p: structure that contain default parameters

% general parameters
[pname,o,o] = fileparts(mfilename('fullpath'));
p.annexpth = cat(2,pname,filesep,'assets'); % path to annexed files
p.dumpdir = cat(2,pname,filesep,'dump'); % path to exported data
if exist(p.dumpdir,'dir')
    cd(p.annexpth); % change directory
    try
        warning off MATLAB:RMDIR:RemovedFromPath
        rmdir(p.dumpdir,'s'); % delete dump directory
    catch err
        disp(cat(2,'WARNING: the previous dump directory could not be ',...
            'deleted (needs administrator privileges).'));
        disp(' ');
    end
end
if ~exist(p.dumpdir,'dir')
    mkdir(p.dumpdir); % create new dump directory
end

% defaults for Experiment settings
p.projttl = 'test_sim';
p.molname = 'unknown';
p.expcond = {'param1','0','units1';'param2','value2','units2'};
p.splt = 0.2;
p.plotclr = [0.5,0.5,1;1,0.5,0.5;0.5,1,0.5];

% defaults for Video parameters
p.L = 100; % video length (frames)
p.rate = 10; % frame acquisition rate (frame/s)
p.pixdim = 0.53; % pixel dimensions (um)
p.bitrate = 14; % bit rate (bit/s)
p.viddim = [256,256]; % video dimensions (pixels)
p.camnoise = 1; % offset-type camera noise
p.camprm = [113,0,0.95,0,1,0; ...
    113,0.067,0.95,0,57.8,0; ...
    106.9,0.02,0.95,2,57.7,20.5; ...
    113,0,1,0,1,0; ...
    113,0.067,0.95,0.02,300,5.199]; % parameters of camera noise distributions

% defaults for Molecules
p.N = 12; % sample size
p.coordfiles = {'coord_sim.coord','coord_vp.map','coord_vp.coord'}; % coordinates files
p.presetfiles = {'simprm_fret.mat','simprm_k.mat','simprm_coord.mat',...
    'simprm_itot.mat','simprm_gamma.mat','simprm_psf.mat','simprm_all.mat'};
p.J = 5; % number of states
p.FRET = [0,0.25,0.5,0.75,1]; % FRET values
p.wFRET = [0,0.01,0,0,0]; % FRET deviations
p.k = [0,1,0,0,0.1;
    0,0,0.01,0,0.1;
    0,0.05,0,1,0.1;
    0,0,0.01,0,0.1;
    0.1,0.1,0.1,0.1,0.1]; % transition rates (s-1)
p.pc_in = true; % input intensity units in photon counts
p.Itot = 40; % total intensity
p.wItot = 3; % total intensity deviation
p.gamma = 0.61; % gamma factor
p.wGamma = 0.05; % gamma factor deviation
p.dE = [0,0.02]; % direct excitation coefficients
p.Bt = [0.07,0]; % bleedthrough coefficients
p.bleach = true; % apply photobleaching
p.t_bleach = p.L; % bleaching time constant

% defaults for Experimental setup
p.psf = false; % apply PSF convolution
p.psfW = [0.3526,0.38306];
p.defocus = false; % apply defocusing
p.defocus_prm = [0,0]; % defocusing exponential time constant and defocusing initial amplitude
p.bg = 1; % background spatial distribution
p.bgI = [0,0]; % background intensities
p.bgW = [127,256]; % background Gaussian widths
p.bgImg = 'bgimg.png';
p.bgDec = true; % apply dynamic background
p.bgDec_prm = [p.L/(2*p.rate),1]; % background decay constant and multiplication factor for initial backgroudn amplitude

% default for Export options
p.mat = false; % export .mat trace file
p.sira = false; % export .sira video file
p.avi = false; % export .avi video file
p.txt = false; % export .txt trace file
p.dt = false; % export .dt dwell time file
p.log = true; % export .log simulation parameters file
p.coord = false; % export .coord coordinates file
p.un_out = 1; % exported intensities units

% default for visulaization area
p.exp_axes = 'graph_%i.png';


