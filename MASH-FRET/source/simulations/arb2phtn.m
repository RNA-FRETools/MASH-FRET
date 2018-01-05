function dat = arb2phtn(varargin)

dat = varargin{1};

if size(varargin,2)==3
    K = varargin{2};
    eta = varargin{3};
else
    eta = 0.95;
    K = 57.7;
end

offset = 0;

dat = (dat - offset)/(K*eta);

