function dat = maketestfilepathrelative(dat)
% pth = maketestfilepathrelative(pth)
%
% Browse all elements of input data and make path to MASH-FRET code files 
% relative to MASH-FRET's main source folder.
%
% dat: data structure, cell array, string, etc.

if isempty(dat)
    return
elseif isstruct(dat)
    fldnm = fieldnames(dat);
    for n = 1:numel(fldnm)
        dat.(fldnm{n}) = maketestfilepathrelative(dat.(fldnm{n}));
    end
elseif iscell(dat)
    for r = 1:size(dat,1)
        for c = 1:size(dat,2)
            dat{r,c} = maketestfilepathrelative(dat{r,c});
        end
    end
elseif ischar(dat)
    if contains(dat,fileparts(which('MASH.m')))
        dat = dat(length([fileparts(which('MASH.m')),filesep])+1:end);
    end
end