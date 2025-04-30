function extcellarr = adjustcellsize(cellarr,nrow,ncol)
% extcellarr = adjustcellsize(cellarr,nrow,ncol)
%
% Extend dimensions 1 and 2 of input cell array with empty cells.
% If input is not a cell array, a cell array with empty cells is returned.
%
% cellarr: input cell array
% nrow: extended dimension 1
% ncol: extended dimension 2
% extcellarr: extended cell array

if ~iscell(cellarr)
    extcellarr = cell(nrow,ncol);
    return
end
if size(cellarr,1)<nrow
    cellarr = cat(1,cellarr,cell(nrow-size(cellarr,1),size(cellarr,2)));
end
if size(cellarr,2)<ncol
    cellarr = cat(2,cellarr,cell(size(cellarr,1),ncol-size(cellarr,2)));
end
extcellarr = cellarr;