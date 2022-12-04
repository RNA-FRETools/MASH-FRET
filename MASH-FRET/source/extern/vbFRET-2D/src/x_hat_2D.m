function x_hat = x_hat_2D(zhat,raw)
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net
    
states = unique(zhat);
T = size(raw,1);

x_hat = zeros(T,2);

for s=1:length(states)
    % set the mean (i.e. Viterbi path value) of each state based on the
    % mean value of the data points at that state.
    meanS = mean(raw(zhat == states(s),:),1);
    x_hat(zhat == states(s),:) = meanS(ones(1,sum(zhat == states(s))),:);
end