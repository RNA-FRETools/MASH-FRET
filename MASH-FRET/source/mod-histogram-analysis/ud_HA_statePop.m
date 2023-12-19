function ud_HA_statePop(h_fig)

% update 8.4.2019 by MH: correct update of checkbox_thm_BS

% collect interface parameters
h = guidata(h_fig);
p = h.param;

h_pan = h.uipanel_HA_statePopulations;
if ~prepPanel(h_pan,h)
    % remove bold font from radiobuttons
    set([h.radiobutton_thm_gaussFit h.radiobutton_thm_thresh], ...
        'Value', 0, 'FontWeight', 'normal');
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
clr = p.thm.colList;
prm = p.proj{proj}.HA.prm{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};

if ~(isfield(prm,'plot') && size(prm.plot,2>=2) && ~isempty(prm.plot{2}))
    setProp(get(h_pan,'children'),'Enable', 'off');
    return
end

% determine whether histogram is imported from files
fromfile = isfield(p.proj{proj},'histdat') && ...
    ~isempty(p.proj{proj}.histdat);

nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
perSec = p.proj{proj}.cnt_p_sec;
expT = p.proj{proj}.frame_rate;

start = curr.thm_start;
if isfield(prm,'thm_res')
    res = prm.thm_res;
else
    res = [];
end
isInt = tpe <= 2*nChan*nExc;

meth = start{1}(1);
BOBA = start{1}(2);
rplNb = start{1}(3);
splNb = start{1}(4);
weight = start{1}(5);

% adjust parameters for imported histograms
if fromfile
    BOBA = 0;
end

set([h.checkbox_thm_BS h.radiobutton_thm_gaussFit ...
    h.radiobutton_thm_thresh], 'Enable', 'on');

set([h.edit_thm_nRep h.edit_thm_nSpl h.edit_thm_threshNb ...
    h.edit_thm_threshVal h.edit_thm_pop h.edit_thm_popSigma ...
    h.edit_thm_nGaussFit h.edit_thm_ampLow h.edit_thm_ampStart ...
    h.edit_thm_ampUp h.edit_thm_ampFit h.edit_thm_ampSigma ...
    h.edit_thm_centreLow h.edit_thm_centreStart h.edit_thm_centreUp ...
    h.edit_thm_centreFit h.edit_thm_centreSigma h.edit_thm_fwhmLow ...
    h.edit_thm_fwhmStart h.edit_thm_fwhmUp h.edit_thm_fwhmFit ...
    h.edit_thm_fwhmSigma h.edit_thm_relOccFit h.edit_thm_relOccSigma], ...
    'BackgroundColor', [1 1 1]);

switch meth
    case 1 % Gaussian fitting
        fit_start = start{3}; % [low amp., start amp., up amp., low center,
                              %  start center, up center, low FWHM, 
                              %  start FWHM, up FWHM]
        if ~isempty(res)
            fit_res = res{2,1}; % [amp. fit, amp. sigma, center fit, 
                              %  center sigma, FWHM fit, FWHM sigma, 
                              % rel. occ. fit, rel. occ. sigma]
        else
            fit_res = [];
        end
        if isInt
            if perSec
                fit_start(:,4:9) = fit_start(:,4:9)/expT;
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
        
        set(h.edit_thm_gaussClr,'backgroundcolor',clr(curr_gauss,:),...
            'enable','inactive');
        
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
        end
        
        if ~isempty(res)
            thr_res = res{1,1}; % [relative pop. sigma r g b]
        else
            thr_res = [];
        end
        
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
            set(h.edit_thm_threshclr,'backgroundcolor',clr(curr_pop,:),...
                'enable','inactive')
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



