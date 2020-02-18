function routinetest_TP_sampleManagement(h_fig,p,prefix)
% routinetest_TP_sampleManagement(h_fig,p,prefix)
%
% Tests molecule list, molecule status, 
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

% empty project list
disp(cat(2,prefix,'empty project list...'));
nProj = numel(get(h.listbox_traceSet,'string'));
proj = nProj;
while proj>0
    set(h.listbox_traceSet,'value',proj);
    listbox_traceSet_Callback(h.listbox_traceSet,[],h_fig);
    pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
    proj = proj-1;
end

% import default project
disp(cat(2,prefix,'import default project'));
pushbutton_addTraces_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},[],...
    h_fig);

% test sample navigation
disp(cat(2,prefix,'test sample management...'));
pushbutton_molNext_Callback(h.pushbutton_molNext,[],h_fig);
pushbutton_molPrev_Callback(h.pushbutton_molPrev,[],h_fig);

N = numel(get(h.listbox_molNb,'string'));
n = 1;
while n==1
    n = ceil(rand(1)*N);
end
set(h.edit_currMol,'string',num2str(n));
edit_currMol_Callback(h.edit_currMol,[],h_fig);

% delete molecules
nspl = randsample(1:N,3);
for n = nspl
    set(h.listbox_molNb,'value',n);
    listbox_molNb_Callback(h.listbox_molNb,[],h_fig);
    checkbox_TP_selectMol_Callback(h.checkbox_TP_selectMol,[],h_fig);
end
pushbutton_TTrem_Callback(h.pushbutton_TTrem,[],h_fig);

% test molecule tag
disp(cat(2,prefix,'test current molecule tagging...'));
togglebutton_TP_addTag_Callback(h.togglebutton_TP_addTag,[],h_fig);

nTag = numel(get(h.listbox_TP_defaultTags,'string'));
tag = ceil(rand(1)*nTag);
set(h.listbox_TP_defaultTags,'value',tag);
listbox_TP_defaultTags_Callback(h.listbox_TP_defaultTags,[],h_fig);

set(h.popupmenu_TP_molLabel,'value',tag);
pushbutton_TP_deleteTag_Callback(h.pushbutton_TP_deleteTag,[],h_fig);

% test trace update
disp(cat(2,prefix,'test trace update...'));
pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

% test trace export
disp(cat(2,prefix,'test trace export...'));
pushbutton_expTraces_Callback(h.pushbutton_expTraces,[],h_fig);
h = guidata(h_fig);
q = h.optExpTr;
nFigFmt = numel(get(q.popupmenu_figFmt,'string'));
opt = p.expOpt;
opt.traces(1) = true;
opt.hist(1) = true;
opt.dt(1) = true;
opt.fig{1}(1) = true;
set_TP_asciiExpOpt(opt,h_fig);
pushbutton_next_Callback({p.dumpdir,p.mash_files{p.nL,p.nChan}},[],h_fig);

% test trace export to single files/one file
opt = p.expOpt;
opt.traces(1) = true;
opt.traces(2) = 1;
opt.traces(6) = ~p.expOpt.traces(6);
pushbutton_expTraces_Callback(h.pushbutton_expTraces,[],h_fig);
set_TP_asciiExpOpt(opt,h_fig);
pushbutton_next_Callback({p.dumpdir,p.mash_files{p.nL,p.nChan}},[],h_fig);

% test parameters export to separate file
disp(cat(2,prefix,'test parameters export...'));
opt.traces(3:7) = false;
opt.traces(8) = 1;
pushbutton_expTraces_Callback(h.pushbutton_expTraces,[],h_fig);
set_TP_asciiExpOpt(opt,h_fig);
pushbutton_next_Callback({p.dumpdir,p.mash_files{p.nL,p.nChan}},[],h_fig);

% test figure export to different formats
disp(cat(2,prefix,'test figure export...'));
opt = p.expOpt;
opt.fig{1}(1) = true;
for fmt = 1:nFigFmt
    if fmt==p.expOpt.fig{1}(2)
        continue
    end
    opt.fig{1}(2) = fmt;
    pushbutton_expTraces_Callback(h.pushbutton_expTraces,[],h_fig);
    set_TP_asciiExpOpt(opt,h_fig);
    pushbutton_next_Callback({p.dumpdir,p.mash_files{p.nL,p.nChan}},[],...
        h_fig);
end

% test different figure layout and figure preview
disp(cat(2,prefix,'test figure layout...'));
exp_fig = cat(2,p.dumpdir,filesep,p.exp_figpreview);
opt.fig{1}(12) = true;
pushbutton_expTraces_Callback(h.pushbutton_expTraces,[],h_fig);

opt.fig{1}([4,5,8]) = [true,false,false];
opt.fig{2} = cat(2,exp_fig,'_subImg.png');
set_TP_asciiExpOpt(opt,h_fig);

opt.fig{1}([4,5,8]) = [false,true,false];
opt.fig{2} = cat(2,exp_fig,'_top.png');
set_TP_asciiExpOpt(opt,h_fig);

opt.fig{1}([4,5,8]) = [false,false,true];
opt.fig{2} = cat(2,exp_fig,'_bottom.png');
set_TP_asciiExpOpt(opt,h_fig);

opt.fig{1}([4,5,8]) = [true,true,true];
opt.fig{1}(10) = false;
opt.fig{2} = cat(2,exp_fig,'_noHist.png');
set_TP_asciiExpOpt(opt,h_fig);

opt.fig{1}(10) = true;
opt.fig{1}(11) = false;
opt.fig{2} = cat(2,exp_fig,'_noDiscr.png');
set_TP_asciiExpOpt(opt,h_fig);

pushbutton_cancel_Callback(q.pushbutton_cancel,[],h_fig);

% test trace manager
disp(cat(2,prefix,'test trace manager...'));
pushbutton_TM_Callback(h.pushbutton_TM,[],h_fig);
h = guidata(h_fig);
q = h.tm;

menu_export_Callback(q.pushbutton_export,[],h_fig);

% close project
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
