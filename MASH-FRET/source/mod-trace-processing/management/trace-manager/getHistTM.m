function [P,iv] = getHistTM(trace,lim,niv,logbin)
% Build and return 1D or 2D histogram depending on the second dimension of
% input data

% Last update by MH, 24.4.2019
% >> isolate here the code to calculate 1D & 2D histogram to allow easier 
%    function call and avoid extensive repetitions
%
% RB 2018-01-04: adapted for FRET-S-Histogram, hist2 is rather slow
% RB 2018-01-05: hist2 replaced by hist2D
% RB 2018-01-04: adapted for FRET-S-Histogram

is1D = isscalar(niv);
nodata = isempty(trace) || any(isnan(trace(:)));

if is1D % 1D histogram
    if logbin(1)
        ivx = logspace(log10(lim(1,1)),log10(lim(1,2)),niv(1)+1);
    else
        ivx = linspace(lim(1,1),lim(1,2),niv(1)+1);
    end
    if nodata
        iv = [];
        P = [];
        return
    end
    [P,iv] = histcounts(trace,ivx);

else % 2D histogram
    if logbin(1)
        ivx = logspace(log10(lim(1,1)),log10(lim(1,2)),niv(1)+1);
    else
        ivx = linspace(lim(1,1),lim(1,2),niv(1)+1);
    end
    if logbin(2)
        ivy = logspace(log10(lim(2,1)),log10(lim(2,2)),niv(2)+1);
    else
        ivy = linspace(lim(2,1),lim(2,2),niv(2)+1);
    end
    if nodata
        iv = {[],[]};
        P = [];
        return
    end
    [P,iv{2},iv{1}] = histcounts2(trace(:,2),trace(:,1),ivy,ivx);
end
