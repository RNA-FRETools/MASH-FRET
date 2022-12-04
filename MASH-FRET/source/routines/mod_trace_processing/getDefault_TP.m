function p = getDefault_TP
% p = getDefault_TP
%
% Generates default values for Trace processing testing
%
% p: structure that contain default parameters

% defaults
nChan_max = 3;
nL_max = 3;
nChan_def = 2;
nL_def = 2;
defprm = {'Movie name' '' ''
       'Molecule name' '' ''
       '[Mg2+]' [] 'mM'
       '[K+]' [] 'mM'};
nScreenPrm = 10;
labels = {'Cy3','Cy5','Cy7'};

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
p.nChan_max = nChan_max;
p.nL_max = nL_max;

% parameters for project management area
p.nChan_def = nChan_def;
p.nL_def = nL_def;
p.nChan = nChan_def;
p.nL = nL_def;
p.wl = [];
while isempty(p.wl) || numel(unique(p.wl))~=nL_max % laser wavelengths
%     p.wl = round(1000*sort(rand(1,nL_max))); % use random numbers
    p.wl = (0:nL_max-1)*106 + 532; % use fixed numbers (for merging compatibile projects)
end
p.mash_files = cell(nL_max,nChan_max);
p.exp_ascii2mash = cell(nL_max,nChan_max);
p.es = cell(nChan_max,nL_max);
for nL = 1:nL_max
    defprm_nL = defprm;
    for l = 1:nL
        defprm_nL{size(defprm,1)+l,1} = ['Power(',num2str(p.wl(l)),'nm)'];
        defprm_nL{size(defprm,1),2} = '';
        defprm_nL{size(defprm,1),3} = 'mW';
    end
    for nChan = 1:nChan_max
        p.es{nChan,nL}.imp.vfile = {''};
        p.es{nChan,nL}.imp.tdir = sprintf('%ichan%iexc',nChan,nL);
        dir_content = dir(...
            [p.annexpth,filesep,p.es{nChan,nL}.imp.tdir,filesep,'*.txt']);
        p.es{nChan,nL}.imp.tfiles = {};
        for n = 1:size(dir_content,1)
            p.es{nChan,nL}.imp.tfiles = cat(2,p.es{nChan,nL}.imp.tfiles,...
                dir_content(n,1).name);
        end
        p.es{nChan,nL}.imp.coordfile = '';
        p.es{nChan,nL}.imp.coordopt = [];
        
        p.es{nChan,nL}.chan.nchan = nChan;
        p.es{nChan,nL}.chan.emlbl = labels(1:nChan);
        
        p.es{nChan,nL}.las.nlas = nL;
        p.es{nChan,nL}.las.laswl = p.wl(1:nL);
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
        
        p.es{nChan,nL}.fstrct = {[2 2 1 1 1 0 1],ones(1,nL),...
            [1+(1:nChan)',1+(1:nChan)',zeros(nChan,1)],...
            ones(nChan,3,nL),ones(size(FRET,1),3)};
        
        p.es{nChan,nL}.div.projttl = sprintf('test_%ichan%iexc',nChan,nL);
        p.es{nChan,nL}.div.molname = 'none';
        p.es{nChan,nL}.div.expcond = defprm_nL;
        p.es{nChan,nL}.div.splt = 0.2;
        rands = rand(size(p.es{nChan,nL}.calc.s,1),1);
        rande = rand(size(FRET,1),1);
        randi = rand(nChan*nL,1);
        p.es{nChan,nL}.div.plotclr = [...
            repmat(rands,1,2),ones(size(p.es{nChan,nL}.calc.s,1),1);...
            rande,ones(size(p.es{nChan,nL}.calc.fret,1),1),rande;...
            ones(nChan*nL,1),repmat(randi,1,2)];
        
        p.mash_files{nChan,nL} = sprintf('%ichan%iexc.mash',nChan,nL);
        
        p.exp_ascii2mash{nChan,nL} = ...
            sprintf('ascii_%ichan%iexc.mash',nChan,nL);
    end
end
p.coord_file = '2chan.coord';
p.coord_fline = 1;
p.vid_width = 100;
p.vid_file = '2chan2exc.sira';
p.gamma_files = {'2chan2exc_1.gam','2chan2exc_2.gam','2chan2exc_3.gam'};
p.beta_files = {'2chan2exc_1.bet','2chan2exc_2.bet','2chan2exc_3.bet'};
p.states_fcol = [5,5,0];
p.exp_coord1 = 'coordFromFile.mash';
p.exp_coord2 = 'coordFromHeader.mash';
p.exp_vid = 'vidFromFile.mash';
p.exp_gam = 'gamFromFile.mash';
p.exp_bet = 'betFromFile.mash';
p.exp_states = 'statesFromFile.mash';
p.exp_sortProj = '2chan2exc_sort.mash';
p.exp_merged = 'merged.mash';

% parameters for panel Sample management
p.tmOpt{1} = [0,50,1120 % histogram limits
    0,50,255
    0,50,175
    0,50,300
    0,50,1270
    0,50,470
    -0.2,50,1.2
    -0.2,50,1.2];
p.tmOpt{2}{1} = {'D','A1','A2','static','dynamic'}; % default tag names
p.tmOpt{2}{2} = rand(size(p.tmOpt{2}{1},2),3); % default tag colors
p.tmOpt{2}{3} = 3; % number of molecules in display
p.tmOpt{3}(1) = 50; % number of histogram intervals
p.tmOpt{3}(2) = 1; % condition of range
p.tmOpt{3}(3) = 10; % confidence level 1
p.tmOpt{3}(4) = 90; % confidence level 2
p.tmOpt{3}(5) = 1; % units

% parameters for panel Plot
p.perSec = true;
p.inSec = false;
p.fixX0 = false;
p.x0 = 10;

% parameters for panel Sub-images
p.contrast = 90;
p.brightness = 60;

% parameters for panel Background
p.bgMeth = 2;
p.bgPrm = [... % param1, param2, bg intensity, x-dark, y-dark, auto dark
    0   20 100 0  0  0 % Manual
    0   20 0   0  0  0 % 20 darkest
	0   20 0   0  0  0 % Mean value
	100 20 0   0  0  0 % Most frequent value
	0.5 20 0   0  0  0 % Histotresh
	10  20 0   55 10 1 % Dark trace
	2   20 0   0  0  0];% Median
p.bgApply = true;
p.exp_bgTrace1 = 'darkTrace_auto.png';
p.exp_bgTrace2 = 'darkTrace_man.png';
simgw = (5*(1:nScreenPrm))';
p.bgPrm_screen = [];
for meth = 1:size(p.bgPrm,1)
    switch meth
        case 3
            prm1screen = (0:(nScreenPrm-1))';
        case 4
            prm1screen = round(linspace(10,100,nScreenPrm)');
        case 5
            prm1screen = linspace(0,1,nScreenPrm)';
        case 6
            prm1screen = round(linspace(0,10,nScreenPrm)');
        case 7
            prm1screen = ones(nScreenPrm,1);
            prm1screen(round(nScreenPrm/2):end) = 2;
        otherwise
            prm1screen = zeros(nScreenPrm,1);
    end
    p.bgPrm_screen = cat(3,p.bgPrm_screen,[simgw,prm1screen]);
end
p.exp_bgTrace_0D1 = 'darkTrace_0D_auto.png';
p.exp_bgTrace_0D2 = 'darkTrace_0D_man.png';
p.exp_bgTrace_1D1 = 'darkTrace_1D_auto.png';
p.exp_bgTrace_1D2 = 'darkTrace_1D_man.png';
p.exp_bgTrace_2D1 = 'darkTrace_2D_auto.png';
p.exp_bgTrace_2D2 = 'darkTrace_2D_man.png';
p.exp_bga{1} = 'bgares_0D_%i.bga';
p.exp_bga{2} = 'bgares_1D_%i.bga';
p.exp_bga{3} = 'bgares_2D_%i.bga';

% parameters for panel Cross-talks
p.bt = [0,0.07 % bleedthrought coefficients
    0,0];
p.de = [0,0 % direct excitation coefficients
    0.02,0];

% parameters for panel Denoising
p.denMeth = 1; % index in list of denoising method
p.denApply = false; % (1) to denoise traces, (0) otherwise
p.denPrm = [3,0,0 % denosiing method settings
    5 1 2
    3 2 1];

% parameters for panel Photobleaching
p.pbMeth = 1; % index in list of photobleaching detection method
p.pbApply = false; % (1) clip traces (0) otherwise
p.pbDat = 1; % index in list of data to use in threshold method
p.pbPrm{1} = 7; % manual cutoff frame
p.pbPrm{2} = [0 1 6 % threshold settings for FRET
    0 1 6 % ... for S
    0 1 6 % ... for I1_1
    0 1 6 % ... for I2_1
    0 1 6 % ... for I1_2
    0 1 6 % ... for I2_2
    0 1 6 % ... for all I
    0 1 6]; % ... for summed I

% parameters for panel Factor corrections
p.factMeth = 1; % index in list of factor calculation method
p.fact = [1,1]; % manual gamma and beta factors
p.factPrm{1} = {'',''}; % source directory and factor files
p.factFiles = {'2chan2exc_1.gam','2chan2exc_1.bet',...
    '2chan2exc_2.gam','2chan2exc_2.bet',...
    '2chan2exc_3.gam','2chan2exc_3.bet'}; % .gam and/or .bet files
p.factPrm{2} = [p.nL,0,2,1,10]; % settings of photobleaching-based calculation method
p.factPrm{3} = [1,-0.2,50,1.2,1,50,5,1]; % settings of ES linear regression calculation method

% set default find states parameters
p.fsMeth = 6; % index in list of state finding method
p.fsDat = 1; % find states in (1) bottom traces, (2) top traces, (3) all traces
p.fsPrm = [2  0  0 1 0 0 0 0 % state finding method settings
    1  2  1 1 0 0 0 0
    1  2  1 1 0 0 0 0
    0  0  0 0 0 0 0 0
    50 90 2 1 0 0 0 0
    2  0  0 1 0 0 0 0]; 
p.fsThresh = [-Inf,0,0.6 % state values and thresholds
    0.7,1,Inf];

% parameters for visualization area
p.exp_axes = 'axes';
p.exp_figpreview = 'figure_preview';

% parameters for file export
p.expOpt.traces = [false,7,true,true,true,true,true,2];
p.expOpt.hist = [false,true,-1000,100,4000,true,-0.2,0.01,1.2,true,-0.2,...
    0.01,1.2,true];
p.expOpt.dt = [false,true,true,true,true];
p.expOpt.fig = {[false,1,6,true,true,0,0,true,0,true,true,false],''};
p.expOpt.gen = [true,0];

