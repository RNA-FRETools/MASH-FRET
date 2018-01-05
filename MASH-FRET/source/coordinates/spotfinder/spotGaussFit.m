function [res intrupt] = spotGaussFit(spots, I, spotSize, lb, h_fig)
% Fit the intensity profile of the input spots with a 2D-Gaussian and
% return fitting results (x and y coordinates, intensity, spot width and 
% height, assymetry)
% "spots" >> [n-by-2] matrix, contains the raw spots coordinates
% "I" >> raw image
% "spotSize" >> area to fit around each spot
% "h_fig" >> figure_MASH handle
% "res" >> {1-by-n} cell array, contains selected spots parameters
% for each of the n channel.
% "intrupt" >> boolean saying if the loading bar was interrupted or not
%
% P = P_0 + I_0*exp(-(a*((x-x_0).^2) + 2*b*(x-x_0)*(y-y_0) + c*((y-y_0).^2)))
%
% with: a = (cos(theta)^2)/(2*o_x^2) + (sin(theta)^2)/(2*o_y^2)
%       b = -sin(2*theta)/(4*o_x^2) + sin(2*theta)/(4*o_y^2)
%       c = (sin(theta)^2)/(2*o_x^2) + (cos(theta)^2)/(2*o_y^2)

% Requires external functions: integrate2dgauss, loading_bar 
% Last update: 5th of February 2014 by M.C.A.S.H.

res = [];
    
h = guidata(h_fig);

intrupt = 0;
n_spots = size(spots,1);
hw_x = (spotSize(1)-1)/2;
hw_y = (spotSize(2)-1)/2;
res_x = h.movie.pixelX;
res_y = h.movie.pixelY;

for i = 1:n_spots
    if spots(i,1) - hw_x > 0 && spots(i,1) + hw_x < res_x && ...
            spots(i,2) - hw_y > 0 && spots(i,2) + hw_y < res_y

        p = (spots(i,2) - hw_y):(spots(i,2) + hw_y);
        r = (spots(i,1) - hw_x):(spots(i,1) + hw_x);
        Q = I(ceil(p),ceil(r));

        [X,Y] = meshgrid(r,p);
        x(:,1) = X(:); 
        x(:,2) = Y(:);
        q = Q(:);

        fun = @(a,x) a(1) + a(2)*exp(-((((cos(a(3)))^2)/(2*(a(4)^2))+ ...
            ((sin(a(3)))^2)/(2*(a(5)^2)))*((x(:,1)-a(6)).^2)+2*(-sin(2*a(3))/ ...
            (4*(a(4)^2))+sin(2*a(3))/(4*(a(5)^2)))*(x(:,1)-a(6)).*(x(:,2)-a(7))+(( ...
            (sin(a(3)))^2)/(2*(a(4)^2))+((cos(a(3)))^2)/(2*(a(5)^2)))*( ...
            (x(:,2)-a(7)).^2)));
        
        P_0 = 0;
        I_0 = I(ceil(spots(i,2)), ceil(spots(i,1)));
        theta_0 = 0;
        x_0 = spots(i,1);
        y_0 = spots(i,2);
        sig_x = spotSize(1)/2;
        sig_y = spotSize(2)/2;
        c0 = [P_0 I_0 theta_0 sig_x sig_y x_0 y_0];
        
        [cc,o,o,o] = nlinfit(x, q, fun, c0);
        
        res(i,1) = cc(6); % x-Position
        res(i,2) = cc(7); % y-Position
%         res(i,3) = cc(2)*2*pi*cc(4)*cc(5); % Integral
        res(i,3) = sum(q)-cc(1)*numel(q); % Integral
        res(i,4) = 1 + abs(1 - abs(cc(4)/cc(5))); % ratio of full widths
        res(i,5) = abs(cc(4)); % x sigma
        res(i,6) = abs(cc(5)); % y sigma
        res(i,7) = cc(3); % orientation angle
        res(i,8) = cc(1); % z offset

        if ~lb
            intrupt = loading_bar('update', h_fig);
            if intrupt
                return;
            end
        end

    else
        res(i,1) = 0;
        res(i,2) = 0;
        res(i,3) = 0;
        res(i,4) = 0;
        res(i,5) = 0;
        res(i,6) = 0;
        res(i,7) = 0;
        res(i,8) = 0;
    end
end

