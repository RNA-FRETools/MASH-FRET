function buildWinOpt(p, nExc, nChan, obj, h_fig)
% buildWinOpt(p, nExc, nChan, obj, h_fig)
%
% Build figure for project settings
%
% p: {1-by-7} cell array containin project options with:
%  p{1}: cell array containing user-defined experimental condition/value/units trios
%  p{2}: obsolete
%  p{3}: [nFRET-by-2] donor-acceptor FRET pairs (channel indexes)
%  p{4}: [nS-by-2] donor-acceptor Stoichiometry pairs (channel indexes)
%  p{5}: {1-by-3} containing:
%   p{5}{1}: {nL-by-nChan} plot colors for intensities
%   p{5}{2}: {nL-by-nFRET} plot colors for intensities
%   p{5}{3}: {nL-by-nS} plot colors for intensities
%  p{6}: [1-by-nChan] channel-specific excitation wavelengths (in nm)
%  p{7}: {1-by-2} containing:
%   p{7}{1}: cell vector containing default labels
%   p{7}{2}: {1-by-nChan} channel-specific labels
% nExc: number of alternating lasers
% nChan: number of video channels
% obj: handle to pushbutton that was pressed to open project options
% h_fig: handle to main figure

% Last update by MH, 26.7.2019: reduce height of panel "color code" by removing extra space

h = guidata(h_fig);
nPrm = size(p{1},1);
nFixPrm = 4 + nExc;
isFRET = nChan > 1;
isS = isFRET & (nExc > 1);

str_laser = {};
exc = [];
for i = 5:(4+nExc)
    exc = cat(2,exc,getValueFromStr('Power(', p{1}{i,1}));
    str_laser = cat(2,str_laser,[num2str(exc(end)),'nm']);
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
        excl = p{4}(:,1)>nChan | p{4}(:,2) > nChan;
        for l = 1:size(p{4},1)
            if size(p{6},2)>=max(p{4}(l,[1,2])) && p{6}(p{4}(l,1))>0 && ...
                    p{6}(p{4}(l,2))>0
                str_Slst = [str_Slst ['S ' p{7}{2}{p{4}(l,1)} ...
                    p{7}{2}{p{4}(l,2)}]];
            else
                excl(l) = true;
            end
            if ~sum(p{3}(:,1)==p{4}(l,1) & p{3}(:,2)==p{4}(l,2))
                excl(l) = true;
            end
        end
        p{4}(excl,:) = [];
    end
else
    p{4} = [];
end

clr_ref = getDefTrClr(nExc, exc, nChan, size(p{3},1), size(p{4},1));
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
    val_FRETprm = [1 1 1];
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
        val_Sprm = [get(h.itgExpOpt.popupmenu_Spairs, 'Value') ...
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
        h.itgExpOpt.uipanel_sPrm, 'String', 'Of FRET pair: ', ...
        'HorizontalAlignment', 'left', 'Position', ...
        [xNext yNext w_med h_txt]);

    xNext = xNext + w_med;

    h.itgExpOpt.popupmenu_Spairs = uicontrol('Style', 'popupmenu', ...
        'Parent', h.itgExpOpt.uipanel_sPrm, 'BackgroundColor', [1 1 1], ...
        'Position', [xNext yNext 2*w_pop h_edit], 'String', str_Spop, ...
        'Value', val_Sprm(1));

end

%% Panel color code

str_clrChan = getStrPop('DTA_chan', {p{7}{2} p{3} p{4} exc p{5}});
if val_clrPrm <= size(p{3},1)
    curr_clr = p{5}{2}(val_clrPrm,:);
    
elseif val_clrPrm <= size(p{3},1)+size(p{4},1)
    curr_clr = p{5}{3}((val_clrPrm-size(p{3},1)),:);
    
else
    ind = val_clrPrm-size(p{3},1)-size(p{4},1);
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
    uistack(h.itgExpOpt.popupmenu_Spairs, 'bottom');
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
