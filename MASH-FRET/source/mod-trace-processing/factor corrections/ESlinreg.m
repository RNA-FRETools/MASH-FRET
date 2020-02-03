function [gamma,beta,ok] = ESlinreg(ES,prm)

% default
mincount = 0;
fact = 5; % weighing factor

ok = true;

eiv = linspace(prm(2),prm(3),prm(4));
ebincenter = mean([eiv(1:end-1);eiv(2:end)],1);
siv = linspace(prm(5),prm(6),prm(7));
sbincenter = mean([siv(1:end-1);siv(2:end)],1);

[E,S] = meshgrid(ebincenter,sbincenter);

E = E(:);
S = S(:);
w = ES(:);

E(w<=mincount) = [];
S(w<=mincount) = [];
w(w<=mincount) = [];

try
    mdl = fitlm(E,S,'weights',(w/sum(w)).^fact);
catch err
    ok = false;
    return
end

OME = mdl.Coefficients.Estimate(1,1);
SIG =  mdl.Coefficients.Estimate(2,1);

gamma = (OME-1)/(OME+SIG-1);
beta = OME+SIG-1;

