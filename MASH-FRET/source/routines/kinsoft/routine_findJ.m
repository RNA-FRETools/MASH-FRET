function [pname,fname,res,Js] = routine_findJ(h_fig)
% [pname,fname,res,Js] = routine_findJ(h_fig)
%
% Analyze data of Kinsoft challenge to find the optimum number of states
% In case different configurations lead to similar goodness of fit, the corresponding number of states are given all together as a result
%
% h_fig: handle to main figure
% pname: source directory
% fname: base name used in exported files
% res: clustering results for all model complexities
% Js: [nJ-by-2] optimum number of states and associated BIC values

% initializes output
fname = [];
res = [];
Js = [];

% defauts
Jmax = 10; % maximum number of states to find
meth = 5; % state finding method index in list (STaSI)
trace = 1; % index in list of traces to apply state finding algorithm to (bottom traces)
deblurr = true; % activate "deblurr" option
tdp_dat = 3; % data to plot in TDP (FRET data)
tdp_tag = 1; % molecule tag to plot in TDP (all molecules)
BIC_tol = 0; % minimum relative BIC variation to validate an optimum configuration

% get default interface
h = guidata(h_fig);

% ask files to user
disp('>> select kinsoft challenge trace files (*.txt,*.dat)...');
[fnames,pname,~] = uigetfile(...
    {'*.dat;*.txt','Select trace files (*.dat,*.txt)';...
    '*.*','All files (*.*)'},'multiselect','on');
if ~sum(pname) || numel(fnames)==0
    return
end
fname = pname;
if strcmp(fname(end),filesep)
    fname(end) = [];
end
[~,fname,~] = fileparts(fname);

disp('>> start determination of the number of states J...');

% get default interface settings
p = getDef_kinsoft(pname,fnames);
fname_mash = getCorrName([fname '_STaSI.mash'],pname,h_fig);
fname_clst = getCorrName([fname,'_STaSI_%sstates.clst'],pname,h_fig);
fname_tdpImg = getCorrName([fname,'_STaSI_TDP.png'],pname,h_fig);
fname_clstImg = getCorrName([fname,'_STaSI_clust_%sstates.png'],pname,...
    h_fig);

disp('>>>> import .dat files in Trace processing...');

% set options for ASCII file import 
switchPan(h.togglebutton_TP,[],h_fig);
set_TP_asciiImpOpt(p.asciiOpt,h_fig);
pushbutton_addTraces_Callback({pname,fnames},[],h_fig);

% set project options
p.projOpt.proj_title = [fname,'_STaSI'];
set_VP_projOpt(p.projOpt,p.wl(1:p.nL),h.pushbutton_editParam,h_fig);

% save project
pushbutton_expProj_Callback({p.dumpdir,fname_mash},[],h_fig);

disp('>>>> process single FRET traces with STaSI...');

% set interface to default values
setDef_kinsoft_TP(p,h_fig);

% configure state finding algorithm to STaSI
p.fsPrm(meth,1,:) = Jmax;
p.fsPrm(meth,7,:) = deblurr;
set_TP_findStates(meth,trace,p.fsPrm,p.fsThresh,p.nChan,p.nL,h_fig);
pushbutton_applyAll_DTA_Callback(h.pushbutton_applyAll_DTA,[],h_fig);

% process traces
pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

disp(cat(2,'>>>> save modificiations in file ',fname_mash,'...'));

% save project
pushbutton_expProj_Callback({p.dumpdir,fname_mash},[],h_fig);
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

disp(cat(2,'>>>> import file ',fname_mash,' in Transition analysis...'));

% import project in TA
switchPan(h.togglebutton_TA,[],h_fig);
pushbutton_TDPaddProj_Callback({p.dumpdir,fname_mash},[],h_fig);

disp('>>>> build TDP...');

% set TDP settings and update plot
set_TA_TDP(tdp_dat,tdp_tag,p.tdpPrm,h_fig);
pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);

fprintf(cat(2,'>>>> export TDP screenshot to file ',fname_tdpImg,'\n'));

% export a screenshot of TDP
set(h_fig, 'CurrentAxes',h.axes_TDPplot1);
exportAxes({[p.dumpdir,filesep,fname_tdpImg]},[],h_fig);

disp('>>>> cluster transitions with Gaussian mixtures...');

% set clustering settings and cluster transitions
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
[~,Jopt] = min(res.BIC);
Js = Jopt;
BICs = res.BIC(Jopt);
for J = (Jopt+1):Jmax
    if abs((res.BIC(J)-res.BIC(J-1))/res.BIC(J-1))<=BIC_tol
        Js = cat(2,Js,J);
        BICs = cat(2,BICs,res.BIC(J));
    else
        break;
    end
end
for J = (Jopt-1):-1:1
    if abs((res.BIC(J+1)-res.BIC(J))/res.BIC(J))<=BIC_tol
        Js = cat(2,Js,J);
        BICs = cat(2,BICs,res.BIC(J));
    else
        break;
    end
end
[BICs,id] = sort(BICs);
Js = Js(id);

fprintf(cat(2,'>>>> export gaussian parameters to ',fname_clst,' files ',...
    'and TDP screenshots to ',fname_clstImg,' files...\n'),'[J]','[J]');

% export optimum gaussian mixtures to .clst files
p.tdp_expOpt(5) = true;
for J = Js
    set(h.popupmenu_tdp_model,'value',J-1);
    popupmenu_tdp_model_Callback(h.popupmenu_tdp_model,[],h_fig);

    pushbutton_tdp_impModel_Callback(h.pushbutton_tdp_impModel,[],h_fig);
    
    pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig);
    set_TA_expOpt(p.tdp_expOpt,h_fig);
    pushbutton_expTDPopt_next_Callback({p.dumpdir,...
        sprintf(fname_clst,num2str(J))},[],h_fig);
    
    % export a screenshot of clustering
    set(h_fig, 'CurrentAxes',h.axes_TDPplot1);
    exportAxes({[p.dumpdir,filesep,sprintf(fname_clstImg,num2str(J))]},[],...
        h_fig);
end

disp(cat(2,'>>>> save modificiations to file ',fname_mash,'...'));

% save modifications to mash file
pushbutton_TDPsaveProj_Callback({p.dumpdir,fname_mash},[],h_fig);
pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);

str_J = repmat('%i, ',[1,numel(Js)]);
str_J = str_J(1:end-2);
fprintf(cat(2,'>> results: J = ',str_J,'\n'),Js);

Js = [Js',BICs'];

