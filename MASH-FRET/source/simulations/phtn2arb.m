function dat = phtn2arb(varargin)

dat = varargin{1};

if size(varargin,2)==3
    K = varargin{2};
    eta = varargin{3};
elseif size(varargin,2)==2
    eta = varargin{2};
    K = 57.7;
else
    eta = 0.95;
    K = 57.7;
end

offset = 0; % offset implemented in camera noise model. Do not change!


dat = offset + dat*eta*K; % offset implemented in camera noise model. Do not change!


