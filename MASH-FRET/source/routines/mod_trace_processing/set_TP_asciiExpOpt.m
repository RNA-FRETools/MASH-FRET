function set_TP_asciiExpOpt(opt,h_fig)
% set_TP_asciiExpOpt(opt,h_fig)
%
% Set ASCII files export options to proper values
%
% opt: structure containing export options as set in getDefault_TP (see p.expOpt)
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
q = h.optExpTr;


% set general export options
set(q.checkbox_molValid,'value',opt.gen(1));
checkbox_molValid_Callback(q.checkbox_molValid,[],h_fig);

if opt.gen(2)==0
    opt.gen(2) = numel(get(q.popup_molTagged,'string'));
end
set(q.popup_molTagged,'value',opt.gen(2));
popup_molTagged_Callback(q.popup_molTagged,[],h_fig);

% set Time traces export options
set(q.radiobutton_saveTr,'value',opt.traces(1));
radiobutton_saveTr_Callback(q.radiobutton_saveTr,[],h_fig);
if opt.traces(1)
    set(q.popupmenu_trFmt,'value',opt.traces(2));
    popupmenu_trFmt_Callback(q.popupmenu_trFmt,[],h_fig);
    
    if sum(opt.traces(2)==[1,7])
        set(q.checkbox_trI,'value',opt.traces(3));
        checkbox_trI_Callback(q.checkbox_trI,[],h_fig);

        setIfEnabled(q.checkbox_trFRET,'value',opt.traces(4),true);

        setIfEnabled(q.checkbox_trS,'value',opt.traces(5),true);

        setIfEnabled(q.checkbox_trAll,'value',opt.traces(6),true);
    end

    setIfEnabled(q.checkbox_gam,'value',opt.traces(7),true);

    set(q.popupmenu_trPrm,'value',opt.traces(8));
    popupmenu_trPrm_Callback(q.popupmenu_trPrm,[],h_fig);
end


% set Histogram export options
set(q.radiobutton_saveHist,'value',opt.hist(1));
radiobutton_saveHist_Callback(q.radiobutton_saveHist,[],h_fig);
if opt.hist(1)
    set(q.checkbox_histI,'value',opt.hist(2));
    checkbox_histI_Callback(q.checkbox_histI,[],h_fig);

    set(q.edit_minI,'string',num2str(opt.hist(3)));
    edit_minI_Callback(q.edit_minI,[],h_fig);

    set(q.edit_binI,'string',num2str(opt.hist(4)));
    edit_binI_Callback(q.edit_binI,[],h_fig);

    set(q.edit_maxI,'string',num2str(opt.hist(5)));
    edit_maxI_Callback(q.edit_maxI,[],h_fig);

    setIfEnabled(q.checkbox_histFRET,'value',opt.hist(6),true);

    setIfEnabled(q.edit_minFRET,'string',num2str(opt.hist(7)),true);

    setIfEnabled(q.edit_binFRET,'string',num2str(opt.hist(8)),true);

    setIfEnabled(q.edit_maxFRET,'string',num2str(opt.hist(9)),true);

    setIfEnabled(q.checkbox_histS,'value',opt.hist(10),true);
    
    setIfEnabled(q.edit_minS,'string',num2str(opt.hist(11)),true);

    setIfEnabled(q.edit_binS,'string',num2str(opt.hist(12)),true);

    setIfEnabled(q.edit_maxS,'string',num2str(opt.hist(13)),true);

    set(q.checkbox_histDiscr,'value',opt.hist(14));
    checkbox_histDiscr_Callback(q.checkbox_histDiscr,[],h_fig);
end


% set Dwell time files export options
set(q.radiobutton_saveDt,'value',opt.dt(1));
radiobutton_saveDt_Callback(q.radiobutton_saveDt,[],h_fig);
if opt.dt(1)
    set(q.checkbox_dtI,'value',opt.dt(2));
    checkbox_dtI_Callback(q.checkbox_dtI,[],h_fig);

    setIfEnabled(q.checkbox_dtFRET,'value',opt.dt(3),true);

    setIfEnabled(q.checkbox_dtS,'value',opt.dt(4),true);
    
    set(q.checkbox_kin,'value',opt.dt(5));
    checkbox_kin_Callback(q.checkbox_kin,[],h_fig);
end


% set Figures export options
set(q.radiobutton_saveFig,'value',opt.fig{1}(1));
radiobutton_saveFig_Callback(q.radiobutton_saveFig,[],h_fig);
if opt.fig{1}(1)
    set(q.popupmenu_figFmt,'value',opt.fig{1}(2));
    popupmenu_figFmt_Callback(q.popupmenu_figFmt,[],h_fig);

    set(q.edit_nMol,'string',num2str(opt.fig{1}(3)));
    edit_nMol_Callback(q.edit_nMol,[],h_fig);

    setIfEnabled(q.checkbox_subImg,'value',opt.fig{1}(4),true);

    setIfEnabled(q.checkbox_top,'value',opt.fig{1}(5),true);

    if opt.fig{1}(6)==0
        opt.fig{1}(6) = numel(get(q.popupmenu_topChan,'string'));
    end
    setIfEnabled(q.popupmenu_topChan,'value',opt.fig{1}(6),true);

    if opt.fig{1}(7)==0
        opt.fig{1}(7) = numel(get(q.popupmenu_topExc,'string'));
    end
    setIfEnabled(q.popupmenu_topExc,'value',opt.fig{1}(7),true);

    setIfEnabled(q.checkbox_bottom,'value',opt.fig{1}(8),true);

    if opt.fig{1}(9)==0
        opt.fig{1}(9) = numel(get(q.popupmenu_botChan,'string'));
    end
    setIfEnabled(q.popupmenu_botChan,'value',opt.fig{1}(9),true);

    set(q.checkbox_figHist,'value',opt.fig{1}(10));
    checkbox_figHist_Callback(q.checkbox_figHist,[],h_fig);

    set(q.checkbox_figDiscr,'value',opt.fig{1}(11));
    checkbox_figDiscr_Callback(q.checkbox_figDiscr,[],h_fig);

    if opt.fig{1}(12)
        pushbutton_preview_Callback({opt.fig{2}},[],h_fig);
    end
end

