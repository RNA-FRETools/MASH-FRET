function [str_fit,cell_cf] = getEqExp(strch, nExp)

str_fit = [];
cell_cf = {};

if strch
    % Stretched exponential decay
    str_fit = 'a*exp(-((x-x0)/b)^c)';
    cell_cf = {'a', 'b', 'c'};
    
else
    for n = 1:nExp
        % exponential decay
        if nExp > 1
%             ns = 1:nExp;
%             ns(ns==n) = [];
%             A = strcat('(1', sprintf(repmat('-a_%i',[1 (nExp-1)]), ns), ')');
            A = sprintf('a_%i', n);
        else
            A = 'a_1';
        end
        if n > 1
            str_fit = strcat(str_fit, '+');
        end
        str_fit = strcat(str_fit, A, sprintf('*exp(-(x-x0)/b_%i)', n));
        cell_cf = [cell_cf, sprintf('a_%i', n)];
        cell_cf = [cell_cf, sprintf('b_%i', n)];
    end
end

str_fit = ['P0+' str_fit];

