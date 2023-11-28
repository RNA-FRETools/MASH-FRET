function discr = get_discrFromCp(cp, trace, varargin)

nSet = size(trace,2);
discr = zeros(size(trace));
if ~isempty(varargin)
    stateVal = varargin{1};
end

for n = 1:nSet
    p = [1 cp{n} numel(trace(:,n))];
    for i = 1:(numel(p)-1)
        if exist('stateVal', 'var')
            vals = unique(stateVal{n}(p(i):(p(i+1)-1)));
            V = numel(vals);
            N = zeros(1,V);
            for v = 1:V
                N(v) = sum(stateVal{n}(p(i):(p(i+1)-1))==vals(v));
            end
            [~,j] = max(N);
            discr(p(i):p(i+1)-1,n) = vals(j);
        else
            discr(p(i):p(i+1)-1,n) = mean(trace((p(i)):p(i+1)-1,n));
        end
    end
end