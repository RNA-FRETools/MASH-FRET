function ud_TTprojPrm(h_fig)

%% Last update: 25.4.2019 by MH
% --> manage background color of togglebutton associated with new tag list
% 
% update: 24.4.2019 by MH
% --> manage visibility of new tag list
%
% update: 3.4.2019 by MH
% --> manage visibility of control text_TP_cross_gammafactor
%
% Last update: 29.3.2019 by MH
% --> adapt popupmenu settings and visibility control for bleedthrough 
%     correction to changes in GUI (delete popupmenu_excDirExc and text_bt 
%     and add text_TP_cross_into and text_TP_cross_bt in GUI)
% --> change popupmenu_corr_exc's string from 'exc' to 'dir_exc' type and
%     set string to 'none' and value to 1 if no emitter-specific laser is 
%     defined and/or used in the ALEX scheme.
% --> comment code
%
% update: 28.3.2019 by Melodie Hadzic
% --> Visibility of UI controls for DE coefficients is not manage here
%     anymore but in ud_cross.m
%%

h = guidata(h_fig);
p = h.param.ttPr;

setProp(get(h.uipanel_TP, 'Children'), 'Visible', 'on');

% set default tag name list invisible and update corresponding button 
% appearance
set(h.lisbox_TP_defaultTags,'visible','off');
set(h.pushbutton_TP_addTag,'value',0,'backgroundcolor',...
    [240/255 240/255 240/255]);

if ~isempty(p.proj)
    proj = p.curr_proj;
    isMov = p.proj{proj}.is_movie;
    isCoord = p.proj{proj}.is_coord;
    nC = p.proj{proj}.nb_channel;
    labels = p.proj{proj}.labels;
    FRET = p.proj{proj}.FRET;
    S = p.proj{proj}.S;
    nFRET = size(FRET,1);
    nS = size(S,1);
    exc = p.proj{proj}.excitations;
    nExc = p.proj{proj}.nb_excitations;
    
    % added by MH, 29.3.2019
    chanExc = p.proj{proj}.chanExc;
    
    incl = p.proj{proj}.coord_incl;
    p_fix = p.proj{proj}.fix;
    nMol = size(incl,2);
    perSec = p_fix{2}(4);
    perPix = p_fix{2}(5);
    
    setProp(get(h.uipanel_TP, 'Children'), 'Enable', 'on');
    set(h.text_molTot, 'String', ['total: ' num2str(nMol) ' molecules']);
    set(h.listbox_traceSet, 'Max', 2, 'Min', 0);

    if ~isCoord
        setProp([h.text_TP_subImg_exc h.popupmenu_subImg_exc ...
            h.checkbox_refocus h.text_brightness ...
            h.slider_brightness h.text_contrast h.slider_contrast ...
            h.text_subImg_dim h.edit_subImg_dim ...
            h.text_TP_subImg_coordinates h.text_TP_subImg_channel ...
            h.popupmenu_TP_subImg_channel h.text_TP_subImg_x ...
            h.edit_TP_subImg_x h.text_TP_subImg_y h.edit_TP_subImg_y ...
            h.text_xDark h.edit_xDark h.text_yDark h.edit_yDark ...
            h.checkbox_autoDark h.pushbutton_showDark h.text_TP_bg_param...
            h.edit_trBgCorrParam_01 h.text_TP_subImg_brightness ...
            h.text_TP_subImg_contrast h.text_TP_subImg_coordinates], ...
            'Visible', 'off');
        set(h.popupmenu_trBgCorr, 'Value', 1, 'String', {'Manual'});

    elseif ~isMov
        set([h.text_TP_subImg_coordinates h.text_TP_subImg_channel ...
            h.popupmenu_TP_subImg_channel h.text_TP_subImg_x ...
            h.edit_TP_subImg_x h.text_TP_subImg_y h.edit_TP_subImg_y], ...
            'Visible', 'on');
        set([h.edit_TP_subImg_x,h.edit_TP_subImg_y],'Enable','inactive');
        set(h.popupmenu_TP_subImg_channel,'Enable','on');
        setProp([ h.text_TP_subImg_exc h.popupmenu_subImg_exc ...
            h.checkbox_refocus h.text_brightness h.slider_brightness ...
            h.text_contrast h.slider_contrast h.text_subImg_dim ...
            h.edit_subImg_dim h.text_xDark h.edit_xDark ...
            h.text_yDark h.edit_yDark h.checkbox_autoDark ...
            h.pushbutton_showDark h.edit_trBgCorrParam_01 ...
            h.text_TP_bg_param h.text_TP_subImg_brightness ...
            h.text_TP_subImg_contrast], 'Visible', 'off');
        set(h.popupmenu_trBgCorr, 'Value', 1, 'String', {'Manual'});

    else
        setProp([h.text_TP_subImg_exc h.popupmenu_subImg_exc ...
            h.checkbox_refocus h.text_brightness ...
            h.slider_brightness h.text_contrast h.slider_contrast ...
            h.text_subImg_dim h.edit_subImg_dim ...
            h.text_TP_subImg_coordinates h.text_TP_subImg_channel ...
            h.popupmenu_TP_subImg_channel h.text_TP_subImg_x ...
            h.edit_TP_subImg_x h.text_TP_subImg_y h.edit_TP_subImg_y ...
            h.text_xDark h.edit_xDark h.text_yDark h.edit_yDark ...
            h.checkbox_autoDark h.pushbutton_showDark h.text_TP_bg_param ...
            h.edit_trBgCorrParam_01 h.text_TP_subImg_brightness ...
            h.text_TP_subImg_contrast h.text_TP_subImg_coordinates], ...
            'Visible','on');
        set(h.popupmenu_trBgCorr, 'Value', 1, 'String', {'Manual', ...
            '<N median values>', 'Mean value', 'Most frequent value', ...
            'Histothresh', 'Dark trace', 'Median value'});
    end
    
    % manage panel visibility for sub-images
    if ~isCoord && ~isMov
        set(h.uipanel_TP_subImages,'Visible','off');
    else
        set(h.uipanel_TP_subImages,'Visible','on');
    end
    
    % manage control visibility for sub-image laser selection
    if nExc == 1
        set([h.text_TP_subImg_exc,h.popupmenu_subImg_exc],'Visible','off');
    else
        set([h.text_TP_subImg_exc,h.popupmenu_subImg_exc],'Visible','on');
    end
    
    % manage control visibility for bleedthrough correction
    if nC == 1
        
        % modified by MH, 29.3.2019
%         setProp([h.text_bt h.popupmenu_bt h.edit_bt], 'Visible', 'off');
        setProp([h.text_TP_cross_into h.text_TP_cross_bt h.popupmenu_bt ...
            h.edit_bt], 'Visible', 'off');
        
    else
        
        % modified by MH, 29.3.2019
%         setProp([h.text_bt h.popupmenu_bt h.edit_bt], 'Visible', 'on');
        setProp([h.text_TP_cross_into h.text_TP_cross_bt h.popupmenu_bt ...
            h.edit_bt], 'Visible', 'on');
        
    end
    
    % manage panel visibility for factor corrections
    if nExc == 1 && nC == 1
        set(h.uipanel_TP_factorCorrections, 'Visible', 'off');
    else
        set(h.uipanel_TP_factorCorrections, 'Visible', 'on');
    end
    
    % manage control visibility for gamma correction
    if nFRET>0
        
        % modified MH, 3.4.2019
%         set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
%             h.text_TP_factors_method h.popupmenu_TP_factors_method ...
%             h.text_TP_factors_gamma h.edit_gammaCorr ...
%             h.pushbutton_optGamma],'Visible','on');
        set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
            h.text_TP_factors_method h.popupmenu_TP_factors_method ...
            h.text_TP_factors_gamma h.edit_gammaCorr ...
            h.pushbutton_optGamma h.text_TP_cross_gammafactor],'Visible',...
            'on');
        
    else
        
        % modified MH, 3.4.2019
%         set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
%             h.text_TP_factors_method h.popupmenu_TP_factors_method ...
%             h.text_TP_factors_gamma h.edit_gammaCorr ...
%             h.pushbutton_optGamma],'Visible','off');
        set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
            h.text_TP_factors_method h.popupmenu_TP_factors_method ...
            h.text_TP_factors_gamma h.edit_gammaCorr ...
            h.pushbutton_optGamma h.text_TP_cross_gammafactor],'Visible',...
            'off');
        
    end
    
    % manage control visibility for selection of intensity data
    if nC==1 && nExc==1
        set([h.text_TP_subImg_channel h.popupmenu_TP_subImg_channel ...
            h.text_trBgCorr_data h.popupmenu_trBgCorr_data], 'Visible', ...
            'off');
    else
        set([h.text_TP_subImg_channel h.popupmenu_TP_subImg_channel ...
            h.text_trBgCorr_data h.popupmenu_trBgCorr_data], 'Visible', ...
            'on');
    end
    
    % manage control visibility for selection of ratio data
    if (nFRET + nS) == 0
        set([h.popupmenu_TP_states_applyTo h.text_TP_states_applyTo ...
            h.popupmenu_plotBottom h.text_plotBottom], 'Visible', 'off');
        set(h.text_topAxes, 'String', 'channel');
    else
        set(h.popupmenu_plotBottom, 'String', getStrPop('plot_botChan', ...
            {FRET S exc p.proj{proj}.colours labels}), 'Value', ...
            p_fix{2}(3));
        set([h.popupmenu_TP_states_applyTo h.text_TP_states_applyTo ...
            h.popupmenu_plotBottom h.text_plotBottom], 'Visible', 'on');
        set(h.text_topAxes, 'String', 'top axes:');
    end
    
    % popupmenu settings
    % modified by MH, 29.3.2019
    set([h.popupmenu_plotTop h.popupmenu_bleachChan ...
        h.popupmenu_corr_chan h.popupmenu_bt h.popupmenu_TP_states_data ...
        h.popupmenu_trBgCorr_data h.popupmenu_subImg_exc ...
        h.popupmenu_trBgCorr_data h.popupmenu_corr_exc ...
        h.popupmenu_ttPlotExc], 'Value', 1);
%         h.popupmenu_ttPlotExc h.popupmenu_excDirExc], 'Value', 1);

    set(h.popupmenu_trBgCorr_data, 'String', getStrPop('bg_corr', ...
        {labels exc p.proj{proj}.colours}));
    set([h.popupmenu_corr_chan h.popupmenu_TP_subImg_channel], 'String', ...
        getStrPop('chan',{labels p_fix{3}(1) p.proj{proj}.colours{1}}));
    set(h.popupmenu_bt, 'String', getStrPop('bt_chan', ...
        {labels p_fix{3}(2) p_fix{3}(1) p.proj{proj}.colours{1}}));
    set(h.popupmenu_TP_states_data, 'String', getStrPop('DTA_chan', ...
        {labels FRET S exc p.proj{proj}.colours}));
    set(h.popupmenu_plotTop, 'String', getStrPop('plot_topChan', ...
        {labels p_fix{2}(1) p.proj{proj}.colours{1}}));
    set(h.popupmenu_bleachChan, 'String', getStrPop('bleach_chan', ...
        {labels FRET S exc p.proj{proj}.colours}));
    
    % modified by MH 29.3.2019
%     set([h.popupmenu_subImg_exc h.popupmenu_corr_exc], 'String', ...
%         getStrPop('exc', exc));
    set(h.popupmenu_subImg_exc, 'String', getStrPop('exc', exc));
    l0 = find(exc==chanExc(p_fix{3}(3)));
    if isempty(l0) % no emitter-specific laser defined
        set(h.popupmenu_corr_exc, 'Value', 1,'String',{'none'});
    else
        set(h.popupmenu_corr_exc,'String',getStrPop('dir_exc',{exc, l0}));
    end
    
    % cancelled by MH, 29.3.2019
%     set(h.popupmenu_excDirExc, 'String', getStrPop('dir_exc', ...
%         {exc, p_fix{3}(1), p_fix{3}(2), p.proj{proj}.colours{1}}));

    set(h.popupmenu_ttPlotExc, 'String', getStrPop('plot_exc', exc));
    
    set(h.popupmenu_plotTop, 'Value', p_fix{2}(2));
    set(h.popupmenu_bleachChan, 'Value', 1);
    set(h.popupmenu_corr_chan, 'Value', p_fix{3}(2));
    set(h.popupmenu_bt, 'Value', p_fix{3}(3));
    set(h.popupmenu_TP_states_data, 'Value', p_fix{3}(4));
    set(h.popupmenu_trBgCorr_data, 'Value', p_fix{3}(6));
    set(h.popupmenu_subImg_exc, 'Value', p_fix{1}(1));
    set(h.popupmenu_corr_chan,'Value',1);
    
    % modified by MH 29.3.2019
%     set(h.popupmenu_corr_exc, 'Value', p_fix{3}(1));
    if ~isempty(l0)
        set(h.popupmenu_corr_exc, 'Value', p_fix{3}(1));
    end
    
    set(h.popupmenu_ttPlotExc, 'Value', p_fix{2}(1));
    
    % cancelled by MH 29.3.2019
%     set(h.popupmenu_excDirExc, 'Value', p_fix{3}(7));
    
    % x-axis settings
    set(h.checkbox_ttPerSec, 'Value', perSec);
    set(h.checkbox_ttAveInt, 'Value', perPix);
    
    % reset sub-image axes
    if isfield(h, 'axes_subImg')
        for i = 1:numel(h.axes_subImg)
            if ishandle(h.axes_subImg(i))
                delete(h.axes_subImg(i));
            end
        end
        h = rmfield(h, 'axes_subImg');
        refresh;
    end
    
    % create sub-image axes and calculate laser-specific avergae images
    if isCoord && isMov
        
        % collect initial panel units
        unitsPanel = get(h.uipanel_TP, 'Units');
        unitsTopaxes = get(h.axes_top, 'Units');
        unitsList = get(h.listbox_traceSet, 'Units');
        unitsBg = get(h.uipanel_TP_backgroundCorrection, 'Units');
        
        % set panel units to pixels
        set(h.uipanel_TP,'Units','pixels');
        set(h.axes_top, 'Units','pixels');
        set(h.listbox_traceSet,'Units','pixels');
        set(h.uipanel_TP_backgroundCorrection,'Units','pixels');
        
        % collect panel positions in pixels
        posList = get(h.listbox_traceSet, 'Position');
        posPanel = get(h.uipanel_TP, 'Position');
        posTopaxes = get(h.axes_top, 'Position');
        posBg = get(h.uipanel_TP_backgroundCorrection, 'Position');
        
        % set panel units to initial units
        set(h.uipanel_TP,'Units',unitsPanel);
        set(h.axes_top, 'Units',unitsTopaxes);
        set(h.listbox_traceSet,'Units',unitsList);
        set(h.uipanel_TP_backgroundCorrection,'Units',unitsBg);
        
        % create sub-image axes
        mg = posList(1);
        yNext = posTopaxes(2) + posTopaxes(4) + 2*mg;
        xNext = posList(1) + posList(3) + mg;
        wImg = (posBg(1)-(posList(1)+posList(3))-(nC+1)*mg)/nC;
        hImg = posPanel(4) - yNext - mg;
        c = (linspace(0, 1, 50))';
        cmap = [c c c];
        for i = 1:nC
            h.axes_subImg(i) = axes('Parent',h.uipanel_TP, ...
                'Units','pixels','Position',[xNext yNext wImg hImg], ...
                'FontUnits',get(h.axes_top,'FontUnits'),'FontSize',...
                get(h.axes_top,'FontSize'),'Visible','off');
            set(h.axes_subImg(i),'Units','normalized');
            colormap(h.axes_subImg(i), cmap);
            xNext = xNext + wImg + mg;
        end
        
        % calculate laser-specific average images
        if ~(isfield(p.proj{proj}, 'aveImg') && ...
                size(p.proj{proj}.aveImg,2) == nExc)
            param.stop = p.proj{proj}.movie_dat{3};
            param.iv = nExc;
            param.file = p.proj{proj}.movie_file;
            param.extra = p.proj{proj}.movie_dat; 
            for l = 1:nExc
                param.start = l;
                [img,ok] = createAveIm(param,false,false,h_fig);
                if ~ok
                    return;
                end
                p.proj{proj}.aveImg{l} = img;
                h.param.ttPr = p;
            end
        end
    end
else
    % delete existing sub-image axes
    if isfield(h, 'axes_subImg')
        for i = 1:numel(h.axes_subImg)
            if ishandle(h.axes_subImg(i))
                delete(h.axes_subImg(i));
            end
        end
        h = rmfield(h, 'axes_subImg');
        refresh;
    end
    
    % set Trace processing module off-enabled
    setProp(get(h.uipanel_TP, 'Children'), 'Enable', 'off');
    setProp([h.pushbutton_traceImpOpt h.pushbutton_addTraces], ...
        'Enable', 'on');
end

% clear and sett off-visible all axes
cla(h.axes_top);
cla(h.axes_topRight);
cla(h.axes_bottom);
cla(h.axes_bottomRight);
set([h.axes_top, h.axes_topRight, h.axes_bottom, h.axes_bottomRight], ...
    'Visible', 'off');

% save changes in h (delete/creation of sub-image axes)
guidata(h_fig, h);
