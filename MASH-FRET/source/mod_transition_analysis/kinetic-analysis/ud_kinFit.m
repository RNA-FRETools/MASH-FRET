function ud_kinFit(h_fig)
% Set properties of all controls in panel "Transition rates" to proper 
% values and refresh associated plots.
%
% h_fig: handle to main figure

% Last update by MH, 12.12.2019
% >> move script that plots boba fret icon from here to 
%  buildPanelTAstateTransitionRates.m (plot is now done only once when 
%  building GUI)
%
% update by MH, 6.12.2019
% >> cancel axes clearance to keep the properties set originally.

%% collect parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
prm = p.proj{proj}.prm{tpe};
clust_res = prm.clst_res;

if ~isempty(clust_res{1})
    
    curr_k = prm.clst_start{1}(4);
    kin_start = prm.kin_start(curr_k,:);
    kin_res = prm.kin_res;
    stchExp = kin_start{1}(1);
    if stchExp
        curr_exp = 1;
        nExp = 1;
    else
        curr_exp = kin_start{1}(3);
        nExp = kin_start{1}(2);
    end
    boba = kin_start{1}(4);
    amp_prm = kin_start{2}(curr_exp,1:3);
    dec_prm = kin_start{2}(curr_exp,4:6);
    beta_prm = kin_start{2}(curr_exp,7:9);
    
    %% build exponential list
    str_e = cell(1,nExp);
    for i = 1:nExp
        str_e{i} = sprintf('exponential n°:%i', i);
    end

    %% set general parameters
    set([h.radiobutton_TDPstretch h.radiobutton_TDPmultExp ...
        h.checkbox_BOBA h.pushbutton_TDPfit_fit ...
        h.text_TDPfit_amp h.text_TDPdec_amp h.text_TDPfit_lower ...
        h.text_TDPfit_start  h.text_TDPfit_upper h.edit_TDPfit_aLow ...
        h.edit_TDPfit_aStart h.edit_TDPfit_aUp h.edit_TDPfit_decLow ...
        h.edit_TDPfit_decStart h.edit_TDPfit_decUp ...
        h.pushbutton_TDPfit_log], 'Enable', 'on');
    
    if stchExp
        set([h.text_TDPfit_beta h.edit_TDPfit_betaLow ...
            h.edit_TDPfit_betaStart h.edit_TDPfit_betaUp], 'Enable', 'on');
        set([h.edit_TDP_nExp h.popupmenu_TDP_expNum], 'Enable', 'off');
    else
        set([h.text_TDPfit_beta h.edit_TDPfit_betaLow ...
            h.edit_TDPfit_betaStart h.edit_TDPfit_betaUp], 'Enable', ...
            'off');
        set([h.edit_TDP_nExp h.popupmenu_TDP_expNum], 'Enable', 'on');
    end
    
    set([h.edit_TDP_nExp h.edit_TDPfit_aLow h.edit_TDPfit_aStart ...
        h.edit_TDPfit_aUp h.edit_TDPfit_decLow h.edit_TDPfit_decStart ...
        h.edit_TDPfit_decUp h.edit_TDPbsprm_01 h.edit_TDPbsprm_02 ...
        h.edit_TDPfit_betaLow h.edit_TDPfit_betaStart ...
        h.edit_TDPfit_betaUp], 'BackgroundColor', [1 1 1]);
    
    set(h.radiobutton_TDPstretch, 'Value', stchExp);
    set(h.radiobutton_TDPmultExp, 'Value', ~stchExp);
    J = clust_res{3};
    k = 0;
    for j1 = 1:J
        for j2 = 1:J
            if j2 ~= j1
                k = k+1;
                if curr_k == k
                    mu1 = round(100*clust_res{1}.mu{J}(j1,1))/100;
                    mu2 = round(100*clust_res{1}.mu{J}(j2,1))/100;
                    break;
                end
            end
        end
    end
    set(h.edit_TDP_nExp, 'String', num2str(nExp));
    set(h.popupmenu_TDP_expNum, 'Value', curr_exp, 'String', str_e);
    set(h.checkbox_BOBA, 'Value', boba);
    
    if boba
        set([h.text_bs_nRep h.edit_TDPbsprm_01 h.text_bs_nSamp ...
            h.edit_TDPbsprm_02, h.checkbox_bobaWeight], 'Enable', 'on');
        n_rep = kin_start{1}(5);
        n_spl = kin_start{1}(6);
        w = kin_start{1}(7);
        set(h.edit_TDPbsprm_01, 'String', num2str(n_rep));
        set(h.edit_TDPbsprm_02, 'String', num2str(n_spl));
        set(h.checkbox_bobaWeight, 'Value', w);
    else
        set([h.text_bs_nRep h.edit_TDPbsprm_01 h.text_bs_nSamp ...
            h.edit_TDPbsprm_02 h.checkbox_bobaWeight], 'Enable', 'off');
    end
    
    set(h.edit_TDPfit_aLow, 'String', num2str(amp_prm(1)));
    set(h.edit_TDPfit_aStart, 'String', num2str(amp_prm(2)));
    set(h.edit_TDPfit_aUp, 'String', num2str(amp_prm(3)));
    set(h.edit_TDPfit_decLow, 'String', num2str(dec_prm(1)));
    set(h.edit_TDPfit_decStart, 'String', num2str(dec_prm(2)));
    set(h.edit_TDPfit_decUp, 'String', num2str(dec_prm(3)));
    set(h.edit_TDPfit_betaLow, 'String', num2str(beta_prm(1)));
    set(h.edit_TDPfit_betaStart, 'String', num2str(beta_prm(2)));
    set(h.edit_TDPfit_betaUp, 'String', num2str(beta_prm(3)));
    
    %% set results
    if size(kin_res,1)>=curr_k && ~isempty(kin_res{curr_k,2})
        kin_k = kin_res(curr_k,:);
        if boba && size(kin_k{1},2)>=4
            amp_res = kin_k{1}(curr_exp,1:2);
            dec_res = kin_k{1}(curr_exp,3:4);
        else
            amp_res = kin_k{2}(curr_exp,1);
            dec_res = kin_k{2}(curr_exp,2);
        end
        set(h.text_TDPfit_res, 'Enable', 'on');
        set([h.edit_TDPfit_aRes h.edit_TDPfit_decRes], 'Enable', ...
            'on', 'BackgroundColor', [0.75 1 0.75]);
        set(h.edit_TDPfit_aRes, 'String', num2str(amp_res(1)));
        set(h.edit_TDPfit_decRes, 'String', num2str(dec_res(1)));
        
        if stchExp && ((boba && size(kin_k{1},2)>=6) || ...
                (~boba && size(kin_k{2}(1,:),2)>=3))
            if boba
                beta_res = kin_k{1}(1,5:6);
            else
                beta_res = kin_k{2}(1,3);
            end
            set(h.edit_TDPfit_betaRes, 'Enable', 'on', ...
                'BackgroundColor', [0.75 1 0.75], 'String', ...
                num2str(beta_res(1)));
            if boba
                set(h.edit_TDPfit_betaBs, 'Enable', 'on', ...
                    'BackgroundColor', [0.75 1 0.75], 'String', ...
                    num2str(beta_res(2)));
            else
                set(h.edit_TDPfit_betaBs, 'Enable', 'off', 'String', '');
            end
            
        else
            set([h.edit_TDPfit_betaRes h.edit_TDPfit_betaBs], 'Enable', ...
                'off', 'String', '');
        end
        
        if boba && size(kin_k{1},2)>=4
            set(h.text_TDPfit_bsRes, 'Enable', 'on');
            set([h.edit_TDPfit_ampBs h.edit_TDPfit_decBs], 'Enable', ...
                'on', 'BackgroundColor', [0.75 1 0.75]);
            set(h.edit_TDPfit_decBs, 'String', num2str(dec_res(2)));
            set(h.edit_TDPfit_ampBs, 'String', num2str(amp_res(2)));
            
        else
            set([h.text_TDPfit_bsRes h.edit_TDPfit_ampBs ...
                h.edit_TDPfit_decBs], 'Enable', 'off');
            set([h.edit_TDPfit_ampBs h.edit_TDPfit_decBs], 'String', '');
        end
        
    else
        kin_k = [];
        
        set([h.text_TDPfit_res h.edit_TDPfit_aRes h.edit_TDPfit_decRes ...
            h.edit_TDPfit_betaRes h.text_TDPfit_bsRes ...
            h.edit_TDPfit_ampBs h.edit_TDPfit_decBs ...
            h.edit_TDPfit_betaBs], 'Enable', 'off');
        set([h.edit_TDPfit_aRes h.edit_TDPfit_decRes ...
            h.edit_TDPfit_betaRes h.edit_TDPfit_ampBs ...
            h.edit_TDPfit_decBs h.edit_TDPfit_betaBs], 'String', '');
    end
    
    act = get(h.pushbutton_TDPfit_log, 'String');
    if strcmp(act, 'y-log scale')
        scl = 'linear';
    elseif strcmp(act, 'y-linear scale')
        scl = 'log';
    end
    k = 0;
    for j1 = 1:J
        for j2 = 1:J
            if j1 ~= j2
                k = k + 1;
            end
            if k == curr_k
                break;
            end
        end
        if k == curr_k
            break;
        end
    end
    
    excl = prm.kin_start{curr_k,1}(8);
    
    clust_k = clust_res{1}.clusters{J}(clust_res{1}.clusters{J}(:,7)==j1 & ...
        clust_res{1}.clusters{J}(:,8)==j2,:);
    
    if size(clust_k,1)>1
        wght = kin_start{1}(7);
        mols = unique(clust_res{1}.clusters{J}(:,4));
        hst = getDtHist(clust_res{1}.clusters{J}, [j1,j2], mols, excl, wght);
        plotKinFit(h.axes_TDPplot2, hst, kin_k, boba, scl, stchExp);
    else
        cla(h.axes_TDPplot2);
    end
    
else
    setProp(get(h.uipanel_TA_stateTransitionRates, 'Children'), 'Enable', ...
        'off');
    set(h.popupmenu_TDP_expNum, 'Value', 1, 'String', {''});
    
    % cancelled by MH, 6.12.2019
%     cla(h.axes_TDPplot2);

    set(h.axes_TDPplot2, 'Visible', 'off');
    
    % cancelled by MH, 12.12.2019
%     [ico_pth,o,o] = fileparts(mfilename('fullpath'));
% 
%     if exist([ico_pth filesep 'boba.png'], 'file')
%         try
%             ico_boba = imread([ico_pth filesep 'boba.png']);
%             ico_boba = repmat(ico_boba, [1 1 3]);
%             image(ico_boba, 'Parent', h.axes_TDPplot3);
%             axis(h.axes_TDPplot3, 'image');
%             set(h.axes_TDPplot3, 'Visible', 'on', 'XTick', [], 'YTick', ...
%                 []);
%             
%         catch err
%             
%             % cancelled by MH, 6.12.2019
% %             cla(h.axes_TDPplot3);
% 
%             set(h.axes_TDPplot3, 'Visible', 'off');
%             return;
%         end
%     end
end

