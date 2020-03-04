function p = getDef_kinsoft(pname,fnames)

% defaults
nChan_def = 2;
nL_def = 1;
defprm = {'Movie name' '' ''
       'Molecule name' '' ''
       '[Mg2+]' [] 'mM'
       '[K+]' [] 'mM'};
deflbl = {'don','acc1'};
nMax = 3; % maximum number of exponential to fit

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
p.ascii_dir = pname;
p.ascii_files = fnames;
for l = 1:p.nL
    defprm{size(defprm,1)+l,1} = ['Power(',num2str(p.wl(l)),'nm)'];
    defprm{size(defprm,1),2} = '';
    defprm{size(defprm,1),3} = 'mW';
end
p.asciiOpt.intImp = {[2 0 true 1 2 (2+p.nChan-1) p.nChan p.nL false 5],...
    p.wl(1:p.nL)};
p.asciiOpt.vidImp = {false ''};
p.asciiOpt.coordImp = {{false,'',{[1 2],1},256},[false 1]};
p.asciiOpt.expCond = defprm;
p.asciiOpt.factImp = {false '' {} false '' {}};

% project options
p.projOpt.proj_title = 'project'; % project title
p.projOpt.mol_name = ''; % molecule name
p.projOpt.conc_mg = []; % Mg concentration
p.projOpt.conc_k = []; % K concentration
p.projOpt.laser_pow = []; % laser powers
p.projOpt.prm_extra = [];
p.projOpt.labels = deflbl(1:p.nChan); % channel labels
chanExc = zeros(1,p.nChan);
chanExc(1:min([p.nChan,p.nL])) = p.wl(1:min([p.nChan,p.nL]));
p.projOpt.chanExc = chanExc; % channel-specific excitation
FRET = [];
for don = 1:(p.nChan-1)
    if chanExc(don)>0
        for acc = (don+1):p.nChan
            FRET = cat(1,FRET,[don,acc]);
        end
    end
end
p.projOpt.FRET = FRET; % FRET pairs
if ~isempty(FRET)
    p.projOpt.S = FRET(chanExc(FRET(:,1))>0 & chanExc(FRET(:,2))>0,:); % stoichiometries
else
    p.projOpt.S = [];
end

% axis units
p.perSec = true;
p.perPix = true;
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
p.factPrm{1} = repmat([0,2,1,10],p.nL,1);
p.factPrm{2} = [-0.2,50,1.2
    1,50,5];

% default find states parameters
nDat = p.nChan*p.nL+size(p.projOpt.FRET,1)+size(p.projOpt.S,1);
p.fsMeth = 5; % threshold, vbFRET, one state, CPA, STaSI
p.fsDat = 1; % bottom, top , all
p.fsPrm = [2  0  0 1 0 0 0 0
    1  2  1 1 0 0 0 0
    0  0  0 0 0 0 0 0
    50 90 2 1 0 0 0 0
    2  0  0 1 0 0 0 0]; % method settings
p.fsPrm = repmat(p.fsPrm,[1,1,nDat]);
p.fsThresh = [-Inf,0,0.6
    0.7,1,Inf];
p.fsThresh = repmat(p.fsThresh,[1,1,nDat]);

% default TDP settings
p.tdpPrm = [0.05,0.025,1.05,1,0,0,1,1];

% default state configuration
Jmax = 10;
p.clstMeth = 2; % clustering method
p.clstMethPrm = [Jmax,50,false,100];
p.clstConfig = [1,1,1,1]; % constraint, diagonal clusters, likelihood, shape
p.clstStart = [linspace(0,1,Jmax)',repmat(0.1,[Jmax,1])];

% default export options
p.tdp_expOpt = [false,4,false,3,false,false,false,false];

% default exponential fit settings
p.expPrm = [0,1,0,0,100]; % stretched, decay nb., boba, weight, sample nb.
p.fitPrm = [0,0.8,Inf
    0 0.5 Inf
    0 0.5 2]; % low, start, up
p.fitPrm = repmat(p.fitPrm,[1,1,nMax]);
p.fitPrm(2,2,2) = 5;
p.fitPrm(2,2,3) = 10;

