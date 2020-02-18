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
deflbl = {'don','acc1','acc2'};

% general parameters
[pname,o,o] = fileparts(mfilename('fullpath'));
p.annexpth = cat(2,pname,filesep,'assets'); % path to annexed files
p.dumpdir = cat(2,pname,filesep,'dump'); % path to exported data
if exist(p.dumpdir,'dir')
    cd(p.annexpth); % change directory
    try
        rmdir(p.dumpdir); % delete dump directory
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
p.nChan = nChan_def;
p.nL = nL_def;
p.wl = [];
while isempty(p.wl) || numel(unique(p.wl))~=nL_max
    p.wl = round(1000*sort(rand(1,nL_max))); % laser wavelengths
end
p.mash_files = cell(nL_max,nChan_max);
p.ascii_dir = cell(nL_max,nChan_max);
p.ascii_files = cell(nL_max,nChan_max);
p.exp_ascii2mash = cell(nL_max,nChan_max);
p.asciiOptopt = cell(nChan_max,nL_max);
p.projOpt = cell(nChan_max,nL_max);
for nL = 1:nL_max
    defprm_nL = defprm;
    for l = 1:nL
        defprm{size(defprm,1)+l,1} = ['Power(',num2str(p.wl(l)),'nm)'];
        defprm{size(defprm,1),2} = '';
        defprm{size(defprm,1),3} = 'mW';
    end
    for nChan = 1:nChan_max
        
        p.mash_files{nL,nChan} = sprintf('%ichan%iexc.mash',nChan,nL);
        
        p.ascii_dir{nL,nChan} = sprintf('%ichan%iexc',nChan,nL);
        dir_content = dir(...
            [p.annexpth,filesep,p.ascii_dir{nL,nChan},filesep,'*.txt']);
        p.ascii_files{nL,nChan} = {};
        for n = 1:size(dir_content,1);
            p.ascii_files{nL,nChan} = cat(2,p.ascii_files{nL,nChan},...
                dir_content(n,1).name);
        end
        
        p.exp_ascii2mash{nL,nChan} = sprintf('%ichan%iexc_ascii.mash',...
            nChan,nL);
        
        p.asciiOpt{nL,nChan}.intImp = {...
            [3 0 true 1 2 (2+nChan-1) nChan nL false 5],p.wl(1:nL)};
        p.asciiOpt{nL,nChan}.vidImp = {false ''};
        p.asciiOpt{nL,nChan}.coordImp = {{false,'',{[1 2],1},256},[false 1]};
        p.asciiOpt{nL,nChan}.expCond = defprm_nL;
        p.asciiOpt{nL,nChan}.factImp = {false '' {} false '' {}};
        
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
p.coord_file = '2chan.coord';
p.coord_fline = 1;
p.vid_width = 100;
p.vid_file = '2chan2exc.sira';
p.gamma_files = {'2chan2exc_1.gam','2chan2exc_2.gam','2chan2exc_3.gam'};
p.beta_files = {'2chan2exc_1.bet','2chan2exc_2.bet','2chan2exc_3.bet'};
p.states_fcol = 5;
p.exp_coord1 = 'coordFromFile.mash';
p.exp_coord2 = 'coordFromHeader.mash';
p.exp_vid = 'vidFromFile.mash';
p.exp_gam = 'gamFromFile.mash';
p.exp_bet = 'betFromFile.mash';
p.exp_states = 'statesFromFile.mash';

% parameters for panel Sample management
p.exp_figpreview = 'figure_preview';
p.expOpt.traces = [false,7,true,true,true,true,true,2];
p.expOpt.hist = [false,true,-1000,100,4000,true,-0.2,0.01,1.2,true,-0.2,...
    0.01,1.2,true];
p.expOpt.dt = [false,true,true,true,true];
p.expOpt.fig = {[false,1,6,true,true,0,0,true,0,true,true,false],''};
p.expOpt.gen = [true,0];
p.tmOpt.def_labels = {'D','A1','A2','static','dynamic'};

% parameters for panel Sub-images

% parameters for panel Background

% parameters for panel Cross-talks

% parameters for panel Denoising

% parameters for panel Photobleaching

% parameters for panel Factor corrections

% parameters for panel Find states

% parameters for visualization area
