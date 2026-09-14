function [cvg,n] = isphvalid(tp,ip,PHtype)
% cvg = isphvalid(tp,ip,PHtype)
%
% Checks whether the transition probability matrix is divergent, i.e.,
% matrices in which diagonal probabilities are judged insufficient to be 
% resolved.
%
% tp: [D-by-(D or D+1)] transition probability matrix
% ip: [1-by-D] initial state probabilities
% PHtype: 1 for discrete PH, 2 for continuous PH
% cvg: 0 if model is divergent, 1 ortherwise.
% n: integer that codes for the type of invalidity
%   n=0: model is valid
%   n=1: model has too short state lifetimes
%   n=2: model has repeated eigenvalues or null coefficients
%   n=3: model yields too small contributions
%   n=4: model yields negative/complex PMF values

% default
n = 0;
cvg = false;
mincontrib = 0.01; % minimum relative contribution of component
pmin = 1+log(2/3); % (pmin=0.5945) at least 2/3 of dwelltimes are >1
% pmin = 1+log(1/2); % (pmin=0.3069) at least half of dwelltimes are >1

% exclude models with very short state lifetimes
if isempty(tp) || any(diag(tp(:,1:end-1))<pmin)
    n = 1;
    return
end

% builds generator matrix
switch PHtype
    case 1 % DPH
        Q = tp(:,1:end-1);
    case 2 % CPH
        Q = tp(:,1:end-1);
        Q(~~eye(size(Q,1))) = diag(tp(:,1:end-1))-1;
    otherwise
        disp('isphvalid: unknown distribution type.');
end

% exclude models giving repeated eigenvalues or null coefficients
[a,eigval] = calcexpweight(Q,ip,eps("double"),PHtype);
if isempty(eigval)
    n = 2;
    return
end

% exclude models giving small contributions
contrib = abs(rnd2tol(calcitg(a,eigval,PHtype),eps("double")));
if any(contrib<mincontrib)
    n = 3;
    return
end

% calculates PMF values
switch PHtype
    case 1 % DPH
        [~,prob] = calcDPHPDF(a,eigval,eps("double"));
    case 2 % CPH
        [~,prob] = calcCPHPDF(a,eigval,eps("double"));
end

% exclude models giving negative or complex PMF values
if any(prob<0 | imag(prob)~=0)
    n = 4;
    return
end

cvg = true;

