function varargout = trunc2minsize(varargin)
D = 0;
for n = 1:nargin
    D = max([D,ndims(varargin{n})]);
end
minsz = Inf(1,D);
for n = 1:nargin
    for d = 1:D
        minsz(d) = min([minsz(d),size(varargin{n},d)]);
    end
end
for n = 1:nargin
    for d = 1:D
        str = repmat(',:',1,(D-d));
        eval(['varargin{n} = varargin{n}(',repmat(':,',1,(d-1)),...
            '1:minsz(d)',str,');']);
    end
end
varargout = varargin;