function updateFields(h_fig, varargin)
% Update all uicontrol properties of MASH
% input argument 1: MASH figure handle
% input argument 2: what to update ('all', 'sim', 'imgAxes', 'movPr', 'ttPr', 'thm', TDP')

% Last update by MH, 19.12.2019: allows coordinates import from ASCII file when a preset file containing only out-of-range coordinates is loaded
% update by MH, 12.12.2019: (1) cancel clearing of image axes to keep properties/boba fret image defined when building GUI (2) make TDP colorbar invisible when no project is loaded
% update by MH, 9.11.2019: review update of transition rate edit fields in order to keep field in selection after tabbing
% update by MH, 24.4.2019: remove double update of molecule list
% update: 19.4.2019 by MH: set empty fields in transtion matrix when rates are loaded from presets to avoid confusion
% update: 7.3.2018 by Richard Börner: Comments adapted for Boerner et al, PONE, 2017.

% set default option
if ~isempty(varargin)
    opt = varargin{1};
else
    opt = 'all';
end

h = guidata(h_fig);

h_pan = guidata(h.figure_actPan);
set(h_pan.text_actions, 'BackgroundColor', [1 1 1]);

%% Simulation fields

if strcmp(opt, 'sim') || strcmp(opt, 'all')
    
    ud_S_vidParamPan(h_fig);
    ud_S_moleculesPan(h_fig);
    ud_S_expSetupPan(h_fig);
    ud_S_expOptPan(h_fig);

end

%% Movie processing fields

if strcmp(opt,'imgAxes') || strcmp(opt, 'movPr') || strcmp(opt, 'all')

    p = h.param.movPr;
    nC = p.nChan;
    labels = p.labels;
    nLaser = p.itg_nLasers;
    
    if isfield(h, 'movie') && isfield(h.movie, 'rate')
        set(h.edit_rate, 'String', num2str(p.rate));
    end
    
    set(h.edit_nChannel, 'String', num2str(p.nChan));
    set(h.popupmenu_colorMap, 'Value', p.cmap);
    set(h.checkbox_int_ps, 'Value', p.perSec);

    for i = 1:nC
        if i > size(p.movBg_p,2)
            for j = 1:size(p.movBg_p,1)
                p.movBg_p{j,i} = p.movBg_p{j,i-1};
            end
        end
        if i > size(h.param.movPr.SF_minI,2)
            p.SF_minI(i) = p.SF_minI(i-1);
            p.SF_intThresh(i) = p.SF_intThresh(i-1);
            p.SF_intRatio(i) = p.SF_intRatio(i-1);
            p.SF_w(i) = p.SF_w(i-1);
            p.SF_h(i) = p.SF_h(i-1);
            p.SF_darkW(i) = p.SF_darkW(i-1);
            p.SF_darkH(i) = p.SF_darkH(i-1);
            p.SF_maxN(i) = p.SF_maxN(i-1);
            p.SF_minHWHM(i) = p.SF_minHWHM(i-1);
            p.SF_maxHWHM(i) = p.SF_maxHWHM(i-1);
            p.SF_maxAssy(i) = p.SF_maxAssy(i-1);
            p.SF_minDspot(i) = p.SF_minDspot(i-1);
            p.SF_minDedge(i) = p.SF_minDedge(i-1);
        end
        if i > size(p.trsf_refImp_rw{1},1)
            p.trsf_refImp_rw{1}(i,1) = ...
                p.trsf_refImp_rw{1}(i-1,1) + ...
                p.trsf_refImp_rw{1}(i-1,2) - 1;
            p.trsf_refImp_rw{1}(i,3) = ...
                p.trsf_refImp_rw{1}(i-1,3);
            p.trsf_refImp_cw{1}(i,1:2) = ...
                p.trsf_refImp_cw{1}(i-1,1:2) + 2;
        end
        if i > size(p.itg_impMolPrm{1},1)
            p.itg_impMolPrm{1}(i,1:2) = ...
                p.itg_impMolPrm{1}(i-1,1:2) + 2;
        end
    end
    h.param.movPr = p;
    guidata(h_fig, h);
    
    set(h.popupmenu_bgChanel, 'String', getStrPop('chan', {labels []}));
    set(h.popupmenu_bgCorr, 'Value', p.movBg_method);
    set(h.checkbox_bgCorrAll, 'Value', ~p.movBg_one);
    
    ud_movBgCorr(h.popupmenu_bgCorr, [], h_fig);
    h = guidata(h_fig);
    p = h.param.movPr;
    
    set(h.edit_startMov, 'String', num2str(p.mov_start)...
        , 'BackgroundColor', [1 1 1]);
    set(h.edit_endMov, 'String', num2str(p.mov_end)...
        , 'BackgroundColor', [1 1 1]);
    
    set(h.edit_aveImg_iv, 'String', num2str(p.ave_iv)...
        , 'BackgroundColor', [1 1 1]);
    set(h.edit_aveImg_start, 'String', num2str(p.ave_start)...
        , 'BackgroundColor', [1 1 1]);
    set(h.edit_aveImg_end, 'String', num2str(p.ave_stop)...
        , 'BackgroundColor', [1 1 1]);
    
    ud_lstBg(h.figure_MASH);

    set(h.edit_refCoord_file, 'String', ...
        p.trsf_coordRef_file, 'BackgroundColor', [1 1 1]);
    set(h.edit_tr_file, 'String', p.trsf_tr_file, ...
        'BackgroundColor', [1 1 1]);
    set(h.edit_coordFile, 'String', p.coordMol_file, ...
        'BackgroundColor', [1 1 1]);
    set(h.edit_itg_coordFile, 'String', p.coordItg_file, ...
        'BackgroundColor', [1 1 1]);
    if isfield(h, 'movie') && isfield(h.movie, 'file')
        set(h.edit_movItg, 'String', h.movie.file);
    end
    set(h.edit_movItg, 'BackgroundColor', [1 1 1]);
    set(h.edit_TTgen_dim, 'String', num2str(p.itg_dim)...
        , 'BackgroundColor', [1 1 1]);
    set(h.edit_intNpix, 'String', num2str(p.itg_n)...
        , 'BackgroundColor', [1 1 1]);
    set(h.checkbox_meanVal, 'Value', p.itg_ave);
    set(h.edit_nLasers, 'String', num2str(nLaser), 'BackgroundColor', ...
        [1 1 1]);

    laser = get(h.popupmenu_TTgen_lasers, 'Value');
    if laser > nLaser
        laser = nLaser;
    end
    set(h.popupmenu_TTgen_lasers, 'Value', laser, 'String', ...
        cellstr(num2str((1:nLaser)')));
    
    set(h.edit_wavelength, 'String', num2str(p.itg_wl(laser)), ...
        'BackgroundColor', [1 1 1]);
    
    if strcmp(opt, 'imgAxes') && isfield(h, 'movie')
        updateImgAxes(h_fig);
        h = guidata(h_fig);
    end
    
    ud_SFpanel(h_fig);

end

%% Traces processing fields

if strcmp(opt, 'ttPr') || strcmp(opt, 'subImg') || strcmp(opt, 'cross') || ...
        strcmp(opt, 'all')
    p = h.param.ttPr;
    
    if ~isempty(p.proj)
        
        % update moleule list; moved by MH, 24.4.2019
        ud_trSetTbl(h_fig);
        
        proj = p.curr_proj;
        mol = p.curr_mol(proj);

        set(h.edit_currMol, 'String', num2str(mol), 'BackgroundColor', ...
            [1 1 1]);
        set(h.listbox_molNb, 'Value', mol);
        set(h.listbox_traceSet, 'Max', 2, 'Min', 0);

        axes.axes_traceTop = h.axes_top;
        axes.axes_histTop = h.axes_topRight;
        axes.axes_traceBottom = h.axes_bottom;
        axes.axes_histBottom = h.axes_bottomRight;
        if p.proj{proj}.is_movie && p.proj{proj}.is_coord
            axes.axes_molImg = h.axes_subImg;
        end
        
        p = updateTraces(h_fig, opt, mol, p, axes);
        
        h.param.ttPr = p;
        guidata(h_fig, h);

        % update parameters
        % cancelled by MH, 24.4.2019
%         ud_trSetTbl(h_fig);
        ud_subImg(h_fig);
        ud_denoising(h_fig);
        ud_bleach(h_fig);
        ud_ttBg(h_fig);
        ud_DTA(h_fig);
        ud_cross(h_fig);
        ud_factors(h_fig)
        ud_plot(h_fig);
        
        h = guidata(h_fig);
        
    else
        ud_TTprojPrm(h_fig);
        h = guidata(h_fig);
    end
end

%% Thermodynamics fields

if strcmp(opt, 'thm') || strcmp(opt, 'all')
    p = h.param.thm;
    set(h.edit_thmContPan, 'Enable', 'inactive');
    if ~isempty(p.proj)
        set([h.listbox_thm_projLst h.pushbutton_thm_rmProj ...
            h.pushbutton_thm_saveProj h.pushbutton_thm_export], ...
            'Enable', 'on');
        set([h.axes_hist1,h.axes_hist2,h.axes_thm_BIC], 'Visible', 'on');
        set(h.listbox_thm_projLst, 'Max', 2, 'Min', 0);
        ud_thmPlot(h_fig);
        ud_thmHistAna(h_fig);
        h = guidata(h_fig);

    else
        set([h.radiobutton_thm_gaussFit h.radiobutton_thm_thresh], ...
            'Value', 0, 'FontWeight', 'normal');
        setProp(get(h.uipanel_HA, 'Children'), 'Enable', 'off');
        
        % cancelled by MH, 12.12.2019
%         cla(h.axes_hist_BOBA);

        cla(h.axes_hist1); cla(h.axes_hist2); cla(h.axes_thm_BIC);

        set([h.axes_hist1,h.axes_hist2,h.axes_thm_BIC], 'Visible','off');
        set([h.pushbutton_help h.pushbutton_thm_impASCII ...
            h.pushbutton_thm_addProj],'Enable', 'on');
    end
end


%% TDP analysis fields

if strcmp(opt, 'TDP') || strcmp(opt, 'all')
    set(h.edit_TDPcontPan, 'Enable', 'inactive');
    
    updateTAplots(h_fig);
    
    p = h.param.TDP;
    if ~isempty(p.proj)
        set([h.listbox_TDPprojList h.pushbutton_TDPremProj ...
            h.pushbutton_TDPsaveProj h.pushbutton_TDPexport],'Enable',...
            'on');
        set(h.listbox_TDPprojList, 'Max', 2, 'Min', 0);
        
        ud_TDPplot(h_fig);
        ud_TDPmdlSlct(h_fig);
        ud_kinFit(h_fig);
        
        h = guidata(h_fig);

    else
        setProp(get(h.uipanel_TA, 'Children'), 'Enable', 'off');
        set([h.pushbutton_help h.pushbutton_TDPimpOpt ...
            h.pushbutton_TDPaddProj], 'Enable', 'on');
        set(h.listbox_TDPtrans, 'String', {''}, 'Value', 1);
        set([h.axes_TDPplot1 h.colorbar_TA h.axes_TDPplot2 h.axes_TDPcmap ...
            h.axes_tdp_BIC], 'Visible', 'off');
    end
end

guidata(h_fig, h);

