function [mat,tau,ip] = routine_getRates(pname,fname,Vs,h_fig)
% rates = routine_getRates(pname,fname,Js,h_fig)
%
% Analyze dwell time histograms to determine state transition rates and associated deviations
%
% pname: source directory
% fname: .mash source file name
% Js: [1-by-nJ] optimum number of states
% h_fig: handle to main figure
% mat: {1-by-nJ} final rate, transition probabilitiy, and deviations matrices with:
%  mat{j}(:,:,1): transition matrix
%  mat{j}(:,:,2): positive confidence interval of transition probabilities
%  mat{j}(:,:,3): negative confidence interval of transition probabilities
%  mat{j}(:,:,4): transition rate coefficients
%  mat{j}(:,:,5): positive confidence interval of transition rate coefficients
%  mat{j}(:,:,6): negative confidence interval of transition rate coefficients
% tau: {1-by-nJ} [2-by-J] state lifetimes (seconds)
% ip: {1-by-nJ} [2-by-J] initial state probabilities

% initialize output
nV = numel(Vs);
mat = cell(1,nV);
ip = cell(1,nV);
tau = cell(1,nV);

% defauts
tdp_dat = 3; % data to plot in TDP (FRET data)
tdp_tag = 1; % molecule tag to plot in TDP (all molecules)
excl = false; % exclude first and last dwell times in sequences
rearr = false; % re-arrange state sequences

if ~strcmp(pname(end),filesep)
    pname = [pname,filesep];
end
fname_mashIn = getCorrName([fname,'_vbFRET_%sstates.mash'],pname,h_fig);
fname_mashOut = getCorrName([fname,'_vbFRET_%sstates_mdl.mash'],pname,...
    h_fig);

% get interface parameters
h = guidata(h_fig);

disp('>> start determination of rates and associated deviations...');

% get default interface settings
p = getDef_kinsoft(pname,[]);
nMax = p.nMax; % maximum number of degenerated levels
T = p.restartNb; % number of restart

switchPan(h.togglebutton_TA,[],h_fig);
p.tdp_expOpt([7,8]) = true;
for V = 1:nV
    fprintf(cat(2,'>>>> import file ',fname_mashIn,...
    ' in Transition analysis...\n'),num2str(Vs(V)));

    % import project in TA
    pushbutton_TDPaddProj_Callback(...
        {p.dumpdir,sprintf(fname_mashIn,num2str(Vs(V)))},[],h_fig);
    
    % set TDP settings and update plot
    set_TA_TDP(tdp_dat,tdp_tag,p.tdpPrm,h_fig);
    pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);
    
    if ~strcmp(get(h.pushbutton_TDPfit_log,'string'),'y-linear scale')
        pushbutton_TDPfit_log_Callback(h.pushbutton_TDPfit_log,[],h_fig);
    end
    
    % set dwell time histogram settings
    set(h.checkbox_TA_slExcl,'value',excl);
    checkbox_TA_slExcl_Callback(h.checkbox_TA_slExcl,[],h_fig);
    set(h.checkbox_tdp_rearrSeq,'value',rearr);
    checkbox_tdp_rearrSeq_Callback(h.checkbox_tdp_rearrSeq,[],h_fig);

    % set kinetic model inferrence settings
    set(h.popupmenu_TA_mdlMeth,'value',1);
    popupmenu_TA_mdlMeth_Callback(h.popupmenu_TA_mdlMeth,[],h_fig);
    set(h.edit_TA_mdlJmax,'string',num2str(nMax));
    edit_TA_mdlJmax_Callback(h.edit_TA_mdlJmax,[],h_fig);
    set(h.edit_TA_mdlRestartNb,'string',num2str(T));
    edit_TA_mdlRestartNb_Callback(h.edit_TA_mdlRestartNb,[],h_fig);
    
    % start model inference
    pushbutton_TA_refreshModel_Callback(h.pushbutton_TA_refreshModel,[],...
        h_fig);
    
    % save project
    fprintf(cat(2,'>>>> save modificiations to file ',fname_mashOut,...
        '...\n'),num2str(Vs(V)));
    pushbutton_TDPsaveProj_Callback(...
        {p.dumpdir,sprintf(fname_mashOut,num2str(Vs(V)))},[],h_fig);
    
    % collect results
    h = guidata(h_fig);
    pTA = h.param.TDP;
    proj = pTA.curr_proj;
    tpe = pTA.curr_type(proj);
    tag = pTA.curr_tag(proj);
    expT = pTA.proj{proj}.frame_rate;
    prm = pTA.proj{proj}.prm{tag,tpe};
    mu = prm.clst_res{1}.mu{Vs(V)};
    bin = prm.lft_start{2}(3);
    nTrs = getClusterNb(Vs(V),p.clstConfig(1),p.clstConfig(2));
    [v1,v2] = getStatesFromTransIndexes(1:nTrs,Vs(V),p.clstConfig(1),...
        p.clstConfig(2));
    [stateVals,~] = binStateValues(mu,bin,[v1,v2]);

    res = prm.mdl_res;
    tp = res{1};
    dtp = res{2};
    ip{V} = res{3};
    states = res{5};
    states_id = zeros(1,numel(states));
    for i = 1:numel(states)
        states_id(i) = find(stateVals==states(i));
    end
    k = tp;
    k(~~eye(size(k,1))) = 0;
    k = k/expT;
    dk = dtp;
    for d3 = 1:size(dk,3)
        for d2 = 1:size(dk,2)
            dk(d2,d2,d3) = 0;
        end
    end
    dk = dk/expT;
    r = -log(diag(tp))'/expT;
    tau{V} = 1./r;

    % concatenate results
    mat{V} = cat(3,tp,dtp,k,dk);
    mat{V}(isnan(mat{V})) = 0;
    
    % add state indexes in first row & column
    mat{V} = cat(1,repmat(states_id,[1,1,size(mat{V},3)]),mat{V});
    mat{V} = cat(2,repmat([0,states_id]',[1,1,size(mat{V},3)]),mat{V});
    
    % add state indexes in first row
    ip{V} = cat(1,states_id,ip{V});
    tau{V} = cat(1,states_id,tau{V});
    
    % close project
    set(h.listbox_TDPprojList,'value',proj);
    listbox_TDPprojList_Callback(h.listbox_TDPprojList,[],h_fig);
    pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
end


