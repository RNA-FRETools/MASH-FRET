function routinetest_TP_projectManagementArea(h_fig,p,prefix)
% routinetest_TP_projectManagementArea(h_fig,p,prefix)
%
% Tests project import/export and project options
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a apecific indent)

h = guidata(h_fig);

% empty project list
nProj = numel(h.listbox_proj.String);
for proj = nProj:-1:1
    set(h.listbox_proj,'value',proj);
    listbox_projLst_Callback(h.listbox_proj,[],h_fig);
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,true);
end

% test intensity import for different number of channels and lasers
disp(cat(2,prefix,'test trace import for different number of channels ',...
    'and lasers...'));
for nL = 1:p.nL_max
    p.nL = nL;
    for nChan = 1:p.nChan_max
        p.nChan = nChan;
        
        % test .mash file import 
        disp(cat(2,prefix,'>> import file ',p.mash_files{nChan,nL}));
        pushbutton_openProj_Callback({p.annexpth,p.mash_files{nChan,nL}},...
            [],h_fig);

        % set module
        switchPan(h.togglebutton_TP,[],h_fig);
        
        % save project
        pushbutton_saveProj_Callback({p.dumpdir,p.mash_files{nChan,nL}},[],...
            h_fig);
        
        % test ASCII files import 
        disp(cat(2,prefix,'>> import data set ',p.es{nChan,nL}.imp.tdir));
        routinetest_TP_createProj(p,h_fig,[prefix,'>> >> ']);

        % save project
        pushbutton_saveProj_Callback({p.dumpdir,p.exp_ascii2mash{nChan,nL}},...
            [],h_fig);
    end
end
p.nChan = p.nChan_def;
p.nL = p.nL_def;

% empty project list
nProj = numel(h.listbox_proj.String);
for proj = nProj:-1:1
    set(h.listbox_proj,'value',proj);
    listbox_projLst_Callback(h.listbox_proj,[],h_fig);
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,true);
end

% test coordinates import from external file
disp(cat(2,prefix,'test import of coordinates from external file...'));
p.es{p.nChan,p.nL}.imp.coordfile = p.coord_file;
p.es{p.nChan,p.nL}.imp.coordopt = {reshape(1:2*p.nChan,2,p.nChan)',1};

routinetest_TP_createProj(p,h_fig,[prefix,'>> ']);

setDefault_TP(h_fig,p);

pushbutton_saveProj_Callback({p.dumpdir,p.exp_coord1},[],h_fig);
pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);

p.es{p.nChan,p.nL}.imp.coordfile = '';
p.es{p.nChan,p.nL}.imp.coordopt = [];

% test video import from file
disp(cat(2,prefix,'test import of video from external file...'));
p.es{p.nChan,p.nL}.imp.vfile = p.vid_file;

routinetest_TP_createProj(p,h_fig,[prefix,'>> ']);

setDefault_TP(h_fig,p);

pushbutton_saveProj_Callback({p.dumpdir,p.exp_vid},[],h_fig);
pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);

p.es{p.nChan,p.nL}.imp.vfile = '';

% test gamma factor import from files
disp(cat(2,prefix,'test import of gamma factors from external files...'));
p.es{p.nChan,p.nL}.imp.gammafile = p.gamma_files;

routinetest_TP_createProj(p,h_fig,[prefix,'>> ']);

setDefault_TP(h_fig,p);

pushbutton_saveProj_Callback({p.dumpdir,p.exp_gam},[],h_fig);
pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);

p.es{p.nChan,p.nL}.imp.gammafile = '';

% test beta factor import from files
disp(cat(2,prefix,'test import of beta factors from external files...'));
p.es{p.nChan,p.nL}.imp.betafile = p.beta_files;

routinetest_TP_createProj(p,h_fig,[prefix,'>> ']);

setDefault_TP(h_fig,p);

pushbutton_saveProj_Callback({p.dumpdir,p.exp_bet},[],h_fig);

p.es{p.nChan,p.nL}.imp.betafile = '';

% test project merging
disp(cat(2,prefix,'test project merging...'));

pushbutton_openProj_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},[],...
    h_fig);

set(h.listbox_proj,'value',[1,2]);
menu_projMenu_merge_Callback([],[],h_fig);

setDefault_TP(h_fig,p);

pushbutton_saveProj_Callback({p.dumpdir,p.exp_merged},[],h_fig);

% empty project list
nProj = numel(h.listbox_proj.String);
for proj = nProj:-1:1
    set(h.listbox_proj,'value',proj);
    listbox_projLst_Callback(h.listbox_proj,[],h_fig);
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,true);
end
