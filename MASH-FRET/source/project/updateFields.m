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
p = h.param;

% set project list
if isempty(p.proj)
    set([h.pushbutton_closeProj,h.pushbutton_editProj,...
        h.pushbutton_saveProj,h.listbox_proj],'enable','off');
else
    set([h.pushbutton_closeProj,h.pushbutton_editProj,...
        h.pushbutton_saveProj,h.listbox_proj],'enable','on');
end

% set folder root
if ~isempty(p.proj)
    proj = p.curr_proj;
    set(h.edit_rootFolder,'string',p.proj{proj}.folderRoot);
    set([h.pushbutton_rootFolder,h.edit_rootFolder],'enable','on');
else
    set(h.edit_rootFolder,'string','');
    set([h.pushbutton_rootFolder,h.edit_rootFolder],'enable','off');
end

% Tool bar
h_tb = [h.togglebutton_S,h.togglebutton_VP,h.togglebutton_TP,...
    h.togglebutton_HA,h.togglebutton_TA];
isOn = [isModuleOn(p,'sim'),isModuleOn(p,'VP'),isModuleOn(p,'TP'),...
        isModuleOn(p,'HA'),isModuleOn(p,'TA')];
set(h_tb(isOn),'enable','on');
set(h_tb(~isOn),'enable','off','value',0);
if all(~isOn)
    switchPan(0,[],h_fig);
end

% Simulation module
if strcmp(opt, 'sim') || strcmp(opt, 'all')
    ud_S_panels(h_fig);
    h = guidata(h_fig);
end

% Movie processing module
if strcmp(opt,'imgAxes') || strcmp(opt, 'movPr') || strcmp(opt, 'all')
    
    % refresh data processing and plot
    if (strcmp(opt, 'all') || strcmp(opt, 'imgAxes'))
        updateImgAxes(h_fig);
    end
    
    ud_VP_panels(h_fig);
    h = guidata(h_fig);
end

% Trace processing module
if strcmp(opt, 'ttPr') || strcmp(opt, 'subImg') || strcmp(opt, 'cross') || ...
        strcmp(opt, 'all')
    
    p = h.param;
    if isModuleOn(p,'TP')
        % refresh data processing and plot
        proj = p.curr_proj;
        mol = p.ttPr.curr_mol(proj);
        axes.axes_traceTop = h.axes_top;
        axes.axes_histTop = h.axes_topRight;
        axes.axes_traceBottom = h.axes_bottom;
        axes.axes_histBottom = h.axes_bottomRight;
        if p.proj{proj}.is_movie && p.proj{proj}.is_coord
            axes.axes_molImg = h.axes_subImg;
        end
        p = updateTraces(h_fig, opt, mol, p, axes);
        h.param = p;
        guidata(h_fig, h);
        
    else
        % update axes and control properties
        ud_TTprojPrm(h_fig);
    end
    
    ud_TP_panels(h_fig);
    h = guidata(h_fig);
end

% Histogram analysis module
if strcmp(opt, 'thm') || strcmp(opt, 'all')
    ud_HA_histDat(h_fig);
    ud_HA_panels(h_fig);
    update_HA_plots(h_fig);
    
    h = guidata(h_fig);
end

% Transition analysis module
if strcmp(opt, 'TDP') || strcmp(opt, 'all')
    ud_TDPdata(h_fig);
    ud_TA_panels(h_fig);
    updateTAplots(h_fig);
    
    h = guidata(h_fig);
end

guidata(h_fig, h);

