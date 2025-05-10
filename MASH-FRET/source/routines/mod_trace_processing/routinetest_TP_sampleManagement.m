function routinetest_TP_sampleManagement(h_fig,p,prefix)
% routinetest_TP_sampleManagement(h_fig,p,prefix)
%
% Tests molecule list, molecule status, ASCII file export and trace manager
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

% multi- and single-channel video-based mash files
vid_type = {'multi-channel', 'single-channel'};

[~,name,ext] = fileparts(p.mash_files{p.nL,p.nChan});
mash_files = {p.mash_files{p.nL,p.nChan},[name,'_sgl',ext]};
mash_dir = {name,[name,'_sgl']};

[~,name,ext] = fileparts(p.exp_sortProj);
exp_proj = {p.exp_sortProj,[name,'_sgl',ext]};

for f = 1:numel(mash_files)
    
    disp(cat(2,prefix,'test ',vid_type{f},' video-based project...'));
    
    % open default project
    disp(cat(2,prefix,'>> import file ',mash_files{f}));
    pushbutton_openProj_Callback({[p.annexpth,mash_dir{f}],mash_files{f}},...
        [],h_fig);

    % set default parameters
    setDefault_TP(h_fig,p);

    % test sample navigation
    disp(cat(2,prefix,'>> test sample navigation...'));
    pushbutton_molNext_Callback(h.pushbutton_molNext,[],h_fig);
    pushbutton_molPrev_Callback(h.pushbutton_molPrev,[],h_fig);

    N = numel(get(h.listbox_molNb,'string'));
    n = 1;
    while n==1
        n = ceil(rand(1)*N);
    end
    set(h.edit_currMol,'string',num2str(n));
    edit_currMol_Callback(h.edit_currMol,[],h_fig);

    % test molecule selection
    disp(cat(2,prefix,'>> >> test molecule status...'));
    nspl = randsample(1:N,3);
    for n = nspl
        set(h.listbox_molNb,'value',n);
        listbox_molNb_Callback(h.listbox_molNb,[],h_fig);
        set(h.checkbox_TP_selectMol,'value',0);
        checkbox_TP_selectMol_Callback(h.checkbox_TP_selectMol,[],h_fig);
    end
    pushbutton_TTrem_Callback(h.pushbutton_TTrem,[],h_fig);

    % test molecule tag
    togglebutton_TP_addTag_Callback(h.togglebutton_TP_addTag,[],h_fig);
    nTag = numel(get(h.listbox_TP_defaultTags,'string'));
    tag = ceil(rand(1)*nTag);
    set(h.listbox_TP_defaultTags,'value',tag);
    listbox_TP_defaultTags_Callback(h.listbox_TP_defaultTags,[],h_fig);

    set(h.popupmenu_TP_molLabel,'value',1);
    pushbutton_TP_deleteTag_Callback(h.pushbutton_TP_deleteTag,[],h_fig);

    % test trace update
    disp(cat(2,prefix,'>> test trace update...'));
    pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
    pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

    % export project
    pushbutton_saveProj_Callback({p.dumpdir,exp_proj{f}},[],h_fig);

    % close project
    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
end
