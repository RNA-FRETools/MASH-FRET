function exportSimLogFile(fpath,h)
% Write simulation parameters and export options to a .log file.
%
% fpath: full destination file path
% p: structure containing simulation parameters and export options.

% Last update: 5.12.2019 by MH
% >> move script that create .log files to this separate function
%
% update: 20.4.2019 by MH
% >> improve file aesthetic and efficacity by renaming intensity units 
%  "image counts/time bin" by "ic", add categories "VIDEO PARAMETERS", 
%  "PRESETS", "MOLECULES", "EXPERIMENTAL SETUP" and "EXPORT OPTIONS"

% defaults
yesno = {'yes','no'};
units_ic = 'ic';
units_pc = 'pc';

% input intensity units
p = h.param.sim;
ip_u = p.intUnits;
if strcmp(ip_u,'electron')
    ip_u = units_ic;
    [mu_y_dark,K,eta] = getCamParam(p.noiseType,p.camNoise);
else
    ip_u = units_pc;
end
op_u = p.intOpUnits;
if strcmp(op_u,'electron')
    op_u = 'image';
end

% write simulation logs
f = fopen(fpath, 'Wt');

fprintf(f,'VIDEO PARAMETERS\n');
fprintf(f,cat(2,'> frame rate (s-1): ',num2str(p.rate),'\n'));
fprintf(f, '> trace length (frame): %i\n',p.nbFrames);
fprintf(f, '> movie dimension (pixels): %i,%i\n',p.movDim);
fprintf(f,cat(2,'> pixel dimension (um): ',num2str(p.pixDim),'\n'));
fprintf(f, '> bit rate: %i\n', p.bitnr);

if strcmp(p.noiseType, 'poiss')
    prm_id = [1,3,5];
    pop_id = 1;

elseif strcmp(p.noiseType, 'norm')
    prm_id = [1,2,3,4,5];
    pop_id = 2;

elseif strcmp(p.noiseType, 'user')
    prm_id = [1,2,3,4,5,6];
    pop_id = 3;

elseif strcmp(p.noiseType, 'none')
    prm_id = [1,2,3];
    pop_id = 4;

elseif strcmp(p.noiseType, 'hirsch')
    prm_id = [1,2,3,4,5,6];
    pop_id = 5;
end

str_noise = get(h.popupmenu_noiseType,'string');
h_text = [h.text_camNoise_01,h.text_camNoise_02,h.text_camNoise_03,...
    h.text_camNoise_04,h.text_camNoise_05,h.text_camNoise_06];

fprintf(f, cat(2,'> camera noise model: ',str_noise{pop_id},'\n'));
for j = prm_id
    fprintf(f,cat(2,'\tparameter ',removeGreek(get(h_text(j),'string')),...
        ' ',num2str(p.camNoise(pop_id,j)),'\n'));
end

if p.impPrm
    fprintf(f,'\nPRESETS\n');
    fprintf(f,'> input parameters file: %s\n',p.prmFile);
end

fprintf(f,'\nMOLECULES\n');
fprintf(f, '> number of traces: %i\n', p.molNb);
if ~isempty(p.coordFile)
    fprintf(f,'> input coordinates file: %s\n',p.coordFile);
end
fprintf(f,'> number of states: %i\n',p.nbStates);
if ~p.impPrm || (p.impPrm && ~isfield(p.molPrm,'stateVal'))
    fprintf(f,'> state values:\n');
    for j = 1:p.nbStates
        fprintf(f,cat(2,'\tstate',num2str(j),': ',num2str(p.stateVal(j)),...
            ', '));
        fprintf(f,cat(2,'deviation: ',num2str(p.FRETw(j)),'\n'));
    end
end
if (~p.impPrm || (p.impPrm && ~isfield(p.molPrm, 'kx'))) && p.nbStates>1
    fprintf(f, '> transitions rates (sec-1):\n');
    str_fmt = '\t%1.3f';
    for l = 2:p.nbStates
        str_fmt = cat(2,str_fmt,'\t%1.3f');
    end
    str_fmt = cat(2,str_fmt,'\n');
    transMat = getTransMat(h.figure_MASH);
    fprintf(f,str_fmt,transMat(1:p.nbStates,1:p.nbStates)');
end
if ~p.impPrm || (p.impPrm && ~isfield(p.molPrm, 'totInt'))
    if strcmp(ip_u,'ic')
        totI = phtn2ele(p.totInt,K,eta);
        totIw = phtn2ele(p.totInt_width,K,eta);
    else
        totI = p.totInt;
        totIw = p.totInt_width;
    end
    fprintf(f,cat(2,'> total intensity (',ip_u,'): ',num2str(totI),', '));
    fprintf(f,cat(2,'deviation (',ip_u,'): ',num2str(totIw),'\n'));
end
if ~p.impPrm || (p.impPrm && ~isfield(p.molPrm, 'gamma'))
    fprintf(f,cat(2,'> gamma factor: ',num2str(p.gamma),', '));
    fprintf(f,cat(2,'deviation: ',num2str(p.gammaW),'\n'));
end

fprintf(f,cat(2,'> donor bleedthrough coefficient: ',num2str(100*p.btD),...
    '%%\n'));
fprintf(f,cat(2,'> acceptor bleedthrough coefficient: ',num2str(100*p.btA),...
    '%%\n'));
fprintf(f,cat(2,'> donor direct excitation coefficient: ',...
    num2str(100*p.deD),'%% of total intensity\n'));
fprintf(f,cat(2,'> acceptor direct excitation coefficient: ',...
    num2str(100*p.deA),'%% of total intensity\n'));
if p.bleach
    fprintf(f,cat(2,'> photobleaching time decay: ',num2str(p.bleach_t),...
        ' s\n'));
end

fprintf(f,'\nEXPERIMENTAL SETUP\n');
if ~p.impPrm || (p.impPrm && ~isfield(p.molPrm, 'psf_width'))
    if p.PSF 
        fprintf(f,cat(2,'> donor PSF standard deviation (um): ',...
            num2str(p.PSFw(1,1)),'\n'));
        fprintf(f,cat(2,'> acceptor PSF standard deviation (um): ',...
            num2str(p.PSFw(1,2)),'\n'));
    end
end
if strcmp(ip_u,'pc')
    bgDon = p.bgInt_don;
    bgAcc = p.bgInt_acc;
else
    bgDon = phtn2ele(p.bgInt_don,K,eta);
    bgAcc = phtn2ele(p.bgInt_acc,K,eta);
end
bg_str = get(h.popupmenu_simBg_type,'String');
fprintf(f,'> background type: %s\n',bg_str{p.bgType});
if p.bgType==1 || p.bgType==2
    fprintf(f,cat(2,'> fluorescent background intensity in donor channel(',...
        ip_u,'): ',num2str(bgDon),'\n'));
    fprintf(f,cat(2,'> fluorescent background intensity in acceptor ',...
        'channel (',ip_u,'): ',num2str(bgAcc),'\n'));
end
if p.bgType == 2
    fprintf(f,cat(2,'> TIRF (x,y) widths (pixel): (',num2str(p.TIRFdim(1)),...
        ',',num2str(p.TIRFdim(2)),')\n'));
elseif p.bgType == 3
    if isfield(p,'bgImg') && ~isempty(p.bgImg)
        fprintf(f, '> background image file: %s\n',p.bgImg.file);
    else
        fprintf(f,'> no background image file loaded\n');
    end
end
if p.bgDec
    fprintf(f,cat(2,'> background decay (s): ',num2str(p.cstDec),'\n'));
    fprintf(f,cat(2,'> initial background amplitude: ',num2str(p.ampDec),...
        '\n'));
end

fprintf(f,'\nEXPORT OPTIONS\n');
fprintf(f,'> export traces (in %s counts): %s\n',op_u,...
    yesno{p.export_traces+1});
fprintf(f,'> export *.sira video: %s\n',yesno{p.export_movie+1});
fprintf(f,'> export *.avi video: %s\n',yesno{p.export_avi+1});
fprintf(f,'> export ideal traces: %s\n',yesno{p.export_procTraces+1});
fprintf(f,'> export dwell-times: %s\n',yesno{p.export_dt+1});
fprintf(f,'> export coordinates: %s\n',yesno{p.export_coord+1});

fclose(f);

