function routinetest_TA_stateLifetimes(h_fig,p,prefix)
% routinetest_TA_stateLifetimes(h_fig,p,prefix)
%
% Tests transition cluster management, different dwell time histogram fitting procedures, axes export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
opt0 = [false,4,false,3,false,false,false,false,false,false,false,false];
nSpl = 5;

setDefault_TA(h_fig,p);

h = guidata(h_fig);

% start clustering
pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,[],h_fig);
V = numel(get(h.popupmenu_TA_slStates,'string'));

% test dwell time formatting
disp(cat(2,prefix,'test dwell time formatting...'));
set(h.edit_TA_slBin,'string',num2str(p.stateBin));
edit_TA_slBin_Callback(h.edit_TA_slBin,[],h_fig);

% export dwell time histograms
pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
opt = opt0;
opt(6) = true;
set_TA_expOpt(opt,h_fig);
pushbutton_expTDPopt_next_Callback({p.dumpdir,[p.exp_dt,'.dt']},[],h_fig);

for excl = [1,0]
    str_excl = '';
    if excl
        str_excl = '_excl';
    end
    set(h.checkbox_TA_slExcl,'value',excl);
    checkbox_TA_slExcl_Callback(h.checkbox_TA_slExcl,[],h_fig);
        
    for rearr = [1 0]
        str_rearr = '';
        if rearr
            str_rearr = '_rearr';
        end
        set(h.checkbox_tdp_rearrSeq,'value',rearr);
        checkbox_tdp_rearrSeq_Callback(h.checkbox_tdp_rearrSeq,[],h_fig);

        % test automated fit on all histograms
        fprintf(cat(2,prefix,'test automated histogram fit (exclude=%i,',...
            'rearrange=%i)...\n'),excl,rearr);
        expPrm = p.expPrm;
        expPrm(1) = 1;
        for v = 1:V
            set_TA_expFit(v,expPrm,p.fitPrm,h_fig);
        end
        pushbutton_TDPfit_fit_Callback(h.pushbutton_TA_slFitAll,[],h_fig);
        
        % display fit results
        test_TA_stateTransitionRates_resultDisplay(h_fig);

        % test multiple exponential fit on current histogram
        fprintf(cat(2,prefix,'test multiple exponential fit (exclude=%i,',...
            'rearrange=%i)...\n'),excl,rearr);
        expPrm = p.expPrm;
        expPrm(1) = 0;
        expPrm(2) = false;
        expPrm(3) = 2;
        set_TA_expFit(1,expPrm,p.fitPrm,h_fig);
        pushbutton_TDPfit_fit_Callback(h.pushbutton_TDPfit_fit,[],h_fig);
        
        % display fit results
        test_TA_stateTransitionRates_resultDisplay(h_fig);

        % save project
        pushbutton_TDPsaveProj_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_dec%s.mash',[str_excl,str_rearr])]},[],...
            h_fig);

        % export fitting results
        pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
        opt = opt0;
        opt(7) = true;
        set_TA_expOpt(opt,h_fig);
        pushbutton_expTDPopt_next_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_dec%s.fit',[str_excl,str_rearr])]},[],...
            h_fig);

        % test stretched exponential fit on current histogram
        fprintf(cat(2,prefix,'test stretched exponential fit (exclude=%i,',...
            'rearrange=%i)...\n'),excl,rearr);
        expPrm(1) = 0;
        expPrm(2) = true;
        set_TA_expFit(1,expPrm,p.fitPrm,h_fig);
        pushbutton_TDPfit_fit_Callback(h.pushbutton_TDPfit_fit,[],h_fig);
        
        % display fit results
        test_TA_stateTransitionRates_resultDisplay(h_fig);

        % save project
        pushbutton_TDPsaveProj_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_beta%s.mash',[str_excl,str_rearr])]},[],...
            h_fig);

        % export fitting results
        pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
        opt = opt0;
        opt(7) = true;
        set_TA_expOpt(opt,h_fig);
        pushbutton_expTDPopt_next_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_beta%s.fit',[str_excl,str_rearr])]},[],...
            h_fig);

        % test weighted bootstrap histogram fit on current histogram
        expPrm = p.expPrm;
        expPrm(1) = 0;
        expPrm(4) = true;
        expPrm(5) = true;
        expPrm(6) = nSpl;

        % test multiple exponential fit on current histogram
        fprintf(cat(2,prefix,'test weighted bootstrap multiple exponential',...
            ' fit (exclude=%i,rearrange=%i)...\n'),excl,rearr);
        expPrm(1) = 0;
        expPrm(2) = false;
        expPrm(3) = 2;
        set_TA_expFit(1,expPrm,p.fitPrm,h_fig);
        pushbutton_TDPfit_fit_Callback(h.pushbutton_TDPfit_fit,[],h_fig);
        
        % display fit results
        test_TA_stateTransitionRates_resultDisplay(h_fig);

        % save project
        pushbutton_TDPsaveProj_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_dec_wboba%s.mash',[str_excl,str_rearr])]},...
            [],h_fig);

        % export boba fitting results
        pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
        opt = opt0;
        opt(7) = true;
        opt(8) = true;
        opt(9) = true;
        set_TA_expOpt(opt,h_fig);
        pushbutton_expTDPopt_next_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_dec_wboba%s.fit',[str_excl,str_rearr])]},...
            [],h_fig);

        % test stretched exponential fit on current histogram
        fprintf(cat(2,prefix,'test weighted bootstrap stretched ',...
            'exponential fit (exclude=%i,rearrange=%i)...\n'),excl,rearr);
        expPrm(1) = 0;
        expPrm(2) = true;
        set_TA_expFit(1,expPrm,p.fitPrm,h_fig);
        pushbutton_TDPfit_fit_Callback(h.pushbutton_TDPfit_fit,[],h_fig);
        
        % display fit results
        test_TA_stateTransitionRates_resultDisplay(h_fig);

        % save project
        pushbutton_TDPsaveProj_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_beta_wboba%s.mash',[str_excl,str_rearr])]},...
            [],h_fig);

        % export fitting results
        pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
        opt = opt0;
        opt(7) = true;
        opt(8) = true;
        opt(9) = true;
        set_TA_expOpt(opt,h_fig);
        pushbutton_expTDPopt_next_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_beta_wboba%s.fit',[str_excl,str_rearr])]},...
            [],h_fig);

        % test weighted bootstrap histogram fit on current histogram
        expPrm = p.expPrm;
        expPrm(1) = 0;
        expPrm(4) = true;
        expPrm(5) = false;
        expPrm(6) = nSpl;

        % test multiple exponential fit on current histogram
        fprintf(cat(2,prefix,'test bootstrap multiple exponential fit ',...
            '(exclude=%i,rearrange=%i)...\n'),excl,rearr);
        expPrm(1) = 0;
        expPrm(2) = false;
        expPrm(3) = 2;
        set_TA_expFit(1,expPrm,p.fitPrm,h_fig);
        pushbutton_TDPfit_fit_Callback(h.pushbutton_TDPfit_fit,[],h_fig);
        
        % display fit results
        test_TA_stateTransitionRates_resultDisplay(h_fig);

        % save project
        pushbutton_TDPsaveProj_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_dec_boba%s.mash',[str_excl,str_rearr])]},...
            [],h_fig);

        % export fitting results
        pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
        opt = opt0;
        opt(7) = true;
        opt(8) = true;
        opt(9) = true;
        set_TA_expOpt(opt,h_fig);
        pushbutton_expTDPopt_next_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_dec_boba%s.fit',[str_excl,str_rearr])]},...
            [],h_fig);

        % test stretched exponential fit on current histogram
        fprintf(cat(2,prefix,'test bootstrap stretched exponential fit ',...
            '(exclude=%i,rearrange=%i)...\n'),excl,rearr);
        expPrm(1) = 0;
        expPrm(2) = true;
        set_TA_expFit(1,expPrm,p.fitPrm,h_fig);
        pushbutton_TDPfit_fit_Callback(h.pushbutton_TDPfit_fit,[],h_fig);
        
        % display fit results
        test_TA_stateTransitionRates_resultDisplay(h_fig);

        % save project
        pushbutton_TDPsaveProj_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_beta_boba%s.mash',[str_excl,str_rearr])]},...
            [],h_fig);

        % export fitting results
        pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
        opt = opt0;
        opt(7) = true;
        opt(8) = true;
        opt(9) = true;
        set_TA_expOpt(opt,h_fig);
        pushbutton_expTDPopt_next_Callback({p.dumpdir,...
            [p.exp_dt,sprintf('_beta_boba%s.fit',[str_excl,str_rearr])]},...
            [],h_fig);
    end
end

disp(cat(2,prefix,'test visualization area...'));

% test y-scale and axes export
set(h_fig,'currentaxes',h.axes_TDPplot2);
exportAxes({[p.dumpdir,filesep,p.exp_logScale]},[],h_fig);

pushbutton_TDPfit_log_Callback(h.pushbutton_TDPfit_log,[],h_fig)
set(h_fig,'currentaxes',h.axes_TDPplot2);
exportAxes({[p.dumpdir,filesep,p.exp_linScale]},[],h_fig);

% test zoom reset
ud_zoom([],[],'reset',h_fig);

pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);


function test_TA_stateTransitionRates_resultDisplay(h_fig)
h = guidata(h_fig);

% fit parameters
pushbutton_TA_fitSettings_Callback(h.pushbutton_TA_fitSettings,[],h_fig);
h = guidata(h_fig);
q = guidata(h.figure_TA_fitSettings);
V = numel(get(q.popupmenu_TA_slStates,'string'));
for v = 1:V
    set(q.popupmenu_TA_slStates,'value',v);
    popupmenu_TA_slStates_Callback(q.popupmenu_TA_slStates,[],h_fig);
    if strcmp(get(q.popupmenu_TDP_expNum,'enable'),'on')
        nExp = numel(get(q.popupmenu_TDP_expNum,'string'));
    else
        nExp = 1;
    end
    for n = 1:nExp
        set(q.popupmenu_TDP_expNum,'value',n);
        popupmenu_TDP_expNum_Callback(q.popupmenu_TDP_expNum,[],h_fig);
    end
end
close(h.figure_TA_fitSettings);

% lifetimes
V = numel(get(h.popupmenu_TA_slStates,'string'));
for v = 1:V
    set(h.popupmenu_TA_slStates,'value',v);
    popupmenu_TA_slStates_Callback(h.popupmenu_TA_slStates,[],h_fig);
    
    D = numel(get(h.popupmenu_TA_slDegen,'string'));
    for d = 1:D
        set(h.popupmenu_TA_slDegen,'value',d);
        popupmenu_TA_slDegen_Callback(h.popupmenu_TA_slDegen,[],h_fig);
        set(h.edit_TA_slTauMean,'string','');
        edit_TA_slTauMean_Callback(h.edit_TA_slTauMean,[],h_fig);
        set(h.edit_TA_slTauSig,'string','');
        edit_TA_slTauSig_Callback(h.edit_TA_slTauSig,[],h_fig);
        
        K = numel(get(h.popupmenu_TA_slTrans,'string'));
        for k = 1:K
            set(h.popupmenu_TA_slTrans,'value',k);
            popupmenu_TA_slTrans_Callback(h.popupmenu_TA_slTrans,[],h_fig);
            set(h.edit_TA_slPopMean,'string','');
            edit_TA_slPopMean_Callback(h.edit_TA_slPopMean,[],h_fig);
            set(h.edit_TA_slPopSig,'string','');
            edit_TA_slPopSig_Callback(h.edit_TA_slPopSig,[],h_fig);
        end
    end
end


