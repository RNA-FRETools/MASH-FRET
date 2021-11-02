function ud_S_moleculesPan(h_fig)
% ud_S_moleculesPan(h_fig)
%
% Set panel Molecules to proper values
%
% h_fig: handle to main figure

% defaults
Jmax = 5; % maximum number of states allowed by interface
ttstr0 = '<b>Total intensity</b> (in %s): pure donor fluorescence intensity collected in absence of acceptor.';
ttstr1 = '<b>Total intensity sample heterogeneity</b> (in %s): standard deviation of the Itot,em Gaussian distribution.';
ttstr2 = '<b>Photobleaching time constant</b> (in %s): characterizes the distribution of photobleaching times.';

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_S_molecules,h)
    return
end

% collect simulation parameters
proj = p.curr_proj;
inSec = p.proj{proj}.time_in_sec;
perSec = p.proj{proj}.cnt_p_sec;
curr = p.proj{proj}.sim.curr;

N = curr.gen_dt{1}(1);
J = curr.gen_dt{1}(3);
rate = curr.gen_dt{1}(4);
isblch = curr.gen_dt{1}(5);
blchcst = curr.gen_dt{1}(6);
kx = curr.gen_dt{2}(:,:,1);
isPresets = curr.gen_dt{3}{1};
presets = curr.gen_dt{3}{2};
presetsFile = curr.gen_dt{3}{3};
coordFile = curr.gen_dat{1}{1}{3};
noiseType = curr.gen_dat{1}{2}{4};
noisePrm = curr.gen_dat{1}{2}{5};
FRETval = curr.gen_dat{2};
Itot = curr.gen_dat{3}{1};
inun = curr.gen_dat{3}{2};
gamma = curr.gen_dat{4};
crstlk = curr.gen_dat{5};

% convert time units
if inSec
    blchcst = blchcst/rate;
    str_tun = 'seconds';
else
    str_tun = 'frames';
end
if perSec
    str_iun = [inun,' counts per second'];
else
    str_iun = [inun,' counts'];
end

% convert intensity units

h_ed = [h.edit11 h.edit21 h.edit31 h.edit41 h.edit51 
    h.edit12 h.edit22 h.edit32 h.edit42 h.edit52
    h.edit13 h.edit23 h.edit33 h.edit43 h.edit53
    h.edit14 h.edit24 h.edit34 h.edit44 h.edit54
    h.edit15 h.edit25 h.edit35 h.edit45 h.edit55];

% set sample size
set(h.edit_nbMol,'string',num2str(N));

% set presets import
if ~isPresets
    set(h.checkbox_simPrmFile,'value',0);
    set(h.edit_simPrmFile,'enable','off','string','');
else
    set(h.checkbox_simPrmFile,'value',1);
    set(h.edit_nbMol,'enable','off');
    
    [o,fname,fext] = fileparts(presetsFile);
    set(h.edit_simPrmFile,'string',[fname,fext]);
end

% set coordinates import
if isPresets && isfield(presets,'coord') && ~isempty(presets.coord)
    set(h.pushbutton_simImpCoord,'enable','off');
    set([h.radiobutton_simCoordFile,h.radiobutton_randCoord],'value',0,...
        'enable','off');
    set(h.edit_simCoordFile,'enable','off','string','');
    
elseif isempty(coordFile)
    set(h.radiobutton_simCoordFile,'value',0);
    set(h.radiobutton_randCoord,'value',1);
    set(h.edit_simCoordFile,'enable','off','string','');
    
else
    set(h.radiobutton_simCoordFile,'value',1);
    set(h.radiobutton_randCoord,'value',0);
    set(h.edit_nbMol,'enable','off');

    [o,fname,fext] = fileparts(coordFile);
    set(h.edit_simCoordFile,'string',[fname fext]);
end

% set state configuration
set(h.edit_nbStates,'string',num2str(J));
state = get(h.popupmenu_states,'value');
if state > J
    state = J;
end
set(h.popupmenu_states,'value',state,'string',cellstr(num2str((1:J)'))');
if isPresets && isfield(presets,'stateVal')
    set([h.edit_nbStates h.popupmenu_states h.edit_stateVal ...
        h.edit_simFRETw],'enable','off');
    set(h.edit_stateVal,'string',num2str(presets.stateVal(1,state)));
    set(h.edit_simFRETw,'string',num2str(presets.FRETw(1,state)));
else
    set(h.edit_stateVal,'string',num2str(FRETval(1,state)));
    set(h.edit_simFRETw,'string',num2str(FRETval(2,state)));
end

% set transition rates
if isPresets && isfield(presets,'kx')
    set([h_ed(:)' h.edit_nbStates],'enable','off');
    J = size(presets.kx,2);
    kx = presets.kx(:,:,1);
    if J<Jmax
        kx = zeros(Jmax);
        kx(1:J,1:J) = presets.kx(:,:,1);
    end
    setTransMat(kx(1:Jmax,1:Jmax,1),h_fig);
else
    setTransMat(kx(1:Jmax,1:Jmax),h_fig);
    for s = 1:size(h_ed,2)
        if s>J
            set(h_ed(s,:),'enable','off');
            set(h_ed(:,s),'enable','off');
        else
            set(h_ed(s,s),'enable','off','string','0');
        end

    end
end

% set total intensity
if strcmp(inun,'electron')
    set(h.checkbox_photon,'value',0);
    [~,K,eta] = getCamParam(noiseType,noisePrm);
else
    set(h.checkbox_photon,'value',1);
end
if isPresets && isfield(presets,'totInt')
    if strcmp(inun,'electron')
        presets.totInt = phtn2ele(presets.totInt(1,1),K,eta);
        presets.totInt_width = phtn2ele(presets.totInt_width(1,1),K,eta);
    end
    if perSec
        presets.totInt = presets.totInt*rate;
        presets.totInt_width = presets.totInt_width*rate;
    end
    set([h.edit_totInt h.edit_dstrbNoise],'enable','off');
    set(h.edit_totInt,'string',num2str(presets.totInt(1,1)));
    set(h.edit_dstrbNoise,'string',num2str(presets.totInt_width(1,1)));
else
    if strcmp(inun,'electron')
        Itot = phtn2ele(Itot,K,eta);
    end
    if perSec
        Itot = Itot*rate;
    end
    set(h.edit_totInt,'string',num2str(Itot(1)));
    set(h.edit_dstrbNoise,'string',num2str(Itot(2)));
end
set(h.edit_totInt,'tooltipstring',wrapHtmlTooltipString(...
    sprintf(ttstr0,str_iun)));
set(h.edit_dstrbNoise,'tooltipstring',wrapHtmlTooltipString(...
    sprintf(ttstr1,str_iun)));

% set gamma factor
if isPresets && isfield(presets,'gamma')
    set([h.edit_gamma h.edit_gammaW],'enable','off');
    set(h.edit_gamma,'string',num2str(presets.gamma(1,1)));
    set(h.edit_gammaW,'string',num2str(presets.gammaW(1,1)));
else
    set(h.edit_gamma,'string',num2str(gamma(1)));
    set(h.edit_gammaW,'string',num2str(gamma(2)));
end

% set cross-talk coefficients
set(h.edit_simDeD,'string',num2str(crstlk(2,1)));
set(h.edit_simDeA,'string',num2str(crstlk(2,2)));
set(h.edit_simBtD,'string',num2str(crstlk(1,1)));
set(h.edit_simBtA,'string',num2str(crstlk(1,2)));

% set bleaching parameters
set(h.checkbox_simBleach,'value',isblch);
if isblch
    set(h.edit_simBleach,'string',num2str(blchcst),'tooltipstring',...
        wrapHtmlTooltipString(sprintf(ttstr2,str_tun)));
else
    set(h.edit_simBleach,'enable','off','string','');
end

