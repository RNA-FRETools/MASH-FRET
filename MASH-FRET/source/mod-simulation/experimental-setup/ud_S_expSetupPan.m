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
inSec = p.proj{p.curr_proj}.time_in_sec;
perSec = p.proj{p.curr_proj}.cnt_p_sec;
curr = p.proj{proj}.sim.curr;
isPresets = curr.gen_dt{3}{1};
presets = curr.gen_dt{3}{2};
rate = curr.gen_dt{1}(4);
noisetype = curr.gen_dat{1}{2}{4};
noiseprm = curr.gen_dat{1}{2}{5};
inun = curr.gen_dat{3}{2};
isPSF = curr.gen_dat{6}{1};
PSFw = curr.gen_dat{6}{2};
isdef = curr.gen_dat{7}(1);
defcst = curr.gen_dat{7}(2);
defamp = curr.gen_dat{7}(3);
bgtype = curr.gen_dat{8}{1};
bgint = curr.gen_dat{8}{2};
tirfdim = curr.gen_dat{8}{3};
bgimg = curr.gen_dat{8}{4}{1};
bgfile = curr.gen_dat{8}{4}{2};
isbgdec = curr.gen_dat{8}{5}(1);
bgcst = curr.gen_dat{8}{5}(2);
bgamp = curr.gen_dat{8}{5}(3);

% convert time units
if inSec
    bgcst = bgcst/rate;
end

% convert intensity units
if perSec
    bgint = bgint*rate;
end

% set PSF convolution
set(h.checkbox_convPSF,'value',isPSF);
if isPresets && isfield(presets,'psf_width')
    set([h.text_simPSFw1 h.text_simPSFw2 h.edit_psfW1 h.edit_psfW2 ...
        h.checkbox_convPSF],'enable','off');
else
    if isPSF
        set(h.edit_psfW1,'string',num2str(PSFw(1)));
        set(h.edit_psfW2,'string',num2str(PSFw(2)));
    else
        set([h.text_simPSFw1 h.edit_psfW1 h.text_simPSFw2 h.edit_psfW2], ...
            'enable','off');
        set([h.edit_psfW1 h.edit_psfW2],'string','');
    end
end

% set defocusing
if defocus
    set(h.checkbox_defocus,'value',isdef);
    if isdef
        set(h.edit_simzdec,'string',num2str(defcst));
        set(h.edit_simz0_A,'string',num2str(defamp));
    else
        set([h.text_simz0 h.text_simzdec h.edit_simzdec h.edit_simz0_A], ...
            'enable','off');
        set([h.edit_simzdec h.edit_simz0_A],'string','');
    end
else
    set(h.checkbox_defocus,'value',0,'enable','off');
    set([h.text_simz0 h.text_simzdec h.edit_simzdec h.edit_simz0_A], ...
        'enable','off');
    set([h.edit_simzdec h.edit_simz0_A],'string','');
end

% set background spatial distribution
set(h.popupmenu_simBg_type,'value',bgtype);

if bgtype~=3 % constant or TIRF
    set ([h.pushbutton_S_impBgImg,h.text_S_bgImgFile,h.edit_S_bgImgFile], ...
        'enable','off','visible','off');
    
    if strcmp(inun,'electron')
        [offset,K,eta] = getCamParam(noisetype,noiseprm);
        bgint(1) = phtn2ele(bgint(1),K,eta);
        bgint(2) = phtn2ele(bgint(2),K,eta);
    end
    set(h.edit_bgInt_don, 'string', num2str(bgint(1)));
    set(h.edit_bgInt_acc, 'string', num2str(bgint(2)));
    
    if bgtype==2 % TIRF
        set(h.edit_TIRFx, 'string', num2str(tirfdim(1)));
        set(h.edit_TIRFy, 'string', num2str(tirfdim(2)));
    else % constant
        set([h.edit_TIRFx,h.edit_TIRFy,h.text_simWTIRF_x, ...
            h.text_simWTIRF_y], 'enable', 'off', 'Visible', 'off');
    end
    
else % pattern
    set([h.edit_bgInt_don,h.edit_bgInt_acc,h.text_simBgD,h.text_simBgA,...
        h.edit_TIRFx,h.edit_TIRFy,h.text_simWTIRF_x,...
        h.text_simWTIRF_y], 'enable', 'off', 'Visible', 'off');
    
    if ~isempty(bgimg)
        [o,fname,fext] = fileparts(bgfile);
        set(h.edit_S_bgImgFile,'string',[fname,fext]);
    end
end

% set dynamic background
set(h.checkbox_bgExp, 'value', isbgdec);
if isbgdec
    set(h.edit_bgExp_cst, 'string', num2str(bgcst));
    set(h.edit_simAmpBG, 'string', num2str(bgamp));
else
    set([h.edit_bgExp_cst h.edit_simAmpBG h.text_dec h.text_amp], 'enable', ...
        'off');
    set([h.edit_bgExp_cst h.edit_simAmpBG], 'string', '');
end

