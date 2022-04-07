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
vers = [2015,2020];
nVers = size(vers,2);

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

% general parameters
p.nChan_def = nChan_def; % number of channels
p.nL_def = nL_def; % number of laser
p.nChan = nChan_def;
p.nL = nL_def;
p.nChan_max = nChan_max;
p.nL_max = nL_max;
p.vers = vers;

% parameters for visualization area (video length = [20,100])
p.vid_files = {sprintf('%i.sira',vers(end)),... % .spe missing
    sprintf('%i.sif',vers(1))...
    sprintf('%i.png',vers(end))...
    sprintf('%i.avi',vers(end))...
    sprintf('%i.gif',vers(end)),...
    sprintf('%i.tif',vers(end)),...
    sprintf('%i.pma',vers(end))};

% experiment settings
p.es = cell(nChan_max,nL_max);
for nChan = 1:nChan_max
    for nL = 1:nL_max
        p.es{nChan,nL}.imp.vfile = {''};
        p.es{nChan,nL}.chan.nchan = nChan;
        p.es{nChan,nL}.chan.emlbl = ['donem',cellstr(...
            [repmat('accem',nChan-1,1),num2str((1:(nChan-1))')])'];
        p.es{nChan,nL}.las.nlas = nL;
        p.es{nChan,nL}.las.laswl = 100*(1:nL);
        p.es{nChan,nL}.las.lasem = [1:min([nChan,nL]),...
            zeros(1,nL-min([nChan,nL]))];
        FRET = [];
        for don = 1:(nChan-1)
            if any(p.es{nChan,nL}.las.lasem==don)
                for acc = (don+1):nChan
                    FRET = cat(1,FRET,[don,acc]);
                end
            end
        end
        p.es{nChan,nL}.calc.fret = FRET;
        p.es{nChan,nL}.calc.s = [];
        if ~isempty(FRET)
            for pair = 1:size(FRET,1)
                if any(p.es{nChan,nL}.las.lasem==FRET(pair,2))
                    p.es{nChan,nL}.calc.s = cat(1,p.es{nChan,nL}.calc.s,...
                        FRET(pair,:));
                end
            end
        end
        p.es{nChan,nL}.div.projttl = '';
        p.es{nChan,nL}.div.molname = 'chanexc';
        p.es{nChan,nL}.div.expcond = {'param1','0','units1';'param2',...
            'value2','units2'};
        p.es{nChan,nL}.div.splt = 0.2;
        rands = rand(size(p.es{nChan,nL}.calc.s,1),1);
        rande = rand(size(p.es{nChan,nL}.calc.fret,1),1);
        randi = rand(nChan*nL,1);
        p.es{nChan,nL}.div.plotclr = [...
            repmat(rands,1,2),ones(size(p.es{nChan,nL}.calc.s,1),1);...
            rande,ones(size(p.es{nChan,nL}.calc.fret,1),1),rande;...
            ones(nChan*nL,1),repmat(randi,1,2)];
    end
end

% parameters for "Plot"
p.cmap = 17; % color map

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
p.vid_iv = 2;
p.exp_fmt = {'.sira','.tif','.gif','.mat','.avi'};

% parameters for "Molecule coordinates"
p.ave_iv = 2; % frame interval for average image
p.ave_start = 2; % first frame index for average image
p.ave_end = 15; % laste frame index for average image
p.sf_meth = 2; % spot finder method
p.sf_fit = false; % fit spots with Gaussians
p.sf_prm = [0,0,0,0,0,0,0,0,0,0,0,0 % spot finder parameters
    1000,5,5,7,7,20,0,1,3,0,1,150
    1000,5,5,7,7,20,0,1,3,0,1,150
    1.4,0,5,7,7,20,0,1,3,0,1,150
    100,5,0,7,7,20,0,1,3,0,1,150];

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
        p.ave_file{nChan} = sprintf('%i_%ichan_ref.png',vers(end),nChan);
        p.ref_file{nChan} = sprintf('%i_%ichan_ref.map',vers(end),nChan);
        p.exp_ref{nChan} = sprintf('%ichan.map',nChan);
        p.exp_trsf{nChan} = sprintf('%ichan_trsf.mat',nChan);
    end
    p.spots_file{nChan} = sprintf('%i_%ichan.spots',vers(end),nChan);
    for v = 1:nVers
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
    p.ref_impOpt{nChan,1} = [];
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
p.expFmt = {'all-in-one ASCII','one-by-one ASCII','HaMMy','vbFRET','QUB',...
    'SMART','ebFRET'}; % exported files 
p.expOpt = false(1,7); % export options
p.exp_traceFile = cell(nL_max,nChan_max);
for nL = 1:nL_max
    for nChan = 1:nChan_max
        p.exp_traceFile{nL,nChan}= sprintf('%ichan%iexc.mash',nChan,nL);
    end
end

