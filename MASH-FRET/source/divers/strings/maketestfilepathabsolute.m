function dat = maketestfilepathabsolute(dat)
% pth = maketestfilepathabsolute(pth)
%
% Browse all elements of input data and transform paths relative to 
% MASH-FRET's main source folder to absolute paths.
%
% dat: data structure, cell array, string, etc.

if isempty(dat)
    return
elseif isstruct(dat)
    fldnm = fieldnames(dat);
    for n = 1:numel(fldnm)
        dat.(fldnm{n}) = maketestfilepathabsolute(dat.(fldnm{n}));
    end
elseif iscell(dat)
    for r = 1:size(dat,1)
        for c = 1:size(dat,2)
            dat{r,c} = maketestfilepathabsolute(dat{r,c});
        end
    end
elseif ischar(dat)
    datcv = convertrelpath(dat);
    src = fileparts(which('MASH.m')); 
    if exist([src,filesep,datcv],'dir') || ...
            exist([src,filesep,datcv],'file')
        dat = [src,filesep,datcv];
    end
end