function routinetest_TP_backgroundAnalyzer(h_fig,p,prefix)
% routinetest_TP_backgroundAnalyzer(h_fig,p,prefix)
%
% Tests Background analyzer
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

[~,name,ext] = fileparts(p.exp_bgTrace_0D1);
exp_bgTrace_0D1 = {p.exp_bgTrace_0D1,[name,'_sgl',ext]};

[~,name,ext] = fileparts(p.exp_bgTrace_0D2);
exp_bgTrace_0D2 = {p.exp_bgTrace_0D2,[name,'_sgl',ext]};

[~,name,ext] = fileparts(p.exp_bgTrace_1D1);
exp_bgTrace_1D1 = {p.exp_bgTrace_1D1,[name,'_sgl',ext]};

[~,name,ext] = fileparts(p.exp_bgTrace_1D2);
exp_bgTrace_1D2 = {p.exp_bgTrace_1D2,[name,'_sgl',ext]};

[~,name,ext] = fileparts(p.exp_bgTrace_2D1);
exp_bgTrace_2D1 = {p.exp_bgTrace_2D1,[name,'_sgl',ext]};

[~,name,ext] = fileparts(p.exp_bgTrace_2D2);
exp_bgTrace_2D2 = {p.exp_bgTrace_2D2,[name,'_sgl',ext]};

[~,name1,ext1] = fileparts(p.exp_bga{1});
[~,name2,ext2] = fileparts(p.exp_bga{2});
[~,name3,ext3] = fileparts(p.exp_bga{3});
exp_bga = {p.exp_bga{1},p.exp_bga{2},p.exp_bga{3};...
    [name1,'_sgl',ext1],[name2,'_sgl',ext2],[name3,'_sgl',ext3]};

for f = 1:numel(mash_files)
    
    disp(cat(2,prefix,'test ',vid_type{f},' video-based project...'));
    
    % open default project
    disp(cat(2,prefix,'>> import file ',mash_files{f}));
    pushbutton_openProj_Callback({[p.annexpth,mash_dir{f}],mash_files{f}},...
        [],h_fig);

    % set default parameters
    setDefault_TP(h_fig,p);

    % test Background analyzer
    pushbutton_optBg_Callback(h.pushbutton_optBg,[],h_fig);
    h = guidata(h_fig);
    q = guidata(h.figure_bgopt);

    % test sample navigation
    disp(cat(2,prefix,'>> test sample navigation...'));
    N = numel(get(h.listbox_molNb,'string'));
    n = randsample(2:(N-1),1);
    set(q.edit_curmol,'string',num2str(n));
    edit_BA_curmol_Callback(q.edit_curmol,[],h_fig);
    pushbutton_BA_nextmol_Callback(q.pushbutton_nextmol,[],h_fig);
    pushbutton_BA_prevmol_Callback(q.pushbutton_prevmol,[],h_fig);

    % test data list
    nDat = numel(get(q.popupmenu_data,'string'));
    for dat = 1:nDat
        set(q.popupmenu_data,'value',dat);
        popupmenu_BA_data_Callback(q.popupmenu_data,[],h_fig);
    end

    % test background calculations for different method
    disp(cat(2,prefix,'>> test without parameter screening...'));
    str_meth = get(q.popupmenu_meth,'string');
    nMeth = numel(str_meth);
    for meth = 1:nMeth
        disp(cat(2,prefix,'>> test ',str_meth{meth},'...'));
        if meth==6
            p.bgPrm(meth,6) = true;
            set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,...
                true,h_fig);
            pushbutton_BA_show_Callback(...
                {[p.dumpdir,filesep,exp_bgTrace_0D1{f}]},[],h_fig);
            pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
            pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
            pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
            pushbutton_BA_save_Callback(...
                {p.dumpdir,sprintf(exp_bga{f,1},meth)},[],h_fig);

            p.bgPrm(meth,6) = false;
            set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,...
                true,h_fig);
            pushbutton_BA_show_Callback(...
                {[p.dumpdir,filesep,exp_bgTrace_0D2{f}]},[],h_fig);
            pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
            pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
            pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
            pushbutton_BA_save_Callback(...
                {p.dumpdir,sprintf(exp_bga{f,1},meth)},[],h_fig);

        else
            set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,...
                true,h_fig);
            pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
            pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
            pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
            pushbutton_BA_save_Callback(...
                {p.dumpdir,sprintf(exp_bga{f,1},meth)},[],h_fig);
        end
    end

    disp(cat(2,prefix,'test 1D parameter screening...'));
    for meth = 2:nMeth
        disp(cat(2,prefix,'>> test ',str_meth{meth},'...'));
        if meth==6
            p.bgPrm(meth,6) = true;
            set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,...
                false,h_fig);
            pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
            pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
            pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
            pushbutton_BA_save_Callback(...
                {p.dumpdir,sprintf(exp_bga{f,2},meth)},[],h_fig);

            p.bgPrm(meth,6) = false;
            set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,...
                false,h_fig);
            pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
            pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
            pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
            pushbutton_BA_save_Callback(...
                {p.dumpdir,sprintf(exp_bga{f,2},meth)},[],h_fig);
        else
            set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,...
                false,h_fig);
            pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
            pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
            pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
            pushbutton_BA_save_Callback(...
                {p.dumpdir,sprintf(exp_bga{f,2},meth)},[],h_fig);
        end
    end

    disp(cat(2,prefix,'test 2D parameter screening...'));
    for meth = [3:5,7]
        disp(cat(2,prefix,'>> test ',str_meth{meth},'...'));
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),false,...
            false,h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback(...
            {p.dumpdir,sprintf(exp_bga{f,3},meth)},[],h_fig);
    end
    close(h.figure_bgopt);

    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
end
