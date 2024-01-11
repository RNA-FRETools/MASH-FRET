function cvg = isdphvalid(tp)
% cvg = isdphvalid(tp)
%
% Checks whether the transition probability matrix is divergent, meaning 
% in which diagonal probabilities are judged insufficient to be resolved.
%
% tp: [D-by-(D or D+1)] transition probability matrix
% cvg: 0 if model is divergent, 1 ortherwise.

% default
% pmin = 1+log(2/3); % (pmin=0.5945) at least 67% of dwelltimes are >1
pmin = 1+log(1/2); % (pmin=0.3069) at least 50% of dwelltimes are >1

cvg = false;
if isempty(tp) || any(tp(~~eye(size(tp)))<pmin)
    return
end

cvg = true;