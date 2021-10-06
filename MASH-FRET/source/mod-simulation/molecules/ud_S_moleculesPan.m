function ud_S_moleculesPan(h_fig)
% ud_S_moleculesPan(h_fig)
%
% Set panel Molecules to proper values
%
% h_fig: handle to main figure

% defaults
Jmax = 5; % maximum number of states allowed by interface

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_S_molecules,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
prm = p.proj{proj}.sim;

h_ed = [h.edit11 h.edit21 h.edit31 h.edit41 h.edit51 
    h.edit12 h.edit22 h.edit32 h.edit42 h.edit52
    h.edit13 h.edit23 h.edit33 h.edit43 h.edit53
    h.edit14 h.edit24 h.edit34 h.edit44 h.edit54
    h.edit15 h.edit25 h.edit35 h.edit45 h.edit55];

% set sample size
set(h.edit_nbMol, 'String', num2str(prm.molNb));

% set presets import
if ~prm.impPrm
    set(h.checkbox_simPrmFile, 'Value', 0);
    set(h.edit_simPrmFile, 'Enable', 'off', 'String', '');
else
    set(h.checkbox_simPrmFile, 'Value', 1);
    set(h.edit_nbMol, 'Enable', 'inactive');
    
    [o,fname,fext] = fileparts(prm.prmFile);
    set(h.edit_simPrmFile, 'String', [fname,fext]);
end

% set coordinates import
if prm.impPrm && isfield(prm.molPrm, 'coord') && ~isempty(prm.molPrm.coord)
    set(h.pushbutton_simImpCoord, 'Enable', 'off');
    set([h.radiobutton_simCoordFile,h.radiobutton_randCoord],'value',0,...
        'Enable', 'off');
    set(h.edit_simCoordFile, 'Enable', 'off', 'string', '');
    
elseif isempty(prm.coordFile)
    set(h.radiobutton_simCoordFile,'value',0);
    set(h.radiobutton_randCoord,'value',1);
    set(h.edit_simCoordFile, 'Enable', 'off', 'string', '');
    
else
    set(h.radiobutton_simCoordFile,'value',1);
    set(h.radiobutton_randCoord,'value',0);
    set(h.edit_nbMol, 'Enable', 'inactive');

    [o,fname,fext] = fileparts(prm.coordFile);
    set(h.edit_simCoordFile, 'String', [fname fext]);
end

% set state configuration
set(h.edit_nbStates, 'String', num2str(prm.nbStates));
state = get(h.popupmenu_states, 'Value');
if state > prm.nbStates
    state = prm.nbStates;
end
set(h.popupmenu_states, 'Value', state, 'String', ...
    cellstr(num2str((1:prm.nbStates)'))');
if prm.impPrm && isfield(prm.molPrm, 'stateVal')
    set([h.edit_nbStates h.popupmenu_states h.edit_stateVal ...
        h.edit_simFRETw], 'Enable', 'off');
    set(h.edit_stateVal, 'String', num2str(prm.molPrm.stateVal(1,state)));
    set(h.edit_simFRETw, 'String', num2str(prm.molPrm.FRETw(1,state)));
else
    set(h.edit_stateVal, 'String', num2str(prm.stateVal(state)));
    set(h.edit_simFRETw, 'String', num2str(prm.FRETw(state)));
end

% set transition rates
if prm.impPrm && isfield(prm.molPrm, 'kx')
    set([h_ed(:)' h.edit_nbStates], 'Enable', 'off');
    J = size(prm.molPrm.kx,2);
    kx = prm.molPrm.kx(:,:,1);
    if J<Jmax
        kx = zeros(Jmax);
        kx(1:J,1:J) = prm.molPrm.kx(:,:,1);
    end
    setTransMat(kx(1:Jmax,1:Jmax,1), h_fig);
else
    setTransMat(prm.kx, h_fig);
    for s = 1:size(h_ed,2)
        if s>prm.nbStates
            set(h_ed(s,:), 'Enable', 'off');
            set(h_ed(:,s), 'Enable', 'off');
        else
            set(h_ed(s,s), 'Enable', 'off', 'String', '0');
        end

    end
end

% set total intensity
if strcmp(prm.intUnits, 'electron')
    set(h.checkbox_photon, 'Value', 0);
    [offset,K,eta] = getCamParam(prm.noiseType,prm.camNoise);
else
    set(h.checkbox_photon, 'Value', 1);
end
if prm.impPrm && isfield(prm.molPrm, 'totInt')
    if strcmp(prm.intUnits, 'electron')
        prm.molPrm.totInt = phtn2ele(prm.molPrm.totInt(1,1),K,eta);
        prm.molPrm.totInt_width = phtn2ele(prm.molPrm.totInt_width(1,1),K,eta);
    end
    set([h.edit_totInt h.edit_dstrbNoise],'Enable','off');
    set(h.edit_totInt, 'String', num2str(prm.molPrm.totInt(1,1)));
    set(h.edit_dstrbNoise, 'String', num2str(prm.molPrm.totInt_width(1,1)));
else
    if strcmp(prm.intUnits, 'electron')
        prm.totInt = phtn2ele(prm.totInt,K,eta);
        prm.totInt_width = phtn2ele(prm.totInt_width,K,eta);
    end
    set(h.edit_totInt, 'String', num2str(prm.totInt));
    set(h.edit_dstrbNoise, 'String', num2str(prm.totInt_width));
end

% set gamma factor
if prm.impPrm && isfield(prm.molPrm, 'gamma')
    set([h.edit_gamma h.edit_gammaW], 'Enable', 'off');
    set(h.edit_gamma, 'String', num2str(prm.molPrm.gamma(1,1)));
    set(h.edit_gammaW, 'String', num2str(prm.molPrm.gammaW(1,1)));
else
    set(h.edit_gamma, 'String', num2str(prm.gamma));
    set(h.edit_gammaW, 'String', num2str(prm.gammaW));
end

% set cross-talk coefficients
set(h.edit_simDeD, 'String', num2str(prm.deD));
set(h.edit_simDeA, 'String', num2str(prm.deA));
set(h.edit_simBtD, 'String', num2str(prm.btD));
set(h.edit_simBtA, 'String', num2str(prm.btA));

% set bleaching parameters
set(h.checkbox_simBleach, 'Value', prm.bleach);
if prm.bleach
    set(h.edit_simBleach, 'String', num2str(prm.bleach_t));
else
    set(h.edit_simBleach, 'Enable', 'off', 'String', '');
end

