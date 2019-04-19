function varargout = MASH(varargin)
% Last Modified by GUIDE v2.5 26-Mar-2019 20:44:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MASH_OpeningFcn, ...
                   'gui_OutputFcn',  @MASH_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end % End initialization code - DO NOT EDIT


function MASH_OpeningFcn(obj, evd, h, varargin)

% define figure name from folder name
[pname,o,o] = fileparts(which('MASH'));
issep = true;
while issep
    possep = strfind(pname,filesep);
    if isempty(possep)
        break;
    else
        pname = pname(possep+1:end);
    end
end
%figName = strrep(pname,'_',' '); % Versioning with folder structure 2018-03-07

% Add source folders to Matlab search path
codePath = fileparts(mfilename('fullpath'));
addpath(genpath(codePath));

mtlbDat = ver;
% check for proper Matlab version
for i = 1:size(mtlbDat,2)
    if strcmp(mtlbDat(1,i).Name, 'MATLAB')
        break;
    end
end

%----------------
% version number
% version_number = 'x.x.x'; % Versioning without folder structure %2018-03-07

% versioning based on latest git tag and current commit hash; FS, 27.3.2019
release_version_file = fullfile(codePath, '.release_version.json');
if exist(release_version_file, 'file') == 2
    if str2num(mtlbDat(1,i).Version) >= 9.1  % use json loader introduced in Matlab 2016b
        git_tag_commit_hash = jsondecode(fileread(release_version_file));
    else
        % parse json file with regex
        git_tag_commit_hash = regexp(regexprep(fileread(release_version_file), '\n+', ' '), '{(?:.|\n)*\"\<tag\>\"\s*\:\s*\"(?<tag>\d+\.\d+\.\d+)\"(?:.|\n)*\"\<prev_commit_hash\>\"\s*\:\s*\"(?<prev_commit_hash>\w*)\"(?:.|\n)*}', 'names');
    end
    version_str = sprintf('%s (prev. commit: %s)', git_tag_commit_hash.tag, git_tag_commit_hash.prev_commit_hash);
else
    version_str = '(unknown version)';
end
%----------------

figName = sprintf('%s %s','MASH-FRET', version_str);

if str2num(mtlbDat(1,i).Version) < 7.12
    updateActPan(['WARNING: The Matlab version installed on this ' ...
        'computer (' mtlbDat(1,i).Version ') is older than the one ' ...
        'used to write ' figName ', i.e. 7.12.\nBe aware that '...
        'compatibility problems can occur.'], obj, 'error');
end


% initialise MASH
initMASH(obj, h, figName);


function varargout = MASH_OutputFcn(obj, evd, h)
varargout{1} = [];


function figure_MASH_CloseRequestFcn(obj, evd, h)
if isfield(h, 'figure_actPan') && ishandle(h.figure_actPan)
    h_pan = guidata(h.figure_actPan);
    success = saveActPan(get(h_pan.text_actions, 'String'), h.figure_MASH);
    if ~success
        return
    end
    delete(h.figure_actPan);
end
if isfield(h, 'wait') && isfield(h.wait, 'figWait') && ...
        ishandle(h.wait.figWait)
    delete(h.wait.figWait);
end
if isfield(h, 'figure_trsfOpt') && ishandle(h.figure_trsfOpt)
    delete(h.figure_trsfOpt);
end
if isfield(h, 'figure_itgOpt') && ishandle(h.figure_itgOpt)
    delete(h.figure_itgOpt);
end
if isfield(h, 'figure_itgExpOpt') && ishandle(h.figure_itgExpOpt)
    delete(h.figure_itgExpOpt);
end
if isfield(h, 'figure_optBg') && ishandle(h.figure_optBg)
    delete(h.figure_optBg)
end

param = h.param;
if ~isempty(param.ttPr.proj)
    % remove background intensities
    for c = 1:size(param.ttPr.defProjPrm.mol{3}{3},2)
        for l = 1:size(param.ttPr.defProjPrm.mol{3}{3},1)
            param.ttPr.defProjPrm.mol{3}{3}{l,c}(3) = 0;
        end
    end

    % remove discretisation results
    param.ttPr.defProjPrm.mol{3}{4} = [];
end
[mfile_path,o,o] = fileparts(mfilename('fullpath'));
save([mfile_path filesep 'default_param.ini'], '-struct', 'param');

delete(obj);



%% CreateFcns %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function menu_routine_CreateFcn(obj, evd, h)

h_fig = get(obj,'Parent');

uimenu(obj,'Label','routine 01','Callback', ...
    {@ttPr_routine,1,h_fig});
uimenu(obj,'Label','routine 02','Callback', ...
    {@ttPr_routine,2,h_fig});
uimenu(obj,'Label','routine 03','Callback', ...
    {@ttPr_routine,3,h_fig});
uimenu(obj,'Label','routine 04','Callback', ...
    {@ttPr_routine,4,h_fig});

