function str_fit = getEqGauss(K)
% K no. of component
%
% Ex: K=2
% A_1*exp(-((x-mu_1).^2)/(2*(o_1^2))) + A_2*exp(-((x-mu_2).^2)/(2*(o_2^2)))

str_fit = '';
for k = 1:K
    if k>1
        str_fit = [str_fit ' + '];
    end
    str_fit = [str_fit ...
        sprintf('A_%i*exp(-((x-mu_%i).^2)/(2*(o_%i^2)))', k, k, k)];
end

