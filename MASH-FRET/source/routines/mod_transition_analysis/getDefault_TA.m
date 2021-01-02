function p = getDefault_TA
% p = getDefault_TA
%
% Generates default values for Transition analysis testing
%
% p: structure that contain default parameters

% defaults
nChan_min = 2;
nChan_max = 3;
nL_max = 3;
nChan_def = 2;
nL_def = 2;
defprm = {'Movie name' '' ''
       'Molecule name' '' ''
       '[Mg2+]' [] 'mM'
       '[K+]' [] 'mM'};
nMax = 3;
expT = 0.1;

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
p.nChan_min = nChan_min;
p.nChan_max = nChan_max;
p.nL_max = nL_max;

% parameters for project management area
p.nChan = nChan_def;
p.nL = nL_def;
p.wl = [];
while isempty(p.wl) || numel(unique(p.wl))~=nL_max
    p.wl = round(1000*sort(rand(1,nL_max))); % laser wavelengths
end
p.mash_file = sprintf('%ichan%iexc.mash',nChan_def,nL_def);
p.ascii_dir = cell(nL_max,nChan_max);
p.ascii_files = cell(nL_max,nChan_max);
p.exp_ascii2mash = cell(nL_max,nChan_max);
p.asciiOptopt = cell(nChan_max,nL_max);
for nL = 1:nL_max
    defprm_nL = defprm;
    for l = 1:nL
        defprm_nL{size(defprm_nL,1)+l,1} = ...
            ['Power(',num2str(p.wl(l)),'nm)'];
        defprm_nL{size(defprm_nL,1),2} = '';
        defprm_nL{size(defprm_nL,1),3} = 'mW';
    end
    for nChan = nChan_min:nChan_max
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
        
        chanExc = zeros(1,nChan);
        FRET = [];
        chanExc(1:min([nChan,nL])) = p.wl(1:min([nChan,nL]));
        for don = 1:(nChan-1)
            if chanExc(don)>0
                for acc = (don+1):nChan
                    FRET = cat(1,FRET,[don,acc]);
                end
            end
        end
        nFRET = size(FRET,1);
        
        p.asciiOpt{nL,nChan}.intImp = {...
            [2 0 true 1 2 (2+nChan-1) nChan nL true 3+nChan+1 ...
            3+nChan+2*nFRET 1],p.wl(1:nL)};
        p.asciiOpt{nL,nChan}.vidImp = {false ''};
        p.asciiOpt{nL,nChan}.coordImp = {{false,'',{[1 2],1},256},[false 1]};
        p.asciiOpt{nL,nChan}.expCond = defprm_nL;
        p.asciiOpt{nL,nChan}.factImp = {false '' {} false '' {}};
    end
end

% default export options
p.tdp_expOpt = [false,4,false,3,false,false,false,false false,false,false,...
    false];

% default TDP settings
p.tdpDat = (p.nChan*p.nL)+1;
p.tdpPrm = [-0.2,0.025,1.2,1,0,0,1,1];
p.exp_tdp = 'tdp';

% default state configuration
Jmax = 4;
p.clstMeth = 2; % clustering method
p.clstMethPrm = [Jmax,5,false,3];
p.clstConfig = [1,1,1,1]; % constraint, diagonal clusters, likelihood, shape
p.clstStart = [linspace(0,1,Jmax)',repmat(0.25,[Jmax,1]),...
    linspace(0.2,0.8,Jmax)',repmat(0.4,[Jmax,1])];
p.exp_clst = 'clst_%i_%i';
p.exp_mouseSlct = 'clstStartMouse_%i_%i';
p.exp_defSlct = 'clstStartDef_%i_%i';

% default exponential fit settings
p.nMax = nMax;
p.stateBin = 0.03; % state binning
p.dtExcl = true; % exclude first and last dwell times in sequences
p.dtRearr = true; % re-arrange state sequences
p.expPrm = [1,0,1,0,0,100]; % auto, stretched, decay nb., boba, weight, sample nb.
amp = permute(...
    [zeros(nMax,1),flip(logspace(-2,0,nMax),2)',Inf(nMax,1)],...
    [3,2,1]);
dec = permute(...
    [zeros(nMax,1),flip(logspace(2,log10(expT),nMax),2)',Inf(nMax,1)],...
    [3,2,1]);
beta = permute([zeros(nMax,1),0.5*ones(nMax,1),2*ones(nMax,1)],[3,2,1]);
p.fitPrm = cat(1,amp,dec,beta);
p.fitPrm(2,2,2) = 5;
p.fitPrm(2,2,3) = 10;
p.exp_dt = 'dthist';
p.exp_logScale = 'dthist_log.png';
p.exp_linScale = 'dthist_lin.png';

% default kinetic model
p.mdlMeth = 1; % starting guess (1:from DPH fit + BIC, 2:from lifetime panel)
p.Dmax = 3; % max. degeneracy for DPH fit
p.mdlRestart = 5; % nb. of Baum-Welch restarts
p.exp_mdl = 'mdl';
p.exp_mdlBIC = 'mdl_BIC.png';
p.exp_mdlSimdt = 'mdl_dt_%i.png';
p.exp_mdlPop = 'mdl_pop.png';
p.exp_mdlTrans = 'mdl_trans.png';


