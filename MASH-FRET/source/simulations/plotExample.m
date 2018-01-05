function plotExample(h_fig)

h = guidata(h_fig);

bgDec_dir = {'decrease','decrease'};

opUnits = h.param.sim.intOpUnits;
res_x = h.param.sim.movDim(1);
res_y = h.param.sim.movDim(2);
rate = 1/h.param.sim.rate;
bgInt_don = h.param.sim.bgInt_don;
bgInt_acc = h.param.sim.bgInt_acc;
dat = h.results.sim.dat;
Idon = dat{1};
Iacc = dat{2};
coord = dat{3};
o_psf = h.param.sim.PSFw/h.param.sim.pixDim;
nbMol = size(Idon,2);
bgType = h.param.sim.bgType;
expDec = h.param.sim.bgDec;
psf = h.param.sim.PSF;
btD = h.param.sim.btD;
btA = h.param.sim.btA;
deD = h.param.sim.deD;
deA = h.param.sim.deA;
bitnr = h.param.sim.bitnr;
% camera noise
noiseType = h.param.sim.noiseType;
switch noiseType
    case 'poiss'
        noiseCamInd = 1;
    case 'norm'
        noiseCamInd = 2;
    case 'user'
        noiseCamInd = 3;
    case 'none'
        noiseCamInd = 4;
end
noisePrm = h.param.sim.camNoise(noiseCamInd,:);
gaussMat = h.param.sim.matGauss;


% Draw frame
lim_don.x = [1 round(res_x/2)]; lim_don.y = [1 res_y];
lim_acc.x = [1 res_x - round(res_x/2)]; lim_acc.y = [1 res_y];
img_don = zeros(res_y, round(res_x/2));
img_acc = zeros(res_y, res_x-round(res_x/2));
img_bg_don = img_don;
img_bg_acc = img_acc;

if nbMol
    
    % calculate fluorescent background image
    switch bgType
        case 1 % constant
            img_bg_don = bgInt_don*ones(res_y, round(res_x/2));
            img_bg_acc = bgInt_acc*ones(res_y, (res_x-round(res_x/2)));

        case 2 % TIRF profile
            TIRFdim = h.param.sim.TIRFdim;

            p.amp = bgInt_don;
            p.mu(1) = round(res_x/4);
            p.mu(2) = round(res_y/2);
            p.sig = TIRFdim;
            [img_bg_don,o] = getImgGauss(lim_don, p, 0);

            p.amp = bgInt_acc;
            [img_bg_acc,o] = getImgGauss(lim_acc, p, 0);

        case 3 % patterned
            if isfield(h.param.sim, 'bgImg') && ~isempty(h.param.sim.bgImg)
                bgImg = h.param.sim.bgImg.frameCur;
                min_s = min([size(img_bg_don);size(bgImg)],[],1);
                h_min = min_s(1); w_min = min_s(2);
                img_bg_don(1:h_min,1:w_min) = bgImg(1:h_min,1:w_min);
                min_s = min([size(img_bg_acc);size(bgImg)],[],1);
                h_min = min_s(1); w_min = min_s(2);
                img_bg_acc(1:h_min,1:w_min) = bgImg(1:h_min,1:w_min);
            else
                updateActPan('No BG pattern loaded.', h_fig, 'error');
            end
    end
    
    for n = 1:nbMol
        
        % direct excitation in % of the background
        % I_de = I + De*bg
        if n == 1
            I_don_de = Idon{n}(:,1) + deD*bgInt_don;
            I_acc_de = Iacc{n}(:,1) + deA*bgInt_acc;
        else
            I_don_de = Idon{n}(1,1) + deD*bgInt_don;
            I_acc_de = Iacc{n}(1,1) + deA*bgInt_acc;
        end
        
        % bleedthrough
        % I_bt = I_de - Bt*I_j_de
        I_don_bt = (1-btD)*I_don_de + btA*I_acc_de;
        I_acc_bt = (1-btA)*I_acc_de + btD*I_don_de;

        % add photon emission noise
        if noiseCamInd~=2
%             I_don_bt = random('norm', I_don_bt, sqrt(I_don_bt));
%             I_acc_bt = random('norm', I_acc_bt, sqrt(I_acc_bt));
            I_don_bt = random('poiss', I_don_bt);
            I_acc_bt = random('poiss', I_acc_bt);
        end

        if psf
            if size(o_psf,1)>1
                o_psf1 = o_psf(n,1); o_psf2 = o_psf(n,1);
            else
                o_psf1 = o_psf(1,1); o_psf2 = o_psf(1,2);
            end
            p_don.amp(n,1) = I_don_bt(1);
            p_don.mu(n,1) = coord(n,1);
            p_don.mu(n,2) = coord(n,2);
            p_don.sig(n,1:2) = [o_psf1 o_psf1];

            p_acc.amp(n,1) = I_acc_bt(1);
            p_acc.mu(n,1) = coord(n,3) - round(res_x/2);
            p_acc.mu(n,2) = coord(n,4);
            p_acc.sig(n,1:2) = [o_psf2 o_psf2];
        end
        if n == 1
            % add noisy fluorescent background trace
            % I_bg = I_bt + bg
            if expDec
                amp = h.param.sim.ampDec; 
                cst = h.param.sim.cstDec;
                
                if strcmp(bgDec_dir{1},'increase')
                    exp_bg_don = img_bg_don(ceil(coord(n,2)), ...
                        ceil(coord(n,1)))*(amp* ...
                        exp(-(numel(I_don_bt):-1:1)*rate/cst)+1);
                else
                    exp_bg_don = img_bg_don(ceil(coord(n,2)), ...
                        ceil(coord(n,1)))*(amp* ...
                        exp(-(1:numel(I_don_bt))*rate/cst)+1);
                end
                if strcmp(bgDec_dir{2},'increase')
                    exp_bg_acc = img_bg_acc(ceil(coord(n,4)), ...
                        ceil(coord(n,3))-round(res_x/2))*(amp* ...
                        exp(-(numel(I_acc_bt):-1:1)*rate/cst)+1);
                else
                    exp_bg_acc = img_bg_acc(ceil(coord(n,4)), ...
                        ceil(coord(n,3))-round(res_x/2))*(amp* ...
                        exp(-(1:numel(I_acc_bt))*rate/cst)+1);
                end

                img_bg_don = img_bg_don*(amp*exp(-rate/cst)+1);
                img_bg_acc = img_bg_acc*(amp*exp(-rate/cst)+1);
                
                if noiseCamInd~=2
%                     I_don_bg = I_don_bt + random('norm',exp_bg_don,sqrt(exp_bg_don))';
%                     I_acc_bg = I_acc_bt + random('norm',exp_bg_acc,sqrt(exp_bg_acc))';
                    I_don_bg = I_don_bt + random('poiss',exp_bg_don)';
                    I_acc_bg = I_acc_bt + random('poiss',exp_bg_acc)';
                else
                    I_don_bg = I_don_bt + exp_bg_don;
                    I_acc_bg = I_acc_bt + exp_bg_acc;
                end
                
            else
                if noiseCamInd~=2
%                     I_don_bg = I_don_bt + random('norm', ...
%                         repmat(img_bg_don(ceil(coord(n,2)), ...
%                         ceil(coord(n,1))),size(I_don_bt)), ...
%                         repmat(sqrt(img_bg_don(ceil(coord(n,2)), ...
%                         ceil(coord(n,1)))),size(I_don_bt)));
%                     I_acc_bg = I_acc_bt + random('norm', ...
%                         repmat(img_bg_acc(ceil(coord(n,4)), ...
%                         ceil(coord(n,3))-round(res_x/2)),size(I_acc_bt)), ...
%                         repmat(sqrt(img_bg_acc(ceil(coord(n,4)), ...
%                         ceil(coord(n,3))-round(res_x/2))),size(I_acc_bt)));
                    I_don_bg = I_don_bt + random('poiss', ...
                        repmat(img_bg_don(ceil(coord(n,2)), ...
                        ceil(coord(n,1))),size(I_don_bt)));
                    I_acc_bg = I_acc_bt + random('poiss', ...
                        repmat(img_bg_acc(ceil(coord(n,4)), ...
                        ceil(coord(n,3))-round(res_x/2)),size(I_acc_bt)));
                else
                    I_don_bg = I_don_bt + repmat(img_bg_don( ...
                        ceil(coord(n,2)),ceil(coord(n,1))), ...
                        size(I_don_bt));
                    I_acc_bg = I_acc_bt + repmat(img_bg_acc( ...
                        ceil(coord(n,4)),ceil(coord(n,3))- ...
                        round(res_x/2)),size(I_acc_bt));
                end
            end
            I_don_plot = I_don_bg;
            I_acc_plot = I_acc_bg;
        end
    end
    
    % add noisy fluorescent background image
    if noiseCamInd~=2
%         img_bg_don = random('norm',img_bg_don,sqrt(img_bg_don));
%         img_bg_acc = random('norm',img_bg_acc,sqrt(img_bg_acc));
        img_bg_don = random('poiss',img_bg_don);
        img_bg_acc = random('poiss',img_bg_acc);
    end
    if psf
        [img_don gaussMat{1}] = getImgGauss(lim_don, p_don, 1, gaussMat{1});
        [img_acc gaussMat{2}] = getImgGauss(lim_acc, p_acc, 1, gaussMat{2});
    else
        for n = 1:nbMol
            img_don(ceil(coord(n,2)),ceil(coord(n,1))) = I_don_bt(1);
            img_acc(ceil(coord(n,4)),ceil(coord(n,3))-round(res_x/2)) = ...
                I_acc_bt(1);
        end
    end
    
    img_don = img_don + img_bg_don;
    img_acc = img_acc + img_bg_acc;
    
    img = [img_don img_acc];
end

% camera noise

[o, sat] = Saturation(bitnr);
if strcmp(opUnits, 'electron')
    sat = phtn2arb(sat);
end

switch noiseType
            
    case 'poiss'
        % convert camera offset in photon count
        I_th = arb2phtn(noisePrm(1));
        
        % add noise in PC
        img = random('poiss', img+I_th);
        I_don_plot = random('poiss', I_don_plot+I_th);
        I_acc_plot = random('poiss', I_acc_plot+I_th);
        
        % convert to EC
        if strcmp(opUnits, 'electron')
            img = phtn2arb(img);
            I_don_plot = phtn2arb(I_don_plot);
            I_acc_plot = phtn2arb(I_acc_plot);
        end
        
    case 'norm'
        K = noisePrm(1);
        sig_d = noisePrm(2);
        mu_y_dark = noisePrm(3);
        sig_q = noisePrm(4);
        eta = noisePrm(6);
        
        % add dark count and convert to EC
        mu_y_img = K*eta*img + mu_y_dark; 
        mu_y_I_don = K*eta*I_don_plot + mu_y_dark;
        mu_y_I_acc = K*eta*I_acc_plot + mu_y_dark;
        
        % calculate noise width in EC
        sig_y_img = sqrt((K*sig_d)^2 + (sig_q^2) + (K^2)*eta*img);
        sig_y_Idon = sqrt((K*sig_d)^2 + (sig_q^2) + (K^2)*eta*I_don_plot);
        sig_y_Iacc = sqrt((K*sig_d)^2 + (sig_q^2) + (K^2)*eta*I_acc_plot);
        
        % add noise
        img = random('norm', mu_y_img, sig_y_img);
        I_don_plot = random('norm', mu_y_I_don, sig_y_Idon);
        I_acc_plot = random('norm', mu_y_I_acc, sig_y_Iacc);
        
        if strcmp(opUnits, 'photon')
            img = arb2phtn(img,K,eta);
            I_don_plot = arb2phtn(I_don_plot,K,eta);
            I_acc_plot = arb2phtn(I_acc_plot,K,eta);
        end
        
    case 'user'

        I_th = noisePrm(1);
        A = noisePrm(2);
        wG = noisePrm(5);
        tau = noisePrm(3);
        a = noisePrm(6);
        sig0 = noisePrm(4);

        % convert to EC
        img = phtn2arb(img);
        I_don_plot = phtn2arb(I_don_plot);
        I_acc_plot = phtn2arb(I_acc_plot);
        
        % calculate noise distribution and add noise
        img = rand_gNexp(img+I_th, A, wG, tau, a, sig0);
        I_don_plot = rand_gNexp(I_don_plot+I_th, A, wG, tau, a, sig0);
        I_acc_plot = rand_gNexp(I_acc_plot+I_th, A, wG, tau, a, sig0);
        
        if strcmp(opUnits, 'photon')
            img = arb2phtn(img);
            I_don_plot = arb2phtn(I_don_plot);
            I_acc_plot = arb2phtn(I_acc_plot);
        end
        
    case 'none'
        if strcmp(opUnits, 'electron')
            img = phtn2arb(img);
            I_don_plot = phtn2arb(I_don_plot);
            I_acc_plot = phtn2arb(I_acc_plot);
        end
        
end
img(img<0) = 0;
img(img>sat) = sat;

if nbMol > 0

    % Plot traces
    if ~(isempty(get(get(h.axes_example, 'XLabel'), 'String')) && ...
            isempty(get(get(h.axes_example, 'YLabel'), 'String')))
        fntS_y = get(get(h.axes_example, 'YLabel'), 'FontSize');
        fntS_x = get(get(h.axes_example, 'XLabel'), 'FontSize');
    end

    plot(h.axes_example, rate*(0:size(I_don_plot,1))', [I_don_plot(1); ...
        I_don_plot], '-b', rate*(0:size(I_acc_plot,1))', ...
        [I_acc_plot(1);I_acc_plot], '-r');
    set(h.axes_example, 'XLim', [0 size(I_don_plot,1)*rate], ...
        'FontUnits', 'normalized');

    if isempty(get(get(h.axes_example, 'XLabel'), 'String')) && ...
            isempty(get(get(h.axes_example, 'YLabel'), 'String'))
        xlabel(h.axes_example, 'time (sec)', 'FontUnits', 'normalized');
        ylabel(h.axes_example, [opUnits ' counts'], 'FontUnits', ...
            'normalized');
    else
        xlabel(h.axes_example, 'time (sec)', 'FontUnits', 'normalized', ...
            'FontSize', fntS_x);
        ylabel(h.axes_example, [opUnits ' counts'], 'FontUnits', ...
            'normalized', 'FontSize', fntS_y);
    end
    legend(h.axes_example, 'donor', 'acceptor');
    grid(h.axes_example, 'on');
    ylim(h.axes_example, 'auto');
end

% Plot movie frame
     
imagesc(img, 'Parent', h.axes_example_mov);
axis(h.axes_example_mov, 'image');
colorbar('delete');
h_colorbar = colorbar('peer', h.axes_example_mov);
ylabel(h_colorbar, [opUnits ' counts/time bin']);

h.param.sim.matGauss = gaussMat;
guidata(h_fig, h);




