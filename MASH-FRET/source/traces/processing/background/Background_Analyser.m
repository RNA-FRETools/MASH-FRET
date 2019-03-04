function varargout = Background_Analyser(varargin)
% Last Modified by GUIDE v2.5 28-Oct-2014 09:29:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Background_Analyser_OpeningFcn, ...
                   'gui_OutputFcn',  @Background_Analyser_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


function Background_Analyser_OpeningFcn(obj, evd, g, varargin)
% store MASH figure handle
g.figure_MASH = varargin{1};

% initialise variables
g.output = obj;
[ok g.param g.curr_m g.curr_l g.curr_c] = setDefBganaPrm(g);
if ~ok
    close all force;
    return;
end
g.res = [];

% update g structure
guidata(obj, g);
ud_fields(obj);


function varargout = Background_Analyser_OutputFcn(obj, evd, g)
% return Background_Analyser figure handle after the figure closes
varargout = {g.output};


% --- Executes when user attempts to close figure_bgopt.
function figure_bgopt_CloseRequestFcn(obj, evd, g)
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
prm = g.param;
m = g.curr_m;

% remove background intensities
for c = 1:nChan
    for l = 1:nExc
        prm{1}{m}(l,c,7) = 0;
    end
end
param.m = prm{1}{m};
param.gen = prm(2:3);

[mfile_path,o,o] = fileparts(mfilename('fullpath'));
save([mfile_path filesep 'default_param.ini'], '-struct', 'param');

delete(obj);


function popupmenu_exc_Callback(obj, evd, g)
g.curr_l = get(obj, 'Value');
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);
plot_bgRes(g.figure_bgopt);


function popupmenu_chan_Callback(obj, evd, g)
g.curr_c = get(obj, 'Value');
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);
plot_bgRes(g.figure_bgopt);


function popupmenu_meth_Callback(obj, evd, g)
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
g.param{1}{m}(l,c,1) = get(obj, 'Value');
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function edit_param1_Callback(obj, evd, g, n)
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
val = str2num(get(obj, 'String'));
if n==0
    g.param{1}{m}(l,c,2) = val;
else
    g.param{2}{1}(l,c,n) = val;
end
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function edit_subimdim_Callback(obj, evd, g, n)
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
val = str2num(get(obj, 'String'));
if n==0
	g.param{1}{m}(l,c,3) = val;
else
	g.param{2}{2}(l,c,n) = val;
end
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function edit_xdark_Callback(obj, evd, g)
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
val = str2num(get(obj, 'String'));
g.param{1}{m}(l,c,4) = val;
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function edit_ydark_Callback(obj, evd, g)
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
val = str2num(get(obj, 'String'));
g.param{1}{m}(l,c,5) = val;
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function checkbox_auto_Callback(obj, evd, g)
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
g.param{1}{m}(l,c,6) = get(obj, 'Value');
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function pushbutton_show_Callback(obj, evd, g)
% update g structure
h = guidata(g.figure_MASH);
p = h.param.ttPr;
if ~isempty(p.proj)
    coord = dispDark(g.figure_bgopt);
    m = g.curr_m;
    l = g.curr_l;
    c = g.curr_c;
    g.param{1}{m}(l,c,4) = coord(1);
    g.param{1}{m}(l,c,5) = coord(2);
end
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function edit_chan_Callback(obj, evd, h_fig, c)
g = guidata(h_fig);
m = g.curr_m;
l = g.curr_l;
val = str2num(get(obj, 'String'));
g.param{1}{m}(l,c,7) = val;
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function pushbutton_prevmol_Callback(obj, evd, g)
curr_m = g.curr_m;
if (curr_m-1)>0
    g.curr_m = curr_m-1;
    guidata(g.figure_bgopt, g);
    ud_fields(g.figure_bgopt);
    plot_bgRes(g.figure_bgopt);
end


function edit_curmol_Callback(obj, evd, g)
val = str2num(get(obj, 'String'));
g.curr_m = val;
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);
plot_bgRes(g.figure_bgopt)


function pushbutton_nextmol_Callback(obj, evd, g)
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nMol = size(p.proj{proj}.intensities,2)/nChan;
curr_m = g.curr_m;
if (curr_m+1)<=nMol
    g.curr_m = curr_m+1;
    guidata(g.figure_bgopt, g);
    ud_fields(g.figure_bgopt);
    plot_bgRes(g.figure_bgopt)
end


function pushbutton_allMol_Callback(obj, evd, g)
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nMol = size(p.proj{proj}.intensities,2)/nChan;
curr_m = g.curr_m;

for m = 1:nMol
    g.param{1}{m} = g.param{1}{curr_m};
end
guidata(g.figure_bgopt,g);


function pushbutton_allChan_Callback(obj, evd, g)
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
curr_m = g.curr_m;
curr_l = g.curr_l;
curr_c = g.curr_c;
for l = 1:nExc
    for c = 1:nChan
        g.param{1}{curr_m}(l,c,:) = g.param{1}{curr_m}(curr_l,curr_c,:);
        g.param{2}{1}(l,c,:) = g.param{2}{1}(curr_l,curr_c,:);
        g.param{2}{2}(l,c,:) = g.param{2}{2}(curr_l,curr_c,:);
        g.param{2}{3}(l,c,:) = g.param{2}{3}(curr_l,curr_c,:);
    end
end
guidata(g.figure_bgopt,g);


function checkbox_allmol_Callback(obj, evd, g)
g.param{3}(3) = get(obj, 'Value');
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function radiobutton_fix_param1_Callback(obj, evd, g)
val = get(obj, 'Value');
g.param{3}(1) = val;
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function radiobutton_fix_subimdim_Callback(obj, evd, g)
val = get(obj, 'Value');
g.param{3}(2) = val;
% update g structure
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);


function pushbutton_start_Callback(obj, evd, g)
if ~checkfield(g.figure_bgopt)
    return;
end
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nMol = size(p.proj{proj}.intensities,2)/nChan;

if ~g.param{3}(1) % varies param 1
    p1 = g.param{2}{1};
    N = size(p1,3);
else
    N = 1;
end
if ~g.param{3}(2) % varies sub-image dim.
    subdim = g.param{2}{2};
    N = N*size(subdim,3);
end
if g.param{3}(3) % all molecules
    mols = 1:nMol;
else
    mols = g.curr_m;
end

bg_m = cell(nMol,nExc,nChan);
% loading bar parameters--------------------------------------
err = loading_bar('init', g.figure_MASH, numel(mols)*N, ...
    'Calculate background intensities...');
if err
    return;
end
h = guidata(g.figure_MASH);
h.barData.prev_var = h.barData.curr_var;
guidata(g.figure_MASH, h);
% ------------------------------------------------------------

for m = mols
    isprm1 = sum([sum(sum(g.param{1}{m}(:,:,1)==3)) ...
        sum(sum(g.param{1}{m}(:,:,1)==4)) ...
        sum(sum(g.param{1}{m}(:,:,1)==5)) ...
        sum(sum(g.param{1}{m}(:,:,1)==6)) ...
        sum(sum(g.param{1}{m}(:,:,1)==7))]) ;
    if g.param{3}(1) || ~isprm1 % fix param 1
        p1 = g.param{1}{m}(:,:,2);
    end
    issubdim = sum(sum(g.param{1}{m}(:,:,1)~=1));
    if g.param{3}(2) || ~issubdim % fix sub-image dim.
        subdim = g.param{1}{m}(:,:,3);
    end
    for i1 = 1:size(p1,3)
        for i2 = 1:size(subdim,3)
            bg = calcBg(m, p1(:,:,i1), subdim(:,:,i2), g.figure_bgopt);
            for l = 1:nExc
                for c = 1:nChan
                    if i1==1 && i2==1
                        g.param{1}{m}(l,c,7) = bg(l,c);
                    end
                    bg_m{m,l,c} = [bg_m{m,l,c}; [bg(l,c) p1(l,c,i1) ...
                        subdim(l,c,i2)]];
                    if i1==1 && i2==1
                        g.param{1}{m}(l,c,7) = bg(l,c);
                    end
                end
            end
            % loading bar updating-------------------------------------
            err = loading_bar('update', g.figure_MASH);
            if err
                return;
            end
            % ---------------------------------------------------------
        end
    end
end
loading_bar('close', g.figure_MASH);
g.res = bg_m;
guidata(g.figure_bgopt, g);
ud_fields(g.figure_bgopt);
plot_bgRes(g.figure_bgopt);


function pushbutton_save_Callback(obj, evd, g)
% update g structure
saveBgOpt(g.figure_bgopt);


function ud_fields(h_fig)
g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param.ttPr;
if ~isempty(p.proj)
    % parameters from MASH
    proj = p.curr_proj;
    nChan = p.proj{proj}.nb_channel;
    exc = p.proj{proj}.excitations;
    clr = p.proj{proj}.colours{1};
    labels = p.proj{proj}.labels;
    perSec = p.proj{proj}.fix{2}(4);
    perPix = p.proj{proj}.fix{2}(5);
    rate = p.proj{proj}.frame_rate;
    nPix = p.proj{proj}.pix_intgr(2);

    % parameters from BG analyser
    m = g.curr_m;
    l = g.curr_l;
    c = g.curr_c;
    meth = g.param{1}{m}(l,c,1);
    sngl_param1 = g.param{1}{m}(l,c,2);
    sngl_subdim = g.param{1}{m}(l,c,3);
    xdark = g.param{1}{m}(l,c,4);
    ydark = g.param{1}{m}(l,c,5);
    auto = g.param{1}{m}(l,c,6);
    bgVal = g.param{1}{m}(l,:,7);
    mlt_param1 = squeeze(g.param{2}{1}(l,c,:))';
    mlt_subdim = squeeze(g.param{2}{2}(l,c,:))';
    fix_param1 = g.param{3}(1);
    fix_subdim = g.param{3}(2);
    allmol = g.param{3}(3);
    
    str_un = '(a.u. /pix)';
    if perSec
        str_un = '(a.u. /pix /s)';
    end
    
    % create as many edit fields for bg intensity as for the number of
    % channels
    if ~isfield(g, 'edit_chan') || ...
            (isfield(g, 'edit_chan') && numel(g.edit_chan)~=nChan)
        try
            delete([g.edit_chan g.text_chan]);
        catch err
            disp(err.message);
        end
        g.text_chan = [];
        g.edit_chan = [];
        y_edit = 39; y_txt = 56; mg = 10; w_edit = 40; h_edit = 20;
        xNext = 150;
        for c = 1:nChan
            g.text_chan(c) = uicontrol('Style', 'text', 'Parent', ...
                g.uipanel_determine_bg, 'Units', 'pixel', 'Position', ...
                [xNext y_txt w_edit h_edit], 'String', ...
                labels{c}, 'HorizontalAlignment', 'center');
            g.edit_chan(c) = uicontrol('Style', 'edit', 'Parent', ...
                g.uipanel_determine_bg, 'Units', 'pixel', 'Position', ...
                [xNext y_edit w_edit h_edit], 'Callback', ...
                {@edit_chan_Callback, h_fig, c}, 'TooltipString', ...
                sprintf('Background intensity in %s channel %s', ...
                labels{c}, str_un));
            xNext = xNext + w_edit + mg;
        end
    end
    
    % set popupmenu strings and values
    if isempty(set(g.popupmenu_exc, 'String'))
        set(g.popupmenu_exc, 'String', getStrPop('exc', exc));
    end
    set(g.popupmenu_exc, 'Value', l);
    if isempty(get(g.popupmenu_chan, 'String'))
        set(g.popupmenu_chan, 'String', getStrPop('chan', {labels, ...
            l, clr}));
    end
    set(g.popupmenu_chan, 'Value', c);
    if isempty(get(g.popupmenu_meth, 'String'))
        set(g.popupmenu_meth, 'String', get(h.popupmenu_trBgCorr, ...
            'String'));
    end
    set(g.popupmenu_meth, 'Value', meth);
    
    set(g.text_bgval, 'String', sprintf('Background values (%inm):', ...
        exc(l)));

    if ~fix_param1
        edit_param1 = [g.edit_param1_1 g.edit_param1_2 g.edit_param1_3 ...
            g.edit_param1_4 g.edit_param1_5 g.edit_param1_6 ...
            g.edit_param1_7 g.edit_param1_8 g.edit_param1_9 ...
            g.edit_param1_10];
        set(g.edit_param1, 'Enable', 'off');
    else
        edit_param1 = g.edit_param1;
        set([g.edit_param1_1 g.edit_param1_2 g.edit_param1_3 ...
            g.edit_param1_4 g.edit_param1_5 g.edit_param1_6 ...
            g.edit_param1_7 g.edit_param1_8 g.edit_param1_9 ...
            g.edit_param1_10], 'Enable', 'off');
    end
    if ~fix_subdim
        edit_subimdim = [g.edit_subimdim_1 g.edit_subimdim_2 ...
            g.edit_subimdim_3 g.edit_subimdim_4 g.edit_subimdim_5 ...
            g.edit_subimdim_6 g.edit_subimdim_7 g.edit_subimdim_8 ...
            g.edit_subimdim_9 g.edit_subimdim_10];
        set(g.edit_subimdim, 'Enable', 'off');
    else
        edit_subimdim = g.edit_subimdim;
        set([g.edit_subimdim_1 g.edit_subimdim_2 ...
            g.edit_subimdim_3 g.edit_subimdim_4 g.edit_subimdim_5 ...
            g.edit_subimdim_6 g.edit_subimdim_7 g.edit_subimdim_8 ...
            g.edit_subimdim_9 g.edit_subimdim_10], 'Enable', 'off');
    end
    
    set([edit_param1 edit_subimdim g.edit_xdark g.edit_ydark ...
        g.edit_chan g.edit_curmol], 'BackgroundColor', [1 1 1]);
    
    set([g.text_exc g.popupmenu_exc g.text_chan g.popupmenu_chan ...
        g.text_meth g.popupmenu_meth g.text_bgval g.text_curmol ...
        g.edit_curmol g.checkbox_allmol g.pushbutton_start ...
        g.pushbutton_save], 'Enable', 'on');
    
    if meth==1 % Manual
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'off');
        set(g.edit_chan, 'Enable', 'on');
            
    elseif meth==2 % 20 darkest, Mean value
        set([g.text_param1 edit_param1 g.text_xdark g.edit_xdark ...
            g.text_ydark g.edit_ydark g.checkbox_auto ...
            g.pushbutton_show g.radiobutton_fix_param1], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_subimdim edit_subimdim g.radiobutton_fix_subimdim], ...
            'Enable', 'on');
        
    elseif meth==3 % Mean value
        set([g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        set(edit_param1, 'Tooltipstring', 'Tolerance cutoff');
            
    elseif meth==4 % Most frequent value, Histothresh 50% value
        set([g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        set(edit_param1, 'Tooltipstring', 'Number of binning interval');
        
    elseif meth==5 % Histothresh
        set([g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        set(edit_param1, 'Tooltipstring', ...
            'Cumulative probability threshold');
            
    elseif meth==6 % Dark trace
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.text_xdark g.text_ydark g.checkbox_auto g.pushbutton_show ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        if ~auto
            set([g.edit_xdark g.edit_ydark], 'Enable', 'on');
        else
           set([g.edit_xdark g.edit_ydark], 'Enable', 'inactive');
        end
        set(g.edit_chan, 'Enable', 'inactive');
        set(edit_param1, 'TooltipString', 'Running average window size');
        
    elseif meth==7 % Median value
        set([g.text_xdark g.edit_xdark g.text_ydark g.edit_ydark ...
            g.checkbox_auto g.pushbutton_show], 'Enable', 'off');
        set(g.edit_chan, 'Enable', 'inactive');
        set([g.text_param1 edit_param1 g.text_subimdim edit_subimdim ...
            g.radiobutton_fix_subimdim g.radiobutton_fix_param1], ...
            'Enable', 'on');
        set(edit_param1, 'Tooltipstring', sprintf(['Calculation method' ...
            '\n\t1: median(median_y)\n\t2: 0.5*(median(median_y)+' ...
            'median(median_x))']));
    end

    if perSec
        bgVal = bgVal/rate;
    end
    if perPix
        bgVal = bgVal/nPix;
    end
    edit_param1 = [g.edit_param1 g.edit_param1_1 g.edit_param1_2 ...
        g.edit_param1_3 g.edit_param1_4 g.edit_param1_5 g.edit_param1_6 ...
        g.edit_param1_7 g.edit_param1_8 g.edit_param1_9 g.edit_param1_10];
    param1 = [sngl_param1 mlt_param1];
    for i = 1:numel(edit_param1)
        set(edit_param1(i), 'String', num2str(param1(i)));
    end
    edit_subimdim = [g.edit_subimdim g.edit_subimdim_1 ...
        g.edit_subimdim_2 g.edit_subimdim_3 g.edit_subimdim_4 ...
        g.edit_subimdim_5 g.edit_subimdim_6 g.edit_subimdim_7 ...
        g.edit_subimdim_8 g.edit_subimdim_9 g.edit_subimdim_10];
    subdim = [sngl_subdim mlt_subdim];
    for i = 1:numel(subdim)
        set(edit_subimdim(i), 'String', num2str(subdim(i)));
    end
    set(g.edit_xdark, 'String', num2str(xdark));
    set(g.edit_ydark, 'String', num2str(ydark));
    set(g.checkbox_auto, 'Value', auto);
    for c = 1:nChan
        set(g.edit_chan(c), 'String', num2str(bgVal(c)));
    end
    set(g.edit_curmol, 'String', num2str(m));
    set(g.checkbox_allmol, 'Value', allmol);
    set(g.radiobutton_fix_subimdim, 'Value', fix_subdim);
    set(g.radiobutton_fix_param1, 'Value', fix_param1);
    
    guidata(h_fig, g);
else
    setProp(get(h_fig, 'Children'), 'Enable', 'off');
end


function [ok,param,curr_m,curr_l,curr_c] = setDefBganaPrm(g)
param = [];
curr_m = 1; curr_l = 1; curr_c = 1;
ok = 1;

[mfile_path,o,o] = fileparts(mfilename('fullpath'));

if exist([mfile_path filesep 'default_param.ini'], 'file')
    try
        prm_prev = load([mfile_path filesep 'default_param.ini'], '-mat');
        param = cell(1,3);
    catch err
        h_err = errordlg({err.message '' ...
            'The file will be deleted.' ''...
            'Please run MASH-FRET again to debug.'}, ...
            'Initialisation error', 'modal');
        uiwait(h_err);
        delete([mfile_path filesep '..' filesep '..' filesep ...
            'default_param.ini']);
        ok = 0;
        return;
    end
end

h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nMol = size(p.proj{proj}.intensities,2)/nChan;

curr_m = p.curr_mol(proj); % current molecule
curr_l = p.proj{proj}.fix{3}(5); % current excitation
curr_c = p.proj{proj}.fix{3}(6); % current channel

for m = 1:nMol
    if exist('prm_prev','var')
        param{1}{m} = prm_prev.m;
    end

    p_BG = p.proj{proj}.curr{m}{3};
    meth = p_BG{2};
    def{1}{m}(:,:,1) = meth; % [nExc-by-nChan] correction methods
    
    for l = 1:nExc
        for c = 1:nChan
            prm = p_BG{3}{l,c}(meth(l,c),:);
            def{1}{m}(l,c,2) = prm(1); % [nExc-by-nChan] parameters 1
            def{1}{m}(l,c,3) = prm(2); % [nExc-by-nChan] sub-image dim.
            def{1}{m}(l,c,4) = prm(4); % [nExc-by-nChan] dark x-coord.
            def{1}{m}(l,c,5) = prm(5); % [nExc-by-nChan] dark y-coord.
            def{1}{m}(l,c,6) = prm(6); % [nExc-by-nChan] auto dark
                                          % coord.
            def{1}{m}(l,c,7) = prm(3); % [nExc-by-nChan] BG intensities
            if m == 1
                def{2}{1}(l,c,:) = 100:-10:10; % [nExc-by-nChan-by-10] param 1
                def{2}{2}(l,c,:) = zeros(1,1,10); % [nExc-by-nChan-by-10] param 2
                def{2}{3}(l,c,:) = 5:5:50; % [nExc-by-nChan-by-10] subimge dim.
            end
        end
    end
end
def{3}(1) = true; % Fix parameter 1 for all calc.
def{3}(2) = true; % Fix parameter 2 for all calc.
def{3}(3) = true; % calculate for all molecules

if exist('prm_prev','var')
    param(2:3) = prm_prev.gen;
end

param = adjustVal(param, def);


function bg_m = calcBg(m, p1, subdim, h_fig)
g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
nPix = p.proj{proj}.pix_intgr(2);
res_x = p.proj{proj}.movie_dim(1);
res_y = p.proj{proj}.movie_dim(2);
split = round(res_x/nChan)*(1:nChan-1);
lim_x = [0 split res_x];
lim_y = [0 res_y];

bg_m = zeros(nExc,nChan);

for l = 1:nExc
    for c = 1:nChan
        sub_w = subdim(l,c);
        coord = floor(p.proj{proj}.coord(m,(2*c-1):2*c))+0.5;
        lim_img_x = [coord(1)-sub_w/2 coord(1)+sub_w/2];
        lim_img_y = [coord(2)-sub_w/2 coord(2)+sub_w/2];

        if lim_img_x(1) <= lim_x(c)
            lim_img_x(1) = lim_x(c)+1;
            lim_img_x(2) = lim_x(c) + sub_w;

        elseif lim_img_x(2) >= lim_x(c+1)
            lim_img_x(2) = lim_x(c+1);
            lim_img_x(1) = lim_x(c+1)-sub_w+1;
        end
        if lim_img_y(1) <= lim_y(1)
            lim_img_y(1) = lim_y(1)+1;
            lim_img_y(2) = lim_y(1) + sub_w;

        elseif lim_img_y(2) >= lim_y(2)
            lim_img_y(2) = lim_y(2);
            lim_img_y(1) = lim_y(2)-sub_w+1;
        end
        lim_img_y = ceil(lim_img_y);
        lim_img_x = ceil(lim_img_x);
        img = p.proj{proj}.aveImg{l}( ...
            lim_img_y(1):lim_img_y(2), ...
            lim_img_x(1):lim_img_x(2));
        
        switch g.param{1}{m}(l,c,1)
            case 1 % Manual
                bg = g.param{1}{m}(l,c,7);

            case 2 % 20 darkest value
                [bg o] = determine_bg(14, img, []);
                bg = nPix*bg;

            case 3 % Mean value
                [bg o] = determine_bg(11, img, p1);
                bg = nPix*bg;

            case 4 % Most frequent value
                [bg o] = determine_bg(12, img, [0 p1(l,c)]);
                bg = nPix*bg;

            case 5 % Histothresh
                [bg o] = determine_bg(13, img, [0 p1(l,c)]);
                bg = nPix*bg;

            case 6 % Dark trace
                aDim = p.proj{proj}.pix_intgr(1);
                autoDark = g.param{1}{m}(l,c,6);
                fDat = [p.proj{proj}.movie_file ...
                    p.proj{proj}.movie_dat(1) [res_y res_x] ...
                    p.proj{proj}.movie_dat(3:end)];
                if autoDark
                    coord_dark = getDarkCoord(l, m, c, p, sub_w);
                else
                    coord_dark = [g.param{1}{m}(l,c,4) ...
                        g.param{1}{m}(l,c,5)];
                    res_y = p.proj{proj}.movie_dim(2);
                    res_x = p.proj{proj}.movie_dim(1);
                    min_xy = aDim/2;
                    max_y = res_y - aDim/2;
                    max_x = res_x - aDim/2;
                    coord_dark(coord_dark(:,1:2)<=min_xy)=min_xy+1;
                    coord_dark(coord_dark(:,1)>=max_x)=max_x-1;
                    coord_dark(coord_dark(:,2)>=max_y)=max_y-1;
                end
                g.param{1}{m}(l,c,4) = coord_dark(1);
                g.param{1}{m}(l,c,5) = coord_dark(2);
                [o I_bg] = create_trace(coord_dark, aDim, nPix, ...
                    fDat);
                bg = slideAve(I_bg(l:nExc:end,:), p1(l,c));
                
            case 7 % Median value
                [bg o] = determine_bg(15, img, p1(l,c));
                bg = nPix*bg;
        end

        bg_m(l,c) = mean(bg);
    end
end
guidata(h_fig, g);

function plot_bgRes(h_fig)
g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
if isempty(g.res)
    return;
end
res_m = g.res{m,l,c};
if isempty(res_m)
    return;
end
perSec = p.proj{proj}.fix{2}(4);
rate = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
str_un = '(a.u. /pix)';
if perSec
    str_un = '(a.u. /pix /s)';
    res_m(:,1) = res_m(:,1)/rate;
end
res_m(:,1) = res_m(:,1)/nPix;

if isempty(res_m)
    rotate3d(g.axes_plot_bgint, 'off');
    cla(g.axes_plot_bgint);
    return;
end

meth = g.param{1}{m}(l,c,1);

str_p1 = 'none'; isprm1 = false;
str_sbig = 'none'; issubdim = false;
if meth~=1
    str_sbig = num2str(res_m(1,3)); % method not manual
    issubdim = true;
end
if sum(meth==[3 4 5 6 7]) % method "mean value", "most frequent value" or 
                        % "histothresh50%" or "dark trace"
    str_p1 = num2str(res_m(1,2));
    isprm1 = true;
end

if g.param{3}(1) || ~isprm1
    if size(res_m,1)>=1 && (g.param{3}(2) || ~issubdim)
        % fix param 1 and sub-image dim.
        % no plot
        cla(g.axes_plot_bgint);
        xlim(g.axes_plot_bgint, [0 1]);
        ylim(g.axes_plot_bgint, [0 1]);
        text(0.05, 0.95, sprintf([ ...
            'Previous calculation:\n' ...
            'BG intensity ' str_un ' = %d\n' ...
            'Parameter 1 = %s\n', ...
            'Sub-image dim. (pixel) = %s\n'], res_m(1), str_p1, ...
            str_sbig), 'Parent', g.axes_plot_bgint, ...
            'Units', 'data', 'VerticalAlignment', 'top');
        view(g.axes_plot_bgint, 2);
        rotate3d(g.axes_plot_bgint, 'off');
        title(g.axes_plot_bgint, '');
        xlabel(g.axes_plot_bgint, '');
        ylabel(g.axes_plot_bgint, '');
        zlabel(g.axes_plot_bgint, '');
        grid(g.axes_plot_bgint, 'off');

    elseif size(res_m,1)>=10 % fix param 1
                             % varies sub-image dim.
        plot(g.axes_plot_bgint, res_m(1:10,3), res_m(1:10,1), '+b');
        title(g.axes_plot_bgint, sprintf(['Previous calculation: ' ...
            'Parameter 1 = %s'], str_p1));
        view(g.axes_plot_bgint, 2);
        rotate3d(g.axes_plot_bgint, 'off');
        xlabel(g.axes_plot_bgint, 'Sub-image dim. (pixel)');
        ylabel(g.axes_plot_bgint, ['BG intensity ' str_un]);
        zlabel(g.axes_plot_bgint, '');
    end
else
    if size(res_m,1)>=10 && (g.param{3}(2) || ~issubdim) 
        % fix sub-image dim.
        % varies param 1
        plot(g.axes_plot_bgint, res_m(1:10,2), res_m(1:10,1), '+b');
        title(g.axes_plot_bgint, sprintf(['Previous calculation: ' ...
            'Sub-image dim. = %s'], str_sbig));
        view(g.axes_plot_bgint, 2);
        rotate3d(g.axes_plot_bgint, 'off');
        xlabel(g.axes_plot_bgint, 'Parameter 1');
        ylabel(g.axes_plot_bgint, ['BG intensity ' str_un]);
        zlabel(g.axes_plot_bgint, '');

    elseif size(res_m,1)>=10 % varies param 1 and sub-image dim.
        X = reshape(res_m(1:100,2), [10 10]);
        Y = reshape(res_m(1:100,3), [10 10]);
        Z = reshape(res_m(1:100,1), [10 10]);
        surf(g.axes_plot_bgint, X, Y, Z);
        title(g.axes_plot_bgint, 'Previous calculation:');
        rotate3d(g.axes_plot_bgint, 'on');
        xlabel(g.axes_plot_bgint, 'Parameter 1');
        ylabel(g.axes_plot_bgint, 'Sub-image dim. (pixel)');
        zlabel(g.axes_plot_bgint, ['BG intensity ' str_un]);

    end
end


function ok = checkfield(h_fig)
ok = 0;
g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nMol = size(p.proj{proj}.intensities,2)/nChan;
exc = p.proj{proj}.chanExc;
chan = p.proj{proj}.labels;

% update g structure
if ~g.param{3}(1) % fix param 1
    p1 = g.param{2}{1};
    edit_param1 = [g.edit_param1_1 g.edit_param1_2 g.edit_param1_3 ...
        g.edit_param1_4 g.edit_param1_5 g.edit_param1_6 g.edit_param1_7 ...
        g.edit_param1_8 g.edit_param1_9 g.edit_param1_10];
else
    edit_param1 = g.edit_param1;
end
if ~g.param{3}(2) % fix sub-image dim.
    subdim = g.param{2}{2};
    edit_subimdim = [g.edit_subimdim_1 g.edit_subimdim_2 ...
        g.edit_subimdim_3 g.edit_subimdim_4 g.edit_subimdim_5 ...
        g.edit_subimdim_6 g.edit_subimdim_7 g.edit_subimdim_8 ...
        g.edit_subimdim_9 g.edit_subimdim_10];
else
    edit_subimdim = g.edit_subimdim;
end
if g.param{3}(3) % all molecules
    mols = 1:nMol;
else
    mols = g.curr_m;
end

for m = mols
    isprm1 = sum([sum(sum(g.param{1}{m}(:,:,1)==3)) ...
        sum(sum(g.param{1}{m}(:,:,1)==4)) ...
        sum(sum(g.param{1}{m}(:,:,1)==5)) ...
        sum(sum(g.param{1}{m}(:,:,1)==6))]) ;
    if g.param{3}(1) || ~isprm1 % fix param 1
        p1 = g.param{1}{m}(:,:,2);
    end
    issubdim = sum(sum(g.param{1}{m}(:,:,1)~=1));
    if g.param{3}(2) || ~issubdim % fix sub-image dim.
        subdim = g.param{1}{m}(:,:,3);
    end
    if g.param{3}(1) % fix param 1
        p1 = g.param{1}{m}(:,:,2);
    end
    if g.param{3}(3) % fix sub-image dim.
        subdim = g.param{1}{m}(:,:,3);
    end
    for l = 1:nExc
        for c = 1:nChan
            meth = g.param{1}{m}(l,c,1);
            % param 1
            if sum(meth==[3 4 5 6 7])
                for i1 = 1:size(p1,3)
                    if meth==6 && ~(numel(p1(l,c,i1))==1 && ...
                            ~isnan(p1(l,c,i1)) && p1(l,c,i1)>=0)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe sliding ' ...
                            'average window size must be an integer >=' ...
                            ' 0.'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    elseif meth==3 && ~(numel(p1(l,c,i1))==1 ...
                            && ~isnan(p1(l,c,i1)) && p1(l,c,i1)>=0)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe tolerance ' ...
                            'cutoff must be >=0'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    elseif meth==4 && ~(numel(p1(l,c,i1))==1 ...
                            && ~isnan(p1(l,c,i1)) && p1(l,c,i1)>0)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe number of ' ...
                            'interval must be a strictly positive ' ...
                            'number.'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    elseif meth==5 && ~(numel(p1(l,c,i1))==1 ...
                            && ~isnan(p1(l,c,i1)) && p1(l,c,i1)>=0 && ...
                            p1(l,c,i1)<=1)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe cumulative ' ...
                            'probability threshold must be comprised ' ...
                            'between 0 and 1.'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    elseif meth==7 && ~(numel(p1(l,c,i1))==1 && ...
                            ~isnan(p1(l,c,i1)) && sum(p1(l,c,i1)==[1 2]))
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nMedian ' ...
                            'calculation method must be 1 or 2'], m, ...
                            chan{c}, exc(l)), g.figure_MASH, 'error');
                        set(edit_param1(i1), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    end
                end
            end
            % sub-image dim.
            if ~meth==1
                for i2 = 1:size(subdim,3)
                    if ~(numel(subdim(l,c,i2))==1 && ...
                            ~isnan(subdim(l,c,i2)) && subdim(l,c,i2)>0)
                        updateActPan(sprintf(['Molecule %i, %s channel' ...
                            ' upon %inm excitation:\nThe sub-image ' ...
                            'dimensions must be a strictly positive ' ...
                            'number.'], m, chan{c}, exc(l)), ...
                            g.figure_MASH, 'error');
                        set(edit_subimdim(i2), 'BackgroundColor', ...
                            [1 0.75 0.75]);
                        return;
                    end
                end
            end
            if meth==6
                % dark x-coord
                % dark y-coord
            end
            if meth==1
                % BG intensity
            end
        end
    end
end
ok = 1;


function coord_dark = dispDark(h_fig)
g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
res_y = p.proj{proj}.movie_dim(2);
res_x = p.proj{proj}.movie_dim(1);
aDim = p.proj{proj}.pix_intgr(1);
nExc = p.proj{proj}.nb_excitations;
nPix = p.proj{proj}.pix_intgr(2);
fDat = [p.proj{proj}.movie_file p.proj{proj}.movie_dat(1) [res_y res_x] ...
    p.proj{proj}.movie_dat(3:end)];
nFrames = size(p.proj{proj}.intensities,1)*p.proj{proj}.nb_excitations;
perSec = p.proj{proj}.fix{2}(4);
rate = p.proj{proj}.frame_rate;

m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
meth = g.param{1}{m}(l,c,1);
if meth == 6
    autoDark = g.param{1}{m}(l,c,6);
    if autoDark
        subw = g.param{1}{m}(l,c,3);
        coord_dark = getDarkCoord(l, m, c, p, subw);
    else
        coord_dark = [g.param{1}{m}(l,c,4) g.param{1}{m}(l,c,5)];

        min_xy = aDim/2;
        max_y = res_y - aDim/2;
        max_x = res_x - aDim/2;
        coord_dark(coord_dark(:,1:2)<=min_xy)=min_xy+1;
        coord_dark(coord_dark(:,1)>=max_x)=max_x-1;
        coord_dark(coord_dark(:,2)>=max_y)=max_y-1;
    end
    
    p1 = g.param{1}{m}(l,c,2);

    [o I_bg] = create_trace(coord_dark, aDim, nPix, fDat);
    I_bg = slideAve(I_bg(l:nExc:end,:), p1);

    y_lab = 'a.u.';

    if perSec
        I_bg = I_bg/rate;
        y_lab = [y_lab '/s'];
    end

    I_bg = I_bg/nPix;
    y_lab = [y_lab ' /pix'];

    inSec = p.proj{proj}.fix{2}(7);
    x_axis = l:nExc:nFrames;
    if inSec
        x_axis = x_axis*rate;
        x_lab = 'time (s)';
    else
        x_lab = 'frames';
    end


    h_fig = figure('Name', ['Dark trace: (' num2str(coord_dark(1)) ...
        ',' num2str(coord_dark(2)) ')'], 'Visible', 'off', 'Color', ...
        [1 1 1], 'Units', 'pixels');
    units = get(h.axes_top, 'Units');
    set(h.axes_top, 'Units', 'pixels');
    pos_top = get(h.axes_top, 'OuterPosition');
    set(h.axes_top, 'Units', units);
    pos_fig = get(h_fig, 'Position');
    set(h_fig, 'Position', [pos_fig(1:2) pos_top(3:4)]);
    h_axes = axes('Parent', h_fig, 'Units', 'pixels', ...
        'OuterPosition', [0,0,pos_top(3:4)]);
    set(h_axes, 'Units', 'normalized');
    plot(h_axes, x_axis, I_bg, '-k');
    xlim(h_axes, get(h.axes_top, 'XLim'));
    ylim(h_axes, 'auto');
    ylabel(h_axes, y_lab);
    xlabel(h_axes, x_lab);
    set(h_fig, 'Visible', 'on');
end


function saveBgOpt(h_fig)
g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nMol = size(p.proj{proj}.intensities,2)/nChan;
exc = p.proj{proj}.excitations;
labels = p.proj{proj}.labels;
perSec = p.proj{proj}.fix{2}(4);
rate = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);

[o,defname,o] = fileparts(p.proj{proj}.proj_file);
defname = [setCorrectPath('traces_processing', g.figure_MASH) ...
    'optimisation' filesep defname];
[fname,pname,o] = uiputfile({'*.txt', 'Text files(*.txt)'; '*.*', ...
    'All files(*.*)'}, 'Export BG optimisation', defname);
if ~sum(fname)
    return;
end
[o,fname,o] = fileparts(fname);

for l = 1:nExc
    for c = 1:nChan
        dat = [];
        for m = 1:nMol
            if m==1
                meth = g.param{1}{m}(l,c,1);
                dat = g.res{m,l,c}(:,2:end);
            end
            if meth~=g.param{1}{m}(l,c,1);
                updateActPan(['The export function supports only a ' ...
                    'unique correction method for all molecules.'], ...
                    g.figure_MASH, 'error');
                return;
            end
            dat = [dat g.res{m,l,c}(:,1)];
        end
        
        str_un = '(a.u. /pix)';
        if perSec
            str_un = '(a.u. /pix /s)';
            dat(:,3:end) = dat(:,3:end)/rate;
        end
        dat(:,3:end) = dat(:,3:end)/nPix;

        % export BG intensities and statistics
        f = fopen([pname fname '_' labels{c} '-' num2str(exc(l)) ...
            'nm.bga'], 'Wt');
        if meth==1
            prm = [];
            fprintf(f, ['mean_value' str_un '\tstd_value' str_un '\t' ...
                repmat(['mol_%i' str_un '\t'], [1,nMol]) '\n'], (1:nMol)');
        elseif sum(meth==[3 4 5 6]) % sub image, param 1
            prm = [1 2];
            fprintf(f, ['subimage_size(pix)\tparam_1\t' ...
                'mean_value' str_un '\tstd_value' str_un '\t' ...
                repmat(['mol_%i' str_un '\t'],[1,nMol]) '\n'], (1:nMol)');
        else % sub image
            prm = 1;
            fprintf(f, ['subimage_size(pix)\tmean_value' str_un ...
                '\tstd_value' str_un '\t' repmat(['mol_%i' str_un ...
                '\t'],[1,nMol]) '\n'], (1:nMol)');
        end
        means = mean(dat(:,(numel(prm)+1):end),2);
        stds = std(dat(:,(numel(prm)+1):end),0,2);
        fprintf(f, [repmat('%d\t', [1,(size(dat,2)-3)+numel(prm)+2]) ...
            '\n'], [dat(:,prm) means stds dat(:,4:end)]');
        fclose(f);
    end
end
