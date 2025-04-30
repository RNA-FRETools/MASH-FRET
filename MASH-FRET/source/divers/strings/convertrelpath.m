function pth = convertrelpath(pth)
% pth = convertrelpath(pth)
%
% Convert relative directory or file path into machine-dependant format.
%
% pth: relative path to directory or file

% replace file separators by machine-specific ones
pth = strrep(pth,'/',filesep);
pth = strrep(pth,'\',filesep);

% remove openning file separator
if length(pth)>=2 && strcmp(pth(1:2),['.',filesep])
    pth = pth(3:end);
elseif length(pth)>=1 && pth(1)==filesep
    pth = pth(2:end);
end