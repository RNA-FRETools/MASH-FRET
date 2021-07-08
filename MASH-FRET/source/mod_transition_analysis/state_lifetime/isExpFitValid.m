function isValid = isExpFitValid(n,tau,o_tau,tol,conf,meth)
% isValid = isExpFitValid(n,tau,o_tau,tol,conf)
%
% Determine if a multi-exponential fit function is the most sufficient model to describe the data
%
% n: number of expoenential function in the model
% tau: [n-by1-] bootstrap mean of decay constants
% o_tau: [n-by-1] bootstrap deviation of decay constants
% tol: size of the +/- error range (in number of o_tau) [default=3]
% conf: maximum tolerated overlap between error ranges (relative to each full range) [default=0]
% meth: method to determine if the modle is valid or not ('conf' or 'mean')

switch meth
    case 'mean'
        % valid if the range tau +/- tol*o_tau includes no other tau
        isValid = true;
        for ni = 1:n
            njs = 1:n;
            njs(ni) = [];
            for nj = njs
                if (tau(ni)<=tau(nj) && ...
                        ((tau(ni)+tol*o_tau(ni))>=tau(nj) || ...
                        (tau(nj)-tol*o_tau(nj))<=tau(ni))) || ...
                        (tau(ni)>=tau(nj) && ...
                        ((tau(ni)-tol*o_tau(ni))<=tau(nj) || ...
                        (tau(nj)+tol*o_tau(nj))>=tau(ni)))
                    isValid = 0;
                    break
                end
            end
            if ~isValid
                break
            end
        end
        
    case 'conf'
        % valid if the relative overlap of range tau +/- tol*o_tau is less than conf
        for n1 = 1:n
            n2s = 1:n;
            n2s(n1) = [];
            overlap = 0;
            for n2 = n2s
                if tau(n1)<=tau(n2)
                    incr_overlap = ...
                        (tau(n1)+tol*o_tau(n1))-(tau(n2)-tol*o_tau(n2));
                else
                    incr_overlap = ...
                        (tau(n2)+tol*o_tau(n2))-(tau(n1)-tol*o_tau(n1));
                end
                if incr_overlap<0
                    incr_overlap = 0;
                end
                overlap = overlap+incr_overlap;
            end

            overlap = overlap/(2*tol*o_tau(n1));
            isValid = overlap<conf;

            if ~isValid
                break
            end
        end
end
