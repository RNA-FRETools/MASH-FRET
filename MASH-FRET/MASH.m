function varargout = MASH(varargin)
% Last Modified by GUIDE v2.5 04-Feb-2019 17:22:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MASH_OpeningFcn, ...
                   'gui_OutputFcn',  @MASH_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end % End initialization code - DO NOT EDIT


function MASH_OpeningFcn(obj, evd, h, varargin)

% define figure name from folder name
[pname,o,o] = fileparts(which('MASH'));
issep = true;
while issep
    possep = strfind(pname,filesep);
    if isempty(possep)
        break;
    else
        pname = pname(possep+1:end);
    end
end
%figName = strrep(pname,'_',' '); % Versioning with folder structure 2018-03-07

%----------------
% version number
version_number = '1.1.2'; % Versioning without folder structure %2018-03-07
%----------------

figName = sprintf('%s %s','MASH-FRET', version_number);

% check for proper Matlab version
mtlbDat = ver;
for i = 1:size(mtlbDat,2)
    if strcmp(mtlbDat(1,i).Name, 'MATLAB')
        break;
    end
end
if str2num(mtlbDat(1,i).Version) < 7.12
    updateActPan(['WARNING: The Matlab version installed on this ' ...
        'computer (' mtlbDat(1,i).Version ') is older than the one ' ...
        'used to write ' figName ', i.e. 7.12.\nBe aware that '...
        'compatibility problems can occur.'], obj, 'error');
end

% Add source folders to Matlab search path
codePath = fileparts(mfilename('fullpath'));
addpath(genpath(codePath));

% initialise MASH
initMASH(obj, h, figName);


function varargout = MASH_OutputFcn(obj, evd, h) 
varargout{1} = [];


function figure_MASH_CloseRequestFcn(obj, evd, h)
if isfield(h, 'figure_actPan') && ishandle(h.figure_actPan)
    h_pan = guidata(h.figure_actPan);
    saveActPan(get(h_pan.text_actions, 'String'), h.figure_MASH);
    delete(h.figure_actPan);
end
if isfield(h, 'wait') && isfield(h.wait, 'figWait') && ...
        ishandle(h.wait.figWait)
    delete(h.wait.figWait);
end
if isfield(h, 'figure_trsfOpt') && ishandle(h.figure_trsfOpt)
    delete(h.figure_trsfOpt);
end
if isfield(h, 'figure_itgOpt') && ishandle(h.figure_itgOpt)
    delete(h.figure_itgOpt);
end
if isfield(h, 'figure_itgExpOpt') && ishandle(h.figure_itgExpOpt)
    delete(h.figure_itgExpOpt);
end
if isfield(h, 'figure_optBg') && ishandle(h.figure_optBg)
    delete(h.figure_optBg)
end

param = h.param;
if ~isempty(param.ttPr.proj)
    % remove background intensities
    for c = 1:size(param.ttPr.defProjPrm.mol{3}{3},2)
        for l = 1:size(param.ttPr.defProjPrm.mol{3}{3},1)
            param.ttPr.defProjPrm.mol{3}{3}{l,c}(3) = 0;
        end
    end
    
    % remove discretisation results
    param.ttPr.defProjPrm.mol{3}{4} = [];
end
[mfile_path,o,o] = fileparts(mfilename('fullpath'));
save([mfile_path filesep 'default_param.ini'], '-struct', 'param');

delete(obj);



%% MASH options %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton_rootFolder_Callback(obj, evd, h)
folderRoot = uigetdir(h.folderRoot, 'Choose a root folder:');
if ~isempty(folderRoot) && sum(folderRoot)
    h.folderRoot = folderRoot;
    h.param.movPr.folderRoot = folderRoot;
    cd(h.folderRoot);
    guidata(h.figure_MASH, h);
    set(h.edit_rootFolder, 'String', folderRoot);
    updateActPan(['Root folder set to:\n' folderRoot], h.figure_MASH);
end


function pushbutton_moreTools_Callback(obj, evd, h)
msgbox('Soon available');


function menu_showActPan_Callback(obj, evd, h)
checked = strcmp(get(obj, 'Checked'), 'on');
if ~checked
    if isfield(h, 'figure_actPan') && ishandle(h.figure_actPan)
        set(h.figure_actPan, 'Visible', 'on');
    else
        h.figure_actPan = actionPanel(h_fig);
        guidata(h_fig, h);
    end
    set(obj, 'Checked', 'on');
else
    if isfield(h, 'figure_actPan') && ishandle(h.figure_actPan)
        set(h.figure_actPan, 'Visible', 'off');
    end
    set(obj, 'Checked', 'off');
end


%% Simulations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Last update: 7th of March 2018 by Richard Börner
%
% Comments adapted for Boerner et al 2017
% Noise models adapted for Boerner et al 2017.
% Simulation default parameters adapted for Boerner et al 2017.

% Kinetic model

function edit_nbStates_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 && val ...
        <= 5)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Number of states must be an integer >= 1 and <= 5', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.nbStates = val;
    for i = 1:h.param.sim.nbStates
        if i > size(h.param.sim.stateVal,2)
            h.param.sim.stateVal(i) = h.param.sim.stateVal(i-1);
            h.param.sim.FRETw(i) = h.param.sim.FRETw(i-1);
        end
    end
    h.param.sim.stateVal = h.param.sim.stateVal(1:h.param.sim.nbStates);
    h.param.sim.FRETw = h.param.sim.FRETw(1:h.param.sim.nbStates);
    h.results.sim.mix = [];
    guidata(h.figure_MASH, h);
    
    set(h.popupmenu_states, 'Value', 1);
    set(h.edit_stateVal, 'String', num2str(h.param.sim.stateVal(1)));
    updateFields(h.figure_MASH, 'sim');
end


function edit_kinCst_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Transition rates must be >= 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.kx = getTransMat(h.figure_MASH);
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_length_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Trace length must be an integer > 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.nbFrames = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_simRate_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Frame rate must be > 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.rate = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function checkbox_simBleach_Callback(obj, evd, h)
h.param.sim.bleach = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function edit_simBleach_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Mean photobleaching time must be > 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.bleach_t = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function pushbutton_startSim_Callback(obj, evd, h)
% Make sure all Parameters are updated.
updateFields(h.figure_MASH, 'sim');

% Simulate trajectories and initialize movie simulation
buildModel(h.figure_MASH);

% Make sure all Parameters are updated.
updateFields(h.figure_MASH, 'sim');



% Molecule parameters

function popupmenu_states_Callback(obj, evd, h)
updateFields(h.figure_MASH, 'sim');


function edit_stateVal_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0 && ...
        val <= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('FRET values must be >= 0 and <= 1', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    state = get(h.popupmenu_states, 'Value');
    h.param.sim.stateVal(state) = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_simFRETw_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('FRET values must be >= 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    state = get(h.popupmenu_states, 'Value');
    h.param.sim.FRETw(state) = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_gamma_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Gamma factor must be > 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.gamma = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_gammaW_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val)  && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Gamma factor width must be a number and must be >= 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.gammaW = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_totInt_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Intensities must be >= 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    if strcmp(h.param.sim.intUnits, 'electron')
        val = arb2phtn(val);
    end
    h.param.sim.totInt = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_dstrbNoise_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Intensities must be >= 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    if strcmp(h.param.sim.intUnits, 'electron')
        val = arb2phtn(val);
    end
    h.param.sim.totInt_width = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_bgInt_don_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Intensities must be >= 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    if strcmp(h.param.sim.intUnits, 'electron')
        val = arb2phtn(val);
    end
    h.param.sim.bgInt_don = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_bgInt_acc_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Intensities must be >= 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    if strcmp(h.param.sim.intUnits, 'electron')
        val = arb2phtn(val);
    end
    h.param.sim.bgInt_acc = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function checkbox_photon_Callback(obj, evd, h)
switch(get(obj, 'Value'))
    case 1
        h.param.sim.intUnits = 'photon';
    case 0
        h.param.sim.intUnits = 'electron';
end
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function pushbutton_simImpCoord_Callback(obj, evd, h)
if ~iscell(obj)
    [fname, pname, o] = uigetfile({'*.txt', 'ASCII file(*.txt)'; ...
        '*.*', 'All files(*.*)'}, 'Select a coordinates file');
else
    pname = obj{1};
    fname = obj{2};
end
if ~isempty(fname) && sum(fname)
    cd(pname);
    p = h.param.sim;
    p = impSimCoord(fname, pname, p, h.figure_MASH);
    p.matGauss = cell(1,4);
    h.param.sim = p;
    guidata(h.figure_MASH, h);
    
    setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);
    
    updateFields(h.figure_MASH, 'sim');
end


function pushbutton_simRemCoord_Callback(obj, evd, h)
h.param.sim.coord = [];
h.param.sim.coordFile = [];
h.param.sim.genCoord = 1;
h.param.sim.matGauss = cell(1,4);
guidata(h.figure_MASH, h);

setSimCoordTable(h.param.sim.coord, h.uitable_simCoord);

updateFields(h.figure_MASH, 'sim');


% Setup parameters


function edit_simBitPix_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Number of Bit per pixel should be an integer > 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.bitnr = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end

function edit_simMov_w_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Movie dimensions must be integers > 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.movDim(1) = val;
    h.param.sim.matGauss = cell(1,4);
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_simMov_h_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Movie dimensions must be integers > 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.movDim(2) = val;
    h.param.sim.matGauss = cell(1,4);
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_pixDim_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Pixel dimension must be > 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.pixDim = val;
    h.param.sim.matGauss = cell(1,4);
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function popupmenu_simBg_type_Callback(obj, evd, h)
h.param.sim.bgType = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function edit_TIRFx_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('TIRF profile widths must be > 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.TIRFdim(1) = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_TIRFy_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('TIRF profile widths must be > 0', 'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.TIRFdim(2) = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function checkbox_bgExp_Callback(obj, evd, h)
h.param.sim.bgDec = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function edit_bgExp_cst_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Time constant decay must be a number > 0', 'error', ...
        h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.cstDec = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_simAmpBG_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Relative initial BG amplitude must be a number >= 1', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.ampDec = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end

function edit_simzdec_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Defocus of acceptor channel should be >= 0', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.zDec = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_simz0_A_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Defocus time decay should be >= 0', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.z0Dec = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end

% Choose from five different noise modells for the camera SNR
% characteristics
function popupmenu_noiseType_Callback(obj, evd, h)
switch get(obj, 'Value')
    case 1 % Poisson or P-model from Börner et al. 2017
        noiseType = 'poiss';
    case 2 % Gaussian, Normal or N-model from Börner et al. 2017
        noiseType = 'norm';
    case 3 % User defined or NExpN-model from Börner et al. 2017
        noiseType = 'user';
    case 4 % None, no camera noise but possible camera offset value
        noiseType = 'none';
    case 5 % Hirsch or PGN- Model from Hirsch et al. 2011
        noiseType = 'hirsch';
end

h.param.sim.noiseType = noiseType;
guidata(h.figure_MASH, h);

updateFields(h.figure_MASH, 'sim');


function edit_camNoise_01_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

switch ind
    case 1 % Poisson, dark current or camera offset value
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Dark counts or offset of the CCD camera must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,1) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
        
    case 2 % Gaussian, K
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('System gain must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,1) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
        
    case 3 % User defined, with dark current or camera offset value
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Dark count of the CCD camera must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,1) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
        
    case 4 % None, dark current or camera offset value
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Dark counts of the CCD camera must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,1) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end   
            
    case 5 % Hirsch or PGN-model, g
      	if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('EM register gain must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,1) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end   
end


function edit_camNoise_02_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

switch ind
    case 1 % Poissonian, total detection efficiency
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= 1)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['Total Detection Efficiency must be comprised ' ...
                'between 0 and 1'], 'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,2) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
    case 2 % Gaussian, s_d
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['The noise standard deviation of the Gaussian' ...
                ' contribution must be >= 0'], ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,2) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end

    case 3 % User defined, A_CIC
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Gaussian/Exponential relative amplitude of CIC must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,2) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
        
    case 4 % None, none
        
    case 5 % Hirsch or PGN-model, s_d, read-out-noise
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('The read-out-noise must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,2) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end  
end


function edit_camNoise_03_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

switch ind
    case 1 % Poissonian, none
        
    case 2 % Gaussian, mu_y.dark
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Dark count or offset of the CCD camera must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,3) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end

    case 3 % User defined, tau_CIC
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('CIC Exponential decay constant must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,3) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
        
    case 4 % None, none
        
    case 5 % Hirsch or PGN-model
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Dark count or offset of the CCD camera must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,3) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
end


function edit_camNoise_04_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

switch ind
    case 1 % Poissonian, none
        
    case 2 % Gaussian, s_q
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['Noise standard deviaton of the contribution ' ...
                'due to analog digital conversion must be >= 0'], ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,4)= val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
        
    case 3  % User defined, sig
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Camera noise width must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,4) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
        
    case 4 % None, none
        
    case 5 % Hirsch or PGN-model
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('CIC contribution must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,4) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
end


function edit_camNoise_05_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

switch ind
    case 1 % Poissonian, none
        
    case 2 % Gaussian, mu_rho.stat (none)
        
    case 3 % User defined, K
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Overall system gain must be >= 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,5) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end    
    case 4 % None, none
        
    case 5 % Hirsch or PGN-model
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan('Analog-to-Digital factor must be > 0', ...
                'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,5)= val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
end


function edit_camNoise_06_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

ind = get(h.popupmenu_noiseType, 'Value');

switch ind
    case 1 % Poissonian, none
        
    case 2 % Gaussian, eta
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= 1)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['Total Detection Efficiency must be comprised ' ...
                'between 0 and 1'], 'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,6) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
        
    case 3  % User defined, eta
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= 1)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['Total Detection Efficiency must be comprised ' ...
                'between 0 and 1'], 'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,6) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end

    case 4 % None, none
        
    case 5 % Hirsch or PGN-model, eta
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= 1)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            setContPan(['Total Detection Efficiency must be comprised ' ...
                'between 0 and 1'], 'error', h.figure_MASH);
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            h.param.sim.camNoise(ind,6) = val;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'sim');
        end
end


function edit_simBtD_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0  && ...
        val <= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Bleedthrough coefficient must be >= 0 and <= 1', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.btD = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_simBtA_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0  && ...
        val <= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Bleedthrough coefficient must be >= 0 and <= 1', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.btA = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_simDeD_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0  && ...
        val <= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Direct excitation coefficient must be >= 0 and <= 1', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.deD = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


function edit_simDeA_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0  && ...
        val <= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Direct excitation coefficient must be >= 0 and <= 1', ...
        'error', h.figure_MASH);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.sim.deA = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'sim');
end


% Export parameters

function checkbox_avi_Callback(obj, evd, h)
h.param.sim.export_avi = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function checkbox_traces_Callback(obj, evd, h)
h.param.sim.export_traces = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function checkbox_movie_Callback(obj, evd, h)
h.param.sim.export_movie = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function popupmenu_opUnits_Callback(obj, evd, h)
switch get(obj, 'Value')
    case 1
        h.param.sim.intOpUnits = 'photon';
    case 2
        h.param.sim.intOpUnits = 'electron';
end
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function checkbox_procTraces_Callback(obj, evd, h)
h.param.sim.export_procTraces = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function checkbox_dt_Callback(obj, evd, h)
h.param.sim.export_dt = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function checkbox_simParam_Callback(obj, evd, h)
h.param.sim.export_param = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function checkbox_expCoord_Callback(obj, evd, h)
h.param.sim.export_coord = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'sim');


function pushbutton_exportSim_Callback(obj, evd, h)
% Set fields to proper values
updateFields(h.figure_MASH, 'sim');
exportResults(h.figure_MASH);
updateFields(h.figure_MASH, 'sim');




%% Video processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Video control


function pushbutton_loadMov_Callback(obj, evd, h)
if isfield(h, 'movie') && isfield(h.movie, 'path') && ...
        exist(h.movie.path, 'dir')
    cd(h.movie.path);
end
if loadMovFile(1, 'Select a graphic file:', 1, h.figure_MASH);
    h = guidata(h.figure_MASH);
    h.param.movPr.itg_movFullPth = [h.movie.path h.movie.file];
    h.param.movPr.rate = h.movie.cyctime;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'imgAxes');
end


function edit_rate_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', val);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Frame rate must be > 0.', ...
        h.figure_MASH, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.movie.cyctime = val;
    h.param.movPr.rate = val;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'imgAxes');
end


function edit_nChannel_Callback(obj, evd, h)
nChan = round(str2num(get(obj, 'String')));
if ~(~isempty(nChan) && numel(nChan) == 1 && ~isnan(nChan) && ...
        nChan > 0)
    updateActPan('Number of channel must be > 0.', ...
        h.figure_MASH, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    p = h.param.movPr;
    p.nChan = nChan;
    
    if isfield(h, 'movie')
        sub_w = round(h.movie.pixelX/nChan);
        h.movie.split = (1:nChan-1)*sub_w;
        txt_split = [];
        for i = 1:size(h.movie.split,2)
            txt_split = [txt_split ' ' num2str(h.movie.split(i))];
        end
        set(h.text_split, 'String', ['Channel splitting: ' txt_split]);
    end
    
    clr_ref = getDefTrClr(p.itg_nLasers, p.itg_wl, nChan, size(p.itg_expFRET,1), ...
        size(p.itg_expS,1));
    
    for c = 1:nChan
        if c > size(p.itg_clr{1},2)
            p.itg_clr{1}(:,(size(p.itg_clr{1},2)+1):size(clr_ref{1},2)) ...
                = clr_ref{1}(:,(size(p.itg_clr{1},2)+1):end);
        end
        if c > size(p.labels_def,2)
            p.labels_def{c} = sprintf('Cy%i', (2*c+1));
        end
        if c > size(p.chanExc,2)
            if c <= p.itg_nLasers
                p.chanExc(c) = p.itg_wl(c);
            else
                p.chanExc(c) = 0;
            end
        end
    end
    p.labels = p.labels_def(1:nChan);
    p.chanExc = p.chanExc(1:nChan);
    p.itg_expFRET(~~sum(p.itg_expFRET>nChan),:) = [];
    set(h.popupmenu_bgChanel, 'Value', 1);
    set(h.popupmenu_SFchannel, 'Value', 1);
    
    % Set fields to proper values
    p.SFres = {};
    h.param.movPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'imgAxes');
end


function switchMovTool(obj, evd, h)
switch obj
    case h.togglebutton_target
        set(h.togglebutton_zoom, 'Value', 0);
        
    case h.togglebutton_zoom
        set(h.togglebutton_target, 'Value', 0);
end
updateFields(h.figure_MASH, 'imgAxes');


function checkbox_int_ps_Callback(obj, evd, h)
h.param.movPr.perSec = get(obj, 'Value');
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'imgAxes');


function slider_img_Callback(obj, evd, h)
cursorPos = round(get(obj, 'Value'));
minSlider = get(obj, 'Min');
maxSlider = get(obj, 'Max');
if cursorPos <= minSlider 
    cursorPos = minSlider;
elseif cursorPos >= maxSlider
    cursorPos = maxSlider;
end
set(obj, 'Value', cursorPos);
set(h.text_frameCurr, 'String', cursorPos);

[data ok] = getFrames([h.movie.path h.movie.file], cursorPos, ...
    {h.movie.speCursor [h.movie.pixelX h.movie.pixelY] ...
    h.movie.framesTot}, h.figure_MASH);
if ok
    p = h.param.movPr;
    if size(p.SFres,1) >= 1
        p.SFres = p.SFres(1,1:(1+p.nChan));
    end
    h.param.movPr = p;
    h.movie.frameCurNb = cursorPos;
    h.movie.frameCur = data.frameCur;
    guidata(h.figure_MASH, h);
end
updateFields(h.figure_MASH, 'imgAxes');


function popupmenu_colorMap_Callback(obj, evd, h)
contents = get(obj,'String'); 
selectedText = contents{get(obj, 'Value')};
h.param.movPr.cmap = get(obj, 'Value');
guidata(h.figure_MASH, h);
colormap(selectedText);
updateActPan([selectedText ' colormap applied.'], h.figure_MASH);
updateFields(h.figure_MASH, 'imgAxes');



% Background correction

function popupmenu_bgCorr_Callback(obj, evd, h)
ud_movBgCorr(h.figure_MASH);


function checkbox_bgCorrAll_Callback(obj, evd, h)
h.param.movPr.movBg_one = ~get(obj, 'Value');
if h.param.movPr.movBg_one
    h.param.movPr.movBg_one = h.movie.frameCurNb;
end
guidata(h.figure_MASH, h);


function popupmenu_bgChanel_Callback(obj, evd, h)
updateFields(h.figure_MASH, 'movPr');
        

function edit_bgParam_01_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
method = h.param.movPr.movBg_method;
if sum(method==[12 13])
    val = round(val);
end
set(obj, 'String', val);

if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be a number.'], ...
        h.figure_MASH, 'error');
    
elseif method<18 && val<0
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be > 0.'], ...
        h.figure_MASH, 'error');
    
elseif method==9 && val>1
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be in the range ' ...
        '[0,1].'], h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_bgChanel, 'Value');
    h.param.movPr.movBg_p{method,channel}(1) = val;
    guidata(h.figure_MASH, h);
end


function edit_bgParam_02_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', val);
method = h.param.movPr.movBg_method;
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Background correction parameter must be >= 0.', ...
        h.figure_MASH, 'error');
elseif method==8 && val>1
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Background correction must be in the range [0,1].', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_bgChanel, 'Value');
    h.param.movPr.movBg_p{method,channel}(2) = val;
    guidata(h.figure_MASH, h);
end


function edit_startMov_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
stop = h.param.movPr.mov_end;
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val <= stop && ...
        val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Starting frame must be <= ending frame and >= 1.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.mov_start = val;
    guidata(h.figure_MASH, h);
end


function edit_endMov_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
start = h.param.movPr.mov_start;
tot = h.movie.framesTot;
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= start && ...
        val <= tot)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Ending frame must be >= starting frame and <= ' ...
        'frame length.'], h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.mov_end = val;
    guidata(h.figure_MASH, h);
end


function pushbutton_export_Callback(obj, evd, h)
% Set fields to proper values
updateFields(h.figure_MASH, 'movPr');
if isfield(h, 'movie')
    if isfield(h.movie, 'path') && exist(h.movie.path, 'dir')
        cd(h.movie.path);
    end
    exportMovie(h.figure_MASH);
end


% Average image


function edit_aveImg_start_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
stop = h.param.movPr.ave_stop;
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val <= stop && ...
        val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Starting frame must be <= ending frame and >= 1.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.ave_start = val;
    guidata(h.figure_MASH, h);
end


function edit_aveImg_iv_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Frame interval must be >= 1.', h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.ave_iv = val;
    guidata(h.figure_MASH, h);
end


function edit_aveImg_end_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
start = h.param.movPr.ave_start;
tot = h.movie.framesTot;
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= start && ...
        val <= tot)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Ending frame must be >= starting frame and <= ' ...
        'frame length.'], h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.ave_stop = val;
    guidata(h.figure_MASH, h);
end
    

function pushbutton_aveImg_load_Callback(obj, evd, h)
cd(setCorrectPath('average_images', h.figure_MASH));
loadMovFile(1, 'Select a graphic file:', 1, h.figure_MASH);


% Spot finder


function checkbox_SFgaussFit_Callback(obj, evd, h)
h.param.movPr.SF_gaussFit = get(obj, 'Value');
guidata(h.figure_MASH, h);
ud_SFpanel(h.figure_MASH);


function popupmenu_SFchannel_Callback(obj, evd, h)
ud_SFpanel(h.figure_MASH);


function checkbox_SFall_Callback(obj, evd, h)
h.param.movPr.SF_all = get(obj, 'Value');
guidata(h.figure_MASH, h);


function edit_SFparam_maxN_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj,'String',num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. number of peak must be >= 0.', h.figure_MASH, ...
        'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_maxN(channel) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end


function edit_SFparam_minI_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
chan = get(h.popupmenu_SFchannel, 'Value');
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan([get(obj, 'TooltipString') ' must be >= 0.'], ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    chan = get(h.popupmenu_SFchannel, 'Value');
    if h.param.movPr.perSec
        val = val*h.param.movPr.rate;
    end
    h.param.movPr.SF_minI(chan) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end


function edit_SFparam_minDspot_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj,'String',num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. peak-peak distance must be >= 0.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_minDspot(channel) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end


function edit_SFparam_minDedge_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj,'String',num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. image edge-peak distance must be >= 0.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_minDedge(channel) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end


function edit_SFparam_minHWHM_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Min. spot width must be a number.', h.figure_MASH, ...
        'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_minHWHM(channel) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end


function edit_SFparam_maxHWHM_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. spot width must be a number.', h.figure_MASH, ...
        'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_maxHWHM(channel) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end


function edit_SFparam_maxAssy_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 100)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Max. spot assymetry must be a number >= 100.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    val = str2num(get(obj, 'String'));
    channel = get(h.popupmenu_SFchannel, 'Value');
    h.param.movPr.SF_maxAssy(channel) = val;
    guidata(h.figure_MASH, h);
    ud_SFspots(h.figure_MASH);
    ud_SFpanel(h.figure_MASH);
end


% Coordinates transformation


function popupmenu_trType_Callback(obj, evd, h)
h.param.movPr.trsf_type = get(obj, 'Value');
guidata(h.figure_MASH, h);


% Intensity integration

function edit_TTgen_dim_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Integration area dimensions must be an integer > 0.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h.param.movPr.itg_dim = val;
    h.param.movPr.itg_n = val^2;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'movPr');
end


function checkbox_meanVal_Callback(obj, evd, h)
val = get(obj, 'Value');
h.param.movPr.itg_ave = val;
guidata(h.figure_MASH, h);
updateFields(h.figure_MASH, 'movPr');


function edit_nLasers_Callback(obj, evd, h)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('The number of lasers must be an integer > 0.', ...
        h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    p = h.param.movPr;
    isLasPrm = [strncmp({p.itg_expMolPrm{:,1}}', 'Power(', 6)];
    [lasPrmRow,o,o] = find(isLasPrm);
    fstLasPrm = lasPrmRow(1);
    lastLasPrm = lasPrmRow(end);
    defPrm = {p.itg_expMolPrm{1:(fstLasPrm-1),:}};
    defPrm = reshape(defPrm, [numel(defPrm)/3 3]);
    addPrm = {p.itg_expMolPrm{(lastLasPrm+1):end,:}};
    addPrm = reshape(addPrm, [numel(addPrm)/3 3]);
    for i = 1:val
        prmVal = [];
        if numel(p.itg_wl) < i
            p.itg_wl(i) = round(p.itg_wl(i-1)*1.2);
        elseif size(p.itg_expMolPrm,2) >= fstLasPrm+i-1
            prmVal = p.itg_expMolPrm{fstLasPrm+i-1,2};
        end
        lasPrm{i,1} = ['Power(' ...
            num2str(round(p.itg_wl(i))) 'nm)'];
        lasPrm{i,2} = prmVal;
        lasPrm{i,3} = 'mW';
        
    end
    
    % remove laser wavelengths if reducing the number of lasers
    p.itg_wl = p.itg_wl(1:val);
    
    for ii = 1:size(p.chanExc,2)
        if isempty(find(p.itg_wl==p.chanExc(ii)))
            % remove FRET calculations for which donors are not directly 
            % excited anymore
            if size(p.itg_expFRET,2)>0
                p.itg_expFRET(p.itg_expFRET(:,1)==ii,:) = [];
            end
            
            % remove S calculations for dyes that are not directly 
            % excited anymore
            p.itg_expS(p.itg_expS==ii) = [];
            
            % remove channel excitations if reducing the number of lasers
            p.chanExc(ii) = 0;
        end
    end
    
    if ~isempty(find(size(p.itg_expFRET)==0))
        p.itg_expFRET = [];
    end
    if ~isempty(find(size(p.itg_expS)==0))
        p.itg_expS = [];
    end

    % redifine colors for intensity trajectories
    clr_ref = getDefTrClr(val, p.itg_wl, p.nChan, size(p.itg_expFRET,1),...
        size(p.itg_expS,1));
    p.itg_clr{1} = clr_ref{1}(1:numel(p.itg_wl),:);
    p.itg_clr{2} = clr_ref{2}(1:size(p.itg_expFRET,1),:);
    p.itg_clr{3} = clr_ref{3}(1:size(p.itg_expS,1),:);
    
    p.itg_expMolPrm = [defPrm;lasPrm;addPrm];
    p.itg_nLasers = val;
    
    h.param.movPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'movPr');
end


function popupmenu_TTgen_lasers_Callback(obj, evd, h)
updateFields(h.figure_MASH, 'movPr');


function edit_wavelength_Callback(obj, evd, h)
val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
p = h.param.movPr;
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Wavelengths must be > 0', h.figure_MASH, 'error');
else
    set(obj, 'BackgroundColor', [1 1 1]);
    laser = get(h.popupmenu_TTgen_lasers, 'Value');
    p.itg_wl(laser) = val;
    p.itg_expMolPrm(4+laser,1) = {['Power(' num2str(val) 'nm)']};
    
    clr_ref = getDefTrClr(numel(p.itg_wl), p.itg_wl, p.nChan, ...
        size(p.itg_expFRET,1), size(p.itg_expS,1));
    p.itg_clr{1} = clr_ref{1}(1:numel(p.itg_wl),:);
    
    h.param.movPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'movPr');
end



%% Trace processing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Manage projects/traces


function menu_routine_CreateFcn(obj, evd, h)

h_fig = get(obj,'Parent');

uimenu(obj,'Label','routine 01','Callback', ...
    {@ttPr_routine,1,h_fig});
uimenu(obj,'Label','routine 02','Callback', ...
    {@ttPr_routine,2,h_fig});
uimenu(obj,'Label','routine 03','Callback', ...
    {@ttPr_routine,3,h_fig});
uimenu(obj,'Label','routine 04','Callback', ...
    {@ttPr_routine,4,h_fig});


function listbox_traceSet_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    slct = get(obj, 'Value');
    val = slct(end);
    if val ~= p.curr_proj
        p.curr_proj = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);

        ud_TTprojPrm(h.figure_MASH);
        ud_trSetTbl(h.figure_MASH);

        updateFields(h.figure_MASH, 'ttPr');
    end
end


function listbox_molNb_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol_prev = p.curr_mol(proj);
    currMol = get(obj, 'Value');
    if ~isequal(currMol, mol_prev)
        p.curr_mol(proj) = currMol;
        fixStart = p.proj{proj}.fix{2}(6);
        if fixStart
            p.proj{proj}.curr{currMol}{2}{1}(4) = ...
                p.proj{proj}.curr{mol_prev}{2}{1}(4);
        end
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);

        ud_trSetTbl(h.figure_MASH);
        updateFields(h.figure_MASH, 'ttPr');
    end
end


function edit_currMol_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val))
    proj = p.curr_proj;
    mol_prev = p.curr_mol(proj);
    if ~isequal(val, mol_prev)
        nMax = size(p.proj{proj}.coord_incl,2);
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 ...
                && val <= nMax)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Molecule number must be > 0 and <= ' ...
                num2str(nMax)], h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.curr_mol(proj) = val;
            fixStart = p.proj{proj}.fix{2}(6);
            if fixStart
                p.proj{proj}.curr{val}{2}{1}(4) = ...
                    p.proj{proj}.curr{mol_prev}{2}{1}(4);
            end
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);

            ud_trSetTbl(h.figure_MASH);
            updateFields(h.figure_MASH, 'ttPr');
        end
    end
end


function pushbutton_molPrev_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj) - 1;
    if mol < 1
        mol = 1;
    end
    mol_prev = p.curr_mol(proj);
    if mol ~= mol_prev
        p.curr_mol(proj) = mol;
        fixStart = p.proj{proj}.fix{2}(6);
        if fixStart
            p.proj{proj}.curr{mol}{2}{1}(4) = ...
                p.proj{proj}.curr{mol_prev}{2}{1}(4);
        end
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);

        ud_trSetTbl(h.figure_MASH);
        updateFields(h.figure_MASH, 'ttPr');
    end
end


function pushbutton_molNext_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    nMax = size(p.proj{proj}.coord_incl,2);
    mol = p.curr_mol(proj) + 1;
    if mol > nMax
        mol = nMax;
    end
    mol_prev = p.curr_mol(proj);
    if mol ~= mol_prev
        p.curr_mol(proj) = mol;
        fixStart = p.proj{proj}.fix{2}(6);
        if fixStart
            p.proj{proj}.curr{mol}{2}{1}(4) = ...
                p.proj{proj}.curr{mol_prev}{2}{1}(4);
        end
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);

        ud_trSetTbl(h.figure_MASH);
        updateFields(h.figure_MASH, 'ttPr');
    end
end


function pushbutton_ttGo_Callback(obj, evd, h)
updateFields(h.figure_MASH, 'ttPr');


function pushbutton_expTraces_Callback(obj, evd, h)
openExpTtpr(h.figure_MASH);


function pushbutton_TM_Callback(obj, evd, h)
traceManager(h.figure_MASH);
h = guidata(h.figure_MASH);
uiwait(h.tm.figure_traceMngr);
h = guidata(h.figure_MASH);
if isfield(h, 'tm') && h.tm.ud
    ud_trSetTbl(h.figure_MASH);
    updateFields(h.figure_MASH, 'ttPr');
    close(h.tm.figure_traceMngr);
end


% Sub-images and Background correction

function popupmenu_subImg_exc_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj) && p.proj{p.curr_proj}.is_coord && ...
        p.proj{p.curr_proj}.is_movie
    val = get(obj, 'Value');
    p.proj{p.curr_proj}.fix{1}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function checkbox_refocus_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj) && p.proj{p.curr_proj}.is_coord && ...
        p.proj{p.curr_proj}.is_movie
    p.proj{p.curr_proj}.fix{1}(5) = get(obj, 'Value');
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function slider_brightness_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj) && p.proj{p.curr_proj}.is_coord && ...
        p.proj{p.curr_proj}.is_movie
    val = round(100*get(obj, 'Value'))/100;
    set(obj, 'Value', val);
    p.proj{p.curr_proj}.fix{1}(3) = val*2 - 1;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'subImg');
end


function slider_contrast_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj) && p.proj{p.curr_proj}.is_coord && ...
        p.proj{p.curr_proj}.is_movie
    val = round(100*get(obj, 'Value'))/100;
    set(obj, 'Value', val);
    p.proj{p.curr_proj}.fix{1}(4) = val*2 - 1;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'subImg');
end


function popupmenu_trBgCorr_exc_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(5) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_ttBg(h.figure_MASH);
end


function popupmenu_trBgCorr_chan_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(6) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_ttBg(h.figure_MASH);
end


function popupmenu_trBgCorr_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    exc = p.proj{proj}.fix{3}(5);
    chan = p.proj{proj}.fix{3}(6);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{3}{2}(exc,chan) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_ttBg(h.figure_MASH);
end


function edit_trBgCorrParam_01_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    exc = p.proj{proj}.fix{3}(5);
    chan = p.proj{proj}.fix{3}(6);
    method = p.proj{proj}.curr{mol}{3}{2}(exc,chan);
    if sum(double(method~=[1 2]))
        val = str2num(get(obj, 'String'));
        if method==4 % number of binning interval
            val = round(val);
            if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                    val >= 1)
                set(obj, 'BackgroundColor', [1 0.75 0.75]);
                updateActPan(['Number of binning interval must be ' ...
                    '>= 1.'], h.figure_MASH, 'error');
                return;
            end
        elseif method==4 % CumP threshold
            if ~(numel(val)==1 && ~isnan(val) && val>=0 && val<=1)
                set(obj, 'BackgroundColor', [1 0.75 0.75]);
                updateActPan(['Cumulative probability threshold must ' ...
                    'be comprised between 0 and 1.'], h.figure_MASH, ...
                    'error');
                return;
            end
        elseif method==6 % running average window size
            if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                    val >= 0)
                set(obj, 'BackgroundColor', [1 0.75 0.75]);
                updateActPan(['Running average window size must be ' ...
                    '>= 0.'], h.figure_MASH, 'error');
                return;
            end
        elseif method==3 % tolerance cutoff
            if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                    val >= 0)
                set(obj, 'BackgroundColor', [1 0.75 0.75]);
                updateActPan('Tolerance cutoff must be >= 0.', ...
                    h.figure_MASH, 'error');
                return;
            end
        elseif method==7 % calculation method
            val = round(val);
            if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                    sum(val==[1 2]))
                set(obj, 'BackgroundColor', [1 0.75 0.75]);
                updateActPan('Median calculation method must be 1 or 2',...
                    h.figure_MASH, 'error');
                return;
            end
        end
        set(obj, 'BackgroundColor', [1 1 1]);
        p.proj{proj}.curr{mol}{3}{3}{exc,chan}(method,1) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_ttBg(h.figure_MASH);
    end
end


function edit_subImg_dim_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    if p.proj{proj}.is_coord && p.proj{proj}.is_movie
        val = str2num(get(obj, 'String'));
        res_x = p.proj{proj}.movie_dim(1);
        nC = p.proj{proj}.nb_channel;
        subW = round(res_x/nC);
        minVal = min([subW (res_x-(nC-1)*subW)]);
        set(obj, 'String', num2str(val));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0 ...
                && val <= minVal)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Subimage dimensions must be > 0 and <= ' ...
                num2str(minVal)], h.figure_MASH , 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            l = p.proj{proj}.fix{3}(5);
            c = p.proj{proj}.fix{3}(6);
            mol = p.curr_mol(proj);
            method = p.proj{proj}.curr{mol}{3}{2}(l,c);
            p.proj{proj}.curr{mol}{3}{3}{l,c}(method,2) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'ttPr');
        end
    end
end


function edit_trBgCorr_bgInt_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    exc = p.proj{proj}.fix{3}(5);
    chan = p.proj{proj}.fix{3}(6);
    method = p.proj{proj}.curr{mol}{3}{2}(exc,chan);
    if method == 1
        val = str2num(get(obj, 'String'));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Background intensity must be a number.', ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            perSec = p.proj{proj}.fix{2}(4);
            perPix = p.proj{proj}.fix{2}(5);
            if perSec
                rate = p.proj{proj}.frame_rate;
                val = val*rate;
            end
            if perPix
                nPix = p.proj{proj}.pix_intgr(2);
                val = val*nPix;
            end
            p.proj{proj}.curr{mol}{3}{3}{exc,chan}(method,3) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_ttBg(h.figure_MASH);
        end
    end
end


function checkbox_trBgCorr_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    exc = p.proj{proj}.fix{3}(5);
    chan = p.proj{proj}.fix{3}(6);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{3}{1}(exc,chan)= val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function edit_xDark_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    nChan = p.proj{proj}.nb_channel;
    exc = p.proj{proj}.fix{3}(5);
    chan = p.proj{proj}.fix{3}(6);
    method = p.proj{proj}.curr{mol}{3}{2}(exc,chan);
    if method == 6 % dark trace
        val = str2num(get(obj, 'String'));
        res_x = p.proj{proj}.movie_dim(1);
        lim = [0 round(res_x/nChan)*(1:(nChan-1)) res_x];
        itgDim = p.proj{proj}.pix_intgr(1);
        
        valMin = lim(chan) + itgDim/2;
        valMax = lim(chan+1) - itgDim/2;

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val > valMin && val < valMax)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Dark x-coordinates must be > ' ...
                num2str(valMin) ' and < ' num2str(valMax)], ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.proj{proj}.curr{mol}{3}{3}{exc,chan}(method,4) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_ttBg(h.figure_MASH);
            updateFields(h.figure_MASH, 'subImg');
        end
    end
end


function edit_yDark_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    exc = p.proj{proj}.fix{3}(5);
    chan = p.proj{proj}.fix{3}(6);
    method = p.proj{proj}.curr{mol}{3}{2}(exc,chan);
    if method == 6 % dark trace
        val = str2num(get(obj, 'String'));
        res_y = p.proj{proj}.movie_dim(2);
        itgDim = p.proj{proj}.pix_intgr(1);
        
        valMin = itgDim/2;
        valMax = res_y - itgDim/2;

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val > valMin && val < valMax)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Dark y-coordinates must be > ' ...
                num2str(valMin) ' and < ' num2str(valMax)], ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.proj{proj}.curr{mol}{3}{3}{exc,chan}(method,5) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_ttBg(h.figure_MASH);
            updateFields(h.figure_MASH, 'subImg');
        end
    end
end


function checkbox_autoDark_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    exc = p.proj{proj}.fix{3}(5);
    chan = p.proj{proj}.fix{3}(6);
    method = p.proj{proj}.curr{mol}{3}{2}(exc,chan);
    if method == 6 % dark trace
        val = get(obj, 'Value');
        p.proj{proj}.curr{mol}{3}{3}{exc,chan}(method,6) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_ttBg(h.figure_MASH);
        updateFields(h.figure_MASH, 'subImg');
    end
end


function pushbutton_showDark_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    dispDarkTr(h.figure_MASH);
end


function pushbutton_applyAll_ttBg_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    choice = questdlg( {['Overwriting background parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite background parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
    
    if strcmp(choice, 'Apply')
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        nMol = size(p.proj{proj}.coord_incl,2);
        for m = 1:nMol
            p.proj{proj}.curr{m}{3} = p.proj{proj}.curr{mol}{3};
        end
        p.proj{proj}.def.mol{3} = p.proj{proj}.curr{mol}{3};
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
    end
end


function pushbutton_optBg_Callback(obj, evd, h)
h.figure_optBg = Background_Analyser(h.figure_MASH);
guidata(h.figure_MASH, h);


% Traces plot

function popupmenu_ttPlotExc_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    labels = p.proj{p.curr_proj}.labels;
    str_top = getStrPop('plot_topChan', {labels val ...
        p.proj{p.curr_proj}.colours{1}});
    set(h.popupmenu_plotTop, 'String', str_top);
    p.proj{p.curr_proj}.fix{2}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function popupmenu_plotTop_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    p.proj{p.curr_proj}.fix{2}(2) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function popupmenu_plotBottom_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    p.proj{p.curr_proj}.fix{2}(3) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function checkbox_ttPerSec_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    p.proj{p.curr_proj}.fix{2}(4) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function checkbox_ttAveInt_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    p.proj{p.curr_proj}.fix{2}(5) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end



% Denoising

function popupmenu_denoising_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    mol = p.curr_mol(proj);
    p.proj{proj}.curr{mol}{1}{1}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_denoising(h.figure_MASH);
end


function checkbox_smoothIt_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p.proj{proj}.curr{mol}{1}{1}(2) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function edit_denoiseParam_01_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{1}{1}(1);
    
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Denoising parameters must be >= 0', ...
            h.figure_MASH, 'error');
        
    else
        switch method
            
            case 1 % Rolling point: running average window size
                nmax = p.proj{proj}.nb_excitations * ...
                    size(p.proj{proj}.intensities,1);
                if ~(val > 0 && val < nmax)
                    set(obj, 'BackgroundColor', [1 0.75 0.75]);
                    updateActPan(['Running average window size must be' ...
                        ' > 0 and < ' num2str(nmax)], h.figure_MASH, ...
                        'error');
                    return;
                end
                
            case 2 % Haran filter: exponential factor for predictor weights
                
            case 3 % Wavelet analysis: shrink strength, firm/hard/soft
                if ~(sum(double(val == [1 2 3])))
                    set(obj, 'BackgroundColor', [1 0.75 0.75]);
                    updateActPan(['Shrink strength must be 1, 2 or 3 ' ...
                        '(firm, hard or soft)'], h.figure_MASH, 'error');
                    return;
                end
            
            otherwise
                return;
        end
        set(obj, 'BackgroundColor', [1 1 1]);
        p.proj{proj}.curr{mol}{1}{2}(method,1) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_denoising(h.figure_MASH);
    end
end


function edit_denoiseParam_02_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{1}{1}(1);
    
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Denoising parameters must be >= 0', ...
            h.figure_MASH, 'error');
        
    else
        switch method

            case 2 % Haran filter: running average window size
                nmax = p.proj{proj}.nb_excitations * ...
                    size(p.proj{proj}.intensities,1);
                if ~(val > 0 && val < nmax && mod(val,2))
                    set(obj, 'BackgroundColor', [1 0.75 0.75]);
                    updateActPan(['Running average window size must ' ...
                        'be an odd integer > 0 and < ' num2str(nmax)], ...
                        h.figure_MASH, 'error');
                    return;
                end
                
            case 3 % Wavelet analysis: time, local/universal
                if ~(sum(double(val == [1 2])))
                    set(obj, 'BackgroundColor', [1 0.75 0.75]);
                    updateActPan(['Time must be 1 or 2 (local or ' ...
                        'universal)'], h.figure_MASH, 'error');
                    return;
                end
            
            otherwise
                return;
        end
        set(obj, 'BackgroundColor', [1 1 1]);
        p.proj{proj}.curr{mol}{1}{2}(method,2) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_denoising(h.figure_MASH);
    end
end


function edit_denoiseParam_03_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{1}{1}(1);
    
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Denoising parameters must be >= 0', ...
            h.figure_MASH, 'error');
        
    else
        switch method
            
            case 2 % Haran filter: factor for predictor window sizes
                if ~(val > 0)
                    set(obj, 'BackgroundColor', [1 0.75 0.75]);
                    updateActPan(['Factor for predictor average window' ...
                        ' sizes must be > 0'], h.figure_MASH, 'error');
                    return;
                end
                
            case 3 % Wavelet analysis: cycle spin, on/off
                if ~(sum(double(val == [1 2])))
                    set(obj, 'BackgroundColor', [1 0.75 0.75]);
                    updateActPan(['Cycle spin must be 1 or 2 (on or ' ...
                        'off)'], h.figure_MASH, 'error');
                    return;
                end
                
            otherwise
                return;
        end
        set(obj, 'BackgroundColor', [1 1 1]);
        p.proj{proj}.curr{mol}{1}{2}(method,3) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_denoising(h.figure_MASH);
    end
end


function pushbutton_applyAll_den_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    choice = questdlg( {['Overwriting denoising parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite denoising parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
    
    if strcmp(choice, 'Apply')
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        nMol = size(p.proj{proj}.coord_incl,2);
        for m = 1:nMol
            p.proj{proj}.curr{m}{1} = p.proj{proj}.curr{mol}{1};
        end
        p.proj{proj}.def.mol{1} = p.proj{proj}.curr{mol}{1};
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
    end
end



% Photobleaching

function edit_photobl_start_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    inSec = p.proj{proj}.fix{2}(7);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if p.proj{proj}.curr{mol}{2}{1}(1)
        stop = p.proj{proj}.curr{mol}{2}{1}(4+method);
    else
        nExc = p.proj{proj}.nb_excitations;
        stop = nExc*size(p.proj{proj}.intensities,1);
    end
    rate = p.proj{proj}.frame_rate;
    if inSec
        val = rate*round(val/rate);
        minVal = rate;
        maxVal = rate*stop;
    else
        val = round(val);
        minVal = 1;
        maxVal = stop;
    end
    set(obj, 'String', num2str(val));
    
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
            val >= minVal && val <= maxVal)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Data start must be >= ' num2str(minVal) ...
            ' and <= ' num2str(maxVal)], h.figure_MASH, 'error');
        
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        if inSec
            val = val/rate;
        end
        p.proj{proj}.curr{mol}{2}{1}(4) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_bleach(h.figure_MASH);
        updateFields(h.figure_MASH, 'ttPr');
    end
end


function edit_photobl_stop_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 1 % Manual
        val = str2num(get(obj, 'String'));
        inSec = p.proj{proj}.fix{2}(7);
        nExc = p.proj{proj}.nb_excitations;
        len = nExc*size(p.proj{proj}.intensities,1);
        start = p.proj{proj}.curr{mol}{2}{1}(4);
        rate = p.proj{proj}.frame_rate;
        if inSec
            val = rate*round(val/rate);
            minVal = rate*start;
            maxVal = rate*len;
        else
            val = round(val);
            minVal = start;
            maxVal = len;
        end
        set(obj, 'String', num2str(val));

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= minVal && val <= maxVal)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Data end must be >= ' num2str(minVal) ...
                ' and <= ' num2str(maxVal)], h.figure_MASH, 'error');

        else
            set(obj, 'BackgroundColor', [1 1 1]);
            if inSec
                val = val/rate;
            end
            p.proj{proj}.curr{mol}{2}{1}(4+method) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_bleach(h.figure_MASH);
        end
    end
end


function checkbox_photobl_insec_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    p.proj{proj}.fix{2}(7) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function checkbox_photobl_fixStart_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    nMol = size(p.proj{proj}.coord_incl,2);
    if val
        for m = 1:nMol
             p.proj{proj}.curr{m}{2}{1}(4) = ...
                 p.proj{proj}.curr{mol}{2}{1}(4);
        end
    else
        for m = 1:nMol
            if ~isempty(p.proj{proj}.prm{m})
                p.proj{proj}.curr{m}{2}{1}(4) = ...
                    p.proj{proj}.prm{m}{2}{1}(4);
            else
                p.proj{proj}.curr{m}{2}{1}(4) = ...
                    p.proj{proj}.curr{mol}{2}{1}(4);
            end
        end
    end
    p.proj{proj}.fix{2}(6) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function popupmenu_debleachtype_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p.proj{proj}.curr{mol}{2}{1}(2) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_bleach(h.figure_MASH);
end


function popupmenu_bleachChan_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 2 % Threshold
        val = get(obj, 'Value');
        p.proj{proj}.curr{mol}{2}{1}(3) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_bleach(h.figure_MASH);
    end
end


function edit_photoblParam_01_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 2 % Threshold
        val = str2num(get(obj, 'String'));
        set(obj, 'String', num2str(val));
        
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Data threshold must be a number.', ...
                h.figure_MASH, 'error');

        else
            set(obj, 'BackgroundColor', [1 1 1]);
            chan = p.proj{proj}.curr{mol}{2}{1}(3);
            nFRET = size(p.proj{proj}.FRET,1);
            nS = size(p.proj{proj}.S,1);
            if chan > nFRET + nS % threshold for intensities
                perSec = p.proj{proj}.fix{2}(4);
                perPix = p.proj{proj}.fix{2}(5);
                if perSec
                    rate = p.proj{proj}.frame_rate;
                    val = val*rate;
                end
                if perPix
                    nPix = p.proj{proj}.pix_intgr(2);
                    val = val*nPix;
                end
            end
            p.proj{proj}.curr{mol}{2}{2}(chan,1) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_bleach(h.figure_MASH);
        end
    end
end


function edit_photoblParam_02_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 2 % Threshold
        val = str2num(get(obj, 'String'));
        inSec = p.proj{proj}.fix{2}(7);
        nExc = p.proj{proj}.nb_excitations;
        len = nExc*size(p.proj{proj}.intensities,1);
        rate = p.proj{proj}.frame_rate;
        if inSec
            val = rate*round(val/rate);
            maxVal = rate*len;
        else
            val = round(val);
            maxVal = len;
        end
        set(obj, 'String', num2str(val));

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= maxVal)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Extra cutoff must be >= 0 and <= ' ...
                num2str(maxVal)], h.figure_MASH, 'error');

        else
            set(obj, 'BackgroundColor', [1 1 1]);
            if inSec
                val = val/rate;
            end
            chan = p.proj{proj}.curr{mol}{2}{1}(3);
            p.proj{proj}.curr{mol}{2}{2}(chan,2) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_bleach(h.figure_MASH);
        end
    end
end


function edit_photoblParam_03_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{2}{1}(2);
    if method == 2 % Threshold
        val = str2num(get(obj, 'String'));
        inSec = p.proj{proj}.fix{2}(7);
        nExc = p.proj{proj}.nb_excitations;
        len = nExc*size(p.proj{proj}.intensities,1);
        start = p.proj{proj}.prm{mol}{2}{1}(4);
        rate = p.proj{proj}.frame_rate;
        if inSec
            val = rate*round(val/rate);
            minVal = rate*start;
            maxVal = rate*len;
        else
            val = round(val);
            minVal = start;
            maxVal = len;
        end
        set(obj, 'String', num2str(val));

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= minVal && val <= maxVal)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Minimum cutoff must be >= ' num2str(minVal) ...
                ' and <= ' num2str(maxVal)], h.figure_MASH, 'error');

        else
            set(obj, 'BackgroundColor', [1 1 1]);
            if inSec
                val = val/rate;
            end
            chan = p.proj{proj}.curr{mol}{2}{1}(3);
            p.proj{proj}.curr{mol}{2}{2}(chan,3) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_bleach(h.figure_MASH);
        end
    end
end


function checkbox_cutOff_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p.proj{proj}.curr{mol}{2}{1}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function pushbutton_applyAll_debl_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    choice = questdlg( {['Overwriting debleaching parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite debleaching parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
    
    if strcmp(choice, 'Apply')
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        nMol = size(p.proj{proj}.coord_incl,2);
        for m = 1:nMol
            p.proj{proj}.curr{m}{2} = p.proj{proj}.curr{mol}{2};
        end
        p.proj{proj}.def.mol{2} = p.proj{proj}.curr{mol}{2};
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
    end
end



% Coefficient corrections

function popupmenu_corr_exc_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_cross(h.figure_MASH);
end


function popupmenu_corr_chan_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(2) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_cross(h.figure_MASH);
end


function popupmenu_bt_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(3) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_cross(h.figure_MASH);
end


function edit_bt_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0 ...
            && val <= 1)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Bleedthrough coefficient must be >= 0 and <= 1', ...
            h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        exc = p.proj{proj}.fix{3}(1);
        chan_in = p.proj{proj}.fix{3}(2);
        chan_out = p.proj{proj}.fix{3}(3);
        p.proj{proj}.curr{mol}{5}{1}{exc,chan_in}(chan_out) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_cross(h.figure_MASH);
    end
end


function edit_dirExc_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0 ...
            && val <= 1)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Direct excitation coefficient must be >= 0 and ' ...
            '<= 1'], h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        exc_in = p.proj{proj}.fix{3}(1);
        chan_in = p.proj{proj}.fix{3}(2);
        exc_base = p.proj{proj}.fix{3}(7);
        p.proj{proj}.curr{mol}{5}{2}{exc_in,chan_in}(exc_base) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_cross(h.figure_MASH);
    end
end


function popupmenu_excDirExc_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(7) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_cross(h.figure_MASH);
end


function edit_gammaCorr_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    clr = get(obj, 'String');
    if strcmp(clr, 'pink') || strcmp(clr, 'yellow') || ...
            strcmp(clr, 'blue') || strcmp(clr, 'green') || ...
            strcmp(clr, 'gray') || strcmp(clr, 'danny')
        setBgClr(h.figure_MASH, clr);
        ud_cross(h.figure_MASH);
        return;
    end
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    chan = p.proj{proj}.fix{3}(8);
    if chan>0
        val = str2num(get(obj, 'String'));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Gamma correction factor must be >= 0', ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p.proj{proj}.curr{mol}{5}{3}(chan) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_cross(h.figure_MASH);
        end
    end
end


function popupmenu_gammaFRET_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    p.proj{proj}.fix{3}(8) = val-1;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_cross(h.figure_MASH);
end

% FS added 8.1.2018
function pushbutton_optGamma_Callback(obj, evd, h)
gammaOpt(h.figure_MASH);



% FS added 8.1.2018, last modified 11.1.2018
function checkbox_pbGamma_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    toFRET = p.proj{proj}.curr{mol}{4}{1}(2);
    if toFRET == 1  % if DTA applied to bottom traces, deactivate pb gamma calculation
        val = 0;
    end
    p.proj{proj}.curr{mol}{5}{4}(1) = val; % pb based gamma corr checkbox 
    p.proj{proj}.curr{mol}{5}{5}(1) = val; % show cutoff checkbox
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    if val == 1 % added by FS, 24.7.2018
        updateFields(h.figure_MASH, 'ttPr');
    end
    % get updated handle (updated in updateFields)
    % h = guidata(h_fig) is called at the beginning of the next function (updateFields is the last function),
    % but here the handle is still needed for the next line
    h = guidata(h.figure_MASH);
    set(obj, 'Value', h.param.ttPr.proj{proj}.curr{mol}{5}{4}(1)) % updates the pb Gamma checkbox
end


function pushbutton_applyAll_corr_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    choice = questdlg( {['Overwriting factor parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite factor parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
    
    if strcmp(choice, 'Apply')
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        nMol = size(p.proj{proj}.coord_incl,2);
        for m = 1:nMol
            p.proj{proj}.curr{m}{5} = p.proj{proj}.curr{mol}{5};
        end
        p.proj{proj}.def.mol{5} = p.proj{proj}.curr{mol}{5};
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
    end
end


% Dwell-time analysis

function popupmenu_DTAmethod_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{4}{1}(1) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_DTA(h.figure_MASH);
end


function radiobutton_DTA2bottom_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{4}{1}(2) = val;
    
    % added by FS, 5.6.2018
    % disable photobleaching based gamma factor determination
    % checkbox and pushbutton are enable again if isDiscrTop is 1 in 'discrTraces.m'
    set(h.pushbutton_optGamma, 'enable', 'off') 
    p.proj{proj}.curr{mol}{5}{4}(1) = 0; % deactivate the pb based gamma correction checkbox
    set(h.checkbox_pbGamma, 'enable', 'off', 'Value', 0)
    
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_DTA(h.figure_MASH);
end


function radiobutton_DTA2top_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{4}{1}(2) = ~val;
    
    % added by FS, 5.6.2018
    % disable photobleaching based gamma factor determination
    % checkbox and pushbutton are enable again if isDiscrTop is 1 in 'discrTraces.m'
    set(h.pushbutton_optGamma, 'enable', 'on') 
    p.proj{proj}.curr{mol}{5}{4}(1) = 1; % deactivate the pb based gamma correction checkbox
    set(h.checkbox_pbGamma, 'enable', 'on', 'Value', 0)
    
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_DTA(h.figure_MASH);
end


function radiobutton_DTA2all_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{4}{1}(2) = 2*val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_DTA(h.figure_MASH);
end


function popupmenu_DTAchannel_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    val = get(obj, 'Value');
    p.proj{proj}.fix{3}(4) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    ud_DTA(h.figure_MASH);
end


function edit_DTA_minN_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{4}{1}(1);
    chan_in = p.proj{proj}.fix{3}(4);
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    valMax = p.proj{proj}.curr{mol}{4}{2}(method,2,chan_in);
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 1 ...
            && val <= valMax)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Minimum number of states must be >= 1 and <= ' ...
            num2str(valMax)], h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        p.proj{proj}.curr{mol}{4}{2}(method,1,chan_in) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_DTA(h.figure_MASH);
    end
end


function edit_DTA_maxN_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{4}{1}(1);
    chan_in = p.proj{proj}.fix{3}(4);
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    valMin = p.proj{proj}.curr{mol}{4}{2}(method,1,chan_in);
    if method==1
        valMax = 6;
    else
        valMax = Inf;
    end
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
            val <= valMax && val >= valMin)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Maximum number of states must be >= ' ...
            num2str(valMin) ' and <= ' num2str(valMax)], h.figure_MASH, ...
            'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        p.proj{proj}.curr{mol}{4}{2}(method,2,chan_in) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_DTA(h.figure_MASH);
    end
end



function edit_DTA_smooth_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Number of refinment cycles must be >= 0', ...
            h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        method = p.proj{proj}.curr{mol}{4}{1}(1);
        chan_in = p.proj{proj}.fix{3}(4);
        p.proj{proj}.curr{mol}{4}{2}(method,3,chan_in) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_DTA(h.figure_MASH);
    end
end


function edit_DTA_bin_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('State binning must be >= 0', ...
            h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        method = p.proj{proj}.curr{mol}{4}{1}(1);
        chan_in = p.proj{proj}.fix{3}(4);
        nFRET = size(p.proj{proj}.FRET,1);
        nS = size(p.proj{proj}.S,1);
        if chan_in > (nFRET + nS)
            perSec = p.proj{proj}.fix{2}(4);
            perPix = p.proj{proj}.fix{2}(5);
            if perSec
                rate = p.proj{proj}.frame_rate;
                val = val*rate;
            end
            if perPix
                nPix = p.proj{proj}.pix_intgr(2);
                val = val*nPix;
            end
        end
        p.proj{proj}.curr{mol}{4}{2}(method,4,chan_in) = val;
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_DTA(h.figure_MASH);
    end
end


function edit_DTAparam_01_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{4}{1}(1);
    if sum(double(method == [2 4]))
        val = round(str2num(get(obj, 'String')));
        set(obj, 'String', num2str(val));

        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            if method == 2 % VbFRET
                updateActPan('Number of iteration must be > 0', ...
                    h.figure_MASH, 'error');
            elseif method == 4 % CPA
                updateActPan('Number of bootstrap sample must be > 0', ...
                    h.figure_MASH, 'error');
            end
            
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            chan_in = p.proj{proj}.fix{3}(4);
            p.proj{proj}.curr{mol}{4}{2}(method,5,chan_in) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end


function edit_DTAparam_02_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{4}{1}(1);
    if method == 4 % CPA
        val = round(str2num(get(obj, 'String')));
        set(obj, 'String', num2str(val));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= 100)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Confidence level must be >= 0 and <= 100', ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            chan_in = p.proj{proj}.fix{3}(4);
            p.proj{proj}.curr{mol}{4}{2}(method,6,chan_in) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end


function edit_DTAparam_03_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{4}{1}(1);
    if method == 4 % CPA
        val = round(str2num(get(obj, 'String')));
        set(obj, 'String', num2str(val));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                sum(double(val == [1 2])))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Method for change localisation must be 1 ' ...
                'or 2 ("max." or "MSE")'], h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            chan_in = p.proj{proj}.fix{3}(4);
            p.proj{proj}.curr{mol}{4}{2}(method,7,chan_in) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end


function edit_DTAparam_04_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    toBot = p.proj{proj}.curr{mol}{4}{1}(2);
    if ~toBot
        val = round(str2num(get(obj, 'String')));
        set(obj, 'String', num2str(val));
        valMax = ...
            p.proj{proj}.nb_excitations*size(p.proj{proj}.intensities,1);
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
                val >= 0 && val <= valMax)
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan(['Width of changing zone must be >= 0 and <= ' ...
                num2str(valMax)], h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            method = p.proj{proj}.curr{mol}{4}{1}(1);
            p.proj{proj}.curr{mol}{4}{2}(method,8,:) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end


function checkbox_recalcStates_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{4}{1}(3) = val;
    h.param.ttPr = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'ttPr');
end


function edit_thresh_Callback(obj, evd, h, state)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{4}{1}(1);
    if method == 1 % Threshold
        val = str2num(get(obj, 'String'));
        set(obj, 'String', num2str(val));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('State value must be a number.', ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            chan_in = p.proj{proj}.fix{3}(4);
            nFRET = size(p.proj{proj}.FRET,1);
            nS = size(p.proj{proj}.S,1);
            if chan_in > (nFRET + nS)
                perSec = p.proj{proj}.fix{2}(4);
                perPix = p.proj{proj}.fix{2}(5);
                if perSec
                    rate = p.proj{proj}.frame_rate;
                    val = val*rate;
                end
                if perPix
                    nPix = p.proj{proj}.pix_intgr(2);
                    val = val*nPix;
                end
            end
            p.proj{proj}.curr{mol}{4}{4}(1,state,chan_in) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end


function edit_low_Callback(obj, evd, h, state)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{4}{1}(1);
    if method == 1 % Threshold
        val = str2num(get(obj, 'String'));
        set(obj, 'String', num2str(val));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Lower threshold value must be a number.', ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            chan_in = p.proj{proj}.fix{3}(4);
            nFRET = size(p.proj{proj}.FRET,1);
            nS = size(p.proj{proj}.S,1);
            if chan_in > (nFRET + nS)
                perSec = p.proj{proj}.fix{2}(4);
                perPix = p.proj{proj}.fix{2}(5);
                if perSec
                    rate = p.proj{proj}.frame_rate;
                    val = val*rate;
                end
                if perPix
                    nPix = p.proj{proj}.pix_intgr(2);
                    val = val*nPix;
                end
            end
            p.proj{proj}.curr{mol}{4}{4}(2,state,chan_in) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end


function edit_up_Callback(obj, evd, h, state)
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    method = p.proj{proj}.curr{mol}{4}{1}(1);
    if method == 1 % Threshold
        val = str2num(get(obj, 'String'));
        set(obj, 'String', num2str(val));
        if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Upper threshold value must be a number.', ...
                h.figure_MASH, 'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            chan_in = p.proj{proj}.fix{3}(4);
            nFRET = size(p.proj{proj}.FRET,1);
            nS = size(p.proj{proj}.S,1);
            if chan_in > (nFRET + nS)
                perSec = p.proj{proj}.fix{2}(4);
                perPix = p.proj{proj}.fix{2}(5);
                if perSec
                    rate = p.proj{proj}.frame_rate;
                    val = val*rate;
                end
                if perPix
                    nPix = p.proj{proj}.pix_intgr(2);
                    val = val*nPix;
                end
            end
            p.proj{proj}.curr{mol}{4}{4}(3,state,chan_in) = val;
            h.param.ttPr = p;
            guidata(h.figure_MASH, h);
            ud_DTA(h.figure_MASH);
        end
    end
end


function pushbutton_applyAll_DTA_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    choice = questdlg( {['Overwriting DTA parameters of all ' ...
        'molecules erases previous traces processing'], ...
        'Overwrite DTA parameters of all molecule?'}, ...
        'Overwrite parameters', 'Apply', 'Cancel', 'Apply');
    
    if strcmp(choice, 'Apply')
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        nMol = size(p.proj{proj}.coord_incl,2);
        for m = 1:nMol
            p.proj{proj}.curr{m}{4} = p.proj{proj}.curr{mol}{4};
        end
        p.proj{proj}.def.mol{4} = p.proj{proj}.curr{mol}{4};
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
    end
end


%% Gathering results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% TDP analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pushbutton_TDPimpOpt_Callback(obj, evd, h)
openTrImpOpt(obj, evd, h);


function edit_TDPradius_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    meth = p.proj{proj}.prm{tpe}.clst_start{1}(1);
    
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        switch meth
            case 1 % kmean
                str = 'Tolerance radii';
            case 2 % gaussian model based
                str = 'Min. Gaussian standard deviation.';
        end
        setContPan([str ' must be >= 0.'], 'error', h.figure_MASH);
        
    else
        switch meth
            case 1 % kmean
                state = get(h.popupmenu_TDPstate, 'Value');
                p.proj{proj}.prm{tpe}.clst_start{2}(state,2) = val;
                
            case 2 % gaussian model based
                p.proj{proj}.prm{tpe}.clst_start{2}(1,2) = val;
        end
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end

function popupmenu_TDPcolour_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = get(obj, 'Value');
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trans = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    p.proj{proj}.prm{tpe}.clst_start{3}(trans,:) = p.colList(val,:);
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
end


function pushbutton_TDPcmap_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    axes(h.axes_TDPplot1);
    colormapeditor;
end


function pushbutton_TDPexport_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    expTDPopt(h.figure_MASH);
end


% Exponential fit

function radiobutton_TDPstretch_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    kin_k = p.proj{proj}.prm{tpe}.kin_start;
    if kin_k{trs,1}(1) ~= get(obj, 'Value') && ~kin_k{trs,1}(1)
        kin_k{trs,1}(1) = get(obj, 'Value');
        p.proj{proj}.prm{tpe}.kin_start = kin_k;
        p.proj{proj}.prm{tpe}.kin_res(trs,:) = cell(1,5);
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
    end
    updateFields(h.figure_MASH, 'TDP');
end


function radiobutton_TDPmultExp_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    kin_k = p.proj{proj}.prm{tpe}.kin_start;
    if kin_k{trs,1}(1) == get(obj, 'Value') && kin_k{trs,1}(1)
        kin_k{trs,1}(1) = ~get(obj, 'Value');
        p.proj{proj}.prm{tpe}.kin_start = kin_k;
        p.proj{proj}.prm{tpe}.kin_res(trs,:) = cell(1,5);
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
    end
    updateFields(h.figure_MASH, 'TDP');
end


function edit_TDP_nExp_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val > 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Number of exponential decays must be positive', ...
            'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
        kin_k = p.proj{proj}.prm{tpe}.kin_start;
        prev_val = kin_k{trs,1}(2);
        if prev_val ~= val
            for t = 1:val
                if prev_val < t 
                    kin_k{trs,2}(t,:) = kin_k{trs,2}(t-1,:);
                end
            end
            kin_k{trs,2} = kin_k{trs,2}(1:val,:);
            kin_k{trs,1}(2) = val;
            if kin_k{trs,1}(3) > val
                kin_k{trs,1}(3) = val;
            end
            p.proj{proj}.prm{tpe}.kin_start = kin_k;
            p.proj{proj}.prm{tpe}.kin_res(trs,:) = cell(1,5);
            h.param.TDP = p;
            guidata(h.figure_MASH, h);
            updateFields(h.figure_MASH, 'TDP');
        end
    end
end


function popupmenu_TDP_expNum_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    p.proj{proj}.prm{tpe}.kin_start{trs,1}(3) = get(obj, 'Value');
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
end


function checkbox_BOBA_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    p.proj{proj}.prm{tpe}.kin_start{trs,1}(4) = get(obj, 'Value');
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
end


function edit_TDPbsprm_01_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val > 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Number of replicates must be >= 0', 'error', ...
            h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
        p.proj{proj}.prm{tpe}.kin_start{trs,1}(5) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPbsprm_02_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val > 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Number of samples must be >= 0', 'error', ...
            h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
        p.proj{proj}.prm{tpe}.kin_start{trs,1}(6) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function checkbox_bobaWeight_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    trs = p.proj{proj}.prm{tpe}.clst_start{1}(4);
    p.proj{proj}.prm{tpe}.kin_start{trs,1}(7) = get(obj, 'Value');
    h.param.TDP = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'TDP');
end


function edit_TDPfit_aLow_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Exp. amplitude must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        strch = prm.kin_start{trs,1}(1);
        if strch
            n = 1;
        else
            n = p.proj{proj}.prm{tpe}.kin_start{trs,1}(3);
        end
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(n,1) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_aStart_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Exp. amplitude must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        strch = prm.kin_start{trs,1}(1);
        if strch
            n = 1;
        else
            n = p.proj{proj}.prm{tpe}.kin_start{trs,1}(3);
        end
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(n,2) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_aUp_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Exp. amplitude must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        strch = prm.kin_start{trs,1}(1);
        if strch
            n = 1;
        else
            n = p.proj{proj}.prm{tpe}.kin_start{trs,1}(3);
        end
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(n,3) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_decLow_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Exp. time decay must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        strch = prm.kin_start{trs,1}(1);
        if strch
            n = 1;
        else
            n = p.proj{proj}.prm{tpe}.kin_start{trs,1}(3);
        end
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(n,4) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_decStart_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Exp. time decay must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        strch = prm.kin_start{trs,1}(1);
        if strch
            n = 1;
        else
            n = p.proj{proj}.prm{tpe}.kin_start{trs,1}(3);
        end
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(n,5) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_decUp_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Exp. time decay must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        strch = prm.kin_start{trs,1}(1);
        if strch
            n = 1;
        else
            n = p.proj{proj}.prm{tpe}.kin_start{trs,1}(3);
        end
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(n,6) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_betaLow_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Beta exponent must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(1,7) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_betaStart_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Beta exponent must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(1,8) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_betaUp_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val >= 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('Beta exponent must be >= 0', 'error', h.figure_MASH);
        return;
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        prm = p.proj{proj}.prm{tpe};
        trs = prm.clst_start{1}(4);
        p.proj{proj}.prm{tpe}.kin_start{trs,2}(1,9) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end


function edit_TDPfit_res_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'TDP');
end
    

function pushbutton_TDPfit_log_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    act = get(obj, 'String');
    if strcmp(act, 'y-log scale')
        set(obj, 'String', 'y-linear scale');
        set(h.axes_TDPplot2, 'YScale', 'log');
    elseif strcmp(act, 'y-linear scale')
        set(obj, 'String', 'y-log scale');
        set(h.axes_TDPplot2, 'YScale', 'linear');
    end
end



%% Histogram analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Project managment


function listbox_thm_projLst_Callback(obj, evd, h)
p = h.param.thm;
if size(p.proj,2)>1
    val = get(obj, 'Value');
    p.curr_proj = val(1);
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    cla(h.axes_hist1);
    cla(h.axes_hist2);
    updateFields(h.figure_MASH, 'thm');
end


function pushbutton_thm_impASCII_Callback(obj, evd, h)


function pushbutton_thm_export_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    export_thm(h.figure_MASH);
end


% Bootstrap analysis

function radiobutton_thm_gaussFit_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    p.proj{proj}.prm{tpe}.thm_start{1}(1) = 1;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end


function radiobutton_thm_thresh_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    p.proj{proj}.prm{tpe}.thm_start{1}(1) = 2;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end


function checkbox_thm_BS_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    p.proj{proj}.prm{tpe}.thm_start{1}(2) = get(obj, 'Value');
    p.proj{proj}.prm{tpe}.thm_res(1,1:3) = {[] [] []};
    p.proj{proj}.prm{tpe}.thm_res(2,1:3) = {[] [] []};
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end


function edit_thm_nRep_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>0)
        setContPan(['The number of replicates must be a positive ' ...
            'integer'], 'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        prm.thm_start{1}(1,3) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_nSpl_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>0)
        setContPan(['The number of samples must be a positive ' ...
            'integer'], 'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        prm.thm_start{1}(1,4) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function checkbox_thm_weight_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    prm.thm_start{1}(1,5) = get(obj, 'Value');
    p.proj{proj}.prm{tpe} = prm;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end


% Gaussian fitting

function pushbutton_thm_RMSE_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    prm.thm_res(2,1:3) = {[] [] []};
    prm.thm_res(3,1:3) = {[] [] []};
    prev_res = prm.thm_res;
    
    isBIC = ~prm.thm_start{4}(1); % apply BIC (or rmse) selection
    penalty = prm.thm_start{4}(2); % penalty factor for rmse selection
    Kmax = prm.thm_start{4}(3); % maximum number of Gaussian functions to fit
    val = prm.plot{2}(:,[1 2 3])'; % histogram: FRET, count, cumulative count
%     N = size(val,2); % number of molecules

    res = rmse_ana(h.figure_MASH, isBIC, penalty, Kmax, val);
    prm.thm_res(3,1:2) = res;
    
    if isequal(prm.thm_res,prev_res)
        setContPan('Not enought data for RMSE analysis.', 'error' , ...
            h.figure_MASH);
        return;
    end
    
    L = prm.thm_res{3,1}(:,1);
    BIC = prm.thm_res{3,1}(:,2);
    
    if isBIC
        [o,Kopt] = min(BIC);
        
    else
        Kopt = 1;
        for k = 2:Kmax
            if ((L(k)-L(k-1))/abs(L(k-1)))>(penalty-1)
                Kopt = k;
            else
                break;
            end
        end
    end
    
    set(h.popupmenu_thm_nTotGauss, 'Value', Kopt);
    
    x_lim = prm.plot{1}(2:3);
    fitprm = prm.thm_res{3,2}{Kopt};
    prm.thm_start{3} = [zeros(Kopt,1) fitprm(:,1) ones(Kopt,1) ...
        repmat(x_lim(1),[Kopt,1]) fitprm(:,2) repmat(x_lim(2),[Kopt,1]) ...
        zeros(Kopt,1) fitprm(:,3) Inf(Kopt,1) p.colList(1:Kopt,:)];
    p.proj{proj}.prm{tpe} = prm;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end


function edit_thm_penalty_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>0)
        setContPan('The penalty must be number >=1', 'error', ...
            h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        prm.thm_start{4}(1,2) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function popupmenu_thm_nTotGauss_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'thm');
end


function radiobutton_thm_penalty_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    prm.thm_start{4}(1,1) = get(obj, 'Value');
    p.proj{proj}.prm{tpe} = prm;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end


function radiobutton_thm_BIC_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    prm.thm_start{4}(1,1) = ~get(obj, 'Value');
    p.proj{proj}.prm{tpe} = prm;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end


function edit_thm_maxGaussNb_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    val = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>0)
        setContPan(['The max. number of Gaussians should be a positive' ...
            ' integer'], 'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        prm.thm_start{4}(1,3) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function pushbutton_thm_impPrm_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};

    if ~isempty(prm.thm_res{3,2})
        
        K = get(h.popupmenu_thm_nTotGauss, 'Value');
    
        x_lim = prm.plot{1}(2:3);
        fitprm = prm.thm_res{3,2}{K};
        prm.thm_start{3} = [zeros(K,1) fitprm(:,1) ones(K,1) ...
            repmat(x_lim(1),[K,1]) fitprm(:,2) repmat(x_lim(2),[K,1]) ...
            zeros(K,1) fitprm(:,3) Inf(K,1) p.colList(1:K,:)];
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_nGaussFit_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    K = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(K));
    if ~(numel(K)==1 && ~isnan(K) && K>0)
        setContPan(['The number of Gaussians should be a positive ' ...
            'integer'], 'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    elseif K~=size(prm.thm_start{3},1)
        set(obj, 'BackgroundColor', [1 1 1]);
        if size(prm.thm_start{3},1)<K
            states = linspace(0,1,K+2);
            states = states(2:end-1);
            thm_start = prm.thm_start{3};
            for i = size(thm_start,1)+1:K
                thm_start(i,:) = thm_start(i-1,:);
                thm_start(i,5) = states(i);
            end
            prm.thm_start{3} = thm_start;
        end
        prm.thm_start{3} = prm.thm_start{3}(1:K,:);
        prm.thm_res(2,1:3) = {[] [] []};
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function pushbutton_thm_fit_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'thm');
    gauss_ana(h.figure_MASH);
    updateFields(h.figure_MASH, 'thm');
end


function edit_thm_centreUp_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    minVal = prm.thm_start{3}(gauss,5);
    
    if isInt
        if perSec
            minVal = minVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
        end
    end
    
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>minVal)
        setContPan(sprintf(['The upper limit of Gaussian center must ' ...
            'be higher than the starting value (%d)'],minVal), 'error', ...
            h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        prm.thm_start{3}(gauss,6) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_ampUp_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};

    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    minVal = prm.thm_start{3}(gauss,2);
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>minVal)
        setContPan(sprintf(['The upper limit of Gaussian amplitude ' ...
            'must be higher than the starting value (%d)'],minVal), ...
            'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        prm.thm_start{3}(gauss,3) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_centreStart_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    minVal = prm.thm_start{3}(gauss,4);
    maxVal = prm.thm_start{3}(gauss,6);
    
    if isInt
        if perSec
            minVal = minVal/expT;
            maxVal = maxVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
            maxVal = maxVal/nPix;
        end
    end
    
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>minVal && val<maxVal)
        setContPan(sprintf(['The starting guess for Gaussian center ' ...
            'must be higher than the lower limit (%d) and lower than ' ...
            'the upper limit (%d)'],minVal,maxVal), 'error', ...
            h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.thm_start{3}(gauss,5) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_ampStart_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    minVal = prm.thm_start{3}(gauss,1);
    maxVal = prm.thm_start{3}(gauss,3);
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>minVal && val<maxVal)
        setContPan(sprintf(['The starting guess for Gaussian amplitude' ...
            ' must be higher than the lower limit (%d) and lower than ' ...
            'the upper limit (%d)'],minVal,maxVal), 'error', ...
            h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        prm.thm_start{3}(gauss,2) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_centreLow_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    maxVal = prm.thm_start{3}(gauss,5);
    
    if isInt
        if perSec
            maxVal = maxVal/expT;
        end
        if perPix
            maxVal = maxVal/nPix;
        end
    end
    
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val<maxVal)
        setContPan(sprintf(['The lower limit of Gaussian center must ' ...
            'be higher than the starting value (%d)'],maxVal), 'error', ...
            h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.thm_start{3}(gauss,4) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_ampLow_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    maxVal = prm.thm_start{3}(gauss,2);
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val<maxVal)
        setContPan(sprintf(['The lower limit of Gaussian amplitude ' ...
            'must be lower than the starting value (%d)'],maxVal), ...
            'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        prm.thm_start{3}(gauss,1) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function popupmenu_thm_gaussNb_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'thm');
end


function edit_thm_fwhmUp_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    minVal = prm.thm_start{3}(gauss,8);
    
    if isInt
        if perSec
            minVal = minVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
        end
    end
    
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>minVal)
        setContPan(sprintf(['The upper limit of Gaussian FWHM ' ...
            'must be higher than the starting value (%d)'],minVal), ...
            'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.thm_start{3}(gauss,9) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_fwhmStart_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    minVal = prm.thm_start{3}(gauss,7);
    maxVal = prm.thm_start{3}(gauss,9);
    
    if isInt
        if perSec
            minVal = minVal/expT;
            maxVal = maxVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
            maxVal = maxVal/nPix;
        end
    end
    
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val>minVal && val<maxVal)
        setContPan(sprintf(['The starting guess for Gaussian FWHM' ...
            ' must be higher than the lower limit (%d) and lower than ' ...
            'the upper limit (%d)'],minVal,maxVal), 'error', ...
            h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.thm_start{3}(gauss,8) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_fwhmLow_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    gauss = get(h.popupmenu_thm_gaussNb, 'Value');
    val = str2num(get(obj, 'String'));
    maxVal = prm.thm_start{3}(gauss,8);
    
    if isInt
        if perSec
            maxVal = maxVal/expT;
        end
        if perPix
            maxVal = maxVal/nPix;
        end
    end
    
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val<maxVal)
        setContPan(sprintf(['The lower limit of Gaussian FWHM ' ...
            'must be lower than the starting value (%d)'],maxVal), ...
            'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.thm_start{3}(gauss,7) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


% Thresholding

function edit_thm_threshVal_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    thresh = get(h.popupmenu_thm_thresh, 'Value');
    N = size(prm.thm_start{2},1);
    val = str2num(get(obj, 'String'));
    if thresh==1 && N>1
        minVal = -Inf;
        maxVal = prm.thm_start{2}(thresh+1);
    elseif thresh==N && N>1
        minVal = prm.thm_start{2}(thresh-1);
        maxVal = Inf;
    elseif N==1
        minVal = -Inf;
        maxVal = Inf;
    else
        minVal = prm.thm_start{2}(thresh-1);
        maxVal =  prm.thm_start{2}(thresh+1);
    end
    
    if isInt
        if perSec
            minVal = minVal/expT;
            maxVal = maxVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
            maxVal = maxVal/nPix;
        end
    end
    
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val)&& val>minVal && val<maxVal)
        setContPan(sprintf(['Threshold value must be higher than the ' ...
            'previous threshold (%d) and lower than the next threshold' ...
            '(%d)'], minVal, maxVal), ...
            'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.thm_start{2}(thresh) = val;
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function popupmenu_thm_thresh_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'thm');
end


function popupmenu_thm_pop_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'thm');
end


function edit_thm_threshNb_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    N = round(str2num(get(obj, 'String')));
    set(obj, 'String', num2str(N));
    if ~(numel(N)==1 && ~isnan(N) && N>0)
        setContPan(['The number of thresholds should be a positive ' ...
            'integer'], 'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    elseif N~=numel(prm.thm_start{2})
        set(obj, 'BackgroundColor', [1 1 1]);
        if numel(prm.thm_start{2})<N
            thm_start = prm.thm_start{2};
            thresh = (linspace(thm_start(end),1.2,N+2))';
            thresh = thresh(2:end-1,1);
            for i = size(thm_start,1)+1:N
                thm_start(i,1) = thresh(i,1);
            end
            prm.thm_start{2} = thm_start;
        end
        prm.thm_start{2} = prm.thm_start{2}(1:N,:);
        prm.thm_res(1,1:3) = {[] [] []};
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function pushbutton_thm_threshStart_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    updateFields(h.figure_MASH, 'thm');
    thresh_ana(h.figure_MASH);
    updateFields(h.figure_MASH, 'thm');
end


% Plot

function popupmenu_thm_tpe_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    if get(obj, 'Value') ~= p.curr_tpe(proj)
        p.curr_tpe(proj) = get(obj, 'Value');
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        cla(h.axes_hist1);
        cla(h.axes_hist2);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_xlim1_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    maxVal = prm.plot{1}(1,3);
    
    if isInt
        if perSec
            maxVal = maxVal/expT;
        end
        if perPix
            maxVal = maxVal/nPix;
        end
    end
    
    if ~(numel(val)==1 && ~isnan(val) && val<maxVal)
        setContPan(sprintf(['Lower limit of x-axis must be lower than ' ...
            '%d.'],maxVal), 'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.plot{1}(1,2) = val;
        prm.plot{2} = [];
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_xlim2_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    isInt = tpe <= 2*nChan*nExc;
    perSec = p.proj{proj}.cnt_p_sec;
    perPix = p.proj{proj}.cnt_p_pix;
    expT = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    minVal = prm.plot{1}(1,2);
    
    if isInt
        if perSec
            minVal = minVal/expT;
        end
        if perPix
            minVal = minVal/nPix;
        end
    end
    
    if ~(numel(val)==1 && ~isnan(val) && val>minVal)
        setContPan(sprintf(['Upper limit of x-axis must be higher than' ...
            ' %d.'],minVal), 'error', h.figure_MASH);
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.plot{1}(1,3) = val;
        prm.plot{2} = [];
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function edit_thm_xbin_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    if ~(numel(val)==1 && ~isnan(val) && val > 0)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('x-binning must be > 0', 'error', h.figure_MASH);
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        proj = p.curr_proj;
        tpe = p.curr_tpe(proj);
        prm = p.proj{proj}.prm{tpe};
        
        nChan = p.proj{proj}.nb_channel;
        nExc = p.proj{proj}.nb_excitations;
        isInt = tpe <= 2*nChan*nExc;
        perSec = p.proj{proj}.cnt_p_sec;
        perPix = p.proj{proj}.cnt_p_pix;
        expT = p.proj{proj}.frame_rate;
        nPix = p.proj{proj}.pix_intgr(2);
        
        if isInt
            if perSec
                val = val*expT;
            end
            if perPix
                val = val*nPix;
            end
        end
        
        prm.plot{1}(1,1) = val;
        prm.plot{2} = [];
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'thm');
    end
end


function checkbox_thm_ovrfl_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    prm.plot{1}(4) = get(obj, 'Value');
    prm.plot{2} = [];
    p.proj{proj}.prm{tpe} = prm;
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'thm');
end

