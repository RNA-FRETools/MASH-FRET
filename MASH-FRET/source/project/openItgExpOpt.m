function openItgExpOpt(obj, evd, h_fig)
% Open a window to modify project parameters
% "obj" >> handle of pushbutton from which the function has been called
% "evd" >> eventdata structure of the pushbutton from which the function
%          has been called (usually empty)
% "h" >> main data structure stored in figure_MASH's handle

% Last update: 3.4.2019 by MH
% --> Add project's labels to default labels (FRET and S popupmenus were 
%     updated with project's labels and channel popupmenu with defaults
%     that are different when importing ASCII traces)
% --> improve default color coding of FRET and S by taking into account
%     the color of last added FRET or S
% --> Warn the user and review FRET and Stoichiometry when changing an 
%     emitter-specific illumination to "none"
% --> review ud_fretPanel, create ud_sPanel and use both to make robust 
%     updates of FRET and stoichiometry panels and manage absence of FRET
%     or stoichiometry panels.
% --> avoid exporting empty parameters with non-zero dimensions, correct 
%     typos and remove caps-lock in message boxes 
%
% update: 4.2.2019 by Mélodie Hadzic
% --> remove "file options" panel (displaced in an other option window
%     created by function openItgExpOpt.m, called by control 
%     pushbutton_TTgen_FileOpt)

h = guidata(h_fig);
switch obj
    case h.pushbutton_chanOpt
        p{1} = h.param.movPr.itg_expMolPrm;
        p{2} = [];
        p{3} = h.param.movPr.itg_expFRET;
        p{4} = h.param.movPr.itg_expS;
        p{5} = h.param.movPr.itg_clr;
        p{6} = h.param.movPr.chanExc;
        p{7}{1} = h.param.movPr.labels_def;
        p{7}{2} = h.param.movPr.labels;
        nExc = h.param.movPr.itg_nLasers;
        nChan = h.param.movPr.nChan;
        
    case h.pushbutton_editParam
        currProj = get(h.listbox_traceSet, 'Value');
        p{1} = h.param.ttPr.proj{currProj}.exp_parameters;
        p{2} = [];
        p{3} = h.param.ttPr.proj{currProj}.FRET;
        p{4} = h.param.ttPr.proj{currProj}.S;
        p{5} = h.param.ttPr.proj{currProj}.colours;
        p{6} = h.param.ttPr.proj{currProj}.chanExc;
        p{7}{1} = h.param.movPr.labels_def;
        p{7}{2} = h.param.ttPr.proj{currProj}.labels;
        nExc = h.param.ttPr.proj{currProj}.nb_excitations;
        nChan = h.param.ttPr.proj{currProj}.nb_channel;
end

% added by MH, 3.4.2019
% adjust default labels with project labels if any and different:
nLabels = numel(p{7}{1});
isincluded = false(1,numel(p{7}{2}));
for i = 1:numel(p{7}{2})
    for j = 1:nLabels
        if strcmp(p{7}{2}(i),p{7}{1}(j))
            isincluded(i) = true;
        end
    end
    if ~isincluded(i)
        p{7}{1} = [p{7}{1} p{7}{2}(i)];
    end
end

buildWinOpt(p, nExc, nChan, obj, h_fig);


function buildWinOpt(p, nExc, nChan, obj, h_fig)

% Last update: 26.7.2019 by MH
% >> reduce height of panel "color code" by removing extra space

h = guidata(h_fig);
nPrm = size(p{1},1);
nFixPrm = 4 + nExc;
isFRET = nChan > 1;
isS = nExc > 1;

str_laser = {};
exc = [];
for i = 5:4+nExc
    exc = [exc getValueFromStr('Power(', p{1}{i,1})];
    str_laser = [str_laser [num2str(exc(end)) 'nm']];
end
str_chan = cellstr(num2str((1:nChan)'));

str_addPrm = {};
if nPrm > nFixPrm
    for i = nFixPrm+1:nPrm
        str_addPrm = {str_addPrm{:} p{1}{i,1}};
    end
end

if isFRET
    str_lst = {};
    if ~isempty(p{3})
        p{3}((p{3}(:,1) > nChan),:) = [];
        p{3}((p{3}(:,2) > nChan),:) = [];

        for l = 1:size(p{3},1)
            str_lst = [str_lst ['FRET ' p{7}{2}{p{3}(l,1)} '>' ...
                p{7}{2}{p{3}(l,2)}]];
        end
    end
else
    p{3} = [];
end

if isS
    str_Slst = {};
    str_Spop = getStrPop('chan', {p{7}{2} []});
    if ~isempty(p{4})
        if size(p{4},2)>1
            p{4} = p{4}(:,1);
        end
        p{4}((p{4}>nChan)) = [];
        for l = 1:numel(p{4})
            if p{6}(p{4}(l))>0
                str_Slst = [str_Slst ['S ' p{7}{2}{p{4}(l)}]];
            else
                p{4}(l) = [];
            end
        end
    end
else
    p{4} = [];
end

clr_ref = getDefTrClr(nExc, exc, nChan, size(p{3},1), numel(p{4}));
for l = 1:nExc
    if l > size(p{5}{1},1)
        p{5}{1}(l:size(clr_ref{1},1),:) = clr_ref{1}(l:end,:);
    end
    for c = 1:nChan
        if c > size(p{5}{1},2)
            p{5}{1}(:,c:size(clr_ref{1},2)) = clr_ref{1}(:,c:end);
        end
    end
end

mg = 10;
big_mg = 15;

h_txt = 14;
h_edit = 20;
h_but = 22; 
h_lb = 2*h_but + mg; 

w_small = 30;
w_short = 40;
w_pop = 50;
w_but = 53;
w_med = 85;
w_lb = 167;
w_lb_small = 110;
w_full = 230;

h_pan_prm = 10 + 5*mg + big_mg + 3*h_txt + 4*h_edit + h_lb + ...
    (nPrm - 2)*(mg + h_edit);
h_pan_fret = 10 + h_lb + h_edit + 3*mg;
h_pan_S = 10 + h_lb + h_edit + 3*mg;
h_pan_chan = 10 + h_txt + 3*h_edit + h_but + big_mg + 4*mg;

% 26.7.2019, MH: remove extra space
% h_pan_clr = 10 + h_txt + h_edit + h_but + 3*mg;
h_pan_clr = 10 + h_edit + h_but + 3*mg;

w_pan = w_full + 2*mg;
wFig = 2*w_pan + 3*mg;

hFig = 3*mg + h_but + max([h_pan_prm, (double(isFRET)*(h_pan_fret + mg) ...
    + double(isS)*(h_pan_S + mg) + h_pan_chan + mg + h_pan_clr)]);

fig_name = 'Project parameters';

pos_0 = get(0, 'ScreenSize');
xFig = pos_0(1) + (pos_0(3) - wFig)/2;
yFig = pos_0(2) + (pos_0(4) - hFig)/2;
if hFig > pos_0(4)
    yFig = pos_0(4) - 30;
end

if ~(isfield(h, 'figure_itgExpOpt') && ishandle(h.figure_itgExpOpt))

    h.figure_itgExpOpt = figure('Color', [0.94 0.94 0.94], 'Resize', ...
        'off', 'NumberTitle', 'off', 'MenuBar', 'none', 'Name', ...
        fig_name, 'Visible', 'off', 'Units', 'pixels', ...
        'Position', [xFig yFig wFig hFig], 'CloseRequestFcn', ...
        {@figure_itgExpOpt_CloseRequestFcn, h_fig}, 'WindowStyle', ...
        'Modal');
    guidata(h.figure_itgExpOpt, p);
    val_FRETprm = [1 1 1 1];
    val_Sprm = [1 1];
    val_chanPrm = [1 1];
    val_clrPrm = 1;
    
else
    if isFRET
        val_FRETprm = [get(h.itgExpOpt.popupmenu_FRETfrom, 'Value') ...
            get(h.itgExpOpt.popupmenu_FRETto, 'Value') ...
            get(h.itgExpOpt.listbox_FRETcalc, 'Value')];
    end
    if isS
        val_Sprm = [get(h.itgExpOpt.popupmenu_Snum, 'Value') ...
            get(h.itgExpOpt.listbox_Scalc, 'Value')];
    end
    val_chanPrm = [get(h.itgExpOpt.popupmenu_dyeChan, 'Value') ...
        get(h.itgExpOpt.listbox_dyeLabel, 'Value')];
    val_clrPrm = get(h.itgExpOpt.popupmenu_clrChan, 'Value');
    posCurr = get(h.figure_itgExpOpt, 'Position');
    set(h.figure_itgExpOpt, 'Position', [posCurr(1) yFig wFig hFig]);
    figChild = get(h.figure_itgExpOpt, 'Children');
    for i = 1:numel(figChild)
        delete(figChild(i));
    end
    h = rmfield(h, 'itgExpOpt');
end
    
bgCol = get(h.figure_itgExpOpt, 'Color');

yNext = mg;
xNext = wFig - mg - w_but;

h.itgExpOpt.pushbutton_itgExpOpt_ok = uicontrol('Style', ...
    'pushbutton', 'Parent', h.figure_itgExpOpt, 'String', 'Save', ...
    'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_but h_but], 'Callback', ...
    {@pushbutton_itgExpOpt_ok_Callback, obj, h_fig});

xNext = xNext - w_but - mg;

h.itgExpOpt.pushbutton_itgExpOpt_cancel = uicontrol('Style', ...
    'pushbutton', 'Parent', h.figure_itgExpOpt, 'String', 'Cancel', ...
    'Units', 'pixels', 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_but h_but], 'Callback', ...
    {@pushbutton_itgExpOpt_cancel_Callback, h_fig});

guidata(h_fig,h);
h.itgExpOpt.pushbutton_help = setInfoIcons(...
    h.itgExpOpt.pushbutton_itgExpOpt_cancel,h_fig,...
    h.param.movPr.infos_icon_file);

yNext = hFig - mg - h_pan_prm;
xNext = mg;

h.itgExpOpt.uipanel_molPrm = uipanel('Units', 'pixels', 'Parent', ...
    h.figure_itgExpOpt, 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_pan h_pan_prm]);

yNext = hFig - mg - h_pan_chan;
xNext = xNext + w_pan + mg;

h.itgExpOpt.uipanel_chanPrm = uipanel('Units', 'pixels', 'Parent', ...
    h.figure_itgExpOpt, 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_pan h_pan_chan]);

if isFRET
    yNext = yNext - mg - h_pan_fret;
    
    h.itgExpOpt.uipanel_fretPrm = uipanel('Units', 'pixels', 'Parent', ...
        h.figure_itgExpOpt, 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext w_pan h_pan_fret]);
end

if isS
    yNext = yNext - mg - h_pan_S;
    
    h.itgExpOpt.uipanel_sPrm = uipanel('Units', 'pixels', 'Parent', ...
        h.figure_itgExpOpt, 'BackgroundColor', bgCol, 'Position', ...
        [xNext yNext w_pan h_pan_S]);
end

yNext = yNext - mg - h_pan_clr;
    
h.itgExpOpt.uipanel_clr = uipanel('Units', 'pixels', 'Parent', ...
    h.figure_itgExpOpt, 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_pan h_pan_clr]);

%% Panel project parameters

yNext = mg;
xNext = mg;

uicontrol('Style', 'text', 'Parent', h.itgExpOpt.uipanel_molPrm, ...
    'String', 'units:', 'Units', 'pixels', 'BackgroundColor', ...
    bgCol, 'HorizontalAlignment', 'center', 'Position', ...
    [xNext yNext w_short h_txt]);

xNext = xNext + w_short + mg;

h.itgExpOpt.edit_newUnits = uicontrol('Style', 'edit', 'Parent', ...
    h.itgExpOpt.uipanel_molPrm, 'String', '', 'Units', 'pixels', ...
    'BackgroundColor', [1 1 1], 'Position', ...
    [xNext yNext w_med h_edit], 'Callback', {@edit_newUnits, h_fig});

xNext = w_pan - mg - w_but;

h.itgExpOpt.pushbutton_itgExpOpt_add = uicontrol('Style', 'pushbutton', ...
    'Parent', h.itgExpOpt.uipanel_molPrm, 'String', 'Add', 'Units', ...
    'pixels', 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_but h_but], 'Callback', ...
    {@pushbutton_itgExpOpt_add_Callback, obj, h_fig});

yNext = yNext + h_edit + mg;
xNext = mg;

uicontrol('Style', 'text', 'Parent', h.itgExpOpt.uipanel_molPrm, ...
    'String', 'name:', 'Units', 'pixels', 'BackgroundColor', ...
    bgCol, 'HorizontalAlignment', 'center', 'Position', ...
    [xNext yNext w_short h_txt]);

xNext = xNext + w_short + mg;

h.itgExpOpt.edit_newName = uicontrol('Style', 'edit', 'Parent', ...
    h.itgExpOpt.uipanel_molPrm, 'String', '', 'Units', 'pixels', ...
    'BackgroundColor', [1 1 1], 'Position', ...
    [xNext yNext w_med h_edit], 'Callback', {@edit_newName, h_fig});

yNext = yNext + h_edit + mg;
xNext = mg;

h.itgExpOpt.listbox_prm = uicontrol('Style', 'listbox', 'Parent', ...
    h.itgExpOpt.uipanel_molPrm, 'String', str_addPrm, 'Units', ...
    'pixels', 'BackgroundColor', [1 1 1], 'Position', ...
    [xNext yNext w_lb h_lb]);

xNext = w_pan - mg - w_but;

h.itgExpOpt.pushbutton_itgExpOpt_rem = uicontrol('Style', 'pushbutton', ...
    'Parent', h.itgExpOpt.uipanel_molPrm, 'String', 'Remove', 'Units', ...
    'pixels', 'BackgroundColor', bgCol, 'Position', ...
    [xNext yNext w_but h_but], 'Callback', ...
    {@pushbutton_itgExpOpt_rem_Callback, obj, h_fig});

yNext = yNext + h_lb;
xNext = mg;

uicontrol('Style', 'text', 'Parent', h.itgExpOpt.uipanel_molPrm, ...
    'String', 'Additional parameters:', 'Units', 'pixels', ...
    'FontWeight', 'bold', 'BackgroundColor', bgCol, ...
    'HorizontalAlignment', 'left', 'Position', ...
    [xNext yNext w_full h_txt]);

yNext = yNext + h_txt + big_mg;

for i = nPrm:-1:3

    xNext = mg;

    uicontrol('Style', 'text', 'Parent', ...
        h.itgExpOpt.uipanel_molPrm, 'String', p{1}{i,1}, 'Units', ...
        'pixels', 'BackgroundColor', bgCol, 'HorizontalAlignment', ...
        'right', 'Position', [xNext yNext w_med h_txt]);

    xNext = xNext + w_med + mg;

    h.itgExpOpt.edit_prmVal(i) = uicontrol('Style', 'edit', ...
        'Parent', h.itgExpOpt.uipanel_molPrm, 'String', ...
        num2str(p{1}{i,2}), 'Units', 'pixels', 'BackgroundColor', ...
        [1 1 1], 'Position', [xNext yNext w_short h_edit], 'Callback', ...
        {@edit_param_Callback, i, h_fig});

    xNext = xNext + w_short + mg;

    uicontrol('Style', 'text', 'Parent', ...
        h.itgExpOpt.uipanel_molPrm, 'String', p{1}{i,3}, 'Units', ...
        'pixels', 'BackgroundColor', bgCol, 'HorizontalAlignment', ...
        'left', 'Position', [xNext yNext w_med h_txt]);

    yNext = yNext + h_edit + mg;

end

xNext = mg;

h.itgExpOpt.edit_molName = uicontrol('Style', 'edit', 'Parent', ...
    h.itgExpOpt.uipanel_molPrm, 'String', num2str(p{1}{2,2}), 'Units', ...
    'pixels', 'BackgroundColor', [1 1 1], 'HorizontalAlignment', ...
    'left', 'Position', [xNext yNext w_full h_edit], 'Callback', ...
    {@edit_param_Callback, 2, h_fig});

yNext = yNext + h_edit;

uicontrol('Style', 'text', 'Parent', h.itgExpOpt.uipanel_molPrm, ...
    'String', p{1}{2,1}, 'Units', 'pixels', 'BackgroundColor', bgCol, ...
    'HorizontalAlignment', 'left', 'Position', ...
    [xNext yNext w_full h_txt]);

yNext = yNext + h_txt + mg;

h.itgExpOpt.edit_movName = uicontrol('Style', 'edit', 'Parent', ...
    h.itgExpOpt.uipanel_molPrm, 'String', num2str(p{1}{1,2}), 'Units', ...
    'pixels', 'BackgroundColor', [1 1 1], 'HorizontalAlignment', ...
    'left', 'Position', [xNext yNext w_full h_edit], 'Callback', ...
    {@edit_param_Callback, 1, h_fig});

yNext = yNext + h_edit;

uicontrol('Style', 'text', 'Parent', h.itgExpOpt.uipanel_molPrm, ...
    'String', p{1}{1,1}, 'Units', 'pixels', 'BackgroundColor', bgCol, ...
    'HorizontalAlignment', 'left', 'Position', ...
    [xNext yNext w_full h_txt]);


%% Panel Channel parameters

xNext = mg;
yNext = h_pan_chan - h_edit - mg - 10;

uicontrol('Style','text','Parent',h.itgExpOpt.uipanel_chanPrm,'Units', ...
    'pixels','String','channel:','HorizontalAlignment','left', ...
    'Position',[xNext yNext w_pop h_txt]);

xNext = xNext + w_pop;

h.itgExpOpt.popupmenu_dyeChan = uicontrol('Style','popupmenu','Parent', ...
    h.itgExpOpt.uipanel_chanPrm,'Units','pixels','String',str_chan, ...
    'BackgroundColor',[1 1 1],'Value',val_chanPrm(1),'Callback', ...
    {@popupmenu_dyeChan_Callback, h_fig},'Position', ...
    [xNext yNext w_pop h_edit]);

xNext = mg;
yNext = yNext - mg - h_edit;

uicontrol('Style','text','Parent',h.itgExpOpt.uipanel_chanPrm,'Units', ...
    'pixels','String','label:','HorizontalAlignment','left','Position', ...
    [xNext yNext w_pop h_txt]);

xNext = xNext + w_pop;

for v = 1:size(p{7}{1},2)
    if strcmp(p{7}{1}{v}, p{7}{2}{val_chanPrm(1)})
        break;
    end
end
h.itgExpOpt.popupmenu_dyeLabel = uicontrol('Style','popupmenu','Parent', ...
    h.itgExpOpt.uipanel_chanPrm,'Units','pixels','String',p{7}{1},...
    'Value',v,'BackgroundColor',[1 1 1],'Callback', ...
    {@popupmenu_dyeLabel_Callback, h_fig},'Position', ...
    [xNext yNext w_pop h_edit]);

xNext = xNext + w_pop + mg;

uicontrol('Style','text','Parent',h.itgExpOpt.uipanel_chanPrm,'Units', ...
    'pixels','String','excitation:','HorizontalAlignment','left', ...
    'Position',[xNext yNext w_pop h_txt]);

xNext = xNext + w_pop + mg;

exc_str = [str_laser 'none'];
for u = 1:size(exc_str,2)
    if getValueFromStr('', exc_str{u}) == p{6}(val_chanPrm(1))
        break;
    end
end
h.itgExpOpt.popupmenu_dyeExc = uicontrol('Style','popupmenu','Parent', ...
    h.itgExpOpt.uipanel_chanPrm,'Units','pixels','String',exc_str, ...
    'Value',u,'BackgroundColor',[1 1 1],'Callback', ...
    {@popupmenu_dyeExc_Callback, h_fig},'Position', ...
    [xNext yNext w_pop h_edit]);

xNext = mg;
yNext = mg + h_lb;

uicontrol('Style','text','Parent',h.itgExpOpt.uipanel_chanPrm,'Units', ...
    'pixels','String','Fluorescent labels:','HorizontalAlignment', ...
    'left','FontWeight','bold','Position',[xNext yNext w_full h_txt]);

xNext = mg;
yNext = mg;

h.itgExpOpt.listbox_dyeLabel = uicontrol('Style','listbox','Parent', ...
    h.itgExpOpt.uipanel_chanPrm,'Units','pixels','String',p{7}{1}, ...
    'Value',val_chanPrm(2),'BackgroundColor',[1 1 1],'Position', ...
    [xNext yNext w_lb_small h_lb]);

xNext = xNext + w_lb_small + mg;
yNext = yNext + h_lb - h_but;

uicontrol('Style','text','Parent',h.itgExpOpt.uipanel_chanPrm,'Units', ...
    'pixels','String','label:','HorizontalAlignment','left','Position', ...
    [xNext yNext w_small h_txt]);

xNext = xNext + w_small;

h.itgExpOpt.edit_dyeLabel = uicontrol('Style','edit','Parent', ...
    h.itgExpOpt.uipanel_chanPrm,'Units','pixels','BackgroundColor', ...
    [1 1 1],'Position',[xNext yNext w_short h_edit]);

xNext = xNext + w_short + mg;

h.itgExpOpt.pushbutton_addLabel = uicontrol('Style','pushbutton', ...
    'Parent', h.itgExpOpt.uipanel_chanPrm,'Units','pixels','String', ...
    'Add','Callback',{@pushbutton_addLabel_Callback, h_fig},'Position', ...
    [xNext yNext w_small h_but]);

yNext = mg;
xNext = xNext - mg - w_short - w_small;

h.itgExpOpt.pushbutton_remLabel = uicontrol('Style','pushbutton', ...
    'Parent', h.itgExpOpt.uipanel_chanPrm,'Units','pixels','String', ...
    'Remove','Callback',{@pushbutton_remLabel_Callback, h_fig}, ...
    'Position',[xNext yNext w_but h_but]);


%% Panel FRET parameters

if isFRET
    xNext = mg;
    yNext = mg;

    h.itgExpOpt.listbox_FRETcalc = uicontrol('Style', 'listbox', ...
        'Parent', h.itgExpOpt.uipanel_fretPrm, 'String', {''}, ...
        'Position', [xNext yNext w_lb h_lb], 'BackgroundColor', ...
        [1 1 1], 'Value', val_FRETprm(3), 'String', str_lst);

    xNext = xNext + w_lb + mg;

    h.itgExpOpt.pushbutton_remFRET = uicontrol('Style', 'pushbutton', ...
        'Parent', h.itgExpOpt.uipanel_fretPrm, 'String', 'Remove', ...
        'Position', [xNext yNext w_but h_but], 'Callback', ...
        {@pushbutton_remFRET_Callback, h_fig});

    yNext = yNext + h_but + mg;

    h.itgExpOpt.pushbutton_addFRET = uicontrol('Style', 'pushbutton', ...
        'Parent', h.itgExpOpt.uipanel_fretPrm, 'String', 'Add', ...
        'Position', [xNext yNext w_but h_but], 'Callback', ...
        {@pushbutton_addFRET_Callback, h_fig});

    yNext = yNext + h_but + mg;
    xNext = mg;

    h.itgExpOpt.text_FRETfrom = uicontrol('Style', 'text', 'Parent', ...
        h.itgExpOpt.uipanel_fretPrm, 'String', 'From channel:', ...
        'HorizontalAlignment', 'left', 'Position', ...
        [xNext yNext w_med h_txt]);

    xNext = xNext + w_med;

    h.itgExpOpt.popupmenu_FRETfrom = uicontrol('Style', 'popupmenu', ...
        'Parent', h.itgExpOpt.uipanel_fretPrm, 'BackgroundColor', ...
        [1 1 1], 'Position', [xNext yNext w_pop h_edit], 'String', ...
        p{7}{2}, 'Value', val_FRETprm(1));

    xNext = xNext + w_pop;

    h.itgExpOpt.text_FRETto = uicontrol('Style', 'text', 'Parent', ...
        h.itgExpOpt.uipanel_fretPrm, 'String', 'to:', 'Position', ...
        [xNext yNext w_short h_txt]);

    xNext = xNext + w_short;

    h.itgExpOpt.popupmenu_FRETto = uicontrol('Style', 'popupmenu', ...
        'Parent', h.itgExpOpt.uipanel_fretPrm, 'BackgroundColor', ...
        [1 1 1], 'Position', [xNext yNext w_pop h_edit], 'String', ...
        p{7}{2}, 'Value', val_FRETprm(2));
end

if isS
    %% Stoichiometry parameters
    
    xNext = mg;
    yNext = mg;

    h.itgExpOpt.listbox_Scalc = uicontrol('Style', 'listbox', 'Parent', ...
        h.itgExpOpt.uipanel_sPrm, 'String', {''}, 'Position', ...
        [xNext yNext w_lb h_lb], 'BackgroundColor', [1 1 1], 'Value', ...
        val_Sprm(2), 'String', str_Slst);

    xNext = xNext + w_lb + mg;

    h.itgExpOpt.pushbutton_remS = uicontrol('Style', 'pushbutton', ...
        'Parent', h.itgExpOpt.uipanel_sPrm, 'String', 'Remove', ...
        'Position', [xNext yNext w_but h_but], 'Callback', ...
        {@pushbutton_remS_Callback, h_fig});

    yNext = yNext + h_but + mg;

    h.itgExpOpt.pushbutton_addS = uicontrol('Style', 'pushbutton', ...
        'Parent', h.itgExpOpt.uipanel_sPrm, 'String', 'Add', ...
        'Position', [xNext yNext w_but h_but], 'Callback', ...
        {@pushbutton_addS_Callback, h_fig});

    yNext = yNext + h_but + mg;
    xNext = mg;

    h.itgExpOpt.text_Snum = uicontrol('Style', 'text', 'Parent', ...
        h.itgExpOpt.uipanel_sPrm, 'String', ...
        'Fluorescence stoichiometry of: ', 'HorizontalAlignment', ...
        'left', 'Position', [xNext yNext w_lb h_txt]);

    xNext = xNext + w_lb;

    h.itgExpOpt.popupmenu_Snum = uicontrol('Style', 'popupmenu', ...
        'Parent', h.itgExpOpt.uipanel_sPrm, 'BackgroundColor', [1 1 1], ...
        'Position', [xNext yNext w_but+mg h_edit], 'String', str_Spop, ...
        'Value', val_Sprm(1));
end

%% Panel color code

str_clrChan = getStrPop('DTA_chan', {p{7}{2} p{3} p{4} exc p{5}});
if val_clrPrm <= size(p{3},1)
    curr_clr = p{5}{2}(val_clrPrm,:);
    
elseif val_clrPrm <= size(p{3},1)+numel(p{4})
    curr_clr = p{5}{3}((val_clrPrm-size(p{3},1)),:);
    
else
    ind = val_clrPrm-size(p{3},1)-numel(p{4});
    c = ceil(ind/nExc);
    l = ind - (c-1)*nExc;
    curr_clr = p{5}{1}{l,c};
end

yNext = mg;
xNext = mg + w_full - 2*w_short;

if sum(curr_clr)>=1.5
    fntClr = 'black';
else
    fntClr = 'white';
end
h.itgExpOpt.pushbutton_viewClr = uicontrol('Style','pushbutton','Parent', ...
    h.itgExpOpt.uipanel_clr,'BackgroundColor',curr_clr,'Position', ...
    [xNext yNext w_short*2 h_edit],'Enable','on','callback',...
    {@pushbutton_viewClr_Callback,h_fig},'ForegroundColor',fntClr,'String',...
    'Set color');

xNext = mg;
yNext = yNext + h_but + mg;

h.itgExpOpt.popupmenu_clrChan = uicontrol('Style', 'popupmenu', ...
    'Parent', h.itgExpOpt.uipanel_clr, 'BackgroundColor', [1 1 1], ...
    'String', str_clrChan, 'Value', val_clrPrm, 'Position', ...
    [xNext yNext w_full h_edit], 'Callback', ...
    {@popupmenu_clrChan_Callback, h_fig});

guidata(h_fig, h);

uistack(h.itgExpOpt.pushbutton_itgExpOpt_ok, 'bottom');
uistack(h.itgExpOpt.pushbutton_itgExpOpt_cancel, 'bottom');

uistack(h.itgExpOpt.pushbutton_viewClr, 'bottom');
uistack(h.itgExpOpt.popupmenu_clrChan, 'bottom');

if isS
    uistack(h.itgExpOpt.pushbutton_remS, 'bottom');
    uistack(h.itgExpOpt.pushbutton_addS, 'bottom');
    uistack(h.itgExpOpt.listbox_Scalc, 'bottom');
    uistack(h.itgExpOpt.popupmenu_Snum, 'bottom');
end

if isFRET
    uistack(h.itgExpOpt.pushbutton_remFRET, 'bottom');
    uistack(h.itgExpOpt.pushbutton_addFRET, 'bottom');
    uistack(h.itgExpOpt.listbox_FRETcalc, 'bottom');
    uistack(h.itgExpOpt.popupmenu_FRETto, 'bottom');
    uistack(h.itgExpOpt.popupmenu_FRETfrom, 'bottom');
end

uistack(h.itgExpOpt.pushbutton_remLabel, 'bottom');
uistack(h.itgExpOpt.pushbutton_addLabel, 'bottom');
uistack(h.itgExpOpt.edit_dyeLabel, 'bottom');
uistack(h.itgExpOpt.listbox_dyeLabel, 'bottom');
uistack(h.itgExpOpt.popupmenu_dyeExc, 'bottom');
uistack(h.itgExpOpt.popupmenu_dyeLabel, 'bottom');
uistack(h.itgExpOpt.popupmenu_dyeChan, 'bottom');
uistack(h.itgExpOpt.pushbutton_itgExpOpt_add, 'bottom');
uistack(h.itgExpOpt.edit_newUnits, 'bottom');
uistack(h.itgExpOpt.edit_newName, 'bottom');
uistack(h.itgExpOpt.pushbutton_itgExpOpt_rem, 'bottom');
uistack(h.itgExpOpt.listbox_prm, 'bottom');
try
    for i = numel(h.itgExpOpt.edit_prmVal):-1:1
        uistack(h.itgExpOpt.edit_prmVal(i), 'bottom');
    end
catch err
    disp('Minor warning: Tabulation order dismissed.');
end
uistack(h.itgExpOpt.edit_molName, 'bottom');
uistack(h.itgExpOpt.edit_movName, 'bottom');

set(h.itgExpOpt.uipanel_molPrm, 'Title', 'Project parameters');
% if fromVidproc
%     set(h.itgExpOpt.uipanel_files, 'Title', 'Output files');
% end
set(h.itgExpOpt.uipanel_chanPrm, 'Title', 'Video channels');
if isFRET
    set(h.itgExpOpt.uipanel_fretPrm, 'Title', 'FRET calculations');
end
if isS
    set(h.itgExpOpt.uipanel_sPrm, 'Title', 'Stoichiometry calculations');
end
set(h.itgExpOpt.uipanel_clr, 'Title', 'Color code');

set(h.figure_itgExpOpt, 'Visible', 'on');

% added by MH, 3.4.2019
ud_fretPanel(h_fig);
ud_sPanel(h_fig);


function figure_itgExpOpt_CloseRequestFcn(obj, evd, h_fig)
h = guidata(h_fig);
if isfield(h, 'itgExpOpt');
    h = rmfield(h, {'itgExpOpt', 'figure_itgExpOpt'});
    guidata(h_fig, h);
end

delete(obj);


function popupmenu_dyeChan_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
chan = get(obj, 'Value');
for v = 1:size(p{7}{1},2)
    if isequal(p{7}{1}{v},p{7}{2}{chan})
        break;
    end
end
exc_str = get(h.itgExpOpt.popupmenu_dyeExc, 'String');
for u = 1:size(exc_str,1)
    if getValueFromStr('', exc_str{u,1}) == p{6}(chan)
        break;
    end
end
set(h.itgExpOpt.popupmenu_dyeLabel, 'Value', v);
set(h.itgExpOpt.popupmenu_dyeExc, 'Value', u);


function popupmenu_dyeLabel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
str = get(obj, 'String');
val = get(obj, 'Value');
chan = get(h.itgExpOpt.popupmenu_dyeChan,'Value');
p{7}{2}(chan) = str(val);
guidata(h.figure_itgExpOpt,p);
ud_fretPanel(h_fig);
ud_sPanel(h_fig);


function popupmenu_dyeExc_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
str = get(obj, 'String');
val = get(obj, 'Value');
if val == size(str,1)
    exc = 0;
else
    exc = getValueFromStr('', str{val});
end
chan = get(h.itgExpOpt.popupmenu_dyeChan,'Value');
if exc==p{6}(chan)
    return;
end
if exc==0 
    ud_fret = 0;
    ud_s = 0;
    for id = 1:numel(str)
        if ~isempty(strfind(str{id},num2str(p{6}(chan))))
            break;
        end
    end
    if isfield(h.itgExpOpt,'popupmenu_Snum') && sum(p{4}==chan) && ...
        isfield(h.itgExpOpt,'popupmenu_FRETto') && sum(p{3}(:,1)==chan)
        choice = questdlg({cat(2,'Selected emitter is invoved in ',...
            'FRET and stoichiometry calculations. Changing its specific ',...
            'illumination to "none" will automatically remove the ',...
            'corresponding FRET and stoichiometry from the lists'),'',...
            cat(2,'Do you want to turn illumination to "none" and remove ',...
            'the FRET and stoichiometry from the lists?')},'',...
            'Yes, remove','cancel','cancel');
        if strcmp(choice,'Yes, remove')
            ud_fret = 1;
            ud_s = 1;
        else
            set(obj,'Value',id);
            return;
        end
    elseif isfield(h.itgExpOpt,'popupmenu_Snum') && sum(p{4}==chan)
        choice = questdlg({cat(2,'Selected emitter is invoved in ',...
            'stoichiometry calculations. Changing its specific ',...
            'illumination to "none" will automatically remove the ',...
            'corresponding stoichiometry from the list'),'',...
            cat(2,'Do you want to turn illumination to "none" and remove ',...
            'the stoichiometry from the list?')},'',...
            'Yes, remove','Cancel','Cancel');
        if strcmp(choice,'Yes, remove')
            ud_s = 1;
        else
            set(obj,'Value',id);
            return;
        end
    elseif isfield(h.itgExpOpt,'popupmenu_FRETto') && sum(p{3}(:,1)==chan)
        choice = questdlg({cat(2,'Selected emitter is invoved in ',...
            'FRET calculations as a donor. Changing its specific ',...
            'illumination to "none" will automatically remove the ',...
            'corresponding FRET from the list'),'',...
            cat(2,'Do you want to turn illumination to "none" and remove ',...
            'the FRET from the list?')},'',...
            'Yes, remove','Cancel','Cancel');
        if strcmp(choice,'Yes, remove')
            ud_fret = 1;
        else
            set(obj,'Value',id);
            return;
        end
    end
    if ud_s
        p{4}(p{4}==chan) = [];
    end
    if ud_fret
        p{3}(p{3}(:,1)==chan,:) = [];
    end
end
p{6}(chan) = exc;
guidata(h.figure_itgExpOpt,p);
ud_fretPanel(h_fig);
ud_sPanel(h_fig);


function pushbutton_addLabel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
label = get(h.itgExpOpt.edit_dyeLabel,'String');
if ~isempty(label)
    p = guidata(h.figure_itgExpOpt);
    p{7}{1} = [p{7}{1} label];
    guidata(h.figure_itgExpOpt,p);
    set(h.itgExpOpt.listbox_dyeLabel,'String',p{7}{1});
    set(h.itgExpOpt.popupmenu_dyeLabel,'String',p{7}{1});
    popupmenu_dyeLabel_Callback(h.itgExpOpt.popupmenu_dyeLabel,evd,h_fig);
end


function pushbutton_remLabel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
slct = get(h.itgExpOpt.listbox_dyeLabel,'Value');
p = guidata(h.figure_itgExpOpt);
for c = 1:size(p{7}{2},2)
    if strcmp(p{7}{2}{c}, p{7}{1}{slct})
        updateActPan(sprintf('The label is used for channel %i.',c), ...
            h_fig, 'error');
        return;
    end
end

p{7}{1}(slct) = [];

for c = size(p{7}{1},2)+1:size(p{7}{2},2)
    p{7}{1}(c) = {sprintf('dye %i',c)};
end

guidata(h.figure_itgExpOpt,p);
set(h.itgExpOpt.listbox_dyeLabel,'Value',size(p{7}{1},2),'String',p{7}{1});
set(h.itgExpOpt.popupmenu_dyeLabel,'String',p{7}{1});
popupmenu_dyeLabel_Callback(h.itgExpOpt.popupmenu_dyeLabel,evd,h_fig);


function pushbutton_viewClr_Callback(obj, evd, h_fig)

rgb = uisetcolor('Set a trace color');
if numel(rgb)==1
    return;
end

h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);

str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
str_chan = get(h.itgExpOpt.popupmenu_dyeChan,'String');
nExc = numel(str_exc)-1;
nChan = size(str_chan,1);

chan = get(h.itgExpOpt.popupmenu_clrChan, 'Value');
if chan <= size(p{3},1)
    p{5}{2}(chan,:) = rgb;

elseif chan <= size(p{3},1)+numel(p{4})
    p{5}{3}((chan-size(p{3},1)),:) = rgb;

else
    ind = chan-size(p{3},1)-numel(p{4});
    i = 0;
    for l = 1:nExc
        for c = 1:nChan
            i = i + 1;
            if ind == i
                break;
            end
        end
        if ind == i
            break;
        end
    end
    p{5}{1}{l,c} = rgb;
end

guidata(h.figure_itgExpOpt, p);

% update pushutton color
if sum(rgb)>=1.5
    fntClr = 'black';
else
    fntClr = 'white';
end
set(h.itgExpOpt.pushbutton_viewClr,'backgroundcolor',rgb,'foregroundcolor',...
    fntClr);

% update color in trace list
exc = zeros(1,nExc);
for i = 1:size(str_exc,1)-1
    exc(i) = getValueFromStr('', str_exc{i,1});
end
str_clrChan = getStrPop('DTA_chan', {p{7}{2} p{3} p{4} exc p{5}});
val_clrChan = get(h.itgExpOpt.popupmenu_clrChan, 'Value');
if val_clrChan > size(str_clrChan,2)
    val_clrChan = size(str_clrChan,2);
end
set(h.itgExpOpt.popupmenu_clrChan,'Value',val_clrChan,'String',str_clrChan); 


function popupmenu_clrChan_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
str_chan = get(h.itgExpOpt.popupmenu_dyeChan,'String');
nChan = size(str_chan,1);
str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
nExc = size(str_exc,1)-1;

chan = get(obj, 'Value');

if chan <= size(p{3},1)
    clr = p{5}{2}(chan,:);

elseif chan <= size(p{3},1)+numel(p{4})
    clr = p{5}{3}((chan-size(p{3},1)),:);

else
    ind = chan-size(p{3},1)-numel(p{4});
    i = 0;
    for l = 1:nExc
        for c = 1:nChan
            i = i + 1;
            if ind == i
                break;
            end
        end
        if ind == i
            break;
        end
    end
    clr = p{5}{1}{l,c};
end

if sum(clr)>=1.5
    fntClr = 'black';
else
    fntClr = 'white';
end
set(h.itgExpOpt.pushbutton_viewClr,'backgroundcolor',clr,'foregroundcolor',...
    fntClr);


function pushbutton_remFRET_Callback(obj, evd, h_fig)
h = guidata(h_fig);
slct = get(h.itgExpOpt.listbox_FRETcalc, 'Value');
p = guidata(h.figure_itgExpOpt);
if ~isempty(p{3})
    p_prev = p{3};
    p{3} = [];
    for i = 1:size(p_prev,1)
        if i ~= slct
            p{3} = [p{3};p_prev(i,:)];
        end
    end
    guidata(h.figure_itgExpOpt,p);
    ud_fretPanel(h_fig);
    if isempty(p{3})
        l = 0;
    else
        l = size(p{3},1);
    end
    set(h.itgExpOpt.listbox_FRETcalc, 'Value', l);
end


function pushbutton_addFRET_Callback(obj, evd, h_fig)
h = guidata(h_fig);
chanFrom = get(h.itgExpOpt.popupmenu_FRETfrom, 'Value');
chanTo = get(h.itgExpOpt.popupmenu_FRETto, 'Value');
p = guidata(h.figure_itgExpOpt);
exc = p{6}(chanFrom);
if chanFrom == chanTo
    updateActPan('DONOR and ACCEPTOR channels must be different.', ...
        h_fig, 'error');
elseif exc==0
    updateActPan(['FRET calculation impossible: no donor-specific '...
        'illumination is defined.'], h_fig, 'error');
else
    p = guidata(h.figure_itgExpOpt);
    for i = 1:size(p{3},1)
        if isequal(p{3}(i,:),flipdim([chanFrom chanTo],2))
            updateActPan(['Channel ' p{7}{2}{chanTo} ...
                ' is already defined as the donor in the pair ' ...
                p{7}{2}{chanTo} '/' p{7}{2}{chanFrom}], h_fig, 'error');
            return;
        end
        if isequal(p{3}(i,:),[chanFrom chanTo])
            return;
        end
    end
    p{3}(size(p{3},1)+1,1:2) = [chanFrom chanTo];
    guidata(h.figure_itgExpOpt, p);
    ud_fretPanel(h_fig);
    if isempty(p{3})
        l = 0;
    else
        l = size(p{3},1);
    end
    set(h.itgExpOpt.listbox_FRETcalc, 'Value', l);
end


function ud_fretPanel(h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);

% added by MH, 3.4.2019
if ~isfield(h.itgExpOpt,'popupmenu_FRETfrom')
    return;
end

% get excitation wavelengths
str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
for i = 1:size(str_exc,1)-1
    exc(i) = getValueFromStr('', str_exc{i});
end

% set channel popupmenu string
if isfield(h.itgExpOpt, 'popupmenu_FRETfrom')
    set(h.itgExpOpt.popupmenu_FRETfrom, 'String', p{7}{2});
end
if isfield(h.itgExpOpt, 'popupmenu_FRETto')
    set(h.itgExpOpt.popupmenu_FRETto, 'String', p{7}{2});
end

% build FRET list string and FRET default colors
rgb_Emin = [0,0,0];
rgb_Emax = [1,1,1];
str_lst = {};
for l = 1:size(p{3},1)
    str_lst = [str_lst ['FRET ' p{7}{2}{p{3}(l,1)} '>' ...
        p{7}{2}{p{3}(l,2)}]];
    if l > size(p{5}{2},1)
        if l>1
            p{5}{2}(l,:) = mean([p{5}{2}(l-1,:);rgb_Emax],1);
        else
            p{5}{2}(l,:) = rgb_Emin;
        end
    end
end

% update list
val = get(h.itgExpOpt.listbox_FRETcalc, 'Value');
set(h.itgExpOpt.listbox_FRETcalc, 'Value', 1);
set(h.itgExpOpt.listbox_FRETcalc, 'String', str_lst);
if val<=numel(str_lst) && val>0
    set(h.itgExpOpt.listbox_FRETcalc, 'Value', val);
else
    set(h.itgExpOpt.listbox_FRETcalc, 'Value', numel(str_lst));
end

% save colors
guidata(h.figure_itgExpOpt,p);

% update color panel
str_clrChan = getStrPop('DTA_chan',{p{7}{2} p{3} p{4} exc p{5}});
val_clrChan = get(h.itgExpOpt.popupmenu_clrChan, 'Value');
if val_clrChan > size(str_clrChan,2)
    val_clrChan = size(str_clrChan,2);
end
set(h.itgExpOpt.popupmenu_clrChan, 'Value', val_clrChan, 'String', ...
  str_clrChan);
popupmenu_clrChan_Callback(h.itgExpOpt.popupmenu_clrChan, [], h_fig);


function ud_sPanel(h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);

% added by MH, 3.4.2019
if ~isfield(h.itgExpOpt,'popupmenu_Snum')
    return;
end

% get excitation wavelengths
str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
for i = 1:size(str_exc,1)-1
    exc(i) = getValueFromStr('', str_exc{i});
end

% set channel popupmenu string
if isfield(h.itgExpOpt, 'popupmenu_Snum')
    set(h.itgExpOpt.popupmenu_Snum, 'String', p{7}{2});
end

% build S list string and S default colors
rgb_Smin = [0,0,1];
rgb_Smax = [1,1,1];
str_S = get(h.itgExpOpt.popupmenu_Snum, 'String');
str_lst = {};
for l = 1:numel(p{4})
    str_lst = [str_lst ['S ' str_S{p{4}(l)}]];
    if l > size(p{5}{3},1)
        if l>1
            p{5}{3}(l,:) = mean([p{5}{3}(l-1,:);rgb_Smax],1);
        else
            p{5}{3}(l,:) = rgb_Smin;
        end
    end
end

% update list
val = get(h.itgExpOpt.listbox_Scalc, 'Value');
set(h.itgExpOpt.listbox_Scalc, 'Value', 1);
set(h.itgExpOpt.listbox_Scalc, 'String', str_lst);
if val<=numel(str_lst) && val>0
    set(h.itgExpOpt.listbox_Scalc, 'Value', val);
else
    set(h.itgExpOpt.listbox_Scalc, 'Value', numel(str_lst));
end

% save colors
guidata(h.figure_itgExpOpt,p);

% update color panel
str_clrChan = getStrPop('DTA_chan',{p{7}{2} p{3} p{4} exc p{5}});
val_clrChan = get(h.itgExpOpt.popupmenu_clrChan, 'Value');
if val_clrChan > size(str_clrChan,2)
    val_clrChan = size(str_clrChan,2);
end
set(h.itgExpOpt.popupmenu_clrChan, 'Value', val_clrChan, 'String', ...
  str_clrChan);
popupmenu_clrChan_Callback(h.itgExpOpt.popupmenu_clrChan, [], h_fig);


function pushbutton_remS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
slct = get(h.itgExpOpt.listbox_Scalc, 'Value');
p = guidata(h.figure_itgExpOpt);

str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
for i = 1:size(str_exc,1)-1
    exc(i) = getValueFromStr('', str_exc{i,1});
end
if ~isempty(p{4})
    p_prev = p{4};
    p{4} = [];
    for i = 1:size(p_prev,1)
        if i ~= slct
            p{4} = [p{4};p_prev(i)];
        end
    end
    guidata(h.figure_itgExpOpt,p);
    ud_sPanel(h_fig);
    if isempty(p{4})
        l = 0;
    else
        l = numel(p{4});
    end
    set(h.itgExpOpt.listbox_Scalc, 'Value', l);
end


function pushbutton_addS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
chanS = get(h.itgExpOpt.popupmenu_Snum, 'Value');
p = guidata(h.figure_itgExpOpt);
str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
for i = 1:size(str_exc,1)-1
    exc(i) = getValueFromStr('', str_exc{i,1});
end

if ~isempty(find(p{4}==chanS,1))
    return;
    
elseif p{6}(chanS)==0
    updateActPan(['The direct excitation wavelength of ' p{7}{2}{chanS} ...
        ' is not defined. The stoichiometry can not be calculated'],...
        h_fig, 'error');
    return;
end

p{4}(numel(p{4})+1,1) = chanS;
guidata(h.figure_itgExpOpt,p);
ud_sPanel(h_fig);
if isempty(p{4})
    l = 0;
else
    l = numel(p{4});
end
set(h.itgExpOpt.listbox_Scalc, 'Value', l);


function edit_param_Callback(obj, evd, i, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
val = get(obj,'String');
if ~sum(double(i == [1 2]))
    if ~isempty(val)
        val = str2num(val);
        set(obj, 'String', num2str(val));
        if ~(numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Parameter values must be numeric.', h_fig, ...
                'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p{1}{i,2} = val;
            guidata(h.figure_itgExpOpt, p);
        end
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        p{1}{i,2} = val;
        guidata(h.figure_itgExpOpt, p);
    end
else
    p{1}{i,2} = val;
    guidata(h.figure_itgExpOpt, p);
end


function edit_newName(obj, evd, h_fig)
str = get(obj, 'String');
maxN = 10;
if ~(~isempty(str) && length(str) <= maxN)
    updateActPan(['Parameter name must not be empty and must contain ' ...
        num2str(maxN) ' characters at max.'], h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
end


function edit_newUnits(obj, evd, h_fig)
str = get(obj, 'String');
maxN = 10;
if length(str) > maxN
    updateActPan(['Parameter units must contain ' num2str(maxN) ...
        ' characters at max.'], h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
end


function pushbutton_itgExpOpt_add_Callback(obj, evd, but_obj, h_fig)
h = guidata(h_fig);
name_str = get(h.itgExpOpt.edit_newName, 'String');
units_str = get(h.itgExpOpt.edit_newUnits, 'String');
maxN = 10;
if ~isempty(name_str) && length(name_str) <= maxN && ...
        length(units_str) <= maxN
    p = guidata(h.figure_itgExpOpt);
    str_chan = get(h.itgExpOpt.popupmenu_dyeChan,'String');
    nChan = size(str_chan,1);
    str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
    nExc = size(str_exc,1)-1;

    p{1} = [p{1}; {name_str '' units_str}];
  
    guidata(h.figure_itgExpOpt, p);
    guidata(h_fig,h);
    buildWinOpt(p, nExc, nChan, but_obj, h_fig);
else
    updateActPan(['Parameter name must not be empty and parameter name' ...
        'and units must contain ' num2str(maxN) ' characters at max.'], ...
        h_fig, 'error');
end


function pushbutton_itgExpOpt_rem_Callback(obj, evd, but_obj, h_fig)
h = guidata(h_fig);
p_select = get(h.itgExpOpt.listbox_prm, 'Value');
if p_select > 0
    p_prev = guidata(h.figure_itgExpOpt);
    p = cell(1,3);
    str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
    nExc = size(str_exc,1)-1;
    for i = 1:size(p_prev{1},1)
        if i ~= p_select + 4 + nExc
            p{1} = [p{1};{p_prev{1}{i,1} p_prev{1}{i,2} p_prev{1}{i,3}}];
        end
    end
    p{3} = p_prev{3};
    p{4} = p_prev{4};
    p{5} = p_prev{5};
    p{6} = p_prev{6};
    p{7} = p_prev{7};
    guidata(h.figure_itgExpOpt, p);
    
    str_chan = get(h.itgExpOpt.popupmenu_dyeChan,'String');
    nChan = size(str_chan,1);
    str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
    nExc = size(str_exc,1)-1;
    
    buildWinOpt(p, nExc, nChan, but_obj, h_fig);
end


function pushbutton_itgExpOpt_ok_Callback(obj, evd, but_obj, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);

% added by MH, 3.4.2019
% avoid empty variables with non-zero dimensions
for i = 1:numel(p)
    if numel(p{i})==0
        p{i} = [];
    end
end

switch but_obj
    case h.pushbutton_chanOpt
        h.param.movPr.itg_expMolPrm = p{1};
        h.param.movPr.itg_expFRET = p{3};
        h.param.movPr.itg_expS = p{4};
        h.param.movPr.itg_clr = p{5};
        h.param.movPr.chanExc = p{6};
        h.param.movPr.labels = p{7}{2};
        
    case h.pushbutton_editParam
        currProj = get(h.listbox_traceSet, 'Value');
        h.param.ttPr.proj{currProj}.exp_parameters = p{1};
        h.param.ttPr.proj{currProj}.FRET = p{3};
        h.param.ttPr.proj{currProj}.S = p{4};
        h.param.ttPr.proj{currProj}.colours = p{5};
        h.param.ttPr.proj{currProj}.chanExc = p{6};
        h.param.ttPr.proj{currProj}.labels = p{7}{2};
end
h.param.movPr.labels_def = p{7}{1};
guidata(h_fig, h);


close(h.figure_itgExpOpt);


function pushbutton_itgExpOpt_cancel_Callback(obj, evd, h_fig)
h = guidata(h_fig);
close(h.figure_itgExpOpt);



