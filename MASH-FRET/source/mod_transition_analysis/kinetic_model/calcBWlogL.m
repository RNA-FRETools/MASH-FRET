function logL = calcBWlogL(alpha,beta)

logL = 0;

if iscell(alpha)
    N = numel(alpha);
else
    N = 1;
    alpha = {alpha};
    beta = {beta};
end
for n = 1:N
    logL = logL + log(sum(sum(alpha{n}.*beta{n}')));
end