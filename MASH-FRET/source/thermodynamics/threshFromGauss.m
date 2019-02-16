function thresh = threshFromGauss(A,mu,sig)
% find intersection points of neighbouring Gaussians (iso-probability 
% points)

K = numel(mu);
thresh = zeros(K-1,1);
for k = 1:K-1
    x1 = mu(k);   o1 = sig(k);   A1 = A(k);
    x2 = mu(k+1); o2 = sig(k+1); A2 = A(k+1);
    
    vA = 1/(o2^2)-1/(o1^2);
    vB = 2*x1/(o1^2)-2*x2/(o2^2);
    vC = ((x2/o2)^2)-((x1/o1)^2)-2*log(A2/A1);
    
    delta = (vB^2)-4*vA*vC;

    thresh(k,1) = (-vB-sqrt(delta))/(2*vA);
end

% plot results

% % number of intervals in x-axis
% n_iv = 100;
% 
% hfig = figure;
% haxes = axes(hfig,'nextplot','add');
% 
% xmin = (mu(1)-3*sig(1));
% xmax = (mu(end)+3*sig(end));
% xbin = (xmax-xmin)/n_iv;
% x = xmin:xbin:xmax;
% y = zeros(size(x));
% 
% for k= 1:K
%     yk = A(k)*exp(-((x-mu(k)).^2)/(2*(sig(k)^2)));
%     y = y + yk;
%     plot(haxes,x,yk,'-k');
% end
% plot(haxes,x,y,'-b');
% 
% for k=1:K-1
%     plot(haxes,repmat(thresh(k,1),1,2),[min(y),max(y)],'-r');
% end

