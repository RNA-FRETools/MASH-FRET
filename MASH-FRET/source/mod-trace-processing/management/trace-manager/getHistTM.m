function [P,iv] = getHistTM(trace,lim,niv)
% Build and return 1D or 2D histogram depending on the second dimension of
% input data

% Last update by MH, 24.4.2019
% >> isolate here the code to calculate 1D & 2D histogram to allow easier 
%    function call and avoid extensive repetitions
%
% RB 2018-01-04: adapted for FRET-S-Histogram, hist2 is rather slow
% RB 2018-01-05: hist2 replaced by hist2D
% RB 2018-01-04: adapted for FRET-S-Histogram

if sum(sum(isnan(trace),2),1)
    P = [];
    iv = [];
    return;
end

if size(trace,2)==1 % 1D histogram
    bin = (lim(2)-lim(1))/niv;
    iv = (lim(1)-bin):bin:(lim(2)+bin);
    [P,iv] = hist(trace,iv); % RB: HISTOGRAM replaces hist since 2015! 

else % 2D histogram
    if sum(sum(isnan(trace)))
        P = [];
        iv = [];
        return
    end
    prm = [lim(1,:),niv(1);lim(2,:),niv(2)];
    [P,iv{1},iv{2}] = hist2D(trace,prm); % RB: hist2D by tudima at zahoo dot com, inlcuded in \traces\processing\management
end
