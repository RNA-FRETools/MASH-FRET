function ud_S_expSetupPan(h_fig)
% ud_S_expSetupPan(h_fig)
%
% Set panel Experimental setup to proper values
%
% h_fig: handle to main figure

% default
defocus = false;

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_S_experimentalSetup,h)
    set([h.pushbutton_S_impBgImg,h.text_S_bgImgFile,h.edit_S_bgImgFile,...
        h.edit_bgInt_don,h.edit_bgInt_acc,h.text_simBgD,h.text_simBgA,...
        h.edit_TIRFx,h.edit_TIRFy,h.text_simWTIRF_x,h.text_simWTIRF_y], ...
        'visible','off');
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
prm = p.proj{proj}.sim;

% set PSF convolution
set(h.checkbox_convPSF, 'Value', prm.PSF);
if prm.impPrm && isfield(prm.molPrm, 'psf_width')
    set([h.text_simPSFw1 h.text_simPSFw2 h.edit_psfW1 h.edit_psfW2 ...
        h.checkbox_convPSF], 'Enable', 'off');
else
    if prm.PSF
        set(h.edit_psfW1, 'String', num2str(prm.PSFw(1,1)));
        set(h.edit_psfW2, 'String', num2str(prm.PSFw(1,2)));
    else
        set([h.text_simPSFw1 h.edit_psfW1 h.text_simPSFw2 h.edit_psfW2], ...
            'Enable', 'off');
        set([h.edit_psfW1 h.edit_psfW2], 'String', '');
    end
end

% set defocusing
set(h.checkbox_defocus,'value',defocus);
if defocus
    set(h.edit_simzdec, 'String', num2str(prm.zDec));
    set(h.edit_simz0_A, 'String', num2str(prm.z0Dec));
else
    set([h.text_simz0 h.text_simzdec h.edit_simzdec h.edit_simz0_A], ...
        'Enable', 'off');
    set([h.edit_simzdec h.edit_simz0_A], 'String', '');
end

% set background spatial distribution
set(h.popupmenu_simBg_type, 'Value', prm.bgType);

if prm.bgType~=3 % constant or TIRF
    set ([h.pushbutton_S_impBgImg,h.text_S_bgImgFile,h.edit_S_bgImgFile], ...
        'Enable', 'off', 'Visible', 'off');
    
    if strcmp(prm.intUnits, 'electron')
        [offset,K,eta] = getCamParam(prm.noiseType,prm.camNoise);
        prm.bgInt_don = phtn2ele(prm.bgInt_don,K,eta);
        prm.bgInt_acc = phtn2ele(prm.bgInt_acc,K,eta);
    end
    set(h.edit_bgInt_don, 'String', num2str(prm.bgInt_don));
    set(h.edit_bgInt_acc, 'String', num2str(prm.bgInt_acc));
    
    if prm.bgType==2 % TIRF
        set(h.edit_TIRFx, 'String', num2str(prm.TIRFdim(1)));
        set(h.edit_TIRFy, 'String', num2str(prm.TIRFdim(2)));
    else % constant
        set([h.edit_TIRFx,h.edit_TIRFy,h.text_simWTIRF_x, ...
            h.text_simWTIRF_y], 'Enable', 'off', 'Visible', 'off');
    end
    
else % pattern
    set([h.edit_bgInt_don,h.edit_bgInt_acc,h.text_simBgD,h.text_simBgA,...
        h.edit_TIRFx,h.edit_TIRFy,h.text_simWTIRF_x,...
        h.text_simWTIRF_y], 'Enable', 'off', 'Visible', 'off');
    
    if isfield(prm,'bgImg') && isfield(prm.bgImg,'file') && ...
            ~isempty(prm.bgImg.file)
        [o,fname,fext] = fileparts(prm.bgImg.file);
        set(h.edit_S_bgImgFile,'string',[fname,fext]);
    end
end

% set dynamic background
set(h.checkbox_bgExp, 'Value', prm.bgDec);
if prm.bgDec
    set(h.edit_bgExp_cst, 'String', num2str(prm.cstDec));
    set(h.edit_simAmpBG, 'String', num2str(prm.ampDec));
else
    set([h.edit_bgExp_cst h.edit_simAmpBG h.text_dec h.text_amp], 'Enable', ...
        'off');
    set([h.edit_bgExp_cst h.edit_simAmpBG], 'String', '');
end

