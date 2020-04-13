function version_str = getMASHversion(codePath)

% default
ext = '.release_version.json';
vers0 = '(unknown version)';

mtlbDat = ver;
for i = 1:size(mtlbDat,2)
    if strcmp(mtlbDat(1,i).Name, 'MATLAB')
        break
    end
end

% get MASH-FRET version
% version_number = 'x.x.x'; % Versioning without folder structure %2018-03-07
% versioning based on latest git tag and current commit hash; FS, 27.3.2019
release_vers_file = fullfile(codePath, ext);
if exist(release_vers_file, 'file')==2
    if str2num(mtlbDat(1,i).Version)>=9.1  % use json loader introduced in Matlab 2016b
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
    version_str = vers0;
end

if str2double(mtlbDat(1,i).Version) < 7.12
    disp(['WARNING: The MATLAB version installed on this computer (' ...
        mtlbDat(1,i).Version ') is older than the one used to develop ',...
        'MASH-FRET (7.12). Be aware that compatibility problems can ',...
        'occur.']);
end
