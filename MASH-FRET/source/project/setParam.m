function ok = setParam(h_fig)
% ok = setParam(h_fig)
%
% Initialize MASH parameters from the file default_param.ini
%
% h_fig: handle to main figure

% Last update, 16.1.2020 by MH: add TP import parameter for beta factor file import
% update, 25.4.2019 by MH: set default tag names and colors in Video processing interface's defaults
% update,28.3.2019 by MH: add gamma file import in Trace processing
% update, 20.2.2019 by MH: add ebFRET-compatible export in Video processing
% update: 7.3.2018 by Richard Börner: (1) Comments adapted for Boerner et al 2017 (2) Simulation default parameters adapted for Boerner et al 2017.
% created 23.4.2014 by MH

% initialize output
ok = 1;

% load interface parameters from file
h = guidata(h_fig);
h.param = [];
[mfile_path,o,o] = fileparts(mfilename('fullpath'));
if exist([mfile_path filesep '..' filesep '..' filesep ...
        'default_param.ini'], 'file')
    try
        h.param = load([mfile_path filesep '..' filesep '..' filesep ...
            'default_param.ini'], '-mat');
    catch err
        h_err = errordlg({err.message '' ...
            'The file will be deleted.' ''...
            'Please run MASH-FRET again to debug.'}, ...
            'Initialisation error', 'modal');
        uiwait(h_err);
        delete([mfile_path filesep '..' filesep '..' filesep ...
            'default_param.ini']);
        ok = 0;
        return
    end
end

% set project list
h.param.proj = {};
h.param.curr_mod = {};
h.param.curr_proj = 0;

% set root folder
pth = userpath;
if ~isempty(pth) && strcmp(pth(end),'\')
    pth = pth(1:end-1);
else
    pth = pwd;
end
h.param.folderRoot = adjustParam('folderRoot', pth, h.param);
if ~exist(h.param.folderRoot, 'dir')
    h.param.folderRoot = pth;
end

% get path to help button image file
[src,o,o] = fileparts(which('setInfoIcons'));
h.param.infos_icon_file = cat(2,src,filesep,'infos_icon.png');

% Default experiment settings
if ~isfield(h.param, 'es')
    h.param.es = [];
end
h.param.es = setParamExp(h.param.es);

% Simulation interface parameters
if ~isfield(h.param, 'sim')
    h.param.sim = [];
end
h.param.sim = setParamSim(h.param.sim);

% Video processing interface parameters
if ~isfield(h.param, 'movPr')
    h.param.movPr = [];
end
h.param.movPr = setParamVP(h.param.movPr);

% Trace processing interface parameters
if ~isfield(h.param, 'ttPr')
    h.param.ttPr = [];
end
h.param.ttPr = setParamTP(h.param.ttPr);

% Histogram analysis interface parameters
if ~isfield(h.param, 'thm')
    h.param.thm = [];
end
h.param.thm = setParamHA(h.param.thm);

% Transition analysis interface parameters
if ~isfield(h.param, 'TDP')
    h.param.TDP = [];
end
h.param.TDP = setParamTA(h.param.TDP);

% save modif
guidata(h_fig, h);


function p = setParamExp(p_input)

% defaults
frameRate = 1;
nChan = 2;
nExc = 1;
excWl = 532;
chanExc = [532,0];
chanLabel = {'Cy3','Cy5'};
expCond = {'Title','new project','';...
    'Molecule','','';...
    '[Mg2+]',[],'mM';...
    '[K+]',[],'mM'};
tagNames = {'static','dynamic','D-only','A-only'};
tagClr = {'#4298B5','#FFFFCC','#33CC33','#FF6666','#E19D29'};
impTrajPrm = {{[1 1 1 1 2 0 1 0 0 5 5 0],1:nExc,reshape(1:(2*nExc),2,nExc)'} ... % trajectory file structure
    {0,''} ... % video file
    {0,'',{reshape(1:2*nChan,2,nChan)',1},256} ... % coordinates file, file structure, video width
    [0,1] ... % coordinates in trajectory file
    [] ... % obsolete: old experimental parameters
    {0,'',{},0,'',{}}}; % gamma files, beta files

p = p_input;

% nb of channels
p.nChan = adjustParam('nChan', nChan, p_input);

% channel labels/emitter names
p.chanLabel = adjustParam('chanLabel', chanLabel, p_input); 
if numel(p.chanLabel)~=p.nChan
    p.chanLabel = split(sprintf(repmat('chan%i ',[1,p.nChan]),1:p.nChan));
    p.chanLabel = p.chanLabel(1:p.nChan)';
end

 % nb of alternating lasers
p.nExc = adjustParam('nExc', nExc, p_input);

% laser wavelength
p.excWl = adjustParam('excWl', excWl, p_input); 
if numel(p.excWl)~=p.nExc
    p.excWl = round(532*(1+0.2*(0:p.nExc-1)));
end

% channel-specific laser wavelength
p.chanExc = adjustParam('chanExc', chanExc, p_input); 
if numel(p.chanExc)~=p.nChan
    p.chanExc = zeros(1,p.nChan);
    p.chanExc(1:min([p.nChan,p.nExc])) = p.excWl(1:min([p.nChan,p.nExc]));
end
for c = 1:p.nChan
    if ~any(p.excWl==p.chanExc(c)) 
        if c<p.nExc && ~any(p.chanExc==p.excWl(c))
            p.chanExc(c) = p.excWl(c);
        else
            p.chanExc(c) = 0;
        end
    end
end

% FRET and stoichiometry pairs
p.FRETpairs = adjustParam('FRETpairs', [], p_input);
p.FRETpairs(~isValidFRETpair(p.FRETpairs,p.chanExc)) = [];
p.Spairs = adjustParam('Spairs', [], p_input);
p.Spairs(~isValidSpair(p.Spairs,p.FRETpairs,p.chanExc),:) = [];

% experimental conditions
p.expCondDef = expCond;
p.expCond = adjustParam('expCond', expCond, p_input);

% video frame rate
p.frameRate = frameRate;

% plot colors
plotClr = getDefTrClr(p.nExc, p.excWl, p.nChan, size(p.FRETpairs,1), ...
    size(p.Spairs,1));
p.plotClr = adjustParam('plotClr', plotClr, p_input);
if size(p.plotClr{1},1)~=p.nExc || size(p.plotClr{1},2)~=p.nChan
    p.plotClr{1} = plotClr{1};
end
if size(p.plotClr{2},1)~=size(p.FRETpairs,1)
    p.plotClr{2} = plotClr{2};
end
if size(p.plotClr{3},1)~=size(p.Spairs,1)
    p.plotClr{3} = plotClr{3};
end

% molecule tags
p.tagNames = adjustParam('tagNames',tagNames,p_input);
p.tagClr = adjustParam('tagClr',tagClr,p_input);
if numel(p.tagClr)~=numel(p.tagNames)
    p.tagClr = p.tagClr(1:min([numel(p.tagClr),numel(p.tagNames)]));
    p.tagNames = p.tagNames(1:min([numel(p.tagClr),numel(p.tagNames)]));
end

% trajectory import options
p.impTrajPrm = adjustParam('impIprm', impTrajPrm, p_input);


function p = setParamSim(p_input)

p = p_input;

% projects' current plots and expanded panel
p.curr_plot = [];
p.curr_pan = [];


function p = setParamVP(p_input)

p = p_input;

% projects' current video frame, plots and expanded panel
p.curr_frame = [];
p.curr_plot = [];
p.curr_pan = [];


function p = setParamTP(p_input)

p = p_input;

% projects' current molecules and plots
p.curr_mol = [];
p.curr_plot = [];
p.curr_pan = [];


function p = setParamHA(p_input)

% defaults
colList = [1 0 0 % red
           0 1 0 % green
           0 0 1 % blue
           1 1 0 % yellow
           0 1 1 % cyan
           1 0 1 % magenta
           0 0.5 0 % olive
           1 0.5 0 % orange
           0.5 0 0 % wine
           0 0 0.5 % marine
           0.5 0.5 0 % kaki
           0 0.5 0.5 % turquoise
           0.5 0 0.5 % purple
           0.5 0.25 0 % brown
           1 0.5 1 % pink
           0.5 0 1 % violet
           0.5 0.5 0.5 % grey
           1 1 0.5 % canary
           0.5 1 1]; % pastel blue
       
p = p_input;

% projects' current data types, molecule subgroup tags, plots and expanded panel
p.curr_tpe = [];
p.curr_tag = [];
p.curr_plot = [];
p.curr_pan = [];

% interface defaults
p.colList = colList;


function p = setParamTA(p_input)

% defaults
colList = [1 0 0 % red
           0 1 0 % green
           0 0 1 % blue
           1 1 0 % yellow
           0 1 1 % cyan
           1 0 1 % magenta
           0 0.5 0 % olive
           1 0.5 0 % orange
           0.5 0 0 % wine
           0 0 0.5 % marine
           0.5 0.5 0 % kaki
           0 0.5 0.5 % turquoise
           0.5 0 0.5 % purple
           0.5 0.25 0 % brown
           1 0.5 1 % pink
           0.5 0 1 % violet
           0.5 0.5 0.5 % grey
           1 1 0.5 % canary
           0.5 1 1]; % pastel blue
       
p = p_input;

% projects' current data types, molecule subgroup tags, plots and expanded panel
p.curr_type = [];
p.curr_tag = [];
p.curr_plot = [];
p.curr_pan = [];

% interface defaults
p.colList = colList;

