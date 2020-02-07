function h_fig = MASH(varargin)

% add source folders to Matlab search path
codePath = fileparts(mfilename('fullpath'));
addpath(genpath(codePath));

% get MATLAB version
mtlbDat = ver;
for i = 1:size(mtlbDat,2)
    if strcmp(mtlbDat(1,i).Name, 'MATLAB')
        break
    end
end

% get MASH-FRET version
% version_number = 'x.x.x'; % Versioning without folder structure %2018-03-07
% versioning based on latest git tag and current commit hash; FS, 27.3.2019
release_vers_file = fullfile(codePath, '.release_version.json');
if exist(release_vers_file, 'file') == 2
    if str2num(mtlbDat(1,i).Version) >= 9.1  % use json loader introduced in Matlab 2016b
        git_tag_commit_hash = jsondecode(fileread(release_vers_file));
    else
        % parse json file with regex
        git_tag_commit_hash = regexp(regexprep(fileread(release_vers_file),...
            '\n+', ' '), cat(2,'{(?:.|\n)*\"\<tag\>\"\s*\:\s*\"(?<tag>\d+',...
            '\.\d+\.\d+)\"(?:.|\n)*\"\<prev_commit_hash\>\"\s*\:\s*\"(?',...
            '<prev_commit_hash>\w*)\"(?:.|\n)*}'), 'names');
    end
    version_str = sprintf('%s (prev. commit: %s)', git_tag_commit_hash.tag,...
        git_tag_commit_hash.prev_commit_hash);
else
    version_str = '(unknown version)';
end

% define figure name from MASH-FRET version
figName = sprintf('%s %s','MASH-FRET', version_str);
if str2num(mtlbDat(1,i).Version) < 7.12
    disp(['WARNING: The Matlab version installed on this computer (' ...
        mtlbDat(1,i).Version ') is older than the one used to write ' ...
        figName ', i.e. 7.12. Be aware that compatibility problems can ',...
        'occur.']);
end

% build MASH-FRET graphical interface
h_fig = buildMASHfig;

% add action muting option
h.mute_actions = false;

% initialize main figure
initMASH(h_fig, figName);

% make main figure visible
set(h_fig,'visible','on');

