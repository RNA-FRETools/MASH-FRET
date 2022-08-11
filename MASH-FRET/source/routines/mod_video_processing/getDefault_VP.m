function p = getDefault_VP
% p = getDefault_VP
%
% Generates default values for Video processing interface parameters
%
% p: structure that contain default parameters

% defaults
nChan_max = 3;
nL_max = 3;
nChan_def = 2;
nL_def = 2;
vers = [2015,2020,2022];
nVers = size(vers,2);
deflbl = {'don','acc1','acc2'};
expT = 0.1;

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
p.vers = vers;
p.nChan_max = nChan_max;
p.nL_max = nL_max;

% parameters for visualization area (video length = [20,100])
p.vid_files = {sprintf('%i.sira',vers(end-1)),... % .spe missing
    sprintf('%i.sif',vers(1))...
    sprintf('%i.png',vers(end-1))...
    sprintf('%i.avi',vers(end-1))...
    sprintf('%i.gif',vers(end-1)),...
    sprintf('%i.tif',vers(end-1)),...
    sprintf('%i.pma',vers(end-1)),...
    sprintf('%i.pma',vers(end)),...
    sprintf('%i_%ichan.coord',vers(end-1),nChan_def),...
    sprintf('%i_%ichan.spots',vers(end-1),nChan_def)}; 
p.tracecurs_file = 'createTraceCursor.png'; % exported image file from "Create trace" cursor
p.exp_axes = 'graph.png';

% parameters for "Plot"
p.perSec = true; % units per second
p.cmap = 1; % color map

% parameters for "Experiment settings"
p.nChan = nChan_def; % number of channels
p.nL = nL_def; % number of laser
p.wl = [];
while isempty(p.wl) || numel(unique(p.wl))~=nL_max
    p.wl = round(1000*sort(rand(1,nL_max))); % laser wavelength
end
p.expT = expT; % exposure time
p.projOpt = cell(nL_max,nChan_max);
for nL = 1:nL_max
    for nChan = 1:nChan_max
        p.projOpt{nL,nChan}.proj_title = ...
            sprintf('test_%ichan%iexc',nChan,nL); % project title
        p.projOpt{nL,nChan}.mol_name = 'none'; % molecule name
        p.projOpt{nL,nChan}.conc_mg = round(100*rand(1)); % Mg concentration
        p.projOpt{nL,nChan}.conc_k = round(500*rand(1)); % K concentration
        p.projOpt{nL,nChan}.laser_pow = round(100*rand(1,nL)); % laser powers
        p.projOpt{nL,nChan}.prm_extra = {'buffer',1,''};
        p.projOpt{nL,nChan}.labels = deflbl(1:nChan); % channel labels
        chanExc = zeros(1,nChan);
        chanExc(1:min([nChan,nL])) = p.wl(1:min([nChan,nL]));
        p.projOpt{nL,nChan}.chanExc = chanExc; % channel-specific excitation
        FRET = [];
        for don = 1:(nChan-1)
            if chanExc(don)>0
                for acc = (don+1):nChan
                    FRET = cat(1,FRET,[don,acc]);
                end
            end
        end
        p.projOpt{nL,nChan}.FRET = FRET; % FRET pairs
        if ~isempty(FRET)
            p.projOpt{nL,nChan}.S = ...
                FRET(chanExc(FRET(:,1))>0 & chanExc(FRET(:,2))>0,:); % stoichiometries
        else
            p.projOpt{nL,nChan}.S = [];
        end
    end
end

% parameters for "Edit and export video"
p.bg_corr = 18; % image filters
p.bg_all = false; % apply to current frame only
p.bg_prm = [0 0
     3 0
     3 0
     3 0
     3 1
     3 200
     200 0
     3 0.99
     0.5 0
     1500 0
     0 2
     0 50
     0 0.5
     0 0
     0 0
     3 1
     0 0
     2 0
     10 0];
p.bg_file = 'bgimg.png';
p.vid_start = 2;
p.vid_end = 7;
p.exp_vid = 'export';
p.exp_fmt = {'.sira','.tif','.gif','.mat','.avi'};

% parameters for "Molecule coordinates"
p.ave_iv = 2; % frame interval for average image
p.ave_start = 2; % first frame index for average image
p.ave_end = 15; % laste frame index for average image
p.exp_ave = 'ave.png'; % exported average image
p.sf_meth = 2; % spot finder method
p.sf_fit = false; % fit spots with Gaussians
p.sf_all = false; % apply spotfinder to all video frames
p.sf_prm = [0,0,0,0,0,0,0,0,0,0,0,0 % spot finder parameters
    10000,5,5,7,7,20,0,1,3,0,1,150
    10000,5,5,7,7,20,0,1,3,0,1,150
    1.4,5,5,0,7,20,0,1,3,0,1,150
    1000,5,5,7,0,20,0,1,3,0,1,150];
p.exp_spots = {'spots_sf%i.spots','spots_sf%i_fit.spots'}; % exported spots file
p.exp_tracks = {'tracks_sf%i.spots','tracks_sf%i_fit.spots'}; % exported tracks file

p.ave_file = cell(1,nChan); % imported reference image files
p.ref_file = cell(1,nChan); % imported reference coordinates files
p.spots_file = cell(1,nChan); % imported spots coordinates files
p.exp_ref = cell(1,nChan); % exported reference coordinates
p.exp_trsf = cell(1,nChan); % exported transformation files
p.exp_trsfImg = cell(nChan_max,nVers); % exported transformed image files
p.exp_coord = cell(nChan_max,nVers); % exported transformed coordinates files
for nChan = 1:nChan_max
    if nChan==1
        p.ave_file{nChan} = '';
        p.ref_file{nChan} = '';
        p.exp_ref{nChan} = '';
        p.exp_trsf{nChan} = '';
    else
        p.ave_file{nChan} = sprintf('%i_%ichan_ref.png',vers(end-1),nChan);
        p.ref_file{nChan} = sprintf('%i_%ichan_ref.map',vers(end-1),nChan);
        p.exp_ref{nChan} = sprintf('%ichan.map',nChan);
        p.exp_trsf{nChan} = sprintf('%ichan_trsf.mat',nChan);
    end
    p.spots_file{nChan} = sprintf('%i_%ichan.spots',vers(end-1),nChan);
    for v = 1:(nVers-1)
        if nChan==1
            p.trsf_file{nChan,v} = '';
            p.exp_coord{nChan,v} = '';
            p.exp_trsfImg{nChan,v} = '';
        else
            p.trsf_file{nChan,v} = ...
                sprintf('%i_%ichan_ref_trs.mat',vers(v),nChan);
            p.exp_coord{nChan,v} = ...
                sprintf('%ichan_%i.coord',nChan,vers(v));
            p.exp_trsfImg{nChan,v} = ...
                sprintf('%ichan_trsf%i.png',nChan,vers(v));
        end
    end
end
p.ref_impOpt = cell(nChan_max,3); % reference coordinates import options
for nChan = 1:nChan_max
    if nChan==1
        continue
    end
    p.ref_impOpt{nChan,1} = [256,256];
    p.ref_impOpt{nChan,2} = [1,2];
    p.ref_impOpt{nChan,3} = ...
        [(2:(nChan+1))',nChan*ones(nChan,1),zeros(nChan,1)];
end
p.spots_impOpt = [1,2]; % spots coordinates import options

% parameters for "Intensity integration"
p.coord_impOpt = {[1,2;3,4],1};
p.coord_file = cell(1,nChan_max); % coordinates files
for nChan = 1:nChan_max
    if nChan==1
        p.coord_file{nChan} = sprintf('2020_%ichan.spots',nChan);
    else
        p.coord_file{nChan} = sprintf('2020_%ichan.coord',nChan);
    end
end
p.pixDim = 5;
p.nPix = 8;
p.pixAve = true;
p.expFmt = {'all-in-one ASCII','one-by-one ASCII','HaMMy','vbFRET','QUB',...
    'SMART','ebFRET'}; % exported files 
p.expOpt = false(1,7); % export options
p.exp_traceFile = cell(nL_max,nChan_max);
for nL = 1:nL_max
    for nChan = 1:nChan_max
        p.exp_traceFile{nL,nChan}= sprintf('%ichan%iexc.mash',nChan,nL);
    end
end

