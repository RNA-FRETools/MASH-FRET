function ud_TTprojPrm(h_fig)

% Last update, 25.4.2019 by MH: manage background color of togglebutton associated with new tag list
% update, 24.4.2019 by MH: manage visibility of new tag list
% update, 3.4.2019 by MH: manage visibility of control text_TP_cross_gammafactor
% update, 29.3.2019 by MH: (1) adapt popupmenu settings and visibility control for bleedthrough correction to changes in GUI (delete popupmenu_excDirExc and text_bt and add text_TP_cross_into and text_TP_cross_bt in GUI)(2) change popupmenu_corr_exc's string from 'exc' to 'dir_exc' type and set string to 'none' and value to 1 if no emitter-specific laser is defined and/or used in the ALEX scheme (3) comment code
% update, 28.3.2019 by MH: Visibility of UI controls for DE coefficients is not manage here anymore but in ud_cross.m

h = guidata(h_fig);
p = h.param;
if isempty(p.proj)
    return
end

% update VP's plot tabs
nMov = numel(p.proj{p.curr_proj}.movie_file);
if nMov>1
    tabttl = p.proj{p.curr_proj}.labels;
else
    tabttl = 'multi-channel';
end

h = buildVPtabgroupPlotVid(h,h.dimprm,nMov,tabttl);
h = buildVPtabgroupPlotAvimg(h,h.dimprm,nMov,tabttl);
h = buildVPtabgroupPlotTr(h,h.dimprm,nMov,tabttl);

% set default tag name list invisible and update corresponding button 
% appearance
set(h.listbox_TP_defaultTags,'visible','off');
set(h.togglebutton_TP_addTag,'value',0,'backgroundcolor',...
    [240/255 240/255 240/255]);

% delete existing sub-image axes
if isfield(h, 'axes_subImg')
    for i = 1:numel(h.axes_subImg)
        if ishandle(h.axes_subImg(i))
            delete(h.axes_subImg(i));
        end
    end
    h = rmfield(h, 'axes_subImg');
end

if isModuleOn(p,'TP')
    proj = p.curr_proj;
    isMov = p.proj{proj}.is_movie;
    isCoord = p.proj{proj}.is_coord;
    nC = p.proj{proj}.nb_channel;
    labels = p.proj{proj}.labels;
    FRET = p.proj{proj}.FRET;
    S = p.proj{proj}.S;
    exc = p.proj{proj}.excitations;
    nExc = p.proj{proj}.nb_excitations;
    chanExc = p.proj{proj}.chanExc;
    incl = p.proj{proj}.coord_incl;
    clr = p.proj{proj}.colours;
    p_fix = p.proj{proj}.TP.fix;
    
    nMol = size(incl,2);
    
    setProp(get(h.uipanel_TP, 'Children'), 'Enable', 'on');
    set(h.text_molTot, 'String', ['total: ' num2str(nMol) ' molecules']);
    set(h.listbox_proj, 'Max', 2, 'Min', 0);

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
            'enable', 'off');
        set(h.popupmenu_trBgCorr, 'Value', 1, 'String', {'Manual'});

    elseif ~isMov
        set([h.text_TP_subImg_coordinates h.text_TP_subImg_channel ...
            h.popupmenu_TP_subImg_channel h.text_TP_subImg_x ...
            h.edit_TP_subImg_x h.text_TP_subImg_y h.edit_TP_subImg_y], ...
            'enable', 'off');
        set([h.edit_TP_subImg_x,h.edit_TP_subImg_y],'Enable','inactive');
        set(h.popupmenu_TP_subImg_channel,'Enable','on');
        setProp([ h.text_TP_subImg_exc h.popupmenu_subImg_exc ...
            h.checkbox_refocus h.text_brightness h.slider_brightness ...
            h.text_contrast h.slider_contrast h.text_subImg_dim ...
            h.edit_subImg_dim h.text_xDark h.edit_xDark ...
            h.text_yDark h.edit_yDark h.checkbox_autoDark ...
            h.pushbutton_showDark h.edit_trBgCorrParam_01 ...
            h.text_TP_bg_param h.text_TP_subImg_brightness ...
            h.text_TP_subImg_contrast], 'enable', 'off');
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
            'enable','on');
        set(h.popupmenu_trBgCorr, 'Value', 1, 'String', {'Manual', ...
            '<N median values>', 'Mean value', 'Most frequent value', ...
            'Histothresh', 'Dark trace', 'Median value'});
    end
    
    % manage control visibility for gamma correction
    nFRET = size(FRET,1);
    nS = size(S,1);
    if nFRET>0
        
        % modified MH, 3.4.2019, 13.1.2020
        set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
            h.text_TP_factors_method h.popupmenu_TP_factors_method ...
            h.text_TP_factors_fact h.text_TP_factors_gamma ...
            h.text_TP_factors_beta h.edit_gammaCorr h.edit_betaCorr ...
            h.pushbutton_optGamma],'enable','off');
    else
        
        % modified MH, 3.4.2019, 13.1.2020
        set([h.text_TP_factors_data h.popupmenu_gammaFRET ...
            h.text_TP_factors_method h.popupmenu_TP_factors_method ...
            h.text_TP_factors_fact h.text_TP_factors_gamma ...
            h.text_TP_factors_beta h.edit_gammaCorr h.edit_betaCorr ...
            h.pushbutton_optGamma],'enable','off');
    end
    
    % manage control visibility for selection of ratio data
    if (nFRET + nS) == 0
        set([h.popupmenu_TP_states_applyTo h.text_TP_states_applyTo ...
            h.popupmenu_plotBottom h.text_plotBottom], 'enable', 'off');
        set(h.text_topAxes, 'String', 'channel');
    else
        set(h.popupmenu_plotBottom, 'String', getStrPop('plot_botChan', ...
            {FRET S exc clr labels}), 'Value', p_fix{2}(3));
        set([h.popupmenu_TP_states_applyTo h.text_TP_states_applyTo ...
            h.popupmenu_plotBottom h.text_plotBottom], 'enable', 'on');
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
        {labels exc clr}));
    set([h.popupmenu_corr_chan h.popupmenu_TP_subImg_channel], 'String', ...
        getStrPop('chan',{labels p_fix{3}(1) clr{1}}));
    set(h.popupmenu_bt, 'String', getStrPop('bt_chan', ...
        {labels p_fix{3}(2) p_fix{3}(1) clr{1}}));
    set(h.popupmenu_TP_states_data, 'String', getStrPop('DTA_chan', ...
        {labels FRET S exc clr}));
    set(h.popupmenu_plotTop, 'String', getStrPop('plot_topChan', ...
        {labels p_fix{2}(1) clr{1}}));
    set(h.popupmenu_bleachChan, 'String', getStrPop('bleach_chan', ...
        {labels FRET S exc clr}));
    
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
%         {exc, p_fix{3}(1), p_fix{3}(2), clr{1}}));

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

    % create sub-image axes and calculate laser-specific avergae images
    if isCoord && isMov
        
        % collect panel positions in pixels
        postab = getPixPos(h.uitab_TP_plot_traces);
        mg = postab(1);
        mgtab = mg;
        
        % create sub-image axes
        wImg = (postab(3)-(nC+1)*mg)/nC;
        hImg = (postab(4)-mgtab-5*mg)/3.7;
        y = postab(4)-mgtab-hImg;
        x = mg;
        c = (linspace(0,1,50))';
        cmap = [c c c];
        for i = 1:nC
            h.axes_subImg(i) = axes('Parent',h.uitab_TP_plot_traces, ...
                'Units','pixels','Position',[x y wImg hImg], ...
                'FontUnits',get(h.axes_top,'FontUnits'),'FontSize',...
                get(h.axes_top,'FontSize'),'Visible','off');
            colormap(h.axes_subImg(i), cmap);
            tiaxes = get(h.axes_subImg(i),'tightinset');
            posaxes = getRealPosAxes([x y wImg hImg],tiaxes,'traces');
            set(h.axes_subImg(i),'position',posaxes);
            set(h.axes_subImg(i),'units','normalized');
            
            x = x + wImg + mg;
        end
        set(h.axes_subImg,'uicontextmenu',h.cm_zoom);
        
        % calculate laser-specific average images
        if ~(isfield(p.proj{proj}, 'aveImg') && ...
                size(p.proj{proj}.aveImg,1)==nMov && ...
                size(p.proj{proj}.aveImg,2)==(nExc+1))
            p.proj{proj}.aveImg = cell(nMov,nExc+1);
            for mov = 1:nMov
                p.proj{proj}.aveImg(mov,:) = calcAveImg('all',...
                    p.proj{proj}.movie_file{mov},...
                    p.proj{proj}.movie_dat{mov},...
                    p.proj{proj}.nb_excitations,h_fig);
            end
            h.param = p;
        end
    end
else
    % set Trace processing module off-enabled
%     setProp(get(h.uipanel_TP, 'Children'), 'Enable', 'off');
    set(h.pushbutton_help,'enable','on');
    set([h.popupmenu_plotTop h.popupmenu_bleachChan h.popupmenu_corr_chan ...
        h.popupmenu_bt h.popupmenu_TP_states_data ...
        h.popupmenu_trBgCorr_data h.popupmenu_subImg_exc ...
        h.popupmenu_trBgCorr_data h.popupmenu_corr_exc ...
        h.popupmenu_ttPlotExc h.popupmenu_TP_subImg_channel],'Value',1,...
        'string',{'none'});
end

% clear and set off-visible all axes
cla(h.axes_top);
cla(h.axes_topRight);
cla(h.axes_bottom);
cla(h.axes_bottomRight);
set([h.axes_top,h.axes_topRight,h.axes_bottom,h.axes_bottomRight],...
    'visible','off');

% save changes in h (delete/creation of sub-image axes)
guidata(h_fig, h);
