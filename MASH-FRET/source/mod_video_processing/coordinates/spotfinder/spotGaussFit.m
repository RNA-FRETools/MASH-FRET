function [res,intrupt] = spotGaussFit(spots, I, spotSize, lb, h_fig)
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

% Last update: 14th of March 2019 by Mélodie Hadzic
% >> Review Gaussian assymetry calculation

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
        
        P_0 = 0; % z-offset
        I_0 = I(ceil(spots(i,2)), ceil(spots(i,1))); % amplitude
        theta_0 = 0; % orientation angle
        sig_x = spotSize(1)/2; % x standrd deviation
        sig_y = spotSize(2)/2; % y standard deviation
        x_0 = spots(i,1); % x position
        y_0 = spots(i,2); % y position
        
        [cc,o,o,o] = nlinfit(x,q,fun,[P_0 I_0 theta_0 sig_x sig_y x_0 y_0]);
        
        P_0 = cc(1);
        I_0 = cc(2);
        theta_0 = cc(3);
        sig_x = abs(cc(4));
        sig_y = abs(cc(5));
        x_0 = cc(6);
        y_0 = cc(7);
        
        res(i,1) = x_0; % x-Position
        res(i,2) = y_0; % y-Position
%         res(i,3) = cc(2)*2*pi*cc(4)*cc(5); % Integral
        res(i,3) = sum(q)-P_0*numel(q); % Integral
        if sig_x>sig_y
            res(i,4) = sig_x/sig_y; % ratio of standard deviations
        else
            res(i,4) = sig_y/sig_x; % ratio of standard deviations
        end
        res(i,5) = sig_x; % x sigma
        res(i,6) = sig_y; % y sigma
        res(i,7) = theta_0; % orientation angle
        res(i,8) = P_0; % z offset

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

