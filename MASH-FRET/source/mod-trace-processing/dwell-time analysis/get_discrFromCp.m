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
            discr(p(i):p(i+1)-1,n) = stateVal{n}(p(i));
        else
            discr(p(i):p(i+1)-1,n) = mean(trace((p(i)):p(i+1)-1,n));
        end
    end
end