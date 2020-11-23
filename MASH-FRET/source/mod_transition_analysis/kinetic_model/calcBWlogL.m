function logL = calcBWlogL(varargin)

logL = 0;

if nargin==1
    cl = varargin{1};
    if ~iscell(cl)
        cl = {cl};
    end
    N = numel(cl);
    for n = 1:N
        logL = logL + sum(log(cl{n}));
    end
elseif nargin==2
    alpha = varargin{1};
    beta = varargin{2};
    if ~iscell(alpha)
        alpha = {alpha};
    end
    if ~iscell(beta)
        beta = {beta};
    end
    N = numel(alpha);
    for n = 1:N
        logL = logL + log(sum(sum(alpha{n}.*beta{n}')));
    end
end
