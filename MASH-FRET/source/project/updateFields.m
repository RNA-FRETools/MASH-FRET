function updateFields(h_fig, varargin)
% updateFields(h_fig)
% updateFields(h_fig, opt)
%
% Update calculations and set GUI to proper values
%
% h_fig: handle to main figure
% opt: what is to update ('all','sim','movPr','imgAxes','ttPr','subImg','cross','thm','TDP')

% Last update, 19.12.2019 by MH: allows coordinates import from ASCII file when a preset file containing only out-of-range coordinates is loaded
% update, 12.12.2019 by MH: (1) cancel clearing of image axes to keep properties/boba fret image defined when building GUI (2) make TDP colorbar invisible when no project is loaded
% update, 9.11.2019 by MH: review update of transition rate edit fields in order to keep field in selection after tabbing
% update, 24.4.2019 by MH: remove double update of molecule list
% update, 19.4.2019 by MH: set empty fields in transtion matrix when rates are loaded from presets to avoid confusion
% update, 7.3.2018 by Richard Börner: Comments adapted for Boerner et al, PONE, 2017.

% set default option
if ~isempty(varargin)
    opt = varargin{1};
else
    opt = 'all';
end

h = guidata(h_fig);

% reset action window color
h_pan = guidata(h.figure_actPan);
set(h_pan.text_actions, 'BackgroundColor', [1 1 1]);

% set folder root
set(h.edit_rootFolder,'string',h.folderRoot);

%% Simulation fields

if strcmp(opt, 'sim') || strcmp(opt, 'all')
    
    % update Simulation panels
    ud_S_vidParamPan(h_fig);
    ud_S_moleculesPan(h_fig);
    ud_S_expSetupPan(h_fig);
    ud_S_expOptPan(h_fig);
    
    h = guidata(h_fig);
end

%% Movie processing fields

if strcmp(opt,'imgAxes') || strcmp(opt, 'movPr') || strcmp(opt, 'all')
    
    % refresh video processing and plot
    if (strcmp(opt, 'all') || strcmp(opt, 'imgAxes')) && ...
            isfield(h, 'movie')
        updateImgAxes(h_fig);
    end
    
    % update Video processing panels
    ud_VP_plotPan(h_fig);
    ud_VP_expSetPan(h_fig);
    ud_VP_edExpVidPan(h_fig);
    ud_VP_molCoordPan(h_fig);
    ud_VP_intIntegrPan(h_fig);
    
    h = guidata(h_fig);
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

