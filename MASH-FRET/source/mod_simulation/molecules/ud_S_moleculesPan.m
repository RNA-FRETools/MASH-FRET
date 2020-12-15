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
p = h.param.sim;

% set all controls on-enabled
setProp(h.uipanel_S_molecules,'enable','on');

h_ed = [h.edit11 h.edit21 h.edit31 h.edit41 h.edit51 
    h.edit12 h.edit22 h.edit32 h.edit42 h.edit52
    h.edit13 h.edit23 h.edit33 h.edit43 h.edit53
    h.edit14 h.edit24 h.edit34 h.edit44 h.edit54
    h.edit15 h.edit25 h.edit35 h.edit45 h.edit55];

% reset background color of edit fields
set([h.edit_nbMol h.edit_nbStates h.edit_stateVal h.edit_simFRETw h_ed(:)' ...
    h.edit_totInt h.edit_dstrbNoise h.edit_gamma h.edit_gammaW ...
    h.edit_simDeD h.edit_simDeA h.edit_simBtD h.edit_simBtA ...
    h.edit_simBleach], 'BackgroundColor', [1 1 1]);

% set sample size
set(h.edit_nbMol, 'String', num2str(p.molNb));

% set presets import
if ~p.impPrm
    set([h.pushbutton_simRemPrm h.edit_simPrmFile], 'Enable', 'off');
    set(h.edit_simPrmFile, 'String', '');
else
    set(h.edit_nbMol, 'Enable', 'off');
    
    [o,fname,fext] = fileparts(p.prmFile);
    set(h.edit_simPrmFile, 'String', [fname,fext]);
end
if p.impPrm && isfield(p.molPrm, 'coord') && ~isempty(p.molPrm.coord)
    set(h.pushbutton_simImpCoord, 'Enable', 'off');
end

% set coordinates import
if isempty(p.coordFile)
    set([h.pushbutton_simRemCoord h.edit_simCoordFile], 'Enable', 'off');
    set(h.edit_simCoordFile, 'String', '');
else
    set(h.edit_nbMol, 'Enable', 'off');
    
    [o,fname,fext] = fileparts(p.coordFile);
    set(h.edit_simCoordFile, 'String', [fname fext]);
end

% set state configuration
set(h.edit_nbStates, 'String', num2str(p.nbStates));
state = get(h.popupmenu_states, 'Value');
if state > p.nbStates
    state = p.nbStates;
end
set(h.popupmenu_states, 'Value', state, 'String', ...
    cellstr(num2str((1:p.nbStates)'))');
if p.impPrm && isfield(p.molPrm, 'stateVal')
    set([h.edit_nbStates h.popupmenu_states h.edit_stateVal ...
        h.edit_simFRETw], 'Enable', 'off');
    set(h.edit_stateVal, 'String', num2str(p.molPrm.stateVal(1,state)));
    set(h.edit_simFRETw, 'String', num2str(p.molPrm.FRETw(1,state)));
else
    set(h.edit_stateVal, 'String', num2str(p.stateVal(state)));
    set(h.edit_simFRETw, 'String', num2str(p.FRETw(state)));
end

% set transition rates
if p.impPrm && isfield(p.molPrm, 'kx')
    set([h_ed(:)' h.edit_nbStates], 'Enable', 'off');
    J = size(p.molPrm.kx,2);
    kx = p.molPrm.kx(:,:,1);
    if J<Jmax
        kx = zeros(Jmax);
        kx(1:J,1:J) = p.molPrm.kx(:,:,1);
    end
    setTransMat(kx(1:Jmax,1:Jmax,1), h_fig);
else
    setTransMat(p.kx, h_fig);
    for s = 1:size(h_ed,2)
        if s>p.nbStates
            set(h_ed(s,:), 'Enable', 'off');
            set(h_ed(:,s), 'Enable', 'off');
        else
            set(h_ed(s,s), 'Enable', 'off', 'String', '0');
        end

    end
end

% set total intensity
if strcmp(p.intUnits, 'electron')
    set(h.checkbox_photon, 'Value', 0);
    [offset,K,eta] = getCamParam(p.noiseType,p.camNoise);
else
    set(h.checkbox_photon, 'Value', 1);
end
if p.impPrm && isfield(p.molPrm, 'totInt')
    if strcmp(p.intUnits, 'electron')
        p.molPrm.totInt = phtn2ele(p.molPrm.totInt(1,1),K,eta);
        p.molPrm.totInt_width = phtn2ele(p.molPrm.totInt_width(1,1),K,eta);
    end
    set([h.edit_totInt h.edit_dstrbNoise],'Enable','off');
    set(h.edit_totInt, 'String', num2str(p.molPrm.totInt(1,1)));
    set(h.edit_dstrbNoise, 'String', num2str(p.molPrm.totInt_width(1,1)));
else
    if strcmp(p.intUnits, 'electron')
        p.totInt = phtn2ele(p.totInt,K,eta);
        p.totInt_width = phtn2ele(p.totInt_width,K,eta);
    end
    set(h.edit_totInt, 'String', num2str(p.totInt));
    set(h.edit_dstrbNoise, 'String', num2str(p.totInt_width));
end

% set gamma factor
if p.impPrm && isfield(p.molPrm, 'gamma')
    set([h.edit_gamma h.edit_gammaW], 'Enable', 'off');
    set(h.edit_gamma, 'String', num2str(p.molPrm.gamma(1,1)));
    set(h.edit_gammaW, 'String', num2str(p.molPrm.gammaW(1,1)));
else
    set(h.edit_gamma, 'String', num2str(p.gamma));
    set(h.edit_gammaW, 'String', num2str(p.gammaW));
end

% set cross-talk coefficients
set(h.edit_simDeD, 'String', num2str(p.deD));
set(h.edit_simDeA, 'String', num2str(p.deA));
set(h.edit_simBtD, 'String', num2str(p.btD));
set(h.edit_simBtA, 'String', num2str(p.btA));

% set bleaching parameters
set(h.checkbox_simBleach, 'Value', p.bleach);
if p.bleach
    set(h.edit_simBleach, 'String', num2str(p.bleach_t));
else
    set(h.edit_simBleach, 'Enable', 'off', 'String', '');
end

