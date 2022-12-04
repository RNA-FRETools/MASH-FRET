function routinetest_TP_backgroundCorrections(h_fig,p,prefix)
% routinetest_TP_backgroundCorrections(h_fig,p,prefix)
%
% Tests different background estimators
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

% multi- and single-channel video-based mash files
vid_type = {'multi-channel', 'single-channel'};

[~,name,ext] = fileparts(p.mash_files{p.nL,p.nChan});
mash_files = {p.mash_files{p.nL,p.nChan},[name,'_sgl',ext]};

[~,name,ext] = fileparts(p.exp_bgTrace1);
exp_bgTrace1 = {p.exp_bgTrace1,[name,'_sgl',ext]};

[~,name,ext] = fileparts(p.exp_bgTrace2);
exp_bgTrace2 = {p.exp_bgTrace2,[name,'_sgl',ext]};

for f = 1:numel(mash_files)
    
    disp(cat(2,prefix,'test ',vid_type{f},' video-based project...'));
    
    % open default project
    disp(cat(2,prefix,'>> import file ',mash_files{f}));
    pushbutton_openProj_Callback({p.annexpth,mash_files{f}},[],h_fig);

    % set default parameters
    setDefault_TP(h_fig,p);

    % expand panel
    h_but = getHandlePanelExpandButton(h.uipanel_TP_backgroundCorrection,...
        h_fig);
    if strcmp(h_but.String,char(9660))
        pushbutton_panelCollapse_Callback(h_but,[],h_fig);
    end

    % test different background corrections
    str_meth = get(h.popupmenu_trBgCorr,'string');
    nMeth = numel(str_meth);
    nDat = numel(get(h.popupmenu_trBgCorr_data,'string'));
    for meth = 1:nMeth
        if meth==p.bgMeth
            continue
        end
        disp(cat(2,prefix,'>> test ',str_meth{meth},'...'));
        dat = meth;
        if dat>nDat
            dat = meth-ceil(meth/nDat-1)*nDat;
        end
        set(h.popupmenu_trBgCorr_data,'value',dat);
        popupmenu_trBgCorr_data_Callback(h.popupmenu_trBgCorr_data,[],...
            h_fig);

        if meth==6
            p.bgPrm(meth,6) = true;
            set_TP_background(meth,p.bgPrm(meth,:),true,h_fig);
            pushbutton_showDark_Callback(...
                {[p.dumpdir,filesep,exp_bgTrace1{f}]},[],h_fig);
            pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);

            p.bgPrm(meth,6) = false;
            set_TP_background(meth,p.bgPrm(meth,:),true,h_fig);
            pushbutton_showDark_Callback(...
                {[p.dumpdir,filesep,exp_bgTrace2{f}]},[],h_fig);
            pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
        else
            set_TP_background(meth,p.bgPrm(meth,:),true,h_fig);
            pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
        end
    end
    pushbutton_applyAll_ttBg_Callback(h.pushbutton_applyAll_ttBg,[],h_fig);
    pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

    pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
end
