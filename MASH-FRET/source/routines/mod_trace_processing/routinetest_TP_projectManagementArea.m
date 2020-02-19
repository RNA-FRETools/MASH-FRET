function routinetest_TP_projectManagementArea(h_fig,p,prefix)
% routinetest_TP_projectManagementArea(h_fig,p,prefix)
%
% Tests project import/export and project options
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

% empty project list
disp(cat(2,prefix,'test project list...'));
nProj = numel(get(h.listbox_traceSet,'string'));
proj = nProj;
while proj>0
    set(h.listbox_traceSet,'value',proj);
    listbox_traceSet_Callback(h.listbox_traceSet,[],h_fig);
    pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
    proj = proj-1;
end

% test intensity import for different number of channels and lasers
disp(cat(2,prefix,'test trace import for different number of channels ',...
    'and lasers...'));
for nL = 1:p.nL_max
    for nChan = 1:p.nChan_max
        % test .mash file import 
        disp(cat(2,prefix,'>> import file ',p.mash_files{nL,nChan}));
        pushbutton_addTraces_Callback({p.annexpth,p.mash_files{nL,nChan}},...
            [],h_fig);
        
        % set project options
        set_VP_projOpt(p.projOpt{nL,nChan},p.wl(1:nL),...
            h.pushbutton_editParam,h_fig);
        
        % save project
        pushbutton_expProj_Callback({p.dumpdir,p.mash_files{nL,nChan}},[],...
            h_fig);
        
        % test ASCII files import 
        disp(cat(2,prefix,'>> import data set ',p.ascii_dir{nL,nChan}));
        set_TP_asciiImpOpt(p.asciiOpt{nL,nChan},h_fig);
        pushbutton_addTraces_Callback({...
            [p.annexpth,filesep,p.ascii_dir{nL,nChan}],...
            p.ascii_files{nL,nChan}},[],h_fig);
        
        % set project options
        set_VP_projOpt(p.projOpt{nL,nChan},p.wl(1:nL),...
            h.pushbutton_editParam,h_fig);
        
        % save project
        pushbutton_expProj_Callback({p.dumpdir,p.exp_ascii2mash{nL,nChan}},...
            [],h_fig);
    end
end

% empty project list
disp(cat(2,prefix,'test project list...'));
nProj = numel(get(h.listbox_traceSet,'string'));
proj = nProj;
while proj>0
    set(h.listbox_traceSet,'value',proj);
    listbox_traceSet_Callback(h.listbox_traceSet,[],h_fig);
    pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
    proj = proj-1;
end

% test coordinates import from external file
disp(cat(2,prefix,'test import of coordinates from external file...'));
opt = p.asciiOpt{p.nChan,p.nL};
opt.coordImp{1}{1} = true;
opt.coordImp{1}{2} = {p.annexpth,p.coord_file};
opt.coordImp{1}{4} = p.vid_width;
set_TP_asciiImpOpt(opt,h_fig);

pushbutton_addTraces_Callback({...
    [p.annexpth,filesep,p.ascii_dir{p.nL,p.nChan}],...
    p.ascii_files{p.nL,p.nChan}},[],h_fig);

set_VP_projOpt(p.projOpt{p.nL,p.nChan},p.wl(1:p.nL),h.pushbutton_editParam,...
    h_fig);

pushbutton_expProj_Callback({p.dumpdir,p.exp_coord1},[],h_fig);
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

% test coordinates import from trace file header
disp(cat(2,prefix,'test import of coordinates from trace file headers',...
    '...'));
opt = p.asciiOpt{p.nChan,p.nL};
opt.coordImp{2}(1) = true;
opt.coordImp{2}(2) = p.coord_fline;
set_TP_asciiImpOpt(opt,h_fig);

pushbutton_addTraces_Callback({...
    [p.annexpth,filesep,p.ascii_dir{p.nL,p.nChan}],...
    p.ascii_files{p.nL,p.nChan}},[],h_fig);

set_VP_projOpt(p.projOpt{p.nL,p.nChan},p.wl(1:p.nL),h.pushbutton_editParam,...
    h_fig);

pushbutton_expProj_Callback({p.dumpdir,p.exp_coord2},[],h_fig);
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

% test video import from file
disp(cat(2,prefix,'test import of video from external file...'));
opt = p.asciiOpt{p.nChan,p.nL};
opt.vidImp{1} = true;
opt.vidImp{2} = {p.annexpth,p.vid_file};
set_TP_asciiImpOpt(opt,h_fig);

pushbutton_addTraces_Callback({...
    [p.annexpth,filesep,p.ascii_dir{p.nL,p.nChan}],...
    p.ascii_files{p.nL,p.nChan}},[],h_fig);

set_VP_projOpt(p.projOpt{p.nL,p.nChan},p.wl(1:p.nL),h.pushbutton_editParam,...
    h_fig);

pushbutton_expProj_Callback({p.dumpdir,p.exp_vid},[],h_fig);
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

% test gamma factor import from files
disp(cat(2,prefix,'test import of gamma factors from external files...'));
opt = p.asciiOpt{p.nChan,p.nL};
opt.factImp{1} = true;
opt.factImp{2} = p.annexpth;
opt.factImp{3} = p.gamma_files;
set_TP_asciiImpOpt(opt,h_fig);

pushbutton_addTraces_Callback({...
    [p.annexpth,filesep,p.ascii_dir{p.nL,p.nChan}],...
    p.ascii_files{p.nL,p.nChan}},[],h_fig);

set_VP_projOpt(p.projOpt{p.nL,p.nChan},p.wl(1:p.nL),h.pushbutton_editParam,...
    h_fig);

pushbutton_expProj_Callback({p.dumpdir,p.exp_gam},[],h_fig);
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

% test beta factor import from files
disp(cat(2,prefix,'test import of beta factors from external files...'));
opt = p.asciiOpt{p.nChan,p.nL};
opt.factImp{4} = true;
opt.factImp{5} = p.annexpth;
opt.factImp{6} = p.beta_files;
set_TP_asciiImpOpt(opt,h_fig);

pushbutton_addTraces_Callback({...
    [p.annexpth,filesep,p.ascii_dir{p.nL,p.nChan}],...
    p.ascii_files{p.nL,p.nChan}},[],h_fig);

set_VP_projOpt(p.projOpt{p.nL,p.nChan},p.wl(1:p.nL),h.pushbutton_editParam,...
    h_fig);

pushbutton_expProj_Callback({p.dumpdir,p.exp_bet},[],h_fig);
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

% test beta factor import from files
disp(cat(2,prefix,'test import of beta factors from external files...'));
opt = p.asciiOpt{p.nChan,p.nL};
opt.intImp{9} = true;
opt.intImp{10} = p.states_fcol;
set_TP_asciiImpOpt(opt,h_fig);

pushbutton_addTraces_Callback({...
    [p.annexpth,filesep,p.ascii_dir{p.nL,p.nChan}],...
    p.ascii_files{p.nL,p.nChan}},[],h_fig);

set_VP_projOpt(p.projOpt{p.nL,p.nChan},p.wl(1:p.nL),h.pushbutton_editParam,...
    h_fig);

pushbutton_expProj_Callback({p.dumpdir,p.exp_states},[],h_fig);
pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

