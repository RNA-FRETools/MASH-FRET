function xy = ellipsis(x,y,mu,rad,theta)

sqc = cos(theta)^2; % square cosine
sqs = sin(theta)^2; % square sine
sqox = 1/(rad(1)^2); % square x-radius
sqoy = 1/(rad(2)^2); % square y-radius

if ~isempty(x)
    % solve 2nd degree ellipsis equation for predefine x-data
    X = x-mu(1);
    Ax = (sqs*sqox+sqc*sqoy);
    Bx = 2*X*sqrt(sqc*sqs)*(sqox-sqoy);
    Cx = (sqc*sqox+sqs*sqoy)*(X.^2)-1;
    Dx = (Bx.^2)-4*Ax*Cx;

    inclx = Dx>=0;

    y_inf = (-Bx-sqrt(Dx))/(2*Ax)+mu(2);
    y_sup = flip((-Bx+sqrt(Dx))/(2*Ax)+mu(2),2);
    x_incr = x;
    x_decr = flip(x_incr,2);
    inclx = [inclx,flip(inclx,2)];
    xy_x = [[x_incr';x_decr'],[y_inf';y_sup']];
    xy_x = real(xy_x);
    xy_x(~inclx,:) = NaN;
else
    xy_x = [];
end
if ~isempty(y)
    % solve 2nd degree ellipsis equation for predefine y-data
    Y = y-mu(2);
    Ay = (sqc*sqox+sqs*sqoy);
    By = 2*Y*sqrt(sqc*sqs)*(sqox-sqoy);
    Cy = (sqs*sqox+sqc*sqoy)*(Y.^2)-1;
    Dy = (By.^2)-4*Ay*Cy;

    incly = Dy>=0;

    x_inf = (-By-sqrt(Dy))/(2*Ay)+mu(1);
    x_sup = flip((-By+sqrt(Dy))/(2*Ay)+mu(1),2);
    y_incr = y;
    y_decr = flip(y_incr,2);
    incly = [incly,flip(incly,2)];
    xy_y = [[x_inf';x_sup'],[y_incr';y_decr']];
    xy_y = real(xy_y);
    xy_y(~incly,:) = NaN;
else
    xy_y = [];
end

% merge calculated data sets
if isempty(x)
    N = size(xy_y,1);
    xy = [xy_y(1:(N/2),1),flip(xy_y((N/2+1):end,1),1)];
elseif isempty(y)
    N = size(xy_x,1);
    xy = [xy_x(1:(N/2),2),flip(xy_x((N/2+1):end,2),1)];
else
    xy = {xy_x,xy_y};
end


