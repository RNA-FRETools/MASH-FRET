function p = getDefault_VP
% p = getDefault_VP
%
% Generates default values for Video processing interface parameters
%
% p: structure that contain default parameters

% general parameters
[pname,o,o] = fileparts(mfilename('fullpath'));
p.annexpth = cat(2,pname,filesep,'assets'); % path to annexed files
p.dumpdir = cat(2,pname,filesep,'dump'); % path to exported data
if ~exist(p.dumpdir,'dir')
    mkdir(p.dumpdir);
end

% parameters for video import (video length = [20,100])
p.vid_file = {'2015.sif','2020.sira','2020.png','2020.avi','2020.gif',...
    '2020.tif','2020_2chan.coord','2020_2chan.spots'}; % .spe and .pma missing

% parameters for "Plot"
p.persec = true; % units per second
p.cmap = 1; % color map

% parameters for "Experiment settings"
p.nChan = 2; % number of channels
p.nL = 2; % number of laser
p.wl = [530,640,760]; % laser wavelength
p.expT = 0.1; % exposure time
p.proj_title = 'test_project'; % project title
p.mol_name = 'none'; % molecule name
p.conc_mg = []; % Mg concentration
p.conc_k = []; % K concentration
p.pow = []; % laser powers
p.labels = {'don','acc1','acc2'}; % channel labels
p.chanExc = [530,640]; % channel-specific excitation
p.FRET = [1,2;1,3;2,3]; % FRET pairs
p.S = [1,2;1,3;2,3]; % stoichiometries

% parameters for "Edit and export video"
p.bg_corr = 1; % no image filter
p.bg_all = false; % apply to current frame only
p.bg_prm = [0,0 % filter parameters
    3,0
    3,0
    3,0
    3,1
    3,200
    200,0
    3,0.99
    0.5,1500
    0,0
    0,50
    0,0.5
    0,0
    0,0
    3,1
    0,0
    10,0
    -90,0];
p.bg_file = 'bgimg.png';
p.vid_start = 1;
p.vid_end = 15;
p.exp_vid = 'export';
p.exp_fmt = '.sira'; 

% parameters for "Molecule coordinates"
p.ave_iv = 2; % frame interval for average image
p.ave_start = 2; % first frame index for average image
p.ave_end = 15; % laste frame index for average image
p.ave_file = 'ave.png'; % exported average image
p.sf_meth = 1; % spot finder method
p.sf_fit = false; % fit spots with Gaussians
p.sf_all = false; % apply spotfinder to all video frames
p.sf_prm = [0,0,0,0,0,0,0,0,0,0,0,0 % spot finder parameters
    1000,7,7,5,5,20,1100,1,3,0,1,150
    1000,7,7,5,5,20,1100,1,3,0,1,150
    1.4,7,7,0,5,20,1100,1,3,0,1,150
    100,7,7,5,0,20,100,1,3,0,1,150];
p.exp_spots = 'spots.spots'; % exported spots file
p.exp_tracks = 'tracks.spots'; % exported tracks file
p.ave_file = {'','2020_2chan_ref.ave','2020_3chan_ref.ave'}; % reference image files
p.ref_file = {'','2020_2chan_ref.map','2020_3chan_ref.map'}; % reference coordinates files
p.trsf_file = {'','';... % old and new transformation files
    '2015_2chan_ref.mat','2020_2chan_ref.mat';...
    '2015_3chan_ref.mat','2020_3chan_ref.mat'};
p.spot_file = {'2020_1chan.spots','2020_2chan.spots','2020_3chan.spots'}; % spots coordinates files

% parameters for "Intensity integration"
p.coord_file = {'2020_1chan.spots','2020_2chan.coord','2020_3chan.coord'}; % coordinates files
p.pixDim = 5;
p.nPix = 8;
p.pixAve = true;
p.expOpt = false(1,7); % exported files (ascii all,ascii each,hammy,vbfret,qub,smart,ebfret)
