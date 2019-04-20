function exportResults(h_fig,varargin)

% exportResults create the *.sira movie file, the *.mat and the *.traces
% files, containing the raw intensity-time traces, from the simulated
% noisy traces.
%
% Requires external files: setContPan.m

% Last update: 20.4.2019 by MH
% >> improve file aesthetic and efficacity by renaming intensity units 
%    "image counts/time bin" by "ic", add categories "VIDEO PARAMETERS", 
%    "PRESETS", "MOLECULES", "EXPERIMENTAL SETUP" and "EXPORT OPTIONS"
%
% Last update: 20th of February 2019 by Mélodie Hadzic
% --> add headers to dwell-time files
% --> modify dwell-times file name for coherence with trace processing
%
% update: 7th of March 2018 by Richard Börner
% --> Comments adapted for Boerner et al 2017
% --> Noise models adapted for Boerner et al 2017.
% --> Simulation default parameters adapted for Boerner et al 2017.
%
% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic

h = guidata(h_fig);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize all parameters

p = h.param.sim;

bgDec_dir = {'decrease','decrease'};


if isfield(h, 'results') && isfield(h.results, 'sim') && ...
        isfield(h.results.sim, 'dat') && ...
        size(h.results.sim.dat{1},2)==p.molNb
    
    if size(varargin,2)==2
        pName = varargin{1};
        fName = varargin{2};
    else
        [fName,pName] = uiputfile({'*.*', 'All files (*.*)'}, ...
            'Define a root name the exported files', ...
            setCorrectPath('simulations', h_fig));
    end
    
    if ~isempty(fName) && sum(fName)
        cd(pName);
        [~,fName,~] = fileparts(fName);

        transMat = getTransMat(h_fig);
        
        % Labelled molecular system
        J = p.nbStates;         % number of FRET states
        M = p.molNb;            % number of molecules
        bleach = p.bleach;      % simulated bleaching (0/1)
        bleachT = p.bleach_t;   % bleaching characteristic time
        N = p.nbFrames;         % number of frames
        states = p.stateVal;    % FRET state values
        FRETw = p.FRETw;        % heterogeneous FRET broadening
        gamma = p.gamma;        % gamma factor
        gammaW = p.gammaW;      % heterogeneous gamma broadening
        totI = p.totInt;        % total fluorescence (PC)
        totIw = p.totInt_width; % heterogeneous fluorescence broadening
        
        % EMCCD camera
        res_x = p.movDim(1); % movie with
        res_y = p.movDim(2); % movie height
        psf = p.PSF; % convolve with PSF (0/1)
        o_psf = p.PSFw/p.pixDim; % PSF sigma (for both channels)
        
        matGauss = p.matGauss;
        expT = 1/p.rate; % exposure time
        aDim = p.pixDim; % pixel dimension
        [~, sat] = Saturation(p.bitnr); % saturation of camera pixel value
        %sat = 2^p.bitnr-1;
        
        % Background
        bgType = p.bgType; % fluorescent background type
        bgDon = p.bgInt_don; bgAcc = p.bgInt_acc; % BG intensities
        TIRFw = p.TIRFdim; % TIRF profile widths
        bgDec = p.bgDec; % exponentially decreasing BG (0/1)
        amp = p.ampDec; % exponential amplitude
        cst = p.cstDec; % exponential time decay constant
        
        % Defocusing and lateral chromatic aberration
        z0 = p.z0Dec;
        z_dec = p.zDec; 

        % camera noise
        noiseType = p.noiseType; % noise distribution 
        switch noiseType      
            case 'poiss'
                camNoiseInd = 1;    
            case 'norm'
                camNoiseInd = 2;
            case 'user'
                camNoiseInd = 3;
            case 'none'
                camNoiseInd = 4;          
            case 'hirsch'
                camNoiseInd = 5;
        end
        noisePrm = p.camNoise(camNoiseInd,:);
        
        % instrumental imperfections
        btD = p.btD; % bleedthrough coefficients D -> A
        btA = p.btA; % bleedthrough coefficients A -> D, usually zero
        deD = p.deD; % direct excitation coefficients D, usually zero
        deA = p.deA; % direct excitation coefficients A
        
        % Import/export options
        isPrm = p.export_param; % export simulation parameters (0/1)
        ip_u = p.intUnits; % input intensity units
        if strcmp(ip_u,'electron')
            ip_u = 'ic';
        else
            ip_u = 'pc';
        end
        op_u = p.intOpUnits; % output intensity units
        prm_file = p.prmFile; % parameters file name
        crd_file = p.coordFile; % coordinates file name
        impPrm = p.impPrm; % imported simulation parameters (0/1)
        isAvi = p.export_avi; % export movie (0/1)
        isMov = p.export_movie; % export movie (0/1)
        isTr = p.export_traces; % export Matlab traces (0/1)
        isProcTr = p.export_procTraces; % export ASCII traces (0/1)
        isCrd = p.export_coord; % export coordinates (0/1)
        isDt = p.export_dt; % export dwell-times (0/1)
        
        str_exp_mov = 'no';
        str_exp_avi = 'no';
        str_exp_traces = 'no';
        str_exp_procTraces = 'no';
        str_exp_dt = 'no';
        str_exp_coord = 'no';
        str_action = '';
        
        % Results from buildModel function
        res         = h.results.sim; % results/simulated data
        Idon        = res.dat{1};    % ideal traces including heterogeneous FRET and 
        Iacc        = res.dat{2};    % fluorescence broadening
        crd         = res.dat{3};    % coordinates
        
        Idon_id     = res.dat_id{1}; % ideal traces excluding heterogeneous
        Iacc_id     = res.dat_id{2}; % FRET and fluorescence broadening
        
        discr_id    = res.dat_id{3}; % ideal FRET traces excluding 
                                     % heterogeneous FRET broadening
                                  
        discr_seq   = res.dat_id{4}; % FRET state sequence (numbered 1,2,...)

        % end of intitialization
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % initialise background frame
        lim_don.x = [1 round(res_x/2)]; lim_don.y = [1 res_y];
        lim_acc.x = [1 res_x - round(res_x/2)]; lim_acc.y = [1 res_y];
        
        img_bg_don = zeros(res_y, round(res_x/2));
        img_bg_acc = zeros(res_y, res_x-round(res_x/2));

        % calculate fluorescent background image (background values still im electron or image counts / frame)
        switch bgType
            case 1 % constant
                img_bg_don = bgDon*ones(res_y, round(res_x/2));
                img_bg_acc = bgAcc*ones(res_y, res_x - round(res_x/2));

            case 2 % TIRF profile
                q.amp = bgDon;
                q.mu(1) = round(res_x/4);
                q.mu(2) = round(res_y/2);
                q.sig = TIRFw;
                [img_bg_don,o] = getImgGauss(lim_don, q, 0);

                q.amp = bgAcc;
                [img_bg_acc,o] = getImgGauss(lim_acc, q, 0);

            case 3 % patterned
                if isfield(p, 'bgImg') && ~isempty(p.bgImg)
                    bgImg = p.bgImg.frameCur;
                    min_s = min([size(img_bg_don);size(bgImg)]);
                    h_min = min_s(1); w_min = min_s(2);
                    img_bg_don(1:h_min,1:w_min) = ...
                        bgImg(1:h_min,1:w_min);
                    min_s = min([size(img_bg_acc);size(bgImg)]);
                    h_min = min_s(1); w_min = min_s(2);
                    img_bg_acc(1:h_min,1:w_min) = ...
                        bgImg(1:h_min,1:w_min);
                else
                    setContPan('No BG pattern loaded.','error',h_fig);
                    return;
                end
        end
        
        img_bg = [img_bg_don img_bg_acc];

        % calculate trajectories for all molecules 
        % incl. instrumental imperfections and photon shot noise
        
        % initialise traces
        I_don_bt = cell(1,M); % ideal trace + cross talk + shot noise
        I_acc_bt = I_don_bt; % 
        I_don_plot = I_don_bt; % noisy traces + noisy BG trace
        I_acc_plot = I_don_bt; % 
        bg_don = I_don_bt; % noisy BG traces
        bg_acc = I_don_bt; % 
        
        setContPan('Format data ...', 'process', h_fig);
        
        for m = 1:M % M:= Number of molecules

%             % direct excitation in % of the background
%             % comment: indeed there is direct excitation contribution of the background, but its corrected via the background itself. 
%             % I_de = I + De*bg
%             I_don_de = Idon{m}(:,1) + deD*bgDon;
%             I_acc_de = Iacc{m}(:,1) + deA*bgAcc;

            % direct excitation assuming I_Dem_Dex without FRET = I_Aem_Aex
            % comment: this value can only be correct for ALEX type
            % measurements. Therefore, direct excitation should only be
            % simulated for ALEX type simulations.
            % I_de = I + De*I_j
            I_don_de = Idon{m}(:,1) + deD*totI; % usually zero, there is no direct excitation of the Donor 
            I_acc_de = Iacc{m}(:,1) + deA*totI;
            
            % bleedthrough (missing signal in each channel will be added in the other)
            % I_bt = I_de - Bt*I_j_de
            I_don_bt{m} = (1-btD)*I_don_de + btA*I_acc_de;
            I_acc_bt{m} = (1-btA)*I_acc_de + btD*I_don_de;

            % add photon emission noise, which is Poisson-noise
            if camNoiseInd~=2 % no Poisson noise for pure Gaussian noise
                I_don_bt{m} = random('poiss', I_don_bt{m});
                I_acc_bt{m} = random('poiss', I_acc_bt{m});
            end

            % add noisy fluorescent background trace
            % I_bg = I_bt + bg
            % exp decay of background, to check, ok!
            if bgDec
                bg_don{m} = img_bg_don(ceil(crd(m,2)), ...
                    ceil(crd(m,1)))*(amp*exp(-expT*(1:numel(I_don_bt{m}))/cst)+1);
                bg_acc{m} = img_bg_acc(ceil(crd(m,4)), ...
                    ceil(crd(m,3))-round(res_x/2))* ...
                    (amp*exp(-expT*(1:numel(I_acc_bt{m}))/cst)+1);
                
                if camNoiseInd~=2 % no Poisson noise for pure Gaussian noise
                    bg_don{m} = random('poiss', bg_don{m});
                    bg_acc{m} = random('poiss', bg_acc{m});
                end
                
                if strcmp(bgDec_dir{1},'increase')
                    I_don_bg = I_don_bt{m} + (bg_don{m}(end:-1:1))';
                else
                    I_don_bg = I_don_bt{m} + bg_don{m}';
                end
                if strcmp(bgDec_dir{2},'increase')
                    I_acc_bg = I_acc_bt{m} + (bg_acc{m}(end:-1:1))';
                else
                    I_acc_bg = I_acc_bt{m} + bg_acc{m}';
                end
            % constant background pattern (constant, TIRF profile, patterned)    
            else
                if camNoiseInd~=2 % no Poisson noise for pure Gaussian noise
                    I_don_bg = I_don_bt{m} + random('poiss', ...
                        repmat(img_bg_don(ceil(crd(m,2)), ...
                        ceil(crd(m,1))),size(I_don_bt{m})));
                    I_acc_bg = I_acc_bt{m} + random('poiss', ...
                        repmat(img_bg_acc(ceil(crd(m,4)), ...
                        ceil(crd(m,3))-round(res_x/2)), ...
                        size(I_acc_bt{m})));
                else
                    I_don_bg = I_don_bt{m} + repmat(img_bg_don( ...
                        ceil(crd(m,2)),ceil(crd(m,1))), ...
                        size(I_don_bt{m}));
                    I_acc_bg = I_acc_bt{m} + repmat(img_bg_acc( ...
                        ceil(crd(m,4)),ceil(crd(m,3))- ...
                        round(res_x/2)),size(I_acc_bt{m}));
                end
            end
            I_don_plot{m} = I_don_bg; % this cell array contains all simulated donor traces
            I_acc_plot{m} = I_acc_bg; % this cell array contains all simulated acceptor traces

            % define Point-Spread-Function (PSF) for each simulated molecule
            if psf
                    if size(o_psf,1)>1
                        o_psf1 = o_psf(m,1); o_psf2 = o_psf(m,1);
                    else
                        o_psf1 = o_psf(1,1); o_psf2 = o_psf(1,2);
                    end
                    psf_don_amp(m,:) = I_don_bt{m}(:,1)';
                    p_don.mu(m,1) = crd(m,1);
                    p_don.mu(m,2) = crd(m,2);
                    p_don.sig(m,1:2) = [o_psf1 o_psf1];

                    psf_acc_amp(m,:) = I_acc_bt{m}(:,1)';
                    p_acc.mu(m,1) = crd(m,3) - round(res_x/2);
                    p_acc.mu(m,2) = crd(m,4);
                    p_acc.sig(m,1:2) = [o_psf2 o_psf2];
            end
        end

        % Export SMV
        if isMov || isAvi % sira(movie/video) or avi file 
            
            setContPan('Write video to file ...', 'process', h_fig);
            
            % open blank movie file
            if isMov
                fName_mov = [fName '.sira'];
                str_exp_mov = 'yes';
                
                f = fopen([pName fName_mov], 'w');
                
                % SIRA header for Version MASH-FRET movie processing
                % version > 1.003.37
                figname = get(h_fig, 'Name');
                vers = figname(length('MASH-FRET '):end);
                fprintf(f, ['MASH-FRET exported binary graphic Version: ' ...
                    '%s\r'], vers);
                fwrite(f, double(expT), 'double');
                fwrite(f, single(res_x), 'single');
                fwrite(f, single(res_y), 'single');
                fwrite(f, single(N), 'single');
            end
            
            if isAvi
                fName_mov_avi = [fName '.avi'];
                str_exp_avi = 'yes';
                v = VideoWriter(cat(2,pName,fName_mov_avi),'Uncompressed AVI');
                v.FrameRate = 1/expT;

                open(v);
            end

            for i = 1:N % number of frames
                if i==2
                    t = tic;
                end
                
                % initialise images
                img_don = zeros(res_y,round(res_x/2));
                img_acc = zeros(res_y,res_x-round(res_x/2));
                img_bg_i = img_bg; % transfer background image to each frame of the movie/video
                
                % build noisy + PSF convoluted sm fluorescence image
                if psf
                    p_don.amp = psf_don_amp(:,i);
                    p_acc.amp = psf_acc_amp(:,i);
                    [img_don2, matGauss{1}] = getImgGauss(lim_don, ...
                        p_don, 1, matGauss{1});
                    [img_acc2, matGauss{2}] = getImgGauss(lim_acc, ...
                        p_acc, 1, matGauss{2});
                    img_don = img_don + img_don2;
                    img_acc = img_acc + img_acc2;
                else
                    for m = 1:M
                        img_don(ceil(crd(m,2)),ceil(crd(m,1))) = ...
                            I_don_bt{m}(i,1);
                        img_acc(ceil(crd(m,4)),ceil(crd(m,3))- ...
                            round(res_x/2)) = I_acc_bt{m}(i,1);
                    end
                end
                
                % build noisy fluorescent background image
                if p.bgDec
                    if strcmp(bgDec_dir{1},'increase')
                        img_don = img_don*(amp*exp(-expT*(N-i+1)/cst)+1);
                    else
                        img_don = img_don*(amp*exp(-expT*i/cst)+1);
                    end
                    if strcmp(bgDec_dir{1},'increase')
                        img_acc = img_acc*(amp*exp(-expT*(N-i+1)/cst)+1);
                    else
                        img_acc = img_acc*(amp*exp(-expT*i/cst)+1);
                    end
                end
                
                img = [img_don img_acc];
                
                % add noisy fluorescent background image 
                if camNoiseInd~=2
                    img_bg_i = random('poiss', img_bg_i);
                end
                
                
                img = img + img_bg_i;
                
                % add camera noise
                % comment: the input values are always poisson distributed pc coming from
                % the fluorophors and the background!
                
                switch noiseType
                %     Propability distribution for different noise contributions.
                %     Ptot = @(o,I0,q,c,f,nic,g) (1/sqrt(2*pi*o))*exp(-(I0*q+c)-((f*nic)^2)/(2*(o^2)))+(2/g)*chi2pdf(2*(I0*q+c),4.2*f*nic/g);
                %     G = @(noe,nie,g) (noe^(nie-1))*exp(-noe/g)/(gamma(nie)*(g^nie));
                %     P = @(nie,c) exp(-c)*(c^nie)/factorial(nie);
                %     N = @(fnic,noe,r) normpdf(fnic,noe,r);
                %     Pdark = @(nic,noe,nie,g,f,r) (P(nie,G(noe,nie,g))*N(f*nic,noe,r))*(f*nic);      
    
                    case 'poiss' % Poisson or P-model from Börner et al. 2017
                        mu_y_dark = noisePrm(1); % given in IC
                        eta = noisePrm(3); 
                        K = 1;
                        
                        % add noise for photoelectrons (no mu_y_dark here)
                        % (PC-->EC)
                        img = random('poiss', eta*img);
                        
                        % add camera mu_y_dark for conversion to image counts
                        % (EC-->IC)
                        img = img + mu_y_dark;
                        
                    case 'norm' % Gaussian, Normal or N-model from Börner et al. 2017
                        % PC are not Poisson distributed here.
                        % model parameters
                        mu_y_dark = noisePrm(1);
                        sig_d = noisePrm(2);
                        eta = noisePrm(3);
                        sig_q = noisePrm(4);
                        K = noisePrm(5);
                        
                        % (PC-->IC)
                        mu_y_img = phtn2arb(img,mu_y_dark,K,eta);

                        % calculate noise width in EC, Gaussian width
                        % ASSUMPTION (no units conversion, just value assignment)
                        % (EC)
                        sig_pe_img = sqrt(eta*img); 

                        % (EC-->IC)
                        sig_y_img = sqrt((K*sig_d)^2 + (sig_q^2) + (K*sig_pe_img).^2);

                        % add Gaussian noise
                        % (IC)
                        img = random('norm', mu_y_img, sig_y_img);

                    case 'user'  % User defined or NExpN-model from Börner et al. 2017
                       
                         % model parameters
                        mu_y_dark = noisePrm(1); % Dark counts or mu_y_dark
                        A = noisePrm(2); % CIC contribution
                        eta = noisePrm(3); % Total detection efficiency
                        tau = noisePrm(6); % CIC decay
                        K = noisePrm(5); % Overall system gain
                        sig0 = noisePrm(4); % read-out noise width
                        
                        % convert to IC (PC-->IC)
                        img = phtn2arb(img,mu_y_dark,K,eta);
                        
                        % calculate noise distribution and add noise (IC)
                        img = rand_NexpN(img, A, tau, sig0);
                        
                    case 'none' % None, no camera noise but possible camera mu_y_dark value
                        mu_y_dark = noisePrm(1); % given in IC
                        K = 1;
                        eta = 1;
                        
                        % no noise but mu_y_dark in IC (according to PONE) 
                        % (PC-->IC)
                        img = phtn2arb(img, mu_y_dark, K, eta);
                        
                    case 'hirsch' % Hirsch or PGN- Model from Hirsch et al. 2011
                        
                        % model parameters
                        % EDIT MH: Here the mu_y_dark participates to the generation of noise 
                        % (according to PONE)
                        mu_y_dark = noisePrm(1);
                        s_d = noisePrm(2); 
                        eta = noisePrm(3);
                        CIC = noisePrm(4);
                        g = noisePrm(5); % change 2018-08-03
                        s = noisePrm(6);
                        K = g/s;
                        
                        % Poisson noise of photo-electrons + CIC 
                        % (PC-->EC)
                        img = random('poiss', eta*img+CIC);

                        % Gamma amplification noise, composition 
                        % (EC)
                        img = random('Gamma', img, g);

                        % Gausian read-out noise, composition 
                        % (EC-->IC)
                        img = random('norm', img/s + mu_y_dark, s_d*g/s);

                end
                
                % Correction of out-of-range values.
                % Due to noise calculated values out of the detection range 0 <= 0I <= bitrate. 
                
                img(img<0) = 0;
                img(img>sat) = sat;
                
                % (IC-->PC)
                if strcmp(op_u, 'photon')
                    img = arb2phtn(img, mu_y_dark, K, eta);
                end
                
                if isAvi
                    img_avi = zeros([size(img) 3]);
                    img_avi(:,:,1) = img;
                    img_avi(:,:,2) = img;
                    img_avi(:,:,3) = img;
                    img_avi = uint8(255*img_avi/max(max(img)));
                    writeVideo(v, img_avi);
%                     imgAvi = typecast(uint16(img(:)),'uint8');
%                     imgAvi = reshape(imgAvi,2,res_y*res_x);
%                     imgFin = uint8(zeros(res_y,res_x,3));
%                     for r = 1:2
%                         imgFin(:,:,r) = uint8(reshape(imgAvi(r,:),res_y,res_x));
%                     end
%                     writeVideo(v,imgFin);
                end

                if isMov
                    min_img = min(min(round(img)));
                    if min_img >= 0
                        min_img = 0;
                    end

                    img = single(img+abs(min_img));
                    img = [reshape(img,1,numel(img)) single(abs(min_img))];
                    fwrite(f, img, 'single');
                end
                
%                 disp(cat(2,'Writing frame ',num2str(i),' of ',num2str(N)));
                
                if i==2 && size(varargin,2)~=2
                    t_end = toc(t);
                    t_proc = N*t_end;
                    t_h = t_proc/3600;
                    t_min = (t_h - floor(t_h))*60;
                    t_sec = round((t_min - floor(t_min))*60);
                    
                    estm_str = [];
                    if floor(t_h)>0
                        estm_str = [num2str(floor(t_h)) 'h '];
                    end
                    if floor(t_min)>0
                        estm_str = [estm_str num2str(floor(t_min)) 'min '];
                    end
                    estm_str = [estm_str num2str(t_sec) 's'];
                    
                    choice = questdlg({['Estimated time: ' estm_str] ...
                        'Do you want to continue?'}, 'Processing time', ...
                        'Yes', 'No', 'Yes');
                    if ~strcmp(choice, 'Yes')
                        if isMov
                            fclose(f);
                            delete([pName fName_mov]);
                        end
                        if isAvi
                            close(v);
                            delete([pName fName_mov_avi]);
                        end
                        setContPan('Process interrupted.','error',h_fig);
                        return;
                    end
                end
            end
            if isMov
                str_action = cat(2,str_action,'Video written to file: ',...
                    fName_mov,' in folder: ',pName,'\n');
                fclose(f);
            end
            if isAvi
                str_action = cat(2,str_action,'Video written to AVI ',...
                    'file ',fName_mov_avi,' in folder:',pName,'\n');
                close(v);
            end
        end
        
        if strcmp(op_u, 'electron')
            units = 'a.u.';
        else
            units = 'photons';
        end
        
        if isTr || isProcTr || isDt
            
            setContPan('Write trace data to file ...', 'process', h_fig);
            
            if isTr
                fName_traces = [fName '.mat'];
                str_exp_traces = 'yes';
                tr_all = [expT*(1:N)' (1:N)'];
            end
            if isProcTr
                str_exp_procTraces = 'yes';
                setCorrectPath(cat(2,pName,'traces_ASCII'), h_fig);
            end
            if isDt
                str_exp_dt = 'yes';
                setCorrectPath(cat(2,pName,'dwell-times'), h_fig);
            end
            
            % Process all traces
            for m = 1:M
 
                % camera noise
                % comment: the input values are always poisson distributed pc coming from
                % the fluorophors and the background!
                switch noiseType
                %     Propability distribution for different noise contributions.
                %     Ptot = @(o,I0,q,c,f,nic,g) (1/sqrt(2*pi*o))*exp(-(I0*q+c)-((f*nic)^2)/(2*(o^2)))+(2/g)*chi2pdf(2*(I0*q+c),4.2*f*nic/g);
                %     G = @(noe,nie,g) (noe^(nie-1))*exp(-noe/g)/(gamma(nie)*(g^nie));
                %     P = @(nie,c) exp(-c)*(c^nie)/factorial(nie);
                %     N = @(fnic,noe,r) normpdf(fnic,noe,r);
                %     Pdark = @(nic,noe,nie,g,f,r) (P(nie,G(noe,nie,g))*N(f*nic,noe,r))*(f*nic);      

                    case 'poiss' % Poisson or P-model from Börner et al. 2017
                        mu_y_dark = noisePrm(1); % given in IC
                        eta = noisePrm(3); 
                        K = 1;

                        % add noise for photoelectrons (no mu_y_dark here)
                        % (PC-->EC)
                        I_don_plot{m} = random('poiss', eta*I_don_plot{m});
                        I_acc_plot{m} = random('poiss', eta*I_acc_plot{m});

                        % convert to IC
                        % (EC-->IC)
                        I_don_plot{m} = K*I_don_plot{m} + mu_y_dark;
                        I_acc_plot{m} = K*I_acc_plot{m} + mu_y_dark;

                        
                    case 'norm' % Gaussian, Normal or N-model from Börner et al. 2017
                        mu_y_dark = noisePrm(1);
                        sig_d = noisePrm(2);
                        eta = noisePrm(3);
                        sig_q = noisePrm(4);
                        K = noisePrm(5);

                        % (PC-->IC)
                        mu_y_I_don = phtn2arb(I_don_plot{m},mu_y_dark,K,eta);
                        mu_y_I_acc = phtn2arb(I_acc_plot{m},mu_y_dark,K,eta);

                        % calculate noise width in EC, Gaussian width
                        % ASSUMPTION (no units conversion, just value assignment)
                        % (EC)
                        sig_pe_Idon = sqrt(eta*I_don_plot{m}); 
                        sig_pe_Iacc = sqrt(eta*I_acc_plot{m}); 

                        % (EC-->IC)
                        sig_y_Idon = sqrt((K*sig_d)^2 + (sig_q^2) + ...
                            (K*sig_pe_Idon).^2);
                        sig_y_Iacc = sqrt((K*sig_d)^2 + (sig_q^2) + ...
                            (K*sig_pe_Iacc).^2);

                        % add Gaussian noise
                        % (IC)
                        I_don_plot{m} = random('norm',mu_y_I_don,...
                            sig_y_Idon);
                        I_acc_plot{m} = random('norm',mu_y_I_acc,...
                            sig_y_Iacc);

                        
                    case 'user' % User defined or NExpN-model from Börner et al. 2017

                        % model parameters
                        mu_y_dark = noisePrm(1); % Dark counts or mu_y_dark
                        A = noisePrm(2); % CIC contribution
                        eta = noisePrm(3); % Total detection efficiency
                        sig0 = noisePrm(4); % read-out noise width
                        K = noisePrm(5); % Overall system gain
                        tau = noisePrm(6); % CIC decay

                        % convert to IC (PC-->IC)
                        I_don_plot{m} = phtn2arb(I_don_plot{m},mu_y_dark,K,...
                            eta);
                        I_acc_plot{m} = phtn2arb(I_acc_plot{m},mu_y_dark,K,...
                            eta);

                        % calculate noise distribution and add noise (IC)
                        I_don_plot{m} = rand_NexpN(I_don_plot{m},A,tau,...
                            sig0);
                        I_acc_plot{m} = rand_NexpN(I_acc_plot{m},A,tau,...
                            sig0);
                        
                     case 'none' % None, no camera noise but possible camera mu_y_dark value
                        mu_y_dark = noisePrm(1); % given in IC
                        K = 1;
                        eta = 1;

                        I_don_plot{m} = phtn2arb(I_don_plot{m},mu_y_dark,K,...
                            eta);
                        I_acc_plot{m} = phtn2arb(I_acc_plot{m},mu_y_dark,K,...
                            eta);
                        
                    case 'hirsch' % Hirsch or PGN- Model from Hirsch et al. 2011
                        % model parameters
                        mu_y_dark = noisePrm(1);
                        s_d = noisePrm(2);
                        eta = noisePrm(3);
                        CIC = noisePrm(4);
                        g = noisePrm(5); % change 2018-08-03
                        s = noisePrm(6);
                        K = g/s;

                        % Poisson noise of photo-electrons + CIC 
                        % (PC-->EC)
                        I_don_plot{m} = random('poiss', eta*I_don_plot{m}+...
                            CIC);
                        I_acc_plot{m} = random('poiss', eta*I_acc_plot{m}+...
                            CIC);

                        % Gamma amplification noise, composition 
                        % (EC)
                        I_don_plot{m} = random('gamma', I_don_plot{m}, g);
                        I_acc_plot{m} = random('gamma', I_acc_plot{m}, g);

                        % Gausian read-out noise, composition 
                        % (EC-->IC)
                        I_don_plot{m} = random('norm', I_don_plot{m}/s+...
                            mu_y_dark, s_d*g/s);
                        I_acc_plot{m} = random('norm', I_acc_plot{m}/s+...
                            mu_y_dark, s_d*g/s);

                end

                % Correction of out-of-range values.
                % Due to noise calculated values out of the detection range 0 <= 0I <= bitrate. 

                I_don_plot{m}(I_don_plot{m}<0) = 0;
                I_don_plot{m}(I_don_plot{m}>sat) = sat;

                I_acc_plot{m}(I_acc_plot{m}<0) = 0;
                I_acc_plot{m}(I_acc_plot{m}>sat) = sat;
                
                % convert to PC (IC-->PC)
                if strcmp(op_u, 'photon')
                    I_don_plot{m} = arb2phtn(I_don_plot{m},mu_y_dark,K,eta);
                    I_acc_plot{m} = arb2phtn(I_acc_plot{m},mu_y_dark,K,eta);
                end
                
                if isTr % Matlab file
                    tr_all(:,size(tr_all,2)+1:size(tr_all,2)+2) = ...
                        [I_don_plot{m} I_acc_plot{m}];
                end

                if isProcTr || isDt

                    FRET_id = discr_id{m};

                    if isProcTr
                        fName_procTraces = [pName 'traces_ASCII' ...
                            filesep fName '_mol' num2str(m) 'of'...
                            num2str(M) '.txt'];

                        str_header2 = ['coordinates \t' ...
                            num2str(crd(m,1)) ',' num2str(crd(m,2)) ...
                            '\t' num2str(crd(m,3)) ',' ...
                            num2str(crd(m,4)) '\n'];
                        
                        str_header3 = ['time(s)\tframe\tIdon noise(' ...
                            units ')\tIacc noise(' units ')\t' ...
                            'Idon ideal(' units ')\tIacc ideal(' units ...
                            ')\tFRET\tFRET ideal\tstate sequence\n']; 
                        
                        str_output = ['%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d' ...
                            '\t%d\n'];

                        timeAxis = expT*(1:size(Idon_id{m},1))';
                        timeAxis = timeAxis(1:size(Idon_id{m},1),1);
                        state_seq = discr_seq{m};
                        FRET = I_acc_plot{m}./ ...
                            (I_acc_plot{m}+I_don_plot{m});
                        
                        output = [timeAxis (1:size(Idon_id{m},1))' ...
                            I_don_plot{m}(1:size(Idon_id{m},1),1) ...
                            I_acc_plot{m}(1:size(Iacc_id{m},1),1) ...
                            Idon_id{m} Iacc_id{m} ...
                            FRET(1:size(FRET_id,1),1) FRET_id state_seq];

                        f = fopen(fName_procTraces, 'Wt');
                        fprintf(f, [str_header2 str_header3]);
                        fprintf(f, str_output, output');
                        fclose(f);
                    end

                    if isDt
                        fName_dt = cat(2,pName,'dwell-times',filesep,fName,...
                            '_mol',num2str(m),'of',num2str(M),...
                            '_FRET1to2.dt');
                        dt = res.dt_final{m};
                        for j = 1:numel(states)
                            dt(dt(:,2)==j,2) = states(j);
                            dt(dt(:,3)==j,3) = states(j);
                        end
                        f = fopen(fName_dt,'Wt');
                        fprintf(f,cat(2,'dwell-time (second)\tstate\t',...
                            'state after transition\n'));
                        fprintf(f,'%d\t%d\t%d\n',dt');
                        fclose(f);
                    end
                end
            end
            if isProcTr
                str_action = cat(2,str_action,'Traces written to files ',...
                    'in folder: ',pName,'traces_ASCII',filesep,'\n');
            end
            if isDt
                str_action = cat(2,str_action,'Dwell times written to ',...
                    'files in folder: ',pName,'dwell-times',filesep,'\n');
            end
            if isTr
                Trace_all = tr_all;
                coord = crd;
                save([pName fName_traces], 'coord', 'Trace_all', 'units');
                
                str_action = cat(2,str_action,'Traces written to Matlab ',...
                    'file: ',fName_traces,' in folder: ',pName,'\n');
            end
        end
        
        if isCrd
            
            setContPan('Write coordinates to file ...', 'process', h_fig);
            
            if ~exist([pName 'coordinates'], 'dir')
                mkdir([pName 'coordinates']);
            end
            fName_coord = [fName '.crd'];
            str_exp_coord = 'yes';
            save([pName 'coordinates' filesep fName_coord], 'crd', ...
                '-ascii');
            
            str_action = cat(2,str_action,'Molecule coordinates written ',...
                'to file: ',fName_coord,' in folder: ',pName,'coordinates',...
                filesep,'\n');
        end

        if isPrm
            
            setContPan('Write simulation parameters to file ...','process',...
                h_fig);
            
            fName_param = [fName '_param.log'];
            f = fopen([pName fName_param], 'Wt');
            fprintf(f,'VIDEO PARAMETERS\n');
            fprintf(f,cat(2,'> frame rate (s-1): ',num2str(1/expT),'\n'));
            fprintf(f, '> trace length (frame): %i\n', N);
            fprintf(f, '> movie dimension (pixels): %i,%i\n', ...
                [res_x res_y]);
            fprintf(f,cat(2,'> pixel dimension (um): ',num2str(aDim),...
                '\n'));
            fprintf(f, '> bit rate: %i\n', p.bitnr);
            if strcmp(noiseType, 'poiss')
                prm_id = [1,3,5];
                pop_id = 1;
                
            elseif strcmp(noiseType, 'norm')
                prm_id = [1,2,3,4,5];
                pop_id = 2;
                
            elseif strcmp(noiseType, 'user')
                prm_id = [1,2,3,4,5,6];
                pop_id = 3;
                
            elseif strcmp(noiseType, 'none')
                prm_id = [1,2,3];
                pop_id = 4;
                
            elseif strcmp(noiseType, 'hirsch')
                prm_id = [1,2,3,4,5,6];
                pop_id = 5;
            end
            
            str_noise = get(h.popupmenu_noiseType,'string');
            h_text = [h.text_camNoise_01,h.text_camNoise_02,...
                h.text_camNoise_03,h.text_camNoise_04,h.text_camNoise_05,...
                h.text_camNoise_06];
            
            fprintf(f, cat(2,'> camera noise model: ',str_noise{pop_id},...
                '\n'));
            for j = prm_id
                fprintf(f, cat(2,'\tparameter ',get(h_text(j),'string'),...
                    ' ',num2str(noisePrm(j)),'\n'));
            end
            
            if impPrm
                fprintf(f,'\nPRESETS\n');
                fprintf(f,'> input parameters file: %s\n',prm_file);
            end
            
            fprintf(f,'\nMOLECULES\n');
            fprintf(f, '> number of traces: %i\n', M);
            if ~isempty(crd_file)
                fprintf(f,'> input coordinates file: %s\n',crd_file);
            end
            fprintf(f, '> number of states: %i\n', J);
            if ~impPrm || (impPrm && ~isfield(p.molPrm, 'stateVal'))
                fprintf(f, '> state values:\n');
                for i = 1:J
                    fprintf(f,cat(2,'\tstate',num2str(i),': ',...
                        num2str(states(i)),', '));
                    fprintf(f,cat(2,'deviation: ',num2str(FRETw(i)),'\n'));
                end
            end
            if (~impPrm || (impPrm && ~isfield(p.molPrm, 'kx'))) && J>1
                fprintf(f, '> transitions rates (sec-1):\n');
                str_fmt = '\t%1.3f';
                for i = 2:J
                    str_fmt = [str_fmt '\t%1.3f'];
                end
                str_fmt = [str_fmt '\n'];
                fprintf(f, str_fmt, transMat(1:J, 1:J)');
            end
            if ~impPrm || (impPrm && ~isfield(p.molPrm, 'totInt'))
                
                if strcmp(ip_u,'ic')
                    [mu_y_dark,K,eta] = getCamParam(noiseType,p.camNoise);
                    totI = phtn2ele(totI,K,eta);
                    totIw = phtn2ele(totIw,K,eta);
                end
                
                fprintf(f,cat(2,'> total intensity (',ip_u,'): ',...
                    num2str(totI),', '));
                fprintf(f,cat(2,'deviation (',ip_u,'): ',num2str(totIw),...
                    '\n'));
            end
            if ~impPrm || (impPrm && ~isfield(p.molPrm, 'gamma'))
                fprintf(f,cat(2,'> gamma factor: ',num2str(gamma),', '));
                fprintf(f,cat(2,'deviation: ',num2str(gammaW),'\n'));
            end
            fprintf(f,cat(2,'> donor bleedthrough coefficient: ',...
                num2str(100*btD),'%%\n'));
            fprintf(f,cat(2,'> acceptor bleedthrough coefficient: ',...
                num2str(100*btA),'%%\n'));
            fprintf(f,cat(2,'> donor direct excitation coefficient: ',...
                num2str(100*deD),'%% of total intensity\n'));
            fprintf(f,cat(2,'> acceptor direct excitation coefficient: ',...
                num2str(100*deA),'%% of total intensity\n'));
            if bleach
                fprintf(f,cat(2,'\tphotobleaching time decay: ',...
                    num2str(bleachT),' s\n'));
            end
            
            fprintf(f,'\nEXPERIMENTAL SETUP\n');
            if ~impPrm || (impPrm && ~isfield(p.molPrm, 'psf_width'))
                if p.PSF 
                    fprintf(f,cat(2,'> donor PSF standard deviation ',...
                        '(um): ',num2str(p.PSFw(1,1)),'\n'));
                    fprintf(f,cat(2,'> acceptor PSF standard deviation ',...
                        ' (um): ',num2str(p.PSFw(1,2)),'\n'));
                end
            end
            if strcmp(ip_u,'ic')
                bgDon = phtn2ele(bgDon,K,eta);
                bgAcc = phtn2ele(bgAcc,K,eta);
            end
            fprintf(f,cat(2,'> fluorescent background intensity in donor ', ...
                'channel(',ip_u,'): ',num2str(bgDon),'\n'));
            fprintf(f,cat(2,'> fluorescent background intensity in ',...
                'acceptor channel (',ip_u,'): ',num2str(bgAcc),'\n'));
            bg_str = get(h.popupmenu_simBg_type, 'String');
            fprintf(f, '> background type: %s\n', bg_str{bgType});
            if bgType == 2
                fprintf(f,cat(2,'\tTIRF (x,y) widths (pixel): (',...
                    num2str(TIRFw(1)),',',num2str(TIRFw(2)),')\n'));
            elseif bgType == 3
                if isfield(p, 'bgImg') && ~isempty(p.bgImg)
                    fprintf(f, '\tbackground image file: %s\n', ...
                        p.bgImg.file);
                else
                    fprintf(f, '\tno background image file loaded\n');
                end
            end
            if p.bgDec
                fprintf(f,cat(2,'> background decay (s): ',num2str(cst),...
                    '\n'));
                fprintf(f,cat(2,'> initial background amplitude: ',...
                    num2str(amp),'\n'));
            end
            
            fprintf(f,'\nEXPORT OPTIONS\n');
            fprintf(f,'> export traces (in %s counts): %s\n',op_u, ...
                str_exp_traces);
            fprintf(f,'> export *.sira video: %s\n',str_exp_mov);
            fprintf(f,'> export *.avi video: %s\n',str_exp_avi);
            fprintf(f,'> export ideal traces: %s\n',str_exp_procTraces);
            fprintf(f,'> export dwell-times: %s\n',str_exp_dt);
            fprintf(f,'> export coordinates: %s\n',str_exp_coord);

            fclose(f);
            
            str_action = cat(2,str_action,'Simulation parameters written ',...
                'to file: ',fName_param,' in folder: ',pName,'\n');
        end
        
        if isTr || isMov || isProcTr || isDt || isPrm || isCrd
            str_action = cat(2,'Success: Simulated data have been ',...
                'exported to files:\n',str_action);
            setContPan(str_action, 'success', h_fig);
            
        else
            setContPan(cat(2,'Error: No saving option is defined for ',...
                'exporting data.'),'error',h_fig);
        end
            
    end
    
else
    setContPan(cat(2,'Error: The kinetic model has to be defined first\n',...
        'Push the "Generate" button first'), 'error', h_fig);
end


