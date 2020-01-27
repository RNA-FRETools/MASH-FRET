function xy = ellipsis(mu,rad,varargin)

% default
nsteps = 100; % number of x data points

% orientation angle
if ~isempty(varargin)
    a = varargin{1};
else
    a = 0;
end

% define x and y data
xmin = mu(1)-max(rad);
xmax = mu(1)+max(rad);
ymin = mu(2)-max(rad);
ymax = mu(2)+max(rad);
x = xmin:(xmax-xmin)/(nsteps-1):xmax;
y = ymin:(ymax-ymin)/(nsteps-1):ymax;

X = x-mu(1);
Y = y-mu(2);
sqc = cos(a)^2; % square cosine
sqs = sin(a)^2; % square sine
sqox = 1/(rad(1)^2); % square x-radius
sqoy = 1/(rad(2)^2); % square y-radius

% solve 2nd degree ellipsis equation for predefine x-data
Ax = (sqs*sqox+sqc*sqoy);
Bx = 2*X*sqrt(sqc*sqs)*(sqox-sqoy);
Cx = (sqc*sqox+sqs*sqoy)*(X.^2)-1;
Dx = (Bx.^2)-4*Ax*Cx;

inclx = Dx>=0;

y_inf = (-Bx(inclx)-sqrt(Dx(inclx)))/(2*Ax)+mu(2);
y_sup = (-Bx(inclx)+sqrt(Dx(inclx)))/(2*Ax)+mu(2);
xy_x = [[x(inclx)';flip(x(inclx)',1)],[y_sup';flip(y_inf',1)]];

% solve 2nd degree ellipsis equation for predefine y-data
Ay = (sqs*sqox+sqc*sqoy);
By = 2*Y*sqrt(sqc*sqs)*(sqox-sqoy);
Cy = (sqc*sqox+sqs*sqoy)*(Y.^2)-1;
Dy = (By.^2)-4*Ay*Cy;

incly = Dy>=0;

x_inf = (-By(incly)-sqrt(Dy(incly)))/(2*Ay)+mu(1);
x_sup = (-By(incly)+sqrt(Dy(incly)))/(2*Ay)+mu(1);
xy_y = [[x_inf';flip(x_sup',1)],[y(incly)';flip(y(incly)',1)]];

% merge calculated data sets
xy = [xy_x,xy_y];


