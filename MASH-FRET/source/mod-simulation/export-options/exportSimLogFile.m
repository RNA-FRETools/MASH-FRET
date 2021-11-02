function exportSimLogFile(fpath,h_fig)
% exportSimLogFile(fpath,h_fig)
%
% Write simulation parameters and export options to a .log file.
%
% fpath: full destination file path
% h_fig: handle to main figure

% update 5.12.2019 by MH: move script that create .log files to this separate function
% update 20.4.2019 by MH: improve file aesthetic and efficacity by renaming intensity units "image counts/time bin" by "ic", add categories "VIDEO PARAMETERS","PRESETS", "MOLECULES", "EXPERIMENTAL SETUP" and "EXPORT OPTIONS"

% defaults
yesno = {'no','yes'};
units_ic = 'ic';
units_pc = 'pc';

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
prm = p.proj{proj}.sim.prm;

% collect simulation parameters
N = prm.gen_dt{1}(1);
L = prm.gen_dt{1}(2);
J = prm.gen_dt{1}(3);
rate = prm.gen_dt{1}(4);
isblch = prm.gen_dt{1}(5);
blchcst = prm.gen_dt{1}(6);
kx = prm.gen_dt{2}(:,:,1);
isPresets = prm.gen_dt{3}{1};
presets = prm.gen_dt{3}{2};
presetsFile = prm.gen_dt{3}{3};

coordFile = prm.gen_dat{1}{1}{3};
viddim = prm.gen_dat{1}{2}{1};
br = prm.gen_dat{1}{2}{2};
pxsz = prm.gen_dat{1}{2}{3};
noisetype = prm.gen_dat{1}{2}{4};
noiseprm = prm.gen_dat{1}{2}{5};
FRETval = prm.gen_dat{2}(1,:);
FRETw= prm.gen_dat{2}(2,:);
Itot = prm.gen_dat{3}{1}(1);
Itotw = prm.gen_dat{3}{1}(2);
inun = prm.gen_dat{3}{2};
gamma = prm.gen_dat{4}(1);
gammaw = prm.gen_dat{4}(2);
btD = prm.gen_dat{5}(1,1);
btA = prm.gen_dat{5}(1,2);
deD = prm.gen_dat{5}(2,1);
deA = prm.gen_dat{5}(2,2);
isPSF = prm.gen_dat{6}{1};
PSFw = prm.gen_dat{6}{2};
bgtype = prm.gen_dat{8}{1};
bgdon = prm.gen_dat{8}{2}(1);
bgacc = prm.gen_dat{8}{2}(2);
tirfdim = prm.gen_dat{8}{3};
bgimg = prm.gen_dat{8}{4}{1};
bgfile = prm.gen_dat{8}{4}{2};
isbgdec = prm.gen_dat{8}{5}(1);
bgcst = prm.gen_dat{8}{5}(2);
bgamp = prm.gen_dat{8}{5}(3);

isTxtTrc = prm.exp{1}(2);
isMatTrc = prm.exp{1}(3);
isDt = prm.exp{1}(4);
isSira = prm.exp{1}(5);
isAvi = prm.exp{1}(6);
isCoord = prm.exp{1}(7);
outun = prm.exp{2};

% input intensity units
if strcmp(inun,'electron')
    inun = units_ic;
    [~,K,eta] = getCamParam(noisetype,noiseprm);
else
    inun = units_pc;
end
if strcmp(outun,'electron')
    outun = 'image';
end

% write simulation logs
f = fopen(fpath, 'Wt');
fprintf(f,'VIDEO PARAMETERS\n');
fprintf(f,cat(2,'> frame rate (s-1): ',num2str(rate),'\n'));
fprintf(f, '> trace length (frames): %i\n',L);
fprintf(f, '> movie dimension (pixels): %i,%i\n',viddim);
fprintf(f,cat(2,'> pixel dimension (um): ',num2str(pxsz),'\n'));
fprintf(f, '> bit rate: %i\n', br);

if strcmp(noisetype, 'poiss')
    prm_id = [1,3,5];
    pop_id = 1;

elseif strcmp(noisetype, 'norm')
    prm_id = [1,2,3,4,5];
    pop_id = 2;

elseif strcmp(noisetype, 'user')
    prm_id = [1,2,3,4,5,6];
    pop_id = 3;

elseif strcmp(noisetype, 'none')
    prm_id = [1,2,3];
    pop_id = 4;

elseif strcmp(noisetype, 'hirsch')
    prm_id = [1,2,3,4,5,6];
    pop_id = 5;
end

str_noise = get(h.popupmenu_noiseType,'string');
h_text = [h.text_camNoise_01,h.text_camNoise_02,h.text_camNoise_03,...
    h.text_camNoise_04,h.text_camNoise_05,h.text_camNoise_06];

fprintf(f, cat(2,'> camera noise model: ',str_noise{pop_id},'\n'));
for j = prm_id
    fprintf(f,cat(2,'\tparameter ',removeGreek(get(h_text(j),'string')),...
        ' ',num2str(noiseprm(pop_id,j)),'\n'));
end
if isPresets
    fprintf(f,'\nPRESETS\n');
    fprintf(f,'> input parameters file: %s\n',presetsFile);
end

fprintf(f,'\nMOLECULES\n');
fprintf(f, '> number of traces: %i\n', N);
if ~isempty(coordFile)
    fprintf(f,'> input coordinates file: %s\n',coordFile);
end
fprintf(f,'> number of states: %i\n',J);
if ~isPresets || (isPresets && ~isfield(presets,'stateVal'))
    fprintf(f,'> state values:\n');
    for j = 1:J
        fprintf(f,cat(2,'\tstate',num2str(j),': ',num2str(FRETval(j)),...
            ', '));
        fprintf(f,cat(2,'deviation: ',num2str(FRETw(j)),'\n'));
    end
end
if (~isPresets || (isPresets && ~isfield(presets,'kx'))) && J>1
    fprintf(f, '> transitions rates (sec-1):\n');
    str_fmt = '\t%1.3f';
    for l = 2:J
        str_fmt = cat(2,str_fmt,'\t%1.3f');
    end
    str_fmt = cat(2,str_fmt,'\n');
    transMat = kx*rate;
    fprintf(f,str_fmt,transMat(1:J,1:J)');
end
if ~isPresets || (isPresets && ~isfield(presets, 'totInt'))
    if strcmp(inun,'ic')
        totI = phtn2ele(Itot,K,eta);
        totIw = phtn2ele(Itotw,K,eta);
    else
        totI = Itot;
        totIw = Itotw;
    end
    fprintf(f,cat(2,'> total intensity (',inun,'): ',num2str(totI),', '));
    fprintf(f,cat(2,'deviation (',inun,'): ',num2str(totIw),'\n'));
end
if ~isPresets || (isPresets && ~isfield(presets, 'gamma'))
    fprintf(f,cat(2,'> gamma factor: ',num2str(gamma),', '));
    fprintf(f,cat(2,'deviation: ',num2str(gammaw),'\n'));
end

fprintf(f,cat(2,'> donor bleedthrough coefficient: ',num2str(100*btD),...
    '%%\n'));
fprintf(f,cat(2,'> acceptor bleedthrough coefficient: ',num2str(100*btA),...
    '%%\n'));
fprintf(f,cat(2,'> donor direct excitation coefficient: ',num2str(100*deD),...
    '%% of total intensity\n'));
fprintf(f,cat(2,'> acceptor direct excitation coefficient: ',...
    num2str(100*deA),'%% of total intensity\n'));
if isblch
    fprintf(f,cat(2,'> photobleaching decay constant (frames): ',...
        num2str(blchcst),' s\n'));
end

fprintf(f,'\nEXPERIMENTAL SETUP\n');
if ~isPresets || (isPresets && ~isfield(presets, 'psf_width'))
    if isPSF 
        fprintf(f,cat(2,'> donor PSF standard deviation (um): ',...
            num2str(PSFw(1,1)),'\n'));
        fprintf(f,cat(2,'> acceptor PSF standard deviation (um): ',...
            num2str(PSFw(1,2)),'\n'));
    end
end
if strcmp(inun,'pc')
    bgdon = phtn2ele(bgdon,K,eta);
    bgacc = phtn2ele(bgacc,K,eta);
end
bg_str = get(h.popupmenu_simBg_type,'String');
fprintf(f,'> background type: %s\n',bg_str{bgtype});
if bgtype==1 || bgtype==2
    fprintf(f,cat(2,'> fluorescent background intensity in donor channel(',...
        inun,'): ',num2str(bgdon),'\n'));
    fprintf(f,cat(2,'> fluorescent background intensity in acceptor ',...
        'channel (',inun,'): ',num2str(bgacc),'\n'));
end
if bgtype == 2
    fprintf(f,cat(2,'> TIRF (x,y) widths (pixel): (',num2str(tirfdim(1)),...
        ',',num2str(tirfdim(2)),')\n'));
elseif bgtype == 3
    if isfield(p,'bgImg') && ~isempty(bgimg)
        fprintf(f, '> background image file: %s\n',bgfile);
    else
        fprintf(f,'> no background image file loaded\n');
    end
end
if isbgdec
    fprintf(f,cat(2,'> background decay constant (frames): ',...
        num2str(bgcst),'\n'));
    fprintf(f,cat(2,'> initial background amplitude: ',num2str(bgamp),...
        '\n'));
end

fprintf(f,'\nEXPORT OPTIONS\n');
fprintf(f,'> export ASCII traces (in %s counts): %s\n',outun,...
    yesno{isTxtTrc+1});
fprintf(f,'> export *.sira video: %s\n',yesno{isSira+1});
fprintf(f,'> export *.avi video: %s\n',yesno{isAvi+1});
fprintf(f,'> export *.mat traces: %s\n',yesno{isMatTrc+1});
fprintf(f,'> export ASCII dwell-times: %s\n',yesno{isDt+1});
fprintf(f,'> export ASCII coordinates: %s\n',yesno{isCoord+1});

fclose(f);

