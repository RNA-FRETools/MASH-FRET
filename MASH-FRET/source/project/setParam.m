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
splt = 1;
nChan = 2;
nExc = 1;
expCond = getDefExpCond;
tagNames = {'D','A','static','dynamic'};
tagClr = {'#3CB371','#FFA500','#0000FF','#EE82EE'};
impHistPrm = [0,1,1,2]; % histogram file structure

p = p_input;

% nb of channels
p.nChan = adjustParam('nChan', nChan, p_input);

% nb of alternating lasers
p.nExc = adjustParam('nExc', nExc, p_input);

% channel- and laser-dependant parameters
p.chanLabel = adjustcellsize(adjustParam('chanLabel',cell(p.nExc,p.nChan),...
    p_input),p.nExc,p.nChan);
p.excWl = adjustcellsize(adjustParam('excWl',cell(p.nExc,p.nChan),p_input),...
    p.nExc,p.nChan);
p.chanExc = adjustcellsize(adjustParam('chanExc',cell(p.nExc,p.nChan),...
    p_input),p.nExc,p.nChan); 
p.FRETpairs = adjustcellsize(adjustParam('FRETpairs',cell(p.nExc,p.nChan),...
    p_input),p.nExc,p.nChan); 
p.Spairs = adjustcellsize(adjustParam('Spairs',cell(p.nExc,p.nChan),...
    p_input),p.nExc,p.nChan); 
p.expCond = adjustcellsize(adjustParam('expCond',cell(p.nExc,p.nChan),...
    p_input),p.nExc,p.nChan);
p.plotClr = adjustcellsize(adjustParam('plotClr',cell(p.nExc,p.nChan),...
    p_input),p.nExc,p.nChan);
p.impTrajPrm = adjustcellsize(adjustParam('impTrajPrm',...
    cell(p.nExc,p.nChan),p_input),p.nExc,p.nChan);
p.expCond = adjustcellsize(adjustParam('expCond',cell(p.nExc,p.nChan),...
    p_input),p.nExc,p.nChan);
[p.chanLabel,p.excWl,p.chanExc,p.FRETpairs,p.Spairs,p.expCond,p.plotClr,...
    p.impTrajPrm,p.expCond] = trunc2minsize(p.chanLabel,p.excWl,p.chanExc,...
    p.FRETpairs,p.Spairs,p.expCond,p.plotClr,p.impTrajPrm,p.expCond);

% channel labels/emitter names
for nChan = 1:size(p.chanLabel,2)
    for nExc = 1:size(p.chanLabel,1)
        if numel(p.chanLabel{nExc,nChan})~=nChan
            p.chanLabel{nExc,nChan} = ...
                split(sprintf(repmat('chan%i ',[1,nChan]),1:nChan));
            p.chanLabel{nExc,nChan} = p.chanLabel{nExc,nChan}(1:nChan)';
        end
    end
end

% laser wavelength
for nChan = 1:size(p.excWl,2)
    for nExc = 1:size(p.excWl,1)
        if numel(p.excWl{nExc,nChan})~=nExc
            p.excWl{nExc,nChan} = round(532*(1+0.2*(0:nExc-1)));
        end
    end
end

% channel-specific laser wavelength
for nChan = 1:size(p.chanExc,2)
    for nExc = 1:size(p.chanExc,1)
        if ~(numel(p.chanExc{nExc,nChan})==p.nChan && ...
                nnz(p.chanExc{p.nExc,p.nChan}>0)<=p.nExc)
            p.chanExc{nExc,nChan} = zeros(1,nChan);
            p.chanExc{nExc,nChan}(1:min([nExc,nChan])) = ...
                p.excWl{nExc,nChan}(1:min([nExc,nChan]));
        end
    end
end

% FRET and stoichiometry pairs
for nChan = 1:size(p.FRETpairs,2)
    for nExc = 1:size(p.FRETpairs,1)
        if isempty(p.FRETpairs{nExc,nChan})
            continue
        end
        p.FRETpairs{nExc,nChan}(~isValidFRETpair(p.FRETpairs{nExc,nChan},...
            p.chanExc{nExc,nChan}),:) = [];
    end
end
for nChan = 1:size(p.Spairs,2)
    for nExc = 1:size(p.Spairs,1)
        if isempty(p.Spairs{nExc,nChan})
            continue
        end
        p.Spairs{nExc,nChan}(~isValidSpair(p.Spairs{nExc,nChan},...
            p.FRETpairs{nExc,nChan},p.chanExc{nExc,nChan}),:) = [];
    end
end

% experimental conditions
p.expCondDef = expCond;
for nChan = 1:size(p.expCond,2)
    for nExc = 1:size(p.expCond,1)
        p.expCond{nExc,nChan} = adjustVal(p.expCond{nExc,nChan},expCond);
    end
end

% video frame rate
p.splt = splt;

% plot colors
for nChan = 1:size(p.plotClr,2)
    for nExc = 1:size(p.plotClr,1)
        plotClr = getDefTrClr(nExc,p.excWl{nExc,nChan},nChan,...
            size(p.FRETpairs{nExc,nChan},1),size(p.Spairs{nExc,nChan},1));
        p.plotClr{nExc,nChan} = adjustVal(p.plotClr{nExc,nChan},plotClr);
    end
end

% trajectory import options
for nChan = 1:size(p.impTrajPrm,2)
    for nExc = 1:size(p.impTrajPrm,1)
        p.impTrajPrm{nExc,nChan} = ...
            adjustVal(p.impTrajPrm{nExc,nChan},getDefTrajImpPrm(nChan,nExc));
        if numel(p.impTrajPrm{nExc,nChan}{1}{2})~=nExc % ALEX time columns
            p.impTrajPrm{nExc,nChan}{1}{2} = ones(1,nExc);
        end
        if ~isequal(size(p.impTrajPrm{nExc,nChan}{1}{3}),[nChan,3]) % intensity columns
            p.impTrajPrm{nExc,nChan}{1}{4} = repmat([1,1,0],nChan,1);
        end
        if ~isequal(size(p.impTrajPrm{nExc,nChan}{1}{4}),[nChan,3,nExc]) % ALEX intensity columns
            p.impTrajPrm{nExc,nChan}{1}{4} = repmat([1,1,0],nChan,1,nExc);
        end
        if ~isequal(size(p.impTrajPrm{nExc,nChan}{1}{5}),...
                [size(p.FRETpairs{nExc,nChan},1),3]) % FRET states columns
            p.impTrajPrm{nExc,nChan}{1}{5} = ...
                repmat([1,1,0],size(p.FRETpairs{nExc,nChan},1),1);
        end
        if size(p.impTrajPrm{nExc,nChan}{3}{3}{1},1)~=nChan % coordinates file structure
            p.impTrajPrm{nExc,nChan}{3}{3}{1} = ...
                reshape(1:(2*nChan),2,nChan)';
        end
    end
end

% histogram import options
p.impHistPrm = adjustParam('impHistPrm', impHistPrm, p_input);

% molecule tags
p.tagNames = adjustParam('tagNames',tagNames,p_input);
p.tagClr = adjustParam('tagClr',tagClr,p_input);
if numel(p.tagClr)~=numel(p.tagNames)
    p.tagClr = p.tagClr(1:min([numel(p.tagClr),numel(p.tagNames)]));
    p.tagNames = p.tagNames(1:min([numel(p.tagClr),numel(p.tagNames)]));
end


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

