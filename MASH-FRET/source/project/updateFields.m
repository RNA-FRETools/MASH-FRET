function updateFields(h_fig, varargin)

% Update all uicontrol properties of MASH
% input argument 1: MASh figure handle
% input argument 2: what to update ('all', 'sim', 'imgAxes', 'movPr',
% 'ttPr', 'thm', TDP'
%
% Requires external files: 
%
% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic
% Last update: 7th of March 2018 by Richard Börner
%
% Comments adapted for Boerner et al, PONE, 2017.

if ~isempty(varargin)
    opt = varargin{1};
else
    opt = 'all';
end

h = guidata(h_fig);

h_pan = guidata(h.figure_actPan);
set(h_pan.text_actions, 'BackgroundColor', [1 1 1]);

%% Simulation fields

if strcmp(opt, 'sim') || strcmp(opt, 'all')
    p = h.param.sim;
    
    set([h.edit_nbStates h.edit_nbMol h.edit_length h.edit_simRate ...
        h.edit_totInt h.edit_dstrbNoise h.edit_gamma h.edit_gammaW ...
        h.edit_bgInt_don h.edit_bgInt_acc h.edit_simMov_w ...
        h.edit_simMov_h h.edit_pixDim h.edit_simBitPix h.edit_TIRFx ...
        h.edit_TIRFy h.edit_bgExp_cst h.edit_simAmpBG h.edit_psfW1 ...
        h.edit_psfW2 h.edit_stateVal h.edit_simFRETw h.edit_camNoise_01 ...
        h.edit_camNoise_02 h.edit_camNoise_03 h.edit_camNoise_04 ...
        h.edit_camNoise_05 h.edit_camNoise_06 h.edit_simBtD ...
        h.edit_simBtA h.edit_simDeD h.edit_simDeA], ...
        'BackgroundColor', [1 1 1]);
    
    set(h.edit_nbStates, 'String', num2str(p.nbStates));
    set(h.edit_nbMol, 'String', num2str(p.molNb));
    if ~(p.impPrm && isfield(p.molPrm, 'kx'))
        setTransMat(p.kx, h_fig);
    end
    transMat_h = [h.edit11 h.edit21 h.edit31 h.edit41 h.edit51
                  h.edit12 h.edit22 h.edit32 h.edit42 h.edit52
                  h.edit13 h.edit23 h.edit33 h.edit43 h.edit53
                  h.edit14 h.edit24 h.edit34 h.edit44 h.edit54
                  h.edit15 h.edit25 h.edit35 h.edit45 h.edit55];
    set(transMat_h, 'Enable', 'off', 'BackgroundColor', [1 1 1]);
    J = min([p.nbStates 5]);
    set(transMat_h(1:J,1:J), 'Enable', 'on');
    str = {};
    for s = 1:p.nbStates
        if s <= J
            set(transMat_h(s,s), 'Enable', 'off', 'String', '0');
        end
        str = [str, ['state ' num2str(s)]];
    end
    set(h.edit_length, 'String', num2str(p.nbFrames));
    set(h.edit_simRate, 'String', num2str(p.rate));
    set(h.checkbox_simBleach, 'Value', p.bleach);
    if p.bleach
        set(h.edit_simBleach, 'Enable', 'on', 'String', ...
            num2str(p.bleach_t));
    else
        set(h.edit_simBleach, 'Enable', 'off', 'String', '');
    end
    
    if strcmp(p.intUnits, 'electron')
        [offset,K,eta] = getCamParam(p.noiseType,p.camNoise);
        set(h.checkbox_photon, 'Value', 0);
        p.totInt = phtn2ele(p.totInt,K,eta);
        p.totInt_width = phtn2ele(p.totInt_width,K,eta);
        p.bgInt_don = phtn2ele(p.bgInt_don,K,eta);
        p.bgInt_acc = phtn2ele(p.bgInt_acc,K,eta);
    else
        set(h.checkbox_photon, 'Value', 1);
    end
    
    state = get(h.popupmenu_states, 'Value');
    if state > p.nbStates
        state = p.nbStates;
    end
    set(h.popupmenu_states, 'Value', state, 'String', str);
    set(h.edit_stateVal, 'String', num2str(p.stateVal(state)));
    set(h.edit_simFRETw, 'String', num2str(p.FRETw(state)));
    set(h.text_simGval, 'String', char(hex2dec('3B3')));
    set(h.text_simGdelta, 'String', cat(2,'w',char(hex2dec('3B3'))));
    set(h.edit_gamma, 'String', num2str(p.gamma));
    set(h.edit_gammaW, 'String', num2str(p.gammaW));
    set(h.edit_totInt, 'String', num2str(p.totInt));
    set(h.edit_dstrbNoise, 'String', num2str(p.totInt_width));
    
    if p.impPrm
        set(h.edit_nbMol, 'Enable', 'off');
        set([h.pushbutton_simRemPrm h.edit_simPrmFile], 'Enable', 'on');
        [o,fname_prm,f_ext] = fileparts(p.prmFile);
        
        if isfield(p.molPrm, 'stateVal')
            set([h.edit_nbStates h.popupmenu_states h.edit_stateVal ...
                h.edit_simFRETw], 'Enable', 'off');
        else
            set([h.edit_nbStates h.popupmenu_states h.edit_stateVal ...
                h.edit_simFRETw], 'Enable', 'on');
        end
        
        if isfield(p.molPrm, 'kx')
            set([reshape(transMat_h,[1 numel(transMat_h)]) ...
                h.edit_nbStates], 'Enable', 'off');
        else
            set(reshape(transMat_h,[1 numel(transMat_h)]),'Enable','on');
        end
        
        if isfield(p.molPrm, 'gamma')
            set([h.edit_gamma h.edit_gammaW], 'Enable', 'off');
        else
            set([h.edit_gamma h.edit_gammaW], 'Enable', 'on');
        end
        
        if isfield(p.molPrm, 'totInt')
            set([h.edit_totInt h.edit_dstrbNoise], 'Enable', 'off');
        else
            set([h.edit_totInt h.edit_dstrbNoise], 'Enable', 'on');
        end
        
        if isfield(p.molPrm, 'coord')
            set(h.pushbutton_simImpCoord, 'Enable', 'off');
        else
            set(h.pushbutton_simImpCoord, 'Enable', 'on');
        end
        
        if isfield(p.molPrm, 'psf_width')
            set([h.text_simPSFw1 h.text_simPSFw2 h.edit_psfW1 ...
                h.edit_psfW2 h.checkbox_convPSF], 'Enable', 'off');
        elseif p.PSF
            set([h.text_simPSFw1 h.text_simPSFw2 h.edit_psfW1 ...
                h.edit_psfW2 h.checkbox_convPSF], 'Enable', 'on');
        else
            set(h.checkbox_convPSF, 'Enable', 'on');
             set([h.text_simPSFw1 h.text_simPSFw2 h.edit_psfW1 ...
                 h.edit_psfW2], 'Enable', 'off');
        end
        
    else
        if p.PSF
            set([h.text_simPSFw1 h.edit_psfW1 h.text_simPSFw2 ...
                h.edit_psfW2 h.checkbox_convPSF], 'Enable', 'on');
            set(h.edit_psfW1, 'String', num2str(p.PSFw(1,1)));
            set(h.edit_psfW2, 'String', num2str(p.PSFw(1,2)));
        else
            set([h.text_simPSFw1 h.edit_psfW1 h.text_simPSFw2 ...
                h.edit_psfW2], 'Enable', 'off');
            set([h.edit_psfW1 h.edit_psfW2], 'String', '');
            set(h.checkbox_convPSF, 'Enable','on');
        end
        
        set(h.edit_nbMol, 'Enable', 'on');
        set([h.pushbutton_simRemPrm h.edit_simPrmFile], 'Enable', 'off');
        fname_prm = '';
        f_ext = '';
        
        set([h.edit_nbStates h.popupmenu_states h.edit_stateVal ...
            h.edit_simFRETw h.edit_gamma h.edit_gammaW h.edit_totInt ...
            h.edit_dstrbNoise], 'Enable', 'on');
    end
    set(h.edit_simPrmFile, 'String', [fname_prm f_ext]);
    
    if isempty(p.coordFile)
        set([h.pushbutton_simRemCoord h.edit_simCoordFile], 'Enable', ...
            'off');
        fname_coord = '';
        f_ext = '';
    else
        set([h.pushbutton_simRemCoord h.edit_simCoordFile], 'Enable', ...
            'on');
        set(h.edit_nbMol, 'Enable', 'off');
        [o,fname_coord,f_ext] = fileparts(p.coordFile);
    end
    set(h.edit_simCoordFile, 'String', [fname_coord f_ext]);
    set(h.edit_simMov_w, 'String', num2str(p.movDim(1)));
    set(h.edit_simMov_h, 'String', num2str(p.movDim(2)));
    set(h.edit_pixDim, 'String', num2str(p.pixDim));
    set(h.checkbox_convPSF, 'Value', p.PSF);
    set(h.edit_simBitPix,'String', num2str(p.bitnr));
    
    set(h.edit_simBtD, 'String', num2str(p.btD));
    set(h.edit_simBtA, 'String', num2str(p.btA));
    set(h.edit_simDeD, 'String', num2str(p.deD));
    set(h.edit_simDeA, 'String', num2str(p.deA));

    set(h.popupmenu_simBg_type, 'Value', p.bgType);
    set(h.edit_bgInt_don, 'String', num2str(p.bgInt_don));
    set(h.edit_bgInt_acc, 'String', num2str(p.bgInt_acc));
    if p.bgType == 2
        set([h.edit_TIRFx h.edit_TIRFy h.text_simWTIRF], ...
            'Enable', 'on');
        set(h.edit_TIRFx, 'String', num2str(p.TIRFdim(1)));
        set(h.edit_TIRFy, 'String', num2str(p.TIRFdim(2)));
    else
        set([h.edit_TIRFx h.edit_TIRFy h.text_simWTIRF], ...
            'Enable', 'off');
        set([h.edit_TIRFx h.edit_TIRFy], 'String', '');
    end
    set(h.checkbox_bgExp, 'Value', p.bgDec);
    if p.bgDec
        set(h.edit_bgExp_cst, 'String', num2str(p.cstDec), 'Enable', 'on');
        set(h.edit_simAmpBG, 'String', num2str(p.ampDec), 'Enable', 'on');
    else
        set([h.edit_bgExp_cst h.edit_simAmpBG], 'Enable', 'off', ...
            'String', '');
    end
    
    if 1
        set(h.edit_simzdec, 'String', num2str(p.zDec), 'Enable', 'on');
        set(h.edit_simz0_A, 'String', num2str(p.z0Dec), 'Enable', 'on');
    else
        set([h.edit_simz h.edit_simz0], 'Enable', 'off', ...
            'String', '');
    end
    
    % camera noise
%     camNoise = [113  0.95       0  0 0     0      %  my.d /   /    /   /    /      % default P- or Poisson Model
%             57.7 0.067 113  0 0     0.95   %  K    s_d my.d s_q mr.s eta    % default N- or Gaussian Model
%             979  0.143  54 16 0.402 0      %  I_0  A   tau  sig c    a      % default NexpN or Exp.-CIC Model
%             113  0       0  0 0     0      %  my.d /   /    /   /    /      % default no noise but camera offset
%             300  0.067 113  0 5.199 0.95 ];%  g    s_d my.d CIC s    eta 
    
    switch p.noiseType
        case 'poiss' % Poisson or P-model from Börner et al. 2017
            ind = 1;
            set(h.popupmenu_noiseType, 'Value', ind);
            
            set([h.text_camNoise_01 h.edit_camNoise_01  ...
                h.text_camNoise_03 h.edit_camNoise_03], 'Enable', 'on');
            
            set([h.text_camNoise_02 h.edit_camNoise_02 ...
                h.text_camNoise_05 h.edit_camNoise_05 ...
                h.text_camNoise_04 h.edit_camNoise_04 ...
                h.text_camNoise_06 h.edit_camNoise_06], 'Enable', 'off');
            
            set(h.text_camNoise_01, 'Style', 'text', 'String', ...
                [char(hex2dec('3BC')),'_ic,dark:']); % dark counts or offset in ic
            set(h.text_camNoise_03, 'Style', 'text', 'String', ...
                [char(hex2dec('3B7')),':']); % total detection efficiency
            set(h.text_camNoise_05, 'String', 'K:'); % overall gain
           
            set([h.text_camNoise_02 h.edit_camNoise_02 ...
                h.text_camNoise_04 h.edit_camNoise_04 ...
                h.text_camNoise_06 h.edit_camNoise_06], 'String', '');
               
            set(h.edit_camNoise_01,'String',num2str(p.camNoise(ind,1)), ...
                'TooltipString','Dark counts or camera offset (ic)');
            set(h.edit_camNoise_03,'String',num2str(p.camNoise(ind,3)), ...
                'TooltipString','Total Detection Efficiency (ec/pc)');
            set(h.edit_camNoise_05,'String',num2str(1),'TooltipString',...
                'Overall system gain (ic/ec)');
            
        case 'norm' % Gaussian, Normal or N-model from Börner et al. 2017
            ind = 2;
            set(h.popupmenu_noiseType, 'Value', ind);
            
            set([h.text_camNoise_01 h.edit_camNoise_01 ...
                h.text_camNoise_02 h.edit_camNoise_02 ...
                h.text_camNoise_03 h.edit_camNoise_03 ...
                h.text_camNoise_04 h.edit_camNoise_04 ...
                h.text_camNoise_05 h.edit_camNoise_05 ...
                h.text_camNoise_06], 'Enable', 'on');
            
            set(h.edit_camNoise_06, 'Enable', 'inactive');
            
            [o, mu_rho_stat] = Saturation(p.bitnr);
            
            set(h.text_camNoise_01, 'String', [char(hex2dec('3BC')),'_ic,dark:']); % Dark counts or offset
            set(h.text_camNoise_02, 'String', [char(hex2dec('3C3')),'_d:']); % Read-out noise width
            set(h.text_camNoise_03, 'String', [char(hex2dec('3B7')),':']); % total detection efficiency
            set(h.text_camNoise_04, 'String', [char(hex2dec('3C3')),'_q:']); % Analog-to-digital noise width
            set(h.text_camNoise_05, 'String', 'K:'); % Overall system gain
            set(h.text_camNoise_06, 'String', 'sat:');

            set(h.edit_camNoise_01, 'String',num2str(p.camNoise(ind,1)),...
                'TooltipString',...
                'Dark counts or camera offset (ic)'); % mu_y.dark
            set(h.edit_camNoise_02, 'String', ...
                num2str(p.camNoise(ind,2)), 'TooltipString', ...
                'Standard deviation of the read-out noise (pc)'); % s_d
             set(h.edit_camNoise_03, 'String', num2str(p.camNoise(ind,3)), ...
                'TooltipString', 'Total Quantum Efficiency (ec/pc)'); % eta
            set(h.edit_camNoise_04, 'String',num2str(p.camNoise(ind,4)), ...
                'TooltipString',['Standard deviaton of the analog-to-',...
                'digital conversion noise (ec)']); % s_q
            set(h.edit_camNoise_05, 'String', num2str(p.camNoise(ind,5)), ...
                'TooltipString', 'Overall system gain (ic/ec)'); % K
            set(h.edit_camNoise_06, 'String', num2str(mu_rho_stat),...
                'TooltipString', ...
                '<html><i>(read only)</i> Pixel saturation (ic)</html>'); % mu_r.stat

        case 'user' % User defined or NExpN-model from Börner et al. 2017
            ind = 3;
            set(h.popupmenu_noiseType, 'Value', ind);
            
            set([h.text_camNoise_01 h.edit_camNoise_01 ...
                h.text_camNoise_02 h.edit_camNoise_02 ...
                h.text_camNoise_03 h.edit_camNoise_03 ...
                h.text_camNoise_04 h.edit_camNoise_04 ...
                h.text_camNoise_05 h.edit_camNoise_05 ...
                h.text_camNoise_06 h.edit_camNoise_06],'Enable','on');
            
            set(h.text_camNoise_01, 'String', [char(hex2dec('3BC')),'_ic,dark:']); % Dark counts or offset
            set(h.text_camNoise_02, 'String', 'A_CIC:'); % CIC contribution
            set(h.text_camNoise_03, 'String', [char(hex2dec('3B7')),':']); % total detection efficiency
            set(h.text_camNoise_04, 'String', [char(hex2dec('3C3')),'_ic:']); % noise width
            set(h.text_camNoise_05, 'String', 'K:'); % Overall system gain
            set(h.text_camNoise_06, 'String', [char(hex2dec('3C4')),'_CIC:']); % CIC decay constant

            set(h.edit_camNoise_01, 'String', num2str(p.camNoise(ind,1)), ...
                'TooltipString', 'Dark counts or camera offset (ic)'); % Dark count or offset
            set(h.edit_camNoise_02, 'String', num2str(p.camNoise(ind,2)), ...
                'TooltipString', 'Exponential tail contribution'); % A_CIC
            set(h.edit_camNoise_03, 'String', num2str(p.camNoise(ind,3)), ...
                'TooltipString', 'Total Quantum Efficiency (ec/pc)'); % eta
            set(h.edit_camNoise_04, 'String', num2str(p.camNoise(ind,4)), ...
                'TooltipString',['Standard deviation of the Gaussian ',...
                'camera noise (ic)']);
            set(h.edit_camNoise_05, 'String', num2str(p.camNoise(ind,5)), ...
                'TooltipString', 'Overall system gain (ic/ec)'); % K
            set(h.edit_camNoise_06, 'String', num2str(p.camNoise(ind,6)), ...
                'TooltipString', 'Exponential tail decay constant (ic)'); % tau_CIC
     
        case 'none' 
            ind = 4;
            set(h.popupmenu_noiseType, 'Value', ind);
            
            set([h.text_camNoise_02 h.edit_camNoise_02 ...
                h.text_camNoise_03 h.edit_camNoise_03 ...
                h.text_camNoise_04 h.edit_camNoise_04 ...
                h.text_camNoise_05 h.edit_camNoise_05  ...
                h.text_camNoise_06 h.edit_camNoise_06], 'Enable', 'off');
            
            set([h.text_camNoise_02 h.edit_camNoise_02 ...
                h.text_camNoise_04 h.edit_camNoise_04 ...
                h.text_camNoise_06 h.edit_camNoise_06], 'String', '');
            
            set([h.text_camNoise_01 h.edit_camNoise_01], 'Enable', 'on');
            
            set(h.text_camNoise_01, 'String', [char(hex2dec('3BC')),'_ic,dark']);
            set(h.text_camNoise_03, 'String', [char(hex2dec('3B7')),':']); % total detection efficiency
            set(h.text_camNoise_05, 'String', 'K:'); % Overall system gain

            set(h.edit_camNoise_01, 'String', num2str(p.camNoise(ind,1)), ...
                'TooltipString', 'Dark counts or camera offset (ic)');
            set(h.edit_camNoise_03, 'String', num2str(1));
            set(h.edit_camNoise_05, 'String', num2str(1));
            
        case 'hirsch'
            ind = 5;
            set(h.popupmenu_noiseType, 'Value', ind);
            
            set([h.text_camNoise_01 h.edit_camNoise_01 ...
                h.text_camNoise_02 h.edit_camNoise_02 ...
                h.text_camNoise_03 h.edit_camNoise_03 ...
                h.text_camNoise_04 h.edit_camNoise_04 ...
                h.text_camNoise_05 h.edit_camNoise_05 ...
                h.text_camNoise_06 h.edit_camNoise_06], 'Enable', 'on');

            set(h.text_camNoise_01, 'String', [char(hex2dec('3BC')),'_ic,dark']); % Dark count or camera offset
            set(h.text_camNoise_02, 'String', [char(hex2dec('3C3')),'_d:']); % read-out noise width
            set(h.text_camNoise_03, 'String', [char(hex2dec('3B7')),':']); % total detection efficiency
            set(h.text_camNoise_04, 'String', 'CIC:'); % CIC contribution
            set(h.text_camNoise_05, 'String', 'g:'); % camera amplification gain
            set(h.text_camNoise_06, 'String', 's:'); % amplifier sensitivity

            set(h.edit_camNoise_01, 'String', num2str(p.camNoise(ind,1)), ...
                'TooltipString', 'Dark counts or camera offset (ic)'); % mu_y.dark
            set(h.edit_camNoise_02, 'String', num2str(p.camNoise(ind,2)), ...
                'TooltipString', ['Noise standard deviation of the read-',...
                'out noise (ec)']); % s_d
            set(h.edit_camNoise_03, 'String', num2str(p.camNoise(ind,3)), ...
                'TooltipString', 'Total detection efficiency (ec/pc)'); % eta
            set(h.edit_camNoise_04, 'String', num2str(p.camNoise(ind,4)), ...
                'TooltipString', 'CIC contribution (ec)'); % CIC
            set(h.edit_camNoise_05, 'String',num2str(p.camNoise(ind,5)), ...
                'TooltipString', 'Amplification gain'); % g
            set(h.edit_camNoise_06, 'String', num2str(p.camNoise(ind,6)), ...
                'TooltipString', ['Amplifier sensitivity or analog-to-',...
                'digital factor (ec/ic)']); % s
            
    end

    set(h.checkbox_simParam, 'Value', p.export_param);
    set(h.checkbox_traces, 'Value', p.export_traces);
    set(h.checkbox_movie, 'Value', p.export_movie);
    set(h.checkbox_avi, 'Value', p.export_avi);
    set(h.checkbox_procTraces, 'Value', p.export_procTraces);
    set(h.checkbox_dt, 'Value', p.export_dt);
    set(h.checkbox_expCoord, 'Value', p.export_coord);
    
    if strcmp(p.intOpUnits, 'photon')
        set(h.popupmenu_opUnits, 'Value', 1);
    else
        set(h.popupmenu_opUnits, 'Value', 2);
    end

    
end

%% Movie processing fields

if strcmp(opt,'imgAxes') || strcmp(opt, 'movPr') || strcmp(opt, 'all')

    p = h.param.movPr;
    nC = p.nChan;
    labels = p.labels;
    nLaser = p.itg_nLasers;
    
    if isfield(h, 'movie') && isfield(h.movie, 'rate')
        set(h.edit_rate, 'String', num2str(p.rate));
    end
    
    set(h.edit_nChannel, 'String', num2str(p.nChan));
    set(h.popupmenu_colorMap, 'Value', p.cmap);
    set(h.checkbox_int_ps, 'Value', p.perSec);

    for i = 1:nC
        if i > size(p.movBg_p,2)
            for j = 1:size(p.movBg_p,1)
                p.movBg_p{j,i} = p.movBg_p{j,i-1};
            end
        end
        if i > size(h.param.movPr.SF_minI,2)
            p.SF_minI(i) = p.SF_minI(i-1);
            p.SF_intThresh(i) = p.SF_intThresh(i-1);
            p.SF_intRatio(i) = p.SF_intRatio(i-1);
            p.SF_w(i) = p.SF_w(i-1);
            p.SF_h(i) = p.SF_h(i-1);
            p.SF_darkW(i) = p.SF_darkW(i-1);
            p.SF_darkH(i) = p.SF_darkH(i-1);
            p.SF_maxN(i) = p.SF_maxN(i-1);
            p.SF_minHWHM(i) = p.SF_minHWHM(i-1);
            p.SF_maxHWHM(i) = p.SF_maxHWHM(i-1);
            p.SF_maxAssy(i) = p.SF_maxAssy(i-1);
            p.SF_minDspot(i) = p.SF_minDspot(i-1);
            p.SF_minDedge(i) = p.SF_minDedge(i-1);
        end
        if i > size(p.trsf_refImp_rw{1},1)
            p.trsf_refImp_rw{1}(i,1) = ...
                p.trsf_refImp_rw{1}(i-1,1) + ...
                p.trsf_refImp_rw{1}(i-1,2) - 1;
            p.trsf_refImp_rw{1}(i,3) = ...
                p.trsf_refImp_rw{1}(i-1,3);
            p.trsf_refImp_cw{1}(i,1:2) = ...
                p.trsf_refImp_cw{1}(i-1,1:2) + 2;
        end
        if i > size(p.itg_impMolPrm{1},1)
            p.itg_impMolPrm{1}(i,1:2) = ...
                p.itg_impMolPrm{1}(i-1,1:2) + 2;
        end
    end
    h.param.movPr = p;
    guidata(h_fig, h);
    
    set(h.popupmenu_bgChanel, 'String', getStrPop('chan', {labels []}));
    set(h.popupmenu_bgCorr, 'Value', p.movBg_method);
    set(h.checkbox_bgCorrAll, 'Value', ~p.movBg_one);
    
    ud_movBgCorr(h.popupmenu_bgCorr, [], h)
    h = guidata(h_fig);
    p = h.param.movPr;
    
    set(h.edit_startMov, 'String', num2str(p.mov_start)...
        , 'BackgroundColor', [1 1 1]);
    set(h.edit_endMov, 'String', num2str(p.mov_end)...
        , 'BackgroundColor', [1 1 1]);
    
    set(h.edit_aveImg_iv, 'String', num2str(p.ave_iv)...
        , 'BackgroundColor', [1 1 1]);
    set(h.edit_aveImg_start, 'String', num2str(p.ave_start)...
        , 'BackgroundColor', [1 1 1]);
    set(h.edit_aveImg_end, 'String', num2str(p.ave_stop)...
        , 'BackgroundColor', [1 1 1]);
    
    ud_lstBg(h.figure_MASH);

    set(h.edit_refCoord_file, 'String', ...
        p.trsf_coordRef_file, 'BackgroundColor', [1 1 1]);
    set(h.edit_tr_file, 'String', p.trsf_tr_file, ...
        'BackgroundColor', [1 1 1]);
    set(h.edit_coordFile, 'String', p.coordMol_file, ...
        'BackgroundColor', [1 1 1]);
    set(h.edit_itg_coordFile, 'String', p.coordItg_file, ...
        'BackgroundColor', [1 1 1]);
    if isfield(h, 'movie') && isfield(h.movie, 'file')
        set(h.edit_movItg, 'String', h.movie.file);
    end
    set(h.edit_movItg, 'BackgroundColor', [1 1 1]);
    set(h.edit_TTgen_dim, 'String', num2str(p.itg_dim)...
        , 'BackgroundColor', [1 1 1]);
    set(h.edit_intNpix, 'String', num2str(p.itg_n)...
        , 'BackgroundColor', [1 1 1]);
    set(h.checkbox_meanVal, 'Value', p.itg_ave);
    set(h.edit_nLasers, 'String', num2str(nLaser), 'BackgroundColor', ...
        [1 1 1]);

    laser = get(h.popupmenu_TTgen_lasers, 'Value');
    if laser > nLaser
        laser = nLaser;
    end
    set(h.popupmenu_TTgen_lasers, 'Value', laser, 'String', ...
        cellstr(num2str((1:nLaser)')));
    
    set(h.edit_wavelength, 'String', num2str(p.itg_wl(laser)), ...
        'BackgroundColor', [1 1 1]);
    
    if strcmp(opt, 'imgAxes') && isfield(h, 'movie')
        updateImgAxes(h_fig);
        h = guidata(h_fig);
    end
    
    ud_SFpanel(h_fig);

end

%% Traces processing fields

if strcmp(opt, 'ttPr') || strcmp(opt, 'subImg') || strcmp(opt, 'all')
    p = h.param.ttPr;
    
    if ~isempty(p.proj)
        proj = p.curr_proj;
        mol = p.curr_mol(proj);
        
        set(h.edit_currMol, 'String', num2str(mol), 'BackgroundColor', ...
            [1 1 1]);
        set(h.listbox_molNb, 'Value', mol);
        set(h.listbox_traceSet, 'Max', 2, 'Min', 0);

        axes.axes_traceTop = h.axes_top;
        axes.axes_histTop = h.axes_topRight;
        axes.axes_traceBottom = h.axes_bottom;
        axes.axes_histBottom = h.axes_bottomRight;
        if p.proj{proj}.is_movie && p.proj{proj}.is_coord
            axes.axes_molImg = h.axes_subImg;
        end
        
        p = updateTraces(h_fig, opt, mol, p, axes);
        
        h.param.ttPr = p;
        guidata(h_fig, h);

        % update parameters
        ud_trSetTbl(h_fig);
        ud_subImg(h_fig);
        ud_denoising(h_fig);
        ud_bleach(h_fig);
        ud_ttBg(h_fig);
        ud_DTA(h_fig);
        ud_cross(h_fig);
        ud_plot(h_fig);
        
        h = guidata(h_fig);
        
    else
        ud_TTprojPrm(h_fig);
        h = guidata(h_fig);
    end
end

%% Thermodynamics fields

if strcmp(opt, 'thm') || strcmp(opt, 'all')
    p = h.param.thm;
    set(h.edit_thmContPan, 'Enable', 'inactive');
    if ~isempty(p.proj)
        set([h.listbox_thm_projLst h.pushbutton_thm_rmProj ...
            h.pushbutton_thm_saveProj h.pushbutton_thm_export], ...
            'Enable', 'on');
        set([h.axes_hist1,h.axes_hist2,h.axes_thm_BIC], 'Visible', 'on');
        set(h.listbox_thm_projLst, 'Max', 2, 'Min', 0);
        ud_thmPlot(h_fig);
        ud_thmHistAna(h_fig);
        h = guidata(h_fig);

    else
        set([h.radiobutton_thm_gaussFit h.radiobutton_thm_thresh], ...
            'Value', 0, 'FontWeight', 'normal');
        setProp(get(h.uipanel_HA, 'Children'), 'Enable', 'off');
        cla(h.axes_hist1); cla(h.axes_hist2); cla(h.axes_hist_BOBA);
        cla(h.axes_thm_BIC);
        set([h.axes_hist1,h.axes_hist2,h.axes_hist_BOBA, ...
            h.axes_thm_BIC], 'Visible','off');
        set([h.pushbutton_thm_impASCII h.pushbutton_thm_addProj], ...
         'Enable', 'on');
    end
end


%% TDP analysis fields

if strcmp(opt, 'TDP') || strcmp(opt, 'all')
    p = h.param.TDP;
    set(h.edit_TDPcontPan, 'Enable', 'inactive');
    if ~isempty(p.proj)
        
        set([h.listbox_TDPprojList h.text_TDPproj ...
            h.pushbutton_TDPremProj h.pushbutton_TDPsaveProj ...
            h.pushbutton_TDPexport], 'Enable', 'on');
        set(h.listbox_TDPprojList, 'Max', 2, 'Min', 0);
        ud_TDPplot(h_fig);
        ud_TDPmdlSlct(h_fig);
        ud_kinFit(h_fig);
        h = guidata(h_fig);

    else
        set([h.togglebutton_TDPkmean h.togglebutton_TDPgauss], ...
            'Value', 0, 'FontWeight', 'normal');
        setProp(get(h.uipanel_TA, 'Children'), 'Enable', 'off');
        set([h.pushbutton_TDPimpOpt h.pushbutton_TDPaddProj], 'Enable', ...
            'on');
        set(h.listbox_TDPtrans, 'String', {''}, 'Value', 1);
        cla(h.axes_TDPplot1); cla(h.axes_TDPplot2); cla(h.axes_TDPplot3);
        cla(h.axes_tdp_BIC);
        set([h.axes_TDPplot1 h.axes_TDPplot2 h.axes_TDPplot3 ...
            h.axes_TDPcmap h.axes_tdp_BIC], 'Visible', 'off');
    end
end

guidata(h_fig, h);

