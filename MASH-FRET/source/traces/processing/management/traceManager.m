
function traceManager(h_fig)
    
    h = guidata(h_fig);
    h.tm.ud = false;
    guidata(h_fig,h);
    
    p = h.param.ttPr;
    proj = p.curr_proj;
    
    global intensities;
    intensities = nan(size(p.proj{proj}.intensities));
    
    if ~(isfield(h.tm, 'figure_traceMngr') && ...
            ishandle(h.tm.figure_traceMngr))
        loadData2Mngr(h_fig);
    end
    
end


function loadData2Mngr(h_fig)

    openMngrTool(h_fig);
    h = guidata(h_fig);
    pushbutton_update_Callback(h.tm.pushbutton_update, [], h_fig);
    plotDataTm(h_fig);
    
end


function openMngrTool(h_fig)
    
    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nb_mol = numel(p.proj{proj}.coord_incl);
    
    wFig = 800;
    hFig = 800;
    prev_u = get(h_fig, 'Units');
    set(h_fig, 'Units', 'pixels');
    posFig = get(h_fig, 'Position');
    set(h_fig, 'Units', prev_u);
    prev_u = get(0, 'Units');
    set(0, 'Units', 'pixels');
    pos_scr = get(0, 'ScreenSize');
    set(0, 'Units', prev_u);
    xFig = posFig(1) + (posFig(3) - wFig)/2;
    yFig = min([hFig pos_scr(4)]) - hFig;
    pos_fig = [xFig yFig wFig hFig];
    
    mg = 10;
    mg_big = 2*mg;
    mg_win = 0;
    mg_ttl = 10;
    fntS = 10.6666666;
    h_edit = 20; w_edit = 40;
    h_but = 22; w_but = 45;
    h_txt = 14;
    w_pan = wFig - 2*mg;
    w_pop = 100;

    h_pan_all = mg_ttl + 3*mg + mg_big + 2*h_edit + 2*h_txt + h_but;
    h_pan_sgl = hFig - mg_win - 3*mg - h_pan_all;
    
    h_axes_all = h_pan_all - mg_ttl - 2*mg - h_edit;
    w_axes2 = 2*mg + 3*w_edit;
    w_axes1 = w_pan - 4*mg - w_pop - w_axes2;
    
    w_sld = 20;
    h_sld = h_pan_sgl - 3*mg - mg_ttl - h_but;

    h = guidata(h_fig);
    
    if nb_mol < 3
        nb_mol_disp = nb_mol;
    else
        nb_mol_disp = 3;
    end
    
    h.tm.molValid = p.proj{proj}.coord_incl;
    
    
    h.tm.figure_traceMngr = figure('Visible', 'on', 'Units', 'pixels', ...
        'Position', pos_fig, 'Color', [0.94 0.94 0.94], ...
        'CloseRequestFcn', {@figure_traceMngr, h_fig}, 'NumberTitle', ...
        'off', 'Name', [get(h_fig, 'Name') ' - Trace manager'], ...
        'WindowStyle', 'modal');
    
    xNext = mg;
    yNext = hFig - mg_win - mg - h_pan_all;
    
    h.tm.uipanel_overall = uipanel('Parent', h.tm.figure_traceMngr, ...
        'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_all], ...
        'Title', 'Overall plots', 'FontUnits', 'pixels', 'FontSize', fntS);
    
    yNext = yNext - mg - h_pan_sgl;
    
    h.tm.uipanel_overview = uipanel('Parent', h.tm.figure_traceMngr, ...
        'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_sgl], ...
        'Title', 'Overview', 'FontUnits', 'pixels', 'FontSize', fntS);
    
    
    %% all results panel
    
    xNext = mg;
    yNext = h_pan_all - mg_ttl - mg - h_txt;
    
    h.tm.text1 = uicontrol('Style', 'text', 'Parent', ...
        h.tm.uipanel_overall, 'Units', 'pixels', 'String', ...
        'Plot axes1:', 'HorizontalAlignment', 'center', 'Position', ...
        [xNext yNext w_pop h_txt], 'FontUnits', 'pixels', 'FontSize', ...
        fntS);
    
    yNext = yNext - h_edit;
    
    h.tm.popupmenu_axes1 = uicontrol('Style', 'popupmenu', 'Parent', ...
        h.tm.uipanel_overall, 'String', {'none'}, 'Units', 'pixels', ...
        'Position', [xNext yNext w_pop h_edit], 'BackgroundColor', ...
        [1 1 1], 'Callback', {@popupmenu_axes_Callback, h_fig}, ...
        'FontUnits', 'pixels', 'FontSize', fntS);
    
    yNext = yNext - mg - h_txt;
    
    h.tm.text2 = uicontrol('Style', 'text', 'Parent', ...
        h.tm.uipanel_overall, 'Units', 'pixels', 'String', ...
        'Plot axes2:', 'HorizontalAlignment', 'center', 'Position', ...
        [xNext yNext w_pop h_txt], 'FontUnits', 'pixels', 'FontSize', ...
        fntS);
    
    yNext = yNext - h_edit;
    
    h.tm.popupmenu_axes2 = uicontrol('Style', 'popupmenu', 'Parent', ...
        h.tm.uipanel_overall, 'Units', 'pixels', 'String', {'none'}, ...
        'Position', [xNext yNext w_pop h_edit], 'BackgroundColor', ...
        [1 1 1], 'Callback', {@popupmenu_axes_Callback, h_fig}, ...
        'FontUnits', 'pixels', 'FontSize', fntS);
    
    yNext = yNext - mg_big - h_but;
    
    h.tm.pushbutton_update = uicontrol('Style', 'pushbutton', 'Parent', ...
        h.tm.uipanel_overall, 'Units', 'pixels', 'Position', ...
        [xNext yNext w_but h_but], 'String', 'UPDATE', 'TooltipString', ...
        'Update the graphs with new parameters', 'Callback', ...
        {@pushbutton_update_Callback, h_fig}, 'FontUnits', 'pixels', ...
        'FontSize', fntS);
    
    xNext = xNext + mg + w_but;
    
    h.tm.pushbutton_export = uicontrol('Style', 'pushbutton', 'Parent', ...
        h.tm.uipanel_overall, 'Units', 'pixels','FontWeight', 'bold', ...
        'String', 'TO MASH', 'Position', [xNext yNext w_but h_but], ...
        'TooltipString', 'Export selection to MASH', 'Callback', ...
        {@menu_export_Callback, h_fig}, 'FontUnits', 'pixels', ...
        'FontSize', fntS);

    xNext = w_pop + 2*mg;
    yNext = mg;
    
    h.tm.axes_ovrAll_1 = axes('Parent', h.tm.uipanel_overall, 'Units', ...
        'pixels', 'FontUnits', 'pixels', 'FontSize', fntS, ...
        'ActivePositionProperty', 'OuterPosition', 'GridLineStyle', ':',...
        'NextPlot', 'replacechildren');
    pos = getRealPosAxes([xNext yNext w_axes1 h_axes_all], ...
        get(h.tm.axes_ovrAll_1, 'TightInset'), 'traces');
    pos(3:4) = pos(3:4) - fntS;
    pos(1:2) = pos(1:2) + fntS;
    set(h.tm.axes_ovrAll_1, 'Position', pos);
    
    xNext = xNext + mg + w_axes1;
    yNext = mg;
    
    h.tm.axes_ovrAll_2 = axes('Parent', h.tm.uipanel_overall, 'Units', ...
        'pixels', 'FontUnits', 'pixels', 'FontSize', fntS, ...
        'ActivePositionProperty', 'OuterPosition', 'GridLineStyle', ':',...
        'NextPlot', 'replacechildren');
    pos1 = pos;
    pos = getRealPosAxes([xNext yNext w_axes2 h_axes_all], ...
        get(h.tm.axes_ovrAll_2, 'TightInset'), 'traces'); 
    pos([2 4]) = pos1([2 4]);
    pos(3) = pos(3) - fntS;
    pos(1) = pos(1) + fntS;
    set(h.tm.axes_ovrAll_2, 'Position', pos);
    
    yNext = h_pan_all - mg_ttl - mg - h_edit;
    
    h.tm.edit_xlim_low = uicontrol('Style', 'edit', 'Parent', ...
        h.tm.uipanel_overall, 'Position', [xNext yNext w_edit h_edit], ...
        'Callback', {@edit_xlim_low_Callback, h_fig}, 'String', '0', ...
        'BackgroundColor', [1 1 1], 'TooltipString', ...
        'lower interval value');
    
    xNext = xNext + mg + w_edit;
    
    h.tm.edit_nbiv = uicontrol('Style', 'edit', 'Parent', ...
        h.tm.uipanel_overall, 'Position', [xNext yNext w_edit h_edit], ...
        'Callback', {@edit_nbiv_Callback, h_fig}, 'String', '200', ...
        'BackgroundColor', [1 1 1], 'TooltipString', 'number of interval');
    
    xNext = xNext + mg + w_edit;
    
    h.tm.edit_xlim_up = uicontrol('Style', 'edit', 'Parent', ...
        h.tm.uipanel_overall, 'Position', [xNext yNext w_edit h_edit], ...
        'Callback', {@edit_xlim_up_Callback, h_fig}, 'String', '1', ...
        'BackgroundColor', [1 1 1], 'TooltipString', ...
        'upper interval value');
    
    
    %% panel overview
    
    if nb_mol <= nb_mol_disp || nb_mol_disp == 0
        min_step = 1;
        maj_step = 1;
        min_val = 0;
        max_val = 1;
        vis = 'off';
    else
        vis = 'on';
        min_val = 1;
        max_val = nb_mol-nb_mol_disp+1;
        min_step = 1/(nb_mol-nb_mol_disp);
        maj_step = nb_mol_disp/(nb_mol-nb_mol_disp);
    end
    
    xNext = mg;
    yNext = h_pan_sgl - mg_ttl - mg - h_but;
    
    h.tm.checkbox_all = uicontrol('Style', 'checkbox', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', 'FontUnits', 'pixels',...
        'FontSize', fntS, 'String', 'Check all', 'TooltipString', ...
        'Include all molecules', 'Position', [xNext yNext w_pop h_edit],...
        'Callback', {@checkbox_all_Callback, h_fig}, 'Value', 1);
    
    xNext = w_pan - mg - w_but;

    h.tm.pushbutton_reduce = uicontrol('Style', 'pushbutton', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', 'Position', ...
        [xNext yNext w_but h_but]);
    
    xNext = xNext - mg_big - w_edit;
    
    h.tm.edit_nbTotMol = uicontrol('Style', 'edit', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', 'Position', ...
        [xNext yNext w_edit h_edit], 'String', '3', 'TooltipString', ...
        'Number of molecule per view', 'BackgroundColor', [1 1 1], ...
        'Callback', {@edit_nbTotMol_Callback, h_fig});
    
    xNext = xNext - mg - w_pop;
    
    h.tm.textNmol = uicontrol('Style', 'text', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', 'String', ...
        'molecules per page:', 'HorizontalAlignment', 'right', ...
        'Position', [xNext yNext w_pop h_txt], 'FontUnits', 'pixels', ...
        'FontSize', fntS);
    
    xNext = w_pan - mg - w_sld;
    yNext = mg;

    h.tm.slider = uicontrol('Style', 'slider', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', 'Position', ...
        [xNext yNext w_sld h_sld], 'Value', max_val, 'Max', max_val, ...
        'Min', min_val, 'Callback', {@slider_Callback, h_fig}, ...
        'SliderStep', [min_step maj_step], 'Visible', vis);
    
    guidata(h_fig, h);
    updatePanel_single(h_fig, nb_mol_disp);
    h = guidata(h_fig);
    
    setProp(get(h.tm.figure_traceMngr, 'Children'), 'Units', 'normalized');
    setProp(get(h.tm.figure_traceMngr, 'Children'), 'FontUnits', ...
        'normalized');
    set([h.tm.uipanel_overview h.tm.uipanel_overall], 'FontUnits', ...
        'pixels');

    arrow_up = [0.92 0.92 0.92 0.92 0.92 0.92 0 0.92 0.92 0.92 0.92 0.92;
                0.92 0.92 0.92 1    1    0    0 0    0.92 0.92 0.92 0.92;
                0.92 0.92 1    1    0    0    0 0    0    0.92 0.92 0.92;
                0.92 1    1    0    0    0    0 0    0    0    0.92 0.92;
                1    1    0    0    0    0    0 0    0    0    0    0.85;
                1    0    0    0    0    0    0 0    0    0    0    0;
                1    1    1    1    1    1    1 1    1    1    1    0.85];

    arrow_up = cat(3,arrow_up,arrow_up,arrow_up);

    dat.arrow = flipdim(arrow_up,1);% close
    dat.open = 1;
    pos_button = get(h.tm.pushbutton_reduce, 'Position');
    pos_panelAll_open = get(h.tm.uipanel_overall, 'Position');
    dat.pos_all = [pos_panelAll_open(1) 1-pos_button(4) ...
        pos_panelAll_open(3) pos_button(4)];% close
    pos_panelSingle_open = get(h.tm.uipanel_overview, 'Position');
    dat.pos_single = [pos_panelSingle_open(1) pos_panelSingle_open(2) ...
        pos_panelAll_open(3) (pos_panelSingle_open(4)+ ...
        pos_panelAll_open(4)-pos_button(4))];% close
    dat.tooltip = 'Show overall panel';% close
    dat.visible = 'off';

    set(h.tm.pushbutton_reduce, 'CData', arrow_up, 'TooltipString', ...
        'Hide overall panel', 'UserData', dat, 'Callback', ...
        {@pushbutton_reduce_Callback, h_fig});

    set(h.tm.figure_traceMngr, 'Visible', 'on');
    
end


function updatePanel_single(h_fig, nb_mol_disp)
    
    h = guidata(h_fig);
    
    nFRET = size(h.param.ttPr.proj{h.param.ttPr.curr_proj}.FRET,1);
    nS = size(h.param.ttPr.proj{h.param.ttPr.curr_proj}.S,1);
    isBot = nS | nFRET;

    mg = 1/12;
    ht_line = (1-2*mg)/nb_mol_disp;
    wd_cb = 1/25;
    wd_axes_tt = 5/8;
    wd_axes_hist = 2/16;
    
    fntS = get(h.tm.axes_ovrAll_1, 'FontSize');
    
    if isfield(h.tm, 'checkbox_molNb')
        for i = 1:size(h.tm.checkbox_molNb,2)
            if ishandle(h.tm.checkbox_molNb(i))
                delete([h.tm.checkbox_molNb(i),h.tm.axes_itt(i),...
                    h.tm.axes_itt_hist(i)]);
                if isBot
                    delete([h.tm.axes_frettt(i), ...
                        h.tm.axes_hist(i)]);
                end
            end
        end
        h.tm = rmfield(h.tm, 'checkbox_molNb');
    end
    
    for i = nb_mol_disp:-1:1
        
        y_next = mg + nb_mol_disp*ht_line - i*ht_line;
        x_next = mg/2;
        
        h.tm.checkbox_molNb(i) = uicontrol('Style', 'checkbox', ...
            'Parent', h.tm.uipanel_overview, 'Units', 'normalized', ...
            'Position', [x_next y_next wd_cb ht_line], 'String', num2str(i), ...
            'Value', h.tm.molValid(i), 'Callback', ...
            {@checkbox_molNb_Callback, h_fig}, 'FontSize', 12, ...
            'BackgroundColor', 0.05*[mod(i,2) mod(i,2) mod(i,2)]+0.85);
        
        y_next = y_next + ht_line*(1-1/(1+isBot)) + 0.01*ht_line;
        x_next = x_next + wd_cb;
        
        h.tm.axes_itt(i) = axes('Parent', h.tm.uipanel_overview, ...
            'Units', 'normalized', 'Position', ...
            [x_next y_next wd_axes_tt ht_line/(1+isBot)], ...
            'YAxisLocation', 'right', 'NextPlot', 'replacechildren', ...
            'GridLineStyle', ':', 'FontUnits', 'pixels', 'FontSize', fntS);
        
        x_next = x_next + wd_axes_tt + 1/16;
        
        h.tm.axes_itt_hist(i) = axes('Parent', h.tm.uipanel_overview, ...
            'Units', 'normalized', 'Position', ...
            [x_next y_next wd_axes_hist ht_line/(1+isBot)], ...
            'YAxisLocation', 'right', ...
            'GridLineStyle', ':', 'FontUnits', 'pixels', 'FontSize', fntS);

        if isBot
            x_next = mg/2 + wd_cb;
            y_next = mg + nb_mol_disp*ht_line - i*ht_line;
        
            h.tm.axes_frettt(i) = axes('Parent', h.tm.uipanel_overview, ...
                'Units', 'normalized', 'Position', ...
                [x_next y_next wd_axes_tt ht_line/2], 'YAxisLocation', ...
                'right', 'NextPlot', 'replacechildren', 'GridLineStyle',...
                ':', 'FontUnits', 'pixels', 'FontSize', fntS);
            
            x_next = x_next + wd_axes_tt + 1/16;
            
            h.tm.axes_hist(i) = axes('Parent', h.tm.uipanel_overview, ...
                'Units', 'normalized', 'Position', ...
                [x_next y_next wd_axes_hist ht_line/2], 'YAxisLocation',...
                'right', 'GridLineStyle', ':', 'FontUnits', 'pixels', ...
                'FontSize', fntS);
        end
    end
    
    guidata(h_fig, h);

end


function checkbox_molNb_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nFRET = size(p.proj{proj}.FRET,1);
    nS = size(p.proj{proj}.S,1);
    isBot = nFRET | nS;
    
    mol = str2num(get(obj, 'String'));
    [o,ind_h,o] = find(h.tm.checkbox_molNb == obj);
    h.tm.molValid(mol) = logical(get(obj, 'Value'));
    guidata(h_fig, h);
    
    if get(obj, 'Value')
        shad = [1 1 1];
    else
        shad = get(h.tm.checkbox_molNb(ind_h), 'BackgroundColor');
    end
    set([h.tm.axes_itt(ind_h), h.tm.axes_itt_hist(ind_h)], 'Color', shad);
    if isBot
        set([h.tm.axes_frettt(ind_h), h.tm.axes_hist(ind_h)], 'Color', ...
            shad);
    end

end


function pushbutton_reduce_Callback(obj, evd, h_fig)

    h = guidata(h_fig);

    dat = get(obj, 'UserData');

    dat_next.arrow = flipdim(dat.arrow,1);
    dat_next.pos_all = get(h.tm.uipanel_overall, 'Position');
    dat_next.pos_single = get(h.tm.uipanel_overview, 'Position');
    dat_next.tooltip = get(h.tm.pushbutton_reduce, 'TooltipString');
    dat_next.open = abs(dat.open - 1);
    dat_next.visible = get(h.tm.popupmenu_axes1, 'Visible');

    set(obj, 'CData', dat.arrow, 'TooltipString', dat.tooltip, ...
        'UserData', dat_next);
    set(get(h.tm.uipanel_overall, 'Children'), 'Visible', dat.visible);
    set(h.tm.uipanel_overall, 'Position', dat.pos_all);
    set(h.tm.uipanel_overview, 'Position', dat.pos_single);
    
    if dat_next.open
        plotData_overall(h_fig);
        
    else
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
        cla(h.tm.axes_ovrAll_1);
        cla(h.tm.axes_ovrAll_2);
        set(h.tm.axes_ovrAll_1, 'UserData', dat1, 'GridLineStyle', ':');
        set(h.tm.axes_ovrAll_2, 'UserData', dat2, 'GridLineStyle', ':');
    end
    
end


function slider_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    nMol = numel(h.tm.molValid);
    
    pos_slider = round(get(obj, 'Value'));
    max_slider = get(obj, 'Max');
    
    nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
    if nb_mol_disp > nMol
        nb_mol_disp = nMol;
    end
    
    for i = 1:nb_mol_disp
        set(h.tm.checkbox_molNb(i), 'String', ...
            num2str(max_slider-pos_slider+i), 'Value', ...
            h.tm.molValid(max_slider-pos_slider+i), 'BackgroundColor', ...
            0.05*[mod(max_slider-pos_slider+i,2) ...
            mod(max_slider-pos_slider+i,2) ...
            mod(max_slider-pos_slider+i,2)]+0.85);
    end
    
    plotDataTm(h_fig);

end


function edit_nbTotMol_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    nb_mol = numel(h.tm.molValid);

    nb_mol_disp = str2num(get(obj, 'String'));
    if nb_mol_disp > nb_mol
        nb_mol_disp = nb_mol;
    end
    updatePanel_single(h_fig, nb_mol_disp);
    
    nb_mol_page = str2num(get(h.tm.edit_nbTotMol, 'String'));
    if nb_mol <= nb_mol_page || nb_mol_page == 0
        min_step = 1;
        maj_step = 1;
        min_val = 0;
        max_val = 1;
        set(h.tm.slider, 'Visible', 'off');
    else
        set(h.tm.slider, 'Visible', 'on');
        min_val = 1;
        max_val = nb_mol-nb_mol_page+1;
        min_step = 1/(max_val-min_val);
        maj_step = nb_mol_page/(max_val-min_val);
    end
    
    set(h.tm.slider, 'Value', max_val, 'Max', max_val, 'Min', min_val, ...
        'SliderStep', [min_step maj_step]);
    
    plotDataTm(h_fig);

end


function plotDataTm(h_fig)

    global intensities;

    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nFRET = size(p.proj{proj}.FRET,1);
    nS = size(p.proj{proj}.S,1);
    isBot = nFRET | nS;
    
    m = p;
    m.proj{proj}.intensities_denoise = intensities;
    
    mol = p.curr_mol(proj);
    prm = p.proj{proj}.prm{mol};

    for i = 1:size(h.tm.checkbox_molNb,2)
        mol_nb = str2num(get(h.tm.checkbox_molNb(i), 'String'));
        
        axes.axes_traceTop = h.tm.axes_itt(i);
        axes.axes_histTop = h.tm.axes_itt_hist(i);
        if isBot
            axes.axes_traceBottom = h.tm.axes_frettt(i);
            axes.axes_histBottom = h.tm.axes_hist(i);
        end
        
        plotData(mol_nb, m, axes, prm, 0);
        
        if h.tm.molValid(mol_nb)
            shad = [1 1 1];
        else
            shad = get(h.tm.checkbox_molNb(i), 'BackgroundColor');
        end
        set([h.tm.axes_itt(i) h.tm.axes_itt_hist(i)], 'Color', shad);
        if isBot
            set([h.tm.axes_frettt(i), h.tm.axes_hist(i)], 'Color', shad);
            if i ~= size(h.tm.checkbox_molNb,2)
                set(get(h.tm.axes_frettt(i), 'Xlabel'), 'String', '');
                set(get(h.tm.axes_itt_hist(i), 'Xlabel'), 'String', '');
            end
        elseif i ~= size(h.tm.checkbox_molNb,2)
            set(get(h.tm.axes_itt(i), 'Xlabel'), 'String', '');
            set(get(axes.axes_histTop, 'Xlabel'), 'String', '');
        end
        set(h.tm.checkbox_molNb(i), 'Value', h.tm.molValid(mol_nb));
    end
end


function pushbutton_update_Callback(obj, evd, h_fig)
    
    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nMol = numel(h.tm.molValid);

    m = p;
    
    nChan = p.proj{proj}.nb_channel;
    exc = p.proj{proj}.excitations;
    chanExc = p.proj{proj}.chanExc;
    labels = p.proj{proj}.labels;
    nExc = p.proj{proj}.nb_excitations;
    FRET = p.proj{proj}.FRET;
    nFRET = size(FRET,1);
    S = p.proj{proj}.S;
    nS = size(S,1);
    perSec = p.proj{proj}.fix{2}(4);
    perPix = p.proj{proj}.fix{2}(5);
    inSec = p.proj{proj}.fix{2}(7);
    rate = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);
    
    def_niv = 200;
    dat1.trace = cell(1,nChan*nExc+nFRET+nS);
    dat1.lim = dat1.trace;
    dat1.ylabel = cell(1,nChan*nExc+nFRET+nS+4);
    dat1.color = dat1.trace;
    
    str_extra = [];
    if perSec
        str_extra = [str_extra ' per s.'];
    end
    if perPix
        str_extra = [str_extra ' per pix.'];
    end
    if inSec
        dat1.xlabel = 'time (s)';
    else
        dat1.xlabel = 'frame number';
    end
    dat2.hist = dat1.trace;
    dat2.iv = dat1.trace;
    
    global intensities;
        
    % loading bar parameters-----------------------------------------------
    err = loading_bar('init', h_fig , nMol, ...
        'Collecting data from MASH ...');
    if err
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    % ---------------------------------------------------------------------
    
    clr = p.proj{proj}.colours;
    for i = 1:nMol
        dtaCurr = m.proj{proj}.curr{i}{4};
        if ~isempty(m.proj{proj}.prm{i})
            dtaPrm = m.proj{proj}.prm{i}{4};
        else
            dtaPrm = [];
        end
        m = plotSubImg(i, m, []);
        [m opt] = resetMol(i, m);
        if strcmp(opt, 'ttBg') || strcmp(opt, 'ttPr')
            m = bgCorr(i, m);
        end
        if strcmp(opt, 'corr') || strcmp(opt, 'ttBg') || ...
                strcmp(opt, 'ttPr')
            m = crossCorr(i, m);
        end
        if strcmp(opt, 'denoise') || strcmp(opt, 'corr') || ...
                strcmp(opt, 'ttBg') || strcmp(opt, 'ttPr')
            m = denoiseTraces(i, m);
        end
        if strcmp(opt, 'debleach') || strcmp(opt, 'denoise') || ...
                strcmp(opt, 'corr') || strcmp(opt, 'ttBg') || ...
                strcmp(opt, 'ttPr')
            m = calcCutoff(i, m);
        end
        m.proj{proj}.curr{i} = m.proj{proj}.prm{i};
        m.proj{proj}.prm{i}{4} = dtaPrm;
        m.proj{proj}.curr{i}{4} = dtaCurr;

        intensities(:,(nChan*(i-1)+1):nChan*i,:) = ...
            m.proj{proj}.intensities_denoise(:, ...
            (nChan*(i-1)+1):nChan*i,:);
            
        % loading bar update-----------------------------------
        err = loading_bar('update', h_fig);
        % -----------------------------------------------------

        if err
            return;
        end
    end
    loading_bar('close', h_fig);
    
    h.param.ttPr = m;
    guidata(h_fig,h);
    
    % loading bar parameters-----------------------------------------------
    err = loading_bar('init', h_fig , nMol, ...
        'Concatenate and calculate data ...');
    if err
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    % ---------------------------------------------------------------------
    
    for i = 1:nMol
        if h.tm.molValid(i)
            for l = 1:nExc
                for c = 1:nChan
                    ind = (l-1)*nChan+c;
                    incl = m.proj{proj}.bool_intensities(:,i);
                    I = intensities(incl,nChan*(i-1)+c,l);
                    if perSec
                        I = I/rate;
                    end
                    if perPix
                        I = I/nPix;
                    end
                    dat1.trace{ind} = [dat1.trace{ind}; reshape(I, ...
                        [numel(I), 1])];
                    dat1.color{ind} = clr{1}{l,c};
                end
            end
            I = intensities(incl,(nChan*(i-1)+1):nChan*i,:);
            gamma = p.proj{proj}.curr{i}{5}{3};
            fret = calcFRET(nChan, nExc, exc, chanExc, FRET, I, gamma);
            for n = 1:nFRET
                ind = ind + 1;
                FRET_tr = fret(:,n);
                FRET_tr(FRET_tr == Inf) = 1000000;
                FRET_tr(FRET_tr == -Inf) = -1000000;
                dat1.trace{ind} = [dat1.trace{ind}; ...
                    reshape(FRET_tr, [numel(FRET_tr) 1])];
                dat1.color{ind} = clr{2}(n,:);
            end
            for n = 1:nS
                ind = ind + 1;
                [o,l_s,o] = find(exc==chanExc(S(n)));
                Inum = sum(intensities(incl, ...
                    (nChan*(i-1)+1):nChan*i,l_s),2);
                Iden = sum(sum(intensities(incl, ...
                    (nChan*(i-1)+1):nChan*i,:),2),3);
                S_tr = Inum./Iden;
                S_tr(S_tr == Inf) = 1000000;
                S_tr(S_tr == -Inf) = -1000000;
                dat1.trace{ind} = [dat1.trace{ind}; ...
                    reshape(S_tr, [numel(S_tr) 1])];
                dat1.color{ind} = clr{3}(n,:);
            end
        end
        
        % loading bar update-----------------------------------
        err = loading_bar('update', h_fig);
        % -----------------------------------------------------

        if err
            return;
        end
    end
    disp('data successfully concatenated !');
    loading_bar('close', h_fig);
    
    for ind = 1:size(dat1.trace,2)
        if ind <= nChan*nExc
            dat1.lim{ind} = [min(dat1.trace{ind}) max(dat1.trace{ind})];
        else
            dat1.lim{ind} = [-0.2 1.2];
        end
        dat1.niv(ind) = def_niv;

        bin = (dat1.lim{ind}(2) - dat1.lim{ind}(1)) / dat1.niv(ind);
        iv = (dat1.lim{ind}(1) - bin):bin:(dat1.lim{ind}(2) + bin);
        [dat2.hist{ind}, dat2.iv{ind}] = hist(dat1.trace{ind}, iv);
    end
    
    str_plot = {};

    for l = 1:nExc
        for c = 1:nChan
            clr_bg_c = sprintf('rgb(%i,%i,%i)', ...
                round(clr{1}{l,c}(1:3)*255));
            clr_fbt_c = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*sum(double( ...
                clr{1}{l,c}(1:3) <= 0.5)));
            str_plot = [str_plot ...
                ['<html><span style= "background-color: ' ...
                clr_bg_c ';color: ' clr_fbt_c ';"> ' labels{c} ...
                ' at ' num2str(exc(l)) 'nm</span></html>']];
            dat1.ylabel{size(str_plot,2)} = ['counts' str_extra];
        end
    end
    for n = 1:nFRET
        clr_bg_f = sprintf('rgb(%i,%i,%i)', ...
            round(clr{2}(n,1:3)*255));
        clr_fbt_f = sprintf('rgb(%i,%i,%i)', ...
            [255 255 255]*sum(double( ...
            clr{2}(n,1:3) <= 0.5)));
        str_plot = [str_plot ['<html><span style= "background-color: '...
            clr_bg_f ';color: ' clr_fbt_f ';">FRET ' labels{FRET(n,1)} ...
            '>' labels{FRET(n,2)} '</span></html>']];
        dat1.ylabel{size(str_plot,2)} = 'FRET';
    end
    for n = 1:nS
        clr_bg_s = sprintf('rgb(%i,%i,%i)', ...
            round(clr{3}(n,1:3)*255));
        clr_fbt_s = sprintf('rgb(%i,%i,%i)', ...
            [255 255 255]*sum(double( ...
            clr{3}(n,1:3) <= 0.5)));
        str_plot = [str_plot ['<html><span style= "background-color: '...
            clr_bg_s ';color: ' clr_fbt_s ';">S ' labels{S(n)} ...
            '</span></html>']];
        dat1.ylabel{size(str_plot,2)} = 'S';
    end
    
    if nChan > 1 || nExc > 1
        str_plot = [str_plot 'all intensity traces'];
        dat1.ylabel{size(str_plot,2)} = ['counts' str_extra];
    end
    if nFRET > 1
        str_plot = [str_plot 'all FRET traces'];
        dat1.ylabel{size(str_plot,2)} = 'FRET';
    end
    if nS > 1
        str_plot = [str_plot 'all S traces'];
        dat1.ylabel{size(str_plot,2)} = 'S';
    end
    if nFRET > 0 && nS > 0
        str_plot = [str_plot 'all FRET & S traces'];
        dat1.ylabel{size(str_plot,2)} = 'FRET or S';
    end
    
    set(h.tm.popupmenu_axes1, 'String', str_plot);
    set(h.tm.popupmenu_axes2, 'String', str_plot(1:(nChan*nExc+nFRET+nS)));

    set(h.tm.axes_ovrAll_2, 'UserData', dat2);
    set(h.tm.axes_ovrAll_1, 'UserData', dat1);
    
    plot2 = get(h.tm.popupmenu_axes2, 'Value');
    
    set(h.tm.edit_xlim_low, 'String', dat1.lim{plot2}(1));
    set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(2));
    set(h.tm.edit_nbiv, 'String', dat1.niv(plot2));

    plotData_overall(h_fig);
    
end


function plotData_overall(h_fig)

warning('off','MATLAB:hg:EraseModeIgnored');

    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    FRET = p.proj{proj}.FRET;
    nFRET = size(FRET,1);
    S = p.proj{proj}.S;
    nS = size(S,1);
    inSec = p.proj{proj}.fix{2}(7);

    plot1 = get(h.tm.popupmenu_axes1, 'Value');
    plot2 = get(h.tm.popupmenu_axes2, 'Value');
    
    dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
    dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
    
    disp('plot data ...');

    if plot1 <= nChan*nExc+nFRET+nS % single channel/FRET/S
        x_axis = 1:size(dat1.trace{plot1},1);
        if inSec
            rate = p.proj{proj}.frame_rate;
            x_axis = x_axis*rate;
        end
        plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{plot1}, 'Color', ...
            dat1.color{plot1}, 'EraseMode', 'background');
        xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
        if plot1 <= nChan*nExc
            ylim(h.tm.axes_ovrAll_1, [min(dat1.trace{plot1}) ...
                max(dat1.trace{plot1})]);
        else
            ylim(h.tm.axes_ovrAll_1, [-0.2 1.2]);
        end
        xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
        ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});
        
        
    elseif plot1 == nChan*nExc+nFRET+nS+1 && nChan > 1% all intensities
        x_axis = 1:size(dat1.trace{1},1);
        if inSec
            rate = p.proj{proj}.frame_rate;
            x_axis = x_axis*rate;
        end
        min_y = Inf;
        max_y = -Inf;
        set(h.tm.axes_ovrAll_1, 'NextPlot', 'add');
        for l = 1:nExc
            for c = 1:nChan
                ind = (l-1)+c;
                plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{ind}, ...
                    'Color', dat1.color{ind}, 'EraseMode', 'background');
                min_y = min([min_y min(dat1.trace{ind})]);
                max_y = max([max_y max(dat1.trace{ind})]);
            end
        end
        set(h.tm.axes_ovrAll_1, 'NextPlot', 'replacechildren');
        xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
        ylim(h.tm.axes_ovrAll_1, [min_y max_y]);
        xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
        ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});
        
    elseif plot1 == nChan*nExc+nFRET+nS+2 && nFRET > 1% all FRET
        x_axis = 1:size(dat1.trace{nChan*nExc+1},1);
        if inSec
            rate = p.proj{proj}.frame_rate;
            x_axis = x_axis*rate;
        end
        set(h.tm.axes_ovrAll_1, 'NextPlot', 'add');
        for n = 1:nFRET
            ind = nChan*nExc+n;
            plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{ind}, ...
                'Color', dat1.color{ind}, 'EraseMode', 'background');
        end
        set(h.tm.axes_ovrAll_1, 'NextPlot', 'replacechildren');
        xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
        ylim(h.tm.axes_ovrAll_1, [-0.2 1.2]);
        xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
        ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});
        
    elseif (plot1 == nChan*nExc+nFRET+nS+2 && nFRET == 1 && nS > 1) || ...
            (plot1 == nChan*nExc+nFRET+nS+3 && nFRET > 1 && nS > 1)% all S
        x_axis = 1:size(dat1.trace{nChan*nExc+nFRET+1},1);
        if inSec
            rate = p.proj{proj}.frame_rate;
            x_axis = x_axis*rate;
        end
        set(h.tm.axes_ovrAll_1, 'NextPlot', 'add');
        for n = 1:nS
            ind = nChan*nExc+nFRET+n;
            plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{ind}, ...
                'Color', dat1.color{ind}, 'EraseMode', 'background');
        end
        set(h.tm.axes_ovrAll_1, 'NextPlot', 'replacechildren');
        xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
        ylim(h.tm.axes_ovrAll_1, [-0.2 1.2]);
        xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
        ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});
        
    elseif (plot1 == nChan*nExc+nFRET+nS+2 && nFRET == 1 && nS == 1) || ...
            (plot1 == nChan*nExc+nFRET+nS+3 && ((nFRET > 1 && nS == 1) ...
            || (nFRET == 1 && nS > 1))) || (plot1 == ...
            nChan*nExc+nFRET+nS+4 && nFRET > 1 && nS > 1) % all FRET & S
        x_axis = 1:size(dat1.trace{nChan*nExc+1},1);
        if inSec
            rate = p.proj{proj}.frame_rate;
            x_axis = x_axis*rate;
        end
        set(h.tm.axes_ovrAll_1, 'NextPlot', 'add');
        for n = 1:nFRET+nS
            ind = nChan*nExc+n;
            plot(h.tm.axes_ovrAll_1, x_axis, dat1.trace{ind}, ...
                'Color', dat1.color{ind}, 'EraseMode', 'background');
        end
        set(h.tm.axes_ovrAll_1, 'NextPlot', 'replacechildren');
        xlim(h.tm.axes_ovrAll_1, [x_axis(1) x_axis(end)]);
        ylim(h.tm.axes_ovrAll_1, [-0.2 1.2]);
        xlabel(h.tm.axes_ovrAll_1, dat1.xlabel);
        ylabel(h.tm.axes_ovrAll_1, dat1.ylabel{plot1});
    end

    xlim(h.tm.axes_ovrAll_2, [dat1.lim{plot2}(1),dat1.lim{plot2}(2)]);
    ylim(h.tm.axes_ovrAll_2, 'auto');
    
    bar(h.tm.axes_ovrAll_2, dat2.iv{plot2}, dat2.hist{plot2}, ...
        'FaceColor', dat1.color{plot2}, 'EdgeColor', ...
        dat1.color{plot2});
    
    xlabel(h.tm.axes_ovrAll_2, dat1.ylabel{plot2});
    ylabel(h.tm.axes_ovrAll_2, 'freq. counts');
end


function popupmenu_axes_Callback(obj, evd, h_fig)

    h = guidata(h_fig);

    if obj == h.tm.popupmenu_axes2
        plot2 = get(obj, 'Value');
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        set(h.tm.edit_xlim_low, 'String', dat1.lim{plot2}(1));
        set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(2));
        set(h.tm.edit_nbiv, 'String', dat1.niv(plot2));
    end
    
    plotData_overall(h_fig);
    
end


function menu_export_Callback(obj, evd, h_fig)

    saveNclose = questdlg(['Do you want to export the traces to ' ...
        'MASH and close the trace manager?'], ...
        'Close and export to MASH smFRET', 'Yes', 'No', 'No');
    
    if strcmp(saveNclose, 'Yes')
        h = guidata(h_fig);
        h.param.ttPr.proj{h.param.ttPr.curr_proj}.coord_incl = ...
            h.tm.molValid;
        h.tm.ud = true;
        guidata(h_fig,h);
        uiresume(h.tm.figure_traceMngr);
    end

end


function edit_xlim_low_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    xlim_low = str2num(get(obj, 'String'));
    xlim_up = str2num(get(h.tm.edit_xlim_up, 'String'));
    
    if xlim_low < xlim_up
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
        plot2 = get(h.tm.popupmenu_axes2, 'Value');
        
        dat1.lim{plot2} = [xlim_low xlim_up];
        
        bin = (dat1.lim{plot2}(2) - dat1.lim{plot2}(1)) / dat1.niv(plot2);
        iv = (dat1.lim{plot2}(1) - bin):bin:(dat1.lim{plot2}(2) + bin);
        [dat2.hist{plot2}, dat2.iv{plot2}] = hist(dat1.trace{plot2}, iv);
        
        set(h.tm.axes_ovrAll_1, 'UserData', dat1);
        set(h.tm.axes_ovrAll_2, 'UserData', dat2);
        
        plotData_overall(h_fig);
        
    else
        str = 'The low x limit must be lower than the up x limit.';
        errordlg(str);
        disp(str);
    end
    
end


function edit_xlim_up_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    xlim_up = str2num(get(obj, 'String'));
    xlim_low = str2num(get(h.tm.edit_xlim_low, 'String'));
    
    if xlim_low < xlim_up
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
        plot2 = get(h.tm.popupmenu_axes2, 'Value');
        
        dat1.lim{plot2} = [xlim_low xlim_up];
        
        bin = (dat1.lim{plot2}(2) - dat1.lim{plot2}(1)) / dat1.niv(plot2);
        iv = (dat1.lim{plot2}(1) - bin):bin:(dat1.lim{plot2}(2) + bin);
        [dat2.hist{plot2}, dat2.iv{plot2}] = hist(dat1.trace{plot2}, iv);
        
        set(h.tm.axes_ovrAll_1, 'UserData', dat1);
        set(h.tm.axes_ovrAll_2, 'UserData', dat2);
        
        plotData_overall(h_fig);
        
    else
        str = 'The low x limit must be lower than the up x limit.';
        errordlg(str);
        disp(str);
    end

end


function edit_nbiv_Callback(obj, evd, h_fig)
    
    h = guidata(h_fig);
    nbiv = round(str2num(get(obj, 'String')));
    if ~isnumeric(nbiv) || nbiv < 1
        nbiv = 1;
    end
    
    dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
    dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
    plot2 = get(h.tm.popupmenu_axes2, 'Value');

    dat1.niv(plot2) = nbiv;

    bin = (dat1.lim{plot2}(2) - dat1.lim{plot2}(1)) / dat1.niv(plot2);
    iv = (dat1.lim{plot2}(1) - bin):bin:(dat1.lim{plot2}(2) + bin);
    [dat2.hist{plot2}, dat2.iv{plot2}] = hist(dat1.trace{plot2}, iv);

    set(h.tm.axes_ovrAll_1, 'UserData', dat1);
    set(h.tm.axes_ovrAll_2, 'UserData', dat2);
    
    plotData_overall(h_fig);

end


function checkbox_all_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    if get(obj, 'Value')
        h.tm.molValid = true(size(h.tm.molValid));
    else
        h.tm.molValid = false(size(h.tm.molValid));
    end
    guidata(h_fig, h);
    plotDataTm(h_fig);

end


function figure_traceMngr(obj, evd, h_fig)

    h = guidata(h_fig);
    h = rmfield(h, 'tm');
    guidata(h_fig, h);
    delete(obj);

end

