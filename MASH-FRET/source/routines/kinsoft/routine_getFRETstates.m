function states = routine_getFRETstates(pname,fname,Js,gaussNoise,h_fig)
% states = routine_getFRETstates(pname,fname,Js,gaussNoise,h_fig)
%
% Analyze data of Kinsoft challenge to find FRET states and associated deviations
%
% pname: source directory
% fname: .mash source file name
% Js: [1-by-nJ] optimum number of states
% gaussNoise: noise in FRET trajectories in Gaussian-distributed
% h_fig: handle to main figure
% states: {1-by-nJ} [J-by-2] FRET states and associated deviations

% initialize output
states = {};

% defauts
if gaussNoise
    meth = 2; % 1D-vbFRET (Gaussian noise)
    str_meth = 'vbFRET';
else
    meth = 6; % STaSI (other noise)
    str_meth = 'STaSI';
end
Jmin = 1; % minimum number of states to find in traces
iter = 10; % number of vbFRET iterations
trace = 1; % index in list of traces to apply state finding algorithm to (bottom traces)
deblurr = true; % activate "deblurr" option
tdp_dat = 3; % data to plot in TDP (FRET data)
tdp_tag = 1; % molecule tag to plot in TDP (all molecules)
shape = 2; % gaussian cluster shape (straight multivariate)

if ~strcmp(pname(end),filesep)
    pname = [pname,filesep];
end
fname_mashIn = getCorrName([fname,'_STaSI.mash'],pname,h_fig);
fname_mashOut = getCorrName([fname,'_vbFRET_%sstates.mash'],pname,h_fig);
fname_clst = getCorrName([fname,'_vbFRET_%sstates.clst'],pname,h_fig);
fname_tdpImg = getCorrName([fname,'_vbFRET_%sstates_TDP.png'],pname,h_fig);
fname_clstImg = getCorrName([fname,'_vbFRET_%sstates_clust.png'],pname,...
    h_fig);

% get default interface
h = guidata(h_fig);

disp('>> start determination of FRET states and associated deviations...');

% get default interface settings
p = getDef_kinsoft(pname,[]);

disp(cat(2,'>>>> import ',fname_mashIn,' in Trace processing...'));

% set options for ASCII file import
switchPan(h.togglebutton_TP,[],h_fig);
pushbutton_addTraces_Callback({p.dumpdir,fname_mashIn},[],h_fig);

disp(['>>>> process single FRET traces with ',str_meth,'...']);

% set interface to default values
setDef_kinsoft_TP(p,h_fig);

% configure state finding algorithm to vbFRET
for Jmax = Js
    fprintf('>>>>>> process with Jmax=%i...\n',Jmax);
    
    if meth==2 % vbFRET
        p.fsPrm(meth,1,:) = Jmin;
        p.fsPrm(meth,2,:) = Jmax;
        p.fsPrm(meth,3,:) = iter;
    else % STaSI
        p.fsPrm(meth,1,:) = Jmax;
    end
    p.fsPrm(meth,7,:) = deblurr;
    set_TP_findStates(meth,trace,p.fsPrm,p.fsThresh,p.nChan,p.nL,h_fig);
    pushbutton_applyAll_DTA_Callback(h.pushbutton_applyAll_DTA,[],h_fig);

    % process traces
    pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

    fprintf(...
        cat(2,'>>>>>> save modificiations in file ',fname_mashOut,'...\n'),...
        num2str(Jmax));
    
    % save modifications to mash file
    p.projOpt.proj_title = [fname,'_vbFRET_',num2str(Jmax),'states'];
    set_VP_projOpt(p.projOpt,p.wl(1:p.nL),h.pushbutton_editParam,h_fig);
    pushbutton_expProj_Callback(...
        {p.dumpdir,sprintf(fname_mashOut,num2str(Jmax))},[],h_fig);
end
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

switchPan(h.togglebutton_TA,[],h_fig);
p.tdp_expOpt(5) = true;
for Jmax = Js
    fprintf(cat(2,'>>>> import file ',fname_mashOut,...
        ' in Transition analysis...\n'),num2str(Jmax));

    % import project in TA
    pushbutton_TDPaddProj_Callback(...
        {p.dumpdir,sprintf(fname_mashOut,num2str(Jmax))},[],h_fig);

    disp('>>>> build TDP...');

    % set TDP settings and update plot
    set_TA_TDP(tdp_dat,tdp_tag,p.tdpPrm,h_fig);
    pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);
    pushbutton_TDPresetClust_Callback(h.pushbutton_TDPresetClust,[],h_fig)
    
    fprintf(cat(2,'>>>> export screenshot of TDP to file ',fname_tdpImg,...
        '\n'),num2str(Jmax));
    
    % export a screenshot of TDP
    set(h_fig, 'CurrentAxes',h.axes_TDPplot1);
    exportAxes({[p.dumpdir,filesep,sprintf(fname_tdpImg,num2str(Jmax))]},...
        [],h_fig);

    disp('>>>> cluster transitions with Gaussian mixtures...');

    % set clustering settings and cluster transitions
    p.clstMethPrm(1) = Jmax;
    p.clstConfig(4) = shape;
    set_TA_stateConfig(p.clstMeth,p.clstMethPrm,p.clstConfig,p.clstStart,...
        h_fig);
    pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,[],h_fig);
    
    % recover results
    h = guidata(h_fig);
    q = h.param.TDP;
    proj = q.curr_proj;
    tpe = q.curr_type(proj);
    tag = q.curr_tag(proj);
    prm = q.proj{proj}.prm{tag,tpe};
    res = prm.clst_res{1};
    mu = res.mu{Jmax};
    bin = prm.lft_start{2}(3);
    K = getClusterNb(Jmax,p.clstConfig(1),p.clstConfig(2));
    [j1,j2] = getStatesFromTransIndexes(1:K,Jmax,p.clstConfig(1),...
        p.clstConfig(2));
    [stateVals,jbin] = binStateValues(mu,bin,[j1,j2]);
    V = size(stateVals,1);
    states_J = [stateVals,zeros(V,1)];
    for v = 1:V
        ox = [];
        oy = [];
        for j = jbin{v}
            ox = cat(2,ox,mean(sqrt(res.o{Jmax}(1,1,j1==j & j2~=j))));
            oy = cat(2,oy,mean(sqrt(res.o{Jmax}(2,2,j2==j & j1~=j))));
        end
        states_J(v,2) = mean([ox,oy]);
    end
    states = cat(2,states,states_J);
    
    fprintf(...
        cat(2,'>>>> export gaussian parameters to file ',fname_clst,' and',...
        'clusters screenshot to file ',fname_clstImg,'\n'),num2str(Jmax));
    
    % export gaussian mixture to .clst files
    str_states = get(h.popupmenu_tdp_model,'string');
    popval = find(~cellfun('isempty',strfind(str_states,num2str(Jmax))));
    set(h.popupmenu_tdp_model,'value',popval);
    popupmenu_tdp_model_Callback(h.popupmenu_tdp_model,[],h_fig);

    pushbutton_tdp_impModel_Callback(h.pushbutton_tdp_impModel,[],h_fig);

    pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig);
    set_TA_expOpt(p.tdp_expOpt,h_fig);
    pushbutton_expTDPopt_next_Callback(...
        {p.dumpdir,sprintf(fname_clst,num2str(Jmax))},[],h_fig);
    
    % export a screenshot of clustering
    set(h_fig, 'CurrentAxes',h.axes_TDPplot1);
    exportAxes({[p.dumpdir,filesep,sprintf(fname_clstImg,num2str(Jmax))]},...
        [],h_fig);
    
    fprintf(...
        cat(2,'>>>> save modificiations to file ',fname_mashOut,'...\n'),...
        num2str(Jmax));
    pushbutton_TDPsaveProj_Callback(...
        {p.dumpdir,sprintf(fname_mashOut,num2str(Jmax))},[],h_fig);
    
    
    set(h.listbox_TDPprojList,'value',1);
    listbox_TDPprojList_Callback(h.listbox_TDPprojList,[],h_fig);
    pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
end

