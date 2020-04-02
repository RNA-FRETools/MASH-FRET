function [TDPs,logL,expIniProb] = routine_backSim(pname,fname,Js,states,mat,prob0,h_fig)
% [TDPs,logL,expIniProb] = routine_backSim(pname,fname,Js,states,mat,prob0,h_fig)
%
% Commpare the selected models to simulation and determine the best fit
%
% pname: source directory
% fname: .mash source file name
% Js: [1-by-nJ] optimum number of states
% states: {1-by-nJ} [J-by-2] FRET states and associated deviations
% mat: {1-by-nJ} final rate, transition probabilitiy, and deviations matrices with:
%  mat{j}(:,:,1): restricted rates (from dwell times)
%  mat{j}(:,:,2): restricted rate deviations
%  mat{j}(:,:,3): transition porbabilities (weighing factors * exponential contribution)
%  mat{j}(:,:,4): transition porbability deviaitions
%  mat{j}(:,:,5): unrestricted rates (weighed by transition prob.)
%  mat{j}(:,:,6): unrestricted rate deviations
% prob0: {1-by-nJ} [1-by-J] initial state probabilities
% h_fig: handle to main figure
% TDPs: Transition density plots such as:
%  TDPs(:,:,1): experimental TDP
%  TDPs(:,:,2:(nJ+1)): simulated TDPs ordered as Js
% logL: [1-by-nJ] log likelihoods
% expIniProb: (1) use experimental initial probabilties, (0) otherwise

% defaults
expIniProb = false; % use experimental inital probabilities
expopt = [0,0,0,1,0,1,0];
noiseType = {'poiss','norm','user','none','hirsch'};
tdp_dat = 3; % data to plot in TDP (FRET data)
tdp_tag = 1; % molecule tag to plot in TDP (all molecules)
gconv = true; % apply Gaussian fitler to TDP

% get interface parameters
h = guidata(h_fig);

% get default interface parameters
p = getDef_kinsoft(pname,[]);

dir_ascii = cat(2,p.dumpdir,filesep,'traces_ASCII',filesep);
files_ascii = getCorrName([fname,'_sim_%sstates'],pname,h_fig);
fname_presets = getCorrName([fname,'_%states_presets.mat'],pname,h_fig);
fname_mashIn = getCorrName([fname,'_STaSI.mash'],pname,h_fig);
fname_tdpImg = getCorrName([fname,'_sim_TDP_%sstates.png'],pname,h_fig);
fname_mashOut = getCorrName([fname,'_sim_%sstates.mash'],pname,h_fig);

disp('>> start model selection using simulation...');

disp('>>>> get TDP from reference traces in Transition analysis...');

% get reference TDP
switchPan(h.togglebutton_TA,[],h_fig);
pushbutton_TDPaddProj_Callback({p.dumpdir,fname_mashIn},[],h_fig);
    
% set TDP settings and update plot
set_TA_TDP(tdp_dat,tdp_tag,p.tdpPrm,h_fig);
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

% recover TDP
h = guidata(h_fig);
q_tp = h.param.TDP;
proj = q_tp.curr_proj;
tag = q_tp.curr_tag(proj);
tpe = q_tp.curr_type(proj);
prm = q_tp.proj{proj}.prm{tag,tpe};
TDPs = prm.plot{2};

if gconv
    TDPs = gconvTDP(TDPs,p.tdpPrm([1,3]),p.tdpPrm(2));
end
if sum(sum(TDPs))>0
    TDPs = TDPs/sum(sum(TDPs));
end

pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);

for j = 1:numel(Js)
        
    fprintf(cat(2,'>>>> determine simulation parameters from experimental',...
        ' data for J=%i...\n'),Js(j));
    
    % collect TP experimental data
    switchPan(h.togglebutton_TP,[],h_fig);
    pushbutton_addTraces_Callback({p.dumpdir,fname_mashIn},[],h_fig);
    
    h = guidata(h_fig);
    q_tp = h.param.ttPr;
    proj = q_tp.curr_proj;
    Idon = q_tp.proj{proj}.intensities_denoise(:,1:2:end,1);
    Iacc = q_tp.proj{proj}.intensities_denoise(:,2:2:end,1);
    expT = q_tp.proj{proj}.frame_rate;

    pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
    
    % calculate simulation parameters
    Itot = Iacc+Idon;
    [o,K,eta] = getCamParam(noiseType{p.camnoise},p.camprm);
    Itot = arb2phtn(Itot,0,K,eta);
    
    incl = ~isnan(Itot);
    N = size(Itot,2);
    Ls = sum(incl,1);
    Imean = nanmean(Itot,1);
    k0 = mat{j}(:,:,1);
    prob = mat{j}(:,:,3);
    states_id = k0(1,2:end,1);
    
    fprintf(cat(2,'>>>> export simulation presets to file ',fname_presets,...
        '\n'),num2str(Js(j)));
    
    tot_intensity = repmat([mean(Imean),std(Imean)],N,1);
    FRET = repmat(states{j}(states_id,:),[1,1,N]);
    trans_rates = repmat(k0(2:end,2:end,1),[1,1,N]);
    trans_prob = repmat(prob(2:end,2:end,1),[1,1,N]);
    if expIniProb
        ini_prob = repmat(prob0{j}(2,:),[N,1]);
        % create preset file
        save([p.dumpdir,filesep,sprintf(fname_presets,num2str(Js(j)))],...
            'FRET','trans_rates','tot_intensity','trans_prob','ini_prob',...
            '-mat');
    else
        % create preset file
        save([p.dumpdir,filesep,sprintf(fname_presets,num2str(Js(j)))],...
            'FRET','trans_rates','tot_intensity','trans_prob','-mat');
    end

    switchPan(h.togglebutton_S,[],h_fig);
    
    fprintf('>>>> simulate model with J=%i...\n',Js(j));
    
    % update default interface settings
    p.L = max(Ls);
    p.rate = 1/expT;
    p.t_bleach = mean(Ls)*expT;
    
    setDefault_S(h_fig,p);
    
    fprintf(cat(2,'>>>> export simulated traces to ASCII files ',...
        files_ascii,'_mol[n]of[N].txt\n'),num2str(Js(j)));
    
    % import presets
    pushbutton_simImpPrm_Callback(...
        {p.dumpdir,sprintf(fname_presets,num2str(Js(j)))},[],h_fig);
    
    % simulate state sequences
    pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);
    
    % recover simulation results and remove blurr states
    h = guidata(h_fig);
    q_tp = h.results.sim;
    for n = 1:numel(q_tp.dat_id{3})
        incl = q_tp.dat_id{3}{n}>0;
        q_tp.dat_id{3}{n}(incl) = deblurrSeq(q_tp.dat_id{3}{n}(incl));
    end
    h.results.sim = q_tp;
    guidata(h_fig,h);
    
    % export ASCII traces and log file
    set_S_fileExport(expopt,h_fig);
    pushbutton_exportSim_Callback(...
        {p.dumpdir,sprintf(files_ascii,num2str(Js(j)))},[],h_fig);
    
    fprintf(cat(2,'>>>> get TDP from simulated traces with J=%i in ',...
        'Transition analysis...\n'),Js(j));
    
    % set options for ASCII file import 
    switchPan(h.togglebutton_TA,[],h_fig);
    
    p.asciiOpt.intImp{1}(1) = 3;
    p.asciiOpt.intImp{1}(5) = 3;
    p.asciiOpt.intImp{1}(6) = 4;
    p.asciiOpt.intImp{1}(9) = true;
    p.asciiOpt.intImp{1}(10) = 8;
    p.asciiOpt.intImp{1}(11) = 8;
    p.asciiOpt.intImp{1}(12) = 0;
    
    flist = dir([dir_ascii,sprintf(files_ascii,num2str(Js(j))),'*']);
    fnames = {};
    for f = 1:size(flist,1)
        fnames = cat(2,fnames,flist(f,1).name);
    end
    
    set_TP_asciiImpOpt(p.asciiOpt,h_fig);
    pushbutton_TDPaddProj_Callback({dir_ascii,fnames},[],h_fig);
    
    % set TDP settings and update plot
    set_TA_TDP(tdp_dat,tdp_tag,p.tdpPrm,h_fig);
    pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);
    
    fprintf(cat(2,'>>>>>>>> export screenshot of simulation''s TDP to',...
        ' file ',fname_tdpImg,'\n'),num2str(Js(j)));

    % export a screenshot of histogram fit
    set(h_fig, 'CurrentAxes',h.axes_TDPplot1);
    exportAxes({[p.dumpdir,filesep,sprintf(fname_tdpImg,num2str(Js(j)))]},...
        [],h_fig);
    
    % recover TDP
    h = guidata(h_fig);
    q_tp = h.param.TDP;
    proj = q_tp.curr_proj;
    tag = q_tp.curr_tag(proj);
    tpe = q_tp.curr_type(proj);
    prm = q_tp.proj{proj}.prm{tag,tpe};
    TDP = prm.plot{2};

    if gconv
        TDP = gconvTDP(TDP,p.tdpPrm([1,3]),p.tdpPrm(2));
    end
    if sum(sum(TDP))>0
        TDP = TDP/sum(sum(TDP));
    end
    
    % save project
    pushbutton_TDPsaveProj_Callback(...
        {p.dumpdir,sprintf(fname_mashOut,num2str(Js(j)))},[],h_fig);
    
    pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
    
    TDPs = cat(3,TDPs,TDP);
end

disp('>>>> Calulate likelihood...');

logL = -Inf(1,numel(Js));
TDPs(TDPs<=0) = 1;
for j = 1:numel(Js)
    logL(j) = sum(sum(log(TDPs(:,:,1))+ log(TDPs(:,:,j+1))));
end
[~,idmax] = max(logL);

fprintf('>>>> Optimum configuration: J=%i\n',Js(idmax));
