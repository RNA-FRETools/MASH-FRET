% traceManager(h_fig)
%
% Enables trace selection upon visual inspection or defined criteria 
% "h_fig" >> 

% Created the ??th of ???? 201? by Mélodie C.A.S. Hadzic
% Last update: the 5rd of January 2018 by Richard Börner
% >> include FRET-S-Histogram
% >> include inverse selection button
% >> restructured dat2.hist, dat2.iv and dat1.lim

function traceManager(h_fig)
   
    h = guidata(h_fig);
    h.tm.ud = false;
    guidata(h_fig,h);
    
    p = h.param.ttPr;
    proj = p.curr_proj;
    
    % molecule tags, added by FS, 24.4.2018
    h.tm.molTagNames = p.proj{proj}.molTagNames;
    h.tm.molTag = p.proj{proj}.molTag;
    guidata(h_fig, h);
    
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

% define colors for tag names; added by FS, 24.4.2018
function str_lst = colorTagNames(h_fig)
h = guidata(h_fig);
colorlist = {'transparent', '#4298B5', '#DD5F32', '#92B06A', '#ADC4CC', '#E19D29'};
str_lst = cell(1,length(h.tm.molTagNames));
str_lst{1} = h.tm.molTagNames{1};
 
for k = 2:length(h.tm.molTagNames)
    str_lst{k} = ['<html><body  bgcolor="' colorlist{k} '">' ...
        '<font color="white">' h.tm.molTagNames{k} '</font></body></html>'];
end
end

function openMngrTool(h_fig)

%% Last update by MH, 24.4.2019
% >> add toolbar and empty tools "Auto sorting" and "View of video"
% >> rename "Overview" panel in "Molecule selection"
%
% update: by FS, 24.4.2018
% >> add debugging mode where all other windows are not deactivated
% >> add edit box to define a molecule tag
% >> add popup menu to select molecule tag
% >> add popup menu to select molecule tag
%
% update: by RB, 5.1.2018
% >> new pushbutton to inverse the selection of individual molecules
% >> add "to do" section: include y-axes control for FRET-S-Histogram
%
% update: by RB, 3.1.2018
% >> adapt width of popupmenu for FRET-S-Histogram 
%
% update: by RB, 15.12.2017
% >> update popupmenu_axes1 and popupmenu_axes2 string
%
%%

    
    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nb_mol = numel(p.proj{proj}.coord_incl);
    
    wFig = 900;
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
    fntS_big = 12;
    h_edit = 20; w_edit = 40;

    w_pop = 120; % RB 2018-01-03: adapt width of popupmenu for FRET-S-Histogram 
    h_but = 20; w_but = (w_pop-mg)/2;
    h_but_big = 30; w_but_big = 120;

    h_txt = 14;
    w_pan = wFig - 2*mg;

    h_pan_all = mg_ttl + 3*mg + mg_big + 2*h_edit + 2*h_txt + h_but;
    h_toolbar = h_but_big + 2*mg;
    h_pan_sgl = hFig - mg_win - 4*mg - h_pan_all - h_toolbar;
    h_pan_tool = h_pan_all + mg + h_pan_sgl;
    
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
        'off', 'Name', [get(h_fig, 'Name') ' - Trace manager']);
    
    % add debugging mode where all other windows are not deactivated
    % added by FS, 24.4.2018
    debugMode = 1;
    if ~debugMode
        set(h.tm.figure_traceMngr, 'WindowStyle', 'modal')
    end
    
    x_0 = mg;
    y_0 = hFig - mg_win;

    xNext = x_0;
    yNext = y_0 - mg - h_but_big;
    
    h.tm.togglebutton_overview = uicontrol('style','togglebutton','parent',...
        h.tm.figure_traceMngr,'units','pixels','position',...
        [xNext,yNext,w_but_big,h_but_big],'string','Overview','fontweight',...
        'bold','fontunits','pixels','fontsize',fntS_big,'callback',...
        {@switchPan_TM,h_fig});
    
    xNext = xNext + w_but_big + mg;
    
    h.tm.togglebutton_autoSorting = uicontrol('style','togglebutton',...
        'parent',h.tm.figure_traceMngr,'units','pixels','position',...
        [xNext,yNext,w_but_big,h_but_big],'string','Auto sorting',...
        'fontweight','bold','fontunits','pixels','fontsize',fntS_big,...
        'callback',{@switchPan_TM,h_fig});
    
    xNext = xNext + w_but_big + mg;
    
    h.tm.togglebutton_videoView = uicontrol('style','togglebutton','parent',...
        h.tm.figure_traceMngr,'units','pixels','position',...
        [xNext,yNext,w_but_big,h_but_big],'string','View on video',...
        'fontweight','bold','fontunits','pixels','fontsize',fntS_big,...
        'callback',{@switchPan_TM,h_fig});
    
    xNext = mg;
    yNext = yNext - mg - h_pan_all;
    
    h.tm.uipanel_overall = uipanel('Parent', h.tm.figure_traceMngr, ...
        'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_all], ...
        'Title', 'Overall plots', 'FontUnits', 'pixels', 'FontSize', fntS);
    
    yNext = yNext - mg - h_pan_sgl;
    
    h.tm.uipanel_overview = uipanel('Parent', h.tm.figure_traceMngr, ...
        'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_sgl], ...
        'Title','Molecule selection','FontUnits','pixels','FontSize',fntS);
    
    yNext = y_0 - mg - h_but_big - mg - h_pan_tool;
    
    h.tm.uipanel_autoSorting = uipanel('Parent', h.tm.figure_traceMngr, ...
        'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_tool], ...
        'Title', '', 'FontUnits', 'pixels', ...
        'FontSize', fntS, 'Visible', 'off');
    
    h.tm.uipanel_videoView = uipanel('Parent', h.tm.figure_traceMngr, ...
        'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_tool], ...
        'Title', '', 'FontUnits', 'pixels', ...
        'FontSize', fntS, 'Visible', 'off');
    
    
    %% all results panel
    
    xNext = mg;
    yNext = h_pan_all - mg_ttl - mg - h_txt;
    
    h.tm.text1 = uicontrol('Style', 'text', 'Parent', ...
        h.tm.uipanel_overall, 'Units', 'pixels', 'String', ...
        'Plot axes1:', 'HorizontalAlignment', 'center', 'Position', ...
        [xNext yNext w_pop h_txt], 'FontUnits', 'pixels', 'FontSize', ...
        fntS);
    
    yNext = yNext - h_edit;
    
    % RB 2017-12-15: update str_plot 
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
    
    % RB 2017-12-15: update str_plot 
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
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   % RB 2018-01-05 to do: include y-axes control for FRET-S-Histogram
   %     yNext = h_pan_all - mg_ttl - mg - h_edit;
   %     
   %     h.tm.edit_xlim_low = uicontrol('Style', 'edit', 'Parent', ...
   %         h.tm.uipanel_overall, 'Position', [xNext yNext w_edit h_edit],
   %         ... 'Callback', {@edit_xlim_low_Callback, h_fig}, 'String', '0',
   %         ... 'BackgroundColor', [1 1 1], 'TooltipString', ... 'lower
   %         interval value');
   %
   %     xNext = xNext + mg + w_edit;
   %
   %     h.tm.edit_nbiv = uicontrol('Style', 'edit', 'Parent', ...
   %         h.tm.uipanel_overall, 'Position', [xNext yNext w_edit h_edit],
   %         ... 'Callback', {@edit_nbiv_Callback, h_fig}, 'String', '200',
   %         ... 'BackgroundColor', [1 1 1], 'TooltipString', 'number of
   %         interval');
   %
   %     xNext = xNext + mg + w_edit;
   %
   %     h.tm.edit_xlim_up = uicontrol('Style', 'edit', 'Parent', ...
   %         h.tm.uipanel_overall, 'Position', [xNext yNext w_edit h_edit],
   %         ... 'Callback', {@edit_xlim_up_Callback, h_fig}, 'String', '1',
   %         ... 'BackgroundColor', [1 1 1], 'TooltipString', ... 'upper
   %         interval value');
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
   
   
    %% TM panel overview
    
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
    
    % RB 2018-01-05: new pushbotton to inverse the selcetion of individual
    % molecules
    
    xNext = xNext + 2/3*w_pop ;
    
    h.tm.pushbutton_inverse = uicontrol('Style', 'pushbutton', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', 'FontWeight', 'bold', ...
        'String', 'Invert Selection', 'Position', [xNext yNext 4/5*w_pop h_but], ...
        'TooltipString', 'Invert selection of all molecules', 'Callback', ...
        {@pushbutton_all_inverse_Callback, h_fig}, 'FontUnits', 'pixels', ...
        'FontSize', fntS);
    
    
    % edit box to define a molecule tag, added by FS, 24.4.2018
    xNext = xNext + w_pop;
    h.tm.edit_molTag = uicontrol('Style', 'edit', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', ...
        'String', 'define a new tag', 'Position', [xNext yNext w_pop h_but], ...
        'Callback', {@edit_addMolTag_Callback, h_fig}, ...
        'FontUnits', 'pixels', ...
        'FontSize', fntS);
    

    % popup menu to select molecule tag, added by FS, 24.4.2018
    xNext = xNext + w_pop + mg;
    str_lst = colorTagNames(h_fig);
    h.tm.popup_molTag = uicontrol('Style', 'popup', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', ...
        'String', str_lst, ...
        'Position', [xNext yNext w_pop h_but], ...
        'TooltipString', 'select a molecule tag', ...
        'FontUnits', 'pixels', ...
        'FontSize', fntS);
    
    % popup menu to select molecule tag, added by FS, 24.4.2018
    xNext = xNext + w_pop + mg;
    h.tm.pushbutton_deleteMolTag = uicontrol('Style', 'pushbutton', 'Parent', ...
        h.tm.uipanel_overview, 'Units', 'pixels', ...
        'String', 'delete tag', ...
        'Position', [xNext yNext 1/2*w_pop h_but], ...
        'TooltipString', 'select a molecule tag', ...
        'Callback', {@pushbutton_deleteMolTag_Callback, h_fig}, ...    
        'FontUnits', 'pixels', ...
        'FontSize', fntS);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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
    
    switchPan_TM(h.tm.togglebutton_overview,[],h_fig);
    
end

function switchPan_TM(obj,evd,h_fig)
% Render the selected tool visible and other tools invisible

%% Created by MH, 24.4.2019
%
%%

h = guidata(h_fig);

green = [0.76 0.87 0.78];
grey = [240/255 240/255 240/255];

set(obj,'Value',1,'BackgroundColor',green);

switch obj
    case h.tm.togglebutton_overview
        set([h.tm.togglebutton_autoSorting,h.tm.togglebutton_videoView],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_autoSorting,h.tm.uipanel_videoView],'Visible',...
            'off');
        set([h.tm.uipanel_overall,h.tm.uipanel_overview], 'Visible', 'on');
        
    case h.tm.togglebutton_autoSorting
        set([h.tm.togglebutton_overview,h.tm.togglebutton_videoView],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_overall,h.tm.uipanel_overview,...
            h.tm.uipanel_videoView],'Visible','off');
        set(h.tm.uipanel_autoSorting, 'Visible', 'on');
        
    case h.tm.togglebutton_videoView
        set([h.tm.togglebutton_overview,h.tm.togglebutton_autoSorting],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_overall,h.tm.uipanel_overview,...
            h.tm.uipanel_autoSorting],'Visible','off');
        set(h.tm.uipanel_videoView, 'Visible', 'on');
end
end


function updatePanel_single(h_fig, nb_mol_disp)
    
    h = guidata(h_fig);
    
    nFRET = size(h.param.ttPr.proj{h.param.ttPr.curr_proj}.FRET,1);
    nS = size(h.param.ttPr.proj{h.param.ttPr.curr_proj}.S,1);
    isBot = nS | nFRET;

    mg = 1/12;
    ht_line = (1-2*mg)/nb_mol_disp;
    %wd_cb = 1/25;
    wd_cb = 1/15;
    wd_axes_tt = 5/8;
    wd_axes_hist = 2/16;
    w_pop = 1/15;
    
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
        
        
        % added by FS, 24.4.2018
        str_lst = colorTagNames(h_fig);
        if h.tm.molTag(i) > length(str_lst)
            val = 1;
        else
            val = h.tm.molTag(i);
        end
        h.tm.popup_molNb(i) = uicontrol('Style', 'popup', ...
            'Parent', h.tm.uipanel_overview, 'Units', 'normalized', ...
            'Position', [x_next y_next w_pop ht_line], 'String',  str_lst, ...
            'Value', val, 'Callback', ...
            {@popup_molTag_Callback, h_fig, i}, ...
            'BackgroundColor', 0.05*[mod(i,2) mod(i,2) mod(i,2)]+0.85);
        % deactivate the popupmenu if the molecule is not selected
        % added by FS, 24.4.2018
        if h.tm.molValid(i) == 0
            set(h.tm.popup_molNb(i), 'Enable', 'off')
        else
            set(h.tm.popup_molNb(i), 'Enable', 'on')
        end
        
        
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


function update_popups(h_fig, nb_mol_disp)
h = guidata(h_fig);
for i = nb_mol_disp:-1:1
    % added by FS, 25.4.2018
    str_lst = colorTagNames(h_fig);
    set(h.tm.popup_molNb(i), 'String', str_lst)
end
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
    
    % deactivate the popupmenu if the molecule is not selected
    % added by FS, 24.4.2018
    if h.tm.molValid(mol) == 0
        set(h.tm.popup_molNb(ind_h), 'Enable', 'off', 'Value', 1)
        h.tm.molTag(mol) = 1;
        guidata(h_fig, h)
    else
        set(h.tm.popup_molNb(ind_h), 'Enable', 'on')
    end

end

% added by FS, 24.4.2018, modified by FS, 25.5.2018
function popup_molTag_Callback(obj, evd, h_fig, ~)
    % the molecule is passed directly to the callback, since the string
    % variable is already occupied with the molecule tags
    h = guidata(h_fig);
    pos_slider = round(get(h.tm.slider, 'Value'));
    max_slider = get(h.tm.slider, 'Max');
    cb = get(obj, 'Callback');
    mol = max_slider-pos_slider+cb{3};
    h.tm.molTag(mol) = get(obj, 'Value');
    guidata(h_fig, h);
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
        
        
        % added by FS, 24.4.2018
        str_lst = colorTagNames(h_fig);
        if h.tm.molTag(max_slider-pos_slider+i) > length(str_lst)
            val = 1;
        else
            val = h.tm.molTag(max_slider-pos_slider+i);
        end
        set(h.tm.popup_molNb(i), 'String', ...
            str_lst, 'Value', ...
            val, 'BackgroundColor', ...
            0.05*[mod(max_slider-pos_slider+i,2) ...
            mod(max_slider-pos_slider+i,2) ...
            mod(max_slider-pos_slider+i,2)]+0.85);
        % deactivate the popupmenu if the molecule is not selected
        % added by FS, 24.4.2018
        if h.tm.molValid(max_slider-pos_slider+i) == 0
            set(h.tm.popup_molNb(i), 'Enable', 'off')
        else
            set(h.tm.popup_molNb(i), 'Enable', 'on')
        end
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

% RB 2018-01-03: adapted for FRET-S-histograms
function pushbutton_update_Callback(obj, evd, h_fig)
    
    % get guidata
    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nMol = numel(h.tm.molValid);

    m = p;
    
    % get variables from the indiviudal project `proj`
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
    
    % allocate cells
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
    %dat2.hist = dat1.trace; %old
    %dat2.iv = dat1.trace; %old
    dat2.hist = cell(1,nChan*nExc+nFRET+nS+nFRET); % RB 2018-01-03:
    dat2.iv = dat2.hist; % RB 2018-01-03:
    
    global intensities;
        
    % loading bar parameters-----------------------------------------------
    err = loading_bar('init', h_fig , nMol, ...
        'Collecting data from MASH ...');
    if err
        return;
    end
    h = guidata(h_fig); % update:  get current guidata 
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h); % update: set current guidata 
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
                S_tr(S_tr == Inf) = 1000000; % prevent for Inf
                S_tr(S_tr == -Inf) = -1000000; % prevent for Inf
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
    
    % RB 2018-01-04: adapted for FRET-S-Histogram, hist2 is rather slow
    % RB 2018-01-05: hist2 replaced by hist2D
    % loading bar parameters-----------------------------------------------
    err = loading_bar('init', h_fig , (nChan*nExc+nFRET+nS+nFRET*nS), ...
        'Histogram data ...');
    if err
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    % ---------------------------------------------------------------------
    
    % RB 2018-01-04: adapted for FRET-S-Histogram
    ES = []; % local array
    % MH 2019-03-27: collect ES indexes
    ind_es = [];
    for fret = 1:nFRET
        for s = 1:nS
            ind_es = cat(1,ind_es,[fret,s]);
        end
    end
    for ind = 1:(size(dat1.trace,2)+nFRET*nS) % counts for nChan*nExc Intensity channels, nFRET channles, nS channels and nFRET ES histograms
        dat1.niv(ind) = def_niv;
        if ind <= nChan*nExc % intensity histogram 1D 
            dat1.lim{ind} = [min(dat1.trace{ind}) max(dat1.trace{ind})];
            bin = (dat1.lim{ind}(2) - dat1.lim{ind}(1)) / dat1.niv(ind);
            iv = (dat1.lim{ind}(1) - bin):bin:(dat1.lim{ind}(2) + bin);
            [dat2.hist{ind}, dat2.iv{ind}] = hist(dat1.trace{ind}, iv); % HISTOGRAM replaces hist since 2015! 
        elseif ind <= (nChan*nExc + nFRET + nS) % FRET and S histogram 1D
            dat1.lim{ind} = [-0.2 1.2];
            bin = (dat1.lim{ind}(2) - dat1.lim{ind}(1)) / dat1.niv(ind);
            iv = (dat1.lim{ind}(1) - bin):bin:(dat1.lim{ind}(2) + bin);
            [dat2.hist{ind}, dat2.iv{ind}] = hist(dat1.trace{ind}, iv); % HISTOGRAM replaces hist since 2015! 
        else  % FRET-S histogram 2D, adapted from getTDPmat.m
            dat1.lim{ind} = [-0.2 1.2; -0.2 1.2];
            %binx = (dat1.lim{ind}(2,2) - dat1.lim{ind}(2,1)) / dat1.niv(ind);
            %biny = (dat1.lim{ind}(1,2) - dat1.lim{ind}(1,1)) / dat1.niv(ind);
            %ivx = (dat1.lim{ind}(2,1) - binx):binx:(dat1.lim{ind}(2,2) + binx);
            %ivy = (dat1.lim{ind}(1,1) - biny):biny:(dat1.lim{ind}(1,2) + biny);
            ind_fret = ind_es(ind-nChan*nExc-nFRET-nS,1) + nChan*nExc;
            ind_s = ind_es(ind-nChan*nExc-nFRET-nS,2) + nChan*nExc + nFRET;
            ES = [dat1.trace{ind_fret},dat1.trace{ind_s}]; % build [N-by-2] or ' ... '[2-by-N] data matrix.']
            %[dat2.hist{ind},o,o,dat2.iv{ind}] = hist2(ES, [ivx;ivy]); % hist2 by MCASH rather slow
            binEdges_minmaxN_xy = [dat1.lim{ind}(1,1) dat1.lim{ind}(1,2) dat1.niv(ind); dat1.lim{ind}(2,1) dat1.lim{ind}(2,2) dat1.niv(ind)];
            [dat2.hist{ind},dat2.iv{ind}(1,:),dat2.iv{ind}(2,:)] = hist2D(ES, binEdges_minmaxN_xy); % hist2D by tudima at zahoo dot com, inlcuded in \traces\processing\management
        end
        
        % old from MCASH
        %bin = (dat1.lim{ind}(2) - dat1.lim{ind}(1)) / dat1.niv(ind);
        %iv = (dat1.lim{ind}(1) - bin):bin:(dat1.lim{ind}(2) + bin);
        %[dat2.hist{ind}, dat2.iv{ind}] = hist(dat1.trace{ind}, iv); % HISTOGRAM replaces hist since 2015! 
        
        % loading bar update-----------------------------------
        err = loading_bar('update', h_fig);
        % -----------------------------------------------------

        if err
            return;
        end
    end
    disp('data successfully histogrammed !');
    loading_bar('close', h_fig);
    
    str_plot = {}; % string for popup menu

    % String for Intensity Channels in popup menu
    for l = 1:nExc % number of excitation channels
        for c = 1:nChan % number of emission channels
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
            dat2.ylabel{size(str_plot,2)} = 'freq. counts'; % RB 2018-01-04
            dat2.xlabel{size(str_plot,2)} = ['counts' str_extra]; % RB 2018-01-04
        end
    end
    % String for FRET Channels in popup menu
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
        dat2.ylabel{size(str_plot,2)} = 'freq. counts'; % RB 2018-01-04
        dat2.xlabel{size(str_plot,2)} = 'FRET'; % RB 2018-01-04
    end
    % String for Stoichiometry Channels in popup menu
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
        dat2.ylabel{size(str_plot,2)} = 'freq. counts'; % RB 2018-01-04
        dat2.xlabel{size(str_plot,2)} = 'S'; % RB 2018-01-04
    end
    % String for all Intensity Channels in popup menu 
    if nChan > 1 || nExc > 1
        str_plot = [str_plot 'all intensity traces'];
        dat1.ylabel{size(str_plot,2)} = ['counts' str_extra];
        % no dat2.xlabel{size(str_plot,2)} = ['counts' str_extra]; % RB 2018-01-04
    end
    % String for all FRET Channels in popup menu
    if nFRET > 1
        str_plot = [str_plot 'all FRET traces'];
        dat1.ylabel{size(str_plot,2)} = 'FRET';
        % no dat2.xlabel{size(str_plot,2)} = 'FRET'; % RB 2018-01-04
    end
    % String for all Stoichiometry Channels in popup menu
    if nS > 1
        str_plot = [str_plot 'all S traces'];
        dat1.ylabel{size(str_plot,2)} = 'S';
        % no dat2.xlabel{size(str_plot,2)} = 'S'; % RB 2018-01-04
    end
    % String for all FRET and Stoichiometry Channels in popup menu
    if nFRET > 0 && nS > 0
        str_plot = [str_plot 'all FRET & S traces'];
        dat1.ylabel{size(str_plot,2)} = 'FRET or S';
        % no dat2.xlabel{size(str_plot,2)} = 'FRET or S'; % RB 2018-01-04
    end
    % String for Stoichiometry-FRET Channels in popup menu
    % RB 2017-12-15: str_plot including FRET-S-histograms in popupmenu (only corresponding SToichiometry FRET values e.g. FRET:Cy3->Cy5 and S:Cy3->Cy5 not FRET:Cy3->Cy5 and S:Cy3->Cy7 etc.)   )
    n = 0;
    for fret = 1:nFRET
        for s = 1:nS
            
            n = n + 1;
            
            clr_bg_s = sprintf('rgb(%i,%i,%i)', ...
                round(clr{3}(s,1:3)*255));
            clr_bg_e = sprintf('rgb(%i,%i,%i)', ...
                round(clr{2}(fret,1:3)*255));
            clr_fbt_s = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*sum(double( ...
                clr{3}(s,1:3) <= 0.5)));
            clr_fbt_e = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*sum(double( ...
                clr{2}(fret,1:3) <= 0.5)));
            str_plot =  [str_plot ['<html><span style= "background-color: '...
                clr_bg_e ';color: ' clr_fbt_e ';">FRET ' labels{FRET(fret,1)} ...
                '>' labels{FRET(fret,2)} '</span>-<span style= "background-color: '...
                clr_bg_s ';color: ' clr_fbt_s ';">S ' labels{S(s)} ...
                '</span></html>']];
            
            % no dat1.ylabel{nChan*nExc+nFRET+nS+n} = 'FRET or S'; % RB 2018-01-04
            dat2.ylabel{nChan*nExc+nFRET+nS+n} = 'S'; % RB 2018-01-04: change index as str_plot and str_plot2 are different
            dat2.xlabel{nChan*nExc+nFRET+nS+n} = 'E'; % RB 2018-01-04: change index as str_plot and str_plot2 are different
        end
    end
   
    % RB 2018-01-03: new variable to expand popupmenu entries
    str_plot2 = [str_plot(1:(nChan*nExc+nFRET+nS)) str_plot((size(str_plot,2)-nFRET*nS+1):size(str_plot,2))];
        
    % RB 2017-12-15: str_plot including FRET-S-histograms in popupmenu of axes 2 
    set(h.tm.popupmenu_axes1, 'String', str_plot(1:(size(str_plot,2)-nFRET*nS)));
    set(h.tm.popupmenu_axes2, 'String', str_plot2()); 

    set(h.tm.axes_ovrAll_1, 'UserData', dat1);
    set(h.tm.axes_ovrAll_2, 'UserData', dat2);
    
    plot2 = get(h.tm.popupmenu_axes2, 'Value');
    
    set(h.tm.edit_xlim_low, 'String', dat1.lim{plot2}(1));
    set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(2));
    set(h.tm.edit_nbiv, 'String', dat1.niv(plot2));

    plotData_overall(h_fig);
    
end

% RB 2018-01-03: adapted for FRET-S-histograms
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
                %ind = (l-1)+c; % RB 2018-01-03: indizes/colour bug solved
                ind = 2*(l-1)+c;
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
        for n = 1:(nFRET+nS)
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
    
    % RB 2017-12-15: implement FRET-S-histograms in plot2
    if plot2 <= nChan*nExc+nFRET+nS
        bar(h.tm.axes_ovrAll_2, dat2.iv{plot2}, dat2.hist{plot2}, ...
            'FaceColor', dat1.color{plot2}, 'EdgeColor', ...
        dat1.color{plot2});
    
        xlabel(h.tm.axes_ovrAll_2, dat2.xlabel{plot2});
        ylabel(h.tm.axes_ovrAll_2, dat2.ylabel{plot2}); % RB 2018-01-04:
        
        xlim(h.tm.axes_ovrAll_2, [dat1.lim{plot2}(1),dat1.lim{plot2}(2)]);
        ylim(h.tm.axes_ovrAll_2, 'auto');
    else  % draw FRET-S histogram
        cla(h.tm.axes_ovrAll_2);
        %lim = [-0.2 1.2; -0.2,1.2];
        imagesc(dat1.lim{plot2}(1,:),dat1.lim{plot2}(1,:),dat2.hist{plot2}, 'Parent', h.tm.axes_ovrAll_2);
        set(h.tm.axes_ovrAll_2,'CLim',[min(min(dat2.hist{plot2})) max(max(dat2.hist{plot2}))]);
        
        xlabel(h.tm.axes_ovrAll_2, dat2.xlabel{plot2});
        ylabel(h.tm.axes_ovrAll_2, dat2.ylabel{plot2});
        
        xlim(h.tm.axes_ovrAll_2, dat1.lim{plot2}(1,:));
        ylim(h.tm.axes_ovrAll_2, dat1.lim{plot2}(2,:));
    end
end


function popupmenu_axes_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    p = h.param.ttPr;
    proj = p.curr_proj;
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    FRET = p.proj{proj}.FRET;
    nFRET = size(FRET,1);
    S = p.proj{proj}.S;
    nS = size(S,1);
    
    if obj == h.tm.popupmenu_axes2
        plot2 = get(obj, 'Value');
        if plot2 <= nChan*nExc+nFRET+nS
            dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
            set(h.tm.edit_xlim_low, 'String', dat1.lim{plot2}(1));
            set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(2));
            set(h.tm.edit_nbiv, 'String', dat1.niv(plot2));
        else %% double check RB 2018-01-04
            dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
            set(h.tm.edit_xlim_low, 'String',  dat1.lim{plot2}(1,1));
            set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(1,2));
            set(h.tm.edit_nbiv, 'String', dat1.niv(plot2));
        end
    end
    
    plotData_overall(h_fig);
    
end


function menu_export_Callback(obj, evd, h_fig)

    saveNclose = questdlg(['Do you want to export the traces to ' ...
        'MASH and close the trace manager?'], ...
        'Close and export to MASH-FRET', 'Yes', 'No', 'No');
    
    if strcmp(saveNclose, 'Yes')
        h = guidata(h_fig);
        h.param.ttPr.proj{h.param.ttPr.curr_proj}.coord_incl = ...
            h.tm.molValid;
        h.param.ttPr.proj{h.param.ttPr.curr_proj}.molTag = ...
            h.tm.molTag; % added by FS, 24.4.2018
        h.param.ttPr.proj{h.param.ttPr.curr_proj}.molTagNames = ...
            h.tm.molTagNames; % added by FS, 24.4.2018
        h.tm.ud = true;
        guidata(h_fig,h);
        uiresume(h.tm.figure_traceMngr);
    end

end

% RB 2018-01-04: adapted for FRET-S-histograms
function edit_xlim_low_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    xlim_low = str2num(get(obj, 'String'));
    xlim_up = str2num(get(h.tm.edit_xlim_up, 'String'));
    
    p = h.param.ttPr;
    proj = p.curr_proj;
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    FRET = p.proj{proj}.FRET;
    nFRET = size(FRET,1);
    S = p.proj{proj}.S;
    nS = size(S,1);
    
    ES = [];
    if xlim_low < xlim_up
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
        plot2 = get(h.tm.popupmenu_axes2, 'Value');
        
        if plot2 <= nChan*nExc+nFRET+nS
            dat1.lim{plot2} = [xlim_low xlim_up];
        
            bin = (dat1.lim{plot2}(2) - dat1.lim{plot2}(1)) / dat1.niv(plot2);
            iv = (dat1.lim{plot2}(1) - bin):bin:(dat1.lim{plot2}(2) + bin);
            [dat2.hist{plot2}, dat2.iv{plot2}] = hist(dat1.trace{plot2}, iv);
        
        else%% double check RB 2018-01-04
            dat1.lim{plot2} = [xlim_low xlim_up; xlim_low xlim_up];
            
            %binx = (dat1.lim{plot2}(2,2) - dat1.lim{plot2}(2,1)) / dat1.niv(plot2);
            %biny = (dat1.lim{plot2}(1,2) - dat1.lim{plot2}(1,1)) / dat1.niv(plot2);
            %ivx = (dat1.lim{plot2}(2,1) - binx):binx:(dat1.lim{plot2}(2,2) + binx);
            %ivy = (dat1.lim{plot2}(1,1) - biny):biny:(dat1.lim{plot2}(1,2) + biny);
            ES = [dat1.trace{plot2-nFRET-nS},dat1.trace{plot2-nS}]; % build [N-by-2] or ' ... '[2-by-N] data matrix.']
            %[dat2.hist{plot2},o,o,dat2.iv{plot2}] = hist2(ES, [ivx;ivy]); % hist2 by MCASH
            binEdges_minmaxN_xy = [dat1.lim{plot2}(1,1) dat1.lim{plot2}(1,2) dat1.niv(plot2); dat1.lim{plot2}(2,1) dat1.lim{plot2}(2,2) dat1.niv(plot2)];
            [dat2.hist{plot2},dat2.iv{plot2}(1,:),dat2.iv{plot2}(2,:)] = hist2D(ES, binEdges_minmaxN_xy); % hist2D by tudima at zahoo dot com, inlcuded in \traces\processing\management
        end
        set(h.tm.axes_ovrAll_1, 'UserData', dat1);
        set(h.tm.axes_ovrAll_2, 'UserData', dat2);
        
        plotData_overall(h_fig);
        
    else
        str = 'The low x limit must be lower than the up x limit.';
        errordlg(str);
        disp(str);
    end
    
end

% RB 2018-01-04: adapted for FRET-S-histograms
function edit_xlim_up_Callback(obj, evd, h_fig)

    h = guidata(h_fig);
    xlim_up = str2num(get(obj, 'String'));
    xlim_low = str2num(get(h.tm.edit_xlim_low, 'String'));
    
    p = h.param.ttPr;
    proj = p.curr_proj;
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    FRET = p.proj{proj}.FRET;
    nFRET = size(FRET,1);
    S = p.proj{proj}.S;
    nS = size(S,1);
    
    ES = [];
    if xlim_low < xlim_up
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
        plot2 = get(h.tm.popupmenu_axes2, 'Value');
        
        if plot2 <= nChan*nExc+nFRET+nS
            dat1.lim{plot2} = [xlim_low xlim_up];
        
            bin = (dat1.lim{plot2}(2) - dat1.lim{plot2}(1)) / dat1.niv(plot2);
            iv = (dat1.lim{plot2}(1) - bin):bin:(dat1.lim{plot2}(2) + bin);
            [dat2.hist{plot2}, dat2.iv{plot2}] = hist(dat1.trace{plot2}, iv);
        
        else%% double check RB 2018-01-04
            dat1.lim{plot2} = [xlim_low xlim_up; xlim_low xlim_up];
            
            %binx = (dat1.lim{plot2}(2,2) - dat1.lim{plot2}(2,1)) / dat1.niv(plot2);
            %biny = (dat1.lim{plot2}(1,2) - dat1.lim{plot2}(1,1)) / dat1.niv(plot2);
            %ivx = (dat1.lim{plot2}(2,1) - binx):binx:(dat1.lim{plot2}(2,2) + binx);
            %ivy = (dat1.lim{plot2}(1,1) - biny):biny:(dat1.lim{plot2}(1,2) + biny);
            ES = [dat1.trace{plot2-nFRET-nS},dat1.trace{plot2-nS}]; % build [N-by-2] or ' ... '[2-by-N] data matrix.']
            %[dat2.hist{plot2},o,o,dat2.iv{plot2}] = hist2(ES, [ivx;ivy]); % hist2 by MCASH
            binEdges_minmaxN_xy = [dat1.lim{plot2}(1,1) dat1.lim{plot2}(1,2) dat1.niv(plot2); dat1.lim{plot2}(2,1) dat1.lim{plot2}(2,2) dat1.niv(plot2)];
            [dat2.hist{plot2},dat2.iv{plot2}(1,:),dat2.iv{plot2}(2,:)] = hist2D(ES, binEdges_minmaxN_xy); % hist2D by tudima at zahoo dot com, inlcuded in \traces\processing\management
     
        end
        
        set(h.tm.axes_ovrAll_1, 'UserData', dat1);
        set(h.tm.axes_ovrAll_2, 'UserData', dat2);
        
        plotData_overall(h_fig);
        
    else
        str = 'The low x limit must be lower than the up x limit.';
        errordlg(str);
        disp(str);
    end

end

% RB 2018-01-04: adapted for FRET-S-histograms
function edit_nbiv_Callback(obj, evd, h_fig)
    
    h = guidata(h_fig);
    nbiv = round(str2num(get(obj, 'String')));
    if ~isnumeric(nbiv) || nbiv < 1
        nbiv = 1;
    end
    
    p = h.param.ttPr;
    proj = p.curr_proj;
    nChan = p.proj{proj}.nb_channel;
    nExc = p.proj{proj}.nb_excitations;
    FRET = p.proj{proj}.FRET;
    nFRET = size(FRET,1);
    S = p.proj{proj}.S;
    nS = size(S,1);
    
    dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
    dat2 = get(h.tm.axes_ovrAll_2, 'UserData');
    plot2 = get(h.tm.popupmenu_axes2, 'Value');

    dat1.niv(plot2) = nbiv;
   
    ES = [];
    if plot2 <= nChan*nExc+nFRET+nS
        bin = (dat1.lim{plot2}(2) - dat1.lim{plot2}(1)) / dat1.niv(plot2);
        iv = (dat1.lim{plot2}(1) - bin):bin:(dat1.lim{plot2}(2) + bin);
        [dat2.hist{plot2}, dat2.iv{plot2}] = hist(dat1.trace{plot2}, iv);
    else%% double check RB 2018-01-05
        ES = [dat1.trace{plot2-nFRET-nS},dat1.trace{plot2-nS}]; % build [N-by-2] or ' ... '[2-by-N] data matrix.']
        binEdges_minmaxN_xy = [dat1.lim{plot2}(1,1) dat1.lim{plot2}(1,2) dat1.niv(plot2); dat1.lim{plot2}(2,1) dat1.lim{plot2}(2,2) dat1.niv(plot2)];
        dat2.iv{plot2}=[]; % delete cell array content to avoid dimension mismatch in cells after changing the number of bins
        [dat2.hist{plot2},dat2.iv{plot2}(1,:),dat2.iv{plot2}(2,:)] = hist2D(ES, binEdges_minmaxN_xy); % hist2D by tudima at zahoo dot com, inlcuded in \traces\processing\management

    end
        
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
    
    % deactivate the popupmenu if the molecule is not selected
    % added by FS, 25.4.2018
    pos_slider = round(get(h.tm.slider, 'Value'));
    max_slider = get(h.tm.slider, 'Max');
    nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
    for i = nb_mol_disp:-1:1
        if h.tm.molValid(max_slider-pos_slider+i) == 0
            set(h.tm.popup_molNb(i), 'Enable', 'off', 'Value', 1)
            h.tm.molTag(max_slider-pos_slider+i) = 1;
        else
            set(h.tm.popup_molNb(i), 'Enable', 'on')
        end
    end
    
    guidata(h_fig, h);
    plotDataTm(h_fig);

end

% RB 2018-01-05: new pushbotton to invert the selcetion of individual molecules
function pushbutton_all_inverse_Callback(obj, evd, h_fig)
    
    h = guidata(h_fig);
    
    h.tm.molValid = ~h.tm.molValid;
    
    % deactivate the popupmenu if the molecule is not selected
    % added by FS, 25.4.2018
    pos_slider = round(get(h.tm.slider, 'Value'));
    max_slider = get(h.tm.slider, 'Max');
    nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
    for i = nb_mol_disp:-1:1
        if h.tm.molValid(max_slider-pos_slider+i) == 0
            set(h.tm.popup_molNb(i), 'Enable', 'off', 'Value', 1)
            h.tm.molTag(max_slider-pos_slider+i) = 1;
        else
            set(h.tm.popup_molNb(i), 'Enable', 'on')
        end
    end
    
    guidata(h_fig, h);
    plotDataTm(h_fig);
end 


% added by FS, 24.4.2018
function edit_addMolTag_Callback(obj, evd, h_fig)
    h = guidata(h_fig);
    if ~strcmp(obj.String, 'define a new tag') && ~ismember(obj.String, h.tm.molTagNames)
        h.tm.molTagNames{end+1} = obj.String;
        guidata(h_fig, h);
        str_lst = colorTagNames(h_fig);
        set(h.tm.popup_molTag, 'String', str_lst);
        nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
        guidata(h_fig, h);
        update_popups(h_fig, nb_mol_disp)
    end
end

function popup_molTag_Callback(obj,evd,h_fig)
% Updates the tag color in corresponding edit field

%% Created by MH, 24.4.2019
%
%%

h = guidata(h_fig);

% control empty tag
tag = get(obj,'value');
str_pop = get(obj, 'string');
if strcmp(str_pop{tag},'no default tag')
    set(h.tm.edit_tagClr,'string','','enable','off');
    return;
end

% update edit field background color
clr_hex = h.tm.molTagClr{tag}(2:end);
set(h.tm.edit_tagClr,'string',clr_hex,'enable','on','backgroundcolor',...
    hex2rgb(clr_hex)/255,'foregroundcolor','white');

end


function edit_tagClr_Callback(obj,evd,h_fig)
% Defines the tag color with hexadecimal input

%% Created by MH, 24.4.2019
%
%%

h = guidata(h_fig);

% control empty tag
tag = get(h.tm.popup_molTag,'value');
str_pop = get(h.tm.popup_molTag, 'string');
if strcmp(str_pop{tag},'no default tag')
    return;
end

% control color value
clr_str = get(obj,'string');
if ~ishexclr(clr_str)
    setContPan(cat(2,'Tag color must be a RGB value in the hexadecimal ',...
        'format (ex:92B06A)'),'error',h_fig);
    return;
end

% save color
h.tm.molTagClr{tag} = cat(2,'#',clr_str);
guidata(h_fig,h);

% update edit field background color
popup_molTag_Callback(h.tm.popup_molTag,[],h_fig);

% update color in default tag popup
str_lst = colorTagNames(h_fig);
set(h.tm.popup_molTag,'String',str_lst);

% update color in molecule tag listboxes and popups
n_mol_disp = str2num(get(h.tm.edit_nbTotMol,'string'));
update_popups(h_fig,n_mol_disp);

% update color in string of selection popupmenu
str_pop = getStrPop_select(h_fig);
curr_slct = get(h.tm.popupmenu_selection,'value');
if curr_slct>numel(str_pop)
    curr_slct = numel(str_pop);
end
set(h.tm.popupmenu_selection,'value',curr_slct,'string',str_pop);

end



function pushbutton_deleteMolTag_Callback(obj, evd, h_fig)
    h = guidata(h_fig);
    selectMolTag = get(h.tm.popup_molTag, 'Value');
    if selectMolTag ~= 1
        h.tm.molTagNames(selectMolTag) = [];
        guidata(h_fig, h);
        str_lst = colorTagNames(h_fig);
        set(h.tm.popup_molTag, 'Value', 1);
        set(h.tm.popup_molTag, 'String', str_lst);
        nb_mol_disp = str2num(get(h.tm.edit_nbTotMol, 'String'));
        guidata(h_fig, h);
        update_popups(h_fig, nb_mol_disp)
    end
end



function figure_traceMngr(obj, evd, h_fig)

    h = guidata(h_fig);
    h = rmfield(h, 'tm');
    guidata(h_fig, h);
    delete(obj);

end

