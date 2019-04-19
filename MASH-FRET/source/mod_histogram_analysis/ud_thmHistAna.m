function ud_thmHistAna(h_fig)

% Last update: by MH, 8.4.2019
% >> correct update of checkbox_thm_BS

h = guidata(h_fig);
p = h.param.thm;
proj = p.curr_proj;
tpe = p.curr_tpe(proj);
prm = p.proj{proj}.prm{tpe};
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
start = prm.thm_start;
res = prm.thm_res;
clr = p.colList;
perSec = p.proj{proj}.cnt_p_sec;
perPix = p.proj{proj}.cnt_p_pix;
expT = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
isInt = tpe <= 2*nChan*nExc;

meth = start{1}(1);
BOBA = start{1}(2);
rplNb = start{1}(3);
splNb = start{1}(4);
weight = start{1}(5);

set([h.checkbox_thm_BS h.radiobutton_thm_gaussFit ...
    h.radiobutton_thm_thresh], 'Enable', 'on');

set([h.edit_thm_nRep h.edit_thm_nSpl h.edit_thm_threshNb ...
    h.edit_thm_threshVal h.edit_thm_pop h.edit_thm_popSigma ...
    h.edit_thm_penalty h.edit_thm_maxGaussNb h.edit_thm_LogL ...
    h.edit_thm_BIC h.edit_thm_nGaussFit h.edit_thm_ampLow ...
    h.edit_thm_ampStart h.edit_thm_ampUp h.edit_thm_ampFit ...
    h.edit_thm_ampSigma h.edit_thm_centreLow h.edit_thm_centreStart ...
    h.edit_thm_centreUp h.edit_thm_centreFit h.edit_thm_centreSigma ...
    h.edit_thm_fwhmLow h.edit_thm_fwhmStart h.edit_thm_fwhmUp ...
    h.edit_thm_fwhmFit h.edit_thm_fwhmSigma h.edit_thm_relOccFit ...
    h.edit_thm_relOccSigma], 'BackgroundColor', [1 1 1]);

% RMSE analysis panel

rmse_start = start{4}; % [apply penalty, penalty, max. nb. of Gaussian]
rmse_res = res{3,1}; % [logL BIC]

setProp(h.uipanel_HA_stateConfiguration,'Enable', 'on');

set(h.radiobutton_thm_penalty, 'Value', rmse_start(1));
set(h.radiobutton_thm_BIC, 'Value', ~rmse_start(1));
Kmax = rmse_start(3);
set(h.edit_thm_maxGaussNb, 'String', num2str(Kmax));
if rmse_start(1)
    set(h.radiobutton_thm_penalty, 'FontWeight', 'bold');
    set(h.radiobutton_thm_BIC, 'FontWeight', 'normal');
    set(h.edit_thm_penalty, 'String', num2str(rmse_start(2)));
else
    set(h.radiobutton_thm_BIC, 'FontWeight', 'bold');
    set(h.radiobutton_thm_penalty, 'FontWeight', 'normal');
    set(h.edit_thm_penalty, 'String', '', 'Enable', 'off');
end
if ~isempty(rmse_res)
    curr_gauss = get(h.popupmenu_thm_nTotGauss, 'Value');
    if curr_gauss>Kmax
        curr_gauss = Kmax;
    end
    set(h.popupmenu_thm_nTotGauss, 'String', ...
        cellstr(num2str((1:Kmax)')), 'Value', curr_gauss);
    if ~rmse_start(1)
        [o,Kopt] = min(rmse_res(:,2));
    else
        Kopt = 1;
        for k = 2:Kmax
            if ((rmse_res(k,1)-rmse_res(k-1,1))/ ...
                    abs(rmse_res(k-1,1)))>(rmse_start(2)-1)
                Kopt = k;
            else
                break;
            end
        end
    end
    set(h.text_thm_calcNgauss, 'String', num2str(Kopt));
    set(h.edit_thm_LogL, 'String', ...
        num2str(rmse_res(curr_gauss,1)));
    if rmse_start(1)
        set([h.text_thm_BIC h.edit_thm_BIC], 'Enable', 'off');
        set(h.edit_thm_BIC, 'String', '');
    else
        set([h.text_thm_BIC h.edit_thm_BIC], 'Enable', 'on');
        set(h.edit_thm_BIC, 'String', ...
            num2str(rmse_res(curr_gauss,2)));
    end
else
    set([h.text_thm_suggNgauss h.text_thm_calcNgauss ...
        h.text_thm_for h.popupmenu_thm_nTotGauss ...
        h.text_thm_nTotGauss h.text_thm_LogL ...
        h.edit_thm_LogL h.text_thm_BIC h.edit_thm_BIC], ...
        'Enable', 'off');
    set([h.text_thm_calcNgauss h.edit_thm_LogL], 'String', '');
    set(h.popupmenu_thm_nTotGauss, 'String', {''});
end

switch meth
    case 1 % Gaussian fitting
        fit_start = start{3}; % [low amp., start amp., up amp., low center,
                              %  start center, up center, low FWHM, 
                              %  start FWHM, up FWHM]
        fit_res = res{2,1}; % [amp. fit, amp. sigma, center fit, 
                          %  center sigma, FWHM fit, FWHM sigma, 
                          % rel. occ. fit, rel. occ. sigma]
        if isInt
            if perSec
                fit_start(:,4:9) = fit_start(:,4:9)/expT;
            end
            if perPix
                fit_start(:,4:9) = fit_start(:,4:9)/nPix;
            end
        end
        
        set(h.radiobutton_thm_thresh, 'Value', 0, 'FontWeight', 'normal');
        set(h.radiobutton_thm_gaussFit, 'Value', 1, 'FontWeight', 'bold');
        
        % Gaussian fitting panel
        setProp([h.uipanel_HA_gaussianFitting,...
            h.uipanel_HA_fittingParameters],'Enable', 'on');

        K = size(fit_start,1);
        set(h.edit_thm_nGaussFit, 'String', num2str(K));
        str_gauss = ...
            cellstr([repmat('Gaussian n°:',[K,1]) num2str((1:K)')]);
        curr_gauss = get(h.popupmenu_thm_gaussNb, 'Value');
        if curr_gauss>K
            curr_gauss = K;
        end
        set(h.popupmenu_thm_gaussNb, 'String', str_gauss, 'Value', ...
            curr_gauss);
        
        set(h.edit_thm_gaussClr, 'BackgroundColor', clr(curr_gauss,:));
        
        set(h.edit_thm_ampLow, 'String', num2str(fit_start(curr_gauss,1)));
        
        set(h.edit_thm_ampStart, 'String', ...
            num2str(fit_start(curr_gauss,2)));
        
        set(h.edit_thm_ampUp, 'String', num2str(fit_start(curr_gauss,3)));
        
        set(h.edit_thm_centreLow, 'String', ...
            num2str(fit_start(curr_gauss,4)));
        
        set(h.edit_thm_centreStart, 'String', ...
            num2str(fit_start(curr_gauss,5)));
        
        set(h.edit_thm_centreUp, 'String', ...
            num2str(fit_start(curr_gauss,6)));
        
        set(h.edit_thm_fwhmLow, 'String', ...
            num2str(fit_start(curr_gauss,7)));
        
        set(h.edit_thm_fwhmStart, 'String', ...
            num2str(fit_start(curr_gauss,8)));
        
        set(h.edit_thm_fwhmUp, 'String', num2str(fit_start(curr_gauss,9)));
        
        if ~isempty(fit_res)

            if isInt
                if perSec
                    fit_res(:,3:6) = fit_res(:,3:6)/expT;
                end
                if perPix
                    fit_res(:,3:6) = fit_res(:,3:6)/nPix;
                end
            end
        
            set(h.edit_thm_ampFit, 'String', ...
                num2str(fit_res(curr_gauss,1)));
            set(h.edit_thm_centreFit, 'String', ...
                num2str(fit_res(curr_gauss,3)));
            set(h.edit_thm_fwhmFit, 'String', ...
                num2str(fit_res(curr_gauss,5)));
            set(h.edit_thm_relOccFit, 'String', ...
                num2str(fit_res(curr_gauss,7)));
            if BOBA
                set(h.edit_thm_ampSigma, 'String', ...
                    num2str(fit_res(curr_gauss,2)));
                set(h.edit_thm_centreSigma, 'String', ...
                    num2str(fit_res(curr_gauss,4)));
                set(h.edit_thm_fwhmSigma, 'String', ...
                    num2str(fit_res(curr_gauss,6)));
                set(h.edit_thm_relOccSigma, 'String', ...
                    num2str(fit_res(curr_gauss,8)));
            else
                set([h.text_thm_sigma h.edit_thm_ampSigma ...
                    h.edit_thm_centreSigma h.edit_thm_fwhmSigma ...
                    h.edit_thm_relOccSigma], 'Enable', 'off');
                set([h.edit_thm_ampSigma h.edit_thm_centreSigma ...
                    h.edit_thm_fwhmSigma h.edit_thm_relOccSigma], ...
                    'String', '');
            end
        else
            set([h.text_thm_fit h.text_thm_sigma h.edit_thm_ampFit ...
                h.edit_thm_ampSigma h.edit_thm_centreFit ...
                h.edit_thm_centreSigma h.edit_thm_fwhmFit ...
                h.edit_thm_fwhmSigma h.text_thm_relOcc ...
                h.edit_thm_relOccFit h.edit_thm_relOccSigma], 'Enable', ...
                'off');
            set([h.edit_thm_ampFit h.edit_thm_ampSigma ...
                h.edit_thm_centreFit h.edit_thm_centreSigma ...
                h.edit_thm_fwhmFit h.edit_thm_fwhmSigma ...
                h.edit_thm_relOccFit h.edit_thm_relOccSigma], 'String', ...
                '');
        end
        
        % Threshold panel
        setProp(h.uipanel_HA_thresholding, 'Enable', 'off');
        set([h.edit_thm_threshNb h.edit_thm_threshVal h.edit_thm_pop ...
            h.edit_thm_popSigma], 'String', '');
        set([h.popupmenu_thm_pop h.popupmenu_thm_thresh], 'String', ...
            {''}, 'Value', 1);
        
    case 2 % Threshold
        thresh = start{2}; % threshold values
        
        if isInt
            if perSec
                thresh = thresh/expT;
            end
            if perPix
                thresh = thresh/nPix;
            end
        end
        
        thr_res = res{1,1}; % [relative pop. sigma r g b]
        
        set(h.radiobutton_thm_gaussFit, 'Value', 0, 'FontWeight', ...
            'normal');
        set(h.radiobutton_thm_thresh, 'Value', 1, 'FontWeight', 'bold');
        
        % Gaussian fitting panels
        setProp([h.uipanel_HA_gaussianFitting,...
            h.uipanel_HA_fittingParameters],'Enable', 'off');
        set([h.edit_thm_nGaussFit h.edit_thm_ampLow ...
            h.edit_thm_ampStart h.edit_thm_ampUp h.edit_thm_ampFit ...
            h.edit_thm_ampSigma h.edit_thm_centreLow ...
            h.edit_thm_centreStart h.edit_thm_centreUp ...
            h.edit_thm_centreFit h.edit_thm_centreSigma ...
            h.edit_thm_fwhmLow h.edit_thm_fwhmStart h.edit_thm_fwhmUp ...
            h.edit_thm_fwhmFit h.edit_thm_fwhmSigma ...
            h.edit_thm_relOccFit h.edit_thm_relOccSigma], 'String', '');
        set(h.popupmenu_thm_gaussNb, 'String', {''});
        
        % Threshold panel
        K = size(thresh,1)+1;
        setProp(h.uipanel_HA_thresholding, 'Enable', 'on');
        set(h.edit_thm_threshNb, 'String', num2str(K-1));
        curr_thr = get(h.popupmenu_thm_thresh, 'Value');
        if curr_thr>K-1
            curr_thr = K-1;
        end
        str_thr = ...
            cellstr([repmat('Threshold n°:',[K-1,1]) num2str((1:K-1)')]);
        set(h.popupmenu_thm_thresh, 'String', str_thr, 'Value', curr_thr);
        set(h.edit_thm_threshVal, 'String', num2str(thresh(curr_thr)));
        if ~isempty(thr_res)
            curr_pop = get(h.popupmenu_thm_pop, 'Value');
            if curr_pop>K
                curr_pop = K;
            end
            str_pop = ...
                cellstr([repmat('Population n°:',[K,1]) num2str((1:K)')]);
            set(h.popupmenu_thm_pop, 'String', str_pop, 'Value', curr_pop);
            set(h.edit_thm_pop, 'String', num2str(thr_res(curr_pop,1)));
            if BOBA
                set(h.edit_thm_popSigma, 'String', ...
                    num2str(thr_res(curr_pop,2)));
            else
                set(h.edit_thm_popSigma, 'String', '');
                set([h.text_thm_popSigma h.edit_thm_popSigma], ...
                    'Enable', 'off');
            end
            set(h.edit_thm_threshclr, 'BackgroundColor', clr(curr_pop,:))
        else
            set([h.text_thm_relOccThr h.popupmenu_thm_pop ...
                h.text_thm_pop h.edit_thm_pop h.text_thm_popSigma ...
                h.edit_thm_popSigma h.text_thm_threshclr ...
                h.edit_thm_threshclr], 'Enable', 'off');
            set(h.popupmenu_thm_pop, 'String', {''});
            set([h.edit_thm_pop h.edit_thm_popSigma], 'String', '');
        end
end

% BOBA panel

% added by MH, 8.4.2019
set(h.checkbox_thm_BS, 'Value', BOBA);

if BOBA
    set([h.text_thm_nRep h.edit_thm_nRep h.text_thm_nSpl ...
        h.edit_thm_nSpl h.checkbox_thm_weight], 'Enable', 'on')
    
    % cancelled by MH, 8.4.2019
%     set(h.checkbox_thm_BS, 'Value', BOBA);

    set(h.edit_thm_nRep, 'String', num2str(rplNb));
    set(h.edit_thm_nSpl, 'String', num2str(splNb));
    set(h.checkbox_thm_weight, 'Value', weight);
else
    set([h.text_thm_nRep h.edit_thm_nRep h.text_thm_nSpl ...
        h.edit_thm_nSpl h.checkbox_thm_weight], 'Enable', 'off')
    set([h.edit_thm_nRep h.edit_thm_nSpl], 'String', '');
end



