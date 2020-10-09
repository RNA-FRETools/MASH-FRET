function routinetest_TA_stateTransitionRates(h_fig,p,prefix)
% routinetest_TA_stateTransitionRates(h_fig,p,prefix)
%
% Tests transition cluster management, different dwell time histogram fitting procedures, axes export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
opt0 = [false,4,false,3,false,false,false,false];
nSpl = 5;

setDefault_TA(h_fig,p);

h = guidata(h_fig);

% start clustering
pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,[],h_fig);

% test transition list
disp(cat(2,prefix,'test transition list...'));
K = numel(get(h.listbox_TDPtrans,'string'));
for k = 1:K
    set(h.listbox_TDPtrans,'value',k);
    listbox_TDPtrans_Callback(h.listbox_TDPtrans,[],h_fig);
end
nClr = numel(get(h.popupmenu_TDPcolour,'string'));
for clr = 1:nClr
    set(h.popupmenu_TDPcolour,'value',clr);
    popupmenu_TDPcolour_Callback(h.popupmenu_TDPcolour,[],h_fig);
end
set(h.checkbox_tdp_rearrSeq,'value',true);
checkbox_tdp_rearrSeq_Callback(h.checkbox_tdp_rearrSeq,[],h_fig);
set(h.checkbox_tdp_rearrSeq,'value',false);
checkbox_tdp_rearrSeq_Callback(h.checkbox_tdp_rearrSeq,[],h_fig);

% export dwell time histogram
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
    % test simple histogram fit
    fprintf(cat(2,prefix,'test simple histogram fit (exclude=%i)...\n'),...
        excl);

    % test multiple exponential fit
    fprintf(cat(2,prefix,'>> test multiple exponential fit (exclude=%i)',...
        '...\n'),excl);
    expPrm = p.expPrm;
    expPrm(1) = false;
    expPrm(2) = 2;
    set_TA_expFit(expPrm,p.fitPrm,h_fig);
    pushbutton_TDPfit_fit_Callback({excl},[],h_fig);
    
    % save project
    pushbutton_TDPsaveProj_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_dec%s.mash',str_excl)]},[],h_fig);

    % export fitting results
    pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
    opt = opt0;
    opt(7) = true;
    set_TA_expOpt(opt,h_fig);
    pushbutton_expTDPopt_next_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_dec%s.fit',str_excl)]},[],h_fig);
    
    % test stretched exponential fit
    fprintf(cat(2,prefix,'>> test stretched exponential fit (exclude=%i)',...
        '...\n'),excl);
    expPrm(1) = true;
    set_TA_expFit(expPrm,p.fitPrm,h_fig);
    pushbutton_TDPfit_fit_Callback({excl},[],h_fig);
    
    % save project
    pushbutton_TDPsaveProj_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_beta%s.mash',str_excl)]},[],h_fig);

    % export fitting results
    pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
    opt = opt0;
    opt(7) = true;
    set_TA_expOpt(opt,h_fig);
    pushbutton_expTDPopt_next_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_beta%s.fit',str_excl)]},[],h_fig);

    % test weighted bootstrap histogram fit
    fprintf(cat(2,prefix,'test weighted bootstrap histogram fit (exclude=',...
        '%i)...\n'),excl);
    expPrm = p.expPrm;
    expPrm(3) = true;
    expPrm(4) = true;
    expPrm(5) = nSpl;

    % test multiple exponential fit
    fprintf(cat(2,prefix,'>> test multiple exponential fit (exclude=%i)',...
        '...\n'),excl);
    expPrm(1) = false;
    expPrm(2) = 2;
    set_TA_expFit(expPrm,p.fitPrm,h_fig);
    pushbutton_TDPfit_fit_Callback({excl},[],h_fig);
    
    % save project
    pushbutton_TDPsaveProj_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_dec_wboba%s.mash',str_excl)]},[],h_fig);

    % export boba fitting results
    pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
    opt = opt0;
    opt(7) = true;
    opt(8) = true;
    opt(9) = true;
    set_TA_expOpt(opt,h_fig);
    pushbutton_expTDPopt_next_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_dec_wboba%s.fit',str_excl)]},[],h_fig);

    % test stretched exponential fit
    fprintf(cat(2,prefix,'>> test stretched exponential fit (exclude=%i)',...
        '...\n'),excl);
    expPrm(1) = true;
    set_TA_expFit(expPrm,p.fitPrm,h_fig);
    pushbutton_TDPfit_fit_Callback({excl},[],h_fig);
    
    % save project
    pushbutton_TDPsaveProj_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_beta_wboba%s.mash',str_excl)]},[],h_fig);

    % export fitting results
    pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
    opt = opt0;
    opt(7) = true;
    opt(8) = true;
    opt(9) = true;
    set_TA_expOpt(opt,h_fig);
    pushbutton_expTDPopt_next_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_beta_wboba%s.fit',str_excl)]},[],h_fig);

    % test weighted bootstrap histogram fit
    fprintf(cat(2,prefix,'test unweighted bootstrap histogram fit ',...
        '(exclude=%i)...\n'),excl);
    expPrm = p.expPrm;
    expPrm(3) = true;
    expPrm(4) = false;
    expPrm(5) = nSpl;

    % test multiple exponential fit
    fprintf(cat(2,prefix,'>> test multiple exponential fit (exclude=%i)',...
        '...\n'),excl);
    expPrm(1) = false;
    expPrm(2) = 2;
    set_TA_expFit(expPrm,p.fitPrm,h_fig);
    pushbutton_TDPfit_fit_Callback({excl},[],h_fig);
    
    % save project
    pushbutton_TDPsaveProj_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_dec_boba%s.mash',str_excl)]},[],h_fig);

    % export fitting results
    pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
    opt = opt0;
    opt(7) = true;
    opt(8) = true;
    opt(9) = true;
    set_TA_expOpt(opt,h_fig);
    pushbutton_expTDPopt_next_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_dec_boba%s.fit',str_excl)]},[],h_fig);

    % test stretched exponential fit
    fprintf(cat(2,prefix,'>> test stretched exponential fit (exclude=%i)',...
        '...\n'),excl);
    expPrm(1) = true;
    set_TA_expFit(expPrm,p.fitPrm,h_fig);
    pushbutton_TDPfit_fit_Callback({excl},[],h_fig);
    
    % save project
    pushbutton_TDPsaveProj_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_beta_boba%s.mash',str_excl)]},[],h_fig);

    % export fitting results
    pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig)
    opt = opt0;
    opt(7) = true;
    opt(8) = true;
    opt(9) = true;
    set_TA_expOpt(opt,h_fig);
    pushbutton_expTDPopt_next_Callback({p.dumpdir,...
        [p.exp_dt,sprintf('_beta_boba%s.fit',str_excl)]},[],h_fig);
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
