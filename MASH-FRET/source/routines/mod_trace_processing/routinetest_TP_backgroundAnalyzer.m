function routinetest_TP_backgroundAnalyzer(h_fig,p,prefix)
% routinetest_TP_backgroundAnalyzer(h_fig,p,prefix)
%
% Tests Background analyzer
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

p.mash_files{p.nL,p.nChan} = p.mash_file_bga;
setDefault_TP(h_fig,p);

disp(cat(2,prefix,'>> import file ',p.mash_files{nL,nChan}));
pushbutton_addTraces_Callback({p.annexpth,p.mash_files{nL,nChan}},...
    [],h_fig);

% test Background analyzer
pushbutton_optBg_Callback(h.pushbutton_optBg,[],h_fig);
h = guidata(h_fig);
q = guidata(h.figure_bgopt);

% test sample navigation
disp(cat(2,prefix,'test sample navigation...'));
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
disp(cat(2,prefix,'test without parameter screening...'));
str_meth = get(q.popupmenu_meth,'string');
nMeth = numel(str_meth);
for meth = 1:nMeth
    disp(cat(2,prefix,'>> test ',str_meth{meth},'...'));
    if meth==6
        p.bgPrm(meth,6) = true;
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,true,...
            h_fig);
        pushbutton_BA_show_Callback({[p.dumpdir,filesep,p.exp_bgTrace_0D1]},...
            [],h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{1},meth)},...
            [],h_fig);

        p.bgPrm(meth,6) = false;
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,true,...
            h_fig);
        pushbutton_BA_show_Callback({[p.dumpdir,filesep,p.exp_bgTrace_0D2]},...
            [],h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{1},meth)},...
            [],h_fig);
    else
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,true,...
            h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{1},meth)},...
            [],h_fig);
    end
end

disp(cat(2,prefix,'test 1D parameter screening...'));
for meth = 2:nMeth
    disp(cat(2,prefix,'>> test ',str_meth{meth},'...'));
    if meth==6
        p.bgPrm(meth,6) = true;
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,false,...
            h_fig);
        pushbutton_BA_show_Callback({[p.dumpdir,filesep,p.exp_bgTrace_1D1]},...
            [],h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{2},meth)},...
            [],h_fig);

        p.bgPrm(meth,6) = false;
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,false,...
            h_fig);
        pushbutton_BA_show_Callback({[p.dumpdir,filesep,p.exp_bgTrace_1D2]},...
            [],h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{2},meth)},...
            [],h_fig);
    else
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),true,false,...
            h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{2},meth)},...
            [],h_fig);
    end
end

disp(cat(2,prefix,'test 2D parameter screening...'));
for meth = 3:7
    disp(cat(2,prefix,'>> test ',str_meth{meth},'...'));
    if meth==6
        p.bgPrm(meth,6) = true;
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),false,...
            false,h_fig);
        pushbutton_BA_show_Callback({[p.dumpdir,filesep,p.exp_bgTrace_2D1]},...
            [],h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{3},meth)},...
            [],h_fig);

        p.bgPrm(meth,6) = false;
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),false,...
            false,h_fig);
        pushbutton_BA_show_Callback({[p.dumpdir,filesep,p.exp_bgTrace_2D2]},...
            [],h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{3},meth)},...
            [],h_fig);
    else
        set_TP_BA(meth,p.bgPrm(meth,:),p.bgPrm_screen(:,:,meth),false,...
            false,h_fig);
        pushbutton_BA_allChan_Callback(q.pushbutton_allChan,[],h_fig);
        pushbutton_BA_allMol_Callback(q.pushbutton_allMol,[],h_fig);
        pushbutton_BA_start_Callback(q.pushbutton_start,[],h_fig);
        pushbutton_BA_save_Callback({p.dumpdir,sprintf(p.exp_bga{3},meth)},...
            [],h_fig);
    end
end
close(h.figure_bgopt);

pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
