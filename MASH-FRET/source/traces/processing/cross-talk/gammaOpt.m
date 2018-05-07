% options for photobleaching based gamma correction
% last updated: FS, 12.1.2018

function gammaOpt(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;

% figure dimensions and position
wFig = 445;
hFig = 135;
prev_u = get(h_fig, 'Units');
set(h_fig, 'Units', 'pixels');
posFig = get(h_fig, 'Position');
set(h_fig, 'Units', prev_u);
prev_u = get(0, 'Units');
set(0, 'Units', 'pixels');
pos_scr = get(0, 'ScreenSize');
set(0, 'Units', prev_u);
xFig = posFig(1) + (posFig(3) - wFig)/2;
yFig = min([hFig pos_scr(4)]);
pos_fig = [xFig yFig wFig hFig];

% margins and dimensions of uicontrol elements
mg = 10;
mg_big = 2*mg;
mg_ttl = 10;
fntS = 10.6666666;
h_edit = 25; w_edit = 60;
h_but = 22;
h_txt = 14;
w_pan = wFig - 2*mg;
w_pop = 120;
h_pan_all = mg_ttl + 2*mg + 1*mg_big + 2*h_edit + 1*h_txt + 0*h_but;

% string and value of gamma correction popupmenu 
acc_str = get(h.popupmenu_gammaFRET, 'String');
acc = get(h.popupmenu_gammaFRET, 'Value')-1;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    p.proj{proj}.curr{mol}{5}{4}(2) = acc;
    showCutoff = p.proj{proj}.curr{mol}{5}{5}(acc,1);
end

% Gamma factor options - subfigure
h.gpo.figure_gammaOpt = figure('Visible', 'on', 'Units', 'pixels', ...
    'Position', pos_fig, 'Color', [0.94 0.94 0.94], ...
    'NumberTitle', 'off',...
    'Name', [get(h_fig, 'Name') ' - Gamma factor options'], ...
    'WindowStyle', 'modal');  % make other windows inaccessible

xNext = mg;
yNext = hFig - mg - h_pan_all;

% photobleaching panel
h.gpo.uipanel_photobleach = uipanel('Parent', h.gpo.figure_gammaOpt, ...
    'Units', 'pixels', 'Position', [xNext yNext w_pan h_pan_all], ...
    'Title', 'Photobleaching parameters', 'FontUnits', 'pixels', 'FontSize', fntS);

% checkbox
xNext = mg;
yNext = h_pan_all - mg_ttl - h_txt - h_edit - mg_big;
h.gpo.checkbox_showCutoff = uicontrol('Style', 'checkbox', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels',...
    'Position', [xNext yNext 3/4*w_pop h_edit], ...
    'String', 'show cutoff',...
    'Value', showCutoff,...
    'TooltipString', 'show the photobleaching cutoff for the gamma correction',...
    'Callback', {@checkbox_showCutoff, h_fig});

% pushbutton load gamma factors
yNext = h_pan_all - mg_ttl - h_txt - 2*h_edit - mg_big - mg;
h.gpo.pushbutton_loadGamma = uicontrol('Style', 'pushbutton', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels',...
    'Position', [xNext yNext 2/3*w_pop h_edit], ...
    'String', 'load gamma',...
    'Value', showCutoff,...
    'TooltipString', 'load gamma factor file',...
    'Callback', {@pushbutton_loadGamma_Callback, h_fig});

% pushbutton compute gamma factor
yNext = h_pan_all - mg_ttl - h_txt - 2*h_edit - mg_big - mg;
xNext = 2*mg + w_pop;
h.gpo.pushbutton_computeGamma = uicontrol('Style', 'pushbutton', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels',...
    'Position', [xNext yNext w_edit h_edit], ...
    'String', ['compute ' char(hex2dec('3B3'))],...
    'Value', showCutoff,...
    'TooltipString', 'compute ',...
    'Callback', {@pushbutton_computeGamma_Callback, h_fig});

% check icon axis
xNext = mg + 3/4*w_pop;
yNext = h_pan_all - 2/3*mg_ttl - h_txt - h_edit - mg_big;
pos = [xNext/w_pan yNext/h_pan_all h_edit/w_pan h_edit/h_pan_all];
h.gpo.axis_pbGamma = axes('Parent', h.gpo.uipanel_photobleach,...
     'Position', pos);

% acceptor popup 
xNext = mg;
yNext = h_pan_all - mg_ttl - h_txt - mg_big;
h.gpo.popup_pbGamma = uicontrol('Style', 'popup', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels',...
    'Position', [xNext yNext w_pop h_edit], ...
    'String', acc_str(2:end), ...
    'Value', acc, ...
    'Callback', {@popup_pbGamma_Callback, h_fig});

% edit stop
xNext = xNext + mg + w_pop;
yNext = h_pan_all - mg_ttl - h_txt - h_edit - mg_big;
h.gpo.edit_pbGamma_stop = uicontrol('Style', 'edit', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels', 'Position', ...
    [xNext yNext w_edit h_edit], 'BackgroundColor', [1 1 1], ...
    'Enable', 'inactive');

yNext = h_pan_all - mg_ttl - h_txt - mg_big;
h.gpo.text_pbGamma_stop = uicontrol('Style', 'text', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels',...
    'Position', [xNext yNext w_edit h_edit], ...
    'String', 'stop');

% edit threshold
xNext = xNext + mg + w_edit;
h.gpo.text_pbGamma_threshold = uicontrol('Style', 'text', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels',...
    'Position', [xNext yNext w_edit h_edit], ...
    'String', 'threshold');

yNext = h_pan_all - mg_ttl - h_txt - h_edit - mg_big;
h.gpo.edit_pbGamma_threshold = uicontrol('Style', 'edit', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels', 'Position', ...
    [xNext yNext w_edit h_edit], 'TooltipString', ...
    'Threshold for photobleaching cutoff', 'BackgroundColor', [1 1 1], ...
    'Callback', {@edit_pbGamma_threshold_Callback, h_fig});

% edit extra substract
xNext = xNext + mg + w_edit;
h.gpo.edit_pbGamma_extraSubstract = uicontrol('Style', 'edit', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels', 'Position', ...
    [xNext yNext w_edit h_edit], 'BackgroundColor', [1 1 1], ...
    'Callback', {@edit_pbGamma_extraSubstract_Callback, h_fig});

yNext = h_pan_all - mg_ttl - h_txt - mg_big;
h.gpo.text_pbGamma_extraSubstract = uicontrol('Style', 'text', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels',...
    'Position', [xNext yNext w_edit h_edit], ...
    'String', 'substract');

% edit min cutoff
xNext = xNext + mg + w_edit;
h.gpo.text_pbGamma_minCutoff = uicontrol('Style', 'text', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels',...
    'Position', [xNext yNext w_edit h_edit], ...
    'String', 'min. cutoff');

yNext = h_pan_all - mg_ttl - h_txt - h_edit - mg_big;
h.gpo.edit_pbGamma_minCutoff = uicontrol('Style', 'edit', 'Parent', ...
    h.gpo.uipanel_photobleach, 'Units', 'pixels', 'Position', ...
    [xNext yNext w_edit h_edit], 'BackgroundColor', [1 1 1], ...
    'Callback', {@edit_pbGamma_minCutoff_Callback, h_fig});

p = calcCutoffGamma(mol, p);
p = prepostInt(h_fig, mol, p);
h.param.ttPr = p;
guidata(h_fig, h)
ud_pbGamma(h_fig)
drawCheck(h_fig)

end

% draws a checkmark or a cross depending if a cutoff is found within the
% trace (i.e intensity of the donor prior to and after the presumed cutoff is different)
function drawCheck(h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    acc = p.proj{proj}.curr{mol}{5}{4}(2);
    if p.proj{proj}.curr{mol}{5}{5}(acc,7) == 1
        [icon, ~, alpha] = imread('check.png');
        set(h.gpo.checkbox_showCutoff, 'Enable', 'on')
        set(h.gpo.pushbutton_computeGamma, 'Enable', 'on')
        drawCutoff(h_fig,1)
    else
        [icon, ~, alpha] = imread('notdefined.png');
        set(h.gpo.checkbox_showCutoff, 'Enable', 'off')
        set(h.gpo.pushbutton_computeGamma, 'Enable', 'off')
        drawCutoff(h_fig,0)
    end
    image(icon, 'alphaData', alpha)
    set(gca, 'visible', 'off')
end
end

% update the acceptor popup menu
function popup_pbGamma_Callback(obj, ~, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    p.proj{proj}.curr{mol}{5}{4}(2) = val;
    h.param.ttPr = p;
    guidata(h_fig, h)
    ud_pbGamma(h_fig)
    drawCheck(h_fig)
end
end

% show or hide the pb cutoff
function checkbox_showCutoff(obj, ~, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = get(obj, 'Value');
    acc = p.proj{proj}.curr{mol}{5}{4}(2);
    p.proj{proj}.curr{mol}{5}{5}(acc,1) = val;
    h.param.ttPr = p;
    guidata(h_fig, h)
    updateFields(h_fig, 'ttPr');
end
end

% load gamma factor file, added by FS, 24.4.2018
function pushbutton_loadGamma_Callback(~, ~, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
defPth = h.folderRoot;

% load gamma factor file if it exists
[fnameGamma,pnameGamma,~] = uigetfile({'*.gam', 'Gamma factors (*.gam)'; '*.*', ...
    'All files(*.*)'}, 'Select gamma factor file', defPth, 'MultiSelect', 'on');
if ~isempty(fnameGamma) && ~isempty(pnameGamma) && sum(pnameGamma)
    if ~iscell(fnameGamma)
        fnameGamma = {fnameGamma};
    end
    gammasCell = cell(1,length(fnameGamma));
    for f = 1:length(fnameGamma)
        filename = [pnameGamma fnameGamma{f}];
        fileID = fopen(filename,'r');
        formatSpec = '%f';
        gammasCell{f} = fscanf(fileID,formatSpec);
    end
    gammas = cell2mat(gammasCell');
end


% check if number of molecules is the same in the project and the .gam file
proj = p.curr_proj;
nMol = numel(p.proj{proj}.coord_incl);
if ~isempty(fnameGamma) && ~isempty(pnameGamma) && sum(pnameGamma)
    if length(gammas) ~= nMol
        updateActPan('number of gamma factors does not match the number of ASCII files loaded. Set all gamma factors to 1.', h.figure_MASH, 'error');
        fnameGamma = []; % set to empty (will not try to import any gamma factors from file)
    end
end

% set the gamma factors
for n = 1:nMol
    % assign gamma value (assignment only works if number of values in .gam file equals the number of loaded restructured ASCII files)
    if ~isempty(fnameGamma) && ~isempty(pnameGamma) && sum(pnameGamma)
        % set the gamma factor from the .gam file
        % (FRET is calculated on the spot based on imported and corrected
        % intensities)
        p.proj{proj}.curr{n}{5}{3} = gammas(n);
        p.proj{proj}.prm{n}{5}{3} = gammas(n);
    end
end

% update the parameters (adapted from pushbutton_addTraces_Callback.m)
h.param.ttPr = p;
guidata(h.figure_MASH, h);
ud_TTprojPrm(h.figure_MASH);
ud_trSetTbl(h.figure_MASH);
updateFields(h.figure_MASH, 'ttPr');

% close figure
close(gcf)
end

% threshold (adapted from edit_photoblParam_01_Callback in MASH.m)
function edit_pbGamma_threshold_Callback(obj, ~, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = str2double(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    acc = p.proj{proj}.curr{mol}{5}{4}(2);
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val))
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan('Data threshold must be a number.', ...
            h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        perSec = p.proj{proj}.fix{2}(4);
        perPix = p.proj{proj}.fix{2}(5);
        if perSec
            rate = p.proj{proj}.frame_rate;
            val = val*rate;
        end
        if perPix
            nPix = p.proj{proj}.pix_intgr(2);
            val = val*nPix;
        end
        p.proj{proj}.curr{mol}{5}{5}(acc,2) = val;
        p = calcCutoffGamma(mol, p);
        p = prepostInt(h_fig, mol, p);
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_pbGamma(h_fig)
        drawCheck(h_fig)
        updateFields(h_fig, 'ttPr');
    end
end
end

% extra frames/s to substract (adapted from edit_photoblParam_02_Callback in MASH.m)
function edit_pbGamma_extraSubstract_Callback(obj, ~, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = str2double(get(obj, 'String'));
    inSec = p.proj{proj}.fix{2}(7);
    nExc = p.proj{proj}.nb_excitations;
    len = nExc*size(p.proj{proj}.intensities,1);
    rate = p.proj{proj}.frame_rate;
    if inSec
        val = rate*round(val/rate);
        maxVal = rate*len;
    else
        val = round(val);
        maxVal = len;
    end
    set(obj, 'String', num2str(val));
    acc = p.proj{proj}.curr{mol}{5}{4}(2);
    
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
            val >= 0 && val <= maxVal)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Extra cutoff must be >= 0 and <= ' ...
            num2str(maxVal)], h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        if inSec
            val = val/rate;
        end
        p.proj{proj}.curr{mol}{5}{5}(acc,3) = val;
        p = calcCutoffGamma(mol, p);
        p = prepostInt(h_fig, mol, p);
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_pbGamma(h_fig)
        drawCheck(h_fig)
        updateFields(h_fig, 'ttPr');
    end
end
end

% minimum cutoff (adapted from edit_photoblParam_03_Callback in MASH.m)
function edit_pbGamma_minCutoff_Callback(obj, ~, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
if ~isempty(p.proj)
    proj = p.curr_proj;
    mol = p.curr_mol(proj);
    val = str2double(get(obj, 'String'));
    inSec = p.proj{proj}.fix{2}(7);
    nExc = p.proj{proj}.nb_excitations;
    len = nExc*size(p.proj{proj}.intensities,1);
    acc = p.proj{proj}.curr{mol}{5}{4}(2);
    start = p.proj{proj}.curr{mol}{5}{5}(acc,5);
    rate = p.proj{proj}.frame_rate;
    if inSec
        val = rate*round(val/rate);
        minVal = rate*start;
        maxVal = rate*len;
    else
        val = round(val);
        minVal = start;
        maxVal = len;
    end
    set(obj, 'String', num2str(val));
    
    if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
            val >= minVal && val <= maxVal)
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        updateActPan(['Minimum cutoff must be >= ' num2str(minVal) ...
            ' and <= ' num2str(maxVal)], h.figure_MASH, 'error');
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        if inSec
            val = val/rate;
        end
        p.proj{proj}.curr{mol}{5}{5}(acc,4) = val;
        p = calcCutoffGamma(mol, p);
        p = prepostInt(h_fig, mol, p);
        h.param.ttPr = p;
        guidata(h.figure_MASH, h);
        ud_pbGamma(h_fig)
        drawCheck(h_fig)
        updateFields(h_fig, 'ttPr');
    end
end
end

% draw the cutoff line; added by FS, 26.4.2018
function drawCutoff(h_fig, drawIt)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
acc = p.proj{proj}.curr{mol}{5}{4}(2);
p.proj{proj}.curr{mol}{5}{5}(acc,1) = drawIt;
set(h.gpo.checkbox_showCutoff, 'Value', drawIt)
h.param.ttPr = p;
guidata(h_fig, h)
updateFields(h_fig, 'ttPr');
end

% compute the gamma factor; added by FS, 26.4.2018
function pushbutton_computeGamma_Callback(obj, ~, h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
mol = p.curr_mol(proj);
h.param.ttPr.proj{proj}.curr{mol}{5}{4}(1) = 1;
guidata(h_fig, h)
updateFields(h_fig, 'ttPr');
set(h.checkbox_pbGamma, 'Value', h.param.ttPr.proj{proj}.curr{mol}{5}{4}(1))
close(gcf)
end
