function ok = setParam(h_fig)
% Initialize MASH parameters from the file default_param.ini
% "h_fig" >> MASH figure handle

% Requires external function: adjustParam

%% Last update by MH, 25.4.2019
% >> set default tag names and colors in Video processing interface's 
%    defaults
%
% update: 28th of March 2019 by Melodie Hadzic
% --> add gamma file import in Trace processing
%
% update: 20th of February by Mélodie Hadzic
% --> add ebFRET-compatible export in Video processing
%
% update: 7th of March 2018 by Richard Börner
% --> Comments adapted for Boerner et al 2017
% --> Simulation default parameters adapted for Boerner et al 2017.
%
% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic
%%

h = guidata(h_fig);
h.param = [];
ok = 1;

[mfile_path,o,o] = fileparts(mfilename('fullpath'));

if exist([mfile_path filesep '..' filesep '..' filesep ...
        'default_param.ini'], 'file')
    try
        h.param = load([mfile_path filesep '..' filesep '..' filesep ...
            'default_param.ini'], '-mat');
    catch err
        h_err = errordlg({err.message '' ...
            'The file will be deleted.' ''...
            'Please run MASH-FRET again to debug.'}, ...
            'Initialisation error', 'modal');
        uiwait(h_err);
        delete([mfile_path filesep '..' filesep '..' filesep ...
            'default_param.ini']);
        ok = 0;
        return;
    end
end

% Simulation pannel
if ~isfield(h.param, 'sim')
    h.param.sim = [];
end
h.param.sim = setParamSim(h.param.sim);

% Movie processing pannel
if ~isfield(h.param, 'movPr')
    h.param.movPr = [];
end
h.param.movPr = setParamMov(h.param.movPr);

% Trace processing pannel
if ~isfield(h.param, 'ttPr')
    h.param.ttPr = [];
end
h.param.ttPr = setParamTT(h.param.ttPr);

% Thermodynamics pannel
if ~isfield(h.param, 'thm')
    h.param.thm = [];
end
h.param.thm = setParamThm(h.param.thm);

% TDP analysis pannel
if ~isfield(h.param, 'TDP')
    h.param.TDP = [];
end
h.param.TDP = setParamTDP(h.param.TDP);

guidata(h_fig, h);

% Gather results pannel
if ~isfield(h.param, 'gath')
    h.param.gath = [];
end
h.param.gath = setParamGath(h.param.gath);

% reinitialize output files management
h.param.OpFiles.overwrite_ask = 1;
h.param.OpFiles.overwrite = 0;


% Simulation pannel (default parameters for SMV simulations)
function p = setParamSim(p_input)
p = p_input;

nChan = 2;

% general parameters
p.nbStates = adjustParam('nbStates', 2, p_input); % nb of FRET states
p.molNb = adjustParam('molNb', 100, p_input); % nb of simulated molecules 
p.nbFrames = adjustParam('nbFrames', 4000, p_input); % nb of video frames
p.rate = adjustParam('rate', 10, p_input); % frame rate (s-1)
p.bleach = adjustParam('bleach', 0, p_input); % fluorophore bleaching (0/1)
p.bleach_t = adjustParam('bleach_t', p.nbFrames/p.rate, p_input); % bleaching decay time (s-1)
p.bitnr = adjustParam('bitnr', 14, p_input); % bit rate

% molecule parameters
kx = [  0   0.1   0.1   0.1   0.1 % transition state rates (s-1), for up to 5 states
      0.1     0   0.1   0.1   0.1
      0.1   0.1     0   0.1   0.1
      0.1   0.1   0.1     0   0.1
      0.1   0.1   0.1   0.1     0];
p.kx = adjustParam('kx', kx, p_input);
val = round(10*linspace(0,1,p.nbStates))/10;
p.stateVal = adjustParam('stateVal', val, p_input);
p.FRETw = adjustParam('FRETw', zeros(1,p.nbStates), p_input); % FRET width for heterogenous broadening
p.gamma = adjustParam('gamma', 1, p_input); % gamma factor (correction for different quantum yields and detection efficiencies of the fluorophors)
p.gammaW = adjustParam('gammaW', 0, p_input); % gamma width for molecule variations
p.totInt = adjustParam('totInt', 36, p_input); % total emitted intennsity 
p.totInt_width = adjustParam('totInt_width', 0, p_input); % total emitted Intensity width for heterogenous broadening
p.coord = adjustParam('coord', [], p_input); % only allocation of sm coordinates
p.molPrm = adjustParam('molPrm', [], p_input); % only allocation of sm parameters

% setup parameters
p.bgInt_don = adjustParam('bgInt_don', 0, p_input);
p.bgInt_acc = adjustParam('bgInt_acc', 0, p_input);
p.noiseType = adjustParam('noiseType', 'none', p_input);
if strcmp(p.noiseType,'poiss')
    p.noiseType = 'none';
end
p.movDim = adjustParam('movDim', [256 256], p_input);
p.bgType = adjustParam('bgType', 1, p_input); % 1: constant, 2: TIRF profile, 3: patterned 
p.TIRFdim = adjustParam('TIRFdim', [floor(p.movDim(1)/(2*nChan)) ...
    p.movDim(2)/2], p_input);
p.pixDim = adjustParam('pixDim', 0.53, p_input);
p.bgDec = adjustParam('bgDec', 0, p_input);
p.cstDec = adjustParam('cstDec', p.nbFrames*p.rate/10, p_input);
p.ampDec = adjustParam('ampDec', 1, p_input);
p.PSF = adjustParam('PSF', 1, p_input);
p.PSFw = adjustParam('PSFw', [0.35260 0.38306], p_input);
if size(p.PSFw,2)~=2
    p.PSFw = repmat(p.PSFw(1,:),[1,2]);
end

% defocsing/focal drift/chromatic aberation
p.zDec = adjustParam('zDec', 0, p_input); % defocusing
p.z0Dec = adjustParam('z0Dec', 0, p_input); % lateral chromatic aberration

% camera noise default values
camNoise = [113   0     0.95 0    1    0       % mu.d /     eta /     1 /       % default P- or Poisson Model
            113   0.067 0.95 0    57.8 0       % mu.d s_d   eta s_q   K mr.s    % default N- or Gaussian Model
            106.9 0.02  0.95 2    57.7 20.5    % mu.d A_CIC eta sig_d K tau_CIC % default NexpN or Exp.-CIC Model
            113   0     1    0    1    0       % mu.d /     1   /     1 /       % default no noise but camera offset
            113   0.067 0.95 0.02 300  5.199]; % mu.d s_d   eta CIC   g s       % default PGN- or Hirsch Model 
        
p.camNoise = adjustParam('camNoise', camNoise, p_input);

% instrumental imperfections
p.btD = adjustParam('btD', 0.07, p_input);  % default bleedthrough D excitation D emmission in A channel
p.btA = adjustParam('btA', 0, p_input);     % default bleedthrough A excitation A emmission in D channel
p.deD = adjustParam('deD', 0, p_input);     % default direct excitation of D after A excitation
p.deA = adjustParam('deA', 0.02, p_input);  % default direct excitation of A after D excitation


% other parameters
p.intUnits = adjustParam('intUnits', 'electron', p_input);
p.intOpUnits = adjustParam('intOpUnits', 'electron', p_input);
p.export_traces = adjustParam('export_traces', 1, p_input);
p.export_movie = adjustParam('export_movie', 1, p_input);
p.export_avi = adjustParam('export_avi', 0, p_input);
p.export_procTraces = adjustParam('export_procTraces', 1, p_input);
p.export_dt = adjustParam('export_dt', 1, p_input);
p.export_coord = adjustParam('export_coord', 1, p_input);
p.export_param = adjustParam('export_param', 1, p_input);
p.genCoord = adjustParam('genCoord', 1, p_input);
p.coordFile = adjustParam('coordFile', [], p_input);
p.impPrm = adjustParam('impPrm', 0, p_input);
p.prmFile = adjustParam('prmFile', [], p_input);
p.molPrm = adjustParam('molPrm', [], p_input);
p.matGauss = cell(1,4);

% Movie processing pannel

function p = setParamMov(p_input)
p = p_input;

pth = userpath;
if ~isempty(pth) && strcmp(pth(end),'\')
    pth = pth(1:end-1);
else
    pth = pwd;
end
p.folderRoot = adjustParam('folderRoot', pth, p_input);
if ~exist(p.folderRoot, 'dir')
    p.folderRoot = pth;
end
p.perSec = adjustParam('perSec', 1, p_input);
p.nChan = adjustParam('nChan', 2, p_input);
p.cmap = adjustParam('cmap', 1, p_input);
p.rate = adjustParam('rate', 1, p_input);

u = {[0 0]
     [3 0]
     [3 0]
     [3 0]
     [3 1]
     [3 200]
     [200 0]
     [3 0.99]
     [0.5 0]
     [1500 0]
     [0 2]
     [0 50]
     [0 0.5]
     [0 0]
     [0 0]
     [3 1]
     [0 0]
     [1 0]
     [0 0]};

q = {};
for i = 1:p.nChan
    q = [q u];
end
 
p.movBg_p = adjustParam('movBg_p', q, p_input);
for i = 1:p.nChan
    if size(p.movBg_p,1)<19
        p.movBg_p = [p.movBg_p;q(size(p.movBg_p,1)+1:19,:)];
    end
    % correct param "probability threshold" for histothresh method
    if p.movBg_p{13,i}(2)>1
        p.movBg_p{13,i}(1) = 0;
        p.movBg_p{13,i}(2) = 0.5;
    end
end
p.movBg_method = adjustParam('movBg_method', 1, p_input);
p.movBg_myfilter = {'', 'gauss', 'mean', 'median', 'ggf', 'lwf', ...
                          'gwf', 'outlier', 'histotresh', 'simpletresh'};
p.movBg_one = adjustParam('movBg_one', 0, p_input);
p.mov_start = 1;
p.mov_end = 1;
p.bgCorr = {};

p.ave_start = 1;
p.ave_stop = 1;
p.ave_iv = 1;

p.SF_method = adjustParam('SF_method', 1, p_input);
p.SF_gaussFit = adjustParam('SF_gaussFit', 0, p_input);
p.SF_intThresh = adjustParam('SF_intThresh', zeros(1,p.nChan), p_input);
p.SF_minI = adjustParam('SF_minI', p.SF_intThresh, p_input);
p.SF_w = adjustParam('SF_w', 7*ones(1,p.nChan), p_input);
p.SF_h = adjustParam('SF_h', 7*ones(1,p.nChan), p_input);
p.SF_darkW = adjustParam('SF_darkW', 9*ones(1,p.nChan), p_input);
p.SF_darkH = adjustParam('SF_darkH', 9*ones(1,p.nChan), p_input);
p.SF_all = adjustParam('SF_all', 0, p_input);
p.SF_maxN = adjustParam('SF_maxN', 200*ones(1,p.nChan), p_input);
p.SF_minHWHM = adjustParam('SF_minHWHM', zeros(1,p.nChan), p_input);
p.SF_maxHWHM = adjustParam('SF_maxHWHM', 5*ones(1,p.nChan), p_input);
p.SF_maxAssy = adjustParam('SF_maxAssy', 150*ones(1,p.nChan), p_input);
p.SF_minDspot = adjustParam('SF_minDspot', 0*ones(1,p.nChan), p_input);
p.SF_minDedge = adjustParam('SF_minDedge', 3*ones(1,p.nChan), p_input);
p.SF_intRatio = adjustParam('SF_intRatio', 1.4*ones(1,p.nChan), p_input);
p.SFres = {};
p.coordMol = [];
p.coordMol_file = [];

p.trsf_coordRef = [];
p.trsf_coordRef_file = [];
p.trsf_tr = [];
p.trsf_tr_file = [];
p.trsf_refImp_mode = adjustParam('trsf_refImp_mode', 'rw', p_input);
p.trsf_refImp_rw = adjustParam('trsf_refImp_rw', {[((1:p.nChan)' + 1) ...
    p.nChan*ones(p.nChan,1) zeros(p.nChan,1)] [1 2]}, p_input);
p.trsf_refImp_cw = adjustParam('trsf_refImp_cw', {...
    reshape((1:2*p.nChan), [p.nChan 2]) 1}, p_input);
p.trsf_type = adjustParam('tr_type', 1, p_input);
p.trsf_coordImp = adjustParam('trsf_coordImp', [1 2], p_input);
p.trsf_coordLim = adjustParam('trsf_coordLim', [256 256], p_input);
p.coordTrsf = [];
p.coordTrsf_file = [];

p.coordItg = [];
p.coordItg_file = [];
p.itg_movFullPth = [];
p.itg_coordFullPth = [];
p.itg_dim = adjustParam('itg_dim', 3, p_input);
p.itg_n = adjustParam('itg_n', p.itg_dim^2, p_input);
if p.itg_n>p.itg_dim^2
    p.itg_n = p.itg_dim^2;
end
p.itg_ave = adjustParam('itg_ave', 1, p_input);
p.itg_nLasers = adjustParam('itg_nLasers', 1, p_input);
p.itg_wl = adjustParam('itg_wl', ...
    round(532*(1 + 0.2*(0:p.itg_nLasers-1))), p_input);
p.itg_impMolPrm = adjustParam('itg_impMolPrm', {[1 2] 1}, p_input);
p_exp = {'Project title' '' ''
         'Molecule' '' ''
         '[Mg2+]' [] 'mM'
         '[K+]' [] 'mM'};
for i = 1:p.itg_nLasers
    p_exp{size(p_exp,1)+1,1} = ['Power(' ...
        num2str(round(p.itg_wl(i))) 'nm)'];
    p_exp{size(p_exp,1),2} = '';
    p_exp{size(p_exp,1),3} = 'mW';
end
p.itg_expMolPrm = adjustParam('itg_expMolPrm', p_exp, p_input);
p.itg_expFRET = adjustParam('itg_expFRET', [], p_input);
p.itg_expS = adjustParam('itg_expS', [], p_input);
if size(p.itg_expS,2)>1
    p.itg_expS = [];
end

itg_clr = getDefTrClr(p.itg_nLasers, p.itg_wl, p.nChan, ...
    size(p.itg_expFRET,1), size(p.itg_expS,1));
p.itg_clr = adjustParam('itg_clr', itg_clr, p_input);

p.itg_expMolFile = adjustParam('itg_expMolFile', [1 1 0 0 0 0 0 0], ...
    p_input);
% no ebFRET option
if numel(p.itg_expMolFile)<8
    p.itg_expMolFile = cat(2,p.itg_expMolFile,0);
end

chanExc = zeros(1,p.nChan);
for c = 1:p.nChan
    labels{c} = sprintf('Cy%i', (2*c+1));
    if c <= p.itg_nLasers
        chanExc(c) = p.itg_wl(c);
    end
end
p.chanExc = adjustParam('chanExc', chanExc, p_input);
p.labels_def = adjustParam('labels_def', labels, p_input);
p.labels = adjustParam('labels', labels, p_input);
p.defTagNames = adjustParam('defTagNames', {'static', 'dynamic'}, p_input);
p.defTagClr = adjustParam('defTagClr', {'#4298B5','#DD5F32','#92B06A',...
    '#ADC4CC','#E19D29'}, p_input);

% Trace processing pannel

function p = setParamTT(p_input)
p = p_input;
% general panel parameters
nExc = 1;
nChan = 2;
wl = round(532*(1 + 0.2*(0:nExc-1)));
defprm = {'Movie name' '' ''
       'Molecule name' '' ''
       '[Mg2+]' [] 'mM'
       '[K+]' [] 'mM'};
for i = 1:nExc
    defprm{size(defprm,1)+i,1} = ['Power(' ...
        num2str(round(wl(i))) 'nm)'];
    defprm{size(defprm,1),2} = '';
    defprm{size(defprm,1),3} = 'mW';
end

p_imp = {{[1 0 0 1 1 0 nChan nExc 0 5] wl} ...
    {0 ''} ...
    {0 '' {[1 2] 1} 256} ...
    [0 1] ...
    defprm ...
    {0 '' {}}}; % add gamma import
p.impPrm = adjustParam('impPrm', p_imp, p_input);
p.impFRET = adjustParam('impFRET', [], p_input);
p.impS = adjustParam('impS', [], p_input);
p.proj = {};
p.curr_proj = 0;
p.curr_mol = [];
p.defTagNames = {'static', 'dynamic'};
p.defTagClr = {'#4298B5','#DD5F32','#92B06A','#ADC4CC','#E19D29'};

% Themodynamics processing pannel
function p = setParamThm(p_input)
p = p_input;
p.proj = {};
p.curr_proj = 0;
p.curr_tpe = [];
         % R G B
colList = [1 0 0 % red
           0 1 0 % green
           0 0 1 % blue
           1 1 0 % yellow
           0 1 1 % cyan
           1 0 1 % magenta
           0 0.5 0 % olive
           1 0.5 0 % orange
           0.5 0 0 % wine
           0 0 0.5 % marine
           0.5 0.5 0 % kaki
           0 0.5 0.5 % turquoise
           0.5 0 0.5 % purple
           0.5 0.25 0 % brown
           1 0.5 1 % pink
           0.5 0 1 % violet
           0.5 0.5 0.5 % grey
           1 1 0.5 % canary
           0.5 1 1]; % pastel blue
p.colList = adjustParam('colList', colList, p_input);

% Kinetics processing pannel

function p = setParamTDP(p_input)
p = p_input;
p.proj = {};
p.curr_proj = 0;
p.curr_type = [];
         % R G B
colList = [1 0 0 % red
           0 1 0 % green
           0 0 1 % blue
           1 1 0 % yellow
           0 1 1 % cyan
           1 0 1 % magenta
           0 0.5 0 % olive
           1 0.5 0 % orange
           0.5 0 0 % wine
           0 0 0.5 % marine
           0.5 0.5 0 % kaki
           0 0.5 0.5 % turquoise
           0.5 0 0.5 % purple
           0.5 0.25 0 % brown
           1 0.5 1 % pink
           0.5 0 1 % violet
           0.5 0.5 0.5 % grey
           1 1 0.5 % canary
           0.5 1 1]; % pastel blue
p.colList = adjustParam('colList', colList, p_input);

cmap = colormap('jet');
p.cmap = adjustParam('cmap', cmap, p_input);


function p = setParamGath(p_input)
% empty
p = p_input;




